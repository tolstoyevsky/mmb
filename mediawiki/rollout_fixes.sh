#!/bin/sh

# The directory is necessary for php-fpm, but it does not exist in the container.
mkdir /run/php

