FROM cusdeb/alpinev3.7:armhf
MAINTAINER Evgeny Golyshev <eugulixes@gmail.com>

ENV INADYN_VERSION v2.1
ENV LIBITE_VERSION v1.8.3
ENV LIBCONFUSE_VERSION v3.0

RUN apk --update add \
    automake \
    autoconf \
    build-base \
    ca-certificates \
    curl \
    flex \
    # gettext \
    gettext-dev \
    git \
    libtool \
    openssl-dev \
    tar \
 && mkdir -p /tmp/src/inadyn /tmp/src/libconfuse /tmp/src/libite \
 # libConfuse
 && curl -Lo /tmp/src/libconfuse.tar.gz https://github.com/martinh/libconfuse/archive/$LIBCONFUSE_VERSION.tar.gz \
 && tar -C /tmp/src/libconfuse --strip-components=1 -xzvf /tmp/src/libconfuse.tar.gz \
 && cd /tmp/src/libconfuse && ./autogen.sh && ./configure --prefix=/usr && make && make install \
 # libite
 && curl -Lo /tmp/src/libite.tar.gz https://github.com/troglobit/libite/archive/$LIBITE_VERSION.tar.gz \
 && tar -C /tmp/src/libite --strip-components=1 -xzvf /tmp/src/libite.tar.gz \
 && cd /tmp/src/libite && ./autogen.sh && ./configure --prefix=/usr && make && make install-strip \
 # inadyn
 && curl -Lo /tmp/src/inadyn.tar.gz https://github.com/troglobit/inadyn/archive/$INADYN_VERSION.tar.gz \
 && tar -C /tmp/src/inadyn --strip-components=1 -xzvf /tmp/src/inadyn.tar.gz \
 && cd /tmp/src/inadyn && ./autogen.sh && ./configure --enable-openssl && make && make install \
 # cleanup
 && rm -rf /tmp/src \
 && apk del \
    automake \
    autoconf \
    build-base \
    curl \
    flex \
    git \
    libtool \
    tar \
 && rm -rf /var/cache/apk/*

ENTRYPOINT ["/usr/local/sbin/inadyn", "--foreground"]
CMD ["--loglevel=info"]
