#!/bin/sh

host="$(echo "${MONGO_HOST}" | cut -d':' -f1)"

port="$(echo "${MONGO_HOST}" | cut -d':' -f2)"

export MONGO_URL="mongodb://${MONGO_HOST}/${MONGO_DATABASE}"
export MONGO_OPLOG_URL="mongodb://${MONGO_OPLOG_HOST}/local?replSet=rs01"

wait-for-it.sh -h "${host}" -p "${port}" -t 90 -- >&2 echo "MongoDB is ready"

n=0
until [ ${n} -ge 5 ]; do
  node main.js && break
  n=$((n+1))
  >&2 echo "retrying in 1 sec"
  sleep 1
done
