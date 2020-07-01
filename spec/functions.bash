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

set -euo pipefail
IFS=$'\n\t'

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

function get_content() {
  echo content
}
