FROM wordpress:5.3.2-php7.4-fpm

RUN set -ex && \
    buildDeps=' \
    ' && \
    deps=' \
        nano \
        unzip \
        vim \
        wget \
        zip \
    ' && \
    apt update --fix-missing && \
    apt install -y $buildDeps --no-install-recommends && \
    apt install -y $deps --no-install-recommends && \
    rm -rf /var/lib/apt/lists/*

ENV SHELL=/bin/bash

WORKDIR /var/www/html