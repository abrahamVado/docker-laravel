SHELL := /bin/bash

.PHONY: up down restart logs shell migrate tinker perms fresh seed

up:
	docker compose up -d --build

down:
	docker compose down

restart:
	docker compose down; docker compose up -d --build

logs:
	docker compose logs -f --tail=200 app nginx postgres

shell:
	docker compose exec app bash

migrate:
	docker compose exec app php artisan migrate

fresh:
	docker compose exec app php artisan migrate:fresh --seed

seed:
	docker compose exec app php artisan db:seed

tinker:
	docker compose exec app php artisan tinker

perms:
	docker compose exec app bash -lc "chown -R www-data:www-data storage bootstrap/cache || true && chmod -R ug+rw storage bootstrap/cache"
