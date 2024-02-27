'''#!/bin/bash

outputFile="network-benchmark.csv";

serverTCPWindowSize=1M
clientTCPWriteBufferSize="8192K"
clientTCPTCPWindowSize="2.5M"
naggleAlg="off"
portNumber=5001
serverIPAddress="129.114.109.131"

# echo "started ";
# (iperf -s -w 1M 
# iperf -c 129.114.109.131 -e -i 1 --nodelay -l 8192K --trip-times --parallel 1
# ) &
# wait



start_server() {
    iperf -s -w 1M 
}

# Function to start iperf client
start_client() {
    iperf -c 129.114.109.131 -e -i 1 --nodelay -l 8192K
}

# Start server in background
start_server &

# Start client in background
start_client &
wait

echo "Started ";
info=$(iperf -c 129.114.109.131 -e -i 1 --nodelay -l 8192K --trip-times --parallel 1 &);
# info=$(iperf -c $serverIPAddress -p $portNumber -w $clientTCPTCPWindowSize -F $clientTCPWriteBufferSize -N)
echo "Started1111 ";
echo $info;

# kill -9 $(lsof -ti :5001) '''























outputFile1="server-file.txt";
outputFile2="client-file.txt";




# Start the server in the background
iperf -s -w 1M & >> $outputFile1;
server_pid=$!

# Wait for 1 second to let the server start
sleep 1

# Run the client with specified options
for thread of 1 2 4 8 16 32 64; do
    iperf -c 10.35.224.209 -e -i $thread --nodelay -l 8192K --trip-times --parallel 1 >> $outputFile2
done

sleep 2
echo $server_pid;
# Stop the server after the client finishes
kill $server_pid
wait $server_pid

echo "Test completed."