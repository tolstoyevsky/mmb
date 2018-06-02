FROM cusdeb/alpine3.7:amd64
MAINTAINER Evgeny Golyshev <eugulixes@gmail.com>

ENV WATCHTOWER_VERSION 0.3.0
ENV WATCHTOWER_SRC /root/src/github.com/v2tec/watchtower

RUN echo http://mirror.yandex.ru/mirrors/alpine/v3.7/community >> /etc/apk/repositories \
 && apk --update add \
    git \
    glide \
    go \
    musl-dev \
 && mkdir -p $WATCHTOWER_SRC \
 && git clone -b v0.3.0 https://github.com/v2tec/watchtower.git $WATCHTOWER_SRC \
 && cd $WATCHTOWER_SRC \
 && env GOPATH=/root glide install \
 && env GOPATH=/root go build -a -ldflags '-extldflags "-static"' \
 && cp watchtower / \
 # Cleanup
 && rm -r /root/src /root/.glide \
 && apk del \
    git \
    glide \
    go \
    musl-dev \
 && rm -f /var/cache/apk/*

ENTRYPOINT ["/watchtower"]

