# syntax=docker/dockerfile:1.7
FROM ghcr.io/robmeijer/php:8.3-fpm AS app

ENV APP_ENV=prod XDEBUG_MODE=off

COPY --link --chown=www-data:www-data app/composer.* app/symfony.lock ./

RUN set -eux; \
    composer install --prefer-dist --no-dev --no-scripts --no-progress --ignore-platform-reqs --no-interaction; \
    composer clear-cache;

COPY --link --chown=www-data:www-data app ./

RUN set -eux; \
    composer dump-autoload --classmap-authoritative --no-dev; \
    composer dump-env prod; \
    composer run-script --no-dev post-install-cmd; \
    chmod -R 777 var;

COPY --link --chmod=755 docker/docker-entrypoint.sh /usr/local/bin/docker-entrypoint

USER www-data

ENTRYPOINT ["docker-entrypoint"]
CMD ["php-fpm"]

FROM nginx:1.25-alpine as web_dev

WORKDIR /var/www/html

COPY docker/nginx/conf.d/default.conf /etc/nginx/conf.d/

FROM web_dev as web

COPY --from=app /var/www/html/public ./public

FROM app AS app_dev

USER root

RUN install-php-extensions xdebug
