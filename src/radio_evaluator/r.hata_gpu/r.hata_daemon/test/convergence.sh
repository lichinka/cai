#!/bin/bash

cat ../daemon.log | grep 'Objective function' - | cut -d',' -f2,3 | tr -d '[:alpha:]' | tr -d ' ' | grep ',' | grep -v '[.():=]' | uniq > /tmp/conv.temp
seq 1 $(wc -l /tmp/conv.temp | cut -d' ' -f1) > /tmp/line.temp
paste -d',' /tmp/line.temp /tmp/conv.temp | tr ',' '\t' > /tmp/conv.txt

#
# Algorithm parameters
#
STEPS="$(grep '_AG_MAX_AGENT_STEPS_' ../prot.h | sed -e 's/[^0-9]//g')"
_HOSTFILE_="$(grep 'HOSTFILE=' ../start_daemon.sh | cut -d'=' -f2)"
AGENTS="$(grep 'slots' ../${_HOSTFILE_} | tail -n1 | cut -d'=' -f2)"

echo "
    set xlabel  'Unique adjacent reads'
    set ylabel  'Uncovered pixels'
    set y2label 'Total pilot power'
    set ytics   nomirror
    set y2range [0:200000]
    set y2tics  scale default
    set grid
    set title \"Agent-based optimization\n-- ${AGENTS} agent(s), +1.0dB, -0.1dB, ${STEPS} steps each --\"
    plot '/tmp/conv.txt' using 1:2 title 'uncovered px' with lines axis x1y1, \
         '/tmp/conv.txt' using 1:3 title 'power (mW)'   with points axis x1y2 " > convergence.plot
#
# Display graph
#
gnuplot -p convergence.plot

