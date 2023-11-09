FROM openjdk:11.0-jre

ENV NOME_WAR=app.war

COPY *.war /app.war

RUN mkdir -p /etc/cas && mkdir -p /etc/cas/config/

COPY certs /certs/

COPY install-ssl-certificate.sh /

COPY copia-arquivo.sh /

RUN \
    chmod +x install-ssl-certificate.sh &&\
    chmod +x copia-arquivo.sh

RUN ./copia-arquivo.sh

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
	rm -R lets-encrypt-x3-cross-signed.der

RUN \
      for i in `ls /certs/`; do keytool -importcert -noprompt -keystore $JAVA_HOME/lib/security/cacerts -storepass changeit -alias $i -file /certs/"$i"  -noprompt; done

EXPOSE 8080 8000 8443 5701/udp

CMD ./install-ssl-certificate.sh &&\
    java ${JAVA_OPTS} -Djava.security.egd=file:/dev/./urandom -jar /app.war