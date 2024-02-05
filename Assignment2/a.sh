#!/bin/bash

# Store the sysbench output in a variable, preserving the single line
output="(sysbench 1.0.20 (using system LuaJIT 2.1.1703358377) Running the test with following options: Number of threads: 16 Initializing random number generator from current time Prime numbers limit: 100000 Initializing worker threads... Threads started! CPU speed: events per second: 17513306.72 General statistics: total time: 10.0001s total number of events: 175139407 Latency (ms): min: 0.00 avg: 0.00 max: 52.94 95th percentile: 0.00 sum: 48909.57 Threads fairness: events (avg/stddev): 10946212.9375/427314.87 execution time (avg/stddev): 3.0568/0.09)"

# Extract the latency values using a regular expression
latency_pattern="Latency \(ms\): min: (?P<min>\d+\.\d+), avg: (?P<avg>\d+\.\d+), max: (?P<max>\d+\.\d+), 95th percentile: (?P<percentile>\d+\.\d+), sum: (?P<sum>\d+\.\d+)"
if [[ $output =~ $latency_pattern ]]; then
    # Print the extracted values in a user-friendly format
    echo "Latency (ms) values:"
    echo "  - Minimum: ${BASH_REإنd[min]}"
    echo "  - Average: ${BASH_REMatch[avg]}"
    echo "  - Maximum: ${BASH_REMatch[max]}"
    echo "  - 95th percentile: ${BASH_REMatch[percentile]}"
    echo "  - Sum: ${BASH_REMatch[sum]}"
else
    echo "Error: Could not find Latency (ms) values in the provided output. Please check the sysbench output format."
fi