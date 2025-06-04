#!/bin/bash
set -e

echo "Session Node initialized with configuration:"
cat /etc/oxen/oxen.conf

# Execute the command passed to the script
exec "$@"
