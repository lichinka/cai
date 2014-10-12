#!/bin/bash

GROUP=$1

if [ -n "${GROUP}" ]; then
    LOGS="$( ls ${GROUP}/*.gz | grep -v 'extended' )"
    i=0
    TMP_FILES=" "
    for LOG in ${LOGS}; do
        echo -n '.'
        OUT="/tmp/.${i}.dat"
        gunzip -c ${LOG} | grep 'Objective function' - | grep ', 0 uncovered' | cut -d',' -f3 | tr -d '[:alpha:]' | tr -d ' ' > ${OUT}
        MISSING_LINES="$( gunzip -c ${LOG} | grep 'Objective' - | wc -l ) - $( cat ${OUT} | wc -l )"
        MISSING_LINES="$( echo "${MISSING_LINES}" | bc -l )"
        for j in $( seq 1 ${MISSING_LINES} ); do
            echo "100000000" >> ${OUT}
        done
        TMP_FILES="${OUT} ${TMP_FILES}"
        i=$(( $i + 1 ))
    done

    paste ${TMP_FILES} > /tmp/.all.dat
    cat /tmp/.all.dat | python plot_convergence.py > /tmp/.plot.dat

    CMD=$( cat <<EOF
set term postscript eps enhanced font "Helvetica,18";
set output "convergence_${GROUP}.eps";
set xlabel "Number of evaluations";
set grid xtics;
set ylabel "Total pilot power [Watts]";
set grid ytics;
plot '/tmp/.plot.dat' using (\$1/1000) with lines lw 2 title 'Best', \
     '/tmp/.plot.dat' using (\$2/1000) with lines lw 2 title 'Mean', \
     '/tmp/.plot.dat' using (\$3/1000) with lines lw 2 title 'Worst';
EOF
)
    gnuplot -p -e "${CMD}"
else
    echo "Usage: $0 [group]"
    echo "Generates the convergence plots for the group of log files (first, second or third).-"
fi

