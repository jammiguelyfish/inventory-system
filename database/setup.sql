-- Database setup script for Laundry Inventory System
-- PostgreSQL Database

-- Create database (run this first as postgres user)
CREATE DATABASE laundry_inventory;

-- Connect to the database
\c laundry_inventory;

-- The table will be auto-created by Spring Boot JPA with ddl-auto=update
-- But here's the manual creation script for reference:

CREATE TABLE IF NOT EXISTS inventory_items (
    id BIGSERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    category VARCHAR(100) NOT NULL,
    quantity INTEGER NOT NULL,
    unit VARCHAR(50) NOT NULL,
    price_per_unit DECIMAL(10, 2),
    minimum_stock INTEGER,
    supplier VARCHAR(255),
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Insert sample data for testing
INSERT INTO inventory_items (name, category, quantity, unit, price_per_unit, minimum_stock, supplier, description)
VALUES 
    ('Tide Liquid Detergent', 'Detergent', 25, 'bottles', 350.00, 10, 'ABC Suppliers Inc.', '1 liter bottle, heavy duty'),
    ('Downy Fabric Softener', 'Fabric Softener', 15, 'bottles', 280.00, 8, 'ABC Suppliers Inc.', '900ml bottle, fresh scent'),
    ('Clorox Bleach', 'Bleach', 30, 'bottles', 120.00, 15, 'XYZ Trading', '1 liter bottle'),
    ('Vanish Stain Remover', 'Stain Remover', 12, 'bottles', 450.00, 5, 'ABC Suppliers Inc.', 'Powder form, 500g'),
    ('Washing Machine Belt', 'Equipment', 3, 'pieces', 850.00, 2, 'Equipment Pro', 'Standard size belt'),
    ('Plastic Hangers', 'Packaging', 200, 'pieces', 5.00, 50, 'Local Market', 'Standard size'),
    ('Laundry Bags', 'Packaging', 45, 'pieces', 25.00, 20, 'Packaging Solutions', 'Large mesh bags'),
    ('Iron', 'Equipment', 2, 'pieces', 1500.00, 1, 'Appliance Store', 'Steam iron'),
    ('Ariel Powder Detergent', 'Detergent', 18, 'boxes', 420.00, 10, 'ABC Suppliers Inc.', '1kg box');

-- Create index for faster searches
CREATE INDEX idx_category ON inventory_items(category);
CREATE INDEX idx_name ON inventory_items(name);

-- View to check low stock items
CREATE OR REPLACE VIEW low_stock_items AS
SELECT * FROM inventory_items
WHERE minimum_stock IS NOT NULL 
  AND quantity <= minimum_stock
ORDER BY quantity ASC;

-- Function to update the updated_at timestamp
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Trigger to automatically update updated_at
CREATE TRIGGER update_inventory_items_updated_at
BEFORE UPDATE ON inventory_items
FOR EACH ROW
EXECUTE FUNCTION update_updated_at_column();
