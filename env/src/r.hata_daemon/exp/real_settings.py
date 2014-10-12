import fileinput
import matplotlib
import matplotlib.pyplot as plt

cell='PEPE'
pwr = 1
ctr = 1.0
for line in fileinput.input ( ):
    # strip new line character
    line = line[:-1]

    (cell_in, pwr_in) = line.split(',')
    if (cell_in != cell):
        # transform power to milliWatts
        print cell, pow(10, (pwr/ctr)/100)
        pwr = 0
        ctr = 0.0
        cell = cell_in

    pwr += int(pwr_in)
    ctr += 1.0

