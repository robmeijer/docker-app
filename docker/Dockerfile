FROM ghcr.io/immediatemediaco/php:8.3-fpm AS app
ENV APP_ENV=prod COMPOSER_ALLOW_SUPERUSER=1
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer
COPY --link --chown=www-data:www-data app/composer.* app/symfony.lock ./
RUN set -xe; \
    composer install --prefer-dist --no-dev --no-scripts --no-progress --ignore-platform-reqs --no-interaction; \
    composer clear-cache;
COPY --link --chown=www-data:www-data app ./
RUN composer dump-autoload -a; \
    composer run-script --no-dev post-install-cmd; \
    composer dump-env prod; \
    chmod -R 777 var;
COPY --chmod=755 docker/docker-entrypoint.sh /usr/local/bin/docker-entrypoint
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
