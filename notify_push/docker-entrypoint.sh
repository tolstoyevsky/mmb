#!/bin/sh

set -e

export PORT=${PORT:=7867}

export NEXTCLOUD_URL=${NEXTCLOUD_URL:=""}

if [[ -z "${NEXTCLOUD_URL}" ]]; then
    >&2 echo "NEXTCLOUD_URL must be specified";
    exit 1
fi

while true; do
    if ! $(notify_push /config/config.php); then
        >&2 echo "Failed to run. Retrying in 30 secs";
        sleep 30
    fi
done
