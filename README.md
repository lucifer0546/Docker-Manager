
<div align="center">
  <img src="images/docker_whale.png" alt="Docker Whale Manager">
</div>


# Docker Management Script

This script provides a set of functions for managing Docker containers. It allows users to interact with Docker containers by offering functionalities to start, stop, and restart containers.

## Prerequisites

- Docker installed on your system.
- Basic knowledge of shell scripting and Docker commands.

## Installation

To install the Docker management script, follow these steps:

1. **Clone the Repository**
   ```bash
   git clone https://github.com/lucifer0546/DockerGui.git
   cd DockerGui
   ```

2. **Run the Install Script**
   Make sure the `install.sh` script is executable:
   ```bash
   chmod +x install.sh
   ./install.sh
   ```

## Usage
After installation, you can run the script using the command `docker-manager`.

The script includes the following functions:

- `choose_docker_container`: Lists all available Docker containers and allows the user to select one. The selected container's ID is stored for further actions.

- `docker_start`: Starts the selected Docker container. It first invokes `choose_docker_container` to select a container.

- `docker_stop`: Stops the selected Docker container. It first invokes `choose_docker_container` to select a container.

- `docker_restart`: Restarts the selected Docker container. It first invokes `choose_docker_container` to select a container.

## Uninstallation

To uninstall the script, follow these steps:

1. **Navigate to the Repository Directory**
   If you're not already in the directory:
   ```bash
   cd DockerGui
   ```

2. **Run the Uninstall Script**
   Make sure the `uninstall.sh` script is executable:
   ```bash
   chmod +x uninstall.sh
   ./uninstall.sh
   ```

## Note

- Ensure you have the necessary permissions to execute Docker commands.
- The script assumes Docker is installed and configured on your system.

## Todo
- `Status Overview:` Add a function to display an overview of all containers, including their status (running, exited), ports, images, and creation dates.

- `Health Check Functionality:` Integrate a health check feature that reports on the health of running containers based on their health status in Docker.

- `Search Functionality:` Implement a search feature that allows users to find containers based on names, IDs, or other criteria.

- `Update Notification:` A function to check for the latest Docker images for the containers and suggest or automate updates.

- `Backup and Restore: `Provide options to easily backup and restore container data, which is crucial for data integrity and recovery.

- `Resource Monitoring:` Add features to monitor and report on the resource usage (CPU, memory) of each container, which is essential for performance tuning.

- `Custom Configuration Management:` Allow users to save and manage custom configurations for containers, making it easier to deploy containers with preferred settings.

- `Network Management:` Include options to manage Docker networks, such as creating, inspecting, and removing networks.

- `Security Scans:` Integrate with tools to perform security scans on containers and images to ensure they are free of known vulnerabilities.

- `User Access Control:` Implement user access control to allow different levels of permissions for different users of the script, enhancing security.

- `Logging and Audit Trails:` Maintain logs of actions performed through the script for auditing and troubleshooting purposes. 

## License

This script is released under the MIT License.
