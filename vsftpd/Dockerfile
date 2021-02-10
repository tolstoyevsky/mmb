FROM cusdeb/alpine3.7:amd64
MAINTAINER Evgeny Golyshev <eugulixes@gmail.com>

RUN echo http://mirror.yandex.ru/mirrors/alpine/v3.7/community >> /etc/apk/repositories \
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
COPY ./run.sh /usr/bin/run.sh

