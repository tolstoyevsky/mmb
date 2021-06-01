#!/bin/sh

set -e

set -x

PORT="${PORT:=11211}"

BIND="${BIND:="127.0.0.1"}"

MEM_LIMIT="${MEM_LIMIT:=64}"

CON_LIMIT="${CON_LIMIT:=1024}"

set +x

PARAMS=""

if [ ! -z "${PORT}" ]; then
    PARAMS="${PARAMS} -p ${PORT}"
fi

if [ ! -z "${BIND}" ]; then
    PARAMS="${PARAMS} -l ${BIND}"
fi

if [ ! -z "${MEM_LIMIT}" ]; then
    PARAMS="${PARAMS} -m ${MEM_LIMIT}"
fi

if [ ! -z "${CON_LIMIT}" ]; then
    PARAMS="${PARAMS} -c ${CON_LIMIT}"
fi

# shellcheck disable=SC2086
set -- memcached ${PARAMS} "$@"

exec "$@"

