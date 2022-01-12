FROM python:3.10-alpine3.15

ARG BRANCH

ENV HOME /root

RUN echo https://mirror.yandex.ru/mirrors/alpine/v3.15/main/       > /etc/apk/repositories \
 && echo https://mirror.yandex.ru/mirrors/alpine/v3.15/community/ >> /etc/apk/repositories \
 && apk --update add \
    bash \
    curl \
    gcc \
    git \
    linux-headers \
    musl-dev \
    openssh \
    postgresql-dev \
 && mkdir /var/www \
 && cd /var/www \
 \
 && curl -O https://raw.githubusercontent.com/vishnubob/wait-for-it/master/wait-for-it.sh \
 && chmod +x wait-for-it.sh \
 \
 && git clone -b $BRANCH --depth 1 https://github.com/tolstoyevsky/meeseeks.git \
 && pip3 install -r meeseeks/requirements.txt \
 \
 && apk del \
   gcc \
   git \
   openssh \
 && rm -rf /var/cache/apk/*

WORKDIR /var/www/meeseeks

COPY docker-entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
