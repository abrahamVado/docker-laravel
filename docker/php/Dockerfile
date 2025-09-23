# ===== Builder: install system deps & composer deps with cache =====
FROM php:8.2-fpm AS builder

ARG APP_ENV=local

RUN set -eux; \
    apt-get update; \
    apt-get install -y --no-install-recommends \
        git curl zip unzip \
        libicu-dev libpq-dev libzip-dev \
        libpng-dev libjpeg62-turbo-dev libwebp-dev libfreetype6-dev \
        libonig-dev libxml2-dev; \
    docker-php-ext-configure gd --with-freetype --with-jpeg --with-webp; \
    docker-php-ext-install -j"$(nproc)" \
        gd intl zip bcmath pcntl exif \
        pdo_pgsql opcache; \
    # keep pdo_mysql if you still need MySQL:
    # docker-php-ext-install pdo_mysql; \
    pecl install redis-6.0.2; \
    docker-php-ext-enable redis; \
    rm -rf /var/lib/apt/lists/*

# composer
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

WORKDIR /var/www/html
# copy only composer files first to leverage Docker layer cache
COPY app/composer.json app/composer.lock* ./
RUN composer install --no-scripts --no-interaction --prefer-dist --no-progress

# ===== Runtime: copy built vendor + rest of app =====
FROM php:8.2-fpm AS app

# (repeat only runtime libs you actually need at runtime)
RUN set -eux; \
    apt-get update; \
    apt-get install -y --no-install-recommends \
        libicu-dev libpq-dev libzip-dev \
        libpng-dev libjpeg62-turbo-dev libwebp-dev libfreetype6-dev \
        libonig-dev libxml2-dev; \
    docker-php-ext-configure gd --with-freetype --with-jpeg --with-webp; \
    docker-php-ext-install -j"$(nproc)" gd intl zip bcmath pcntl exif pdo_pgsql opcache; \
    pecl install redis-6.0.2; \
    docker-php-ext-enable redis; \
    rm -rf /var/lib/apt/lists/*

# Dev php.ini (mounted defaults); you can switch to prod below
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
    } > /usr/local/etc/php/conf.d/zz-dev.ini

# Production toggle (uncomment if building prod images)
# RUN { \
#       echo 'opcache.validate_timestamps=0'; \
#       echo 'opcache.preload_user=www-data'; \
#     } > /usr/local/etc/php/conf.d/zz-prod.ini

WORKDIR /var/www/html

# copy vendor from builder cache
COPY --from=builder /var/www/html/vendor ./vendor
# copy full app (your local checkout bind-mount will override in dev)
COPY app ./

EXPOSE 9000
CMD ["php-fpm", "-F"]
