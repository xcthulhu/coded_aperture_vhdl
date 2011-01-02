OBJDIR=c-obj
WORK=c
VHDL_C=ghdl -a --work=$(WORK) --workdir=$(OBJDIR)
PREFIX=/usr/local/lib/gcc/i686-pc-linux-gnu/3.4.3/vhdl/lib/v93

.PHONY: test

all: $(OBJDIR) \
	$(OBJDIR)/ctype_h.o $(OBJDIR)/endian_h.o $(OBJDIR)/debugio_h.o \
	$(OBJDIR)/strings_h.o $(OBJDIR)/stdlib_h.o $(OBJDIR)/regexp_h.o  \
	$(OBJDIR)/stdio_h.o \
	test

$(OBJDIR)/%.o: %.vhdl
	$(VHDL_C) $<

$(OBJDIR):
	mkdir $(OBJDIR)

test:
	$(MAKE) -C test

clean:
	-rm -r $(OBJDIR)
	$(MAKE) -C test clean

install:
	install -d -m 0755 $(PREFIX)/$(WORK)
	install -m 0644 $(OBJDIR)/* $(PREFIX)/$(WORK)
#ctype_h.vhd
#debugio_h.vhd
#endian_h.vhd
#regexp_h.vhd
#stdio_h.vhd
#stdlib_h.vhd
#strings_h.vhd
