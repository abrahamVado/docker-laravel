# Laravel 12 + Docker + React Starter (Postgres Edition)

A modern, containerized **Laravel 12 API** with **Nginx + PHP-FPM (8.2) + Postgres 16 + Redis + Mailpit**.  
Designed for a **React SPA (Vite)** running separately on your host (or any static hosting).

---

## Tech Stack

- Laravel 12 (PHP 8.2, FPM)
- Nginx (production-like web server)
- Postgres 16
- Redis (queues, cache, sessions)
- Mailpit (local mail catcher)
- Docker & Docker Compose
- React + Vite (SPA) — runs outside Docker (recommended)

Why separate SPA?  
It keeps the PHP containers lean and avoids juggling Node inside Docker. Your SPA can consume the API at `http://localhost` using cookies (Sanctum) or tokens.

---

## Features

- Clean, minimal **docker-compose**: `nginx` + `php-fpm` + `postgres` + `redis` + `mailpit`
- PHP image with common extensions: `pdo_pgsql, gd (jpeg/webp), intl, redis, zip, bcmath, pcntl, exif, opcache`
- Nginx config tuned for Laravel (static caching, secure defaults)
- Named volumes for Postgres data + composer cache
- Healthcheck for Postgres
- Works great with **Sanctum** for SPA auth

---

## Architecture

```text
                +-------------------+
                |   React (Vite)    |
                |   Runs on host    |
                +---------+---------+
                          |
                          v
+-------------------------+-------------------------+
|                     Docker Network               |
|                                                   |
|   +----------+      +-------------+      +--------+|
|   |  Nginx   | ---> |  PHP-FPM    | ---> | Postgres|
|   | (port 80)|      | (port 9000) |      |  5432   |
|   +----------+      +-------------+      +--------+|
|         |                         |                |
|         |                         v                |
|         |                     +--------+           |
|         |                     | Redis  |           |
|         |                     |  6379  |           |
|         |                                         |
|         +---------------------------------------> |
|                                Mailpit (8025 UI)  |
|                                SMTP (1025)        |
+---------------------------------------------------+
```

---

## Included

- `docker-compose.yml` — Nginx + PHP-FPM + Postgres + Redis + Mailpit
- `docker/php/Dockerfile` — PHP 8.2 with common extensions
- `docker/nginx/default.conf` — Laravel-friendly server config
- `scripts/dockerize.sh` — one-shot: prepare `.env.docker`, build, migrate
- `Makefile` — handy commands (`make up`, `make down`, `make shell`, etc.)

---

## One-shot: Dockerize this app

```bash
cp .env .env.docker    # keep your original .env for local non-docker dev
bash scripts/dockerize.sh
```

It will:

- Ensure `.env.docker` has the right Docker values (`DB_CONNECTION=pgsql`, `DB_HOST=postgres`, ports, Sanctum)
- Build and start the containers
- Run `composer install`, generate the app key, run migrations, and `storage:link`

Then open: **http://localhost**  
Mailpit UI: **http://localhost:8025**

---

## Import your existing local DB (optional)

```bash
# Export from your local Postgres (outside Docker)
pg_dump -h 127.0.0.1 -U postgres my_local_db > dump.sql

# Import into the Docker Postgres
docker compose exec -T postgres psql -U postgres -d yamato < dump.sql
```

---

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

---