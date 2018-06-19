# Show available make commands.
usage:
	@echo "Please supply one of:"
	@echo "\tinit:\n\t\t- Initializes WordPress (by cloning from Git)."
	@echo "\tbuild:\n\t\t- Rebuilds the WordPress Docker image."
	@echo "\tup:\n\t\t- Run Docker images with 'docker-compose up'."
	@echo "\tdown:\n\t\t- Stops Docker images with 'docker-compose down'."

# Initializes WordPress.
init:
	@docker-compose run --rm -w /app/wordpress wordpress-php composer install

build:
	@docker-compose build

up: init
	@docker-compose up

down:
	@docker-compose down
