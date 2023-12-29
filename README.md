
# Docker Management Script

This script provides a set of functions for managing Docker containers. It allows users to interact with Docker containers by offering functionalities to start, stop, and restart containers.

## Prerequisites

- Docker installed on your system.
- Basic knowledge of shell scripting and Docker commands.

## Installation

To use the script, clone or download it to your local machine and ensure it has execute permissions.

```bash
chmod +x docker.sh
```

## Usage

The script includes the following functions:

- `choose_docker_container`: Lists all available Docker containers and allows the user to select one. The selected container's ID is stored for further actions.

- `docker_start`: Starts the selected Docker container. It first invokes `choose_docker_container` to select a container.

- `docker_stop`: Stops the selected Docker container. It first invokes `choose_docker_container` to select a container.

- `docker_restart`: Restarts the selected Docker container. It first invokes `choose_docker_container` to select a container.

To run any of these functions, execute the script followed by the function name:

```bash
./docker.sh docker_start
```

## Note

- Ensure you have the necessary permissions to execute Docker commands.
- The script assumes Docker is installed and configured on your system.

## License

This script is released under the MIT License.
