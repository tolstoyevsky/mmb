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

ALPINE_VERSION=v3.7

APK_TOOLS_VERSION=2.9.1-r2

ARCH=${ARCH:="armhf"}

CHROOT_DIR=alpine_chroot

FLAVOUR=${FLAVOUR:=""}

MIRROR=http://mirror.yandex.ru/mirrors/alpine

TAG_NAME=${TAG_NAME:="cusdeb/alpine3.7:armhf"}

set +x

#
# Let's get started
#

if ! is_architecture_valid; then
    fatal "the specified architecture '${ARCH}' is not supported."
    exit 1
fi

# Alpine calls the architecture in a different way. Fixing it.
if [ "${ARCH}" == "amd64" ]; then
    ARCH="x86_64"
fi

if [ ! -z "${FLAVOUR}" ] && [ ! -f ./flavours/"${FLAVOUR}.sh" ]; then
    fatal "there is no such flavour as '${FLAVOUR}'."
    exit 1
fi

if [ -d ${CHROOT_DIR} ]; then
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

if [ ! -d sbin ]; then
    wget "${MIRROR}/${ALPINE_VERSION}/main/${ARCH}/apk-tools-static-${APK_TOOLS_VERSION}.apk"

    tar -xzf apk-tools-static-${APK_TOOLS_VERSION}.apk

    rm apk-tools-static-${APK_TOOLS_VERSION}.apk
fi

mkdir -p ${CHROOT_DIR}/usr/bin
cp qemu-arm-static ${CHROOT_DIR}/usr/bin

./sbin/apk.static -X ${MIRROR}/${ALPINE_VERSION}/main -U --allow-untrusted --root ${CHROOT_DIR} --initdb add alpine-base

rm -rf ${CHROOT_DIR}/var/cache/apk/*

info "Setting up some devices"
mknod -m 666 ${CHROOT_DIR}/dev/full c 1 7
mknod -m 666 ${CHROOT_DIR}/dev/ptmx c 5 2
mknod -m 644 ${CHROOT_DIR}/dev/random c 1 8
mknod -m 644 ${CHROOT_DIR}/dev/urandom c 1 9
mknod -m 666 ${CHROOT_DIR}/dev/zero c 1 5
mknod -m 666 ${CHROOT_DIR}/dev/tty c 5 0

info "Configuring DNS"
echo 'nameserver 8.8.8.8' > ${CHROOT_DIR}/etc/resolv.conf

info "Setting up APK mirror"
mkdir -p ${CHROOT_DIR}/etc/apk
echo "${MIRROR}/${ALPINE_VERSION}/main" > ${CHROOT_DIR}/etc/apk/repositories

if [ ! -z "${FLAVOUR}" ]; then
    info "importing './flavours/${FLAVOUR}.sh'"
    . ./flavours/"${FLAVOUR}.sh"
fi

IMAGE=`sh -c "tar -C alpine_chroot -c . | docker import -"`

docker tag $IMAGE "${TAG_NAME}"

