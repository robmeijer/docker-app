# syntax=docker/dockerfile:1.7
FROM dunglas/frankenphp:1-php8.3 AS base

ENV OPCACHE_VALIDATE_TIMESTAMPS=0 COMPOSER_ALLOW_SUPERUSER=1

WORKDIR /var/www/html

RUN useradd -D www-data; \
    setcap CAP_NET_BIND_SERVICE=+eip /usr/local/bin/frankenphp; \
    chown -R www-data:www-data /data/caddy && chown -R www-data:www-data /config/caddy;

RUN set -eux; \
	install-php-extensions \
		@composer \
		apcu \
		intl \
		opcache \
        pcntl \
        pdo_mysql \
		zip \
	;

RUN ln -s ${PHP_INI_DIR}/php.ini-production ${PHP_INI_DIR}/php.ini

COPY --link docker/conf.d/app.ini $PHP_INI_DIR/conf.d/
COPY --link docker/frankenphp/Caddyfile /etc/caddy/Caddyfile

HEALTHCHECK --start-period=60s CMD curl -f http://localhost:2019/metrics || exit 1
CMD [ "frankenphp", "run", "--config", "/etc/caddy/Caddyfile" ]

FROM base AS app

ENV APP_ENV=prod XDEBUG_MODE=off

USER www-data

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

ENTRYPOINT ["docker-entrypoint"]
CMD [ "frankenphp", "run", "--config", "/etc/caddy/Caddyfile" ]

FROM app AS app_dev

USER root

RUN set -eux; \
    install-php-extensions xdebug; \
    ln -sf "$PHP_INI_DIR/php.ini-development" "$PHP_INI_DIR/php.ini"
