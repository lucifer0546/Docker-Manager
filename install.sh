#!/bin/bash

# Define the install directory
INSTALL_DIR="/usr/local/bin"

# Check for Docker, install if not found (depends on your OS and package manager)
if ! command -v docker >/dev/null 2>&1; then
    echo "Docker is not installed. Please install Docker before running this script."
    exit 1
fi

# Copy your script to the install directory
echo "Installing your Docker management script..."
sudo cp docker.sh $INSTALL_DIR/docker-manager
sudo chmod +x $INSTALL_DIR/docker-manager

echo "Installation complete. You can run the script with 'docker-manager'"
