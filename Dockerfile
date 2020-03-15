ARG NODE_VERSION=13

FROM node:${NODE_VERSION}-buster-slim

ENV DEBIAN_FRONTEND=noninteractive

RUN set -eux; \
    apt-get update -qq; \
    apt-get install -qq --no-install-recommends \
        ca-certificates \
        curl \
        build-essential \
        python2 \
        libglib2.0-dev \
        musl-dev \
        libsass-dev \
        libpng-dev \
        tini \
    ; \
    rm -rf /var/lib/apt/lists/*; \
    update-ca-certificates -f

RUN set -eux; \
    update-ca-certificates -f; \
    cd /opt; \
    curl -L -O https://github.com/libvips/libvips/releases/download/v8.9.1/vips-8.9.1.tar.gz; \
    tar xf vips-8.9.1.tar.gz; \
    cd vips-8.9.1; ./configure && make && make install && ldconfig; \
    cd /opt; \
    curl -L -O https://storage.googleapis.com/downloads.webmproject.org/releases/webp/libwebp-1.1.0.tar.gz; \
    tar xzf libwebp-1.1.0.tar.gz; \
    cd libwebp-1.1.0; ./configure && make && make install && ldconfig; \
    cd /opt; \
    curl -L https://github.com/mozilla/mozjpeg/archive/v3.3.1.tar.gz -o mozjpeg-v3.3.1.tar.gz; \
    tar xzf mozjpeg-v3.3.1.tar.gz; \
    cd mozjpeg-3.3.1; cmake -G"Unix Makefiles" . && make && make install && ldconfig; \
    cd /opt; \
    rm -rf vips-8.9.1.tar.gz libwebp-1.1.0.tar.gz mozjpeg-v3.3.1.tar.gz

RUN set -eux; \
    npm i -g --unsafe-perm  \
        gatsby-cli \
        node-gyp \
        node-sass

RUN set -eux; \
    apt-get autoremove -qq; \
    apt-get autoclear

ENTRYPOINT [ "/usr/bin/tini", "--" ]
