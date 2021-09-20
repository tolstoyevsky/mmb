#!/bin/bash

set -e

PM_MAX_CHILDREN=${PM_MAX_CHILDREN:=5}

PM_START_SERVERS=${PM_START_SERVERS:=2}

PM_MIN_SPARE_SERVERS=${PM_MIN_SPARE_SERVERS:=1}

PM_MAX_SPARE_SERVERS=${PM_MAX_SPARE_SERVERS:=3}

UID="${UID:=1000}"

XDEBUG_CLIENT_PORT=${XDEBUG_CLIENT_PORT:=9003}

BACKEND_PORT=9000

change_ini_params() {
    change_ini_param.py --config-file /etc/php7/php-fpm.d/www.conf --section www "user" "nginx"

    change_ini_param.py --config-file /etc/php7/php-fpm.d/www.conf --section www "group" "nginx"

    change_ini_param.py --config-file /etc/php7/php-fpm.d/www.conf --section www "listen" "localhost:${BACKEND_PORT}"

    change_ini_param.py --config-file /etc/php7/php-fpm.d/www.conf --section www "clear_env" "no"

    change_ini_param.py --config-file /etc/php7/php-fpm.d/www.conf --section www "pm.max_children" "${PM_MAX_CHILDREN}"

    change_ini_param.py --config-file /etc/php7/php-fpm.d/www.conf --section www "pm.start_servers" "${PM_START_SERVERS}"

    change_ini_param.py --config-file /etc/php7/php-fpm.d/www.conf --section www "pm.min_spare_servers" "${PM_MIN_SPARE_SERVERS}"

    change_ini_param.py --config-file /etc/php7/php-fpm.d/www.conf --section www "pm.max_spare_servers" "${PM_MAX_SPARE_SERVERS}"

    change_ini_param.py --config-file /etc/php7/php.ini --section PHP "apc.enable_cli" "1"

    change_ini_param.py --config-file /etc/php7/php.ini --section PHP "error_reporting" "E_ALL"

    change_ini_param.py --config-file /etc/php7/php.ini --section PHP "memory_limit" "512M"

    change_ini_param.py --config-file /etc/php7/php.ini --section XDebug "xdebug.mode" "debug"

    change_ini_param.py --config-file /etc/php7/php.ini --section XDebug "xdebug.start_with_request" "yes"

    change_ini_param.py --config-file /etc/php7/php.ini --section XDebug "xdebug.client_host" "host.docker.internal"

    change_ini_param.py --config-file /etc/php7/php.ini --section XDebug "xdebug.client_port" "${XDEBUG_CLIENT_PORT}"

    change_ini_param.py --config-file /etc/php7/php.ini --section XDebug "zend_extension" "/usr/lib/php7/modules/xdebug.so"
}

usermod -u "${UID}" nginx

/usr/sbin/nginx

change_ini_params

/usr/sbin/php-fpm7 --nodaemonize

