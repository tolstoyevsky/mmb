FROM cusdeb/stretch:armhf
MAINTAINER Evgeny Golyshev <eugulixes@gmail.com>

ENV TERM linux
ENV TRANSMISSION_VERSION 2.92

COPY ./patches /root/patches
COPY ./rollout_fixes.sh /root/rollout_fixes.sh

RUN apt-get update && apt-get install -y \
    build-essential \
    intltool \
    libcurl4-openssl-dev \
    libevent-dev \
    libssl-dev \
    patch \
    pkg-config \
    wget \
    xz-utils \
    zlib1g-dev \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/* \
 && cd && wget https://github.com/transmission/transmission-releases/raw/master/transmission-$TRANSMISSION_VERSION.tar.xz \
 && tar xJvf transmission-$TRANSMISSION_VERSION.tar.xz \
 && mv /root/patches transmission-$TRANSMISSION_VERSION \
 && /root/rollout_fixes.sh \
 && cd transmission-$TRANSMISSION_VERSION \
 && ./configure --enable-cli \
                --enable-daemon \
                --enable-lightweight \
 && make && make install \
 && cd && rm transmission-$TRANSMISSION_VERSION.tar.xz && rm -r transmission-$TRANSMISSION_VERSION \
 && apt-get purge -y build-essential patch wget xz-utils \
 && apt-get autoremove -y

COPY ./run_transmission.sh /usr/bin/run_transmission.sh

