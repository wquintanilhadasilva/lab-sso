#!/bin/sh

set -eu

openssl pkcs12 -export \
    -in /etc/letsencrypt/production/certs/ssl/fullchain.pem \
    -inkey /etc/letsencrypt/production/certs/ssl/privkey.pem \
    -out /etc/cas/thekeystore \
    -name sso-ssl \
    -passout pass:${SSO_SSL_KEYSTORE_PASSWORD}
