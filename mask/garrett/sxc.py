#!/usr/bin/env python
import numpy as np
import sys, csv, itertools

# Input files come from command line
mask_fp = open(sys.argv[1],"r")
events_fp = open(sys.argv[2],"r")

# Get data from input files
mask = csv.reader(mask_fp, delimiter='\t')
mask = map(int,list(itertools.chain(*mask)))
mask = np.array(mask)

events = csv.reader(events_fp, delimiter='\t')
events = np.array(map(int,list(itertools.chain(*events))))
rng = max(events) - min(events)
# Make it so that the lowest value event is 0
events = events - min(events)

# Initiate the image array filled with zeros
image = np.array(map(int,np.zeros(rng + len(mask))))

for e in events:
	for i in range(len(mask)): 
		image[e + i] += 5 * mask[i] - 1

print "\t".join(map(str,image))

mask_fp.close()
events_fp.close()
