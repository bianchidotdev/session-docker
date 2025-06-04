#!/bin/bash
set -e

echo "Starting Session Node..."

echo "$@"
oxend \
    --non-interactive \
    "$@"

# The above command will keep running until oxend exits
# If we get here, oxend has stopped
echo "oxend has stopped. Exiting container..."
exit 1
