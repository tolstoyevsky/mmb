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

set -eE

#
# Helpers
#

# Checks if the specified variable is set.
# Globals:
#     None
# Arguments:
#     Variable name
# Returns:
#     Boolean
check_if_variable_is_set() {
    var_name=$1
    if [ -z "${!var_name+x}" ]; then
        false
    else
        true
    fi
}

# Cleans up the build environment.
# Globals:
#     LOOP_DEV
# Arguments:
#     None
# Returns:
#     None
cleanup() {
    if mount | grep -q "/mnt"; then
        info "unmounting /mnt"
        umount /mnt
    fi

    if check_if_variable_is_set LOOP_DEV; then
        info "detaching the file image associated with ${LOOP_DEV}"
        losetup -d "${LOOP_DEV}"
    fi
}

# Prints the specified message with the level info.
# Globals:
#     None
# Arguments:
#     Message
# Returns:
#     None
info() {
    >&2 echo "${text_in_yellow_color}Info${reset}: ${*}"
}

# Prints the specified message with the level fatal.
# Globals:
#     None
# Arguments:
#     Message
# Returns:
#     None
fatal() {
    >&2 echo "${text_in_red_color}Fatal${reset}: ${*}"
}

# Calls the cleanup function on the following signals: SIGHUP, SIGINT, SIGQUIT
# and SIGABRT.
# Globals:
#     None
# Arguments:
#     None
# Returns:
#     None
set_traps() {
    trap cleanup 1 2 3 6 ERR
}

#
# User defined params
#

set -x

ARCH=${ARCH:=""}

DTB=${DTB:=""}

IMAGE=${IMAGE:=""}

KERNEL=${KERNEL:=""}

MACHINE_TYPE=${MACHINE_TYPE:=""}

MEMORY=${MEMORY:=""}

SD=${SD=""}

set +x

#
# Internal params
#

LOOP_DEV=""

default_cmdline="rw earlyprintk loglevel=8 console=ttyAMA0,115200 dwc_otg.lpm_enable=0 root=/dev/mmcblk0p2"

cmdline=""

qemu_args=()

qemu_bin=""

text_in_red_color=$(tput setaf 1)

text_in_yellow_color=$(tput setaf 3)

reset=$(tput sgr0)

#
# Let's get started
#

if [ ! -z ${IMAGE} ]; then
    info "trying to emulate Raspberry Pi 3 since IMAGE was specified."

    info "the ARCH value was changed to aarch64."
    ARCH="aarch64"

    info "the MACHINE_TYPE value was changed to raspi3."
    MACHINE_TYPE="raspi3"

    info "the MEMORY value was changed to 1G."
    MEMORY="1G"

    info "the SD value was changed to ${IMAGE}."
    SD="${IMAGE}"

    info "using the following command line \"${default_cmdline}\"."
    cmdline="${default_cmdline}"

    LOOP_DEV=$(losetup --partscan --show --find "/tmp/${IMAGE}")
    boot_partition="${LOOP_DEV}p1"

    # It may take a while until devices appear in /dev.
    max_retries=30
    for i in $(eval echo "{1..${max_retries}}"); do
        if [ -z "$(ls "${boot_partition}" 2> /dev/null)" ]; then
            info "there is no ${boot_partition} so far ($((max_retries - i)) attempts left)"
            sleep 1
        else
            break
        fi
    done

    mount "${boot_partition}" /mnt

    if [ ! -f /mnt/kernel8.img ]; then
        fatal "the boot partition of ${IMAGE} does not contain kernel8.img"
        exit 1
    fi

    # Take from the boot partition the kernel and the corresponding DTB file.

    cp /mnt/kernel8.img /tmp

    info "the KERNEL value was changed to kernel8.img."
    KERNEL="kernel8.img"

    dtb=""
    dtbs=($(ls /mnt/bcm*-rpi-3-b.dtb))
    if [ "${#dtbs[@]}" -gt "1" ]; then
        >&2 echo "There are more than one DTB files related to Raspberry Pi 3 in the boot partition of ${IMAGE}. Choose which one to use."
        select FILENAME in ${dtbs[@]}; do
            dtb="${FILENAME}"
            break
        done
    else
        dtb="${dtbs[0]}"
    fi

    cp ${dtb} /tmp

    info "the DTB value was changed to $(basename "${dtb}")."
    DTB="$(basename "${dtb}")"

    cleanup
fi

# Fix values which contain file names.
# All of the files specified using the parameters above are available in the
# /tmp directory.

if [ ! -z ${DTB} ]; then
    DTB="/tmp/${DTB}"
    if [ ! -f "${DTB}" ]; then
        fatal "${DTB} does not exist."
        exit 1
    fi
fi

if [ ! -z ${KERNEL} ]; then
    KERNEL="/tmp/${KERNEL}"
    if [ ! -f "${KERNEL}" ]; then
        fatal "${KERNEL} does not exist."
        exit 1
    fi
fi

if [ ! -z ${SD} ]; then
    SD="/tmp/${SD}"
    if [ ! -f "${SD}" ]; then
        fatal "${SD} does not exist."
        exit 1
    fi
fi

if [ -z "${ARCH}" ]; then
    fatal "specify the target system architecture. See the documentation to know which architectures are supported."
    exit 1
fi

case "${ARCH}" in
# x86
i386|x86_64)
    ;&
# arm
aarch64|arm)
    ;&
# mips
mips|mipsel|mips64|mips64el)
    ;&
# ppc
ppc|ppcemb|ppc64)
    ;&
# sparc
sparc|sparc64)
    ;&
# misc
alpha|cris|lm32|m68k|microblaze|microblazeel|moxie|s390x|sh4|sh4eb|tricore|unicore32|xtensa|xtensaeb)
    qemu_bin="qemu-system-${ARCH}"
    ;;
*)
    fatal "${ARCH} is not supported."
    exit 1
    ;;
esac

params=(
    "DTB -dtb"
    "KERNEL -kernel"
    "MACHINE_TYPE -M"
    "MEMORY -m"
    "SD -sd"
)

for i in "${params[@]}"; do
    var="$(echo "${i}" | cut -d" " -f1)"
    opt="$(echo "${i}" | cut -d" " -f2)"
    if [ ! -z "${!var}" ]; then
        qemu_args+=( "${opt}" "${!var}" )
    fi
done

if [ ! -z "${cmdline}" ]; then
    qemu_args+=( -append "\"${cmdline}\"" )
fi

qemu_args+=( -serial stdio )

info "passing \"${qemu_args[@]}\" to ${qemu_bin}"

# Ugly solution, otherwise bash puts redundant quotes polluting command line.
eval ${qemu_bin} "${qemu_args[@]}" $*
