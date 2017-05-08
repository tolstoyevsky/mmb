#!/bin/sh

QEMU_ARM_STATIC=/usr/bin/qemu-arm-static

# Check dependencies

if [ ! -e $QEMU_ARM_STATIC ]; then
    echo "There is no ${QEMU_ARM_STATIC}."
    echo "Run apt-get install qemu-user-static on Debian/Ubuntu to fix it."
    exit 1
fi

if [ -z `which docker` ]; then
    echo "Docker is not installed."
    echo "Run apt-get install docker.io on Debian/Ubuntu to fix it."
    exit 1
fi

if [ $# -lt 1 ]; then
    echo "You have to specify the Docker image you are going to build."
    exit 1
fi

if [ ! -d $1 ]; then
    echo "${1} does not exist or it's not a directory."
    exit 1
fi

if [ $1 = watchtower ]; then
    cd $1
    ./build_watchtower.sh
    exit 0
fi

CURDIR=`pwd`
cd $1
cp $QEMU_ARM_STATIC .
docker build --force-rm --no-cache -t cusdeb-$1-armhf .
cd $CURDIR

