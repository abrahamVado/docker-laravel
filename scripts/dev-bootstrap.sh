#!/usr/bin/env bash
set -euo pipefail

REPO_URL="${REPO_URL:-https://github.com/abrahamVado/Yamato-Laravel-API.git}"
REPO_REF="${REPO_REF:-main}"

# 1) clone if missing
if [ ! -d "./app" ]; then
  echo "Cloning $REPO_URL (branch/tag: $REPO_REF) into ./app ..."
  git clone --depth 1 --branch "$REPO_REF" "$REPO_URL" app
else
  echo "./app exists; skipping clone."
fi

# 2) bring up infra
docker compose up -d --build postgres redis mailpit app nginx

# 3) prepare env
if [ ! -f "./app/.env" ] && [ -f "./app/.env.example" ]; then
  cp ./app/.env.example ./app/.env
fi

# idempotent patch
sed -i 's/^DB_CONNECTION=.*/DB_CONNECTION=pgsql/' ./app/.env || true
sed -i 's/^DB_HOST=.*/DB_HOST=postgres/' ./app/.env || true
sed -i 's/^DB_PORT=.*/DB_PORT=5432/' ./app/.env || true
sed -i 's/^DB_DATABASE=.*/DB_DATABASE=yamato/' ./app/.env || true
sed -i 's/^DB_USERNAME=.*/DB_USERNAME=postgres/' ./app/.env || true
sed -i 's/^DB_PASSWORD=.*/DB_PASSWORD=secret123/' ./app/.env || true
grep -q '^REDIS_HOST=' ./app/.env || echo 'REDIS_HOST=redis' >> ./app/.env
grep -q '^REDIS_PORT=' ./app/.env || echo 'REDIS_PORT=6379' >> ./app/.env

# optional mailpit defaults
grep -q '^MAIL_MAILER=' ./app/.env || echo 'MAIL_MAILER=smtp' >> ./app/.env
grep -q '^MAIL_HOST='   ./app/.env || echo 'MAIL_HOST=mailpit' >> ./app/.env
grep -q '^MAIL_PORT='   ./app/.env || echo 'MAIL_PORT=1025' >> ./app/.env
grep -q '^MAIL_ENCRYPTION=' ./app/.env || echo 'MAIL_ENCRYPTION=null' >> ./app/.env
grep -q '^MAIL_USERNAME=' ./app/.env || echo 'MAIL_USERNAME=null' >> ./app/.env
grep -q '^MAIL_PASSWORD=' ./app/.env || echo 'MAIL_PASSWORD=null' >> ./app/.env

# 4) install & migrate inside php container
docker compose exec -T app bash -lc '
  set -e
  composer install
  php artisan key:generate || true
  php artisan migrate --force
  php artisan storage:link || true
'

echo
echo "All set."
echo "- App:      http://localhost"
echo "- Mailpit:  http://localhost:8025"
