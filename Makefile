COMPOSE_FILE=./srcs/docker-compose.yml
all: build

build:
	docker compose -f ${COMPOSE_FILE} up --build -d --remove-orphans
clean:
	docker compose -f ${COMPOSE_FILE} down
re: clean all
ps:
	cd srcs && docker ps -a