#!/bin/sh

DELETED=/srv/mediawiki/deleted
IMAGES=/srv/mediawiki/images

if [ ! -d "${DELETED}" ]; then
    mkdir -p "${DELETED}"
    chown www-data:www-data "${DELETED}"
else
    >&2 echo "${DELETED} already exists"
fi

if [ ! -d "${IMAGES}" ]; then
    mkdir -p "${IMAGES}"
    chown www-data:www-data "${IMAGES}"
else
    >&2 echo "${IMAGES} already exists"
fi

