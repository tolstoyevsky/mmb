#!/bin/sh

. ./functions.sh

if [ -d jessie_chroot ]; then
    fail_msg "jessie_chroot already exists. Remove it and run the script again."
fi

debootstrap --arch=armhf --foreign --variant=minbase jessie jessie_chroot || fail_msg "Something went wrong during the first stage."

cp $QEMU_ARM_STATIC jessie_chroot/usr/bin

chroot jessie_chroot /debootstrap/debootstrap --second-stage || fail_msg "Something went wrong during the second stage."

chroot jessie_chroot apt-get clean

chroot jessie_chroot sh -c "rm -rf /var/lib/apt/lists/*"

IMAGE=`sh -c "tar -C jessie_chroot -c . | docker import -"`

docker tag $IMAGE cusdeb/jessie_armhf

