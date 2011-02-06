all: events.pdf sxc.out sxc.pdf

clean:
	rm -f *~ *.pdf *.out *.pyc mask_simplified.tsv mask.tsv

mask_simplified.tsv : mask_full.tsv
	cut -f600-699 $< > $@

mask.tsv : mask_simplified.tsv
	ln -s $< $@

sxc.out : sxc.py mask.tsv events.tsv
	./sxc.py mask.tsv events.tsv > $@

sxc.pdf : sxc.out ../python/bar.py
	../python/bar.py $< $@

events.pdf : events.tsv ../python/histogram.py
	../python/histogram.py $< $@
