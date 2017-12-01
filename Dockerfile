FROM alpine

ENV DOCKER_VERSION 17.09.0
ENV DOCKER_COMPOSE_VERSION 1.17.0

RUN apk add --no-cache openssl && \
  wget -q -O - https://download.docker.com/linux/static/stable/x86_64/docker-$DOCKER_VERSION-ce.tgz | tar -x -f - -z --strip-components=1 -v docker/docker && \
  wget -q -O docker-compose https://github.com/docker/compose/releases/download/$DOCKER_COMPOSE_VERSION/docker-compose-Linux-x86_64 && chmod +x docker-compose
  
FROM ubuntu:17.10

COPY --from=0 docker /usr/local/bin
COPY --from=0 docker-compose /usr/local/bin

ADD https://storage.googleapis.com/kubernetes-release/release/v1.8.4/bin/linux/amd64/kubectl /usr/local/bin/kubectl
RUN chmod +x /usr/local/bin/kubectl

RUN apt-get update && \
  apt-get install -y --no-install-recommends ca-certificates git ssh && \
  rm -rf /var/lib/apt/lists/*
