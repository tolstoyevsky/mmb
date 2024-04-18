ARG ALPINE_VER=3.17
ARG ARIA2_DEPS="c-ares-dev ca-certificates expat-dev ffmpeg gettext-dev gnutls-dev sqlite-dev"
ARG ARIA2_PREFIX="/root/aria2"
ARG NEXTCLOUD_VER=v26.0.13
ARG YT_DLP_TARGET_PATH=/var/www/nc/apps2/ncdownloader/bin/


FROM alpine:"${ALPINE_VER}" AS build_aria2
ARG ALPINE_VER
ARG ARIA2_DEPS
ARG ARIA2_PREFIX
ENV ARIA2_VER 1.36.0
RUN echo http://mirror.yandex.ru/mirrors/alpine/v"${ALPINE_VER}"/community >> /etc/apk/repositories \
 && apk --update add \
    autoconf \
    automake \
    g++ \
    git \
    libtool \
    make \
    musl-dev \
    ${ARIA2_DEPS} \
 && cd && mkdir aria2 \
 && git clone -b release-"${ARIA2_VER}" --depth=1 https://github.com/aria2/aria2.git aria2-src \
 && cd aria2-src \
 && autoreconf -i \
 && ./configure \
        --prefix="${ARIA2_PREFIX}" \
        --sysconfdir="${ARIA2_PREFIX}"/etc \
        --mandir="${ARIA2_PREFIX}"/share/man \
        --infodir="${ARIA2_PREFIX}"/share/info \
        --localstatedir="${ARIA2_PREFIX}"/var \
        --disable-nls \
        --with-ca-bundle=/etc/ssl/certs/ca-certificates.crt \
 # Build an optional NCDownloader requirement.
 && make && make install


FROM alpine:"${ALPINE_VER}" AS download_change_ini_param_py
RUN apk --update add curl \
 && cd \
 && curl -O https://raw.githubusercontent.com/tolstoyevsky/mmb/master/utils/change_ini_param.py \
 && chmod +x change_ini_param.py


FROM alpine:"${ALPINE_VER}" AS download_yt_dlp
ENV YT_DLP_VER 2023.07.06
RUN apk --update add curl \
 && cd \
 # Download an optional NCDownloader requirement.
 && curl -OL https://github.com/yt-dlp/yt-dlp/releases/download/"${YT_DLP_VER}"/yt-dlp \
 && chmod a+rx yt-dlp


FROM node:16-alpine"${ALPINE_VER}" AS main
ARG ALPINE_VER
ARG NEXTCLOUD_VER
ENV NODE_OPTIONS "--max-old-space-size=6144"

COPY ./patches /patches

RUN echo http://mirror.yandex.ru/mirrors/alpine/v"${ALPINE_VER}"/community >> /etc/apk/repositories \
 && apk --update add \
    composer \
    git \
    nginx \
    patch \
 && mkdir -p /run/nginx \
 && cd /usr/bin \
 # Install Nextcloud
 && cd /var/www \
 && git clone -b "${NEXTCLOUD_VER}" --depth 1 https://github.com/nextcloud/server.git nc \
 && cd /var/www/nc \
 && git clone -b "${NEXTCLOUD_VER}" --depth 1 https://github.com/nextcloud/3rdparty.git \
 # Patch Nextcloud
 && mv /patches /var/www/nc/patches \
 && for patch in $(cat patches/series); do patch -p1 < patches/"${patch}"; done \
 # Build patched Nextcloud
 && >&2 echo "----- Entering to /var/www/nc" \
 && cd /var/www/nc \
 && npm i --save-dev \
 && npm run build \
 # Cleaning up
 && apk del \
    composer \
    git \
    patch \
 && find /var/www/nc -name .git | xargs rm -r \
 && rm -r node_modules \
 && rm -r /root/.npm \
 && rm -r /var/cache/apk/*

COPY ./config/avoid-security-or-privacy-risks.conf /etc/nginx/avoid-security-or-privacy-risks.conf
COPY ./config/add-misc-headers.conf /etc/nginx/add-misc-headers.conf
COPY ./config/default /etc/nginx/http.d/default.conf
COPY ./docker-entrypoint.sh /entrypoint.sh

WORKDIR /var/www/nc


FROM main
ARG ALPINE_VER
ARG ARIA2_PREFIX
ARG NEXTCLOUD_VER
ARG YT_DLP_TARGET_PATH

ENV BOOKMARKS_VER v13.1.3

ENV CALENDAR_VER v4.6.7

ENV COLLECTIVES_VER v2.1.1

ENV CONTACTS_VER v5.5.3

ENV DECK_VER v1.9.7

ENV MAIL_VER v3.5.8

ENV NCDOWNLOADER_VER v1.0.2

ENV NEWS_VER 24.0.0

ENV NEWS_UPDATER_VER 11.0.0

ENV NOTES_VER v4.9.4

ENV NOTIFY_PUSH_VER v0.6.10

ENV PASSMAN_VER 2.4.8

ENV PHOTO_SPHERE_VIEWER_VER v1.26.4

ENV SPREED_VER v16.0.11

ENV TASKS_VER v0.15.0

ENV INSTALL_DEPS_FOR "/var/www/nc/apps2/bookmarks /var/www/nc/apps2/circles /var/www/nc/apps2/collectives /var/www/nc/apps2/deck /var/www/nc/apps2/files_photospheres /var/www/nc/apps2/mail /var/www/nc/apps2/ncdownloader /var/www/nc/apps2/news /var/www/nc/apps2/text"

ENV BUILD_JS_FOR "/var/www/nc/apps2/bookmarks /var/www/nc/apps2/calendar /var/www/nc/apps2/collectives /var/www/nc/apps2/contacts /var/www/nc/apps2/deck /var/www/nc/apps2/mail /var/www/nc/apps2/ncdownloader /var/www/nc/apps2/news/js /var/www/nc/apps2/notes /var/www/nc/apps2/notifications /var/www/nc/apps2/photos /var/www/nc/apps2/spreed /var/www/nc/apps2/tasks"

# For building the Spreed app
ENV NODE_OPTIONS "--max-old-space-size=6144"

RUN echo http://mirror.yandex.ru/mirrors/alpine/v"${ALPINE_VER}"/community >> /etc/apk/repositories \
 && apk --update add \
    bash \
    composer \
    g++ \
    git \
    make \
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
    php81-pdo_sqlite \
    php81-posix \
    php81-session \
    php81-simplexml \
    php81-sqlite3 \
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
    ${ARIA2_DEPS} \
 && cd /var/www/nc \
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
 && git clone -b "${NCDOWNLOADER_VER}"        --depth 1 https://github.com/shiningw/ncdownloader \
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
 && for dir in ${INSTALL_DEPS_FOR}; do >&2 echo "----- Entering to ${dir}"; cd "${dir}"; composer install --no-dev; done \
 \
 #
 # Create the directory for yt-dlp.
 # Install the mandatory NCDownloader requirement.
 #
 && mkdir ${YT_DLP_TARGET_PATH} \
 && npm install @nextcloud/browserslist-config --save-dev \
 #
 # Build Nextcloud apps.
 #
 && for dir in ${BUILD_JS_FOR}; do >&2 echo "----- Entering to ${dir}"; cd "${dir}"; npm i; npm run svg_sprite 2> /dev/null || true; npm run build; done \
 \
 && chown -R nginx:nginx /var/www \
 \
 && pip3 install nextcloud-news-updater=="${NEWS_UPDATER_VER}" \
 # Cleanup
 && apk del \
    composer \
    git \
    make \
    py3-pip \
 && find /var/www/nc -name .git | xargs rm -r \
 && find /var/www/nc -name node_modules | xargs rm -rf \
 && rm -r /root/.cache \
 && rm -r /root/.composer \
 && rm -r /root/.npm \
 && rm -r /var/cache/apk/*

COPY --from=build_aria2 "${ARIA2_PREFIX}" /usr/

COPY --from=download_change_ini_param_py /root/change_ini_param.py /usr/bin/

COPY --from=download_yt_dlp /root/yt-dlp ${YT_DLP_TARGET_PATH}

CMD ["/entrypoint.sh"]

