#!/bin/bash

# Copyright 2019 Jefferson J. Hunt
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#   http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# echo to stderr instead of stdout
function echoerr() {
  echo "$@" 1>&2;
}

# print out a message IF debug flag is set
function debug() {
  if [[ "${__DEBUG}" -eq "1" ]]; then
      echo $@
  fi
}

# stop linuxcnc
function stop() {
  debug "stopping linuxcnc"
  killall linuxcnc
}

# start linuxcnc
function start() {
  debug "starting linuxcnc"
  /opt/linuxcnc/scripts/linuxcnc
}

# print help
function help() {
cat << EOF

usage: ${SOURCE} [options] command <config>

  options:

    -d|--debug   : Print addition details to help solve problems
      
  comands:

    start        : start LinuxCNC

    stop         : stop LinuxCNC

example:

  linuxcnc-entrypoint.sh -d start

docker-example:

  docker run --rm -it jeffersonjhunt/linuxcnc -d start

See README.md for more details and examples

EOF
}

# Bootstrap
SOURCE="${BASH_SOURCE[0]}"
SOURCE=$(echo ${SOURCE} | sed 's/\.\///')
while [ -h "${SOURCE}" ]; do
    DIR="$( cd -P "$( dirname "${SOURCE}" )" && pwd )"
    SOURCE="$(readlink "${SOURCE}")"
    [[ ${SOURCE} != /* ]] && SOURCE="${DIR}/${SOURCE}"
done
DIR="$( cd -P "$( dirname "${SOURCE}" )" && pwd )"

# Try and help out a clueless user
case "$1" in
  help|-h|--help) help; exit;;
  *);;
esac

if [[ $# -eq 0 ]]; then
  help; exit
fi

# Process CLI Arugments
while [[ $# -gt 0 ]]; do
    key="$1"
    case "$key" in
        # use debug
        -d|--debug)
          __DEBUG=1
        ;;
        # Commands
        start)
          shift
          start $@
          exit
        ;;
        stop)
          shift
          stop $@
          exit
        ;;
        # Interactive shell for container testing
        bash)
          shift
          bash -i
          exit
        ;;
        *)
          # wtf options
          echoerr "Unknown option '$key'"
        ;;
    esac
    # Shift after checking all the cases to get the next option
    shift
done

echoerr "no command"
help
exit 255

# fin