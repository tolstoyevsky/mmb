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
 # Cleanup
 && apk del \
    curl \
 && rm -f /var/cache/apk/*

ADD run.sh /scripts/run.sh

RUN mkdir /scripts/pre-exec.d \
 && mkdir /scripts/pre-init.d \
 && chmod -R 755 /scripts

VOLUME ["/var/lib/mysql"]

ENTRYPOINT ["/scripts/run.sh"]
