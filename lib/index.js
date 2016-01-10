"use strict";

var path = require("path");
var Promise = require("bluebird");
var _ = require("lodash");
var xml = require("xml2js");
var vile = require("@brentlintner/vile");
var log = vile.logger.create("scalastyle");

// TODO: break up this into smaller modules

var SCALASTYLE = "scalastyle";
var ALL_FILES = ".";

var relative_path = function relative_path(file) {
  return path.relative(process.cwd(), file);
};

var xml_to_json = function xml_to_json(xml_string) {
  return new Promise(function (resolve, reject) {
    if (!xml_string) return resolve();
    xml.parseString(xml_string, function (err, json) {
      if (err) log.error(err);
      resolve(json);
    });
  });
};

var set_sources = function set_sources(data, opts) {
  var sources = _.get(data, "config.sources", ALL_FILES);
  if (typeof sources == "string") {
    opts.push(sources);
  } else {
    _.each(sources, function (source) {
      opts.push(source);
    });
  }
};

var set_config_path = function set_config_path(data, opts) {
  var config = _.get(data, "config.path");
  if (config) opts.push("-c", config);
};

var scalastyle_args = function scalastyle_args(data) {
  var args = [];
  set_config_path(data, args);
  set_sources(data, args);
  return args;
};

var scalastyle = function scalastyle(data) {
  return vile.spawn(SCALASTYLE, { args: scalastyle_args(data) }).then(xml_to_json).then(function (scalastyle_result) {
    return _.get(scalastyle_result, "checkstyle.file", []);
  });
};

var issue_type = function issue_type(error) {
  return _.get(error, "$.severity") == "warning" ? vile.WARNING : vile.ERROR;
};

var start_line = function start_line(error) {
  if (_.has(error, "$.line")) {
    var line = Number(error.$.line);

    if (_.has(error, "$.column")) {
      var character = Number(_.get(error, "$.column"));
      return { line: line, character: character };
    } else {
      return { line: line };
    }
  }
};

var message = function message(error) {
  return _.get(error, "$.message");
};

var into_vile_issues = function into_vile_issues(scalastyle_files) {
  return _.flatten(_.map(scalastyle_files, function (file) {
    return _.map(file.error, function (error) {
      return vile.issue(issue_type(error), relative_path(file.$.name), message(error), start_line(error));
    });
  }));
};

var punish = function punish(plugin_data) {
  return scalastyle(plugin_data).then(into_vile_issues);
};

module.exports = {
  punish: punish
};