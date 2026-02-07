## Quick Start



**Linux/Mac:**
```bash
./start.sh
```

**Windows:**
```batch
start.bat
```

### Manual Start

```bash
docker-compose up -d
```

Then open: **http://localhost:8080**

## What Gets Deployed

When you run `docker-compose up -d`:

1. **PostgreSQL Container**
   - Database: `laundry_inventory`
   - Port: 5432
   - Volume: Persistent data storage
   - Sample data automatically loaded

2. **Spring Boot Application Container**
   - Backend API + Frontend
   - Port: 8080
   - Automatically connects to database
   - Health checks enabled

### Change Database Password

1. Copy `.env.example` to `.env`
2. Update password:
```env
POSTGRES_PASSWORD=your_secure_password
```

3. Restart:
```bash
docker-compose down
docker-compose up -d
```

## Production Deployment

```bash
# Use production configuration
docker-compose -f docker-compose.yml -f docker-compose.prod.yml up -d

# Or with Makefile
make prod-up
```

Production mode includes:
- Resource limits
- Optimized JPA settings
- Reduced logging
- Restart policies

## Troubleshooting

### Container won't start
```bash
# Check logs
docker-compose logs

# Check status
docker-compose ps
```

### Database connection issues
```bash
# Check database health
docker-compose exec postgres pg_isready -U postgres

# Access database directly
docker-compose exec postgres psql -U postgres -d laundry_inventory
```

## Monitoring

### View Resource Usage
```bash
docker stats laundry-app laundry-postgres
```

### View Logs
```bash
# All logs
docker-compose logs -f

# Application only
docker-compose logs -f app

# Database only
docker-compose logs -f postgres
```

### Health Status
```bash
# Check application
curl http://localhost:8080/api/items

# Check containers
docker-compose ps
```


