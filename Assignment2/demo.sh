#!bin/bash 

outputFile="cpu-results.txt"

touch "$outputFile";
> "$outputFile";

for thread in 1 2 4 8 16 32 64;do
    echo "------- Started $thread ---------";
    threadInfo=$(sysbench cpu --cpu-max-prime=100000 --threads=$thread run);
    echo "$threadInfo";
    latencyInfo=$(echo "$threadInfo" | grep -A 5 "Latency (ms):");
    avgLatency=$(echo "Avg : $latencyInfo" | grep -A 2 "avg:" | awk '/avg:/ {print $2}');
    cpuSpeed=$(echo "$threadInfo" | grep -A 1 "CPU speed:")
    events=$(echo "$cpuSpeed" | grep -A 1 "events per second:" | awk '/events per second:/ {print $4}');
    echo "Events per seconds : $events";
    echo "Thread_$thread $avgLatency $events" >> $outputFile;
    echo "------- Ended $thread ---------";
done