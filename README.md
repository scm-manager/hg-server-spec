# hg-server-spec

This repository contains [bats](https://github.com/bats-core/bats-core) tests to test the compatibility of different [python](https://www.python.org/) and [mercurial](https://www.mercurial-scm.org/) versions with [SCM-Manager](https://scm-manager.org).

# Getting started

## Requirements

* [bash](https://www.gnu.org/software/bash/)
* [curl](https://curl.haxx.se/)
* [jq](https://stedolan.github.io/jq/)
* [bats-core](https://github.com/bats-core/bats-core)
* [docker](https://www.docker.com/)

## Prepare environment

Clone the [SCM-Manager](https://github.com/scm-manager/scm-manager).
Build SCM-Manager `mvn clean install -Ppackaging` and copy the `etc` and `opt` directory from `scm-packaging/docker/target/build` to `env`.

## Run

Just start the tests with the `run.sh` script.
