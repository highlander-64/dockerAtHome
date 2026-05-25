#!/bin/bash

# Base directory containing all application subdirectories with compose files
DOCKER_DIR="$(dirname "$0")/docker"

# Name of the Traefik subdirectory — it is always started first and stopped last
TRAEFIK_DIR="traefik"

# Print usage instructions and exit with error
usage() {
    echo "Usage: $0 [start|stop]"
    exit 1
}

# Search a given directory for a valid Docker Compose file and print its path
find_compose_file() {
    local dir="$1"
    # Check all common compose file naming conventions
    for file in docker-compose.yml docker-compose.yaml compose.yml compose.yaml; do
        if [ -f "$dir/$file" ]; then
            echo "$dir/$file"
            return 0
        fi
    done
    return 1
}

start_containers() {
    # --- Start Traefik first so the reverse proxy is ready before other services come up ---
    local traefik_path="$DOCKER_DIR/$TRAEFIK_DIR"

    # Check whether the Traefik directory exists
    if [ -d "$traefik_path" ]; then
        local compose_file
        # Locate the compose file inside the Traefik directory
        compose_file=$(find_compose_file "$traefik_path")
        if [ -n "$compose_file" ]; then
            echo "[INFO] Starting Traefik ..."
            # Start Traefik containers in detached mode
            docker compose -f "$compose_file" up -d
        else
            echo "[WARN] No compose file found in $traefik_path, skipping."
        fi
    else
        echo "[WARN] Traefik directory not found: $traefik_path"
    fi

    # --- Start all remaining application containers ---
    # Iterate over every subdirectory inside the docker folder
    for dir in "$DOCKER_DIR"/*/; do
        local name
        # Extract the folder name to use as the service identifier
        name=$(basename "$dir")

        # Skip the Traefik directory — it was already handled above
        [ "$name" = "$TRAEFIK_DIR" ] && continue

        local compose_file
        # Locate the compose file inside this application directory
        compose_file=$(find_compose_file "$dir")
        if [ -n "$compose_file" ]; then
            echo "[INFO] Starting $name ..."
            # Start the application containers in detached mode
            docker compose -f "$compose_file" up -d
        else
            echo "[WARN] No compose file found in $dir, skipping."
        fi
    done

    echo "[INFO] All containers started."
}

stop_containers() {
    # --- Stop all application containers first, before taking down the reverse proxy ---
    # Iterate over every subdirectory inside the docker folder
    for dir in "$DOCKER_DIR"/*/; do
        local name
        # Extract the folder name to use as the service identifier
        name=$(basename "$dir")

        # Skip Traefik — it must remain running until all other services are stopped
        [ "$name" = "$TRAEFIK_DIR" ] && continue

        local compose_file
        # Locate the compose file inside this application directory
        compose_file=$(find_compose_file "$dir")
        if [ -n "$compose_file" ]; then
            echo "[INFO] Stopping $name ..."
            # Stop and remove the application containers
            docker compose -f "$compose_file" down
        fi
    done

    # --- Stop Traefik last ---
    local traefik_path="$DOCKER_DIR/$TRAEFIK_DIR"

    # Check whether the Traefik directory exists
    if [ -d "$traefik_path" ]; then
        local compose_file
        # Locate the compose file inside the Traefik directory
        compose_file=$(find_compose_file "$traefik_path")
        if [ -n "$compose_file" ]; then
            echo "[INFO] Stopping Traefik ..."
            # Stop and remove the Traefik container
            docker compose -f "$compose_file" down
        fi
    fi

    echo "[INFO] All containers stopped."
}

# Require exactly one argument, otherwise show usage
[ $# -ne 1 ] && usage

# Dispatch to the appropriate function based on the argument
case "$1" in
    start) start_containers ;;
    stop)  stop_containers  ;;
    *)     usage            ;;
esac