#!/usr/bin/env python

import sys
import csv
import itertools

if (len(sys.argv) > 1) : fin = open(sys.argv[1],"r")
else : fin = sys.stdin

if (len(sys.argv) > 2) : fout = open(sys.argv[2],"w")
else : fout = sys.stdout

events = csv.reader(fin, delimiter='\t')
events_fixed = filter(lambda x : x != "", list(itertools.chain(*events)))
#min_event = min(events_fixed)
events = "\t".join(events_fixed)
print >>fout, events
