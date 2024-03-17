ARG ASSETS_IMAGE

FROM ${ASSETS_IMAGE} AS assets

FROM nginx:1.25-alpine as web_dev

WORKDIR /var/www/html

COPY docker/nginx/conf.d/default.conf /etc/nginx/conf.d/

# Below is the logic for deployed images to copy data over from the app image to the public directory
# This is required because only local development uses a volume sync.
FROM web_dev as web

COPY --from=assets /var/www/html/public ./public
