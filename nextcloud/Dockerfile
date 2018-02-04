FROM cusdeb/stretch:armhf
MAINTAINER Evgeny Golyshev <eugulixes@gmail.com>

ENV CALENDAR_VERSION v1.5.7
ENV CONTACTS_VERSION v2.0.1
ENV NEXTCLOUD_VERSION v13.0.0RC4
ENV SPREED_VERSION v3.0.1
ENV TERM linux

RUN apt-get update && apt-get install -y \
    git \
    less \
    memcached \
    nano \
    nginx \
    patch \
    php-apcu \
    php-curl \
    php-gd \
    php-fpm \
    php-mbstring \
    php-memcached \
    php-mysql \
    php-xml \
    php-zip \
    supervisor \
    cron \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/* \
 && cd /var/www \
 && git clone -b $NEXTCLOUD_VERSION --depth 1 https://github.com/nextcloud/server.git nc \
 && cd /var/www/nc \
 && git clone -b $NEXTCLOUD_VERSION --depth 1 https://github.com/nextcloud/3rdparty.git \
 && git clone -b $NEXTCLOUD_VERSION --depth 1 https://github.com/nextcloud/apps.git apps2 \
 && cd /var/www/nc/apps2 \
 && git clone -b $CALENDAR_VERSION  --depth 1 https://github.com/nextcloud/calendar.git \
 && git clone -b $CONTACTS_VERSION  --depth 1 https://github.com/nextcloud/contacts.git \
 && git clone -b $NEXTCLOUD_VERSION --depth 1 https://github.com/nextcloud/files_pdfviewer.git \
 && git clone -b $NEXTCLOUD_VERSION --depth 1 https://github.com/nextcloud/files_videoplayer.git \
 && rm -r /var/www/nc/apps2/files_videoviewer \
 && git clone -b $NEXTCLOUD_VERSION --depth 1 https://github.com/nextcloud/gallery.git \
 && git clone -b $SPREED_VERSION    --depth 1 https://github.com/nextcloud/spreed.git \
 && cd /var/www && chown -R www-data:www-data nc \
 && apt-get purge -y git \
 && apt-get autoremove -y

COPY ./patches /var/www/nc/patches
COPY ./rollout_fixes.sh /usr/bin/rollout_fixes.sh
RUN /usr/bin/rollout_fixes.sh

COPY ./config/cron /tmp/cron
COPY ./config/default /etc/nginx/sites-available/default
COPY ./config/www.conf /etc/php/7.0/fpm/pool.d/www.conf
COPY ./config/supervisord.conf /etc/supervisor/supervisord.conf
COPY ./run_nginx.sh /usr/bin/run_nginx.sh

RUN crontab -u www-data /tmp/cron
