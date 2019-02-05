#!/bin/sh

# The directories are necessary for nginx and php-fpm, but they do not exist in the container.
mkdir /run/nginx
mkdir /run/php

