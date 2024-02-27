#!/bin/bash

fileTotalSize="3G"
numFiles="128"
fileBlockSize="4096"
fileTestMode="rndrd"
fileIOMode="sync"
extraIOFlag="--file-extra-flags=[direct]"

outputFile="vm-disk-sysbench-results.csv"

> $outputFile

echo "Thread,TotalOperations,Throughput";
for thread in 4 32; do
    echo "Running sysbench with $thread threads... $(date)"
    echo "---------------------- STARTED ---------------------------";

    benchmarkCmd="sysbench fileio --file-total-size=$fileTotalSize --file-num=$numFiles --file-block-size=$fileBlockSize --threads=$thread --file-test-mode=$fileTestMode --file-io-mode=$fileIOMode";
    benchmarkPrepare=$($benchmarkCmd prepare)
    benchmarkInfo=$($benchmarkCmd run)
    echo "$benchmarkInfo"+"";

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

    $benchmarkCmd cleanup
    sleep 3
    echo "Thread_$thread, $totalOperations, $throughputInfo" >> $outputFile;
    echo "Sysbench completed with $thread threads. $(date)"
    echo "---------------------- ENDED ---------------------------";
done

echo "Strong scaling study completed."