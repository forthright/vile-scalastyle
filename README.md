# vile-scalastyle [![CircleCI](https://circleci.com/gh/forthright/vile-scalastyle.svg?style=svg&circle-token=004bffac81b98d18e7d2af91c9cf38987de69a0d)](https://circleci.com/gh/forthright/vile-scalastyle)

[![score-badge](https://vile.io/api/v0/projects/vile-scalastyle/badges/score?token=USryyHar5xQs7cBjNUdZ)](https://vile.io/~brentlintner/vile-scalastyle) [![security-badge](https://vile.io/api/v0/projects/vile-scalastyle/badges/security?token=USryyHar5xQs7cBjNUdZ)](https://vile.io/~/brentlintner/vile-scalastyle) [![coverage-badge](https://vile.io/api/v0/projects/vile-scalastyle/badges/coverage?token=USryyHar5xQs7cBjNUdZ)](https://vile.io/~/brentlintner/vile-scalastyle) [![dependency-badge](https://vile.io/api/v0/projects/vile-scalastyle/badges/dependency?token=USryyHar5xQs7cBjNUdZ)](https://vile.io/~/brentlintner/vile-scalastyle)

A [vile](https://vile.io) plugin for [scalastyle](http://www.scalastyle.org).

**NOTICE**

This project is not actively maintained. If you want to
help maintain the project, or if you have a better
alternative to switch to, please open an issue and ask!

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
