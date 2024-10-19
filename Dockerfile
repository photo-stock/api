FROM php:8.2-fpm

RUN apt-get update && apt-get install -y \
    libzip-dev \
    unzip \
    git \
    curl \
    && docker-php-ext-install pdo pdo_mysql zip \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

COPY --from=composer:2.2 /usr/bin/composer /usr/bin/composer

WORKDIR /var/www/html

COPY composer.json composer.lock ./
RUN composer install --no-dev --optimize-autoloader --no-interaction --no-scripts

COPY . .

RUN ls -la

COPY .env.production .env


RUN chown -R www-data:www-data /var/www \
    && chmod -R 755 /var/www \
    && chmod -R 777 /var/www/html/storage \
    && chmod -R 777 /var/www/html/bootstrap/cache \
    && chmod -R 777 /var/www/html/storage/framework/sessions



RUN php artisan migrate --force

EXPOSE 9000

USER www-data

CMD ["php-fpm"]
