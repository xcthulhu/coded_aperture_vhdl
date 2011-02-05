all: events.pdf sxc.out sxc.pdf

clean:
	rm -f *~ *.pdf *.out *.pyc mask_simplifies.tsv mask.tsv

mask_simplified.tsv : mask_full.tsv
	cut -f1000-1100 $< > $@

mask.tsv : mask_simplified.tsv
	ln -s mask_simplified.tsv mask.tsv

sxc.out : sxc.py mask.tsv events.tsv
	./sxc.py mask.tsv events.tsv > $@

sxc.pdf : sxc.out ../python/bar.py
	../python/bar.py $< $@

events.pdf : events.tsv ../python/histogram.py
	../python/histogram.py $< $@
