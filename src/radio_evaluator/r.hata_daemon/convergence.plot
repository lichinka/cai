
    set xlabel  'Unique adjacent reads'
    set ylabel  'Uncovered pixels'
    set y2label 'Total pilot power'
    set ytics   nomirror
    set y2range [0:200000]
    set y2tics  scale default
    set grid
    set title "Agent-based optimization\n--  agent(s), +dB, -dB,  steps each --"
    plot '/tmp/conv.txt' using 1:2 title 'uncovered px' with lines axis x1y1,          '/tmp/conv.txt' using 1:3 title 'power (mW)'   with points axis x1y2 
