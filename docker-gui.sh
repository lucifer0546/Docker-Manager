#!/bin/bash

# ==============================
# SECTION: Main Menu
# ==============================

function main_menu() {
    clear
    docker_stats
    dialog --backtitle "Docker GUI" --title "Main Menu" --menu "Select an option:" 12 60 5 \
        1 "Manage Docker Containers" \
        2 "Manage Docker Images" \
        3 "Exit" 2> /tmp/menu_choice.txt

    choice=$(cat /tmp/menu_choice.txt)

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
            dialog --backtitle "Docker GUI" --msgbox "Invalid choice. Please try again." 8 40
            main_menu
            ;;
    esac
}

# ======================================
# SECTION: Container Menu and Functions
# ======================================

function docker_container_menu() {
    clear
    dialog --backtitle "Docker GUI" --title "Docker Container Menu" --menu "Select an option:" 12 60 8 \
        1 "Start a Docker Container" \
        2 "Stop a Docker Container" \
        3 "Restart a Docker Container" \
        4 "Open a Shell in a Docker Container" \
        5 "Remove a Docker Container" \
        6 "Remove all Docker Containers" \
        7 "Back to Main Menu" 2> /tmp/menu_choice.txt

    choice=$(cat /tmp/menu_choice.txt)

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
            dialog --backtitle "Docker GUI" --msgbox "Invalid choice. Please try again." 8 40
            docker_container_menu
            ;;
    esac
}

function docker_start() {
    clear
    dialog --backtitle "Docker GUI" --title "Start a Docker Container" --msgbox "Select a Docker container to start:" 8 60
    docker ps -a --format "table {{.ID}}\t{{.Names}}\t{{.Status}}\t{{.Image}}" | awk '{if ($3 == "Up") print "\033[0;32m" NR-1,$0 "\033[0m"; else print NR-1,$0}' > /tmp/docker_containers.txt
    dialog --backtitle "Docker GUI" --title "Start a Docker Container" --menu "Select a Docker container to start:" 20 60 10 \
        $(cat /tmp/docker_containers.txt) 2> /tmp/container_number.txt

    container_number=$(cat /tmp/container_number.txt)

    docker start $(docker ps -a --format "{{.ID}}" | sed -n "${container_number}p")

    dialog --backtitle "Docker GUI" --msgbox "Starting a Docker container..." 8 40
}

function docker_stop() {
    docker ps -a --format "table {{.ID}}\t{{.Names}}" > /tmp/docker_containers.txt
    dialog --backtitle "Docker GUI" --title "Stop a Docker Container" --menu "Select a Docker container to stop:" 20 60 10 \
        $(cat /tmp/docker_containers.txt) 2> /tmp/container_number.txt

    container_number=$(cat /tmp/container_number.txt)

    docker stop $(docker ps -a --format "{{.ID}}" | sed -n "${container_number}p")

    dialog --backtitle "Docker GUI" --msgbox "Stopping a Docker container..." 8 40
}

function docker_restart() {
    docker ps -a --format "table {{.ID}}\t{{.Names}}" > /tmp/docker_containers.txt
    dialog --backtitle "Docker GUI" --title "Restart a Docker Container" --menu "Select a Docker container to restart:" 20 60 10 \
        $(cat /tmp/docker_containers.txt) 2> /tmp/container_number.txt

    container_number=$(cat /tmp/container_number.txt)

    docker restart $(docker ps -a --format "{{.ID}}" | sed -n "${container_number}p")

    dialog --backtitle "Docker GUI" --msgbox "Restarting a Docker container..." 8 40
}

function docker_shell() {
    docker ps -a --format "table {{.ID}}\t{{.Names}}" > /tmp/docker_containers.txt
    dialog --backtitle "Docker GUI" --title "Open a Shell in a Docker Container" --menu "Select a Docker container to open a shell:" 20 60 10 \
        $(cat /tmp/docker_containers.txt) 2> /tmp/container_number.txt

    container_number=$(cat /tmp/container_number.txt)

    docker exec -it $(docker ps -a --format "{{.ID}}" | sed -n "${container_number}p") /bin/bash

    dialog --backtitle "Docker GUI" --msgbox "Opening a shell in a Docker container..." 8 40
}

function docker_container_remove() {
    docker ps -a --format "table {{.ID}}\t{{.Names}}" > /tmp/docker_containers.txt
    dialog --backtitle "Docker GUI" --title "Remove a Docker Container" --menu "Select a Docker container to remove:" 20 60 10 \
        $(cat /tmp/docker_containers.txt) 2> /tmp/container_number.txt

    container_number=$(cat /tmp/container_number.txt)

    docker rm $(docker ps -a --format "{{.ID}}" | sed -n "${container_number}p")

    dialog --backtitle "Docker GUI" --msgbox "Removing a Docker container..." 8 40
}

function docker_remove_all() {
    dialog --backtitle "Docker GUI" --title "Remove all Docker Containers" --yesno "Are you sure you want to remove all Docker containers?" 8 60

    response=$?

    if [ $response -eq 0 ]; then
        docker rm $(docker ps -a -q)

        dialog --backtitle "Docker GUI" --msgbox "Removing all Docker containers..." 8 40
    else
        dialog --backtitle "Docker GUI" --msgbox "Operation cancelled." 8 40
    fi
}

# ======================================
# SECTION: Image Menu and Functions
# ======================================

function docker_image_menu() {
    clear
    dialog --backtitle "Docker GUI" --title "Docker Image Menu" --menu "Select an option:" 12 60 6 \
        1 "Remove a Docker Image" \
        2 "Remove all Docker Images" \
        3 "Remove all dangling Docker Images" \
        4 "Remove all Docker Images except the latest" \
        5 "Back to Main Menu" 2> /tmp/menu_choice.txt

    choice=$(cat /tmp/menu_choice.txt)

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
            dialog --backtitle "Docker GUI" --msgbox "Invalid choice. Please try again." 8 40
            docker_image_menu
            ;;
    esac
}

# ======================================
# SECTION: Functions
# ======================================

function docker_stats() {
    stats=$(docker stats --no-stream --format "table {{.Container}}\t{{.CPUPerc}}\t{{.Name}}\t\033[32m{{.MemUsage}}\033[0m\t\033[32m{{.MemPerc}}\033[0m\t{{.NetIO}}\t{{.BlockIO}}\t{{.PIDs}}")

    dialog --backtitle "Docker GUI" --title "Docker Stats" --msgbox "$stats" 20 80
}

# ======================================
# SECTION: Initial Checks
# ======================================

function check_docker_status() {
    if ! systemctl is-active --quiet docker; then
        dialog --backtitle "Docker GUI" --title "Docker Not Running" --yesno "Docker is not running. Would you like to start it?" 8 60

        response=$?

        if [ $response -eq 0 ]; then
            if [ "$(id -u)" != "0" ]; then
                dialog --backtitle "Docker GUI" --msgbox "You don't have sudo permission. Please run the script as root or with sudo." 8 60
                exit 1
            fi

            systemctl start docker
            dialog --backtitle "Docker GUI" --msgbox "Docker has been started." 8 40
        else
            dialog --backtitle "Docker GUI" --msgbox "Docker is not running. Exiting..." 8 40
            exit 1
        fi
    else
        if [ "$(id -u)" != "0" ]; then
            dialog --backtitle "Docker GUI" --msgbox "You don't have sudo permission. Please run the script as root or with sudo." 8 60
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
