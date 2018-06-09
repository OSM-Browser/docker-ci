FROM alpine

ENV DOCKER_VERSION 17.12.0
ENV DOCKER_COMPOSE_VERSION 1.18.0
ENV KUBECTL_VERSION 1.10.0
ENV HELM_VERSION 2.9.1

RUN apk add --no-cache openssl
RUN wget -q -O - https://download.docker.com/linux/static/stable/x86_64/docker-$DOCKER_VERSION-ce.tgz | tar -x -f - -z --strip-components=1 -v docker/docker
RUN wget -q -O docker-compose https://github.com/docker/compose/releases/download/$DOCKER_COMPOSE_VERSION/docker-compose-Linux-x86_64 && chmod +x docker-compose
RUN wget -q -O kubectl https://storage.googleapis.com/kubernetes-release/release/v$KUBECTL_VERSION/bin/linux/amd64/kubectl && chmod +x kubectl
RUN wget -q -O - https://storage.googleapis.com/kubernetes-helm/helm-v$HELM_VERSION-linux-amd64.tar.gz | tar -x -f - -z --strip-components=1 -v linux-amd64/helm
  
FROM ubuntu:17.10

COPY --from=0 docker /usr/local/bin
COPY --from=0 docker-compose /usr/local/bin
COPY --from=0 kubectl /usr/local/bin
COPY --from=0 helm /usr/local/bin

RUN apt-get update && \
  apt-get install -y --no-install-recommends ca-certificates git ssh && \
  rm -rf /var/lib/apt/lists/*
