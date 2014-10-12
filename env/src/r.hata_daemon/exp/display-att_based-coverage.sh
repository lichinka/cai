#!/bin/bash

if [ $# -lt 1 ]; then
    echo "Usage:"
    echo "  $0 [number of transmitters]"
    echo "Shows the pilot power needed for each transmitter to achieve"
    echo "full coverage of the service area. The powers are calculated"
    echo "with the attenuation-based approach."
else
    WORK_DIR=$(find .. -iname 'daemon.log' -printf '%h')
    TX_NUM=$(( $1 - 1 ))
    for tx in $(seq 0 ${TX_NUM});
    do
        PWR=$(cat ${WORK_DIR}/daemon.log  | grep -F '|' | cut -d'|' -f4,5 | tr '|' ' ' | grep "^${tx} " | sort -k2 -rn | grep -v '00000$' | head -n1)
        PWR=$(echo ${PWR} | cut -d' ' -f2)
        echo "pilots[${tx}] = $( echo "${PWR}*1000.0" | bc | cut -d'.' -f1 );"
    done
fi

