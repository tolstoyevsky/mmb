FROM alpine:3.14
MAINTAINER Evgeny Golyshev <eugulixes@gmail.com>

RUN echo http://mirror.yandex.ru/mirrors/alpine/v3.14/community >> /etc/apk/repositories \
 && apk --update add \
    bash \
    composer \
    curl \
    nginx \
    php7 \
 # required modules
    php7-ctype \
    php7-curl \
    php7-dom \
    php7-fpm \
    php7-gd \
    php7-iconv \
    php7-json \
    php7-mbstring \
    php7-openssl \
    # for nextcloud-news-updater
    php7-pcntl \
    php7-pdo \
    php7-pdo_mysql \
    php7-posix \
    php7-session \
    php7-simplexml \
    php7-tokenizer \
    php7-xml \
    php7-xmlreader \
    php7-xmlwriter \
    php7-zip \
 # recommended modules
    php7-bcmath \
    php7-fileinfo \
    php7-gmp \
    php7-intl \
    php7-opcache \
    php7-pecl-apcu \
    php7-pecl-imagick \
    \
    php7-pecl-xdebug \
    \
    python3 \
    shadow \
 && mkdir -p /run/nginx \
 && cd /usr/local/bin \
 && curl -O https://raw.githubusercontent.com/tolstoyevsky/mmb/master/utils/change_ini_param.py \
 && chmod +x /usr/local/bin/change_ini_param.py \
 # Cleanup
 && apk del \
    curl \
 && rm -r /var/cache/apk/*

COPY ./config/add-misc-headers.conf /etc/nginx/add-misc-headers.conf

COPY ./config/avoid-security-or-privacy-risks.conf /etc/nginx/avoid-security-or-privacy-risks.conf

COPY ./config/default /etc/nginx/http.d/default.conf

COPY ./docker-entrypoint.sh /entrypoint.sh

WORKDIR /var/www/nc

CMD ["/entrypoint.sh"]

