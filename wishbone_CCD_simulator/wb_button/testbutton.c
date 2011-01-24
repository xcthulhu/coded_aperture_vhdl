/* 
 * A simple program to test Wishbone button driver
 *
 * (c) Copyright 2008    Armadeus project
 * Fabien Marteau <fabien.marteau@armadeus.com>
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2, or (at your option)
 * any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
 **********************************************************************
 */

#include <stdio.h>
#include <stdlib.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <signal.h>


int fd_button;

void quit(int signal)
{
    close(fd_button);
    exit(0);
}

void usage(char *prog_name)
{
    if (prog_name) {
        printf("\nUsage:\n");
        printf("%s <button_device> [count]\n", prog_name);
    }
}

int main(int argc, char *argv[])
{
    unsigned short i, value=0;
    int count=0, max_count=0;

    /* quit when Ctrl-C is pressed */
    signal(SIGINT, quit);

    if (argc < 2) {
        printf("invalid arguments number\n");
        usage(argv[0]);
        exit(EXIT_FAILURE);
    }

    fd_button = open(argv[1], O_RDWR);
    if (fd_button < 0) {
        perror("can't open file");
        exit(EXIT_FAILURE);
    }

    if (argc == 3)
        max_count = atoi(argv[2]);

    printf("Press button\n");

    while (1) {
        /* read value (blocking) */
        if (read(fd_button, &value, 1) < 0) {
            perror("read error");
            exit(EXIT_FAILURE);
        }
        printf("Read %d\n", value);
        count++;
        if (max_count && (count >= max_count))
            break;

/* needed ?
        if (lseek(fd_button, 0, SEEK_SET) < 0) {
            perror("lseek error");
            exit(EXIT_FAILURE);
        }
*/
    }

    close(fd_button);
    exit(0);
}

