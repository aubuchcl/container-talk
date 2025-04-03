#!/bin/bash

TARGET="$TARGET_HOST"

echo "Waiting 15 seconds before starting..."
sleep 15

echo "Attempting to resolve $TARGET..."

while true; do
    if getent hosts "$TARGET" > /dev/null 2>&1; then
        echo "$TARGET is reachable!"
        break
    else
        echo "Could not resolve other container ($TARGET), retrying..."
    fi
    sleep 1
done

# Placeholder for your app logic
tail -f /dev/null
