#!/bin/bash

# Create app folder and subfolders
mkdir -p app/jac
mkdir -p app/static
mkdir -p app/templates

# Create instance folder
mkdir -p instance

# Create migrations folder
mkdir -p migrations

# Create Jac and Python files
touch app/__init__.jac
touch app/forms.py
touch app/models.py
touch app/routes.jac
touch app/utils.py
touch app/jac/text_gen.jac

# Create static files
touch app/static/styles.css
touch app/static/script.js

# Create template files
touch app/templates/index.html
touch app/templates/history.html

# Create root files
touch config.py
touch mana.py
touch requirements.txt
touch .env

echo "Project structure created successfully!"

