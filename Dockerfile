FROM php:8.2-fpm

RUN apt-get update && apt-get install -y \
    libzip-dev \
    unzip \
    git \
    curl \
    && docker-php-ext-install pdo pdo_mysql zip

COPY --from=composer:2.2 /usr/bin/composer /usr/bin/composer

WORKDIR /var/www/html

COPY composer.json composer.lock ./
RUN composer install --no-dev --optimize-autoloader --no-interaction --no-scripts

COPY . .

RUN chmod -R 755 /var/www/html

#RUN ls -la /var/www/html/storage /var/www/html/bootstrap/cache


RUN php artisan migrate --force


EXPOSE 9000

USER www-data

CMD ["php-fpm"]
