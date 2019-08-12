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

if [ "$(id -u)" -ne "0" ]; then
    >&2 echo "This script must be run as root"
    exit 1
fi

. ./functions.sh

parse_options "$@"

set_traps

#
# User defined params
#

set -x

ALPINE_VERSION=3.9

APK_TOOLS_VERSION=2.10.3-r1

ARCH=${ARCH:="armhf"}

CHROOT_DIR=alpine_chroot

FLAVOUR=${FLAVOUR:=""}

MIRROR=http://mirror.yandex.ru/mirrors/alpine

TAG_NAME=${TAG_NAME:="cusdeb/alpine${ALPINE_VERSION}:${ARCH}"}

set +x


#
# Internal params
#

EMULATION_BINARY=""

USE_EMULATION=true

#
# Let's get started
#

if ! is_architecture_valid; then
    fatal "the specified architecture '${ARCH}' is not supported."
    exit 1
fi

user_defined_arch_to_target_arch "${ARCH}"

if uname -a | grep -q "${TARGET_ARCH}"; then
    USE_EMULATION=false
fi

# Alpine calls the architecture in a different way. Fixing it.
if [ "${ARCH}" == "amd64" ]; then
    ARCH="x86_64"
fi

if [ -n "${FLAVOUR}" ] && [ ! -f ./flavours/"${FLAVOUR}.sh" ]; then
    fatal "there is no such flavour as '${FLAVOUR}'."
    exit 1
fi

if [ -d ${CHROOT_DIR} ]; then
    fatal "${CHROOT_DIR} already exists. Remove it and run the script again."
    exit 1
fi

if ${USE_EMULATION}; then
    choose_emulator

    if [ -z "${EMULATION_BINARY}" ]; then
        fatal "could not choose the suitable user mode emulation binary."
        exit 1
    fi

    if [ -e "${EMULATION_BINARY}" ]; then
        info "./${EMULATION_BINARY} already exists"
    else
        info "fetching ${EMULATION_BINARY}"

        get_qemu_emulation_binary

        success "fetched ${EMULATION_BINARY}"
    fi
fi

if [ ! -d sbin ]; then
    wget "${MIRROR}/v${ALPINE_VERSION}/main/${ARCH}/apk-tools-static-${APK_TOOLS_VERSION}.apk"

    tar -xzf apk-tools-static-"${APK_TOOLS_VERSION}.apk"

    rm apk-tools-static-"${APK_TOOLS_VERSION}.apk"
fi

if ${USE_EMULATION}; then
    mkdir -p "${CHROOT_DIR}"/usr/bin
    cp qemu-arm-static "${CHROOT_DIR}"/usr/bin
fi

./sbin/apk.static -X "${MIRROR}/v${ALPINE_VERSION}/main" -U --allow-untrusted --root "${CHROOT_DIR}" --initdb add alpine-base

rm -rf "${CHROOT_DIR}"/var/cache/apk/*

info "setting up some devices"
mknod -m 666 "${CHROOT_DIR}"/dev/full c 1 7
mknod -m 666 "${CHROOT_DIR}"/dev/ptmx c 5 2
mknod -m 644 "${CHROOT_DIR}"/dev/random c 1 8
mknod -m 644 "${CHROOT_DIR}"/dev/urandom c 1 9
mknod -m 666 "${CHROOT_DIR}"/dev/zero c 1 5
mknod -m 666 "${CHROOT_DIR}"/dev/tty c 5 0

info "configuring DNS"
echo 'nameserver 8.8.8.8' > "${CHROOT_DIR}"/etc/resolv.conf

info "setting up APK mirror"
mkdir -p ${CHROOT_DIR}/etc/apk
echo "${MIRROR}/v${ALPINE_VERSION}/main" > "${CHROOT_DIR}"/etc/apk/repositories

if [ -n "${FLAVOUR}" ]; then
    info "importing './flavours/${FLAVOUR}.sh'"

    # shellcheck source=flavours/nodejs.sh
    . ./flavours/"${FLAVOUR}.sh"
fi

IMAGE="$(sh -c "tar -C alpine_chroot -c . | docker import -")"

docker tag "${IMAGE}" "${TAG_NAME}"

success "created ${TAG_NAME} base image"
