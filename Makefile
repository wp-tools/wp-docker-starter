-include .env

# Show available make commands.
usage:
	@echo "Please supply one of:"
	@echo "\tinit:\n\t\t- Initializes WordPress (by cloning from Git)."
	@echo "\tbuild:\n\t\t- Rebuilds the WordPress Docker image."
	@echo "\tup:\n\t\t- Run Docker images with 'docker-compose up'."
	@echo "\tdown:\n\t\t- Stops Docker images with 'docker-compose down'."

# Initializes WordPress.
kill:
	@docker-compose run --rm -w /app/wordpress/core wordpress-php wp db drop --yes 2>/dev/null
	@docker-compose down 2>/dev/null

init:
	@docker-compose run --rm -w /app/wordpress/core wordpress-php wp db create 2>/dev/null
	@docker-compose down 2>/dev/null

reset: kill init

setup:
	@docker-compose --log-level CRITICAL up -d wordpress-php 2>/dev/null
	@docker-compose exec -w /app/wordpress wordpress-php composer install
ifneq (${WP_MULTISITE},true)
	@docker-compose exec -w /app/wordpress/core wordpress-php sh -c 'wp core install --url="${WP_DOMAIN}" --admin_user="${WP_USER}" --admin_password="${WP_PASS}" --admin_email=${WP_EMAIL} --skip-email --title="${WP_SITE_TITLE}"'
else
	@docker-compose exec -w /app/wordpress/core wordpress-php sh -c 'wp core multisite-install --url="${WP_DOMAIN}" --admin_user="${WP_USER}" --admin_password="${WP_PASS}" --admin_email=${WP_EMAIL} --skip-email --title="${WP_SITE_TITLE}"'
endif
	@docker-compose down 2>/dev/null

build:
	@docker-compose build

up:
	@docker-compose up

down:
	@docker-compose down
