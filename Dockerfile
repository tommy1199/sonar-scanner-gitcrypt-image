FROM openjdk:8-alpine

MAINTAINER Sascha Selzer sascha.selzer@gmail.com

ENV SONAR_RUNNER_HOME=/opt/sonar-scanner
ENV PATH $PATH:/opt/sonar-scanner/bin

ENV GITCRYPT_VERSION=0.6.0-r1
ENV SONAR_SCANNER_VERSION=3.3.0.1492-linux

RUN apk update && apk add --no-cache bash jq curl

RUN apk add --no-cache ca-certificates openssl && \
    wget \
        "https://raw.githubusercontent.com/sgerrand/alpine-pkg-git-crypt/master/sgerrand.rsa.pub" \
        -O "/etc/apk/keys/sgerrand.rsa.pub"  && \
    wget "https://github.com/sgerrand/alpine-pkg-git-crypt/releases/download/${GITCRYPT_VERSION}/git-crypt-${GITCRYPT_VERSION}.apk" && \
    apk --no-cache add git-crypt-${GITCRYPT_VERSION}.apk && \
    rm "/etc/apk/keys/sgerrand.rsa.pub" && \
    rm git-crypt-${GITCRYPT_VERSION}.apk && \
    apk del ca-certificates openssl

RUN apk add --no-cache sed unzip && \
  wget --no-check-certificate -O ./sonarscanner.zip https://binaries.sonarsource.com/Distribution/sonar-scanner-cli/sonar-scanner-cli-${SONAR_SCANNER_VERSION}.zip && \
	unzip sonarscanner.zip && \
	rm sonarscanner.zip && \
	mv sonar-scanner-${SONAR_SCANNER_VERSION} /opt/sonar-scanner && \
  sed -i 's/use_embedded_jre=true/use_embedded_jre=false/g' /opt/sonar-scanner/bin/sonar-scanner && \
  apk del sed unzip