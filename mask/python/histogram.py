#!/usr/bin/env python
import numpy as np
import matplotlib.mlab as mlab
import matplotlib.pyplot as plt
import sys, csv, itertools

# Adapted from http://matplotlib.sourceforge.net/plot_directive/mpl_examples/pylab_examples/histogram_demo.py

if (len(sys.argv) > 1) : fin = open(sys.argv[1],"r")
else : fin = sys.stdin

# Get data from indicated input file
data_raw = csv.reader(fin, delimiter='\t')
data = map(int, filter(lambda x : x != "", 
                       list(itertools.chain(*data_raw))))

# the histogram of the data
n, bins, patches = plt.hist(data, 50, normed=1, facecolor='green', alpha=0.75)

plt.title(sys.argv[1])
plt.axis([min(data), max(data), 0, max(n)])
plt.grid(True)

if (len(sys.argv) > 2) : plt.savefig(sys.argv[2])
else: plt.show()
