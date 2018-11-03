#!/bin/bash

BLOCKS=("4k" "16k" "512k" "1m" "2m" "4m")
TEST_PATH="/beegfs/vdbench/h1"

for BLOCK in "${BLOCKS[@]}"
do
    OUTPUT_FOLDER="output-$BLOCK"
    ./vdbench -f ./config_linux.txt -o "$OUTPUT_FOLDER" xfersize=$BLOCK path=$TEST_PATH
done

