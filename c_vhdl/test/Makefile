OBJDIR=c-obj
REFDIR=ref
COMP=ghdl
VHDL_C=$(COMP) -a --workdir=$(OBJDIR) -P../$(OBJDIR)
VHDL_E=$(COMP) -e --workdir=$(OBJDIR) -P../$(OBJDIR)

.PHONY: showerr

all: $(OBJDIR) \
	$(OBJDIR)/ctype_h_test $(OBJDIR)/debugio_h_test $(OBJDIR)/stdio_h_test \
	$(OBJDIR)/regexp_h_test $(OBJDIR)/stdlib_h_test $(OBJDIR)/strings_h_test \
	$(OBJDIR)/endian_h_test \
	showerr

# Synopsys:
#	$(OBJDIR)/regexp_h_test

$(OBJDIR)/%: %.vhdl
	$(VHDL_C) $<
	$(VHDL_E) -o $(OBJDIR)/$(basename $<) $(basename $<)
	cd $(OBJDIR); ./$(basename $<) > $(basename $<)_$(COMP)_ate.txt
	-diff -u $(REFDIR)/$(basename $<)_ate.txt $(OBJDIR)/$(basename $<)_$(COMP)_ate.txt >> $(OBJDIR)/errors.txt

$(OBJDIR):
	mkdir $(OBJDIR)
	cd $(OBJDIR); ln -s ../debugio_h_test.vhdl debugio_h_test.vhd
	echo "0xx10uhh" > $(OBJDIR)/stdio_inlet_test_file.txt
	echo "0123" >> $(OBJDIR)/stdio_inlet_test_file.txt
	echo "uuuu" >> $(OBJDIR)/stdio_inlet_test_file.txt
	echo "-23" >> $(OBJDIR)/stdio_inlet_test_file.txt
	echo "0x123" >> $(OBJDIR)/stdio_inlet_test_file.txt

showerr:
	cat $(OBJDIR)/errors.txt

clean:
	-rm -r $(OBJDIR)

# inlet_test.vhd
