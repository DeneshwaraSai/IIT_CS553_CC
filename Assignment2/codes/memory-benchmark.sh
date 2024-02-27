#!/bin/bash

# The "baremetal-memory--benchmark-results.csv" file is used to store thread number, total operations and throughput features.
outputFile="baremetal-memory-benchmark-results.csv";

# The "baremetal-memory-benchmark-logFile.txt" file is used to store logs after executing the command.
logFile="baremetal-memory-benchmark-logFile.txt";

memoryBlockSize='1K';
memoryTotalSize=120;
memoryOperation='read';
memoryAccessMode='rnd';

# touch is used to create a new file if not exist.
# > "$file name" is used to empty the file.
touch $outputFile;
> $outputFile;

touch $logFile;
> $logFile;

# The below line is used to construct headers or column name for the "baremetal-memory--benchmark-results.csv" file.
echo "Thread,TotalOperations,Throughput" >> $outputFile;

# It iterates through a range of thread values (1, 2, 4, 8, 16, 32, and 64). 
# These represent the number of threads used for memory benchmarking, indicating how many parallel operations are being simulated.
for thread in 1 2 4 8 16 32 64; do
    echo "----------STARTED----------";

    # The below command is used to system benchmarking memory performance.
    # memory block size about 1K
    # memoryOperation = 'read'
    # 120Gibs as total size 
    benchmarkCmd="sysbench memory --memory-block-size=$memoryBlockSize --memory-total-size=${memoryTotalSize}G --memory-oper=$memoryOperation --memory-access-mode=$memoryAccessMode --threads=$thread"
    echo "$benchmarkCmd";
    benchmartInfo=$($benchmarkCmd run);

    # The below command is used to capture the sysbench fileio information by looping it with given thread count.
    # The command output is stored in logFile.
    echo $benchmartInfo >> $logFile;
    echo "$benchmartInfo"+"";

    # grep is used search for a given regex.
    # -A retrieves the number of lines after searching.
    # tr -d [characters] is used to remove respective characters.
    # awk and $number is used to get specified value.
    operationInfo=$(echo "$benchmartInfo" | tr -d '()' | grep "Total operations:" | awk '{print $3}');
    echo "\nTotal operations: $operationInfo"

    throughputinfo=$(echo "$benchmartInfo" | tr -d '()' | grep "transferred" | awk '{print $4}');
    echo "transferred : $throughputinfo \n";
    echo "operationInfo : $operationInfo \n";

    echo "Thread_$thread $operationInfo $throughputinfo";

    # Storing total operations,throughput for every thread in output file.
    echo "Thread_$thread,$operationInfo,$throughputinfo" >> $outputFile;
    echo "----------ENDED----------\n";
done