Author:  Francis G. Wolff   Email: fxw12@po.cwru.edu
Author:  Michael J. Knieser Email: mjknieser@knieser.com
Makefiles and GHDL test:
Copyright (c) 2005 Salvador E. Tropea <salvador en inti gov ar>
Copyright (c) 2005 Instituto Nacional de Tecnología Industrial

 This program is free software; you can redistribute it and/or modify
 it under the terms of the GNU General Public License as published by
 the Free Software Foundation; either version 2, or (at your option)
 any later version.

 This program is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 GNU General Public License for more details.

 You should have received a copy of the GNU General Public License
 along with this program; if not, write to the Free Software
 Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA
 02111-1307, USA

This VHDL library emulates most of the C standard library. Was created by the
Synopsys Users Group and downloaded from:

http://bear.ces.cwru.edu/vhdl/

Corresponds to the 3.0 version of 2004.

It perfectly compiles with GHDL here are some small problems I found:

1) One of the tests needs --ieee=synopys. To avoid complicating the makefiles
I just included the needed functions in the test.
2) The stdio module closes files using file_close but providing a descriptor
that failed to open. Old GHDL versions dies at run time. GHDL 0.18 solves it.
3) I never tried the pipe examples.

To compile the library and run the tests just run "make". It will run the
tests and show the differences between the expected result and the actual
output. The only differences that you should get are in the floating point
precission (rounding issues).

The name of the library is "c". In order to use it just do:

Library c;
Use c.stdio_h.all;

You can find an example in "test_use/hello.vhdl"

For more information read the original docs from:

ori/ESNUG2004v30/

