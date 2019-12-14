FROM alpine

ENV DOCKER_VERSION 19.03.5
ENV DOCKER_COMPOSE_VERSION 1.25.0
ENV KUBECTL_VERSION 1.17.0
ENV HELM_VERSION 3.0.1

RUN apk add --no-cache openssl
RUN wget -q -O - https://download.docker.com/linux/static/stable/x86_64/docker-$DOCKER_VERSION.tgz | tar -x -f - -z --strip-components=1 -v docker/docker
RUN wget -q -O docker-compose https://github.com/docker/compose/releases/download/$DOCKER_COMPOSE_VERSION/docker-compose-Linux-x86_64 && chmod +x docker-compose
RUN wget -q -O kubectl https://storage.googleapis.com/kubernetes-release/release/v$KUBECTL_VERSION/bin/linux/amd64/kubectl && chmod +x kubectl
RUN wget -q -O - https://get.helm.sh/helm-v$HELM_VERSION-linux-amd64.tar.gz | tar -x -f - -z --strip-components=1 -v linux-amd64/helm
  
FROM ubuntu:18.04

COPY --from=0 docker /usr/local/bin
COPY --from=0 docker-compose /usr/local/bin
COPY --from=0 kubectl /usr/local/bin
COPY --from=0 helm /usr/local/bin

RUN apt-get update && \
  apt-get install -y --no-install-recommends ca-certificates git ssh && \
  rm -rf /var/lib/apt/lists/*

RUN helm repo add stable https://kubernetes-charts.storage.googleapis.com && \
  helm repo add strimoid https://strimoid.github.io/helm-charts/
