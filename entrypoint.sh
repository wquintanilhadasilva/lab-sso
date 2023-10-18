#!/bin/sh

/usr/local/bin/importcert.sh

exec java ${JAVA_OPTS} -Djava.security.egd=file:/dev/./urandom -jar /app.war "$@"
