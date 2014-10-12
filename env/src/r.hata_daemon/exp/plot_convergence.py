import sys

best  = int (100000000)
worst = int (100000000)
mean  = float (100000000)

for line in sys.stdin:
    pwrs = [int (s) for s in line.split ('\t')]
    if best > min (pwrs):
        best = int (min (pwrs))
    if worst > max (pwrs):
        worst = int (max (pwrs))
    cur_mean = sum (pwrs) / float (len (pwrs))
    if mean > cur_mean:
        mean = cur_mean
    print ('%d\t%.3f\t%d' % (best, mean, worst))
