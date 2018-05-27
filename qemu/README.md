# QEMU

<p align="center">
    <img src="logo/400x127.png" alt="QEMU">
</p>

QEMU (stands for Quick EMUlator) is an open source emulator that allows mimicking many different processors and loading many different operating systems.

The Dockerfile and assets related to it are intended primarily, but **not** exclusively, for building the Docker container which simplifies testing 64-bit Raspberry Pi images built by [Pieman](https://github.com/tolstoyevsky/pieman), but not limited by this.

<table>
  <tr>
    <td align="center" colspan="2"><b>QEMU</b></td>
  </tr>
  <tr>
    <td>Version</td>
    <td><a href="http://lists.nongnu.org/archive/html/qemu-devel/2018-04/msg04089.html">2.12.0</a></td>
  </tr>
  <tr>
    <td>Release date</td>
    <td>24 Apr 2018</td>
  </tr>
  <tr>
    <td>Data volume</td>
    <td><code>current directory:/tmp</code></td>
  </tr>
  <tr>
    <td valign="top">Base images</td>
    <td>
        <code>cusdeb/alpine3.7:armhf</code> (for <code>armhf</code> port)<br>
        <code>cusdeb/alpine3.7:amd64</code> (for <code>amd64</code> port)
    </td>
  </tr>
</table>

## Table of Contents

- [Prerequisites](#prerequisites)
- [Getting started](#getting-started)
- [Documentation](#documentation)
  * [CLI for the container](#cli-for-the-container)
  * [The container entrypoint script](#the-container-entrypoint-script)
- [Known issues](#known-issues)

## Prerequisites

`docker-qemu.sh`, which is described below, requires bash 4 or higher, so macOS users should upgrade their bash if they haven't done it yet.

## Getting started

First, build 64-bit custom image using Pieman or download one of the existing images from other projects (for example, you may find the 64-bit Gentoo image on [this page](https://github.com/sakaki-/gentoo-on-rpi3-64bit#gentoo-on-rpi3-64bit)). Then, get the `docker-qemu.sh` script

```
$ curl -O https://raw.githubusercontent.com/tolstoyevsky/mmb/master/qemu/docker-qemu.sh
$ chmod +x docker-qemu.sh
```

or execute all the commands below from the `qemu` directory. Finally run the image in the emulator (assume the filename of the target image is `ubuntu-bionic-arm64-for-rpi3.img`).

```
./docker-qemu.sh -e IMAGE=ubuntu-bionic-arm64-for-rpi3.img
```

That's it. However, there will be a lot of things which will happen under the hood. Here are the most important parts:
* When the container starts, the working directory is mounted as `/tmp` inside the container.
* The boot partition in the image, specified via the `IMAGE` parameter, is mounted into `/mnt`.
* `kernel8.img` and the corresponding DTB file (`bcm2710-rpi-3-b.dtb` or `bcm2837-rpi-3-b.dtb`) are copied to `/tmp`.
* The boot partitions is unmounted.
* The image, DTB and kernel filenames are passed to QEMU and it starts.

To gain more control over QEMU you can run the container in a little more challenging way. But first, get to know the boot partition offset executing the following command:

```
/sbin/fdisk -lu ubuntu-bionic-arm64-for-rpi3.img
```

From the output of the command

```
Device                            Boot  Start     End Sectors  Size Id Type
ubuntu-bionic-arm64-for-rpi3.img1        8192  204800  196609   96M  c W95 FAT32 (LBA)
ubuntu-bionic-arm64-for-rpi3.img2      206651 8388607 8181957  3.9G 83 Linux
```

it's clear that the boot partition offset is `8192`.

Then, mount the boot partition, for example, into `/mnt`.

```
sudo mount -o loop,offset=$((8192 * 512)) ubuntu-bionic-arm64-for-rpi3.img /mnt/
```

After that, copy `kernel8.img` and `bcm2837-rpi-3-b.dtb` from the boot partition to the directory which contains `docker-qemu.sh`.

Finally, execute `docker-qemu.sh` in the following way.

```
./docker-qemu.sh \
    -e ARCH=aarch64 \
    -e DTB=bcm2837-rpi-3-b.dtb \
    -e KERNEL=kernel8.img \
    -e MACHINE_TYPE=raspi3 \
    -e MEMORY=1G \
    -e SD=ubuntu-bionic-arm64-for-rpi3.img \
    -- -append \"rw earlyprintk loglevel=8 console=ttyAMA0,115200 dwc_otg.lpm_enable=0 root=/dev/mmcblk0p2\"
```

Note that the kernel command line (i.e. the part which follows right after `-appned`) should be quoted and escaped.

## Documentation

### CLI for the container

`docker-qemu.sh` provides an easy-to-use command-line interface for working with the container.

The script supports the following options.

##### `-e VAR=VALUE`

The option allows passing the environment variables (called parameters) to the container entrypoint script.

##### `--`

Everything that goes after `--` will be passed to QEMU as is.

### The container entrypoint script

`docker-entrypoint.sh` supports the following parameters some of which are translated into the corresponding QEMU options.

##### ARCH=""

The target system architecture. The parameter takes the following values: `i386`, `x86_64`, `alpha`, `aarch64`, `arm`, `cris`, `lm32`, `m68k`, `microblaze`, `microblazeel`, `mips`, `mipsel`, `mips64`, `mips64el`, `moxie`, `ppc`, `ppcemb`, `ppc64`, `sh4`, `sh4eb`, `sparc`, `sparc64`, `s390x`, `tricore`, `xtensa`, `xtensaeb`, `unicore32`.

##### DTB=""

The filename of the DTB file. The parameter is translated into the `-dtb` option.

##### IMAGE=""

The filename of the target image. If the parameter is specified, other paramters are ignored and QEMU runs and emulates Raspberry Pi 3.

##### KERNEL=""

The filename of the kernel. The parameter is translated into the `-kernel` option.

##### MACHINE_TYPE=""

The emulated machine type. The parameter is translated into the `-M` option.

##### MEMORY=""

RAM size. Optionally, a suffix of "M" or "G" can be used to signify a value in megabytes or gigabytes respectively. The parameter is translated into the `-m` option.

##### SD=""

The filename of the target image. The parameter is translated into the `-sd` option.

## Known issues

* QEMU 2.12.0 doesn't support networking when emulating Raspberry Pi 3.
* If you see the following error message trying to run one of the existing images, it probably means that the root partition is not properly aligned relatively the boot partition. In spite of the fact, the image may run on a real hardware without any problem, it may fail in the emulator. I don't know whether it's a bug or feature, but the fact is QEMU (at least, `2.12.0`) is very sensitive to the way how the partitions of the target image are aligned.
  ```
  [    5.008032] ---[ end Kernel panic - not syncing: VFS: Unable to mount root fs on unknown-block(0,0)
  ```
