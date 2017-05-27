FROM armv7/armhf-debian
MAINTAINER Evgeny Golyshev <eugulixes@gmail.com>

COPY qemu-arm-static /usr/bin/qemu-arm-static

ENV NEXTCLOUD_VERSION stable12

RUN apt-get update && apt-get install -y \
    git \
    nginx \
    # Only for PHP 5.5 and up.
    php5-apcu \
    php5-curl \
    php5-gd \
    php5-fpm \
    php5-mysql \
    quilt \
    supervisor \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

RUN cd /var/www \
 && git clone -b $NEXTCLOUD_VERSION --depth 1 https://github.com/nextcloud/server.git nc

RUN cd /var/www/nc \
 && git clone -b $NEXTCLOUD_VERSION --depth 1 https://github.com/nextcloud/3rdparty.git \
 && git clone -b $NEXTCLOUD_VERSION --depth 1 https://github.com/nextcloud/apps.git apps2

RUN cd /var/www/nc/apps2 \
 && git clone -b $NEXTCLOUD_VERSION --depth 1 https://github.com/nextcloud/gallery.git

RUN cd /var/www && chown -R www-data:www-data nc

COPY ./patches /var/www/nc/patches
RUN cd /var/www/nc && quilt push -a

# Security & setup warnings:
# php does not seem to be setup properly to query system environment variables.
# The test with getenv("PATH") only returns an empty response.
RUN sed -i -e "s/;env\[PATH\]/env\[PATH\]/" /etc/php5/fpm/pool.d/www.conf \
 # Use /var/www/nc/data as both a temporary directory and data storage. When
 # files are loaded to Nextcloud, they get to the temporary directory and then
 # to the data storage. If /var/www/nc/data is located on an external device,
 # loaded files will never get to SD card. This is very good for its health.
 # upload_tmp_dir should be equal to Nginx client_body_temp_path.
 && sed -i -e "s/;upload_tmp_dir =/upload_tmp_dir = \"\/var\/www\/nc\/data\"/" /etc/php5/fpm/php.ini \
 # Nextcloud needs time to move the file to its final place (see above) after
 # upload and that can take quite some time for big files.
 # max_execution_time should be equal to Nginx fastcgi_read_timeout.
 && sed -i -e "s/max_execution_time = 30/max_execution_time = 1800/" /etc/php5/fpm/php.ini

COPY ./config/default /etc/nginx/sites-available/default
COPY ./config/supervisord.conf /etc/supervisor/supervisord.conf
COPY ./run_nginx.sh /usr/bin/run_nginx.sh

