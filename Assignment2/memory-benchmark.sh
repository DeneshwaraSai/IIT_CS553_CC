#!/bin/bash

outputFile="memory-results.txt";

memoryBlockSize='1K';
memoryTotalSize=120;
memoryOperation='read';
memoryAccessMode='rnd';

touch $outputFile;
> $outputFile;

for thread in 1 2 4 8 16 32 64; do
    echo "----------STARTED----------"; 
    benchmarkCmd="sysbench memory --memory-block-size=$memoryBlockSize --memory-total-size=${memoryTotalSize}G --memory-oper=$memoryOperation --memory-access-mode=$memoryAccessMode --memory-scope=global --threads=$thread"
    benchmartInfo=$($benchmarkCmd run)
    echo "$benchmartInfo"+"";

    operationInfo=$(echo "$benchmartInfo" | tr -d '()' | grep "Total operations:" | awk '{print $3}');
    echo "\nTotal operations: $operationInfo"

    throughputinfo=$(echo "$benchmartInfo" | tr -d '()' | grep "transferred" | awk '{print $4}');
    echo "transferred : $throughputinfo \n";
    echo "Thread_$thread $operationInfo $throughputinfo" >> $outputFile;
    echo "Thread_$thread $operationInfo $throughputinfo";
    echo "----------ENDED----------\n";
done