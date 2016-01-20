Promise = require "bluebird"
mimus = require "mimus"
fs = require "fs"
scalastyle_xml = require "./../fixtures/scalastyle-xml"

Promise.promisifyAll fs

setup = (vile) ->
  mimus.stub(fs, "readFileAsync").returns(
    new Promise((resolve, reject) -> resolve(scalastyle_xml))
  )

  mimus.stub(fs, "unlinkAsync").returns(
    new Promise((resolve, reject) -> resolve())
  )

  vile.spawn.returns new Promise (resolve) ->
    resolve("potential gibberish")

issues = [
  {
    path: "test.scala",
    message: "Header does not match expected text",
    title: "Header does not match expected text",
    type: "style",
    signature: "scalastyle::org.scalastyle.file.HeaderMatchesChecker",
    where: { start: { line: 1 } }
  }
  {
    path: "test.scala",
    title: "Regular expression matched 'println'",
    message: "Regular expression matched 'println'",
    type: "style",
    signature: "scalastyle::org.scalastyle.file.RegexChecker",
    where: { start: { line: 3, character: 36} }
  }
  {
    path: "test.scala",
    title: "Regular expression matched 'println'",
    message: "Regular expression matched 'println'",
    type: "style",
    signature: "scalastyle::org.scalastyle.file.RegexChecker",
    where: { start: { line: 14, character: 23} }
  }
  {
    path: "test.scala",
    title: "Public method must have explicit type",
    message: "Public method must have explicit type",
    type: "error",
    signature: "scalastyle::org.scalastyle.scalariform." +
                "PublicMethodsHaveTypeChecker",
    where: { start: { line: 2, character: 6} }
  }
  {
    path: "some/folder/test_two.scala",
    title: "Some message",
    message: "Some message",
    signature: "scalastyle::org.scalastyle.file.SomeChecker",
    type: "error",
    where: { start: undefined }
  }
]

module.exports =
  issues: issues
  setup: setup
