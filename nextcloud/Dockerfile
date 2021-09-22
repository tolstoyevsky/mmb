FROM alpine:3.14
MAINTAINER Evgeny Golyshev <eugulixes@gmail.com>

ENV BOOKMARKS_VER v10.0.0

ENV CALENDAR_VER v2.3.3

ENV CONTACTS_VER v4.0.3

ENV DECK_VER v1.5.3

ENV NEWS_VER 16.0.1

ENV NEWS_UPDATER_VER 11.0.0

ENV NEXTCLOUD_VER v22.1.1

ENV NOTES_VER v4.1.1

ENV NOTIFY_PUSH_VER v0.2.2

ENV PASSMAN_VER 2.3.10

ENV PHOTO_SPHERE_VIEWER_VER v1.22.0

ENV SPREED_VER v12.2.0

ENV TASKS_VER v0.14.2

ENV INSTALL_DEPS_FOR "/var/www/nc/apps2/bookmarks /var/www/nc/apps2/deck /var/www/nc/apps2/files_photospheres /var/www/nc/apps2/news"

ENV BUILD_JS_FOR "/var/www/nc /var/www/nc/apps2/bookmarks /var/www/nc/apps2/calendar /var/www/nc/apps2/contacts /var/www/nc/apps2/deck /var/www/nc/apps2/news/js /var/www/nc/apps2/notes /var/www/nc/apps2/notifications /var/www/nc/apps2/photos /var/www/nc/apps2/spreed /var/www/nc/apps2/tasks /var/www/nc/apps2/viewer"

# For building the Spreed app
ENV NODE_OPTIONS "--max-old-space-size=6144"

COPY ./patches /patches

RUN echo http://mirror.yandex.ru/mirrors/alpine/v3.14/community >> /etc/apk/repositories \
 && apk --update add \
    bash \
    composer \
    curl \
    g++ \
    git \
    make \
    nginx \
    npm \
    patch \
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
    php7-pecl-redis \
    \
    python3 \
    py3-pip \
    # For nextcloud-news-updater to run it as nginx user
    sudo \
 && mkdir -p /run/nginx \
 && cd /usr/bin \
 && curl -O https://raw.githubusercontent.com/tolstoyevsky/mmb/master/utils/change_ini_param.py \
 && chmod +x /usr/bin/change_ini_param.py \
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
 && git clone -b "${NEXTCLOUD_VER}"           --depth 1 https://github.com/nextcloud/viewer.git \
 \
 && for dir in ${INSTALL_DEPS_FOR}; do cd "${dir}"; composer install --no-dev; done \
 \
 # Remove /var/www/nc/core/js/dist to rebuild it later to reflect the changes in
 # hide-unnecessary-blocks-on-installation-page.patch 
 && rm -r /var/www/nc/core/js/dist \
 \
 && for dir in ${BUILD_JS_FOR}; do cd "${dir}"; rm -f package-lock.json; npm i --save-dev; npm run svg_sprite 2> /dev/null || true; npm run build; rm -rf node_modules; done \
 \
 && chown -R nginx:nginx /var/www \
 \
 && pip3 install nextcloud-news-updater=="${NEWS_UPDATER_VER}" \
 # Cleanup
 && apk del \
    curl \
    git \
    g++ \
    make \
    npm \
    py3-pip \
 && rm -r /usr/local/lib/node_modules \
 && rm -r /var/cache/apk/* \
 && rm -r /var/www/nc/node_modules

COPY ./config/avoid-security-or-privacy-risks.conf /etc/nginx/avoid-security-or-privacy-risks.conf

COPY ./config/add-misc-headers.conf /etc/nginx/add-misc-headers.conf

COPY ./config/default /etc/nginx/http.d/default.conf

COPY ./docker-entrypoint.sh /entrypoint.sh

WORKDIR /var/www/nc

CMD ["/entrypoint.sh"]

