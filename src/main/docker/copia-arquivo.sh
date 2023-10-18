#!/bin/sh

if [ -d $NOME_WAR ]; then
    echo "$NOME_WAR is a directory"
    mv app.war app.war2 
    mv app.war2/cas.war /app.war
elif [ -f $NOME_WAR ]; then
    echo "$NOME_WAR is a file"
else
    echo "$NOME_WAR is not valid"
    exit 1
fi