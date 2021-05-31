FROM cusdeb/alpine3.7:amd64
MAINTAINER Evgeny Golyshev <eugulixes@gmail.com>

ENV MEMCACHED_VERSION 1.5.10

ENV MEMCACHED_DOWNLOAD_URL https://github.com/memcached/memcached/archive/$MEMCACHED_VERSION.tar.gz

ENV MEMCACHED_DOWNLOAD_SHA 58408d0abc29e2da27cd3e1b9506991f0bd9c80e9362c68e564eee166631b18a

# If the version doesn't look bad for Debian Stretch,
# it's not bad for the image.
ENV SASL_VERSION 2.1.27

ENV SASL_DOWNLOAD_URL https://github.com/cyrusimap/cyrus-sasl/releases/download/cyrus-sasl-"${SASL_VERSION}"/cyrus-sasl-"${SASL_VERSION}".tar.gz

ENV LIBEVENT_VERSION 2.1.8-stable

ENV LIBEVENT_DOWNLOAD_URL https://github.com/libevent/libevent/releases/download/release-$LIBEVENT_VERSION/libevent-$LIBEVENT_VERSION.tar.gz

RUN adduser -D memcached

RUN apk add --update \
    autoconf \
    automake \
    build-base \
    coreutils \
    curl \
    git \
    linux-headers \
    perl \
 && mkdir -p /opt/homemade \
 && cd \
 # Build Cyrus SASL
 && curl -OL $SASL_DOWNLOAD_URL \
 && tar xzvf cyrus-sasl-"${SASL_VERSION}".tar.gz \
 && cd cyrus-sasl-$SASL_VERSION \
 # https://git.alpinelinux.org/cgit/aports/tree/main/cyrus-sasl/APKBUILD?h=3.7-stable#n47
 && ./configure --prefix=/opt/homemade \
                --disable-anon \
                --enable-cram \
                --enable-digest \
                --enable-login \
                --enable-ntlm \
                --disable-otp \
                --enable-plain \
                --with-gss_impl=heimdal \
                --with-devrandom=/dev/urandom \
                --without-ldap \
                --with-saslauthd=/var/run/saslauthd \
                # The reason we're all here tonight
                --enable-static \
 && make && make install \
 && cd .. \
 # Build libevent
 && curl -OL $LIBEVENT_DOWNLOAD_URL \
 && tar xzvf libevent-$LIBEVENT_VERSION.tar.gz \
 && cd libevent-$LIBEVENT_VERSION \
 # https://git.alpinelinux.org/cgit/aports/tree/main/libevent/APKBUILD?h=3.7-stable#n33
 && ./configure --prefix=/opt/homemade \
                --enable-static \
 && make && make install \
 && cd .. \
 # Build memcached
 && curl -OL $MEMCACHED_DOWNLOAD_URL \
 && echo $MEMCACHED_DOWNLOAD_SHA $MEMCACHED_VERSION.tar.gz | sha256sum -c \
 && tar xzvf $MEMCACHED_VERSION.tar.gz \
 && cd memcached-$MEMCACHED_VERSION \
 && ./autogen.sh \
 && env CFLAGS='-I/opt/homemade/include' LDFLAGS='-L/opt/homemade/lib' ./configure --enable-sasl \
 && make SHARED=0 CC='gcc -static' && make install \
 # Install only the server
 && make && install -o root -g root -m 744 memcached /usr/bin \
 && cd .. \
 # Cleanup
 && rm    cyrus-sasl-"${SASL_VERSION}".tar.gz \
 && rm    libevent-$LIBEVENT_VERSION.tar.gz \
 && rm    $MEMCACHED_VERSION.tar.gz \
 && rm -r cyrus-sasl-$SASL_VERSION \
 && rm -r libevent-$LIBEVENT_VERSION \
 && rm -r memcached-$MEMCACHED_VERSION \
 && rm -r /opt/homemade \
 && apk del \
    autoconf \
    automake \
    build-base \
    coreutils \
    curl \
    git \
    linux-headers \
    perl \
 && rm -rf /var/cache/apk/*

USER memcached

COPY docker-entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]

