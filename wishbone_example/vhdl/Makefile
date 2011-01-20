# Make instructions creating a bitmap from xilinx synthesis tools
# adapted from http://www.excamera.com/sphinx/fpga-makefile.html
project=wishbone_example_apf27
top_module=top_wishbone_example
vendor=xilinx
family=spartan3s
part=xc3s200a-4ft256
files=button.vhd  intercon.vhd  irq_mngr.vhd  led.vhd  rstgen_syscon.vhd  top_wishbone_example.vhd  wishbone_wrapper.vhd
include ../../xilinx.mk

BITMAP=$(project).bit
all: $(BITMAP)

# Install the bitmap on the armadeus, by loading into the FPGA
include ../../install.mk
install : install_bitmap

# Clean up (in case you were foolish enough to call the fucking ISE)
RMDIR=rm -rf
RM=rm -f
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
