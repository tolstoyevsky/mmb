#!/bin/sh

cd /root/transmission-${TRANSMISSION_VERSION} && for i in patches/*; do patch -p1 < ${i}; done

