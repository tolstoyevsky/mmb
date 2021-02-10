FROM alpine:3.13
MAINTAINER Valeriya Dmitrieva <dmit.valerya@yandex.ru>

RUN echo https://mirror.yandex.ru/mirrors/alpine/v3.13/main/       > /etc/apk/repositories \
 && echo https://mirror.yandex.ru/mirrors/alpine/v3.13/community/ >> /etc/apk/repositories \
 && apk --update add \
    dcron \
    docker \
    tzdata \
 && mkfifo -m 0666 /var/log/cron.log \
 && ln -s /var/log/cron.log /var/log/crond.log \
 && cp /usr/share/zoneinfo/Europe/Moscow /etc/localtime \
 && echo "Europe/Moscow" > /etc/timezone

COPY cleaning-script.sh /bin/cleaning-script.sh

COPY root /var/spool/cron/crontabs/root

COPY docker-entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
