#!/bin/sh

echo "Importando certificado SSO!!!"

FILES=/certs/*
ITER=0
for f in $FILES
do
    echo "Processing $f file..."
    keytool -importcert -keystore $JAVA_HOME/lib/security/cacerts -storepass changeit -alias "certs-import$ITER" -file $f -noprompt || echo "Falhou arquivo $f"
    ITER=$(expr $ITER + 1)
done
