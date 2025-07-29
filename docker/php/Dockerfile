# 🐘 Base PHP image with FPM (FastCGI Process Manager) for performance
FROM php:8.2-fpm

# 📦 Install system dependencies and PHP extensions
RUN apt-get update && apt-get install -y \
    zip unzip curl git \
    libpng-dev libonig-dev libxml2-dev libzip-dev \
    && docker-php-ext-install \
        pdo_mysql \
        mbstring \
        zip \
        exif \
        pcntl \
        bcmath \
        gd \
        opcache  # ✅ Optional: Enable OPcache for performance

# ✅ Install Composer (latest) from official Composer image
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# 📁 Set working directory
WORKDIR /var/www

# 👤 Optional: Use non-root user for better security in production
RUN useradd -G www-data,root -u 1000 -d /home/laravel laravel && \
    mkdir -p /home/laravel && chown -R laravel:laravel /var/www
USER laravel
