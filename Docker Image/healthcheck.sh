#!/bin/bash

for dir in /home/docker/actions-runner /home/runner/actions-runner; do
    if [ -d "$dir" ]; then
        RUNNER_DIR="$dir"
        break
    fi
done

if [ -z "$RUNNER_DIR" ]; then
    echo "Runner directory not found"
    exit 1
fi

if ! pgrep -f "runner.*run.sh" > /dev/null; then
    echo "Runner process not running"
    exit 1
fi

if [ -f "$RUNNER_DIR/.runner" ]; then
    RUNNER_NAME=$(grep -o '"name":"[^"]*"' "$RUNNER_DIR/.runner" | cut -d'"' -f4)
    if [ -n "$RUNNER_NAME" ]; then
        echo "Runner '$RUNNER_NAME' is healthy"
        exit 0
    fi
fi

echo "Runner is running but not fully registered"
exit 1