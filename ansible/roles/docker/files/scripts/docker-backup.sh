#!/usr/bin/env bash
set -euo pipefail

# Source directory containing Docker data to back up.
SOURCE="/srv/docker/data"
# Destination directory where the rsync backup will be stored.
TARGET="/mnt/backup/docker"
# Resolve the script directory to find docker-control.sh reliably.
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOCKER_CONTROL_SCRIPT="$SCRIPT_DIR/docker-control.sh"

usage() {
  cat <<EOF
Usage: $0

Creates an rsync backup of $SOURCE into $TARGET.
Before the backup runs, it stops the containers via docker-control.sh
and starts them again afterward.
EOF
  exit 1
}

require_command() {
  # Ensure a required command is available on the system.
  command -v "$1" >/dev/null 2>&1 || {
    echo "[ERROR] Required command '$1' not found." >&2
    exit 2
  }
}

cleanup() {
  # If containers were stopped by this script, restart them on exit.
  if [[ "$CONTAINERS_STOPPED" == "yes" ]]; then
    echo "[INFO] Restarting containers after backup..."
    "$DOCKER_CONTROL_SCRIPT" start
  fi
}

# Always run cleanup when the script exits, even on error.
trap cleanup EXIT

# Fail if any arguments are provided; this script takes none.
[ $# -eq 0 ] || usage

# Verify rsync exists before proceeding.
require_command rsync

# Verify the docker-control helper script is executable.
if [[ ! -x "$DOCKER_CONTROL_SCRIPT" ]]; then
  echo "[ERROR] Cannot execute docker-control script: $DOCKER_CONTROL_SCRIPT" >&2
  exit 3
fi

CONTAINERS_STOPPED="no"

echo "[INFO] Stopping containers for backup..."
# Stop all Docker containers before taking the backup.
"$DOCKER_CONTROL_SCRIPT" stop
CONTAINERS_STOPPED="yes"

echo "[INFO] Ensuring backup destination exists: $TARGET"
# Create the target directory if it does not exist.
mkdir -p "$TARGET"

echo "[INFO] Starting rsync backup from $SOURCE to $TARGET"
# Perform the backup with archive mode, preserve metadata, and delete stale files.
rsync -aHAX --delete --stats --human-readable "$SOURCE"/ "$TARGET"/

echo "[INFO] Backup completed successfully."
