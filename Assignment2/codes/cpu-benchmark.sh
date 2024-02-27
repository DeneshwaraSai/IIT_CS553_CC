#!bin/bash 

# The "baremetal-CPU-benchmark-results.csv" file is used to store thread number, average latency, and events per second features.
outputFile="baremetal-cpu-benchmark-results.csv";
cpuLogFile="baremetal-cpu-benchmark-logFile.txt";

# touch is used to create a new file if not exist.
# > "$file name" is used to empty the file.

touch "$outputFile";
> "$outputFile";

touch "$cpuLogFile";
> "$cpuLogFile";

# The below line is used to construct headers or column name for the "baremetal-CPU-benchmark-results.csv" file.
echo "Threads, AvgLatency, Events" >> $outputFile;

# 1 2 4 8 16 32 64 - represents the count of threads that are placed a list and iteration begins here
for thread in 1 2 4 8 16 32 64;do
    echo "------- Started $thread ---------";

    # The below command is used to capture the sysbench fileio information by looping it with given thread count.
    # The command output is stored in logFile.
    threadInfo=$(sysbench cpu --cpu-max-prime=100000 --threads=$thread run) >> $cpuLogFile;
    echo "$threadInfo";
    echo $threadInfo >> $cpuLogFile;

    # grep is used search for a given regex.
    # -A retrieves the number of lines after searching.
    # awk and $number is used to get specified value.
    latencyInfo=$(echo "$threadInfo" | grep -A 5 "Latency (ms):");
    avgLatency=$(echo "Avg : $latencyInfo" | grep -A 2 "avg:" | awk '/avg:/ {print $2}');
    cpuSpeed=$(echo "$threadInfo" | grep -A 1 "CPU speed:")
    events=$(echo "$cpuSpeed" | grep -A 1 "events per second:" | awk '/events per second:/ {print $4}');

    echo "Events per seconds : $events";
    echo "Latency Avg (ms): $avgLatency"

    # Storing average latency and events for every thread in output file.
    echo "Thread_$thread, $avgLatency, $events" >> $outputFile;
    echo "------- Ended $thread ---------\n";
done
