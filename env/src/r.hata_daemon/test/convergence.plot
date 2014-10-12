
    set xlabel  'Number of evaluations'
    set ylabel  'Uncovered pixels'
    set y2label 'Total pilot power'
    set ytics   nomirror
    set y2tics  scale default
    set grid
    set title "Agent-based optimization\n-- 16 agent(s), +0.2dB, -0.1dB, 5000 steps each --"
    plot '/tmp/conv.txt' using 1:2 title 'uncovered px' with lines axis x1y1,          '/tmp/conv.txt' using 1:3 title 'power (mW)'   with points axis x1y2 
