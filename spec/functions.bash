#!/bin/bash
#
# MIT License
#
# Copyright (c) 2020-present Cloudogu GmbH and Contributors
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.
#

function random_string() {
  cat /dev/urandom | env LC_CTYPE=C tr -dc 'a-zA-Z0-9' | fold -w ${1:-32} | head -n 1
}

function create_repository() {
  NAME="$1"
  INITIALIZE=${2:-false}

  SC=$(curl -s -X POST "http://localhost:8080/scm/api/v2/repositories?initialize=${INITIALIZE}" \
    -u "scmadmin:scmadmin" \
    -o /dev/stderr \
    -H "accept: */*" \
    -H "Content-Type: application/vnd.scmm-repository+json;v=2" \
    -d "{\"name\":\"${NAME}\",\"type\":\"hg\"}" \
    -w "%{http_code}")

  if [ $((SC)) -eq 201 ]; then
    return 0
  fi
  return $((SC))
}

function get_repository() {
  curl "http://localhost:8080/scm/api/v2/repositories/scmadmin/$1" \
    -u "scmadmin:scmadmin"
}

function list_changesets() {
  NAME="$1"
  BRANCH=${2:-default}
  curl "http://localhost:8080/scm/api/v2/repositories/scmadmin/$NAME/branches/$BRANCH/changesets/" \
    -u "scmadmin:scmadmin"
}

function get_changeset() {
  NAME="$1"
  NODE=${2:-tip}
  curl "http://localhost:8080/scm/api/v2/repositories/scmadmin/$NAME/changesets/${NODE}" \
    -u "scmadmin:scmadmin"
}

function get_changeset_diff() {
  NAME="$1"
  NODE=${2:-tip}
  curl "http://localhost:8080/scm/api/v2/repositories/scmadmin/$NAME/diff/${NODE}" \
    -u "scmadmin:scmadmin"
}

function get_content() {
  NAME="$1"
  NODE="$2"
  curl "http://localhost:8080/scm/api/v2/repositories/scmadmin/$NAME/content/${NODE}/${3}" \
    -u "scmadmin:scmadmin"
}

function get_annotations() {
  NAME="$1"
  NODE="$2"
  curl "http://localhost:8080/scm/api/v2/repositories/scmadmin/$NAME/annotate/${NODE}/${3}" \
    -u "scmadmin:scmadmin"
}

function exec_hg() {
  hg \
    --config auth.scm.prefix=http://localhost:8080/scm \
    --config auth.scm.username=scmadmin \
    --config auth.scm.password=scmadmin \
  $*
}

function workdir() {
  echo $BATS_TMPDIR/$(random_string 8)
}
