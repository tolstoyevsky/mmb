FROM alpine:3.13
MAINTAINER Evgeny Golyshev <eugulixes@gmail.com>

RUN echo http://mirror.yandex.ru/mirrors/alpine/v3.13/community >> /etc/apk/repositories \
 && apk --update add \
    bash \
    build-base \
    curl \
    linux-pam-dev \
    shadow \
    tar \
    vsftpd \
 && mkdir pam_pwdfile \
 && cd pam_pwdfile \
 && curl -sSL https://github.com/tiwe-de/libpam-pwdfile/archive/v1.0.tar.gz | tar xz --strip 1 \
 && make install \
 && cd .. \
 && rm -rf pam_pwdfile \
 && apk del \
    build-base \
    curl \
    linux-pam-dev \
    tar \
 && passwd -l root \
 && rm -rf /var/cache/apk/*

COPY ./config/vsftpd.conf /etc/vsftpd/vsftpd.conf

COPY ./docker-entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]

