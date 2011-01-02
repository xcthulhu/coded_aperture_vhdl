# test1 makefile
#
CC = gcc
CFLAGS = -Wall -g
.SUFFIXES : .o .c

CFILES = sxc_shift_small.c

all: sxc_shift_v4

clean:
	rm -f sxc_shift_v4 *.o *~

sxc_shift_v4: sxc_shift_v4.o
	$(CC) $(CFLAGS) sxc_shift_v4.o -o sxc_shift_v4 -lm

sxc_shift_v4.o : sxc_shift_v4.c

.c.o :
	rm -f $@
	$(CC) $(CFLAGS) $< -g -c
