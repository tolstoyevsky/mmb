#!/bin/bash

PORT=${PORT:=8004}

# shellcheck disable=SC2034
SECRET_KEY="$(python3 -c "import secrets, string; print(''.join(secrets.choice(string.ascii_letters + string.digits) for _ in range(64)))")"

WG_SITENAME=${WG_SITENAME:="My KB"}

WG_META_NAMESPACE=${WG_META_NAMESPACE:=My_KB}

WG_PROTOCOL=${WG_PROTOCOL:=http}

WG_SERVER=${WG_SERVER:=127.0.0.1:8004}

WG_EMERGENCY_CONTACT=${WG_EMERGENCY_CONTACT:=username@domain.com}

WG_PASSWORD_SENDER=${WG_PASSWORD_SENDER:=username@domain.com}

WG_DB_SERVER=${WG_DB_SERVER:=127.0.0.1:33061}

WG_DB_NAME=${WG_DB_NAME:=knowledge_base}

WG_DB_USER=${WG_DB_USER:=root}

WG_DB_PASSWORD=${WG_DB_PASSWORD:=cusdeb}

ALLOW_ACCOUNT_CREATION=${ALLOW_ACCOUNT_CREATION:=true}

ALLOW_ACCOUNT_EDITING=${ALLOW_ACCOUNT_EDITING:=true}

ALLOW_ANONYMOUS_READING=${ALLOW_ANONYMOUS_READING:=false}

ALLOW_ANONYMOUS_EDITING=${ALLOW_ANONYMOUS_EDITING:=true}

METRIC_COUNTER=${METRIC_COUNTER:=""}

CREDENTIALS=${CREDENTIALS:=""}

RENDER_SERVER=${RENDER_SERVER:=http://127.0.0.1:8007}

# Does variable substitution for LocalSettings.php.
# Globals:
#     None
# Arguments:
#     Variable name
# Returns:
#     None
substitute() {
    local var_name=$1

    sed -i -e "s#${var_name}#${!var_name}#" /var/www/w/LocalSettings.php
}

if [[ -f /var/www/w/namespaces.php ]]; then
    cat /var/www/w/namespaces.php >> /var/www/w/LocalSettings.php
fi

change_ini_param.py --config-file /etc/php7/php-fpm.d/www.conf --section www "listen" "/var/run/php/php7.0-fpm.sock"

change_ini_param.py --config-file /etc/php7/php-fpm.d/www.conf --section www "listen.owner" "nginx"

change_ini_param.py --config-file /etc/php7/php-fpm.d/www.conf --section www "listen.group" "nginx"

change_ini_param.py --config-file /etc/php7/php-fpm.d/www.conf --section www "user" "nginx"

change_ini_param.py --config-file /etc/php7/php-fpm.d/www.conf --section www "group" "nginx"

>&2 echo "Preparing LocalSettings.php"

substitute SECRET_KEY
substitute WG_SITENAME
substitute WG_META_NAMESPACE
substitute WG_PROTOCOL
substitute WG_SERVER
substitute WG_EMERGENCY_CONTACT
substitute WG_PASSWORD_SENDER
substitute WG_DB_SERVER
substitute WG_DB_NAME
substitute WG_DB_USER
substitute WG_DB_PASSWORD
substitute ALLOW_ACCOUNT_CREATION
substitute ALLOW_ACCOUNT_EDITING
substitute ALLOW_ANONYMOUS_READING
substitute ALLOW_ANONYMOUS_EDITING
substitute RENDER_SERVER
substitute CREDENTIALS
substitute METRIC_COUNTER

>&2 echo "Waiting for MariaDB server"

host="$(echo "${WG_DB_SERVER}" | cut -d':' -f1)"

port="$(echo "${WG_DB_SERVER}" | cut -d':' -f2)"

wait-for-it.sh -h "${host}" -p "${port}" -t 90 -- >&2 echo "MariaDB server is ready"

output="$(mysqlshow --user="${WG_DB_USER}" --host="${host}" --port="${port}" --password="${WG_DB_PASSWORD}" "${WG_DB_NAME}" | grep -v Wildcard | grep -o "${WG_DB_NAME}")"
if [[ "${output}" == "${WG_DB_NAME}" ]]; then
    >&2 echo "Database ${WG_DB_NAME} exists"
else
    >&2 echo "Creating the ${WG_DB_NAME} database"
    mysql --user="${WG_DB_USER}" --host="${host}" --port="${port}" --password="${WG_DB_PASSWORD}" -e "CREATE DATABASE ${WG_DB_NAME};"

    mysql --user="${WG_DB_USER}" --host="${host}" --port="${port}" --password="${WG_DB_PASSWORD}" "${WG_DB_NAME}" < /var/www/w/maintenance/tables.sql
    mysql --user="${WG_DB_USER}" --host="${host}" --port="${port}" --password="${WG_DB_PASSWORD}" "${WG_DB_NAME}" < /var/www/w/maintenance/tables-generated.sql
fi

>&2 echo "Executing maintenance/update.php"
cd /var/www/w || exit 1
php7 maintenance/update.php

sed -i -e "s/PORT/${PORT}/" /etc/nginx/conf.d/default.conf

>&2 echo "Fixing ownership"
chown -R nginx:nginx /var/www/w/deleted
chown -R nginx:nginx /var/www/w/images

if [[ -f /var/www/w/resources/assets/kblogo.png ]]; then
    >&2 echo "Using provided kblogo.png"
    mv /var/www/w/resources/assets/kblogo.png /var/www/w/resources/assets/wiki.png
else
    >&2 echo "Using default logo since kblogo.png has not been provided"
fi

supervisord -c /etc/supervisor/supervisord.conf

