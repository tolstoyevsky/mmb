ARG ALPINE_VER=3.24
ARG NEXTCLOUD_VER=v31.0.14
# Talk High Performance Backend: external signaling server + NATS message bus.
ARG SIGNALING_VER=v2.1.1
ARG NATS_VER=v2.14.6
ARG NATS_SHA256=61c3d55f69f61ec616b75782250936445f2819e9e5f2ae6159b10a31abd2200c


FROM alpine:"${ALPINE_VER}" AS download_change_ini_param_py
RUN apk --update add curl \
 && cd \
 && curl -O https://raw.githubusercontent.com/tolstoyevsky/mmb/master/utils/change_ini_param.py \
 && chmod +x change_ini_param.py


# Build the Talk High Performance Backend signaling server from source
# (no prebuilt binary is published). `make server` needs only go/bash/git/make.
# Built on Alpine (go from the distro) rather than the golang image so the build
# depends only on the same base image and mirror the rest of the image uses.
FROM alpine:"${ALPINE_VER}" AS build_signaling
ARG ALPINE_VER
ARG SIGNALING_VER
RUN echo http://mirror.yandex.ru/mirrors/alpine/v"${ALPINE_VER}"/community >> /etc/apk/repositories \
 && apk --update add bash git go make \
 && git clone -b "${SIGNALING_VER}" --depth 1 https://github.com/strukturag/nextcloud-spreed-signaling.git /src \
 && cd /src \
 && make server \
 && cp bin/signaling /nextcloud-spreed-signaling


# Fetch the NATS message bus used by the signaling server (prebuilt release).
FROM alpine:"${ALPINE_VER}" AS download_nats
ARG NATS_VER
ARG NATS_SHA256
RUN apk --update add curl \
 && cd \
 && curl -fsSL "https://github.com/nats-io/nats-server/releases/download/${NATS_VER}/nats-server-${NATS_VER}-linux-amd64.tar.gz" -o nats.tar.gz \
 && echo "${NATS_SHA256}  nats.tar.gz" | sha256sum -c \
 && tar xzf nats.tar.gz \
 && cp "nats-server-${NATS_VER}-linux-amd64/nats-server" /nats-server \
 && chmod +x /nats-server


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
ARG NEXTCLOUD_VER

ENV BOOKMARKS_VER v15.2.1

ENV CALENDAR_VER v5.5.22

ENV COLLECTIVES_VER v3.6.2

ENV CONTACTS_VER v7.3.18

ENV DECK_VER v1.15.9

ENV NEWS_VER 27.2.0

ENV NEWS_UPDATER_VER 11.0.0

ENV NOTES_VER v5.0.2

ENV NOTIFY_PUSH_VER v1.3.4

ENV PASSMAN_VER 2.5.1

ENV PASSWORDS_VER 2025.10.0

ENV PHOTO_SPHERE_VIEWER_VER v1.31.1

ENV SPREED_VER v21.1.11

ENV TASKS_VER v0.18.1

ENV INSTALL_DEPS_FOR "/var/www/nc/apps2/bookmarks /var/www/nc/apps2/calendar /var/www/nc/apps2/contacts /var/www/nc/apps2/circles /var/www/nc/apps2/collectives /var/www/nc/apps2/photos /var/www/nc/apps2/deck /var/www/nc/apps2/files_photospheres /var/www/nc/apps2/spreed /var/www/nc/apps2/news /var/www/nc/apps2/text /var/www/nc/apps2/viewer"

ENV BUILD_JS_FOR "/var/www/nc/apps2/bookmarks /var/www/nc/apps2/calendar /var/www/nc/apps2/collectives /var/www/nc/apps2/contacts /var/www/nc/apps2/deck /var/www/nc/apps2/news /var/www/nc/apps2/notes /var/www/nc/apps2/notifications /var/www/nc/apps2/photos /var/www/nc/apps2/spreed /var/www/nc/apps2/tasks"

# For building the Spreed app
ENV NODE_OPTIONS "--max-old-space-size=6144"

RUN echo http://mirror.yandex.ru/mirrors/alpine/v"${ALPINE_VER}"/community >> /etc/apk/repositories \
 && apk --update add \
    bash \
    composer \
    g++ \
    git \
    make \
    patch \
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
 && cd /var/www/nc \
 && mkdir apps2 && cd apps2 \
 && git clone -b "${BOOKMARKS_VER}"           --depth 1 https://github.com/nextcloud/bookmarks.git \
 && git clone -b "${CALENDAR_VER}"            --depth 1 https://github.com/nextcloud/calendar.git \
 && git clone -b "${NEXTCLOUD_VER}"           --depth 1 https://github.com/nextcloud/circles.git \
 && git clone -b "${COLLECTIVES_VER}"         --depth 1 https://github.com/nextcloud/collectives.git \
 && git clone -b "${CONTACTS_VER}"            --depth 1 https://github.com/nextcloud/contacts.git \
 && git clone -b "${DECK_VER}"                --depth 1 https://github.com/nextcloud/deck.git \
 && git clone -b "${NEXTCLOUD_VER}"           --depth 1 https://github.com/nextcloud/files_pdfviewer.git \
 && git clone -b "${PHOTO_SPHERE_VIEWER_VER}" --depth 1 https://github.com/nextcloud/files_photospheres.git \
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
 # The Passwords app is distributed only as a prebuilt release tarball (not a Git repo);
 # download and unpack it into apps2. It is already built, so it needs no composer/npm step.
 && wget -q "https://git.mdns.eu/api/v4/projects/45/packages/generic/passwords/${PASSWORDS_VER}/passwords.tar.gz" \
 && tar xzf passwords.tar.gz \
 && rm passwords.tar.gz \
 \
 # A failing breach check (default HIBP) must not abort password create/share sync,
 # otherwise a shared password hangs forever on "updatePending". Make the check non-fatal.
 && patch -p1 -d /var/www/nc/apps2/passwords < /var/www/nc/patches/passwords-breach-check-nonfatal.patch \
 \
 # Bookmarks ships no composer.lock and caps composer at PHP 8.1 via config.platform,
 # but its nextcloud/ocp dev-master dependency requires PHP >= 8.3 — the two conflict,
 # composer install fails and the link-preview dependency ends up missing (app 500s).
 # Raise the platform cap to the PHP version this image actually runs so ocp resolves.
 && sed -i 's#"php": "8.1.31"#"php": "8.3.19"#' /var/www/nc/apps2/bookmarks/composer.json \
 \
 # Composer 2.10 (Alpine 3.24) blocks installs on security advisories; the pinned upstream
 # apps carry such deps (e.g. bookmarks -> symfony/dom-crawler 3.x) and won't resolve otherwise.
 && php83 /usr/bin/composer.phar config --global policy.advisories.block false \
 && for dir in ${INSTALL_DEPS_FOR}; do >&2 echo "----- Entering to ${dir}"; cd "${dir}"; php83 /usr/bin/composer.phar install --no-dev; done \
 \
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
    patch \
    py3-pip \
 && find /var/www/nc -name .git | xargs rm -r \
 && find /var/www/nc -name node_modules | xargs rm -rf \
 && rm -r /root/.cache \
 && rm -r /root/.composer \
 && rm -rf /root/.config/composer \
 && rm -r /root/.npm \
 && rm -r /var/cache/apk/*

COPY --from=download_change_ini_param_py /root/change_ini_param.py /usr/bin/

# Talk High Performance Backend binaries (run as TYPE=signaling / TYPE=nats).
COPY --from=build_signaling /nextcloud-spreed-signaling /usr/bin/nextcloud-spreed-signaling
COPY --from=download_nats /nats-server /usr/bin/nats-server

CMD ["/entrypoint.sh"]

