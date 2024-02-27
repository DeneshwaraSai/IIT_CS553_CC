#!/bin/bash

# The below variable are used for furture sysbench fileio command.
fileTotalSize="120G"
numFiles="128"
fileBlockSize="4096"
fileTestMode="rndrd"
fileIOMode="sync"
extraIOFlag="--file-extra-flags=direct"

# The "vm-disk-benchmark-results.csv" file is used to store thread number, total operations and throughput features.
outputFile="vm-disk-benchmark-results.csv";

# The "vm-disk-benchmark-logFile.txt" file is used to store logs after executing the command.
logFile="vm-disk-benchmark-logFile.txt";

# touch is used to create a new file if not exist.
# > "$file name" is used to empty the file.
touch $outputFile;
> $outputFile;

touch $logFile;
> $logFile;

# The below line is used to construct headers or column name for the "vm-disk-benchmark-results.csv" file.
echo "Thread,TotalOperations,Throughput" >> $outputFile;

# 1 2 4 8 16 32 64 - represents the count of threads that are placed a list and iteration begins here
for thread in 1 2 4 8 16 32 64; do
    echo "Running sysbench with $thread threads... $(date)"
    echo "---------------------- STARTED ---------------------------";

    # The below line is created by giving few input parameters
    benchmarkCmd="sysbench fileio --file-total-size=$fileTotalSize --file-num=$numFiles --file-extra-flags=direct --file-block-size=$fileBlockSize --threads=$thread --file-test-mode=$fileTestMode --file-io-mode=$fileIOMode";
   
    # Here preparation of command and thereby creation of files starts. 
    # It created 128 files one after the other depending on the parameters that we provide.
    # The fie are created in the form of test_file.*
    benchmarkPrepare=$($benchmarkCmd prepare)

    #  The command starts running here.
    benchmarkInfo=$($benchmarkCmd run)

    # The below command is used to capture the sysbench fileio information by looping it with given thread count.
    # The command output is stored in logFile.
    echo "$benchmarkInfo"+"";
    echo $benchmarkInfo >> $logFile;

    # grep is used search for a given regex.
    # -A retrieves the number of lines after searching.
    # awk and $number is used to get specified value.
    operations=$(echo "$benchmarkInfo" | grep -A 5 "File operations:")
    throughput=$(echo "$benchmarkInfo" | grep -A 5 "Throughput:")
    totalOperations=$(echo $operations | grep -A 5 'reads/s' | awk '{print $4}')
    throughputInfo=$(echo $throughput | grep -A 5 'read, MiB/s' | awk '{print $4}')

    echo "-------------------------------------------------";
    echo $operations;
    echo $throughput;
    echo $totalOperations;
    echo $throughputInfo;
    echo "-------------------------------------------------";

    # cleanup command is used to remove all files from the desired prepared path.
    $benchmarkCmd cleanup

    # Storing total operations,throughput for every thread in output file.
    echo "Thread_$thread,$totalOperations,$throughputInfo" >> $outputFile;
    echo "Sysbench completed with $thread threads. $(date)"
    echo "---------------------- ENDED ---------------------------";
done

echo "Strong scaling study completed."