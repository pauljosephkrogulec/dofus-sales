FROM php:8.3-fpm-alpine

# Extensions PHP : Postgres (Doctrine), intl, zip (Composer), opcache
COPY --from=mlocati/php-extension-installer:2 /usr/bin/install-php-extensions /usr/local/bin/
RUN install-php-extensions pdo_pgsql intl zip opcache \
    && apk add --no-cache git unzip

COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

COPY conf.d/app.ini $PHP_INI_DIR/conf.d/app.ini
COPY docker-entrypoint.sh /usr/local/bin/docker-entrypoint
RUN chmod +x /usr/local/bin/docker-entrypoint

WORKDIR /var/www/html

ENTRYPOINT ["docker-entrypoint"]
CMD ["php-fpm"]
