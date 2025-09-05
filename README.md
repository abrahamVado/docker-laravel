# 🚀 Laravel 12 + Docker + React Starter (Updated)

A modern, containerized **Laravel 12 API** with **Nginx + PHP-FPM (8.2) + MySQL 8**.  
Designed for a **React SPA (Vite)** running separately on your host (or any static hosting).

---

## 🧱 Tech Stack

- ✅ Laravel 12 (PHP 8.2, FPM)
- ✅ Nginx (production‑like web server)
- ✅ MySQL 8 (UTF8MB4)
- ✅ Docker & Docker Compose
- ✅ React + Vite (SPA) — runs outside Docker (recommended)

> Why separate SPA? It keeps the PHP containers lean and avoids juggling Node inside Docker. Your SPA can consume the API at `http://localhost` using cookies (Sanctum) or tokens.

---

## 📦 Features

- Clean, minimal **docker-compose**: `nginx` + `php-fpm` + `mysql`
- PHP image with common extensions: **pdo_mysql, gd (jpeg/webp), intl, redis, zip, bcmath, pcntl, exif, opcache**
- Nginx config tuned for Laravel (static caching, secure defaults)
- Named volumes for `vendor` and `storage` (fast + correct perms)
- Healthcheck for MySQL
- Works great with **Sanctum** for SPA auth

---

This kit assumes you already developed your Laravel app **outside** Docker. When you're ready, drop these files into the project root and run a single script to containerize it.

## What’s included
- `docker-compose.yml` — Nginx + PHP-FPM + MySQL (dev)
- `docker/php/Dockerfile` — PHP 8.2 with common extensions
- `docker/nginx/default.conf` — Laravel-friendly server config
- `scripts/dockerize.sh` — one-shot: prepare `.env.docker`, build, migrate
- `scripts/db-import.sh` — import a local SQL dump into the MySQL container
- `Makefile` — handy commands (`make up`, `make down`, `make shell`, etc.)

## One-shot: Dockerize this app
```bash
cp .env .env.docker    # keep your original .env for local non-docker dev
bash scripts/dockerize.sh
```

It will:
- Ensure `.env.docker` has the right Docker values (DB_HOST=mysql, ports, Sanctum)
- Build and start the containers
- Run `composer install`, generate the app key, run migrations, and `storage:link`

Then open: **http://localhost**

## Import your existing local DB (optional)
```bash
# Export from your local MySQL (outside Docker)
mysqldump -h 127.0.0.1 -u root -p my_local_db > dump.sql

# Import into the Docker MySQL
bash scripts/db-import.sh dump.sql
```

## Make targets
```bash
make up        # build & start
make down      # stop containers
make restart   # rebuild & restart
make logs      # tail logs for nginx + app
make shell     # bash into php-fpm
make migrate   # php artisan migrate
make tinker    # php artisan tinker
make perms     # fix storage/bootstrap perms
```
