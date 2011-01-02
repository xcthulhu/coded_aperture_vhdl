-- File: stdio_head_h.vhd
-- Version: 3.0 (June 6, 2004)
-- Source: http://bear.ces.cwru.edu/vhdl
-- Date:   June 6, 2004 (Copyright)
-- Author: Francis G. Wolff   Email: fxw12@po.cwru.edu
-- Author: Michael J. Knieser Email: mjknieser@knieser.com
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
--
USE     std.textio.all;
LIBRARY ieee;
USE     ieee.std_logic_1164.all;
LIBRARY C;
USE     C.strings_h.all; --fputs:strlen
USE     C.regexp_h.all;  --sbufprintf:regmatch, sbufscanf:regmatch
USE     C.stdlib_h.all;  --sbufprintf:atoi

PACKAGE stdio_h IS
  FILE     streamfile4, streamfile5, streamfile6: TEXT;
  FILE     streamfile7, streamfile8, streamfile9: TEXT;
  CONSTANT streamNFILE: INTEGER:=9;

  TYPE     streamflags IS ARRAY(0 TO streamNFILE) OF BOOLEAN;
  SHARED   VARIABLE streambusy:   streamflags := (TRUE,TRUE,TRUE,TRUE,OTHERS=>FALSE);
  SHARED   VARIABLE streamlock:   BOOLEAN:=FALSE;
  SHARED   VARIABLE streamnulbuf: LINE; --should allows be null

  TYPE STREAMIOBUF IS
    RECORD
      fstat: FILE_OPEN_STATUS;
      fmode: FILE_OPEN_KIND;   --READ_MODE, WRITE_MODE, APPEND_MODE;
      buf:   LINE;
    END RECORD;

  TYPE       STREAMIOBUFS IS ARRAY(0 TO streamNFILE) OF STREAMIOBUF;
  SHARED     VARIABLE streamiob: STREAMIOBUFS :=
   ((STATUS_ERROR,READ_MODE,NULL), --null fid
    (OPEN_OK,WRITE_MODE,NULL),     --stdout
    (OPEN_OK,READ_MODE,NULL),      --stdin
    OTHERS=>(STATUS_ERROR,READ_MODE,NULL));

  SUBTYPE    CFILE    IS INTEGER;
  CONSTANT   stdin:   CFILE :=2; --UNIX filename "/dev/tty", DOS filename "CON"
  CONSTANT   stdout:  CFILE :=1; --UNIX filename "/dev/tty", DOS filename "CON"
  CONSTANT   stdnul:  CFILE :=3; --UNIX filename "/dev/null", DOS filename "NUL"
  CONSTANT   stderr:  CFILE :=1; --Not support by VHDL 93

  FUNCTION   pf(x: IN BIT)               RETURN STRING;
  FUNCTION   pf(x: IN BOOLEAN)           RETURN STRING;
  FUNCTION   pf(x: IN CHARACTER)         RETURN STRING;
  FUNCTION   pf(x: IN STD_ULOGIC)        RETURN STRING;
  FUNCTION   pf(x: IN STRING)            RETURN STRING;
  FUNCTION   pf(x: IN INTEGER)           RETURN STRING;
  FUNCTION   pf(x: IN BIT_VECTOR)        RETURN STRING;
  FUNCTION   pf(x: IN STD_ULOGIC_VECTOR) RETURN STRING;
  FUNCTION   pf(x: IN STD_LOGIC_VECTOR)  RETURN STRING;
  FUNCTION   pf(x: IN TIME)              RETURN STRING;
  FUNCTION   pf(x: IN REAL)              RETURN STRING;

  --              FILE *fopen(const char *filename, const char *mode);
  IMPURE FUNCTION       fopen(filename: IN STRING; mode: IN STRING) RETURN CFILE;
  --              int   fflush(FILE *stream);
  PROCEDURE             fflush(stream: IN CFILE);
  --              int   fclose(FILE *stream);
  PROCEDURE             fclose(stream: IN CFILE);

  --              int   fputc(int c, FILE *stream);
  PROCEDURE             fputc(c:   IN character; stream: IN CFILE);
  --              int   fputs(const char *s, FILE *stream);
  PROCEDURE             fputs(s:   IN    STRING; stream: IN CFILE);
  PROCEDURE             fputs(s:   INOUT LINE;   stream: IN CFILE); --will deallocate(s)
  --              int   putc(int c, FILE *stream);
  PROCEDURE             putc(c:    IN character; stream: IN CFILE);
  --              int   putchar(int c);
  PROCEDURE             putchar(c: IN character);
  --              int   puts(const char *s);
  PROCEDURE             puts(s:    IN    STRING);
  PROCEDURE             puts(s:    INOUT LINE); --will deallocate(s)

  --              int   feof(FILE *stream);
  IMPURE FUNCTION       feof(stream: IN CFILE) RETURN BOOLEAN;
  --              int   fgetc(FILE *stream);
  IMPURE FUNCTION       fgetc(stream: IN CFILE) RETURN CHARACTER;
  --              char *fgets(char *s, int size, FILE *stream);
  PROCEDURE             fgets(s: OUT  STRING; n: IN INTEGER; stream: IN CFILE);
  --              int   getc(FILE *stream);
  IMPURE FUNCTION       getc(stream: IN CFILE) RETURN CHARACTER;
  --              int   getchar(void);
  IMPURE FUNCTION       getchar RETURN CHARACTER;
  --              char *gets(char *s);
  PROCEDURE             gets(s: OUT STRING);
  --              int   ungetc(int c, FILE *stream);
  PROCEDURE             ungetc(c: IN character; stream: IN CFILE);

  PROCEDURE sbufprintf(fi:  INOUT INTEGER; sbuf: INOUT LINE; stream: IN CFILE;
                       fmt: IN STRING;     s:    IN STRING); --used only for testing package

  PROCEDURE sbufscanf(fi:  INOUT INTEGER; sbuf: INOUT LINE; stream: IN    CFILE;
                      fmt: IN    STRING;  s:    INOUT LINE); --used only for testing package

  PROCEDURE fprintf(stream: IN CFILE; format: IN STRING; a1: INOUT LINE);
  PROCEDURE printf(                   format: IN STRING; a1: INOUT LINE);
  PROCEDURE fscanf( stream: IN CFILE; format: IN string; a1: INOUT LINE);
  PROCEDURE scanf(                    format: IN string; a1: INOUT LINE);
  PROCEDURE sscanf( s:     IN string; format: IN string; a1: INOUT LINE);


  PROCEDURE fprintf(stream:  IN    CFILE;
                    format:  IN    STRING;
                    a1,  a2,  a3,  a4,  a5,  a6,  a7,  a8 : IN STRING := " ";
                    a9,  a10, a11, a12, a13, a14, a15, a16: IN STRING := " ");

  PROCEDURE fprintf(stream:  IN    CFILE;
                    format:  IN    STRING;
                    a1:      IN    STD_LOGIC_VECTOR;
                    a2,  a3,  a4,  a5,  a6,  a7,  a8      : IN STD_LOGIC_VECTOR := "U";
                    a9,  a10, a11, a12, a13, a14, a15, a16: IN STD_LOGIC_VECTOR := "U");

  PROCEDURE printf( format:  IN    STRING;
                    a1,  a2,  a3,  a4,  a5,  a6,  a7,  a8 : IN STRING := " ";
                    a9,  a10, a11, a12, a13, a14, a15, a16: IN STRING := " ");

  PROCEDURE printf( format:  IN    STRING;
                    a1:      IN    STD_LOGIC_VECTOR;
                    a2,  a3,  a4,  a5,  a6,  a7,  a8      : IN STD_LOGIC_VECTOR := "U";
                    a9,  a10, a11, a12, a13, a14, a15, a16: IN STD_LOGIC_VECTOR := "U");

  PROCEDURE sprintf(s: INOUT LINE;   format: IN STRING;  --Append to variable s
                    a1,  a2,  a3,  a4,  a5,  a6,  a7,  a8 : IN STRING := " ";
                    a9,  a10, a11, a12, a13, a14, a15, a16: IN STRING := " ");

  PROCEDURE sprintf(s: INOUT STRING; format: IN STRING;  --Overwrite variable s
                    a1,  a2,  a3,  a4,  a5,  a6,  a7,  a8 : IN STRING := " ";
                    a9,  a10, a11, a12, a13, a14, a15, a16: IN STRING := " ");

  PROCEDURE sprintf(s: INOUT STRING; format:  IN    STRING;
                    a1:      IN    STD_LOGIC_VECTOR;
                    a2,  a3,  a4,  a5,  a6,  a7,  a8      : IN STD_LOGIC_VECTOR := "U";
                    a9,  a10, a11, a12, a13, a14, a15, a16: IN STD_LOGIC_VECTOR := "U");


