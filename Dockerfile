FROM alpine AS downloader
RUN apk add --no-cache curl

ENV KCPTUN_VERSION=20230214 KCPTUN_ARCH=linux-amd64
WORKDIR /app
RUN (curl -L "https://github.com/xtaci/kcptun/releases/download/v${KCPTUN_VERSION}/kcptun-${KCPTUN_ARCH}-${KCPTUN_VERSION}.tar.gz" | tar xz) \
    && mv client_* kcptun-client && mv server_* kcptun-server && chmod +x kcptun-client kcptun-server

ENV PROXYPUNCH_VERSION=v0.0.3 PROXYPUNCH_ARCH=linux64
RUN curl -L "https://github.com/delthas/proxypunch/releases/download/${PROXYPUNCH_VERSION}/proxypunch.linux64.run" -o proxypunch \
    && chmod +x proxypunch

FROM ubuntu:focal
ENV PATH=${PATH}:/app

COPY --from=downloader /app /app
COPY tcp-client.sh /app/tcp-client.sh
COPY tcp-server.sh /app/tcp-server.sh