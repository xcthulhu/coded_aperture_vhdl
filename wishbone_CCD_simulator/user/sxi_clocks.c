#include <stdlib.h>
#include <stdint.h>
#include <string.h>
#include <fcntl.h>
#include <errno.h>
#include <stdio.h>

#define DEV "/dev/sxi_clocks"
#define ME "sxi_clocks"


// We need to avoid page faults during acquision.
// Otherwise we could lose data and get an EPIPE.
// The best approach would be to use a realtime kernel
// and "wired" memory, but here it should be good enough
// to write bits into the buffer to get it into primary
// memory.

uint16_t *getbuf( size_t size )
{
	size_t bytes = size * sizeof( uint16_t );
	uint16_t *b = malloc( bytes );
	
	if( !b ) {
		perror( ME );
		exit( EXIT_FAILURE );
	}
	
	return memset( b, 0xaa, bytes );
}


// read in data

uint16_t *getdata( size_t size )
{
	uint16_t *b;
	ssize_t count;
	size_t bytes = size * sizeof( uint16_t );
	int f = open( DEV, O_RDONLY );
	
	if( f < 0 ) {
		perror( DEV );
		exit( EXIT_FAILURE );
	}
	
	b = getbuf( size );

// driver is written to read all the requested data
// so read() needs only be called once

	count = read( f, b, bytes );
	
	if( count < 0 ) {
		if( errno == EPIPE ) {
			fprintf( stderr, "%s: Buffer overflow occurred in driver\n", ME );
			exit( EXIT_FAILURE );
		}
		perror( me );
		exit( EXIT_FAILURE );
	}
	
	if( count < bytes ) {
		fprintf( stderr, "%s: asked for %d bytes, but only read %d\n",
			ME, bytes, count );
		exit( EXIT_FAILURE );
	}
	
	if(close( f ) < 0 ) {
		perror( ME );
		exit( EXIT_FAILURE );
	}
	
	return b;
}


// write data out, free the buffer

void putdata( uint_16 *b, size_t *n )
{
	if( write( 1, b, n * sizeof( uint_16 )) < 0 ) {
		perror( me );
		exit( EXIT_FAILURE );
	}
	
	(void) free( b );
}
