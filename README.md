# Laundry Shop Inventory Management System [WORK IN PROGRESS]

A full-stack web application for managing inventory. Built with Java Spring Boot backend and vanilla JavaScript frontend. In this code, a laundry shop was used as an example for the inventory.

## Features

- Add, edit, and delete inventory items
- Real-time stock tracking
- Search and filter functionality
- Low stock alerts
- Stock adjustment (add/remove)
- Price per unit tracking
- Supplier management
- Responsive design

## Tech Stack

### Backend
- **Java 17+**
- **Spring Boot 3.2.0**
  - Spring Web
  - Spring Data JPA
  - Spring Boot DevTools
- **PostgreSQL** (Database)
- **Maven** (Build tool)

### Frontend
- **HTML5**
- **CSS3** (Vanilla, no frameworks)
- **JavaScript** (Vanilla, no frameworks)

## Project Structure

```
laundry-inventory/
├── src/
│   ├── main/
│   │   ├── java/com/laundry/inventory/
│   │   │   ├── LaundryInventoryApplication.java
│   │   │   ├── controller/
│   │   │   │   └── ItemController.java
│   │   │   ├── model/
│   │   │   │   └── Item.java
│   │   │   ├── repository/
│   │   │   │   └── ItemRepository.java
│   │   │   └── service/
│   │   │       └── ItemService.java
│   │   └── resources/
│   │       ├── application.properties
│   │       └── static/
│   │           ├── index.html
│   │           ├── css/
│   │           │   └── styles.css
│   │           └── js/
│   │               └── app.js
├── database/
│   └── setup.sql
└── pom.xml
```

## Getting Started

### Docker Quick Start (Recommended)

The easiest way to run the application:

```bash
# Start everything with Docker Compose
docker-compose up -d

# Access the application
open http://localhost:8080
```

The application and database are ready to use.

For detailed Docker instructions, see **[DOCKER.md](DOCKER.md)**

### Manual Installation

If you prefer to run without Docker:

#### Prerequisites

1. **Java 17 or higher**
   ```bash
   java -version
   ```

2. **PostgreSQL 12 or higher**
   ```bash
   psql --version
   ```

3. **Maven 3.6+**
   ```bash
   mvn -version
   ```

4. **VS Code** (recommended) with Java Extension Pack

#### Installation Steps

#### 1. Clone or Download the Project

```bash
cd inventory-system
```

#### 2. Set Up PostgreSQL Database

Open PostgreSQL command line or pgAdmin:

```bash
# Connect to PostgreSQL
psql -U postgres

# Run the setup script
\i database/setup.sql

# Or manually create the database
CREATE DATABASE laundry_inventory;
```

#### 3. Configure Database Connection

Edit `src/main/resources/application.properties`:

```properties
spring.datasource.url=jdbc:postgresql://localhost:5432/laundry_inventory
spring.datasource.username=postgres
spring.datasource.password=your_password_here
```

Replace `your_password_here` with your PostgreSQL password.

#### 4. Build the Project

```bash
mvn clean install
```

#### 5. Run the Application

```bash
mvn spring-boot:run
```

Or run from VS Code:
- Open the project in VS Code
- Open `LaundryInventoryApplication.java`
- Click "Run" above the main method

#### 6. Access the Application

Open your web browser and navigate to:
```
http://localhost:8080
```

## API Endpoints

### Items

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/api/items` | Get all items |
| GET | `/api/items/{id}` | Get item by ID |
| POST | `/api/items` | Create new item |
| PUT | `/api/items/{id}` | Update item |
| DELETE | `/api/items/{id}` | Delete item |
| GET | `/api/items/search?query={query}` | Search items |
| GET | `/api/items/category/{category}` | Filter by category |
| GET | `/api/items/low-stock` | Get low stock items |
| PATCH | `/api/items/{id}/stock` | Adjust stock |

### Example API Requests

#### Create Item
```bash
curl -X POST http://localhost:8080/api/items \
  -H "Content-Type: application/json" \
  -d '{
    "name": "Tide Detergent",
    "category": "Detergent",
    "quantity": 20,
    "unit": "bottles",
    "pricePerUnit": 350.00,
    "minimumStock": 10,
    "supplier": "ABC Suppliers"
  }'
```

#### Adjust Stock
```bash
curl -X PATCH http://localhost:8080/api/items/1/stock \
  -H "Content-Type: application/json" \
  -d '{"quantityChange": 5}'
```

## Frontend Features

### Dashboard
- View all inventory items in a table
- Color-coded status indicators (OK, Low Stock, Critical)
- Real-time low stock alerts

### Search & Filter
- Search items by name
- Filter by category
- Quick view of low stock items

### Inventory Management
- Add new items with detailed information
- Edit existing items
- Delete items with confirmation
- Adjust stock (add or remove)

### Categories
- Detergent
- Fabric Softener
- Bleach
- Stain Remover
- Equipment
- Packaging
- Other Supplies

## Database Schema

### inventory_items Table

| Column | Type | Description |
|--------|------|-------------|
| id | BIGSERIAL | Primary key |
| name | VARCHAR(255) | Item name |
| category | VARCHAR(100) | Item category |
| quantity | INTEGER | Current stock quantity |
| unit | VARCHAR(50) | Unit of measurement |
| price_per_unit | DECIMAL(10,2) | Price per unit |
| minimum_stock | INTEGER | Minimum stock threshold |
| supplier | VARCHAR(255) | Supplier name |
| description | TEXT | Item description |
| created_at | TIMESTAMP | Creation timestamp |
| updated_at | TIMESTAMP | Last update timestamp |

## Configuration

### Application Properties

```properties
# Server
server.port=8080

# Database
spring.datasource.url=jdbc:postgresql://localhost:5432/laundry_inventory
spring.datasource.username=postgres
spring.datasource.password=postgres

# JPA
spring.jpa.hibernate.ddl-auto=update
spring.jpa.show-sql=true
```

### Custom Port

To run on a different port, update `application.properties`:
```properties
server.port=9090
```

Then update the API_URL in `app.js`:
```javascript
const API_URL = 'http://localhost:9090/api/items';
```

## Troubleshooting

### Database Connection Error
- Verify PostgreSQL is running
- Check database credentials in application.properties
- Ensure database exists: `laundry_inventory`

### Build Errors
```bash
# Clean and rebuild
mvn clean install -U

# Skip tests if needed
mvn clean install -DskipTests
```

## Deployment

### Docker Deployment (Recommended)

The application is fully containerized and ready for deployment:

```bash
# Development
docker-compose up -d

# Production
docker-compose -f docker-compose.yml -f docker-compose.prod.yml up -d

# Using Makefile
make up          # Start services
make down        # Stop services
make logs        # View logs
make backup      # Backup database
```

### Traditional JAR Deployment

```bash
mvn clean package
java -jar target/inventory-1.0.0.jar
```



## License

This project is open source and available for educational purposes.




