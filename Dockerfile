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

RUN chown -R www-data:www-data /var/www/html/storage /var/www/html/bootstrap/cache \
    && chmod -R 775 /var/www/html/storage /var/www/html/bootstrap/cache

RUN chmod -R www-data:www-data /var/www/html/.config && mkdir -p /var/www/html/.config/psysh

RUN touch /var/www/html/storage/logs/laravel.log && chown www-data:www-data /var/www/html/storage/logs/laravel.log

#RUN ls -la /var/www/html/storage /var/www/html/bootstrap/cache


RUN php artisan migrate --force


EXPOSE 9000

USER www-data

CMD ["php-fpm"]
