
# ==== MONTAR AMBIENTE ====

## Ambiente Docker

Executar o [docker-compose](./docker/docker-compose.yml) para subir:
* LDAP
* Postgresql
* REDIS

```
docker-compose up -d
```

Esta configuração está preparada para escalar horizontalmente, compartilhando as seções web e o ticket no REDIS.


## Banco de dados

Dados para conexão via `DBeaver` aos serviços configurados no composer:

```
Host:         localhost
Port:         15432
Database:     postgres
UserName:     postgres
Password:     123456
driver-class: org.postgresql.Driver

```

### Criar a tabela e inserir o registro do usuário

Crie a tabela e adicione o usuário que será utilizado para autenticar no CAS com este provedor:

```
CREATE TABLE users
(
    id bigint NOT NULL,
    disabled boolean,
    email character varying(40) COLLATE pg_catalog."default",
    first_name character varying(40) COLLATE pg_catalog."default",
    last_name character varying(40) COLLATE pg_catalog."default",
    expired boolean,
    password character varying(100) COLLATE pg_catalog."default",
    CONSTRAINT users_pkey PRIMARY KEY (id),
    CONSTRAINT uk6dotkott2kjsp8vw4d0m25fb7 UNIQUE (email)
)
WITH (
    OIDS = FALSE
);



INSERT INTO users(
 id, disabled, email, first_name, last_name, expired, password)
 VALUES (1, false, 'user1@test.com', 'test', 'user1', false, '$2y$12$7XQUDwK3QE7oBB0wmVpht.aT7gESI205SgWarj15Wz2Jt6OfglbQ.');
```

+ Senha do usuário adicionado: `testpass`.

Crie a tabela para receber o cadastro dos serviços:

```
CREATE TABLE registered_services (
	id int8 NOT NULL,
	body varchar(8000) NOT NULL,
	evaluation_order int4 NOT NULL,
	evaluation_priority int4 NOT NULL,
	name varchar(255) NOT NULL,
	service_id varchar(255) NOT NULL,
	CONSTRAINT registered_services_pkey PRIMARY KEY (id)
);

```


## LDAP

Adicione o usuário do LDAP que será usado para autenticação no CAS. Utilize o grupo de informações abaixo:

```
dn: uid=chico.gomes,dc=oobjlocal,dc=com,dc=br
cn: Chico Gomes
departmentnumber: 025262
displayname: GOMES
givenname: 75894682312
initials: 157321001
mail: chico.gomes@email.com.br
objectclass: inetOrgPerson
objectclass: top
sn: Chico Gomes
title: 1º Ten
uid: chico.gomes
userpassword: {MD5}F5GWLq3q3NkAHOiIFWmDcA==
```

+ Senha do usuário adicionado: `Teste@123`.


Grave o conteúdo acima em um arquivo com a extensão ldif (exemplo: user-ldap.ldif) e adicione ao LDAP rodando o comando abaixo:

```
ldapadd -c -x -H ldap://localhost:8389 -D "cn=admin,dc=oobjlocal,dc=com,dc=br" -W -f ./user-ldap.ldif 
```
* A DN onde este usuário está sendo inserido é `cn=admin,dc=oobj,dc=com,dc=br`;
* A senha do admin solicitada ao executar o comando acima é `admin_pass` (vide configuração no arquivo [docker-compose.yml](./docker-compose.yml#L48)).


**Observação**: Considere que o LDAP esteja rodando no host: `localhost`, na porta `8389` (o docker-compose citado anteriormente já executa o ldap nesta porta e também já configura este grupo utilizado no exemplo e ajustado nas parametrizações do CAS para este mesmo domínio).


## Executar o cas

Para subir o serviço localmente, escutando na porta de debug, execute o comando:

caso não tenha o gradle instalado, use:

```
sdk install gradle 7.6.3
```
> ou escolha uma versão de sua preferência que seja superior à 7 e seja compatível com essa versão do CAS

### Sem debug

```
sudo ./gradlew clean copyCasConfiguration build run
```
ou

```
./build.sh run
```
### Com debug

```
sudo ./gradlew clean copyCasConfiguration build debug
```
ou
```
./build.sh debug
```


### Usando o Maven

Compile o projeto com:

```
sudo mvn clean install
```

Depois execute o aplicativo com:

```
sudo java -jar ./target/cas.war
```


## Acessar a url do OpenLDAP:

Acessar o openLDA admin em [http://localhost:8980/cmd.php](http://localhost:8980/cmd.php)

* Credenciais:

```
Login DN: cn=admin,dc=oobjlocal,dc=com
Senha   : admin_pass

```

## Acessar o login do CAS:

Acessar a url de login em [http://localhost:8090/cas/login](http://localhost:8090/cas/login)

Lembrando que a porta é a mesma configurada na chave `server.port` nos arquivos de configuração do CAS.


Após login, caso queira trocar de usuário, é necessário fazer o logout através da url [http://localhost:8090/cas/logout](http://localhost:8090/cas/logout).


Dados para autenticação (Considerando as etapas e exemplos citados anteriormente, nas seções acima):

### Provedor JDBC

```
Usuário: user1@test.com
Senha  : testpass
```

### Provedor LDAP

```
Usuário: chico.gomes
Senha  : Teste@123
```


## Configuração do Gateway

Estes ajustes devem ser efetuados no módulo Gateway ou no módulo responsável por tratar a segurança.

Esta biblioteca é a responsável por realizar a interceptação das requisições, verificar a presença do `jwt-token` no header ou no cookie, redirecionar para o sso ou gerar o `jwt-token` no cookie e enviar aos microsserviços.


# ==== DOCUMENTAÇÃO DO OVERLAY ====

[Apereo CAS Documentation](https://apereo.github.io/cas/6.4.x/configuration/Configuration-Management.html)

CAS Overlay Template [![Build Status](https://travis-ci.org/apereo/cas-overlay-template.svg?branch=master)](https://travis-ci.org/apereo/cas-overlay-template)
=======================

Generic CAS WAR overlay to exercise the latest versions of CAS. This overlay could be freely used as a starting template for local CAS war overlays.

# Versions

- CAS `6.4.x`
- JDK `11`

# Overview

To build the project, use:

```bash
# Use --refresh-dependencies to force-update SNAPSHOT versions
./gradlew[.bat] clean build
```

To see what commands are available to the build script, run:

```bash
./gradlew[.bat] tasks
```

To launch into the CAS command-line shell:

```bash
./gradlew[.bat] downloadShell runShell
```

To fetch and overlay a CAS resource or view, use:

```bash
./gradlew[.bat] getResource -PresourceName=[resource-name]
```

To list all available CAS views and templates:

```bash
./gradlew[.bat] listTemplateViews
```

To unzip and explode the CAS web application file and the internal resources jar:

```bash
./gradlew[.bat] explodeWar
```

# Configuration

- The `etc` directory contains the configuration files and directories that need to be copied to `/etc/cas/config`.

```bash
./gradlew[.bat] copyCasConfiguration
```

- The specifics of the build are controlled using the `gradle.properties` file.

## Adding Modules

CAS modules may be specified under the `dependencies` block of the [Gradle build script](build.gradle):

```gradle
dependencies {
    implmentation "org.apereo.cas:cas-server-some-module:${project.casVersion}"
    ...
}
```

To collect the list of all project modules and dependencies:

```bash
./gradlew[.bat] allDependencies
```

You could also add modules and dependencies dynamically on the fly using the `casModules` project property. For example, to include support for OpenID Connect and Duo Security, you could invoke the build using `-PcasModules=oidc,duo` and have it auto-include modules that provide requested functionality. Needless, to say, you will need to know the module name beforehand.

### Clear Gradle Cache

If you need to, on Linux/Unix systems, you can delete all the existing artifacts (artifacts and metadata) Gradle has downloaded using:

```bash
# Only do this when absolutely necessary
rm -rf $HOME/.gradle/caches/
```

Same strategy applies to Windows too, provided you switch `$HOME` to its equivalent in the above command.

# Deployment

- Create a keystore file `thekeystore` under `/etc/cas`. Use the password `changeit` for both the keystore and the key/certificate entries. This can either be done using the JDK's `keytool` utility or via the following command:

```bash
./gradlew[.bat] createKeystore
```

- Ensure the keystore is loaded up with keys and certificates of the server.

On a successful deployment via the following methods, CAS will be available at:

* `https://cas.server.name:8443/cas`

## Executable WAR

Run the CAS web application as an executable WAR:

```bash
./gradlew[.bat] run
```

Debug the CAS web application as an executable WAR:

```bash
./gradlew[.bat] debug
```

Run the CAS web application as a *standalone* executable WAR:

```bash
./gradlew[.bat] clean executable
```

## External

Deploy the binary web application file `cas.war` after a successful build to a servlet container of choice.

## Docker

The following strategies outline how to build and deploy CAS Docker images.

### Jib

The overlay embraces the [Jib Gradle Plugin](https://github.com/GoogleContainerTools/jib) to provide easy-to-use out-of-the-box tooling for building CAS docker images. Jib is an open-source Java containerizer from Google that lets Java developers build containers using the tools they know. It is a container image builder that handles all the steps of packaging your application into a container image. It does not require you to write a Dockerfile or have Docker installed, and it is directly integrated into the overlay.

```bash
./gradlew build jibDockerBuild
```

### Dockerfile

You can also use the native Docker tooling and the provided `Dockerfile` to build and run CAS.

```bash
chmod +x *.sh
./docker-build.sh
./docker-run.sh
```
