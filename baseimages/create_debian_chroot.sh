#!/bin/bash

set -e

if [ "`id -u`" -ne "0" ]; then
    >&2 echo "This script must be run as root"
    exit 1
fi

. ./functions.sh

parse_options "$@"

set_traps

set -x

ARCH=${ARCH:="armhf"}

CHROOT_DIR=${CHROOT_DIR:="stretch_chroot"}

FLAVOUR=${FLAVOUR:=""}

TAG_NAME=${TAG_NAME:="cusdeb/stretch:armhf"}

set +x

#
# Let's get started
#

if ! is_architecture_valid; then
    fatal "the specified architecture '${ARCH}' is not supported."
    exit 1
fi

if [ ! -z "${FLAVOUR}" ] && [ ! -f ./flavours/"${FLAVOUR}.sh" ]; then
    fatal "there is no such flavour as '${FLAVOUR}'."
    exit 1
fi

if [ -d "${CHROOT_DIR}" ]; then
    fatal "${CHROOT_DIR} already exists. Remove it and run the script again."
    exit 1
fi

if [ -e qemu-arm-static ]; then
    info "./qemu-arm-static already exists"
else
    info "Fetching qemu-arm-static"

    get_qemu_arm_static

    success "Successfully fetched qemu-arm-static"
fi

if [ -d debootstrap ]; then
    info "./debootstrap already exists"
else
    info "Fetching debootstrap"

    get_debootstrap

    success "Successfully fetched debootstrap"
fi

info "Creating Debian Stretch chroot environment"
${DEBOOTSTRAP_EXEC} --arch="${ARCH}" --foreign --variant=minbase stretch "${CHROOT_DIR}"

cp qemu-arm-static "${CHROOT_DIR}"/usr/bin

chroot "${CHROOT_DIR}" /debootstrap/debootstrap --second-stage

chroot "${CHROOT_DIR}" apt-get clean

chroot "${CHROOT_DIR}" sh -c "rm -rf /var/lib/apt/lists/*"

success "Successfully created Debian Stretch chroot environment"

info "Make some optimizations"

echo "APT::Get::Purge \"true\";" > "${CHROOT_DIR}"/etc/apt/apt.conf

echo "path-exclude=/usr/share/locale/*" > "${CHROOT_DIR}"/etc/dpkg/dpkg.cfg.d/excludes
echo "path-exclude=/usr/share/man/*"   >> "${CHROOT_DIR}"/etc/dpkg/dpkg.cfg.d/excludes

if [ ! -z "${FLAVOUR}" ]; then
    info "importing './flavours/${FLAVOUR}.sh'"
    . ./flavours/"${FLAVOUR}.sh"
fi

IMAGE=`sh -c "tar -C ${CHROOT_DIR} -c . | docker import -"`

docker tag $IMAGE "${TAG_NAME}"

success "Successfully created Debian Stretch base image"
