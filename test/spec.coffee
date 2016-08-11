fs = require "fs"
mimus = require "mimus"
Promise = require "bluebird"
scalastyle = mimus.require "./../lib", __dirname, []
chai = require "./helpers/sinon_chai"
util = require "./helpers/util"
vile = mimus.get scalastyle, "vile"
log = mimus.get scalastyle, "log"
xml2js = mimus.get scalastyle, "xml"
expect = chai.expect

Promise.promisifyAll fs

SCALASTYLE_CONFIG = "scalastyle_config.xml"
SCALASTYLE_REPORT = "./vile-scalastyle-report.xml"
DEFAULT_ARGS = [ "-q", "true", "--xmlOutput", SCALASTYLE_REPORT, "." ]

# TODO: write integration tests for spawn -> cli
# TODO: don't use setTimeout everywhere (for proper exception throwing)

expect_to_set_args = (done, spawn_args, plugin_data) ->
  scalastyle
    .punish plugin_data || {}
    .should.be.fulfilled.notify ->
      setTimeout ->
        vile.spawn.should.have.been
          .calledWith "scalastyle", spawn_args
          done()
  return

describe "scalastyle", ->
  afterEach mimus.reset
  after mimus.restore
  beforeEach ->
    mimus.stub log, "error"
    mimus.stub vile, "spawn"
    util.setup vile

  describe "#punish", ->
    it "converts scalastyle xml to issues", ->
      scalastyle
        .punish {}
        .should.eventually.eql util.issues

    it "handles an empty response", ->
      fs.readFileAsync.reset()
      fs.readFileAsync.returns new Promise (resolve) -> resolve ""

      scalastyle
        .punish {}
        .should.eventually.eql []

    it "sets the xml output file option on by default", (done) ->
      expect_to_set_args(
        done,
        { args: ["-q", "true", "--xmlOutput", SCALASTYLE_REPORT, "."] }
      )

    it "reads the report file", (done) ->
      scalastyle
        .punish {}
        .should.be.fulfilled.notify ->
          setTimeout ->
            fs.readFileAsync.should.have.been
              .calledWith SCALASTYLE_REPORT
            done()
      return

    it "removes the report file", (done) ->
      scalastyle
        .punish {}
        .should.be.fulfilled.notify ->
          setTimeout ->
            fs.unlinkAsync.should.have.been
              .calledWith SCALASTYLE_REPORT
            done()
      return

    describe "when there is an xml parse error", ->
      error = new Error "cli call had an error"

      beforeEach ->
        mimus.stub xml2js, "parseString"
        xml2js.parseString.callsArgWith 1, error

      afterEach ->
        xml2js.parseString.restore()

      it "logs an error and fulfills promise", (done) ->
        scalastyle
          .punish {}
          .should.be.fulfilled.notify ->
            setTimeout ->
              log.error.should.have.been.calledWith error
              done()
        return

    describe "sources to operate on", ->
      describe "when given a single path", ->
        it "sets the related option", (done) ->
          expect_to_set_args(
            done,
            { args: [ "-q", "true", "--xmlOutput", SCALASTYLE_REPORT, "a/**/*.scala" ] },
            { config: sources: "a/**/*.scala" }
          )

      describe "when given multiple paths", ->
        it "sets the related option", (done) ->
          expect_to_set_args(
            done,
            {
              args: [
                "-q", "true",
                "--xmlOutput", SCALASTYLE_REPORT,
                "a/*.scala", "b/*.scala"
              ]
            },
            { config: sources: ["a/*.scala", "b/*.scala"] }
          )

      describe "when given none", ->
        it "sets the related option to all files", (done) ->
          expect_to_set_args(
            done,
            {
              args: [
                "-q", "true",
                "--xmlOutput", SCALASTYLE_REPORT,
                "."
              ]
            }
          )

    describe "config file path", ->
      describe "when given a single path", ->
        it "sets the related option", (done) ->
          expect_to_set_args(
            done,
            {
              args: [
                "-q", "true",
                "--xmlOutput", SCALASTYLE_REPORT,
                "-c", SCALASTYLE_CONFIG,
                "."
              ]
            },
            { config: path: SCALASTYLE_CONFIG }
          )

        it "sets the related option before any sources", (done) ->
          expect_to_set_args(
            done,
            {
              args: [
                "-q", "true",
                "--xmlOutput", SCALASTYLE_REPORT,
                "-c", SCALASTYLE_CONFIG,
                "a", "b"
              ]
            },
            { config: path: SCALASTYLE_CONFIG, sources: ["a", "b"] }
          )
