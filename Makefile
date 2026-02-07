# Makefile for Laundry Inventory System
# Simplifies common Docker operations

.PHONY: help build up down restart logs clean test backup restore

# Default target
help:
	@echo "Laundry Inventory System - Docker Commands"
	@echo ""
	@echo "Available commands:"
	@echo "  make build      - Build Docker images"
	@echo "  make up         - Start all services"
	@echo "  make down       - Stop all services"
	@echo "  make restart    - Restart all services"
	@echo "  make logs       - View logs (all services)"
	@echo "  make logs-app   - View application logs"
	@echo "  make logs-db    - View database logs"
	@echo "  make clean      - Remove containers and volumes"
	@echo "  make rebuild    - Rebuild and restart"
	@echo "  make shell-app  - Access application shell"
	@echo "  make shell-db   - Access database shell"
	@echo "  make backup     - Backup database"
	@echo "  make restore    - Restore database from backup"
	@echo "  make test       - Test application endpoints"
	@echo "  make ps         - Show running containers"
	@echo "  make stats      - Show container statistics"

# Build images
build:
	docker-compose build

# Start services in detached mode
up:
	docker-compose up -d
	@echo "Services started! Access at http://localhost:8080"

# Start services and show logs
up-logs:
	docker-compose up

# Stop services
down:
	docker-compose down

# Restart services
restart:
	docker-compose restart

# View all logs
logs:
	docker-compose logs -f

# View application logs
logs-app:
	docker-compose logs -f app

# View database logs
logs-db:
	docker-compose logs -f postgres

# Clean everything (including volumes)
clean:
	docker-compose down -v
	@echo "All containers and volumes removed"

# Rebuild and restart
rebuild:
	docker-compose down
	docker-compose build --no-cache
	docker-compose up -d
	@echo "Services rebuilt and restarted!"

# Access application shell
shell-app:
	docker-compose exec app sh

# Access database shell
shell-db:
	docker-compose exec postgres psql -U postgres -d laundry_inventory

# Show running containers
ps:
	docker-compose ps

# Show container statistics
stats:
	docker stats laundry-app laundry-postgres

# Backup database
backup:
	@mkdir -p backups
	docker-compose exec -T postgres pg_dump -U postgres laundry_inventory > backups/backup_$$(date +%Y%m%d_%H%M%S).sql
	@echo "Database backed up to backups/ directory"

# Restore database (use: make restore FILE=backups/backup_20240101_120000.sql)
restore:
	@if [ -z "$(FILE)" ]; then \
		echo "Usage: make restore FILE=backups/backup_YYYYMMDD_HHMMSS.sql"; \
		exit 1; \
	fi
	docker-compose exec -T postgres psql -U postgres laundry_inventory < $(FILE)
	@echo "Database restored from $(FILE)"

# Test application endpoints
test:
	@echo "Testing application health..."
	@curl -s -o /dev/null -w "%{http_code}" http://localhost:8080/api/items && echo " - API endpoint OK" || echo " - API endpoint FAILED"
	@echo "Testing database connection..."
	@docker-compose exec postgres pg_isready -U postgres && echo "Database OK" || echo "Database FAILED"

# Production deployment
prod-up:
	docker-compose -f docker-compose.yml -f docker-compose.prod.yml up -d
	@echo "Production services started!"

prod-down:
	docker-compose -f docker-compose.yml -f docker-compose.prod.yml down

# Development mode (with hot reload)
dev:
	docker-compose up

# View help for production commands
prod-help:
	@echo "Production Commands:"
	@echo "  make prod-up    - Start in production mode"
	@echo "  make prod-down  - Stop production services"
