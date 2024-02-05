#!/bin/bash

# Function to run the benchmark
run_benchmark() {
    # Set the benchmark duration in seconds
    benchmark_duration=10

    # Start the benchmark and redirect both stdout and stderr to the log file
    dd if=/dev/zero of=/dev/null bs=1M count=0 > disk-benchmark-background-log.txt 2>&1 &

    # Start the timer
    start_time=$(date +%s)

    # Sleep for the benchmark duration
    sleep $benchmark_duration

    # Get the end time
    end_time=$(date +%s)
    echo "start time : $start_time || end time : $end_time"

    # Calculate and print the duration
    duration=$((end_time - start_time)) 
    echo "Benchmark completed in $duration seconds"
}

# Run the benchmark function in the background
run_benchmark &

# Save the benchmark process ID
benchmark_pid=$!

# Disown the benchmark process
disown $benchmark_pid

# Exit the script
exit