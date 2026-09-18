FROM python:3.10-alpine3.15

ARG BRANCH

ENV HOME /root

COPY --from=ghcr.io/astral-sh/uv:latest /uv /uvx /bin/

RUN echo https://mirror.yandex.ru/mirrors/alpine/v3.15/main/       > /etc/apk/repositories \
 && echo https://mirror.yandex.ru/mirrors/alpine/v3.15/community/ >> /etc/apk/repositories \
 && apk --update add \
    bash \
    curl \
    git \
    openssh \
 && mkdir /var/www \
 && cd /var/www \
 \
 && curl -O https://raw.githubusercontent.com/vishnubob/wait-for-it/master/wait-for-it.sh \
 && chmod +x wait-for-it.sh \
 \
 && git clone -b $BRANCH --depth 1 https://github.com/tolstoyevsky/meeseeks.git \
 && cd meeseeks \
 && uv sync \
 \
 && apk del \
   git \
   openssh \
 && rm -rf /var/cache/apk/*

WORKDIR /var/www/meeseeks

COPY docker-entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
