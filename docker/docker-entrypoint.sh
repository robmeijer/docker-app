#!/bin/sh
set -e

# first arg is `-f` or `--some-option`
if [ "${1#-}" != "$1" ]; then
  set -- php-fpm "$@"
fi

if [ "$1" = 'php-fpm' ] || [ "$1" = 'php' ] || [ "$1" = 'bin/console' ]; then
  if [ "$APP_ENV" = 'dev' ]; then
    composer install --prefer-dist --no-progress --no-interaction --no-cache
    chmod -R 777 var
  else
    bin/console asset-map:compile
  fi
fi

exec docker-php-entrypoint "$@"
