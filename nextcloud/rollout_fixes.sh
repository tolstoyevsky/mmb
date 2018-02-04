#!/bin/sh

cd /var/www/nc && for i in `cat patches/series`; do patch -p1 < patches/${i}; done

# Fixes
# *** stack smashing detected ***: nginx: worker process terminated
sed -i "s/worker_processes auto;/worker_processes 1;/g" /etc/nginx/nginx.conf

# The directory is necessary for php-fpm, but it does not exist in the container.
mkdir /run/php

# PHP does not seem to be setup properly to query system environment variables. The test with getenv("PATH") only returns an empty response.
sed -i -e "s/;env\[PATH\]/env\[PATH\]/" /etc/php/7.0/fpm/pool.d/www.conf

# The PHP OPcache is not properly configured. For better performance it is recommended to use the following settings in the php.ini:
# opcache.enable=1
# opcache.enable_cli=1
# opcache.interned_strings_buffer=8
# opcache.max_accelerated_files=10000
# opcache.memory_consumption=128
# opcache.save_comments=1
# opcache.revalidate_freq=1
sed -i -e "s/;opcache.enable=0/opcache.enable=1/" /etc/php/7.0/fpm/php.ini
sed -i -e "s/;opcache.enable_cli=0/opcache.enable_cli=1/" /etc/php/7.0/fpm/php.ini
sed -i -e "s/;opcache.interned_strings_buffer=4/opcache.interned_strings_buffer=8/" /etc/php/7.0/fpm/php.ini
sed -i -e "s/;opcache.max_accelerated_files=2000/opcache.max_accelerated_files=10000/" /etc/php/7.0/fpm/php.ini
sed -i -e "s/;opcache.memory_consumption=64/opcache.memory_consumption=128/" /etc/php/7.0/fpm/php.ini
sed -i -e "s/;opcache.save_comments=1/opcache.save_comments=1/" /etc/php/7.0/fpm/php.ini
sed -i -e "s/;opcache.revalidate_freq=2/opcache.revalidate_freq=1/" /etc/php/7.0/fpm/php.ini

# Use /var/www/nc/data as both a temporary directory and data storage. When
# files are loaded to Nextcloud, they get to the temporary directory and then
# to the data storage. If /var/www/nc/data is located on an external device,
# loaded files will never get to SD card. This is very good for its health.
# upload_tmp_dir should be equal to Nginx client_body_temp_path.
sed -i -e "s/;upload_tmp_dir =/upload_tmp_dir = \"\/var\/www\/nc\/data\"/" /etc/php/7.0/fpm/php.ini \

# Nextcloud needs time to move the file to its final place (see above) after
# upload and that can take quite some time for big files.
# max_execution_time should be equal to Nginx fastcgi_read_timeout.
sed -i -e "s/max_execution_time = 30/max_execution_time = 1800/" /etc/php/7.0/fpm/php.ini

