#!/bin/sh

DELUGE_DIR=/srv/deluge
DOWNLOADS_DIR=/srv/common/downloads
STATE_DIR=${DELUGE_DIR}/state
CONFIG=${DELUGE_DIR}/web.conf

if [ ! -d ${DELUGE_DIR} ]; then
    mkdir ${DELUGE_DIR}
    touch ${CONFIG}
else
    >&2 echo "${DELUGE_DIR} already exists"
fi

if [ ! -d ${DOWNLOADS_DIR} ]; then
    mkdir -p ${DOWNLOADS_DIR}
else
    >&2 echo "${DOWNLOADS_DIR} already exists"
fi
