#!/bin/bash

function choose_docker_container() {
    containers=$(sudo docker ps -a --format "{{.ID}}\t{{.Names}}")

    if [[ -z $containers ]]; then
        echo "No Docker containers found."
        return
    fi

    echo "Available Docker containers:"
    echo "$containers"

    read -p "Enter the number of the container you want to choose: " choice

    selected_container=$(echo "$containers" | awk -v choice="$choice" 'NR==choice {print $1}')

    if [[ -z $selected_container ]]; then
        echo "Invalid choice. Please try again."
        return
    fi

    echo "Selected container: $selected_container"
}

function docker_start() {
    choose_docker_container

    if [[ -z $selected_container ]]; then
        return
    fi

    sudo docker start "$selected_container"
}

function docker_stop() {
    choose_docker_container

    if [[ -z $selected_container ]]; then
        return
    fi

    sudo docker stop "$selected_container"
}

function docker_restart() {
    choose_docker_container

    if [[ -z $selected_container ]]; then
        return
    fi

    sudo docker restart "$selected_container"
}

function docker_shell() {
    choose_docker_container

    if [[ -z $selected_container ]]; then
        return
    fi

    sudo docker exec -it "$selected_container" /bin/bash
}

function docker_remove() {
    choose_docker_container

    if [[ -z $selected_container ]]; then
        return
    fi

    sudo docker rm "$selected_container"
}

function docker_remove_all() {
    containers=$(sudo docker ps -a --format "{{.ID}}\t{{.Names}}")

    if [[ -z $containers ]]; then
        echo "No Docker containers found."
        return
    fi

    echo "Available Docker containers:"
    awk '{print NR".", $0}' <<< "$containers"

    read -p "Are you sure you want to remove all containers? [y/N] " choice

    if [[ $choice != "y" ]]; then
        echo "Aborting."
        return
    fi

    sudo docker rm $(echo "$containers" | awk '{print $1}')
}


function docker_image_remove() {
    images=$(sudo docker images --format "{{.ID}}\t{{.Repository}}\t{{.Tag}}")

    if [[ -z $images ]]; then
        echo "No Docker images found."
        return
    fi

    echo "Available Docker images:"
    awk '{print NR".", $0}' <<< "$images"

    read -p "Enter the number of the image you want to remove: " choice

    selected_image=$(echo "$images" | awk -v choice="$choice" 'NR==choice {print $1}')

    if [[ -z $selected_image ]]; then
        echo "Invalid choice. Please try again."
        return
    fi

    echo "Selected image: $selected_image"

    sudo docker rmi "$selected_image"
}

function docker_image_remove_all() {
    images=$(sudo docker images --format "{{.ID}}\t{{.Repository}}\t{{.Tag}}")

    if [[ -z $images ]]; then
        echo "No Docker images found."
        return
    fi

    echo "Available Docker images:"
    echo "$images"

    read -p "Are you sure you want to remove all images? [y/N] " choice

    if [[ $choice != "y" ]]; then
        echo "Aborting."
        return
    fi

    sudo docker rmi $(echo "$images" | awk '{print $1}')
}

function docker_image_remove_dangling() {
    images=$(sudo docker images --format "{{.ID}}\t{{.Repository}}\t{{.Tag}}")

    if [[ -z $images ]]; then
        echo "No Docker images found."
        return
    fi

    echo "Available Docker images:"
    echo "$images"

    read -p "Are you sure you want to remove all dangling images? [y/N] " choice

    if [[ $choice != "y" ]]; then
        echo "Aborting."
        return
    fi

    sudo docker rmi $(sudo docker images -f "dangling=true" -q)
}

function docker_image_remove_all_except_latest() {
    images=$(sudo docker images --format "{{.ID}}\t{{.Repository}}\t{{.Tag}}")

    if [[ -z $images ]]; then
        echo "No Docker images found."
        return
    fi

    echo "Available Docker images:"
    echo "$images"

    read -p "Are you sure you want to remove all images except the latest? [y/N] " choice

    if [[ $choice != "y" ]]; then
        echo "Aborting."
        return
    fi

    sudo docker rmi $(echo "$images" | awk '$3 != "latest" {print $1}')
}

function main_menu() {
    clear
    echo "Select an option:"
    echo "1. Manage Docker Images"
    echo "2. Manage Docker Containers"
    echo "3. Execute Docker Command"
    echo "4. Exit"

    read -p "Enter your choice: " choice

    case $choice in
        1)
            docker_image_menu
            ;;
        2)
            docker_container_menu
            ;;
        3)
            execute_docker_command
            ;;
        4)
            echo "Exiting..."
            return
            ;;
        *)
            echo "Invalid choice. Please try again."
            main_menu
            ;;
    esac
}

function docker_image_menu() {
    clear
    echo "Docker Image Menu:"
    echo "1. Remove a Docker Image"
    echo "2. Remove all Docker Images"
    echo "3. Remove all dangling Docker Images"
    echo "4. Remove all Docker Images except the latest"
    echo "5. View Docker Image Info"
    echo "6. Back to Main Menu"

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
            view_docker_image_info
            ;;
        6)
            main_menu
            ;;
        *)
            echo "Invalid choice. Please try again."
            docker_image_menu
            ;;
    esac
}

function docker_container_menu() {
    clear
    echo "Docker Container Menu:"
    echo "1. Remove a Docker Container"
    echo "2. View Docker Container Info"
    echo "3. Back to Main Menu"

    read -p "Enter your choice: " choice

    case $choice in
        1)
            docker_container_remove
            ;;
        2)
            view_docker_container_info
            ;;
        3)
            main_menu
            ;;
        *)
            echo "Invalid choice. Please try again."
            docker_container_menu
            ;;
    esac
}

function docker_container_remove() {
    containers=$(sudo docker ps -a --format "{{.ID}}\t{{.Names}}")

    if [[ -z $containers ]]; then
        echo "No Docker containers found."
        return
    fi

    echo "Available Docker containers:"
    echo "$containers"

    read -p "Enter the number of the container you want to remove: " choice

    selected_container=$(echo "$containers" | awk -v choice="$choice" 'NR==choice {print $1}')

    if [[ -z $selected_container ]]; then
        echo "Invalid choice. Please try again."
        return
    fi

    echo "Selected container: $selected_container"

    sudo docker rm "$selected_container"
}

function view_docker_container_info() {
    containers=$(sudo docker ps -a --format "{{.ID}}\t{{.Names}}\t{{.Image}}\t{{.Status}}")

    if [[ -z $containers ]]; then
        echo "No Docker containers found."
        return
    fi

    echo "Available Docker containers:"
    echo "$containers"
}

function view_docker_image_info() {
    images=$(sudo docker images --format "{{.ID}}\t{{.Repository}}\t{{.Tag}}\t{{.Size}}")

    if [[ -z $images ]]; then
        echo "No Docker images found."
        return
    fi

    echo "Available Docker images:"
    echo "$images"
}

function execute_docker_command() {
    read -p "Enter the Docker command to execute: " command

    if [[ -z $command ]]; then
        echo "Invalid command. Please try again."
        return
    fi

    sudo docker $command
}

# Rest of the code...

main_menu
