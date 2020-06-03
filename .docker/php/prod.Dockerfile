# Composer dependencies.
FROM composer AS composer-build

WORKDIR /var/www/html

COPY composer.json composer.lock /var/www/html/

RUN mkdir -p /var/www/html/database/{factories,seeds} \
  && composer install --no-dev --prefer-dist --no-scripts --no-autoloader --no-progress --ignore-platform-reqs

# NPM dependencies.
FROM node:12 AS npm-build

WORKDIR /var/www/html

COPY package.json package-lock.json webpack.mix.js /var/www/html/
COPY resources /var/www/html/resources/
COPY public /var/www/html/public/

RUN npm ci
RUN npm run production

# Actual production image.
FROM php:7.4-fpm

WORKDIR /var/www/html

RUN apt-get update \
  && apt-get install --quiet --yes --no-install-recommends \
    libzip-dev \
    unzip \
  && docker-php-ext-install pcntl opcache zip pdo pdo_mysql \
  && pecl install -o -f redis-5.1.1 \
  && docker-php-ext-enable redis

# Use the default production configuration
RUN mv $PHP_INI_DIR/php.ini-production $PHP_INI_DIR/php.ini

# Override with custom opcache settings
COPY .docker/php/opcache.ini $PHP_INI_DIR/conf.d/

COPY --from=composer /usr/bin/composer /usr/bin/composer

COPY --chown=www-data --from=composer-build /var/www/html/vendor/ /var/www/html/vendor/
COPY --chown=www-data --from=npm-build /var/www/html/public/ /var/www/html/public/
COPY --chown=www-data . /var/www/html

RUN composer dump -o && composer check-platform-reqs
