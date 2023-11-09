#!/bin/bash

./mvnw clean package -U

cp target/cas.war docker/cas.war

docker build --no-cache -f docker/Dockerfile-local -t sso docker

docker run --rm --network host sso

#docker run -p 5000:5000 -e JAVA_OPTS=-agentlib:jdwp=transport=dt_socket,server=y,suspend=y,address=*:5000 --rm --network host sso
