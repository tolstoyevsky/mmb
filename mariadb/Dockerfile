FROM alpine:3.13
MAINTAINER Evgeny Golyshev <eugulixes@gmail.com>

RUN apk --update add \
    bash \
    curl \
    mariadb \
    mariadb-client \
    pwgen \
    python3 \
 && cd /usr/bin \
 && curl -O https://raw.githubusercontent.com/tolstoyevsky/mmb/master/utils/change_ini_param.py \
 && chmod +x /usr/bin/change_ini_param.py \
 && mkdir -p /scripts/pre-exec.d \
 && mkdir -p /scripts/pre-init.d \
 && chmod -R 755 /scripts \
 # Cleanup
 && apk del \
    curl \
 && rm -f /var/cache/apk/*

COPY ./docker-entrypoint.sh /entrypoint.sh

VOLUME ["/var/lib/mysql"]

CMD ["/entrypoint.sh"]
