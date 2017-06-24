#!/bin/sh

. ./functions.sh

ALPINE_VERSION=v3.6
APK_TOOLS_VERSION=2.7.2-r0
CHROOT_DIR=alpine_chroot
MIRROR=http://mirror.yandex.ru/mirrors/alpine

if [ -z `which wget` ]; then
    msg "wget is not installed."
    msg "Run apt-get install wget on Debian/Ubuntu to fix it."
    exit 1
fi

if [ -d $CHROOT_DIR ]; then
    fail_msg "${CHROOT_DIR} already exists. Remove it and run the script again."
fi

if [ ! -d sbin ]; then
    wget ${MIRROR}/${ALPINE_VERSION}/main/armhf/apk-tools-static-${APK_TOOLS_VERSION}.apk

    tar -xzf apk-tools-static-${APK_TOOLS_VERSION}.apk

    rm apk-tools-static-${APK_TOOLS_VERSION}.apk
fi

mkdir -p $CHROOT_DIR/usr/bin
cp $QEMU_ARM_STATIC $CHROOT_DIR/usr/bin

./sbin/apk.static -X ${MIRROR}/${ALPINE_VERSION}/main -U --allow-untrusted --root ${CHROOT_DIR} --initdb add alpine-base || fail_msg "Something went wrong while creating chroot."

rm -rf ${CHROOT_DIR}/var/cache/apk/*

# Set up some devices
mknod -m 666 ${CHROOT_DIR}/dev/full c 1 7
mknod -m 666 ${CHROOT_DIR}/dev/ptmx c 5 2
mknod -m 644 ${CHROOT_DIR}/dev/random c 1 8
mknod -m 644 ${CHROOT_DIR}/dev/urandom c 1 9
mknod -m 666 ${CHROOT_DIR}/dev/zero c 1 5
mknod -m 666 ${CHROOT_DIR}/dev/tty c 5 0

# Configuring DNS
echo 'nameserver 8.8.8.8' > ${CHROOT_DIR}/etc/resolv.conf

# Set up APK mirror
mkdir -p ${CHROOT_DIR}/etc/apk
echo "${MIRROR}/${ALPINE_VERSION}/main" > ${CHROOT_DIR}/etc/apk/repositories

IMAGE=`sh -c "tar -C alpine_chroot -c . | docker import -"`

docker tag $IMAGE cusdeb/alpine${ALPINE_VERSION}_armhf

