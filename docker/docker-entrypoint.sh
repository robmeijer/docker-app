#!/bin/sh
set -e

# first arg is `-f` or `--some-option`
if [ "${1#-}" != "$1" ]; then
  set -- frankenphp "$@"
fi

if [ "$1" = 'frankenphp' ] || [ "$1" = 'php' ] || [ "$1" = 'bin/console' ]; then
  if [ "$APP_ENV" = 'dev' ]; then
    composer install --prefer-dist --no-progress --no-interaction
  else
    bin/console asset-map:compile
  fi
fi

exec docker-php-entrypoint "$@"
