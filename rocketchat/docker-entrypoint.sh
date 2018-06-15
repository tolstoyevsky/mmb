#!/bin/sh

host="$(echo ${MONGO_HOST} | cut -d':' -f1)"

port="$(echo ${MONGO_HOST} | cut -d':' -f2)"

export MONGO_URL="mongodb://${MONGO_HOST}/${MONGO_DATABASE}"

wait-for-it.sh -h "${host}" -p "${port}" -t 90 -- >&2 echo "MongoDB is ready"

node main.js

