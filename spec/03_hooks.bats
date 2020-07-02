#!/usr/bin/env bats
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

load functions

@test "should update last modified date" {  
  NAME=$(random_string 16)
  create_repository $NAME true

  LAST_MODIFIED=$(get_repository $NAME | jq '.["lastModified"]')

  WORKDIR=$(workdir)
  exec_hg clone http://localhost:8080/scm/repo/scmadmin/${NAME} ${WORKDIR}
  cd ${WORKDIR}
  echo a > a.txt
  hg add a.txt
  hg commit -m 'added a'
  exec_hg push

  # we wait a little bit, because the hook runs asynchronous
  sleep 0.5

  LAST_MODIFIED_AFTER_PUSH=$(get_repository $NAME | jq '.["lastModified"]')

  # ensure last modified date was updated
  [ "${LAST_MODIFIED}" != "${LAST_MODIFIED_AFTER_PUSH}" ]
}
