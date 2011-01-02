set ate=endian_h_test_vhdle_ate.txt
path %path%;"C:\Program Files\Symphony EDA\VHDL Simili 2.3\tcl\bin"
rem
rem   strict VHDL: -strict
rem   silent mode: -s
rem   use stdout:  -nostderr
rem
vhdlp -work c    -strict -maxerrors 10 -nostderr ../../endian_h.vhd >%ate%
vhdlp -work work -strict -maxerrors 10 -nostderr ../../../test/endian_h_test.vhd  >>%ate%
rem
rem  file i/o:     -stdin <file> -stdout <file>
rem  silent mode:  -s
rem  command file: -do <file>
rem  
vhdle -work work -strict -nostderr endian_h_test_cfg >>%ate%
more <%ate%
