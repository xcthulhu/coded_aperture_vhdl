#!/usr/bin/bash
# Why bash: because the source code is free and portable
# http://www.sunfreeware.com
#
# File: endiantest.bash
# Version: 3.0   (June 6, 2004)
# Source:  http://bear.ces.cwru.edu/vhdl
# Date:    June 6, 2004 (Copyright)
# Author:  Francis G. Wolff   Email: fxw12@po.cwru.edu
# Author:  Michael J. Knieser Email: mjknieser@knieser.com
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 1, or (at your option)
# any later version: http://www.gnu.org/licenses/gpl.html
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.   See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
set -x
if [ -e C            ]; then rm -fr C;        fi #synopsys
if [ -e WORK         ]; then rm -fr WORK;     fi #synopsys
if [ -e c            ]; then rm -fr c;        fi #modelsim
if [ -e work         ]; then rm -fr work;     fi #modelsim
if [ -e modelsim.ini ]; then rm -f modelsim.ini; fi #modelsim
if [ -e WORK.SYM     ]; then rm -fr WORK.SYM; fi #symphony eda
if [ -e C.SYM        ]; then rm -fr C.SYM;    fi #symphony eda


./stdiomake.bash

if [ "${1}" == "--vcom" ]; then
  vlib c
  vlib work
  vmap c c
  vmap work work
  vcom -93 -work c ../../endian_h.vhd
  vcom -93 ../../../test/endian_h_test.vhd
  echo "run" >x.txt
  echo "quit" >>x.txt
  vsim -lib work -l endian_h_test_vsim_log.txt endian_h_test_cfg -c -do x.txt

else
  mkdir  C
  mkdir  WORK
  vhdlan -NOEVENT -work C ../../endian_h.vhd
  vhdlan -NOEVENT ../../../test/endian_h_test.vhd

  echo "run" >x.txt
  echo "quit" >>x.txt
  vhdlsim -e x.txt endian_h_test_cfg
fi
