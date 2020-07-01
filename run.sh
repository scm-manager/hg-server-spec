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

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

echo "... starting hg-sever-spec"

declare -a OPTIONS
SCRIPTS=$(ls "$DIR/env/"*.sh)
for SCRIPT in ${SCRIPTS}; do
  BASENAME=$(basename $SCRIPT)
  OPTIONS+=("${BASENAME%.sh}")
done

ENV=""
if [ $# -ne 0 ]; then
  if [ "env" == "$1" ]; then
    echo "available test environments:"
    echo ""
    for OPTION in "${OPTIONS[@]}"; do
      echo " - ${OPTION}"
    done
    exit 0
  fi

  ENV="${1}"
fi

if [ "${ENV}" == "" ]; then
  echo ""
  echo "choose one of the test environments:"
  echo ""
  select OPTION in ${OPTIONS[@]}; do
  case "$OPTION" in
          "")  echo "Invalid input" ;;
          *)   ENV="${OPTION}"; break ;;
    esac
  done
fi

SCRIPT="$DIR/env/$ENV.sh"
if [ ! -f "$SCRIPT" ]; then
  echo "could not find test environment $ENV"
  exit 1
fi

echo ""
echo "... starting test environment ${ENV}"
$SCRIPT > /dev/null &

# remove test container on exit
trap "docker rm -f hg-server-spec > /dev/null" EXIT

# wait until test environment is started
while [[ "$(curl -s -o /dev/null -w ''%{http_code}'' http://localhost:8080/scm/api/v2)" != "200" ]]; do 
  for X in '-' '/' '|' '\'; do 
    echo -en "\b$X"; 
    sleep 0.1; 
  done;
done

echo -e "\r... scm-manager is ready, starting bats tests"
echo ""

bats "$DIR/spec/"
