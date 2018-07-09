FROM cusdeb/alpine3.7:armhf
MAINTAINER Evgeny Golyshev <eugulixes@gmail.com>

ENV COTURN_VERSION 4.5.0.7

COPY ./rollout_fixes.sh /root/rollout_fixes.sh

RUN apk --update add \
    build-base \
    git \
    libevent-dev \
    openssl-dev \
    sqlite-dev \
 && cd \
 && ./rollout_fixes.sh \
 && git clone -b $COTURN_VERSION https://github.com/coturn/coturn.git \
 && cd coturn \
 && ./configure --prefix=/usr \
 && make && make install \
 && cd && rm -r coturn \
 && cp /usr/share/examples/turnserver/etc/turn_server_cert.pem /etc/turn_server_cert.pem \
 && cp /usr/share/examples/turnserver/etc/turn_server_pkey.pem /etc/turn_server_pkey.pem \
 && apk del \
    build-base \
    git \
 && rm -rf /var/cache/apk/*

COPY ./run.sh /usr/bin/run.sh

