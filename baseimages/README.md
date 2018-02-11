Here are the scripts for building base images which are used for all services from the MMB project. 

## Alpine

<p align="center">
    <img src="alpine-logo.png" width="300">
</p>

To build [Alpine 3.7](https://alpinelinux.org/posts/Alpine-3.7.0-released.html) base image run `create_alpine_chroot.sh` with superuser privileges. Once the script is finished, the image `cusdeb/alpinev3.7:armhf` is created.

## Debian

<p align="center">
    <img src="debian-logo.png" width="150">
</p>

To build [Debian Stretch](https://wiki.debian.org/DebianStretch) base image run `create_debian_chroot.sh` with superuser privileges. Once the script is finished, the image `cusdeb/stretch:armhf` is created.

## Differences from other similar Docker Hub images

The images created by `create_alpine_chroot.sh` and `create_debian_chroot.sh` include `qemu-arm-static` 2.8 to simplify debugging on x86 machines. Furthermore, Debian Stretch base image:
* is forced to get rid of configuration files when removing packages;
* drops locales and man pages when installing packages.

These two things help keep images as small as possible.
