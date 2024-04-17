FROM alpine:3.19
MAINTAINER Evgeny Golyshev <eugulixes@gmail.com>

ENV COTURN_VERSION 4.6.2

RUN apk --update add \
    build-base \
    git \
    libevent-dev \
    linux-headers \
    openssl \
    openssl-dev \
    sqlite-dev \
    sudo \
 && cd \
 && git clone -b "${COTURN_VERSION}" --depth 1 https://github.com/coturn/coturn.git \
 && cd coturn \
 && ./configure --prefix=/usr \
 && make && make install \
 && cd && rm -r coturn \
 && apk del \
    build-base \
    git \
    linux-headers \
 && rm -rf /var/cache/apk/*

COPY ./docker-entrypoint.sh /entrypoint.sh

CMD ["/entrypoint.sh"]
