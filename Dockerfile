FROM openjdk:11.0-jre

LABEL maintainer="filipe.nascimento@basis.com.br"

RUN mkdir -p /etc/cas/certs/ && mkdir -p /etc/cas/services

ADD services /etc/cas/services

COPY certs/ /certs/

COPY *.war /app.war

ADD truststorebasis /etc/cas/certs/

ADD entrypoint.sh /usr/local/bin/entrypoint.sh

ADD importcert.sh /usr/local/bin/importcert.sh

COPY install-ssl-certificate.sh /

RUN \
    # configure timezone
    cp /usr/share/zoneinfo/America/Sao_Paulo /etc/localtime &&\
    # download and import letsencrypt certificate
    wget https://letsencrypt.org/certs/lets-encrypt-x3-cross-signed.der &&\
    keytool -importcert \
        -keystore $JAVA_HOME/lib/security/cacerts \
        -storepass changeit \
        -alias lets-encrypt \
        -file lets-encrypt-x3-cross-signed.der \
        -noprompt &&\
    rm -R lets-encrypt-x3-cross-signed.der && \
    # create folder cas configuration
    mkdir -p /etc/cas/config && \
    apt update && apt install -y dos2unix && \
    rm -rf /var/lib/apt/lists/* && \
    dos2unix /usr/local/bin/entrypoint.sh /usr/local/bin/importcert.sh

EXPOSE 8080 8000 8443 5701/udp

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]

VOLUME ["/certs"]
