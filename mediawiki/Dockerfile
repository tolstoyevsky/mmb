FROM cusdeb/stretch:amd64
MAINTAINER Evgeny Golyshev <eugulixes@gmail.com>

ENV MEDIAWIKI_VERSION REL1_31

RUN apt-get update \
 && apt-get install -y \
    curl \
    git \
    mysql-client \
    nginx \
    php-apcu \
    php-curl \
    php-fpm \
    php-gd \
    php-intl \
    php-mbstring \
    php-mysql \
    php-xml \
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
 # Do the same thing for SyntaxHighlight_GeSHi
 && cd /var/www/w/extensions \
 && git clone -b $MEDIAWIKI_VERSION --depth 1 https://gerrit.wikimedia.org/r/p/mediawiki/extensions/SyntaxHighlight_GeSHi.git SyntaxHighlight_GeSHi \ 
 && cd /var/www && chown -R www-data:www-data w \
 && curl -O https://raw.githubusercontent.com/vishnubob/wait-for-it/master/wait-for-it.sh \
 && chmod +x wait-for-it.sh \
 && mv wait-for-it.sh /usr/local/bin \
 # Cleanup
 && apt-get clean \
 && apt-get purge -y \
    curl \
    git \
 && rm -rf /var/lib/apt/lists/*

COPY ./config/LocalSettings.php /var/www/w

COPY ./config/default /etc/nginx/sites-available/default

COPY ./config/supervisord.conf /etc/supervisor/supervisord.conf

COPY ./rollout_fixes.sh /usr/bin/rollout_fixes.sh

COPY ./docker-entrypoint.sh /usr/bin/docker-entrypoint.sh

RUN /usr/bin/rollout_fixes.sh

CMD ["docker-entrypoint.sh"]

