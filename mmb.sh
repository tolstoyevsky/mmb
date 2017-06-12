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

if [ "`id -u`" -ne "0" ]; then
    >&2 echo "This script must be run as root"
    exit 1
fi

if [ ! -r ./baseimages/functions.sh ] ; then
    >&2 echo "'./baseimages/functions.sh' required script not found"
    exit 1
fi

. ./baseimages/functions.sh

if [ $# -lt 1 ]; then
    fatal "you have to specify the service you are going to build"
    exit 1
fi

if [ -z `which docker` ]; then
    fatal "Docker is not installed"
    exit 1
fi

#
# Let's get started
#

DEFAULT_PORT="amd64"

PORT="${DEFAULT_PORT}"

SERVICE_NAME=$1

if [ ! -d ${SERVICE_NAME} ]; then
    fatal "could not find the directory ${SERVICE_NAME}"
    exit 1
fi

if [ ! -f ${SERVICE_NAME}/Dockerfile ]; then
    fatal "${SERVICE_NAME}/Dockerfile does not exist"
    exit 1
fi

if [ ! -f ${SERVICE_NAME}/docker-compose.yml ]; then
    fatal "${SERVICE_NAME}/docker-compose.yml does not exist"
    exit 1
fi

if [ ! -z $2 ]; then
    case $2 in
        amd64)
            ;;
        armhf)
            PORT=$2
            ;;
        *)
            fatal "port ${2} is not supported"
            exit 1
            ;;
    esac
fi

cd ${SERVICE_NAME}

suffix=""

if [[ "${PORT}" != "${DEFAULT_PORT}" ]]; then
    suffix="-${PORT}"

    if [ ! -f "docker-compose${suffix}.yml" ]; then
        fatal "${SERVICE_NAME} does not support the port ${PORT}"
        exit 1
    fi

    cp --preserve Dockerfile "Dockerfile${suffix}"

    sed -i -e "s/${DEFAULT_PORT}$/${PORT}/" "Dockerfile${suffix}"
fi

IMAGE_NAME=`grep "image: " "docker-compose${suffix}.yml" | awk -F': ' '{print $2}' | head -n1`

docker build --no-cache --force-rm -t "${IMAGE_NAME}" -f "Dockerfile${suffix}" .

if [ -f postinst.sh ]; then
    info "executing postinst.sh"

    sh postinst.sh
else
    info "there is no postinst.sh, so nothing to execute"
fi

success "${SERVICE_NAME} was built"
