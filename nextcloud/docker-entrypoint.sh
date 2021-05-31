#!/bin/bash

set -e

PORT="${PORT:=8001}"

PM_MAX_CHILDREN=${PM_MAX_CHILDREN:=5}

PM_START_SERVERS=${PM_START_SERVERS:=2}

PM_MIN_SPARE_SERVERS=${PM_MIN_SPARE_SERVERS:=1}

PM_MAX_SPARE_SERVERS=${PM_MAX_SPARE_SERVERS:=3}

TYPE="${TYPE:=backend}"

change_ini_params() {
    change_ini_param.py --config-file /etc/php7/php-fpm.d/www.conf --section www "user" "nginx"

    change_ini_param.py --config-file /etc/php7/php-fpm.d/www.conf --section www "group" "nginx"

    change_ini_param.py --config-file /etc/php7/php-fpm.d/www.conf --section www "listen" "backend:9000"

    change_ini_param.py --config-file /etc/php7/php-fpm.d/www.conf --section www "clear_env" "no"

    change_ini_param.py --config-file /etc/php7/php-fpm.d/www.conf --section www "pm.max_children" "${PM_MAX_CHILDREN}"

    change_ini_param.py --config-file /etc/php7/php-fpm.d/www.conf --section www "pm.start_servers" "${PM_START_SERVERS}"

    change_ini_param.py --config-file /etc/php7/php-fpm.d/www.conf --section www "pm.min_spare_servers" "${PM_MIN_SPARE_SERVERS}"

    change_ini_param.py --config-file /etc/php7/php-fpm.d/www.conf --section www "pm.max_spare_servers" "${PM_MAX_SPARE_SERVERS}"

    change_ini_param.py --config-file /etc/php7/php.ini --section PHP "memory_limit" "512M"
}

case "${TYPE}" in
frontend)
    sed -i -e "s/PORT/${PORT}/" /etc/nginx/conf.d/default.conf

    /usr/sbin/nginx -g 'daemon off;'

    ;;
backend)
    change_ini_params

    if [[ ! -f /var/www/nc/config/config.php ]]; then
        touch /var/www/nc/config/CAN_INSTALL
        chown nginx:nginx -R /var/www/nc/config
        chown nginx:nginx -R /var/www/nc/data
    fi

    /usr/sbin/php-fpm7 --nodaemonize

    ;;
news_updater)
    change_ini_params

    sudo -u nginx nextcloud-news-updater /var/www/nc

    ;;
*)
    >&2 echo "Unknown ${TYPE} service type"
    exit 1
    ;;
esac

