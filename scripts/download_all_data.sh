#!/bin/bash

# This script downloads all data text files between 2001-2016
START=$1
END=$2

echo ""
#echo "Downloading data from ${START} to ${END}"

let i=START
while ((i<=END)); do
    echo ""
    echo "Downloading data for ${i}"
    ./scripts/download_all_months.sh $i
    let i++
    echo ""
done

