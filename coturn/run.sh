#!/bin/sh

cp /usr/share/examples/turnserver/etc/turnserver.conf /etc/turnserver.conf

sed -i -e "s/#listening-ip=172.17.19.101/listening-ip=0.0.0.0/" /etc/turnserver.conf

sed -i -e "s/#listening-port=3478/listening-port=${PORT}/" /etc/turnserver.conf
sed -i -e "s/#tls-listening-port=5349/tls-listening-port=${TLS_PORT}/" /etc/turnserver.conf

if [ ! -z ${REALM} ]; then
    sed -i -e "s/#realm=realm/realm=${REALM}/" /etc/turnserver.conf
fi

if [ ! -z ${AUTH_SECRET} ]; then
    sed -i -e "s/#use-auth-secret/use-auth-secret/" /etc/turnserver.conf
    sed -i -e "s/#static-auth-secret=north/static-auth-secret=${AUTH_SECRET}/" /etc/turnserver.conf
fi

sed -i -e "s/#cert=\/usr\/local\/etc\/turn_server_cert.pem/\/etc\/turn_server_cert.pem/" /etc/turnserver.conf
sed -i -e "s/#pkey=\/usr\/local\/etc\/turn_server_pkey.pem/\/etc\/turn_server_pkey.pem/" /etc/turnserver.conf

turnserver

