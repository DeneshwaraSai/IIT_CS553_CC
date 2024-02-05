#!bin/bash 

outputFile="disk-benchmark-background-log.txt"

# touch command is used to create a new File.
touch $outputFile

# dd is data duplicate, It is a command is used for copying and converting.
# The output that i got after executing dd, I'm storing them in output file
# bs = bloack size of 1 MB
# if = input to get bench marks
# of = output file written on the disk
# count = specifies no of copies
(dd if=/dev/zero of=/tmp/benchmark.out bs=1M count=1 2>&1) > $outputFile &

# Record the ID of the process in the background
PID=$!

# According to question, the benchmark should ru for atleast 10 sec, sleep {number}
sleep 10 

#Just wanted to see the process ID whether it is changing for every run.
echo "PROCESS ID = $PID"

# The time taken is calcuted using wait and process Id
(time wait $PID) 2>> $outputFile

echo "The execution is completed"
