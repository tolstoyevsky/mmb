#!/bin/sh

set -e

printf "[dn]\nCN=coturn\n[req]\ndistinguished_name = dn\n[EXT]\nsubjectAltName=DNS:coturn\nkeyUsage=digitalSignature\nextendedKeyUsage=serverAuth" > openssl_config.cnf

openssl req -x509 -out /turn_server_cert.pem -keyout /turn_server_pkey.pem \
  -newkey rsa:2048 -nodes -sha256 \
  -subj '/CN=coturn' -extensions EXT -config openssl_config.cnf

rm -f openssl_config.cnf

chown nobody:nobody /turn_server_cert.pem
chown nobody:nobody /turn_server_pkey.pem

sudo -u nobody turnserver --min-port=49160 --max-port=49200
