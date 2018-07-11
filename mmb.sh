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

PORT=armhf

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
        armhf)
            ;;
        amd64)
            PORT=$2
            ;;
        *)
            fatal "port ${2} is not supported"
            exit 1
            ;;
    esac
fi

cd ${SERVICE_NAME}

IMAGE_NAME=`grep "image: " docker-compose.yml | awk -F': ' '{print $2}'`

case ${PORT} in
    armhf)
        NEW_IMAGE_NAME=${IMAGE_NAME/-amd64/-armhf}

        sed -i "s~cusdeb/alpine3.7:amd64~cusdeb/alpine3.7:armhf~" Dockerfile
        sed -i "s~cusdeb/stretch:amd64~cusdeb/stretch:armhf~" Dockerfile
        ;;
    amd64)
        NEW_IMAGE_NAME=${IMAGE_NAME/-armhf/-amd64}

        sed -i "s~cusdeb/alpine3.7:armhf~cusdeb/alpine3.7:amd64~" Dockerfile
        sed -i "s~cusdeb/stretch:armhf~cusdeb/stretch:amd64~" Dockerfile
        ;;
esac

docker build --no-cache --force-rm -t ${NEW_IMAGE_NAME} .

if [ -f postinst.sh ]; then
    info "executing postinst.sh"

    sh postinst.sh
else
    info "there is no postinst.sh, so nothing to execute"
fi

sed -i "s~${IMAGE_NAME}~${NEW_IMAGE_NAME}~" docker-compose.yml

success "${SERVICE_NAME} was built"
