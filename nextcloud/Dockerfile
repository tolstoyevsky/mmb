FROM armv7/armhf-debian
MAINTAINER Evgeny Golyshev <eugulixes@gmail.com>

COPY qemu-arm-static /usr/bin/qemu-arm-static

ENV NEXTCLOUD_VERSION stable10

RUN apt-get update && apt-get install -y \
    git \
    nginx \
    # Only for PHP 5.5 and up.
    php5-apcu \
    php5-curl \
    php5-gd \
    php5-fpm \
    php5-mysql \
    supervisor \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

RUN cd /var/www \
 && git clone -b $NEXTCLOUD_VERSION --depth 1 https://github.com/nextcloud/server.git nc

RUN cd /var/www/nc \
 && git clone -b $NEXTCLOUD_VERSION --depth 1 https://github.com/nextcloud/3rdparty.git \
 && git clone -b $NEXTCLOUD_VERSION --depth 1 https://github.com/nextcloud/apps.git apps2

RUN cd /var/www/nc/apps2 \
 && git clone -b $NEXTCLOUD_VERSION --depth 1 https://github.com/nextcloud/gallery.git

RUN cd /var/www && chown -R www-data:www-data nc

# Security & setup warnings:
# php does not seem to be setup properly to query system environment variables.
# The test with getenv("PATH") only returns an empty response.
RUN sed -i -e "s/;env\[PATH\]/env\[PATH\]/" /etc/php5/fpm/pool.d/www.conf

COPY ./config/default /etc/nginx/sites-available/default
COPY ./config/supervisord.conf /etc/supervisor/supervisord.conf
COPY ./run_nginx.sh /usr/bin/run_nginx.sh

