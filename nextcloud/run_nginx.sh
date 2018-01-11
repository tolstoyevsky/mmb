#!/bin/sh

sed -i -e "s/{DB_HOST}/${DB_HOST}/" /etc/php/7.0/fpm/pool.d/www.conf
sed -i -e "s/{DB_NAME}/${DB_NAME}/" /etc/php/7.0/fpm/pool.d/www.conf
sed -i -e "s/{DB_USERNAME}/${DB_USERNAME}/" /etc/php/7.0/fpm/pool.d/www.conf
sed -i -e "s/{DB_PASSWORD}/${DB_PASSWORD}/" /etc/php/7.0/fpm/pool.d/www.conf

sed -i -e "s/PORT/${PORT}/" /etc/nginx/sites-available/default
nginx -g 'daemon off;'
