let path = require("path")
let fs = require("fs")
let Promise = require("bluebird")
let _ = require("lodash")
let xml = require("xml2js")
let vile = require("vile")
let log = vile.logger.create("scalastyle")

Promise.promisifyAll(fs)
// TODO: break up this into smaller modules

const SCALASTYLE = "scalastyle"
const SCALASTYLE_REPORT = "./vile-scalastyle-report.xml"
const ALL_FILES = "."

let relative_path = (file) =>
  path.relative(process.cwd(), file)

let xml_to_json = (xml_string) =>
  new Promise((resolve, reject) => {
    if (!xml_string) return resolve()
    xml.parseString(xml_string, (err, json) => {
      if (err) log.error(err)
      resolve(json)
    })
  })

let remove_report = () =>
  fs.unlinkAsync(SCALASTYLE_REPORT)

let read_report = () =>
  fs.readFileAsync(SCALASTYLE_REPORT)
    .then(xml_to_json)
    .then((report) => remove_report().then(() => report))

let set_sources = (data, opts) => {
  let sources = _.get(data, "config.sources", ALL_FILES)
  if (typeof sources == "string") {
    opts.push(sources)
  } else {
    _.each(sources, (source) => {
      opts.push(source)
    })
  }
}

let set_config_path = (data, opts) => {
  let config = _.get(data, "config.path")
  if (config) opts.push("-c", config)
}

let scalastyle_args = (data) => {
  let args = [
    "-q", "true",
    "--xmlOutput",
    SCALASTYLE_REPORT
  ]
  set_config_path(data, args)
  set_sources(data, args)
  return args
}

let scalastyle = (data) =>
  vile
    .spawn(SCALASTYLE, { args: scalastyle_args(data) })
    .then(read_report)
    .then((scalastyle_result) =>
      _.get(scalastyle_result, "checkstyle.file", []))

let issue_type = (error) =>
  _.get(error, "$.severity") == "warning" ? vile.STYL : vile.ERR

let start_line = (error) => {
  if (_.has(error, "$.line")) {
    let line = Number(error.$.line)

    if (_.has(error, "$.column")) {
      let character = Number(_.get(error, "$.column"))
      return { line: line, character: character }
    } else {
      return { line: line }
    }
  }
}

let message = (error) => _.get(error, "$.message")

let into_vile_issues = (scalastyle_files) =>
  _.flatten(
    _.map(scalastyle_files, (file) =>
      _.map(file.error, (error) =>
        vile.issue({
          type: issue_type(error),
          path: relative_path(_.get(file, "$.name")),
          title: message(error),
          message: message(error),
          signature: `scalastyle::${_.get(error, "$.source")}`,
          where: { start: start_line(error) }
        })
      )
    )
  )

let punish = (plugin_data) =>
  scalastyle(plugin_data)
    .then(into_vile_issues)

module.exports = {
  punish: punish
}
