#!/bin/bash

# Define the install directory
INSTALL_DIR="/usr/local/bin"

# Script name
SCRIPT_NAME="docker-manager"

# Check if the script exists
if [ -f "$INSTALL_DIR/$SCRIPT_NAME" ]; then
    echo "Removing the Docker management script..."
    sudo rm -f $INSTALL_DIR/$SCRIPT_NAME
    echo "The script has been successfully removed."
else
    echo "The script is not installed."
fi