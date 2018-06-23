-include .env

# Show available make commands.
usage:
	@echo "Please supply one of:"
	@echo "\tenv\n\t\t- Copies .env.dist to .env"
	@echo "\tsetup\n\t\t- Prepares WordPress folders and installs WordPress."
	@echo "\tbuild\n\t\t- Rebuilds the WordPress Docker image."
	@echo "\tup\n\t\t- Run WordPress services with 'docker-compose up'."
	@echo "\tdown\n\t\t- Stops WordPress services with 'docker-compose down'."

# env copies the environment variables.
env:
	cp .env.dist .env

# setup prepares your project and installs WordPress.
setup:
	@docker-compose --log-level CRITICAL up -d wordpress-php 2>/dev/null
	@docker-compose exec -w /app/wordpress wordpress-php composer install
	@docker-compose exec -w /app/wordpress/core wordpress-php wp core download --skip-content
ifneq (${WP_MULTISITE},true)
	@echo "Running WordPress single site installation..."
	@docker-compose exec -w /app/wordpress/core wordpress-php sh -c 'wp core install --url="${WP_DOMAIN}" --admin_user="${WP_USER}" --admin_password="${WP_PASS}" --admin_email=${WP_EMAIL} --skip-email --title="${WP_SITE_TITLE}"'
else
	@echo "Running WordPress multi-site network installation..."
	@docker-compose exec -w /app/wordpress/core wordpress-php sh -c 'wp core multisite-install --url="${WP_DOMAIN}" --admin_user="${WP_USER}" --admin_password="${WP_PASS}" --admin_email=${WP_EMAIL} --skip-email --title="${WP_SITE_TITLE}"'
endif
	@docker-compose down 2>/dev/null
	@echo "[DONE] Run 'make up' to start the WordPress services."

# build rebuilds your WordPress PHP image.
build:
	@docker-compose build --no-cache

# up launches the WordPress services.
up:
	@docker-compose up

# down gracefully shuts it all down.
down:
	@docker-compose down

cron:
	@crontab -l | grep -q 'http://wordpress.local/wp-cron.php?doing_wp_cron'  && echo 'entry exists' || (crontab -l 2>/dev/null; echo "*/5 * * * * curl http://wordpress.local/wp-cron.php?doing_wp_cron >/dev/null 2>&1") | crontab -
	@echo Cron task added.

cleancron:
	@crontab -l | grep -q 'http://wordpress.local/wp-cron.php?doing_wp_cron' | crontab -

# CAUTION: Use the below targets only if you know what you're doing.

# kill the WordPress database. You will need to run `make init` to get it back.
kill:
	@docker-compose run --rm -w /app/wordpress/core wordpress-php wp db drop --yes 2>/dev/null
	@docker-compose down 2>/dev/null

# init the WordPress database. This will fail if a database exists.
init:
	@docker-compose run --rm -w /app/wordpress/core wordpress-php wp db create 2>/dev/null
	@docker-compose down 2>/dev/null

# reset the WordPress database. You will have an empty `wordpress` table.
reset: kill init
