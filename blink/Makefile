OBJS = blink.o
PROGS = blink_tb
SIMS = blink_tb.vcd
BITMAP=blink.bit
COMP=ghdl
VHDL_C=$(COMP) -a 
VHDL_E=$(COMP) -e
VHDL_R=$(COMP) -r
DEVEL_BASE=..
RM=rm -f
RMDIR=rm -rf

all: $(OBJS) $(PROGS) $(SIMS) $(BITMAP)

%.o : %.vhdl
	$(VHDL_C) $< 

blink_tb : blink_tb.vhdl blink.o
	$(VHDL_C) $<
	$(VHDL_E) $@

blink_tb.vcd : blink_tb blink.o
	$(VHDL_R) $< --vcd=$@

# Make instructions creating a bitmap from xilinx synthesis tools
# adapted from http://www.excamera.com/sphinx/fpga-makefile.html
project=blink
top_module=Clk_div_led
vendor=xilinx
family=spartan3s
part=xc3s200a-4ft256
files=blink.vhdl
include $(DEVEL_BASE)/xilinx.mk

# Install the bitmap on the armadeus, by loading into the FPGA
include $(DEVEL_BASE)/install.mk
install : install_bitmap

clean :
	# Clean ISE products
	$(RM) *.stx *.ucf.untf *.mrp *.nc1 *.ngm *.prm *.lfp
	$(RM) *.placed_ncd_tracker *.routed_ncd_tracker
	$(RM) *.pad_txt *.twx *.log *.vhd~ *.dhp *.jhd *.cel
	$(RM) *.ngr *.ngc *.ngd *.syr *.bld *.pcf
	$(RM) *_map.mrp *_map.ncd *_map.ngm *.ncd *.pad
	$(RM) *.par *.xpi *_pad.csv *_pad.txt *.drc *.bgn
	$(RM) *.xml *_build.xml *.rpt *.gyd *.mfd *.pnx *.gise
	$(RM) *.vm6 *.jed *.err *.ER result.txt tmperr.err *.bak *.vhd~
	$(RM) *.zip *_backup *.*log *.map *.unroutes *.html
	$(RM) *.prj *.xrpt *.xwbt *.lso *.ptwx *.twr *.ut *.xst
	$(RM) *.bit
	$(RM) impactcmd.txt
	$(RMDIR) iseconfig xlnx_auto_0_xdb xst _ngo *_html _xmsgs __projnav
	# Clean GHDL products
	$(RM) *.o *.cf $(PROGS) *.vcd
	$(RM) -r work
	$(RM) *~
