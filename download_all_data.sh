#!/bin/bash

# This script downloads all data text files between 2001-2016

let END=2016 i=2001
while ((i<=END)); do
    echo ""
    echo "Downloading data for ${i}"
    ./download_all_months.sh $i
    let i++
    echo ""
done

