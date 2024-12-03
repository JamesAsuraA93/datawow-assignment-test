#!/bin/bash
# Pull updates from frontend
cd next-frontend-datawow
git pull origin main
cd ..

# Pull updates from backend
cd nest-backend-datawow
git pull origin main
cd ..

# Commit changes to main-app repo
git add .
git commit -m "Update submodules to latest versions"
git push origin main
