# Quick Start Guide - Laundry Inventory System

## 2-Minute Setup with Docker (Recommended)

### Prerequisites
- Docker Desktop installed 
### Steps

```bash
# 1. Navigate to project directory
cd laundry-inventory

# 2. Start everything
docker-compose up -d

# 3. Open browser
http://localhost:8080
```

**Done!** The application is running with sample data.

### Common Docker Commands
```bash
# View logs
docker-compose logs -f

# Stop services
docker-compose down

# Restart services
docker-compose restart

# Access database
docker-compose exec postgres psql -U postgres -d laundry_inventory
```

---

## Alternative: Manual Setup (5 Minutes)

### Prerequisites
```bash
# Check Java (needs 17+)
java -version

# Check PostgreSQL (needs 12+)
psql --version

# Check Maven (needs 3.6+)
mvn -version
```

### Step 2: Setup Database
```bash
# Login to PostgreSQL
psql -U postgres

# Create database
CREATE DATABASE laundry_inventory;

# Exit
\q
```

### Step 3: Configure Application
Edit `src/main/resources/application.properties`:
```properties
spring.datasource.password=YOUR_POSTGRES_PASSWORD
```

### Step 4: Run Application
```bash
# From project root directory
mvn spring-boot:run
```

### Step 5: Open Browser
```
http://localhost:8080
```

## First Steps After Launch

1. **Add Your First Item**
   - Click "+ Add New Item" button
   - Fill in the form (minimum: name, category, quantity, unit)
   - Click "Save Item"

2. **Try Stock Adjustment**
   - Click "Stock" button on any item
   - Choose "Add Stock" or "Remove Stock"
   - Enter quantity and submit

3. **Use Search & Filter**
   - Type in search box to find items
   - Use category dropdown to filter
   - Click "Refresh" to see all items

## Sample Data

The database/setup.sql file includes sample data. To load it:

```bash
psql -U postgres -d laundry_inventory -f database/setup.sql
```

## Common Issues

**Port 8080 in use?**
```properties
# Change in application.properties
server.port=9090
```
```javascript
// Update in js/app.js
const API_URL = 'http://localhost:9090/api/items';
```

**Database connection failed?**
- Check PostgreSQL is running
- Verify password in application.properties
- Ensure database 'laundry_inventory' exists

**Build failed?**
```bash
mvn clean install -U
```
<br><br>

*Read the full README.md for detailed documentation*

