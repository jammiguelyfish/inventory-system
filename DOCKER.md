# 🐳 Docker Deployment Guide

Complete guide for running the Laundry Inventory System using Docker and Docker Compose.

## 📋 Prerequisites

- **Docker** 20.10 or higher
- **Docker Compose** 2.0 or higher

Check your installation:
```bash
docker --version
docker-compose --version
```

## 🚀 Quick Start (Docker)

### Option 1: Using Docker Compose (Recommended)

The easiest way to run the entire application stack:

```bash
# Navigate to project directory
cd laundry-inventory

# Start all services (PostgreSQL + Spring Boot App)
docker-compose up -d

# View logs
docker-compose logs -f

# Stop all services
docker-compose down

# Stop and remove volumes (WARNING: deletes database data)
docker-compose down -v
```

That's it! The application will be available at:
```
http://localhost:8080
```

### Option 2: Using Docker Commands Only

If you prefer to run containers manually:

```bash
# Create a network
docker network create laundry-network

# Run PostgreSQL
docker run -d \
  --name laundry-postgres \
  --network laundry-network \
  -e POSTGRES_DB=laundry_inventory \
  -e POSTGRES_USER=postgres \
  -e POSTGRES_PASSWORD=postgres \
  -p 5432:5432 \
  -v postgres-data:/var/lib/postgresql/data \
  postgres:15-alpine

# Build the application image
docker build -t laundry-app .

# Run the application
docker run -d \
  --name laundry-app \
  --network laundry-network \
  -e SPRING_DATASOURCE_URL=jdbc:postgresql://laundry-postgres:5432/laundry_inventory \
  -e SPRING_DATASOURCE_USERNAME=postgres \
  -e SPRING_DATASOURCE_PASSWORD=postgres \
  -p 8080:8080 \
  laundry-app
```

## 📦 What's Included

The Docker setup includes:

- **PostgreSQL 15** - Database server
- **Spring Boot App** - Backend API and frontend
- **Persistent Storage** - Database data persists across container restarts
- **Health Checks** - Automatic health monitoring
- **Auto-restart** - Containers restart on failure
- **Sample Data** - Pre-loaded inventory items

## 🔧 Configuration

### Environment Variables

Edit `docker-compose.yml` to customize:

```yaml
environment:
  # Database connection
  SPRING_DATASOURCE_URL: jdbc:postgresql://postgres:5432/laundry_inventory
  SPRING_DATASOURCE_USERNAME: postgres
  SPRING_DATASOURCE_PASSWORD: postgres  # Change in production!
  
  # JPA settings
  SPRING_JPA_HIBERNATE_DDL_AUTO: update
  
  # Server port (also update ports mapping)
  SERVER_PORT: 8080
```

### Custom Ports

To change the application port, edit `docker-compose.yml`:

```yaml
services:
  app:
    ports:
      - "9090:8080"  # Access on port 9090
```

### Database Credentials

**⚠️ IMPORTANT**: Change default passwords for production!

In `docker-compose.yml`:
```yaml
postgres:
  environment:
    POSTGRES_PASSWORD: your_secure_password_here

app:
  environment:
    SPRING_DATASOURCE_PASSWORD: your_secure_password_here
```

## 📊 Docker Compose Commands

### Basic Operations

```bash
# Start services
docker-compose up -d

# Start and view logs
docker-compose up

# Stop services
docker-compose down

# Restart services
docker-compose restart

# View logs
docker-compose logs -f

# View logs for specific service
docker-compose logs -f app
docker-compose logs -f postgres
```

### Management Commands

```bash
# List running containers
docker-compose ps

# Execute command in container
docker-compose exec app sh
docker-compose exec postgres psql -U postgres -d laundry_inventory

# View container resource usage
docker-compose stats

# Rebuild and restart
docker-compose up -d --build

# Pull latest images
docker-compose pull
```

### Database Operations

```bash
# Access PostgreSQL CLI
docker-compose exec postgres psql -U postgres -d laundry_inventory

# Backup database
docker-compose exec postgres pg_dump -U postgres laundry_inventory > backup.sql

# Restore database
docker-compose exec -T postgres psql -U postgres laundry_inventory < backup.sql

# View database logs
docker-compose logs postgres
```

## 🗄️ Data Persistence

Database data is stored in a Docker volume named `postgres-data`.

### Backup Data Volume

```bash
# Create backup
docker run --rm \
  -v laundry-inventory_postgres-data:/data \
  -v $(pwd):/backup \
  alpine tar czf /backup/postgres-backup.tar.gz -C /data .

# Restore backup
docker run --rm \
  -v laundry-inventory_postgres-data:/data \
  -v $(pwd):/backup \
  alpine tar xzf /backup/postgres-backup.tar.gz -C /data
```

### Reset Database

```bash
# Stop services and remove volumes
docker-compose down -v

# Start fresh
docker-compose up -d
```

## 🔍 Troubleshooting

### Check Container Health

```bash
# View container status
docker-compose ps

# Check health status
docker inspect laundry-app | grep -A 10 Health
docker inspect laundry-postgres | grep -A 10 Health
```

### Common Issues

#### 1. Port Already in Use

```bash
# Check what's using port 8080
lsof -i :8080  # Linux/Mac
netstat -ano | findstr :8080  # Windows

# Option 1: Stop the conflicting service
# Option 2: Change port in docker-compose.yml
```

#### 2. Database Connection Failed

```bash
# Check if PostgreSQL is ready
docker-compose exec postgres pg_isready -U postgres

# View database logs
docker-compose logs postgres

# Restart database
docker-compose restart postgres
```

#### 3. Application Won't Start

```bash
# View application logs
docker-compose logs app

# Rebuild the image
docker-compose up -d --build

# Check if database is accessible from app
docker-compose exec app ping postgres
```

#### 4. Changes Not Reflecting

```bash
# Rebuild without cache
docker-compose build --no-cache

# Remove old images
docker-compose down
docker rmi laundry-inventory_app
docker-compose up -d --build
```

### View All Logs

```bash
# All services
docker-compose logs -f

# Last 100 lines
docker-compose logs --tail=100

# Since last hour
docker-compose logs --since 1h
```

## 🚢 Production Deployment

### Best Practices

1. **Use Environment Files**

Create `.env` file:
```env
POSTGRES_PASSWORD=secure_password_here
DB_USER=postgres
DB_NAME=laundry_inventory
APP_PORT=8080
```

Update `docker-compose.yml`:
```yaml
environment:
  POSTGRES_PASSWORD: ${POSTGRES_PASSWORD}
```

2. **Use Secrets** (Docker Swarm)

```yaml
secrets:
  postgres_password:
    external: true

services:
  postgres:
    secrets:
      - postgres_password
    environment:
      POSTGRES_PASSWORD_FILE: /run/secrets/postgres_password
```

3. **Enable SSL/TLS**

Add reverse proxy (Nginx/Traefik) with SSL certificates.

4. **Resource Limits**

```yaml
services:
  app:
    deploy:
      resources:
        limits:
          cpus: '1'
          memory: 1G
        reservations:
          cpus: '0.5'
          memory: 512M
```

5. **Use Docker Compose Override**

Create `docker-compose.prod.yml`:
```yaml
services:
  app:
    environment:
      SPRING_PROFILES_ACTIVE: production
    restart: always
```

Run with:
```bash
docker-compose -f docker-compose.yml -f docker-compose.prod.yml up -d
```

## 📈 Monitoring

### Container Logs

```bash
# Real-time logs
docker-compose logs -f

# Export logs
docker-compose logs > app.log
```

### Resource Usage

```bash
# Live stats
docker stats

# Specific containers
docker stats laundry-app laundry-postgres
```

### Health Checks

```bash
# Application health
curl http://localhost:8080/api/items

# Database health
docker-compose exec postgres pg_isready
```

## 🧹 Cleanup

### Remove Containers

```bash
# Stop and remove containers
docker-compose down

# Also remove volumes (deletes data!)
docker-compose down -v

# Remove orphaned containers
docker-compose down --remove-orphans
```

### Remove Images

```bash
# Remove application image
docker rmi laundry-inventory_app

# Remove all unused images
docker image prune -a
```

### Complete Cleanup

```bash
# Remove everything (containers, volumes, images)
docker-compose down -v --rmi all

# System-wide cleanup
docker system prune -a --volumes
```

## 🔐 Security Notes

### Production Checklist

- [ ] Change default passwords
- [ ] Use environment variables for secrets
- [ ] Don't expose PostgreSQL port (5432) publicly
- [ ] Use SSL/TLS for connections
- [ ] Implement proper network isolation
- [ ] Regular backups
- [ ] Update base images regularly
- [ ] Enable firewall rules
- [ ] Use non-root users (already configured)
- [ ] Scan images for vulnerabilities

### Scan for Vulnerabilities

```bash
# Using Docker Scout
docker scout cves laundry-inventory_app

# Using Trivy
trivy image laundry-inventory_app
```

## 📚 Additional Resources

- [Docker Documentation](https://docs.docker.com/)
- [Docker Compose Reference](https://docs.docker.com/compose/)
- [Spring Boot with Docker](https://spring.io/guides/topicals/spring-boot-docker)
- [PostgreSQL Docker Hub](https://hub.docker.com/_/postgres)

## 🆘 Getting Help

If you encounter issues:

1. Check logs: `docker-compose logs -f`
2. Verify health: `docker-compose ps`
3. Review this guide's troubleshooting section
4. Check Docker daemon: `docker info`

---

**Happy Dockerizing! 🐳**
