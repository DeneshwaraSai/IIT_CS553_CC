#!/bin/bash

# Define variables
total_data_size="6G"
num_files="128"
file_block_size="4K"
test_mode="rndrd"
io_mode="sync"
results_file="disk-sysbench_results.txt"
extra_io_flag="--file-extra-flags=direct"
> $results_file

for thread in 4 16 32; do
    echo "Running sysbench with $thread threads..."
    benchmarkCmd="sysbench fileio --file-total-size=$total_data_size --file-num=$num_files --file-block-size=$file_block_size --threads=$thread --file-test-mode=$test_mode --file-io-mode=$io_mode";
    benchmarkPrepare=$($benchmarkCmd prepare)
    echo "";
    benchmarkInfo=$($benchmarkCmd run)
    echo $benchmarkInfo;
    echo $benchmarkInfo >> $results_file;
    echo "";
    $benchmarkCmd cleanup
    sleep 5
    # sysbench fileio --file-total-size=$total_data_size --file-num=$num_files --file-block-size=$file_block_size --threads=$thread --file-test-mode=$test_mode --file-io-mode=$io_mode prepare
    # sysbench fileio --file-total-size=$total_data_size --file-num=$num_files --file-block-size=$file_block_size --threads=$thread --file-test-mode=$test_mode --file-io-mode=$io_mode run >> $results_file
    # sysbench fileio --file-total-size=$total_data_size --file-num=$num_files --file-block-size=$file_block_size --threads=$thread --file-test-mode=$test_mode --file-io-mode=$io_mode cleanup >> $results_file

    echo "Sysbench completed with $thread threads."
done

echo "Strong scaling study completed."






# for thread in 16; do
#     echo "Running sysbench with $thread threads..."
 
#     sysbench fileio --file-total-size=$total_data_size --file-num=$num_files --file-block-size=$file_block_size --threads=$thread --file-test-mode=$test_mode --file-io-mode=$io_mode prepare

#     echo "Sysbench completed with $thread threads."
# done

# Perform strong scaling study
# for thread in 16; do
#     echo "Running sysbench with $thread threads..."
 
#     sysbench fileio --file-total-size=$total_data_size --file-num=$num_files --file-block-size=$file_block_size --threads=$thread --file-test-mode=$test_mode --file-io-mode=$io_mode run >> $results_file

#     echo "Sysbench completed with $thread threads."
# done

# Perform strong scaling study
# for thread in 16; do
#     echo "Running sysbench with $thread threads..."
 
#     sysbench fileio --file-total-size=$total_data_size --file-num=$num_files --file-block-size=$file_block_size --threads=$thread --file-test-mode=$test_mode --file-io-mode=$io_mode cleanup >> $results_file

#     echo "Sysbench completed with $thread threads."
# done
