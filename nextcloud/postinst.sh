#!/bin/sh

CONFIG=/srv/nextcloud/config.php
DATA=/srv/nextcloud/data

if [ ! -d $DATA ]; then
    mkdir -p $DATA
    chown www-data:www-data $DATA
else
    echo "${DATA} already exists" >&2
fi

if [ ! -e $CONFIG ]; then
    touch $CONFIG
    chown www-data:www-data $CONFIG
else
    echo "${CONFIG} already exists" >&2
fi

