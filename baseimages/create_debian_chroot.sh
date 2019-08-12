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

ARCH=${ARCH:="armhf"}

CHROOT_DIR=${CHROOT_DIR:="stretch_chroot"}

FLAVOUR=${FLAVOUR:=""}

TAG_NAME=${TAG_NAME:="cusdeb/stretch:armhf"}

set +x

#
# Internal params
#

EMULATION_BINARY=""

USE_EMULATION=true

#
# Let's get started
#

user_defined_arch_to_target_arch "${ARCH}"

if uname -a | grep -q "${TARGET_ARCH}"; then
    USE_EMULATION=false
fi

if ! is_architecture_valid; then
    fatal "the specified architecture '${ARCH}' is not supported."
    exit 1
fi

if [ -n "${FLAVOUR}" ] && [ ! -f ./flavours/"${FLAVOUR}.sh" ]; then
    fatal "there is no such flavour as '${FLAVOUR}'."
    exit 1
fi

if [ -d "${CHROOT_DIR}" ]; then
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

if [ -d debootstrap ]; then
    info "./debootstrap already exists"
else
    info "fetching debootstrap"

    get_debootstrap

    success "fetched debootstrap"
fi

info "creating Debian Stretch chroot environment"
${DEBOOTSTRAP_EXEC} --arch="${ARCH}" --foreign --variant=minbase stretch "${CHROOT_DIR}"

if ${USE_EMULATION}; then
    cp "${EMULATION_BINARY}" "${CHROOT_DIR}"/usr/bin
fi

chroot "${CHROOT_DIR}" /debootstrap/debootstrap --second-stage

chroot "${CHROOT_DIR}" apt-get clean

chroot "${CHROOT_DIR}" sh -c "rm -rf /var/lib/apt/lists/*"

success "created Debian Stretch chroot environment"

info "making some optimizations"

echo "APT::Get::Purge \"true\";" > "${CHROOT_DIR}"/etc/apt/apt.conf

echo "path-exclude=/usr/share/locale/*" > "${CHROOT_DIR}"/etc/dpkg/dpkg.cfg.d/excludes
echo "path-exclude=/usr/share/man/*"   >> "${CHROOT_DIR}"/etc/dpkg/dpkg.cfg.d/excludes

if [ -n "${FLAVOUR}" ]; then
    info "importing './flavours/${FLAVOUR}.sh'"

    # shellcheck source=flavours/nodejs.sh
    . ./flavours/"${FLAVOUR}.sh"
fi

IMAGE="$(sh -c "tar -C ${CHROOT_DIR} -c . | docker import -")"

docker tag "${IMAGE}" "${TAG_NAME}"

success "created Debian Stretch base image"
