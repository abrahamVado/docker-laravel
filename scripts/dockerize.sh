#!/usr/bin/env bash
set -euo pipefail

if [ ! -f ".env" ]; then
  echo "No .env found. Run: cp .env.example .env and configure it first."
  exit 1
fi

# Create .env.docker if not exists
cp -n .env .env.docker || true

# sed inline cross-platform (GNU/macOS)
if sed --version >/dev/null 2>&1; then SED_INPLACE=(-i); else SED_INPLACE=(-i ''); fi

# Rewrite Docker-friendly values in .env.docker
sed "${SED_INPLACE[@]}" \
  -e 's/^APP_ENV=.*/APP_ENV=local/' \
  -e 's#^APP_URL=.*#APP_URL=http://localhost#' \
  -e 's/^DB_CONNECTION=.*/DB_CONNECTION=mysql/' \
  -e 's/^DB_HOST=.*/DB_HOST=mysql/' \
  -e 's/^DB_PORT=.*/DB_PORT=3306/' \
  -e 's/^SESSION_DRIVER=.*/SESSION_DRIVER=cookie/' \
  -e 's/^SESSION_DOMAIN=.*/SESSION_DOMAIN=localhost/' \
  -e '/^SANCTUM_STATEFUL_DOMAINS=/c\SANCTUM_STATEFUL_DOMAINS=localhost:5173' \
  .env.docker

echo "Starting Docker services…"
export COMPOSE_IGNORE_ORPHANS=1
docker compose up -d --build

echo "Copying .env.docker into the running container as .env …"
docker exec -it laravel_app bash -lc 'cp .env.docker .env'

echo "Installing dependencies & running migrations…"
docker exec -it laravel_app bash -lc " \
  composer install --no-interaction && \
  php artisan key:generate --force && \
  php artisan migrate --force && \
  php artisan storage:link || true \
"

echo "All set! Open http://localhost"
