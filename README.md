# vile-scalastyle [![CircleCI](https://circleci.com/gh/forthright/vile-scalastyle.svg?style=shield&circle-token=004bffac81b98d18e7d2af91c9cf38987de69a0d)](https://circleci.com/gh/forthright/vile-scalastyle) [![score-badge](https://vile.io/api/v0/projects/vile-scalastyle/badges/score?token=USryyHar5xQs7cBjNUdZ)](https://vile.io/~brentlintner/vile-scalastyle) [![security-badge](https://vile.io/api/v0/projects/vile-scalastyle/badges/security?token=USryyHar5xQs7cBjNUdZ)](https://vile.io/~brentlintner/vile-scalastyle) [![coverage-badge](https://vile.io/api/v0/projects/vile-scalastyle/badges/coverage?token=USryyHar5xQs7cBjNUdZ)](https://vile.io/~brentlintner/vile-scalastyle) [![dependency-badge](https://vile.io/api/v0/projects/vile-scalastyle/badges/dependency?token=USryyHar5xQs7cBjNUdZ)](https://vile.io/~brentlintner/vile-scalastyle)

A [Vile](https://vile.io) plugin for identifying common style and
maintainability issues in your Scala code (via [Scalastyle](http://www.scalastyle.org)).

## Requirements

- [Node.js](http://nodejs.org)
- [Scalastyle](http://www.scalastyle.org)

## Installation

Currently, you need to have `scalastyle` installed manually.

## Config

```yaml
scalastyle:
  config:
    path: scalastyle_config.xml
    sources: "." || [ "app", "test" ]
```

## Versioning

This project uses [Semver](http://semver.org).

## Licensing

This project is licensed under the [MPL-2.0](LICENSE) license.

Any contributions made to this project are made under the current license.

## Contributions

Current list of [Contributors](https://github.com/forthright/vile-scalastyle/graphs/contributors).

Any contributions are welcome and appreciated!

All you need to do is submit a [Pull Request](https://github.com/forthright/vile-scalastyle/pulls).

1. Please consider tests and code quality before submitting.
2. Please try to keep commits clean, atomic and well explained (for others).

### Issues

Current issue tracker is on [GitHub](https://github.com/forthright/vile-scalastyle/issues).

Even if you are uncomfortable with code, an issue or question is welcome.

### Code Of Conduct

By participating in this project you agree to our [Code of Conduct](CODE_OF_CONDUCT.md).

## Architecture

This project is currently written in JavaScript. Scalastyle provides
an XML CLI output that is currently used until a more ideal
option is implemented.

- `bin` houses any shell based scripts
- `src` is es6+ syntax compiled with [Babel](https://babeljs.io)
- `lib` generated js library

## Developing

    cd vile-scalastyle
    npm install
    npm run dev
    npm test
