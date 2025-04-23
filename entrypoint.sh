#!/bin/bash

TARGET="$TARGET_HOST"
timeout=5

echo "Waiting 15 seconds before starting..."
sleep 15

echo "Attempting to resolve $TARGET..."

failure_start=""

while true; do
    # Capture output and status code
    output=$(ping -c 1 -W 1 "$TARGET" 2>&1)
    status=$?

    if [ $status -eq 0 ]; then
        echo "$TARGET is reachable!"
        failure_start=""
    else
        now=$(date +%s)
        echo "Could not reach other container ($TARGET), retrying..."
        echo "Ping output: $output"

        echo "--- dig output for $TARGET ---"
        dig "$TARGET"
        echo "-----------------------------"

        if [ -z "$failure_start" ]; then
            failure_start=$now
        else
            elapsed=$(( now - failure_start ))
            if [ "$elapsed" -ge "$timeout" ]; then
                echo "Could not reach other container ($TARGET) for $timeout seconds"
                exit 1
            fi
        fi
    fi

    sleep 1
done
