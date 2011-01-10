
all: events.pdf sxc.out sxc.pdf

clean:
	rm -f *~ *.pdf *.out *.pyc

sxc.out : sxc.py mask.tsv events.tsv
	./sxc.py mask.tsv events.tsv > $@

sxc.pdf : sxc.out ../python/bar.py
	../python/bar.py $< $@

events.pdf : events.tsv ../python/histogram.py
	../python/histogram.py $< $@
