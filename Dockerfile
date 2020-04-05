FROM alpine:edge

ENV GOSU_VERSION 1.11
RUN set -eux \
    && apk add --no-cache --virtual .gosu-deps \
        ca-certificates \
        dpkg \
        gnupg \
    && dpkgArch="$(dpkg --print-architecture | awk -F- '{ print $NF }')" \
    && wget -O /usr/local/bin/gosu "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$dpkgArch" \
    && wget -O /usr/local/bin/gosu.asc "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$dpkgArch.asc" \
    # verify the signature
    && export GNUPGHOME="$(mktemp -d)" \
    && gpg --batch --keyserver hkps://keys.openpgp.org --recv-keys B42F6819007F00F88E364FD4036A9C25BF357DD4 \
    && gpg --batch --verify /usr/local/bin/gosu.asc /usr/local/bin/gosu \
    && command -v gpgconf && gpgconf --kill all || : \
    && rm -rf "$GNUPGHOME" /usr/local/bin/gosu.asc \
    # clean up deps
    && apk del --no-network .gosu-deps \
    && chmod +x /usr/local/bin/gosu \
    # verify that the binary works
    && gosu --version \
    && gosu nobody true

RUN apk add --no-cache ca-certificates git jq util-linux

ENV PHRASEAPP_VERSION 1.17.1
RUN set -eux \
    && apk add --no-cache --virtual .phraseapp-deps \
        curl \
    && curl -fSL -o /usr/local/bin/phraseapp "https://github.com/phrase/phraseapp-client/releases/download/${PHRASEAPP_VERSION}/phraseapp_linux_amd64" \
    # clean up deps
    && apk del .phraseapp-deps \
    && chmod +x /usr/local/bin/phraseapp

COPY entrypoint.sh /entrypoint.sh

WORKDIR /code
VOLUME /code

ENTRYPOINT ["/entrypoint.sh"]