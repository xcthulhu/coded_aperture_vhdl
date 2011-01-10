#!/usr/bin/env python
import numpy as np
import matplotlib.pyplot as plt
import sys, csv, itertools

# Adapted from http://scienceoss.com/bar-plot-with-custom-axis-labels/

if (len(sys.argv) > 1) : fin = open(sys.argv[1],"r")
else : fin = sys.stdin

# Get data from indicated input file
data_raw = csv.reader(fin, delimiter='\t')
data = map(int, filter(lambda x : x != "", 
                       list(itertools.chain(*data_raw))))

# barplot from the data
plt.vlines(range(len(data)),[0],data,lw=0.5)
plt.title(sys.argv[1])
plt.xlim(xmin=0)

#xlocations = na.array(range(len(data)))
#n, bins, patches = plt.hist(data, 50, normed=1, facecolor='green', alpha=0.75)


#plt.axis([min(data), max(data), 0, max(n)])
#plt.grid(True)

if (len(sys.argv) > 2) : plt.savefig(sys.argv[2])
else: plt.show()
