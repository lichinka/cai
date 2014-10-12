#!/bin/bash

if [ $# -lt 1 ]; then
    echo "Usage:"
    echo "  $0 [experiment label]"
    echo "Parses the real network settings for the cells of the experiment given."
    echo "Output is given in milliWatts."
else
    DATASET=$1
    cat ${DATASET}/real.txt |  tr -d ',' | cut -d' ' -f3,10 | grep -f ${DATASET}/bazne.txt | uniq | tr ' ' ',' | python real_settings.py
fi
