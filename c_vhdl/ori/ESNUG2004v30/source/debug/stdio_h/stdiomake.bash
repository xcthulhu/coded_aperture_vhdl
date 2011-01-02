#!/usr/bin/bash
# Why bash: because the source code is free and portable
# http://www.sunfreeware.com
# File: stdio_h.vhd
# Version: 3.0 (June 6, 2004)
# Source: http://bear.ces.cwru.edu/vhdl
# Date: June 6, 2004 (Copyright)
# Author: Francis G. Wolff   Email: fxw12@po.cwru.edu
# Author: Michael J. Knieser Email: mjknieser@knieser.com
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 1, or (at your option)
# any later version: http://www.gnu.org/licenses/gpl.html
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.	 See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
#
#set -x

function enum_proto() {
  if [ "$enum_nargs" != "0" ]; then
    enum_ntypes=$((${#enum_types[@]}-1));
    enum=$enum_start
    eargs=$(( (enum_ntypes+1)**enum_nargs ))
    while [ $enum -lt $eargs ]; do
      sflag=1; #assume all args are string datatype
      vflag=1; #assume all args are string datatype
      s=""; a=1; ai=1; z=0; n=0; 
      while [ $a -le $enum_nargs ]; do
        di=$(( (enum/ai)%(enum_ntypes+1) ))
        if [ $di != 0 ]; then
          if [ $z == 1 ]; then z=2; fi
          n=$((n+1)); s="$s; a$a: $enum_attrib${enum_types[$di]}"
          if [ "${enum_types[$di]}" != "string"           ]; then sflag=0; fi;
          if [ "${enum_types[$di]}" != "std_logic_vector" ]; then vflag=0; fi;
        else
          if [ $z == 0 ]; then z=1; fi
        fi 
        a=$((a+1)); ai=$(( ai*(enum_ntypes+1) ))
      done
      if [ $enum_string == "1" -o "$sflag$vflag" == "00" ]; then
      if [ $z != 2 ]; then
        echo -ne "$enum_head$s$enum_tail$enum_body" >>stdio_h.vhd

        if [ "$enum_body" != "" ]; then
          s=""; a=1;
          while [ $a -le $n ]; do
            s="$s${enum_list0}${enum_list1}a${a}${enum_list2}"
            a=$((a+1))
          done
          echo -ne "$s$enum_end" >>stdio_h.vhd
        fi
      fi
      fi
      enum=$((enum+1))
    done
  fi
}
echo -ne >stdio_h.vhd

debugf=0; maxargs="1"; all=1; enum_types=( "ignored" "string" )
for arg in "$@"; do
  if [ "${arg}" == "--help" -o "${arg}" == "-h" ]; then
    echo "syntax: stdio_h.sh [--maxargs=<decimal=1>] [--debug] [--bit] [--std_logic]"
    echo "generate a stdio_h.vhd file which will handle a maximum of <maxargs> for printf, scanf, ..."
    echo "  --maxargs=<decimal=1>    generate the same number of args for printf and scanf"
    echo "  --debug                  Enable debug flag to true (Default: no debug and all debug statements deleted"
    echo "  --bit                    include datatypes: bit and bit_vector"
    echo "  --std                    include datatypes: std_logic and std_logic_vector"
    echo "  --int                    include this datatype"
    echo "  --bool                   include this datatype"
    echo "  --time                   include this datatype"
    echo "  --real                   include this datatype"
    echo
    echo "Since VHDL does not support variable type arguments like C or C++, they have to be enumerated."
    echo "The more arguments you require the more function prototypes have to be created."
    echo "This may be excessive on the simulator. Best minimize either the args, functions, or types."
    echo
    echo "Example: stdio_h.bash              generate for maximum of 1 args for fprintf, printf, fscanf, sscanf"
    echo "Example: stdio_h.bash --maxargs=3  generate for maximum of 3 args"
    echo "Example: stdio_h.bash --std --int  generate for maximum of 3 args using only std_logic, integer, string"
  exit
  fi

  if [ "${arg/=*}" == "--maxargs" ]; then maxargs="${arg/*=}"; fi
  if [ "${arg}"    == "--debug"   ]; then debugf=1; fi

  if [ "${arg}" == "--bool" ]; then all=0; enum_types=( "${enum_types[@]}" "boolean" ); fi
  if [ "${arg}" == "--int"  ]; then all=0; enum_types=( "${enum_types[@]}" "integer" ); fi
  if [ "${arg}" == "--std"  ]; then all=0; enum_types=( "${enum_types[@]}" "std_logic" "std_logic_vector" ); fi
  if [ "${arg}" == "--bit"  ]; then all=0; enum_types=( "${enum_types[@]}" "bit" "bit_vector" ); fi
  if [ "${arg}" == "--time" ]; then all=0; enum_types=( "${enum_types[@]}" "time" ); fi
  if [ "${arg}" == "--real" ]; then all=0; enum_types=( "${enum_types[@]}" "real" ); fi
  if [ "${arg}" == "--all"  ]; then all=1; fi

done

if [ "--$all" == "--1" ]; then
  enum_types=( "ignored" "string" "integer" "std_logic" "std_logic_vector" "boolean" "bit" "bit_vector" "time" "real" );
fi;

gdate=`date`; echo "-- file: stdio_h.vhd generated on ${gdate}: stdio_h.sh --maxargs=${maxargs} " >>stdio_h.vhd
cat <stdio_h_head.vhd >>stdio_h.vhd

enum_head="  PROCEDURE printf(format: IN string"
enum_string=0
enum_attrib=""
#enum_types=( "ignored" "string" "integer" "std_logic" "std_logic_vector" "boolean" "bit" "bit_vector")
enum_tail=");\n\n"
enum_body=""
enum_nargs=$maxargs
enum_start=1
enum_proto

#fprintf does not require enumeration for string
enum_head="  PROCEDURE fprintf(stream: IN CFILE; format: IN string"
enum_string=0
enum_attrib=""
#enum_types=( "ignored" "string" "integer" "std_logic" "std_logic_vector" "boolean" "bit" "bit_vector")
enum_tail=");\n\n"
enum_body=""
enum_nargs=$maxargs
enum_start=1
enum_proto

enum_head="  PROCEDURE scanf(format: IN string"
enum_string=1
enum_attrib="INOUT "
#enum_types=( "ignored" "string" "integer" "std_logic" "std_logic_vector" "boolean" "bit" "bit_vector")
enum_tail=");\n\n"
enum_body=""
enum_nargs=$maxargs
enum_start=1
enum_proto

enum_head="  PROCEDURE fscanf(stream: IN CFILE; format: IN string"
enum_string=1
enum_attrib="INOUT "
#enum_types=( "ignored" "string" "integer" "std_logic" "std_logic_vector" "boolean" "bit" "bit_vector")
enum_tail=");\n\n"
enum_body=""
enum_nargs=$maxargs
enum_start=1
enum_proto

enum_head="  PROCEDURE sscanf(s: IN string; format: IN string"
enum_string=1
enum_attrib="INOUT "
#enum_types=( "ignored" "string" "integer" "std_logic" "std_logic_vector" "boolean" "bit" "bit_vector")
enum_tail=");\n\n"
enum_body=""
enum_nargs=$maxargs
enum_start=1
enum_proto

echo "end stdio_h;" >>stdio_h.vhd
echo " " >>stdio_h.vhd

if [ $debugf == 0 ]; then 
  sed -e "/if debug/,/end/d;/debug/d" <stdio_h_tail.vhd >stdio_h_tail.sed
  #cp stdio_h_tail.vhd stdio_h_tail.sed
else
  sed -e "/variable debug/s/false/true/" <stdio_h_tail.vhd >stdio_h_tail.sed
fi
cat <stdio_h_tail.sed >>stdio_h.vhd

enum_head="  PROCEDURE printf(format: IN string"
enum_string=1
enum_attrib=""
#enum_types=( "ignored" "string" "integer" "std_logic" "std_logic_vector" "boolean" "bit" "bit_vector")
enum_tail=") IS\n"
enum_body="    VARIABLE fi: INTEGER:=1;\n  BEGIN\n"
enum_list0=""
enum_list1="    sbufprintf(fi, streamnulbuf, stdout, format, pf("; enum_list2="));\n"
enum_end="  END printf;\n\n"
enum_nargs=$maxargs
enum_start=1
enum_proto

# Note: for fprintf() enum_types"
enum_head="  PROCEDURE fprintf(stream: IN CFILE; format: IN string"
enum_string=0
enum_attrib=""
#enum_types=( "ignored" "integer" "string" "std_logic" "std_logic_vector" "boolean" "bit" "bit_vector")
enum_tail=") IS\n"
enum_body="    VARIABLE fi: INTEGER:=1;\n  BEGIN\n"
enum_list0=""
enum_list1="    sbufprintf(fi, streamnulbuf, stream, format, pf("; enum_list2="));\n"
enum_end="  END fprintf;\n\n"
enum_nargs=$maxargs
enum_start=1
enum_proto

enum_head="  PROCEDURE scanf(format: IN string"
enum_string=1
enum_attrib="INOUT "
#enum_types=( "ignored" "string" "integer" "std_logic" "std_logic_vector" "boolean" "bit" "bit_vector")
enum_tail=") IS\n"
enum_body="    VARIABLE fi: INTEGER:=1; VARIABLE t: LINE;\n  BEGIN\n"
enum_list0=""
enum_list1="    sbufscanf(fi, streamnulbuf, stdin, format, t); pf(t, "; enum_list2=");\n"
enum_end="  END scanf;\n\n"
enum_nargs=$maxargs
enum_start=1
enum_proto

enum_head="  PROCEDURE fscanf(stream: IN CFILE; format: IN string"
enum_string=1
enum_attrib="INOUT "
#enum_types=( "ignored" "string" "integer" "std_logic" "std_logic_vector" "boolean" "bit" "bit_vector")
enum_tail=") IS\n"
enum_body="    VARIABLE fi: INTEGER:=1; VARIABLE t: LINE;\n  BEGIN\n"
enum_list0=""
enum_list1="    sbufscanf(fi, streamnulbuf, stream, format, t); pf(t, "; enum_list2=");\n"
enum_end="  END fscanf;\n\n"
enum_nargs=$maxargs
enum_start=1
enum_proto

enum_head="  PROCEDURE sscanf(s: IN string; format: IN string"
enum_string=1
enum_attrib="INOUT "
#enum_types=( "ignored" "string" "integer" "std_logic" "std_logic_vector" "boolean" "bit" "bit_vector")
enum_tail=") IS\n"
enum_body="    VARIABLE fi: INTEGER:=1; VARIABLE t: line; VARIABLE w: line:=NEW string'(s);\n  BEGIN\n"
enum_list0=""
enum_list1="    sbufscanf(fi, w, -1, format, t); pf(t, "; enum_list2=");\n"
enum_end="    deallocate(w);\n  END sscanf;\n\n"
enum_nargs=$maxargs
enum_start=1
enum_proto

echo "end stdio_h;" >>stdio_h.vhd
cp stdio_h.vhd stdio_h_${maxargs}args.vhd
