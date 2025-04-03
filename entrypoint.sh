#!/bin/bash

TARGET="$TARGET_HOST"
timeout=5

echo "Waiting 15 seconds before starting..."
sleep 15

echo "Attempting to resolve $TARGET..."

failure_start=""

while true; do
    if getent hosts "$TARGET" > /dev/null 2>&1; then
        echo "$TARGET is reachable!"
        failure_start=""
    else
        now=$(date +%s)
        echo "Could not resolve other container ($TARGET), retrying..."

        if [ -z "$failure_start" ]; then
            failure_start=$now
        else
            elapsed=$(( now - failure_start ))
            if [ "$elapsed" -ge "$timeout" ]; then
                echo "Could not resolve other container ($TARGET) for $timeout seconds"
                exit 1
            fi
        fi
    fi

    sleep 1
done
