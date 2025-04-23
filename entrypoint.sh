#!/bin/bash

TARGET="$TARGET_HOST"
timeout=5

echo "Waiting 15 seconds before starting..."
sleep 15

echo "Attempting to resolve $TARGET..."

failure_start=""

while true; do
    # Count and print number of lines in /etc/resolv.conf
    resolv_line_count=$(wc -l < /etc/resolv.conf)
    echo "/etc/resolv.conf has $resolv_line_count lines"
    echo "--- /etc/resolv.conf ---"
    cat /etc/resolv.conf
    echo "------------------------"

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
