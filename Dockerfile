FROM alpine:3.18

RUN apk add --no-cache bash bind-tools

RUN cat << 'EOF' > /entrypoint.sh
#!/bin/bash

TARGET="\$TARGET_HOST"
timeout=5

echo "Waiting 15 seconds before starting..."
sleep 15

start_time=\$(date +%s)
echo "Attempting to resolve \$TARGET..."

while true; do
    if getent hosts "\$TARGET" > /dev/null 2>&1; then
        echo "\$TARGET is reachable!"
        break
    fi

    now=\$(date +%s)
    elapsed=\$(( now - start_time ))

    if [ "\$elapsed" -ge "\$timeout" ]; then
        echo "Could not resolve other container (\$TARGET)"
        exit 1
    fi

    sleep 1
done

tail -f /dev/null
EOF

RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
