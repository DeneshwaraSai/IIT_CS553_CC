#!/bin/bash

# this is input file which contains few domain names line by line
inputFile="network-test-machinelist.txt"

# this is output file which contains the domain name and avg RTT seperated by a space
outputFile="network-test-latency.txt"

getPingAndCalculateRTT() {
    # get the first argument by $1
    # Given number of samples are 3
    dnsName=$1
    samples=3

    echo ${dnsName}

    # below code is used to send a specific number of ICMP(Internet Control Message Protocol) requests packets to the given DNS name.
    # -c indicates a flag that indicates number of packets to send.
    # grep is used to filter/ search for line at specific string : round-trip 
    # awk operates on per-line bases and respective value at $m and prints
    # cut is used to split and the code splits at / and gets 2nd value
    avgRoundTripTime=$(ping -c $samples $dnsName | grep "round-trip" | awk '{print $4}' | cut -d '/' -f 2)
    echo ${avgRoundTripTime}

    # writing dnsName and avg RTT values into the output file.
    echo "${dnsName} ${avgRoundTripTime}" >> ${outputFile}
}

# checking whether the input file is present. 
# If not present then a message is printed and program is terminated.
if [ ! -f ${inputFile} ]; then
    echo "Error! The input file is not valid"
    exit 1
fi

# Previously if any output file present, then we are removing it and creating a new file
if [ -f ${outputFile} ]; then 
    rm ${outputFile}
    echo '' > ${outputFile}
fi

# looping of each domain name is done here
while IFS= read -r dnsNames; do 
    if [ -n ${dnsNames} ]; then
        getPingAndCalculateRTT ${dnsNames}
    fi
done < ${inputFile}
 
echo "Done!"