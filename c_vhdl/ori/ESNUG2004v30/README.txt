-- File: README.vhd
-- Version: 3.0 (June 6, 2004)
-- Source:  http://bear.ces.cwru.edu/vhdl
-- Date:    June 6, 2004 (Copyright)
-- Author:  Francis G. Wolff   Email: fxw12@po.cwru.edu
-- Author:  Michael J. Knieser Email: mjknieser@knieser.com
--
-- This program is free software; you can redistribute it and/or modify
-- it under the terms of the GNU General Public License as published by
-- the Free Software Foundation; either version 1, or (at your option)
-- any later version: http://www.gnu.org/licenses/gpl.html
--
-- This program is distributed in the hope that it will be useful,
-- but WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.	 See the
-- GNU General Public License for more details.
--
-- You should have received a copy of the GNU General Public License
-- along with this program; if not, write to the Free Software
-- Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
-- --------------------------------------------------------------------------
    Version 3.0: stdio_h.vhd is now completely "big endian" (i.e. prior versions
                 were little endian). Most users wanted this.
                 Also, "file_open" has been replaced with "fopen"; The
                 The file data type is now "CFILE" and not "FILE"
                 Look at examples in "test/stdio_h_test.vhd"

    fout:=fopen("cpudata.txt", "w"); 
    if fout=0 then
      printf("cannot open file=xxx_out.txt\n");
    else
      fprintf(fout, "alu bus=%s", alu_bus);
      fprintf(fout, "=%#x",  alu_bus);
      fprintf(fout, "=%d\n", alu_bus);
      fclose(fout);
    end if;

    Thanks to the following people who emailed me advice:
       Martin Carrol at research.bell-labs.com
       Frank Papenfuss at etechnik.uni-rostock.de, Rostock, Germany.
       Thomas Johansson at Electronic Systems, LiTH, Sweden

    Previous versions will also still be available.
-- --------------------------------------------------------------------------
(0) PC users:   download Winzip: http://www.winzip.com/
    UNIX users: "gzip -dc ESNUG2003v30.tar.gz | tar xvf -"

(1) The idea of this library is use "C" language functions within VHDL language.

    For example: write(buf, "x="); write(buf, aluout); writeline(output, buf);

    can now be:  printf("x=%s\n", aluout); 
    
    resulting in less lines of code.

    If you use the default installation of stdio_h.vhd where --maxargs=1
    then you are require to break up printf's in to simple ones:

    For example: printf("reset=%s ALUout=%d\n", Reset_L, ALUout);
    
    write as:    printf("reset=%s ", Reset_L);
                 printf("ALUout=%d\n", ALUout);

    or as:       printf("reset=%s ALUout=%d\n", pf(Reset_L), pf(ALUout));

    Using --maxarg=2 will avoid this problem but will generate more
    prototype headers which may have an impact on your simulator (see step 4).
    --------------------------------------------------------------------------
(2) cp ./source/*.vhd /myfavoritelibrary

    IF you "DO NOT" want to "TEST" this installation THEN just copy the files
    in the directory ./source. It contains the default case of 1 maximum argument
    for stdio_h functions (i.e. printf, scanf, ...). Note, if you want more args
    then rename the pre-built files in ./source_make. For example, stdio_h_2args.vhd has
    2 arguments: rename stdio_h_2args.vhd as stdio_h.vhd.

    *** Both of these libraries have been tested as VHDL93 using Synopsys & ModelSim. ***

    *** Synopsys 1076 VHDL Simulator Version 2000.12 -- Dec 26, 2000 (Unix SunOS 5.8)
    *** Model Technology ModelSim SE/EE vcom 5.4d Compiler 2000.09 Sep 15 2000 (Unix SunOS 5.8)
    *** Symphony EDA (R) VHDL Compiler/Simulator Module VhdlE, Version 1.5, Build#16a. (Microsoft Windows Millennium 4.90.3)

    --------------------------------------------------------------------------
(3) Notes: 
    (a) Directory ./test is still useful to study VHDL examples

    (b) Look at the included SNUG & ESNUG 2002 paper, presentations and
        test benches for examples: Directory ./doc or http://www.synopsys.com

    (c) Make sure strings are declared in the positive direction!
        (i.e. variable s: string(1 to 256); not string(256 downto 1));

    (d) Make sure .synopsys_vss.setup is set to your environment
        Warning: .synopsys_vss.setup file is included in several places
        Warning: modelsim.ini is setup correctly or in the proper directory

    (e) These libraries must use VHDL 93 because "shared variable" is used
        across processes.

    --------------------------------------------------------------------------
(4) IF you "DO" want to "TEST" the VHDL libraries themselves,
    OR modify the stdio_h.vhd library
      a set of testbenches with their "expected outputs" from previously run simulators
      are included:
  
    (a) Test requirements: 
            (1) bash shell,
            (2) UNIX commands: diff, sed, cat, date, rm, mv, cp
            (3) (OPTIONAL) inlet test: "ps -af", kill, mkfifo, gcc, awk, grep
            (4) Synopsys or ModelSim vhdl93 simulator
        Check the test bench "diff" to compare with the original output
        Inside file: ./source_make/stdio_h.sh --maxargs=1 controls the number of printf args

    (b) Make sure you have "cd" to the directory of where this README.txt file

    (c) PC/MicroSoft Windows/Unix: setup.bat

        ***Note: the ./bin contains .exe files which where downloaded elsewhere.
           No responsibility is taken for the code but so far I don't have
           any problems or virus from them. The sites from which they came
           are in the file: ./bin/dossites.txt ***

    For those of you who wonder how "setup.bat" can work in both Unix & msdos.
    Look at the first line: "echo ; ./bin/setup.bash; exit; "
    Since msdos does not respect semicolons(;) but Unix does :-)

    --------------------------------------------------------------------------
(5) Versions:
    v22 Fixed "stream: INOUT text" to "FILE stream: text" needed for ModelSim's strict VHDL93
           --Synopsys vhdlan is not strict about VHDL93 (i.e. allows mixing syntax)
           --I am really sorry about all the people who had to fix this themselves :-(
           --Sorry about the incompatable source_make files with the source file (which always worked)
        Added setup.bash script which will build stdio and test libraries
        Fixed problems with %x for scanf and printf
        Fixed the "time" datatype: printf("time=%d\n", now);
        Added special case:
             Upto 16 std_logic_vector args can be used if only std_logic_vector
             is used within a single printf, fprintf, sprintf.
        Rewrote VHDL testbench shell scripts to be ModelSim & Synopsys friendly

        Pre-built stdio_h.vhd files included:
          --maxargs=1 (Default installation) minium simulator resources:
                      For example printf("%d/n",i); is allowed.
                      if you need to do 2 args then write it as 2 statements:
                      printf("%d %d\n", i, j); ==> printf("%d", i); printf(" %d/n",j);
                      Special case: upto 16 std_logic_vector args can be still be used.
                        

          --maxargs=2 means you can do printf("%d %d\n", i, j);
                      but you will use more simulator resources

    v21 Add documentation. Some scanf functions are still missing.
        See next release.

    v20 Merged support for both Synopsys & Mentor
 
    v12 Support for Mentor Graphics vcom, vsim.
        Bug fixes related to big endian std_logic_vector scanf.
        Strcpy works for both "to" and "downto".

    v10 Supports Synopsys vhdlan, vhdlan, etc tools.

(6) Credits: Thanks for all those that emailed me. I will gladly
add you, only if you send me email with express permission of your
Name, Company, and Email

--enjoy.

