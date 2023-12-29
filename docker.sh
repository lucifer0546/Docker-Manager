#!/bin/bash

# ==============================
# SECTION: Main Menu
# ==============================

function main_menu() {
    clear
    print_banner
    docker_stats                                                     
    echo -e "\nSelect an option:"
    echo "1. Manage Docker Containers"
    echo "2. Manage Docker Images"
    echo -e "3. Exit\n"

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

# ======================================
# SECTION: Container Menu and Functions
# ======================================


function docker_container_menu() {
    clear
    print_banner
    echo "Docker Container Menu:"
    echo "1. Start a Docker Container"
    echo "2. Stop a Docker Container"
    echo "3. Restart a Docker Container"
    echo "4. Open a Shell in a Docker Container"
    echo "5. Remove a Docker Container"
    echo "6. Remove all Docker Containers"
    echo -e "0. Back to Main Menu\n"

    read -p "Enter your choice: " choice

    case $choice in
        1)
            docker_start && main_menu
            ;;
        2)
            docker_stop && main_menu
            ;;
        3)
            docker_restart && main_menu
            ;;
        4)
            docker_shell && main_menu
            ;;
        5)
            docker_container_remove && main_menu
            ;;
        6)
            docker_remove_all && main_menu
            ;;
        0)
            main_menu
            ;;
        *)
            echo "Invalid choice. Please try again."
            docker_container_menu
            ;;
    esac
}

function docker_start() {
    clear
    print_banner
    echo "Start a Docker Container:"
    # Print all Docker containers with a number for ID
    docker ps -a --format "table {{.ID}}\t{{.Names}}\t{{.Status}}\t{{.Image}}" | awk '{if ($3 == "Up") print "\033[0;32m" NR-1,$0 "\033[0m"; else print NR-1,$0}'
    echo -e "\n\033[0;32m*Already running\033[0m\n"
    # Prompt user to enter the number of the Docker container to start
    read -p "Enter the number of the Docker container to start: " container_number

    # Start the Docker container based on the selected number
    docker start $(docker ps -a --format "{{.ID}}" | sed -n "${container_number}p")

    echo "Starting a Docker container..."
}

function docker_stop() {
    clear
    print_banner
    # Print all Docker containers with a number for ID
    docker ps -a --format "table {{.ID}}\t{{.Names}}\t{{.Status}}\t{{.Image}}" | awk '{if ($3 == "Up") print "\033[0;32m" NR-1,$0 "\033[0m"; else print NR-1,$0}'
    echo -e "\n\033[0;32m*Running\033[0m\n"

    # Prompt user to enter the number of the Docker container to stop
    read -p "Enter the number of the Docker container to stop: " container_number

    # Stop the Docker container based on the selected number
    docker stop $(docker ps -a --format "{{.ID}}" | sed -n "${container_number}p")

    echo "Stopping a Docker container..."
}

function docker_restart() {
    clear
    print_banner
    # Print all Docker containers with a number for ID
    docker ps -a --format "table {{.ID}}\t{{.Names}}\t{{.Status}}\t{{.Image}}" | awk '{if ($3 == "Up") print "\033[0;32m" NR-1,$0 "\033[0m"; else print NR-1,$0}'
    echo -e "\n\033[0;32m*Running\033[0m\n"

    # Prompt user to enter the number of the Docker container to restart
    read -p "Enter the number of the Docker container to restart: " container_number

    # Restart the Docker container based on the selected number
    docker restart $(docker ps -a --format "{{.ID}}" | sed -n "${container_number}p")

    echo "Restarting a Docker container..."
}

function docker_shell() {
    clear
    print_banner
    # Print all Docker containers with a number for ID
    docker ps -a --format "table {{.ID}}\t{{.Names}}\t{{.Status}}\t{{.Image}}" | awk '{if ($3 == "Up") print "\033[0;32m" NR-1,$0 "\033[0m"; else print NR-1,$0}'
    echo -e "\n\033[0;32m*Running\033[0m\n"

    # Prompt user to enter the number of the Docker container to open a shell
    read -p "Enter the number of the Docker container to open a shell: " container_number

    # Open a shell in the Docker container based on the selected number
    docker exec -it $(docker ps -a --format "{{.ID}}" | sed -n "${container_number}p") /bin/bash

    echo "Opening a shell in a Docker container..."
}

function docker_container_remove() {
    clear
    print_banner
    # Print all Docker containers with a number for ID
    docker ps -a --format "table {{.ID}}\t{{.Names}}\t{{.Status}}\t{{.Image}}" | awk '{if ($3 == "Up") print "\033[0;31m" NR-1,$0 "\033[0m"; else print NR-1,$0}'
    echo -e "\n\033[0;31m*Running can not be removed.\033[0m\n"

    # Prompt user to enter the number of the Docker container to remove
    read -p "Enter the number of the Docker container to remove: " container_number

    # Remove the Docker container based on the selected number
    docker rm $(docker ps -a --format "{{.ID}}" | sed -n "${container_number}p")

    echo "Removing a Docker container..."
}

function docker_remove_all() {
    clear
    print_banner
    docker ps -a --format "table {{.ID}}\t{{.Names}}\t{{.Status}}\t{{.Image}}" | awk '{if ($3 == "Up") print "\033[0;32m" NR-1,$0 "\033[0m"; else print NR-1,$0}'
    echo -e "\n\033[0;32m*Already running\033[0m\n"
    read -p "Are you sure you want to remove all Docker containers? Type 'yes' to confirm: " confirm

    if [ "$confirm" == "yes" ]; then
        # Remove all Docker containers
        docker rm $(docker ps -a -q)

        echo "Removing all Docker containers..."
    else
        echo "Operation cancelled."
    fi
}

# ======================================
# SECTION: Image Menu and Functions
# ======================================


function docker_image_menu() {
    clear
    print_banner
    echo "Docker Image Menu:"
    echo "1. Remove a Docker Image"
    echo "2. Remove all Docker Images"
    echo "3. Remove all dangling Docker Images"
    echo "4. Remove all Docker Images except the latest"
    echo -e "\n0. Back to Main Menu"

    read -p "Enter your choice: " choice

    case $choice in
        1)
            docker_image_remove && main_menu
            ;;
        2)
            docker_image_remove_all && main_menu
            ;;
        3)
            docker_image_remove_dangling && main_menu
            ;;
        4)
            docker_image_remove_all_except_latest && main_menu
            ;;
        0)
            main_menu
            ;;
        *)
            echo "Invalid choice. Please try again."
            docker_image_menu
            ;;
    esac
}

# ======================================
# SECTION: Image functions
# ======================================

function docker_image_remove() {
    clear
    echo "Remove a Docker Image:"
    # Print all Docker images with a number for ID
    docker images --format "table {{.ID}}\t{{.Repository}}\t{{.Tag}}\t{{.Size}}" | awk '{print NR-1,$0}'
    echo -e "\n"

    # Prompt user to enter the number of the Docker image to remove
    read -p "Enter the number of the Docker image to remove: " image_number

    # Remove the Docker image based on the selected number
    docker rmi $(docker images --format "{{.ID}}" | sed -n "${image_number}p")

    echo "Removing a Docker image..."
}

function docker_image_remove_all() {
    clear
    echo "Remove all Docker Images:"
    # Prompt user to confirm the removal of all Docker images
    read -p "Are you sure you want to remove all Docker images? Type 'yes' to confirm: " confirm

    if [ "$confirm" == "yes" ]; then
        # Remove all Docker images
        docker rmi $(docker images -q)

        echo "Removing all Docker images..."
    else
        echo "Operation cancelled."
    fi
}

function docker_image_remove_dangling() {
    clear
    echo "Remove all dangling Docker Images:"
    # Prompt user to confirm the removal of all dangling Docker images
    read -p "Are you sure you want to remove all dangling Docker images? Type 'yes' to confirm: " confirm

    if [ "$confirm" == "yes" ]; then
        # Remove all dangling Docker images
        docker image prune -f

        echo "Removing all dangling Docker images..."
    else
        echo "Operation cancelled."
    fi
}

function docker_image_remove_all_except_latest() {
    clear
    echo "Remove all Docker Images except the latest:"
    # Prompt user to confirm the removal of all Docker images except the latest
    read -p "Are you sure you want to remove all Docker images except the latest? Type 'yes' to confirm: " confirm

    if [ "$confirm" == "yes" ]; then
        # Remove all Docker images except the latest
        docker image prune -a --filter "until=1h" -f

        echo "Removing all Docker images except the latest..."
    else
        echo "Operation cancelled."
    fi
}

# ======================================
# SECTION: Functions
# ======================================

function docker_stats() {
    # Store Docker container stats with green memory usage in a variable
    stats=$(docker stats --no-stream --format "table {{.Name}}\t{{.Container}}\t{{.CPUPerc}}\t\033[32m{{.MemUsage}}\033[0m\t\033[32m{{.MemPerc}}\033[0m\t{{.NetIO}}\t{{.BlockIO}}\t{{.PIDs}}")

    # Print the variable using echo -e
    echo -e "$stats"
}

function print_banner() {
        echo -e "
        ██████╗  ██████╗  ██████╗██╗  ██╗███████╗██████╗          
        ██╔══██╗██╔═══██╗██╔════╝██║ ██╔╝██╔════╝██╔══██╗         
        ██║  ██║██║   ██║██║     █████╔╝ █████╗  ██████╔╝         
        ██║  ██║██║   ██║██║     ██╔═██╗ ██╔══╝  ██╔══██╗         
        ██████╔╝╚██████╔╝╚██████╗██║  ██╗███████╗██║  ██║         
        ╚═════╝  ╚═════╝  ╚═════╝╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝         
                                                                  
    ███╗   ███╗ █████╗ ███╗   ██╗ █████╗  ██████╗ ███████╗██████╗ 
    ████╗ ████║██╔══██╗████╗  ██║██╔══██╗██╔════╝ ██╔════╝██╔══██╗
    ██╔████╔██║███████║██╔██╗ ██║███████║██║  ███╗█████╗  ██████╔╝
    ██║╚██╔╝██║██╔══██║██║╚██╗██║██╔══██║██║   ██║██╔══╝  ██╔══██╗
    ██║ ╚═╝ ██║██║  ██║██║ ╚████║██║  ██║╚██████╔╝███████╗██║  ██║
    ╚═╝     ╚═╝╚═╝  ╚═╝╚═╝  ╚═══╝╚═╝  ╚═╝ ╚═════╝ ╚══════╝╚═╝  ╚═╝
    "
}


# ======================================
# SECTION: Initial Checks
# ======================================


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
    else
                # Check if user has sudo permission
        if [ "$(id -u)" != "0" ]; then
                echo "You don't have sudo permission. Please run the script as root or with sudo."
                exit 1
        fi
        return 0
    fi
}

# ======================================
# SECTION: Main Script
# ======================================

if check_docker_status; then
    main_menu
fi


