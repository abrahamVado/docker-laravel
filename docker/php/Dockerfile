# 🐘 PHP 8.2 FPM (Debian)
FROM php:8.2-fpm AS base

# ---------------------------------------------------------
# System deps + PHP extensions (MySQL + Postgres + GD/WebP)
# ---------------------------------------------------------
RUN set -eux; \
    apt-get update; \
    apt-get install -y --no-install-recommends \
        git curl zip unzip \
        libicu-dev \
        libpq-dev \
        libzip-dev \
        libpng-dev libjpeg62-turbo-dev libwebp-dev libfreetype6-dev \
        libonig-dev libxml2-dev; \
    \
    docker-php-ext-configure gd --with-freetype --with-jpeg --with-webp; \
    docker-php-ext-install -j"$(nproc)" \
        gd intl zip bcmath pcntl exif \
        pdo_mysql pdo_pgsql opcache; \
    \
    pecl install redis; \
    docker-php-ext-enable redis; \
    \
    rm -rf /var/lib/apt/lists/*

# -----------------------
# Composer (from official)
# -----------------------
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

# -----------------------
# PHP runtime tuning (dev)
# -----------------------
RUN { \
      echo 'upload_max_filesize=50M'; \
      echo 'post_max_size=60M'; \
      echo 'memory_limit=512M'; \
      echo 'max_execution_time=120'; \
      echo 'opcache.enable=1'; \
      echo 'opcache.enable_cli=1'; \
      echo 'opcache.validate_timestamps=1'; \
      echo 'opcache.revalidate_freq=0'; \
      echo 'opcache.max_accelerated_files=20000'; \
      echo 'opcache.memory_consumption=256'; \
      echo 'opcache.interned_strings_buffer=16'; \
    } > /usr/local/etc/php/conf.d/zz-app.ini

# -----------------------
# Workdir & permissions
# -----------------------
WORKDIR /var/www/html

# Default php-fpm user is www-data; that’s usually best for Laravel.
# If you prefer a host-matching UID (e.g., 1000) uncomment below:
# RUN useradd -u 1000 -G www-data,root -d /home/laravel -m laravel \
#   && chown -R laravel:www-data /var/www/html
# USER laravel

# php-fpm listens on 9000 by default
EXPOSE 9000

CMD ["php-fpm", "-F"]
