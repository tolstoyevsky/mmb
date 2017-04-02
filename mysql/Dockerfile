FROM armv7/armhf-debian

COPY qemu-arm-static /usr/bin/qemu-arm-static

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y \
    mysql-server \
    mysql-client \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/* \
 # I'm not sure it's necessary. Copy-pasted from
 # https://github.com/haotseng/armhf_dockerfiles/tree/master/armhf-mysql.
 && /etc/init.d/mysql stop \
 && rm -rf /var/lib/mysql/*

#
# The init-db scripts or sql command files in this directory will be executed when container created.
# The details please refer "entrypoint.sh"
#
RUN mkdir /docker-entrypoint-initdb.d

VOLUME /var/log/mysql
VOLUME /var/lib/mysql

EXPOSE 3306


COPY docker-entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

CMD ["mysqld"]
