FROM node:16-alpine3.17
MAINTAINER Evgeny Golyshev <eugulixes@gmail.com>

ENV BOOKMARKS_VER v10.0.3

ENV CALENDAR_VER v3.0.4

ENV COLLECTIVES_VER v0.17.22

ENV CONTACTS_VER v4.0.7

ENV DECK_VER v1.6.0

ENV MAIL_VER v1.11.5

ENV NEWS_VER 17.0.1

ENV NEWS_UPDATER_VER 11.0.0

ENV NEXTCLOUD_VER v25.0.2

ENV NOTES_VER v4.2.0

ENV NOTIFY_PUSH_VER v0.3.0

ENV PASSMAN_VER 2.4.0

ENV PHOTO_SPHERE_VIEWER_VER v1.23.0

ENV SPREED_VER v13.0.1.1

ENV TASKS_VER v0.14.2

ENV INSTALL_DEPS_FOR "/var/www/nc/apps2/bookmarks /var/www/nc/apps2/circles /var/www/nc/apps2/collectives /var/www/nc/apps2/deck /var/www/nc/apps2/files_photospheres /var/www/nc/apps2/news /var/www/nc/apps2/text"

ENV BUILD_JS_FOR "/var/www/nc/apps2/bookmarks /var/www/nc/apps2/calendar /var/www/nc/apps2/collectives /var/www/nc/apps2/contacts /var/www/nc/apps2/deck /var/www/nc/apps2/mail /var/www/nc/apps2/news/js /var/www/nc/apps2/notes /var/www/nc/apps2/notifications /var/www/nc/apps2/photos /var/www/nc/apps2/spreed /var/www/nc/apps2/tasks"

# For building the Spreed app
ENV NODE_OPTIONS "--max-old-space-size=6144"

COPY ./patches /patches

RUN echo http://mirror.yandex.ru/mirrors/alpine/v3.17/community >> /etc/apk/repositories \
 && apk --update add \
    bash \
    composer \
    curl \
    g++ \
    git \
    make \
    nginx \
    patch \
    php81 \
 # required modules
    php81-ctype \
    php81-curl \
    php81-dom \
    php81-fpm \
    php81-gd \
    php81-iconv \
    php81-json \
    php81-mbstring \
    php81-openssl \
    # for nextcloud-news-updater
    php81-pcntl \
    php81-pdo \
    php81-pdo_mysql \
    php81-posix \
    php81-session \
    php81-simplexml \
    php81-tokenizer \
    php81-xml \
    php81-xmlreader \
    php81-xmlwriter \
    php81-zip \
 # recommended modules
    php81-bcmath \
    php81-fileinfo \
    php81-gmp \
    php81-intl \
    php81-opcache \
    php81-pecl-apcu \
    php81-pecl-imagick \
    php81-pecl-redis \
    \
    python3 \
    py3-pip \
    # For nextcloud-news-updater to run it as nginx user
    sudo \
 && mkdir -p /run/nginx \
 && cd /usr/bin \
 && curl -O https://raw.githubusercontent.com/tolstoyevsky/mmb/master/utils/change_ini_param.py \
 && chmod +x /usr/bin/change_ini_param.py \
 # Use Composer 1.x for the Mail app. See https://github.com/nextcloud/mail/issues/5136
 && curl -O https://getcomposer.org/download/1.10.23/composer.phar \
 && chmod +x /usr/bin/composer.phar \
 # Install Nextcloud
 && cd /var/www \
 && git clone -b "${NEXTCLOUD_VER}" --depth 1 https://github.com/nextcloud/server.git nc \
 && cd /var/www/nc \
 # Patch Nextcloud
 && mv /patches /var/www/nc/patches \
 && for patch in $(cat patches/series); do patch -p1 < patches/"${patch}"; done \
 # Install apps
 && git clone -b "${NEXTCLOUD_VER}" --depth 1 https://github.com/nextcloud/3rdparty.git \
 && mkdir apps2 && cd apps2 \
 && git clone -b "${BOOKMARKS_VER}"           --depth 1 https://github.com/nextcloud/bookmarks.git \
 && git clone -b "${CALENDAR_VER}"            --depth 1 https://github.com/nextcloud/calendar.git \
 && git clone -b "${MAIL_VER}"                --depth 1 https://github.com/nextcloud/mail.git \
 && git clone -b "${NEXTCLOUD_VER}"           --depth 1 https://github.com/nextcloud/circles.git \
 && git clone -b "${COLLECTIVES_VER}"         --depth 1 https://gitlab.com/collectivecloud/collectives.git \
 && git clone -b "${CONTACTS_VER}"            --depth 1 https://github.com/nextcloud/contacts.git \
 && git clone -b "${DECK_VER}"                --depth 1 https://github.com/nextcloud/deck.git \
 && git clone -b "${NEXTCLOUD_VER}"           --depth 1 https://github.com/nextcloud/files_pdfviewer.git \
 && git clone -b "${PHOTO_SPHERE_VIEWER_VER}" --depth 1 https://github.com/nextcloud/files_photospheres.git \
 && git clone -b "${NEXTCLOUD_VER}"           --depth 1 https://github.com/nextcloud/files_rightclick.git \
 && git clone -b "${NEWS_VER}"                --depth 1 https://github.com/nextcloud/news.git \
 && git clone -b "${NOTES_VER}"               --depth 1 https://github.com/nextcloud/notes.git \
 && git clone -b "${NEXTCLOUD_VER}"           --depth 1 https://github.com/nextcloud/notifications.git \
 && git clone -b "${NOTIFY_PUSH_VER}"         --depth 1 https://github.com/nextcloud/notify_push.git \
 && git clone -b "${PASSMAN_VER}"             --depth 1 https://github.com/nextcloud/passman.git \
 && git clone -b "${NEXTCLOUD_VER}"           --depth 1 https://github.com/nextcloud/photos.git \
 && git clone -b "${SPREED_VER}"              --depth 1 https://github.com/nextcloud/spreed.git \
 && git clone -b "${TASKS_VER}"               --depth 1 https://github.com/nextcloud/tasks.git \
 && git clone -b "${NEXTCLOUD_VER}"           --depth 1 https://github.com/nextcloud/text.git \
 && git clone -b "${NEXTCLOUD_VER}"           --depth 1 https://github.com/nextcloud/viewer.git \
 \
 && >&2 echo "----- Entering to /var/www/nc/apps2/mail" \
 && cd /var/www/nc/apps2/mail \
 && composer.phar install --no-dev \
 \
 && for dir in ${INSTALL_DEPS_FOR}; do >&2 echo "----- Entering to ${dir}"; cd "${dir}"; composer install --no-dev; done \
 \
 #
 # Build patched Nextcloud.
 #
 && >&2 echo "----- Entering to /var/www/nc" \
 && cd /var/www/nc \
 && npm i --save-dev \
 && npm run build \
 && rm -r node_modules \
 \
 #
 # Build Nextcloud apps.
 # It requires NPM 7.
 #
 && for dir in ${BUILD_JS_FOR}; do >&2 echo "----- Entering to ${dir}"; cd "${dir}"; npm i; npm run svg_sprite 2> /dev/null || true; npm run build; rm -rf node_modules; done \
 \
 && chown -R nginx:nginx /var/www \
 \
 && pip3 install nextcloud-news-updater=="${NEWS_UPDATER_VER}" \
 # Cleanup
 && npm r -g npm \
 && apk del \
    curl \
    git \
    g++ \
    make \
    npm \
    py3-pip \
 && rm -r /root/.npm \
 && rm -r /var/cache/apk/*

COPY ./config/avoid-security-or-privacy-risks.conf /etc/nginx/avoid-security-or-privacy-risks.conf

COPY ./config/add-misc-headers.conf /etc/nginx/add-misc-headers.conf

COPY ./config/default /etc/nginx/http.d/default.conf

COPY ./docker-entrypoint.sh /entrypoint.sh

WORKDIR /var/www/nc

CMD ["/entrypoint.sh"]

