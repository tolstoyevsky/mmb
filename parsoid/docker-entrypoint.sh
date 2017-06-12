#!/bin/sh

set -e

set -x

PARSOID_DOMAIN=${PARSOID_DOMAIN:="parsoid"}

MW_API_ENDPOINT=${MW_API_ENDPOINT:="http://127.0.0.1/w/api.php"}

LOGGING_LEVEL=${LOGGING_LEVEL:="info"}

DEBUG_MODE=${DEBUG_MODE:="false"}

set +x

sed -i -e "s/PORT/${PORT}/" /root/parsoid/config.yaml

sed -i -e "s/PARSOID_DOMAIN/${PARSOID_DOMAIN}/" /root/parsoid/config.yaml

sed -i -e "s#MW_API_ENDPOINT#${MW_API_ENDPOINT}#" /root/parsoid/config.yaml

sed -i -e "s/LOGGING_LEVEL/${LOGGING_LEVEL}/" /root/parsoid/config.yaml

sed -i -e "s/DEBUG_MODE/${DEBUG_MODE}/" /root/parsoid/config.yaml

cd /root/parsoid && npm start

