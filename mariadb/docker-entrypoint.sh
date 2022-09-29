#!/bin/bash

export MYSQLD_port="${MYSQLD_port:=3306}"

# Configure MariaDB only using /etc/my.cnf
rm /etc/my.cnf.d/mariadb-server.cnf

# execute any pre-init scripts
for i in /scripts/pre-init.d/*sh
do
    if [[ -e "${i}" ]]; then
        >&2 echo "[i] pre-init.d - processing $i"
	# shellcheck source=/dev/null
        . "${i}"
    fi
done

if [[ -d /run/mysqld ]]; then
    >&2 echo "[i] mysqld already present, skipping creation"
    chown -R mysql:mysql /run/mysqld
else
    >&2 echo "[i] mysqld not found, creating...."
    mkdir -p /run/mysqld
    chown -R mysql:mysql /run/mysqld
fi

if [[ -d /var/lib/mysql/mysql ]]; then
    >&2 echo "[i] MySQL directory already present, skipping creation"
    chown -R mysql:mysql /var/lib/mysql
else
    >&2 echo "[i] MySQL data directory not found, creating initial DBs"

    chown -R mysql:mysql /var/lib/mysql

    mysql_install_db --user=mysql --datadir=/var/lib/mysql

    if [[ "$MYSQL_ROOT_PASSWORD" = "" ]]; then
        MYSQL_ROOT_PASSWORD=$(pwgen 16 1)
        >&2 echo "[i] MySQL root Password: $MYSQL_ROOT_PASSWORD"
    fi

    MYSQL_DATABASE=${MYSQL_DATABASE:-""}
    MYSQL_USER=${MYSQL_USER:-""}
    MYSQL_PASSWORD=${MYSQL_PASSWORD:-""}

    tfile=$(mktemp)
    if [[ ! -f "${tfile}" ]]; then
        return 1
    fi

    cat << EOF > "${tfile}"
USE mysql;
FLUSH PRIVILEGES;
GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' identified by '$MYSQL_ROOT_PASSWORD' WITH GRANT OPTION;
GRANT ALL PRIVILEGES ON *.* TO 'root'@'localhost' identified by '$MYSQL_ROOT_PASSWORD' WITH GRANT OPTION;
SET PASSWORD FOR 'root'@'localhost' = PASSWORD('${MYSQL_ROOT_PASSWORD}');
EOF

    if [[ "$MYSQL_DATABASE" != "" ]]; then
        >&2 echo "[i] Creating database: $MYSQL_DATABASE"
        echo "CREATE DATABASE IF NOT EXISTS \`$MYSQL_DATABASE\` CHARACTER SET utf8 COLLATE utf8_general_ci;" >> "${tfile}"

        if [[ "$MYSQL_USER" != "" ]]; then
        >&2 echo "[i] Creating user: $MYSQL_USER with password $MYSQL_PASSWORD"
        echo "GRANT ALL ON \`$MYSQL_DATABASE\`.* to '$MYSQL_USER'@'%' IDENTIFIED BY '$MYSQL_PASSWORD';" >> "${tfile}"
        fi
    fi

    /usr/bin/mysqld --user=mysql --bootstrap --verbose=0 < "${tfile}"
    rm -f "${tfile}"
fi

# execute any pre-exec scripts
for i in /scripts/pre-exec.d/*sh
do
    if [[ -e "${i}" ]]; then
        >&2 echo "[i] pre-exec.d - processing $i"
	# shellcheck source=/dev/null
        . ${i}
    fi
done

# Modify /etc/my.cnf
for key_val in $(env); do
    if [[ "${key_val}" = MYSQLD_* ]]; then
        var=$(echo "${key_val}" | cut -d"=" -f1)
	val=${!var}
	config_option=${var#MYSQLD_}
	>&2 echo "Changing '${config_option}' to '${val}'"
	change_ini_param.py --config-file /etc/my.cnf "${config_option}" "${val}"
    fi
done

exec /usr/bin/mysqld --user=mysql --console
