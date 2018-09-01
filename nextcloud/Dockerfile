FROM cusdeb/stretch:amd64
MAINTAINER Evgeny Golyshev <eugulixes@gmail.com>

ENV BOOKMARKS_VERSION v0.12.1
ENV CALENDAR_VERSION v1.6.1
ENV CONTACTS_VERSION v2.1.6
ENV NEXTCLOUD_VERSION v14.0.0RC2
ENV OCSMS_VERSION 1.13.1
ENV NOTES_VERSION v2.4.1
ENV SPREED_VERSION v3.99.12
ENV TERM linux

COPY ./fix_phantomjs_on_armv7l.sh /usr/bin/fix_phantomjs_on_armv7l.sh

RUN apt-get update && apt-get install -y \
    apt-transport-https \
    build-essential \
    curl \
    git \
    gnupg2 \
    less \
    make \
    nano \
    nginx \
    patch \
    php-apcu \
    php-curl \
    php-gd \
    php-fpm \
    php-ldap \
    php-mbstring \
    php-memcached \
    php-mysql \
    php-xml \
    php-zip \
    sudo \
    supervisor \
    wget \
    cron \
 && /usr/bin/fix_phantomjs_on_armv7l.sh \
 # Install Node.js
 && wget -qO- https://deb.nodesource.com/setup_8.x | sudo bash - \
 && apt-get install nodejs \
 # Install yarn
 && wget -qO - https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add - \
 && echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list \
 && apt-get update && apt-get install -y yarn \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/* \
 # Install Nextcloud
 && cd /var/www \
 && git clone -b $NEXTCLOUD_VERSION --depth 1 https://github.com/nextcloud/server.git nc \
 && cd /var/www/nc \
 && git clone -b $NEXTCLOUD_VERSION --depth 1 https://github.com/nextcloud/3rdparty.git \
 && git clone -b $NEXTCLOUD_VERSION --depth 1 https://github.com/nextcloud/apps.git apps2 \
 && cd /var/www/nc/apps2 \
 && git clone -b $CALENDAR_VERSION  --depth 1 https://github.com/nextcloud/calendar.git \
 && git clone -b $CONTACTS_VERSION  --depth 1 https://github.com/nextcloud/contacts.git \
 && git clone -b $BOOKMARKS_VERSION --depth 1 https://github.com/nextcloud/bookmarks.git \
 && git clone -b $NEXTCLOUD_VERSION --depth 1 https://github.com/nextcloud/files_pdfviewer.git \
 && git clone -b $NEXTCLOUD_VERSION --depth 1 https://github.com/nextcloud/files_videoplayer.git \
 && rm -r /var/www/nc/apps2/files_videoviewer \
 && rm -r /var/www/nc/apps2/files_odfviewer \
 && git clone -b $NEXTCLOUD_VERSION --depth 1 https://github.com/nextcloud/notifications.git \
 && git clone -b $OCSMS_VERSION     --depth 1 https://github.com/nextcloud/ocsms.git \
 && git clone -b $NOTES_VERSION     --depth 1 https://github.com/nextcloud/notes.git \
 && git clone -b $NEXTCLOUD_VERSION --depth 1 https://github.com/nextcloud/gallery.git \
 && git clone -b $SPREED_VERSION    --depth 1 https://github.com/nextcloud/spreed.git \
 && chown -R www-data:www-data /var/www \
 # Install the latest bower.
 # Helps to solver the issue:
 # EINVRES Request to https://bower.herokuapp.com/packages/angular failed with 502
 && cd /var/www/nc/apps2/calendar/js && sudo -u www-data npm install bower \
 && cd ..          && sudo -u www-data make \
 && cd ../contacts && sudo -u www-data make \
 # Cleanup
 && rm -r /var/www/.cache \
 && rm -r /var/www/.node-gyp \
 && rm -r /var/www/.npm \
 && rm -r /var/www/nc/apps2/calendar/js/node_modules \
 && rm -r /var/www/nc/apps2/contacts/node_modules \
 && /usr/bin/fix_phantomjs_on_armv7l.sh \
 && apt-get purge -y \
    apt-transport-https \
    build-essential \
    curl \
    git \
    gnupg2 \
    make \
    wget \
    nodejs \
    yarn \
 && apt-get autoremove -y

COPY ./patches /var/www/nc/patches
COPY ./rollout_fixes.sh /usr/bin/rollout_fixes.sh

COPY ./config/cron /tmp/cron
COPY ./config/default /etc/nginx/sites-available/default
COPY ./config/www.conf /etc/php/7.0/fpm/pool.d/www.conf
COPY ./config/supervisord.conf /etc/supervisor/supervisord.conf
COPY ./run_nginx.sh /usr/bin/run_nginx.sh

RUN /usr/bin/rollout_fixes.sh
RUN crontab -u www-data /tmp/cron
