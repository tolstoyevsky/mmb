#!/bin/bash

if [[ `uname -m` == armv* ]]; then
    if [ ! -f /usr/bin/phantomjs ]; then
        cd /tmp && git clone https://github.com/piksel/phantomjs-raspberrypi.git

        chmod 775 /tmp/phantomjs-raspberrypi/bin/phantomjs

        sudo ln -s /tmp/phantomjs-raspberrypi/bin/phantomjs /usr/bin/
    else
        rm -r /tmp/phantomjs-raspberrypi

        rm /usr/bin/phantomjs
    fi
fi
