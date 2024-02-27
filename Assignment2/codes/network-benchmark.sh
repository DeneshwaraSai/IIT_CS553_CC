#!/bin/bash

# The "baremetal-network-results.csv" file is used to store thread number, total operations and throughput features.
# "baremetal-network-serverFile.txt" and "baremetal-network-clientFile.txt" files are used to store the logs of client and server command run information
serverFile="baremetal-network-serverFile.txt";
clientFile="baremetal-network-clientFile.txt";
outputFile="baremetal-network-results.csv";

# touch is used to create a new file if not exist.
# > "$file name" is used to empty the file.
touch $outputFile;
> $outputFile;

touch $serverFile;
> $serverFile;

touch $clientFile;
> $clientFile;

# The below variables are used to execute command and use as command parameters.
serverIP="127.0.0.1";
writeBufferBlockSize="8192K";
clientTCPWindowSize="2.5M";
serverTCPWindowSize="1M";
regexForLatency="[0-9.]+/[0-9.]+/[0-9.]+/[0-9.]+";
regexForThroughput="[0-9.]+ Gbits/sec";

# The below line is used to construct headers or column name for the "baremetal-network-results.csv" file.
echo "Threads,AverageLatency,Throughput" >> $outputFile;

# It iterates through a range of thread values (1, 2, 4, 8, 16, 32, and 64). 
# These represent the number of threads used for network benchmarking, indicating how many parallel operations are being simulated.
for thread in 1 2 4 8 16 32 64; do

    # -w $serverWindowSize represents the window size of server
    # tee is used to send them to 
    # &: Runs the command in the background
    iperf -s -w $serverTCPWindowSize | tee $serverFile &

    # -w $clientWindowSize represents the window size of client
    # --nodelay : nagle alg : false
    # --trip-times: measures the round-trip time (RTT) 
    # -l $writeBufferBlockSize represents the write buffer size
    # -P $thread Specifies the number of parallel client threads ($thread)
    # -i 1: Specifies that the results should be displayed every 1 second
    iperf -c $serverIP -e -i 1 -w $clientTCPWindowSize -P $thread --nodelay -l $writeBufferBlockSize --trip-times --parallel 1 > $clientFile

    # grep is used search for a given regex.
    # -A retrieves the number of lines after searching.
    # tr -d [characters] is used to remove respective characters.
    # awk and $number is used to get specified value.
    averageLatency=$(grep -oE '[0-9.]+/[0-9.]+/[0-9.]+/[0-9.]+' $serverFile | awk -F'/' '{print $1}')
    throughputBandWidth=$(grep -oP '[0-9.]+ Gbits/sec' $serverFile | awk '{print $1}')

    echo "Average Latency: $averageLatency "
    echo "Measured Throughput (Gbits/s) : $throughputBandWidth"

    # Storing average latency and throughput for every thread in output file.
    echo "Thread_$thread,$averageLatency,$throughputBandWidth" >> $outputFile;

    # since we need to iterate for every thread count, It is better to remove serverFile previous data 
    rm -rf $serverFile;

    # killing iperf from process allocation
    pkill iperf;

    sleep 2
done

# killing iperf from process allocation
pkill iperf

