#!/bin/bash

TARGET="$TARGET_HOST"
timeout=5

echo "Waiting 15 seconds before starting..."
sleep 15

echo "Attempting to resolve $TARGET..."

failure_start=""
attempt=1

while true; do
    timestamp=$(python3 -c 'from datetime import datetime; print(datetime.now().strftime("%Y-%m-%d %H:%M:%S.%f")[:-3])')
    echo "[$attempt] [$timestamp] Pinging $TARGET..."

    output=$(ping -c 1 -W 1 "$TARGET" 2>&1)
    status=$?

    if [ $status -eq 0 ]; then
        echo "[$attempt] [$timestamp] $TARGET is reachable!"
        failure_start=""
    else
        now=$(date +%s)
        echo "[$attempt] [$timestamp] Could not reach other container ($TARGET), retrying..."
        echo "[$attempt] [$timestamp] Ping output: $output"

        echo "--- dig output for $TARGET ---"
        dig "$TARGET"
        echo "-----------------------------"

        if [ -z "$failure_start" ]; then
            failure_start=$now
        else
            elapsed=$(( now - failure_start ))
            if [ "$elapsed" -ge "$timeout" ]; then
                echo "[$attempt] [$timestamp] Could not reach other container ($TARGET) for $timeout seconds"
                exit 1
            fi
        fi
    fi

    attempt=$((attempt + 1))
    sleep 1
done
