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

FLAVOUR=${FLAVOUR:=""}

TAG_NAME=${TAG_NAME:="cusdeb/stretch:armhf"}

set +x

#
# Let's get started
#

if [ ! -z "${FLAVOUR}" ] && [ ! -f ./flavours/"${FLAVOUR}.sh" ]; then
    fatal "there is no such flavour as '${FLAVOUR}'."
    exit 1
fi

if [ -d stretch_chroot ]; then
    fatal "stretch_chroot already exists. Remove it and run the script again."
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
${DEBOOTSTRAP_EXEC} --arch=armhf --foreign --variant=minbase stretch stretch_chroot

cp qemu-arm-static stretch_chroot/usr/bin

chroot stretch_chroot /debootstrap/debootstrap --second-stage

chroot stretch_chroot apt-get clean

chroot stretch_chroot sh -c "rm -rf /var/lib/apt/lists/*"

success "Successfully created Debian Stretch chroot environment"

info "Make some optimizations"

echo "APT::Get::Purge \"true\";" > stretch_chroot/etc/apt/apt.conf

echo "path-exclude=/usr/share/locale/*" > /etc/dpkg/dpkg.cfg.d/excludes
echo "path-exclude=/usr/share/man/*"   >> /etc/dpkg/dpkg.cfg.d/excludes

if [ ! -z "${FLAVOUR}" ]; then
    info "importing './flavours/${FLAVOUR}.sh'"
    . ./flavours/"${FLAVOUR}.sh"
fi

IMAGE=`sh -c "tar -C stretch_chroot -c . | docker import -"`

docker tag $IMAGE "${TAG_NAME}"

success "Successfully created Debian Stretch base image"
