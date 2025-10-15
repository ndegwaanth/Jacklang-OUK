#!/bin/bash

# Create main project folder
mkdir -p jac-poem-app

cd jac-poem-app || exit

# Create backend folder and files
mkdir -p backend
touch backend/poem_app.jac
touch backend/requirements.txt

# Create frontend folder and files
mkdir -p frontend
touch frontend/index.html
touch frontend/styles.css
touch frontend/app.js

# Create README
touch README.md

echo "jac-poem-app project structure created successfully!"

