#!/bin/bash

change_ini_param.py --config-file /etc/php7/php-fpm.d/www.conf --section www "env[PARSOID_DOMAIN]" "${PARSOID_DOMAIN}"

change_ini_param.py --config-file /etc/php7/php-fpm.d/www.conf --section www "env[PARSOID_HOST]" "${PARSOID_HOST}"

change_ini_param.py --config-file /etc/php7/php-fpm.d/www.conf --section www "listen" "/var/run/php/php7.0-fpm.sock"

change_ini_param.py --config-file /etc/php7/php-fpm.d/www.conf --section www "listen.owner" "nginx"

change_ini_param.py --config-file /etc/php7/php-fpm.d/www.conf --section www "listen.group" "nginx"

change_ini_param.py --config-file /etc/php7/php-fpm.d/www.conf --section www "user" "nginx"

change_ini_param.py --config-file /etc/php7/php-fpm.d/www.conf --section www "group" "nginx"

>&2 echo "Preparing LocalSettings.php"

sed -i -e "s/WG_SITENAME/${WG_SITENAME}/" /var/www/w/LocalSettings.php
sed -i -e "s/WG_META_NAMESPACE/${WG_META_NAMESPACE}/" /var/www/w/LocalSettings.php
sed -i -e "s/WG_PROTOCOL/${WG_PROTOCOL}/" /var/www/w/LocalSettings.php
sed -i -e "s/WG_SERVER/${WG_SERVER}/" /var/www/w/LocalSettings.php
sed -i -e "s/WG_EMERGENCY_CONTACT/${WG_EMERGENCY_CONTACT}/" /var/www/w/LocalSettings.php
sed -i -e "s/WG_PASSWORD_SENDER/${WG_PASSWORD_SENDER}/" /var/www/w/LocalSettings.php
sed -i -e "s/WG_DB_SERVER/${WG_DB_SERVER}/" /var/www/w/LocalSettings.php
sed -i -e "s/WG_DB_NAME/${WG_DB_NAME}/" /var/www/w/LocalSettings.php
sed -i -e "s/WG_DB_USER/${WG_DB_USER}/" /var/www/w/LocalSettings.php
sed -i -e "s/WG_DB_PASSWORD/${WG_DB_PASSWORD}/" /var/www/w/LocalSettings.php
sed -i -e "s/ALLOW_ACCOUNT_CREATION/${ALLOW_ACCOUNT_CREATION}/" /var/www/w/LocalSettings.php
sed -i -e "s/ALLOW_ACCOUNT_EDITING/${ALLOW_ACCOUNT_EDITING}/" /var/www/w/LocalSettings.php
sed -i -e "s/ALLOW_ANONYMOUS_READING/${ALLOW_ANONYMOUS_READING}/" /var/www/w/LocalSettings.php
sed -i -e "s/ALLOW_ANONYMOUS_EDITING/${ALLOW_ANONYMOUS_EDITING}/" /var/www/w/LocalSettings.php

>&2 echo "Waiting for MariaDB server"

host="$(echo "${WG_DB_SERVER}" | cut -d':' -f1)"

port="$(echo "${WG_DB_SERVER}" | cut -d':' -f2)"

wait-for-it.sh -h "${host}" -p "${port}" -t 90 -- >&2 echo "MariaDB server is ready"

output="$(mysqlshow --user="${WG_DB_USER}" --host="${host}" --port="${port}" --password="${WG_DB_PASSWORD}" "${WG_DB_NAME}" | grep -v Wildcard | grep -o "${WG_DB_NAME}")"
if [ "${output}" == "${WG_DB_NAME}" ]; then
    >&2 echo "Database ${WG_DB_NAME} exists"
else
    >&2 echo "Creating the ${WG_DB_NAME} database"
    mysql --user="${WG_DB_USER}" --host="${host}" --port="${port}" --password="${WG_DB_PASSWORD}" -e "CREATE DATABASE ${WG_DB_NAME};"

    mysql --user="${WG_DB_USER}" --host="${host}" --port="${port}" --password="${WG_DB_PASSWORD}" "${WG_DB_NAME}" < /var/www/w/maintenance/tables.sql
fi

>&2 echo "Executing maintenance/update.php"
cd /var/www/w || exit 1
php7 maintenance/update.php

sed -i -e "s/PORT/${PORT}/" /etc/nginx/conf.d/default.conf

supervisord -c /etc/supervisor/supervisord.conf

