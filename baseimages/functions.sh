#!/bin/sh

export DEBOOTSTRAP=/usr/sbin/debootstrap
export QEMU_ARM_STATIC=/usr/bin/qemu-arm-static

msg() {
    echo $1 >&2
}

fail_msg() {
    echo $1 >&2
    exit 1
}

if [ "$(id -u)" -ne 0 ]; then
    fail_msg "This script must be run as root"
fi

# Check dependencies

if [ ! -e $DEBOOTSTRAP ]; then
    msg "There is no ${DEBOOTSTRAP}."
    msg "Run apt-get install debootstrap on Debian/Ubuntu to fix it."
    exit 1
fi

if [ ! -e $QEMU_ARM_STATIC ]; then
    msg "There is no ${QEMU_ARM_STATIC}."
    msg "Run apt-get install qemu-user-static on Debian/Ubuntu to fix it."
    exit 1
fi

if [ -z `which docker` ]; then
    msg "Docker is not installed."
    msg "Run apt-get install docker.io on Debian/Ubuntu to fix it."
    exit 1
fi

