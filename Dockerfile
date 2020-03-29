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

# 1000 is the defaults
ARG APP_GID=1000
ARG APP_UID=1000

ENV SHELL=/bin/bash \
    APP_GROUP_NAME=app-group \
    APP_USER_NAME=app-user

RUN set -ex && \
    addgroup --gid ${APP_GID} ${APP_GROUP_NAME} && \
    adduser --system --no-create-home --disabled-password --disabled-login --uid ${APP_UID} --ingroup ${APP_GROUP_NAME} ${APP_USER_NAME} && \
    chown -R ${APP_USER_NAME}:${APP_GROUP_NAME} /var/www

USER ${APP_USER_NAME}

WORKDIR /var/www/html