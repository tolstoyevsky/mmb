#!/bin/bash

export PORT=${PORT:=8007}

export MW_QSERVE_PORT=${MW_QSERVE_PORT:=14311}

export TYPE=${TYPE:=nserve}

case "${TYPE}" in
mw-qserve)
    mw-qserve -p "${MW_QSERVE_PORT}"

    ;;
postman)
    wait-for-it.sh -h 127.0.0.1 -p "${MW_QSERVE_PORT}" -t 90 -- >&2 echo "mw-qserve is ready"

    postman

    ;;
nserve)
    wait-for-it.sh -h 127.0.0.1 -p "${MW_QSERVE_PORT}" -t 90 -- >&2 echo "mw-qserve is ready"

    nserve --port="${PORT}"

    ;;
nslave)
    wait-for-it.sh -h 127.0.0.1 -p "${MW_QSERVE_PORT}" -t 90 -- >&2 echo "mw-qserve is ready"

    nslave --cachedir ~/cache/ --url=http://127.0.0.1:8898/cache

    ;;
*)
    >&2 echo "Unknown ${TYPE} service type"
    exit 1
    ;;
esac
