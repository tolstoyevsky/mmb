FROM alpine:3.13
MAINTAINER Evgeny Golyshev <eugulixes@gmail.com>

ENV MEDIAWIKI_VERSION REL1_35

RUN echo http://mirror.yandex.ru/mirrors/alpine/v3.13/community >> /etc/apk/repositories \
 && apk --update add \
    bash \
    curl \
    git \
    mysql-client \
    nginx \
    php7 \
    php7-ctype \
    php7-curl \
    php7-dom \
    php7-fileinfo \
    php7-fpm \
    php7-gd \
    php7-iconv \
    php7-intl \
    php7-json \
    php7-mbstring \
    php7-mysqli \
    php7-pecl-apcu \
    php7-session \
    php7-xml \
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
 && cd /var/www/w/extensions \
 # Install VisualEditor from the original git repo because the GitHub mirror doesn't work.
 && git clone -b $MEDIAWIKI_VERSION --depth 1 https://gerrit.wikimedia.org/r/p/mediawiki/extensions/VisualEditor.git VisualEditor \
 && cd VisualEditor \
 && git submodule update --init \
 # Do the same thing for Cite and SyntaxHighlight_GeSHi
 && cd /var/www/w/extensions \
 && git clone -b $MEDIAWIKI_VERSION --depth 1 https://gerrit.wikimedia.org/r/p/mediawiki/extensions/Cite.git Cite \ 
 && git clone -b $MEDIAWIKI_VERSION --depth 1 https://gerrit.wikimedia.org/r/p/mediawiki/extensions/Collection.git Collection \
 && git clone -b $MEDIAWIKI_VERSION --depth 1 https://gerrit.wikimedia.org/r/p/mediawiki/extensions/MobileFrontend.git MobileFrontend \
 && git clone -b $MEDIAWIKI_VERSION --depth 1 https://gerrit.wikimedia.org/r/p/mediawiki/extensions/SyntaxHighlight_GeSHi.git SyntaxHighlight_GeSHi \
 && git clone -b $MEDIAWIKI_VERSION --depth 1 https://gerrit.wikimedia.org/r/p/mediawiki/extensions/Translate.git Translate \
 && git clone -b $MEDIAWIKI_VERSION --depth 1 https://gerrit.wikimedia.org/r/p/mediawiki/extensions/UniversalLanguageSelector.git UniversalLanguageSelector \
 && cd /var/www && chown -R nginx:nginx w \
 && curl -O https://raw.githubusercontent.com/vishnubob/wait-for-it/master/wait-for-it.sh \
 && chmod +x wait-for-it.sh \
 && mv wait-for-it.sh /usr/local/bin \
 # Cleanup
 && apk del \
    curl \
    git \
 && rm -rf /var/cache/apk/*

COPY ./config/LocalSettings.php /var/www/w

COPY ./config/default /etc/nginx/conf.d/default.conf

COPY ./config/fastcgi-php.conf /etc/nginx/fastcgi-php.conf

COPY ./config/supervisord.conf /etc/supervisor/supervisord.conf

COPY ./rollout_fixes.sh /usr/bin/rollout_fixes.sh

COPY ./docker-entrypoint.sh /usr/bin/docker-entrypoint.sh

RUN /usr/bin/rollout_fixes.sh

CMD ["docker-entrypoint.sh"]

