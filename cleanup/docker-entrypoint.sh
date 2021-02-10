#!/bin/sh

CRON_SCHEDULE=${CRON_SCHEDULE:='0 12 * * 6'}

sed -i -e "s/CRON_SCHEDULE/${CRON_SCHEDULE}/" /var/spool/cron/crontabs/root

>&2 echo "Start cleanup container"

crond -L /var/log/cron.log

>&2 echo "Start writing logs"
while true; do
    cat /var/log/cron.log & wait $!
done
