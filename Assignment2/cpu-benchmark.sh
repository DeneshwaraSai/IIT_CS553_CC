# sysbench cpu --cpu-max-prime=100000 --threads=1 runs

#!bin/bash 

outputFile="cpu_results.txt"

touch $outputFile

for thread in 1 2;do 
    echo "------- Started $thread ---------";
    sysbench cpu --cpu-max-prime=100000 --threads=$thread run >> $outputFile;
    echo "------- Done $thread ---------";
done
