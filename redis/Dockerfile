FROM alpine:3.12
MAINTAINER Evgeny Golyshev <eugulixes@gmail.com>

ENV REDIS_VERSION 6.0.9

ENV REDIS_DOWNLOAD_URL https://github.com/antirez/redis/archive/$REDIS_VERSION.tar.gz

ENV REDIS_DOWNLOAD_SHA 2819b6d9c56be1f25cd157b9cb6b7c2733edcb46f4f6bcb1b79cefe639a2853b

RUN apk add --update \
    bash \
    build-base \
    coreutils \
    curl \
    linux-headers \
    pkgconf \
 && curl -OL $REDIS_DOWNLOAD_URL \
 && echo $REDIS_DOWNLOAD_SHA $REDIS_VERSION.tar.gz | sha256sum -c \
 && tar xzvf $REDIS_VERSION.tar.gz \
 && cd redis-$REDIS_VERSION \
 # Install only the server. Such client-side tools as redis-benchmark,
 # redis-check-aof, redis-check-rdb and redis-cli are not needed in the
 # container. They can be obtained by installing the redis-tools package
 # on Debian/Ubuntu.
 && make && install -o root -g root -m 744 src/redis-server /usr/bin \
 && cd .. \
 # Cleanup
 && rm    $REDIS_VERSION.tar.gz \
 && rm -r redis-$REDIS_VERSION \ 
 && apk del \
    build-base \
    coreutils \
    curl \
    linux-headers \
 && rm -rf /var/cache/apk/*

COPY docker-entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]

