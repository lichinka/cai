#!/bin/bash

if [ $# -lt 1 ]; then
    echo "Usage:"
    echo "  $0 [experiment label]"
    echo "Generates convergence graphs for the article, out of experimental data."
else
    DATASET=$1
    WORST_VALUE=0
    BEST_VALUE=9999999
    PASTE="paste -d. "
    for i in $( seq 1 20 );
    do
        if [ -f ${DATASET}/${i}.gz ]; then
            zcat ${DATASET}/${i}.gz | grep 'Objective' | cut -d',' -f2,3 | tr -d '[:alpha:]' | tr -d ' '> /tmp/${i}.txt
            PASTE="${PASTE} /tmp/${i}.txt"
           
            BAD_VALUE=$( cat /tmp/${i}.txt | cut -d',' -f2 | sort -nr | head -n1 )
            if [ ${WORST_VALUE} -lt ${BAD_VALUE} ]; then
                WORST_VALUE=${BAD_VALUE}
            fi

            GOOD_VALUE=$( cat /tmp/${i}.txt | cut -d',' -f2 | sort -n | head -n1 )
            if [ ${BEST_VALUE} -gt ${GOOD_VALUE} ]; then
                BEST_VALUE=${GOOD_VALUE}
            fi
        fi
    done

    echo "Best value is ${BEST_VALUE}"
    echo "Worst value is ${WORST_VALUE}"

    ${PASTE} > /tmp/conv.txt
    cat /tmp/conv.txt | python convergence.py ${WORST_VALUE}
fi
