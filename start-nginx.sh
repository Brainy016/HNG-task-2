#!/bin/sh
# This script will exit immediately if any command fails
set -e

# Logic to set Primary and Backup based on ACTIVE_POOL
if [ "$ACTIVE_POOL" = "blue" ]; then
  export PRIMARY_HOST="app_blue:${PORT}"
  export BACKUP_HOST="app_green:${PORT}"
  echo ">>> Active pool is BLUE. Primary: $PRIMARY_HOST, Backup: $BACKUP_HOST"
elif [ "$ACTIVE_POOL" = "green" ]; then
  export PRIMARY_HOST="app_green:${PORT}"
  export BACKUP_HOST="app_blue:${PORT}"
  echo ">>> Active pool is GREEN. Primary: $PRIMARY_HOST, Backup: $BACKUP_HOST"
else
  echo "ERROR: ACTIVE_POOL must be set to 'blue' or 'green'."
  exit 1
fi


envsubst '${PRIMARY_HOST} ${BACKUP_HOST}' < /etc/nginx/templates/default.conf.template > /etc/nginx/conf.d/default.conf

echo ">>> Nginx config generated. Starting Nginx..."

# Start Nginx in the foreground (the standard way to run it in Docker)
nginx -g 'daemon off;'