#!/bin/bash

# File to capture output
log_file="disk-benchmark-background-log.txt"

# Run dd command in the background
dd if=/dev/zero of=/dev/null bs=1M count=0 > disk-benchmark-background-log.txt 2>&1 &

# Sleep for at least 10 seconds
sleep 10

# Disown the background process to allow it to continue even if the session is terminated
disown

echo "Disk benchmark is running in the background. Check '$log_file' for progress and results."
