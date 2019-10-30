FROM cusdeb/alpine3.7-node:amd64
MAINTAINER Evgeny Golyshev <eugulixes@gmail.com>

ENV PARSOID_VERSION 0.10.0

RUN apk --update add \
    curl \
    git \
    make \
    python \
 # Install Parsoid
 && cd \
 && curl -LO https://github.com/wikimedia/parsoid/archive/v$PARSOID_VERSION.tar.gz \
 && tar xzf v$PARSOID_VERSION.tar.gz \
 && rm v$PARSOID_VERSION.tar.gz \
 && mv parsoid-$PARSOID_VERSION parsoid \
 && cd parsoid \
 && npm install \
 # Cleanup
 && apk del \
    curl \
    git \
    make \
    python \
 && rm -rf /var/cache/apk/*

COPY ./docker-entrypoint.sh /usr/bin/docker-entrypoint.sh

COPY ./config/config.yaml /root/parsoid/config.yaml

ENTRYPOINT ["docker-entrypoint.sh"]

