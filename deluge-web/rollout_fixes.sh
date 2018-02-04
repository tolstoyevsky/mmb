#!/bin/sh

cd /root/deluge-${DELUGE_VERSION} && for i in `cat patches/series`; do patch -p1 < patches/${i}; done

