#!/bin/bash
# Copyright 2018 Evgeny Golyshev. All Rights Reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

set -e

version="2.12"

if [[ ${BASH_VERSION} != 4.* ]]; then
    >&2 echo "$0 requires bash 4 or higher"
    exit 1
fi

x=0
while getopts e: OPTION
do
    case ${OPTION} in
    e)
        VARS[$x]=$OPTARG
        x=$((x + 1))
        ;;
    esac
done

ARGS=()
for var in ${VARS[@]}; do
    IFS='=' read -ra VAR_VALUE <<< ${var}
    if [[ ${#VAR_VALUE[@]} != 2 ]]; then
        >&2 echo "To assign environment variables, specify them as VAR=VALUE."
        exit 1
    fi

    ARGS+=(--env="${var}")
done

all_args="$*"

additional_args=""
if [[ "${all_args}" = *"--"* ]]; then
    additional_args="$(echo "${all_args##*--}")"
fi

docker run ${ARGS[@]} \
    --net=host \
    --privileged \
    --rm \
    -it -v $(pwd):/tmp -v /dev:/dev \
    "cusdeb/qemu:${version}-amd64" "${additional_args}"
