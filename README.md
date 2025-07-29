# 🚀 Laravel 12 + Docker + React Starter

A modern, containerized development environment for Laravel 12 with React, Vite, and MySQL — built using Docker for seamless local development.

---

## 🧱 Tech Stack

- ✅ Laravel 12 (PHP 8.2)
- ✅ React + Vite (with hot reload)
- ✅ Docker & Docker Compose
- ✅ MySQL 8
- ✅ Nginx (production-like web server)

---

## 📦 Features

- Full Laravel + React setup, ready for development
- Vite + React hot reloading inside Docker
- MySQL service with persistent volume
- Clean Blade/React integration
- Easily extendable (Redis, Mailpit, Horizon, etc.)

---

## ⚙️ Getting Started

### 1. Clone the Repo
```bash
git clone https://github.com/your-username/laravel-docker-react.git
cd laravel-docker-react
```

### 2. Copy the Environment File
```bash
cp .env.example .env
```

Update `.env` DB credentials if needed:
```
DB_HOST=mysql
DB_PORT=3306
DB_DATABASE=laravel
DB_USERNAME=laravel
DB_PASSWORD=secret
```

---

### 3. Start Docker Services
```bash
docker-compose up -d --build
```

This will start:
- `app` (PHP + Laravel)
- `nginx` (web server)
- `mysql` (database)

---

### 4. Enter Container and Install Laravel
```bash
docker exec -it laravel_app bash
composer install
php artisan key:generate
php artisan migrate
exit
```

---

### 5. Install Frontend Dependencies
```bash
npm install
npm run dev
```

> You should see the Vite dev server at http://localhost:5173 and the Laravel app at http://localhost.

---

## 🧪 Testing React Inside Blade

In your Blade file:
```blade
<div id="react-root"></div>
@vite('resources/js/app.jsx')
```

`resources/js/app.jsx`:
```jsx
import React from 'react';
import { createRoot } from 'react-dom/client';
import Example from './components/Example';

const root = document.getElementById('react-root');
if (root) {
    createRoot(root).render(<Example />);
}
```

---

## 🗃️ Project Structure

```
.
├── docker/                  # Docker configs
│   ├── php/Dockerfile       # PHP + Composer
│   └── nginx/default.conf   # Nginx config
├── resources/js/            # React code
├── public/                  # Public web root
├── .env.example             # Environment template
├── docker-compose.yml       # Service definitions
├── vite.config.js           # Vite config for React
└── README.md
```

---

## 📌 Tips

- Use `docker-compose down -v` to remove containers and volumes
- Laravel logs live in `storage/logs/`
- You can add Redis, Mailpit, or Horizon to your compose stack

---

## 📤 Deployment

This setup is for **local development**. For production:
- Use `npm run build` for assets
- Add HTTPS (e.g. Caddy or Let's Encrypt)
- Consider Laravel Octane, Supervisor, and optimized Nginx configs

---

## 📄 License

MIT — free to use, extend, and contribute!
