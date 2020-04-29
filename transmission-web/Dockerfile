FROM alpine:3.11
MAINTAINER Evgeny Golyshev <eugulixes@gmail.com>

ENV TERM linux
ENV TRANSMISSION_VERSION 2.94

COPY ./patches /root/patches

RUN apk --update add \
    # for sys/queue.h
    bsd-compat-headers \
    curl-dev \
    g++ \
    intltool \
    libevent-dev \
    libressl-dev \
    make \
    patch \
    pkgconfig \
    zlib-dev \
 && cd && wget https://github.com/transmission/transmission-releases/raw/master/transmission-$TRANSMISSION_VERSION.tar.xz \
 && tar xJvf transmission-$TRANSMISSION_VERSION.tar.xz \
 && mv /root/patches transmission-$TRANSMISSION_VERSION \
 && cd transmission-$TRANSMISSION_VERSION \
 && for path in $(ls patches/*.patch 2> /dev/null); do \
      patch -p1 < "${path}"; \
    done \
 && ./configure --enable-cli \
                --enable-daemon \
                --enable-lightweight \
 && make && make install \
 && cd && rm transmission-$TRANSMISSION_VERSION.tar.xz && rm -r transmission-$TRANSMISSION_VERSION \
 # Cleanup
 && apk del \
    g++ \
    intltool \
    make \
    patch \
    pkgconfig \
 && rm -rf /var/cache/apk/*


COPY docker-entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]

