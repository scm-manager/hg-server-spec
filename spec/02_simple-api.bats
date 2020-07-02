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

@test "should list changeset" {  
  NAME=$(random_string 16)
  create_repository $NAME true
  CONTENT=$(list_changesets $NAME default)
  [[ "${CONTENT}" == *"initialize repository"* ]]
}

@test "should return single changeset" {  
  NAME=$(random_string 16)
  create_repository $NAME true
  CONTENT=$(get_changeset $NAME)
  [[ "${CONTENT}" == *"initialize repository"* ]]
}

@test "should return diff for changeset" {  
  NAME=$(random_string 16)
  create_repository $NAME true
  CONTENT=$(get_changeset_diff $NAME)
  [[ "${CONTENT}" == *"# $NAME"* ]]
}

@test "should return content" {  
  NAME=$(random_string 16)
  create_repository $NAME true
  CONTENT=$(get_content $NAME tip README.md)
  [[ "${CONTENT}" == "# $NAME" ]]
}

@test "should return annotations" {  
  NAME=$(random_string 16)
  create_repository $NAME true
  CONTENT=$(get_annotations $NAME tip README.md)
  [[ "${CONTENT}" == *"# $NAME"* ]] && [[ "${CONTENT}" == *"SCM Administrator"* ]] && [[ "${CONTENT}" == *"initialize repository"* ]]
}
