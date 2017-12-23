#!/bin/sh

cd /root/deluge-${DELUGE_VERSION} && for i in patches/*; do patch -p1 < ${i}; done

