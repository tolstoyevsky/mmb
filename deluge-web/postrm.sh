#!/bin/sh

DELUGE_DIR=/srv/deluge

if [ -d ${DELUGE_DIR} ]; then
    rm -r ${DELUGE_DIR}
else
    >&2 echo "${DELUGE_DIR} does not exist"
fi

