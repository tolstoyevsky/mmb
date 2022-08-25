#!/bin/bash

set -x

export ALIAS="${ALIAS:=""}"

export COMPANY_NAME="${COMPANY_NAME:=""}"

export CONNECT_ATTEMPTS="${CONNECT_ATTEMPTS:="5"}"

export HELLO_RESPONSE="${HELLO_RESPONSE:="Hello my friend"}"

export ROCKET_CHAT_API="${ROCKET_CHAT_API}"

export PASSWORD="${PASSWORD}"

export USER_NAME="${USER_NAME}"

export TIME_ZONE="${TIME_ZONE:="Europe/Moscow"}"

export PG_HOST="${PG_HOST:="127.0.0.1"}"

export PG_NAME="${PG_NAME:="postgres"}"

export PG_PASSWORD="${PG_PASSWORD:="secret"}"

export PG_PORT="${PG_PORT:="5432"}"

export PG_USER="${PG_USER:="postgres"}"

export BIRTHDAY_CHANNEL_TTL="${BIRTHDAY_CHANNEL_TTL:="3"}"

export BIRTHDAY_LOGGING_CHANNEL="${BIRTHDAY_LOGGING_CHANNEL:=""}"

export CHECK_USERS_AVATARS="${CHECK_USERS_AVATARS:=""}"

export CREATE_BIRTHDAY_CHANNELS="${CREATE_BIRTHDAY_CHANNELS:=""}"

export COMPANY_NAME="${COMPANY_NAME:="CusDeb Solutions"}"

export GREETINGS_RESPONSE="${GREETINGS_RESPONSE:="Welcome to ${COMPANY_NAME}!"}"

export HB_CRONTAB="${HB_CRONTAB:="0 0 7 * * *"}"

export NOTIFY_SET_AVATAR="${NOTIFY_SET_AVATAR:="Oh, I see you didn't set avatar!
Please, do it as soon as possible. :grin:"}"

export NOTIFY_SET_BIRTH_DATE="${NOTIFY_SET_BIRTH_DATE:="Hmm…\nIt looks like you forgot to set the date of birth.\nPlease enter it (DD.MM.YYYY)."}"

export NUMBER_OF_DAYS_IN_ADVANCE="${NUMBER_OF_DAYS_IN_ADVANCE:="7"}"

export PERSONS_WITHOUT_BIRTHDAY_RESPONSE="${PERSONS_WITHOUT_BIRTHDAY_RESPONSE:="These persons did not provide date of birth."}"

export SET_BIRTHDAY_RESPONSE="${SET_BIRTHDAY_RESPONSE:="I memorized you birthday, well done! :wink:"}"

export CONGRATULATION_PHRASES="${CONGRATULATION_PHRASES:=""}"

export TENOR_API_KEY="${TENOR_API_KEY}"

export TENOR_API_URL="${TENOR_API_URL:="https://api.tenor.com/v1/"}"

export TENOR_IMAGE_LIMIT="${TENOR_IMAGE_LIMIT:="5"}"

export TENOR_SEARCH_TERM="${TENOR_SEARCH_TERM:=""}"

export TENOR_BLACKLISTED_GIF_IDS="${TENOR_BLACKLISTED_GIF_IDS:=""}"

export RESPOND_TO_DM="${RESPOND_TO_DM:="false"}"

export CUSTOM_HOLIDAYS="${CUSTOM_HOLIDAYS:=""}"

export HOLIDAYS_CRONTAB_WEEK_BEFORE="${HOLIDAYS_CRONTAB_WEEK_BEFORE:="0 0 7 * * *"}"

export HOLIDAYS_CRONTAB_DAY_BEFORE="${HOLIDAYS_CRONTAB_DAY_BEFORE:="0 0 18 * * *"}"

set +x

ln -snf /usr/share/zoneinfo/"${TIME_ZONE}" /etc/localtime

>&2 echo "Waiting for PostgreSQL"

/var/www/wait-for-it.sh  -h "${PG_HOST}" -p "${PG_PORT}" -t 90 -- >&2 echo "PostgreSQL for ${PG_NAME} is ready"

cd apps/happy_birthder

env PYTHONPATH=$(pwd)/../.. python3 ini_config.py

env PYTHONPATH=$(pwd)/../.. alembic upgrade head

cd ../..

env PYTHONPATH=$(pwd) python3 manage.py
