NAME = inception

COMPOSE = docker compose -f srcs/docker-compose.yml

DATA_DIR = /home/$(USER)/data
WP_DIR = $(DATA_DIR)/wordpress
DB_DIR = $(DATA_DIR)/mariadb

all: up

up:
	mkdir -p $(WP_DIR)
	mkdir -p $(DB_DIR)
	$(COMPOSE) up -d --build

down:
	$(COMPOSE) down

clean:
	$(COMPOSE) down --volumes --remove-orphans

fclean: clean
	docker system prune -af
	sudo find $(WP_DIR) -mindepth 1 -delete
	sudo find $(DB_DIR) -mindepth 1 -delete

re: fclean up
