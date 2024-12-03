#!/bin/bash

# Function to build, commit, and push changes for a given submodule
update_repo() {
  local repo_name=$1
  local install_command=$2
  local build_command=$3
  local branch_name=${4:-main} # Default branch is main

  echo "Updating repository: $repo_name"
  
  # Navigate to the repository directory
  cd "$repo_name" || { echo "Failed to enter $repo_name directory"; exit 1; }

  # Pull the latest changes from the remote branch
  echo "Pulling latest changes for $repo_name..."
  git pull origin "$branch_name"

  # Install dependencies
  echo "Installing dependencies for $repo_name..."
  if ! eval "$install_command"; then
    echo "Dependency installation failed for $repo_name. Exiting..."
    exit 1
  fi

  # Run the build command
  echo "Building $repo_name..."
  if ! eval "$build_command"; then
    echo "Build failed for $repo_name. Exiting..."
    exit 1
  fi

  # Add and commit any new changes
  echo "Checking for changes in $repo_name..."
  git add .
  if git diff-index --quiet HEAD --; then
    echo "No changes to commit in $repo_name."
  else
    git commit -m "Build and update changes for $repo_name"
    echo "Changes committed for $repo_name."
  fi

  # Push the changes to the remote repository
  echo "Pushing changes to $repo_name..."
  git push origin "$branch_name"

  # Navigate back to the main directory
  cd ..
}

# Update the frontend repository (using bun)
update_repo "next-frontend-datawow" "bun install" "bun run build"

# Update the backend repository (using yarn)
update_repo "nest-backend-datawow" "yarn install" "yarn build"

echo "All repositories updated successfully."
