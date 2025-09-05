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

## ⚙️ Getting Started

### 1) Clone & env
```bash
git clone <your-repo-url> myapp && cd myapp
cp .env.example .env
```

Make sure these DB values exist in `.env`:
```dotenv
DB_CONNECTION=mysql
DB_HOST=mysql
DB_PORT=3306
DB_DATABASE=myapp
DB_USERNAME=myapp
DB_PASSWORD=secret
```

For SPA auth (Sanctum), add:
```dotenv
APP_URL=http://localhost
SESSION_DRIVER=cookie
SESSION_DOMAIN=localhost
SANCTUM_STATEFUL_DOMAINS=localhost:5173
```

### 2) Start services
```bash
docker compose up -d --build
```

### 3) Install / migrate inside PHP container
```bash
docker exec -it laravel_app bash -lc "composer install && php artisan key:generate && php artisan migrate && php artisan storage:link"
```

If you see permission issues:
```bash
docker exec -it laravel_app bash -lc "chown -R www-data:www-data storage bootstrap/cache && find storage bootstrap/cache -type d -exec chmod 775 {} \; && find storage bootstrap/cache -type f -exec chmod 664 {} \;"
```

### 4) Test
- API: http://localhost
- Health: `php artisan about`, `php artisan tinker` (inside container)

---

## 🧪 Using a React SPA (recommended)

Create your SPA in a sibling folder (outside Docker):

```
/project-root
  /api   # this repo (Laravel + Docker)
  /web   # your React app (Vite)
```

In `/web`:
```bash
npm create vite@latest web -- --template react
cd web && npm i axios react-router-dom
```

`/web/.env`:
```
VITE_API_URL=http://localhost/api/v1
```

Axios client (with Sanctum cookies):
```ts
const api = axios.create({ baseURL: import.meta.env.VITE_API_URL, withCredentials: true });
await axios.get('http://localhost/sanctum/csrf-cookie', { withCredentials: true });
await api.post('/auth/login', { email, password });
```

Run SPA:
```bash
npm run dev  # runs on http://localhost:5173
```

---

## 🗃️ Structure

```
.
├── docker/
│   ├── nginx/
│   │   └── default.conf
│   └── php/
│       └── Dockerfile
├── public/
├── app/ …
├── composer.json
├── docker-compose.yml
└── README.md
```

---

## 🧰 Commands

```bash
docker compose logs -f nginx
docker compose logs -f app
docker exec -it laravel_app bash
docker compose down -v   # stop & remove containers and volumes
```

---

## 🧩 Optional additions

- **Redis** service for cache/queue
- **Mailpit** for local email testing
- Queue worker & scheduler containers (`queue`, `scheduler`)

---

## 📤 Production notes

- Use `npm run build` for SPA assets (hosted separately or via CDN)
- Enable HTTPS (TLS offload) and strict headers / CSP
- Consider Octane + Supervisor for high concurrency
- In production images, disable `opcache.validate_timestamps` and bake vendor into the image

---

MIT — enjoy! 🎉
