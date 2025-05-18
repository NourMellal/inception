# Inception Project Makefile

# Variables
DOCKER_COMPOSE = cd srcs && docker-compose
ENV_FILE = srcs/.env
VOLUME_DIRS = /home/nmellal/data/wordpress /home/nmellal/data/mariadb

# Colors
GREEN = \033[0;32m
RED = \033[0;31m
YELLOW = \033[0;33m
NC = \033[0m

# Main targets
all: setup build up

# Check if .env file exists
check-env:
	@if [ ! -f $(ENV_FILE) ]; then \
		echo "$(RED)Error: .env file is missing!$(NC)"; \
		exit 1; \
	fi
	@echo "$(GREEN)Environment file exists.$(NC)"

# Create necessary directories for volumes
setup: check-env
	@echo "$(YELLOW)Creating necessary directories...$(NC)"
	@mkdir -p $(VOLUME_DIRS)
	@echo "$(GREEN)Setup complete!$(NC)"

# Build the containers
build: check-env
	@echo "$(YELLOW)Building containers...$(NC)"
	@$(DOCKER_COMPOSE) build
	@echo "$(GREEN)Build complete!$(NC)"

# Start the containers
up: check-env
	@echo "$(YELLOW)Starting containers...$(NC)"
	@$(DOCKER_COMPOSE) up -d
	@echo "$(GREEN)Containers are running!$(NC)"

# Stop the containers
down:
	@echo "$(YELLOW)Stopping containers...$(NC)"
	@$(DOCKER_COMPOSE) down
	@echo "$(GREEN)Containers stopped!$(NC)"

# Show container logs
logs:
	@$(DOCKER_COMPOSE) logs

# Follow container logs
logs-f:
	@$(DOCKER_COMPOSE) logs -f

# Remove containers, volumes and networks
clean:
	@echo "$(YELLOW)Cleaning containers and networks...$(NC)"
	@$(DOCKER_COMPOSE) down --volumes
	@echo "$(GREEN)Clean complete!$(NC)"

# Remove containers, volumes, networks and images
fclean: clean
	@echo "$(YELLOW)Full cleaning (including images)...$(NC)"
	@$(DOCKER_COMPOSE) down --volumes --rmi all
	@echo "$(GREEN)Full clean complete!$(NC)"

# Prune unused Docker objects
prune:
	@echo "$(YELLOW)Pruning unused Docker objects...$(NC)"
	@docker system prune -a --volumes -f
	@echo "$(GREEN)Prune complete!$(NC)"

# Restart containers
restart: down up

# Rebuild and start containers
re: fclean setup all

# Check status of containers
status:
	@docker ps -a
	@echo "\n$(YELLOW)Networks:$(NC)"
	@docker network ls | grep inception
	@echo "\n$(YELLOW)Volumes:$(NC)"
	@docker volume ls | grep inception

.PHONY: all check-env setup build up down logs logs-f clean fclean prune restart re status