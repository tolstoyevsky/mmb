FROM alpine:3.20

LABEL maintainer="Evgeny Golyshev <eugulixes@gmail.com>"

ENV MEDIAWIKI_VERSION REL1_42

RUN echo http://mirror.yandex.ru/mirrors/alpine/v3.20/community >> /etc/apk/repositories \
 && apk --update add \
    bash \
    curl \
    git \
    mysql-client \
    nginx \
    php83 \
    php83-ctype \
    php83-curl \
    php83-dom \
    php83-fileinfo \
    php83-fpm \
    php83-gd \
    php83-iconv \
    php83-intl \
    php83-json \
    php83-mbstring \
    php83-mysqli \
    php83-pecl-apcu \
    php83-session \
    php83-xml \
    php83-xmlreader \
    python3 \
    supervisor \
 && cd /usr/bin \
 && curl -O https://raw.githubusercontent.com/tolstoyevsky/mmb/master/utils/change_ini_param.py \
 && chmod +x /usr/bin/change_ini_param.py \
 && cd /var/www \
 && git clone -b $MEDIAWIKI_VERSION --depth 1 https://github.com/wikimedia/mediawiki.git w \
 # Installing some external dependencies (e.g. via composer) is required.
 # See https://www.mediawiki.org/wiki/Download_from_Git#Fetch_external_libraries
 && cd /var/www/w \
 && git clone -b $MEDIAWIKI_VERSION --depth 1 https://github.com/wikimedia/mediawiki-vendor.git vendor \
 # The default skin must be installed explicitly
 && cd /var/www/w/skins \
 && git clone -b $MEDIAWIKI_VERSION --depth 1 https://github.com/wikimedia/mediawiki-skins-Vector.git vector \
 # Install the extensions
 && cd /var/www/w/extensions \
 && git clone -b $MEDIAWIKI_VERSION --depth 1 https://github.com/wikimedia/mediawiki-extensions-VisualEditor.git VisualEditor \
 && git clone -b $MEDIAWIKI_VERSION --depth 1 https://github.com/wikimedia/mediawiki-extensions-Cite.git Cite \
 && git clone -b $MEDIAWIKI_VERSION --depth 1 https://github.com/wikimedia/mediawiki-extensions-Collection.git Collection \
 && git clone -b $MEDIAWIKI_VERSION --depth 1 https://github.com/wikimedia/mediawiki-extensions-MobileFrontend.git MobileFrontend \
 && git clone -b $MEDIAWIKI_VERSION --depth 1 https://github.com/wikimedia/mediawiki-extensions-SyntaxHighlight_GeSHi.git SyntaxHighlight_GeSHi \
 && git clone -b $MEDIAWIKI_VERSION --depth 1 https://github.com/wikimedia/mediawiki-extensions-Translate.git Translate \
 && git clone -b $MEDIAWIKI_VERSION --depth 1 https://github.com/wikimedia/mediawiki-extensions-UniversalLanguageSelector.git UniversalLanguageSelector \
 && cd VisualEditor \
 && git submodule update --init \
 && cd /var/www && chown -R nginx:nginx w \
 && curl -O https://raw.githubusercontent.com/vishnubob/wait-for-it/master/wait-for-it.sh \
 && chmod +x wait-for-it.sh \
 && mv wait-for-it.sh /usr/local/bin \
 # The client requests Vector when we've got only vector, so fix it
 && cd  w/skins \
 && rm -r Vector \
 && ln -s vector Vector \
 # Cleanup
 && apk del \
    curl \
    git \
 && rm -rf /var/cache/apk/*

COPY ./config/LocalSettings.php ./config/logos.ph[p] ./config/namespaces.ph[p] /var/www/w/

COPY ./config/default /etc/nginx/http.d/default.conf

COPY ./config/supervisord.conf /etc/supervisor/supervisord.conf

COPY ./rollout_fixes.sh /usr/bin/rollout_fixes.sh

COPY ./docker-entrypoint.sh /usr/bin/docker-entrypoint.sh

COPY ./logos/ /var/www/w/resources/assets/

RUN /usr/bin/rollout_fixes.sh

WORKDIR /var/www/w

CMD ["docker-entrypoint.sh"]

