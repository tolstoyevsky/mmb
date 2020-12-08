#!/bin/bash

export REDIS_CONF_bind="${BIND:=127.0.0.1}"

export REDIS_CONF_dir="${REDIS_CONF_dbfilename:=/dump}"

export REDIS_CONF_port="${PORT:=16379}"

export REDIS_CONF_loglevel="${LOGLEVEL:=notice}"

mkdir -p "${REDIS_CONF_dir}"

for key_val in $(env); do
    if [[ "${key_val}" = REDIS_CONF_* ]]; then
        var=$(echo "${key_val}" | cut -d"=" -f1)
	val=${!var}
	config_option=${var#REDIS_CONF_}
	config_option=${config_option//_/-}
	>&2 echo "Changing '${config_option}' to '${val}'"
	echo "${config_option} ${val}" >> redis.conf
    fi
done

redis-server redis.conf

