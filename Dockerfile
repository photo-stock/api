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


RUN chown -R www-data:www-data /var/www/html  && chmod -R 755 /var/www/html  && chmod -R 755 /var/www/html/storage && chomd -R 775 /var/www/html/bootstrap/cache

RUN php artisan config:cache && php artisan route:cache

RUN php artisan migrate --force

EXPOSE 9000

USER www-data

CMD ["php-fpm"]
