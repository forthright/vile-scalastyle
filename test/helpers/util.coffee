Promise = require "bluebird"
scalastyle_xml = require "./../fixtures/scalastyle-xml"

setup = (vile) ->
  vile.spawn.returns new Promise (resolve) ->
    resolve(scalastyle_xml)

issues = [
  {
    file: "test.scala",
    msg: "Header does not match expected text",
    type: "warn",
    where: { start: { line: 1 }, end: {} },
    data: {}
  }
  {
    file: "test.scala",
    msg: "Regular expression matched 'println'",
    type: "warn",
    where: { start: { line: 3, character: 36}, end: {} },
    data: {}
  }
  {
    file: "test.scala",
    msg: "Regular expression matched 'println'",
    type: "warn",
    where: { start: { line: 14, character: 23}, end: {} },
    data: {}
  }
  {
    file: "test.scala",
    msg: "Public method must have explicit type",
    type: "error",
    where: { start: { line: 2, character: 6}, end: {} },
    data: {}
  }
  {
    file: "some/folder/test_two.scala",
    msg: "Some message",
    type: "error",
    where: { start: { }, end: {} },
    data: {}
  }
]

module.exports =
  issues: issues
  setup: setup
