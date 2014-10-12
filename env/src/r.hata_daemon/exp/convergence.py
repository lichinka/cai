import sys
import matplotlib
import matplotlib.pyplot as plt

#
# parse command line parameters
#
power_bound = int(sys.argv[1])

steps = [0]
best_pwr_lst = []
avg_pwr_lst = []
worst_pwr_lst = []

best_pwr = 999999
med_pwr = 0
worst_pwr = -999999

best_cov = 999999
med_cov = 0
worst_cov = -999999

for line in sys.stdin:
    if 'Objective function' in line:
        worst_pwr = -999999
        med_pwr = 0; med_pwr_lst = []
        med_cov = 0; med_cov_lst = []

        # strip new line character
        line = line[:-1]
        for pair in line.split('.'):
            if (len(pair) > 0):
                nums = [int (s) for s in pair.split (',') if s.isdigit ( )]

                print (pair)

                #uncovered = int (nums[1])
                #power = int (nums[2])

                #if (uncovered > 0):
                #    power = power_bound

                #if (best_pwr > power):
                #    best_pwr = power
                ##if (worst_pwr < power):
                ##    worst_pwr = power
                #med_pwr_lst.append (power)

    #    for power in med_pwr_lst:
    #        med_pwr += power
    #        if (worst_pwr < power):
    #            worst_pwr = power

    #    med_pwr = med_pwr / len(med_pwr_lst)

        #print best_cov, best_pwr, med_cov, med_pwr, worst_cov, worst_pwr

    #    steps.append (steps[-1] + 1)
    #    best_pwr_lst.append (best_pwr/1000.0)
    #    avg_pwr_lst.append (med_pwr/1000.0)
    #    worst_pwr_lst.append (worst_pwr/1000.0)

sys.exit (-1)

#
# repeat last values
#
best_pwr_lst.append (best_pwr/1000.0)
avg_pwr_lst.append (med_pwr/1000.0)
worst_pwr_lst.append (worst_pwr/1000.0)

#
# flatten values for avg and worst
#
min_avg = 999999
min_worst = 999999
for i in range(0, len(avg_pwr_lst)):
    if (min_avg > avg_pwr_lst[i]):
        min_avg = avg_pwr_lst[i]
    avg_pwr_lst[i] = min_avg
    if (min_worst > worst_pwr_lst[i]):
        min_worst = worst_pwr_lst[i]
    worst_pwr_lst[i] = min_worst

#
# generate plot
#
fig = plt.figure ( )
ax1 = fig.add_subplot (111)

ax1.set_title ("Net2 optimization\n-- 16 agents, +0.2dB, -0.1dB, 10000 changes each --")
ax1.set_xlabel ('Number of evaluations')
ax1.set_ylabel ('Total pilot power (Watts)')
ax1.grid (True)

ax1.plot (steps, best_pwr_lst, 'k', label=r'$best$')
ax1.plot (steps, avg_pwr_lst, 'k--', label=r'$median$')
ax1.plot (steps, worst_pwr_lst, 'k-.', label=r'$worst$')
ax1.legend (loc='upper right')

"""
    Second Y axis

ax2 = ax1.twinx ( )
ax2.set_ylabel ('Number of uncovered pixels')
ax2.plot (steps, cov_lst, '.')
"""

plt.show ( )

