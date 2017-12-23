FROM cusdeb/stretch:armhf
MAINTAINER Evgeny Golyshev <eugulixes@gmail.com>

ENV DELUGE_VERSION 1.3.15
ENV TERM linux

COPY ./patches /root/patches
COPY ./rollout_fixes.sh /root/rollout_fixes.sh

RUN apt-get update && apt-get install -y \
    bzip2 \
    intltool \
    patch \
    python \
    python-setuptools \
    python-chardet \
    python-openssl \
    python-twisted \
    python-mako \
    python-xdg \
    python-libtorrent \
    supervisor \
    wget \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/* \
 && cd && wget http://git.deluge-torrent.org/deluge/snapshot/deluge-$DELUGE_VERSION.tar.bz2 \
 && tar xjvf deluge-$DELUGE_VERSION.tar.bz2 \
 && mv /root/patches deluge-$DELUGE_VERSION \
 && /root/rollout_fixes.sh \
 && cd deluge-$DELUGE_VERSION \
 && python setup.py build \
 && python setup.py install \
 && cd && rm deluge-$DELUGE_VERSION.tar.bz2 && rm -r deluge-$DELUGE_VERSION \
 && apt-get purge -y bzip2 patch wget \
 && apt-get autoremove -y

COPY ./config/supervisord.conf /etc/supervisor/supervisord.conf
COPY ./run_deluge.sh /usr/bin/run_deluge.sh

