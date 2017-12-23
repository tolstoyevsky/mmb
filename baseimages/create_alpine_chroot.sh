#!/bin/sh

set -e

if [ "`id -u`" -ne "0" ]; then
    >&2 echo "This script must be run as root"
    exit 1
fi

. ./functions.sh

set_traps

ALPINE_VERSION=v3.7
APK_TOOLS_VERSION=2.8.1-r2
CHROOT_DIR=alpine_chroot
MIRROR=http://mirror.yandex.ru/mirrors/alpine

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
    wget ${MIRROR}/${ALPINE_VERSION}/main/armhf/apk-tools-static-${APK_TOOLS_VERSION}.apk

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

IMAGE=`sh -c "tar -C alpine_chroot -c . | docker import -"`

docker tag $IMAGE cusdeb/alpine${ALPINE_VERSION}:armhf

