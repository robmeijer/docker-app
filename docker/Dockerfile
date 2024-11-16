# syntax=docker/dockerfile:1
FROM ghcr.io/robmeijer/php:8.3-fpm-alpine AS app

ENV APP_ENV=prod XDEBUG_MODE=off

COPY --link --chown=www-data:www-data app/composer.* app/symfony.lock ./

RUN composer install --prefer-dist --no-dev --no-scripts --no-progress --ignore-platform-reqs --no-cache -n

COPY --link --chown=www-data:www-data app ./

RUN set -eux; \
    composer dump-autoload --classmap-authoritative --no-dev; \
    composer dump-env prod; \
    composer run-script --no-dev post-install-cmd; \
    chmod -R 777 var;

COPY --link --chmod=755 docker/docker-entrypoint.sh /usr/local/bin/docker-entrypoint

ENTRYPOINT ["docker-entrypoint"]
CMD ["php-fpm"]

FROM nginx:1.27-alpine as web_dev

WORKDIR /var/www/html

COPY --link docker/nginx/conf.d/default.conf /etc/nginx/conf.d/

FROM web_dev as web

COPY --link --from=app /var/www/html/public ./public

FROM app AS app_dev

ARG USER_ID
ARG GROUP_ID

USER root

RUN set -eux; \
    install-php-extensions xdebug; \
    ln -sf "$PHP_INI_DIR/php.ini-development" "$PHP_INI_DIR/php.ini"; \
    apk add --no-cache shadow; \
    usermod -u ${USER_ID} www-data && groupmod -g ${GROUP_ID} www-data;

USER www-data
