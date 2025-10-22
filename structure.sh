#!/bin/bash
# structure.sh - Create project structure for jac-flask-app

# Root directory
mkdir -p jac-flask-app

# Navigate into root
cd jac-flask-app || exit

# Create main application file
touch app.py

# Create jac directory and files
mkdir -p jac
touch jac/models.jac jac/api_walkers.jac jac/ai_processing.jac

# Create static directories and files
mkdir -p static/css static/js
touch static/css/style.css static/js/app.js

# Create templates directory and file
mkdir -p templates
touch templates/index.html

echo "✅ jac-flask-app structure created successfully!"

