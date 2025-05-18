COMPOSE_FILE=./srcs/docker-compose.yml
all:
	sudo docker compose -f ${COMPOSE_FILE} up
build:
	sudo docker compose -f ${COMPOSE_FILE} up --build -d --remove-orphans
clean:
	sudo docker compose -f ${COMPOSE_FILE} down
re: clean all
ps:
	cd srcs && sudo docker ps -a