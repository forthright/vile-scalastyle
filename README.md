# vile-scalastyle

A [vile](http://github.com/brentlintner/vile)
plugin for [scalastyle](http://www.scalastyle.org).

## Requirements

- [nodejs](http://nodejs.org)
- [npm](http://npmjs.org)
- [scala](http://php.net)
- [scalastyle](http://www.scalastyle.org)

## Installation

Currently, you need to have `scalastyle` installed manually.

## Config

```yml
scalastyle:
  config:
    path: scalastyle_config.xml
    sources: "." || [ "app", "test" ]
```

## Architecture

This project is currently written in JavaScript. Scalastyle provides
an XML CLI output that is currently used until a more ideal
option is implemented.

- `bin` houses any shell based scripts
- `src` is es6+ syntax compiled with [babel](https://babeljs.io)
- `lib` generated js library

## Hacking

    cd vile-scalastyle
    npm install
    npm run dev
    npm test
