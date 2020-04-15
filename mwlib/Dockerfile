FROM alpine:3.11
MAINTAINER Evgeny Golyshev <eugulixes@gmail.com>

# The following version of mwlib.rl depends on mwlib 0.16.2.
ENV MWLIB_RL_VER "0.14.5"

COPY patches /root/patches

RUN apk --update add \
    bash \
    curl \
    g++ \
    gcc \
    jpeg-dev \
    libffi-dev \
    libstdc++ \
    libxml2-dev \
    libxslt-dev \
    make \
    musl-dev \
    py2-pip \
    py-setuptools \
    python-dev \
    re2c \ 
 # Install Pillow 6.1.0 otherwise the latest one will be installed,
 # but that's not what we need.
 && pip install Pillow==6.1.0 \
 && pip install mwlib.rl=="${MWLIB_RL_VER}" \
 && cd \
 && curl -O https://raw.githubusercontent.com/vishnubob/wait-for-it/master/wait-for-it.sh \
 && chmod +x wait-for-it.sh \
 && mv wait-for-it.sh /usr/local/bin \
 # Apply patches
 && cd / \
 && for path in $(ls /root/patches/*.patch 2> /dev/null); do \
      patch -p0 < "${path}"; \
    done \
 # Cleanup
 && apk del \
    curl \
    g++ \
    gcc \
    make \   
    py2-pip \
    re2c \
 && rm -rf /var/cache/apk/*

COPY ./docker-entrypoint.sh /entrypoint.sh

CMD ["/entrypoint.sh"]

