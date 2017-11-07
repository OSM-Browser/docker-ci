FROM alpine:latest

ENV DOCKER_VERSION 17.09.0
ENV DOCKER_COMPOSE_VERSION 1.17.0

RUN apk add --no-cache openssl
RUN wget -q -O - https://download.docker.com/linux/static/stable/x86_64/docker-$DOCKER_VERSION-ce.tgz | tar -x -f - -z --strip-components=1 -v docker/docker
RUN wget -q -O docker-compose https://github.com/docker/compose/releases/download/$DOCKER_COMPOSE_VERSION/docker-compose-Linux-x86_64 && chmod +x docker-compose
