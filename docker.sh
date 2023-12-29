#!/bin/bash

function main_menu() {
    clear
    echo "Select an option:"
    echo "1. Manage Docker Containers"
    echo "2. Manage Docker Images"
    echo "3. Execute Docker Command"
    echo "4. Exit"

    read -p "Enter your choice: " choice

    case $choice in
        1)
            docker_container_menu
            ;;
        2)
            docker_image_menu
            ;;
        3)
            echo "Exiting..."
            return
            ;;
        *)
            echo "Invalid choice. Please try again."
            main_menu
            ;;
    esac
}

function docker_container_menu() {
    clear
    echo "Docker Container Menu:"
    echo "1. Start a Docker Container"
    echo "2. Stop a Docker Container"
    echo "3. Restart a Docker Container"
    echo "4. Open a Shell in a Docker Container"
    echo "5. Remove a Docker Container"
    echo "6. Remove all Docker Containers"
    echo "7. Back to Main Menu"

    read -p "Enter your choice: " choice

    case $choice in
        1)
            docker_start
            ;;
        2)
            docker_stop
            ;;
        3)
            docker_restart
            ;;
        4)
            docker_shell
            ;;
        5)
            docker_container_remove
            ;;
        6)
            docker_remove_all
            ;;
        7)
            main_menu
            ;;
        *)
            echo "Invalid choice. Please try again."
            docker_container_menu
            ;;
    esac
}

function docker_start() {
    # Print all Docker containers with a number for ID
    docker ps -a --format "table {{.ID}}\t{{.Names}}"

    # Prompt user to enter the number of the Docker container to start
    read -p "Enter the number of the Docker container to start: " container_number

    # Start the Docker container based on the selected number
    docker start $(docker ps -a --format "{{.ID}}" | sed -n "${container_number}p")

    echo "Starting a Docker container..."
}

function docker_stop() {
    # Print all Docker containers with a number for ID
    docker ps -a --format "table {{.ID}}\t{{.Names}}"

    # Prompt user to enter the number of the Docker container to stop
    read -p "Enter the number of the Docker container to stop: " container_number

    # Stop the Docker container based on the selected number
    docker stop $(docker ps -a --format "{{.ID}}" | sed -n "${container_number}p")

    echo "Stopping a Docker container..."
}

function docker_restart() {
    # Print all Docker containers with a number for ID
    docker ps -a --format "table {{.ID}}\t{{.Names}}"

    # Prompt user to enter the number of the Docker container to restart
    read -p "Enter the number of the Docker container to restart: " container_number

    # Restart the Docker container based on the selected number
    docker restart $(docker ps -a --format "{{.ID}}" | sed -n "${container_number}p")

    echo "Restarting a Docker container..."
}

function docker_shell() {
    # Print all Docker containers with a number for ID
    docker ps -a --format "table {{.ID}}\t{{.Names}}"

    # Prompt user to enter the number of the Docker container to open a shell
    read -p "Enter the number of the Docker container to open a shell: " container_number

    # Open a shell in the Docker container based on the selected number
    docker exec -it $(docker ps -a --format "{{.ID}}" | sed -n "${container_number}p") /bin/bash

    echo "Opening a shell in a Docker container..."
}

function docker_container_remove() {
    # Print all Docker containers with a number for ID
    docker ps -a --format "table {{.ID}}\t{{.Names}}"

    # Prompt user to enter the number of the Docker container to remove
    read -p "Enter the number of the Docker container to remove: " container_number

    # Remove the Docker container based on the selected number
    docker rm $(docker ps -a --format "{{.ID}}" | sed -n "${container_number}p")

    echo "Removing a Docker container..."
}

function docker_remove_all() {
    read -p "Are you sure you want to remove all Docker containers? Type 'yes' to confirm: " confirm

    if [ "$confirm" == "yes" ]; then
        # Remove all Docker containers
        docker rm $(docker ps -a -q)

        echo "Removing all Docker containers..."
    else
        echo "Operation cancelled."
    fi
}

function docker_image_menu() {
    clear
    echo "Docker Image Menu:"
    echo "1. Remove a Docker Image"
    echo "2. Remove all Docker Images"
    echo "3. Remove all dangling Docker Images"
    echo "4. Remove all Docker Images except the latest"
    echo "5. Back to Main Menu"

    read -p "Enter your choice: " choice

    case $choice in
        1)
            docker_image_remove
            ;;
        2)
            docker_image_remove_all
            ;;
        3)
            docker_image_remove_dangling
            ;;
        4)
            docker_image_remove_all_except_latest
            ;;
        5)
            main_menu
            ;;
        *)
            echo "Invalid choice. Please try again."
            docker_image_menu
            ;;
    esac
}

function check_docker_status() {
    # Check if Docker is running
    if ! systemctl is-active --quiet docker; then
        read -p "Docker is not running. Would you like to start it? (yes/no): " start_docker

        if [ "$start_docker" == "yes" ]; then
            # Check if user has sudo permission
            if [ "$(id -u)" != "0" ]; then
                echo "You don't have sudo permission. Please run the script as root or with sudo."
                exit 1
            fi

            # Start Docker
            systemctl start docker
            echo "Docker has been started."
        else
            echo "Docker is not running. Exiting..."
            exit 1
        fi
    fi
}

check_docker_status
main_menu
