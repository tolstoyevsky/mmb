#!/bin/sh
sed -i -e "s/PORT/${PORT}/" /etc/nginx/sites-available/default
nginx -g 'daemon off;'
