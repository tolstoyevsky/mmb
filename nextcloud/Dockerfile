ARG ALPINE_VER=3.24
ARG ARIA2_DEPS="c-ares-dev ca-certificates expat-dev ffmpeg gettext-dev gnutls-dev sqlite-dev"
ARG ARIA2_PREFIX="/root/aria2"
ARG NEXTCLOUD_VER=v31.0.14
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


FROM node:22-alpine"${ALPINE_VER}" AS main
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

ENV BOOKMARKS_VER v15.2.1

ENV CALENDAR_VER v5.5.22

ENV COLLECTIVES_VER v3.6.2

ENV CONTACTS_VER v7.3.18

ENV DECK_VER v1.15.9

ENV MAIL_VER v5.6.21

ENV NCDOWNLOADER_VER v1.0.24

ENV NEWS_VER 27.2.0

ENV NEWS_UPDATER_VER 11.0.0

ENV NOTES_VER v5.0.2

ENV NOTIFY_PUSH_VER v1.3.4

ENV PASSMAN_VER 2.5.1

ENV PASSWORDS_VER 2025.10.0

ENV PHOTO_SPHERE_VIEWER_VER v1.31.1

ENV SPREED_VER v21.1.11

ENV TASKS_VER v0.18.1

ENV INSTALL_DEPS_FOR "/var/www/nc/apps2/circles /var/www/nc/apps2/photos /var/www/nc/apps2/text /var/www/nc/apps2/viewer"

ENV BUILD_JS_FOR "/var/www/nc/apps2/notifications /var/www/nc/apps2/photos"

# For building the Spreed app
ENV NODE_OPTIONS "--max-old-space-size=6144"

RUN echo http://mirror.yandex.ru/mirrors/alpine/v"${ALPINE_VER}"/community >> /etc/apk/repositories \
 && apk --update add \
    bash \
    composer \
    g++ \
    git \
    make \
    php83 \
 # required modules
    php83-ctype \
    php83-curl \
    php83-dom \
    php83-fpm \
    php83-gd \
    php83-iconv \
    php83-json \
    php83-mbstring \
    php83-openssl \
    # phar so Composer runs under php83 (Alpine 3.24 ships Composer against php85, which lacks our modules)
    php83-phar \
    # for nextcloud-news-updater
    php83-pcntl \
    php83-pdo \
    php83-pdo_mysql \
    php83-pdo_sqlite \
    php83-posix \
    php83-session \
    php83-simplexml \
    php83-sqlite3 \
    php83-tokenizer \
    php83-xml \
    php83-xmlreader \
    php83-xmlwriter \
    php83-zip \
 # recommended modules
    php83-bcmath \
    php83-fileinfo \
    php83-gmp \
    php83-intl \
    php83-opcache \
    php83-pecl-apcu \
    php83-pecl-imagick \
    php83-pecl-redis \
    \
    python3 \
    py3-pip \
    # For nextcloud-news-updater to run it as nginx user
    sudo \
    ${ARIA2_DEPS} \
 && cd /var/www/nc \
 && mkdir apps2 && cd apps2 \
 # Apps bundled with the server release but absent from the server Git tree — clone
 # at the server version. These still get a composer/npm build step below.
 && git clone -b "${NEXTCLOUD_VER}" --depth 1 https://github.com/nextcloud/circles.git \
 && git clone -b "${NEXTCLOUD_VER}" --depth 1 https://github.com/nextcloud/files_pdfviewer.git \
 && git clone -b "${NEXTCLOUD_VER}" --depth 1 https://github.com/nextcloud/notifications.git \
 && git clone -b "${NEXTCLOUD_VER}" --depth 1 https://github.com/nextcloud/photos.git \
 && git clone -b "${NEXTCLOUD_VER}" --depth 1 https://github.com/nextcloud/text.git \
 && git clone -b "${NEXTCLOUD_VER}" --depth 1 https://github.com/nextcloud/viewer.git \
 && git clone -b "${PASSMAN_VER}"   --depth 1 https://github.com/nextcloud/passman.git \
 \
 # App Store apps: fetch the PREBUILT release tarball — built JS and vendor/ are
 # already inside, so no composer/npm is needed for these. The release org
 # (nextcloud-releases vs the app's own repo) and the asset filename differ per
 # app, so each URL is spelled out. Every tarball unpacks to its own app dir.
 # wget is wrapped in a retry loop (transient GitHub/CDN timeouts are common).
 && for url in \
      "https://github.com/nextcloud-releases/calendar/releases/download/${CALENDAR_VER}/calendar-${CALENDAR_VER}.tar.gz" \
      "https://github.com/nextcloud-releases/contacts/releases/download/${CONTACTS_VER}/contacts-${CONTACTS_VER}.tar.gz" \
      "https://github.com/nextcloud-releases/deck/releases/download/${DECK_VER}/deck-${DECK_VER}.tar.gz" \
      "https://github.com/nextcloud-releases/mail/releases/download/${MAIL_VER}/mail-${MAIL_VER}.tar.gz" \
      "https://github.com/nextcloud-releases/notes/releases/download/${NOTES_VER}/notes-${NOTES_VER}.tar.gz" \
      "https://github.com/nextcloud-releases/spreed/releases/download/${SPREED_VER}/spreed-${SPREED_VER}.tar.gz" \
      "https://github.com/nextcloud-releases/notify_push/releases/download/${NOTIFY_PUSH_VER}/notify_push-${NOTIFY_PUSH_VER}.tar.gz" \
      "https://github.com/nextcloud/bookmarks/releases/download/${BOOKMARKS_VER}/bookmarks-${BOOKMARKS_VER#v}.tar.gz" \
      "https://github.com/nextcloud/collectives/releases/download/${COLLECTIVES_VER}/collectives-${COLLECTIVES_VER#v}.tar.gz" \
      "https://github.com/nextcloud/news/releases/download/${NEWS_VER}/news.tar.gz" \
      "https://github.com/nextcloud/tasks/releases/download/${TASKS_VER}/tasks.tar.gz" \
      "https://github.com/nextcloud/files_photospheres/releases/download/${PHOTO_SPHERE_VIEWER_VER}/files_photospheres.tar.gz" \
      "https://github.com/shiningw/ncdownloader/releases/download/${NCDOWNLOADER_VER}/ncdownloader-release.tar.gz" \
      "https://git.mdns.eu/api/v4/projects/45/packages/generic/passwords/${PASSWORDS_VER}/passwords.tar.gz" ; do \
        n=0; until wget -q "${url}"; do n=$((n+1)); [ "$n" -ge 5 ] && echo "download failed: ${url}" && exit 1; echo "retry $n: ${url}"; sleep 5; done; \
      done \
 && for t in *.tar.gz; do tar xzf "$t" && rm "$t"; done \
 \
 # Install PHP deps for the still-from-source (server-bundled) apps. Composer runs
 # under php83 (Alpine 3.24 ships Composer against php85, which lacks our modules).
 && for dir in ${INSTALL_DEPS_FOR}; do >&2 echo "----- Entering to ${dir}"; cd "${dir}"; php83 /usr/bin/composer.phar install --no-dev; done \
 \
 #
 # Create the directory for yt-dlp.
 # Install the mandatory NCDownloader requirement.
 #
 && mkdir -p ${YT_DLP_TARGET_PATH} \
 && npm install @nextcloud/browserslist-config --save-dev \
 #
 # Build Nextcloud apps.
 #
 && for dir in ${BUILD_JS_FOR}; do >&2 echo "----- Entering to ${dir}"; cd "${dir}"; npm i; npm run svg_sprite 2> /dev/null || true; npm run build; done \
 \
 && chown -R nginx:nginx /var/www \
 \
 && pip3 install --break-system-packages nextcloud-news-updater=="${NEWS_UPDATER_VER}" \
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
 && rm -rf /root/.config/composer \
 && rm -r /root/.npm \
 && rm -r /var/cache/apk/*

COPY --from=build_aria2 "${ARIA2_PREFIX}" /usr/

COPY --from=download_change_ini_param_py /root/change_ini_param.py /usr/bin/

COPY --from=download_yt_dlp /root/yt-dlp ${YT_DLP_TARGET_PATH}

CMD ["/entrypoint.sh"]

