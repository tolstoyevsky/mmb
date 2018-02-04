#!/bin/sh

cd /root/transmission-${TRANSMISSION_VERSION} && for i in `cat patches/series`; do patch -p1 < patches/${i}; done

