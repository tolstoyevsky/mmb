#!/bin/sh

MYSQL_DIR=/srv/mysql

if [ -d ${MYSQL_DIR} ]; then
    rm -r ${MYSQL_DIR}
else
    >&2 echo "${MYSQL_DIR} does not exist"
fi

