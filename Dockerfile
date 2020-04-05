FROM alpine:latest

ARG VERSION="1.17.1"

RUN apk add --no-cache ca-certificates git jq util-linux

RUN apk add --no-cache --virtual .phraseapp-build \
        curl \
    && curl -fSL -o /usr/local/bin/phraseapp "https://github.com/phrase/phraseapp-client/releases/download/${VERSION}/phraseapp_linux_amd64" \
    && chmod +x /usr/local/bin/phraseapp \
    && apk del .phraseapp-build