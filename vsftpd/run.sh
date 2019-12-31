#!/bin/sh

set -e

IP=`ip addr | grep 'state UP' -A2 | tail -n1 | awk '{print $2}' | cut -f1  -d'/'`

sed -i -e "s/{IP}/${IP}/" /etc/vsftpd/vsftpd.conf
sed -i -e "s/{PORT}/${PORT}/" /etc/vsftpd/vsftpd.conf

if [ ! -z ${USERNAME} ] && [ ! -z ${PASSWORD} ]; then
    useradd -d /ftp -K MAIL_DIR=/dev/null -m -s /bin/false ${USERNAME} || true
    encrypted_password=`mkpasswd -m sha-512 "${PASSWORD}"`
    usermod -p "${encrypted_password}" ${USERNAME}
    chown ${USERNAME}:${USERNAME} /ftp
else
    >&2 echo "either USERNAME or PASSWORD hasn't been specified"
fi

/usr/sbin/vsftpd /etc/vsftpd/vsftpd.conf

