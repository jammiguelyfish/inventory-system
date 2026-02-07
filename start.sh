#!/bin/bash

# Startup script for Laundry Inventory System
# This script helps you get started with Docker

set -e

echo "🧺 Laundry Inventory System - Docker Setup"
echo "=========================================="
echo ""

# Check if Docker is installed
if ! command -v docker &> /dev/null; then
    echo "❌ Docker is not installed!"
    echo "Please install Docker Desktop from: https://www.docker.com/products/docker-desktop"
    exit 1
fi

# Check if Docker Compose is installed
if ! command -v docker-compose &> /dev/null; then
    echo "❌ Docker Compose is not installed!"
    echo "Please install Docker Compose"
    exit 1
fi

echo "✅ Docker is installed"
echo "✅ Docker Compose is installed"
echo ""

# Check if Docker daemon is running
if ! docker info &> /dev/null; then
    echo "❌ Docker daemon is not running!"
    echo "Please start Docker Desktop"
    exit 1
fi

echo "✅ Docker daemon is running"
echo ""

# Stop existing containers if any
echo "🛑 Stopping existing containers..."
docker-compose down 2>/dev/null || true
echo ""

# Build and start services
echo "🔨 Building Docker images..."
docker-compose build
echo ""

echo "🚀 Starting services..."
docker-compose up -d
echo ""

# Wait for services to be healthy
echo "⏳ Waiting for services to be ready..."
sleep 5

# Check if services are running
if docker-compose ps | grep -q "Up"; then
    echo ""
    echo "✅ Services are running!"
    echo ""
    echo "📊 Container Status:"
    docker-compose ps
    echo ""
    echo "🌐 Application is available at: http://localhost:8080"
    echo ""
    echo "📝 Useful commands:"
    echo "  docker-compose logs -f       - View logs"
    echo "  docker-compose down          - Stop services"
    echo "  docker-compose restart       - Restart services"
    echo "  make help                    - View all available commands"
    echo ""
else
    echo "❌ Failed to start services"
    echo "Check logs with: docker-compose logs"
    exit 1
fi
