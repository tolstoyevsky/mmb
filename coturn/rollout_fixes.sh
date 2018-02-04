#!/bin/sh

# Need to mock linux/version.h. See https://github.com/coturn/coturn/issues/46.

mkdir /usr/include/linux

cat <<EOT >> /usr/include/linux/version.h
#define LINUX_VERSION_CODE 264513
#define KERNEL_VERSION(a,b,c) (((a) << 16) + ((b) << 8) + (c))
EOT

