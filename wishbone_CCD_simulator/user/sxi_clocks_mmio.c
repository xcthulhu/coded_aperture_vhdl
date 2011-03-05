#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <sys/mman.h>
#include <unistd.h>
#include <stdint.h>
#include <fcntl.h>

// How many words to grab

#define COUNT 2000000

// Register address offsets

#define C_ID	0x8
#define	C_COUNT	0xA
#define C_DATA	0xC
#define C_BAD	0xE

// Identify the firmware

#define C_ID_NUM	0x0523

// Mapping of FPGA in the Armadeus

#define FPGA_ADDRESS 0xD6000000

static volatile void *regp;

// We need to avoid page faults during acquision.
// Otherwise we could lose data.
// The best approach would be to use a realtime kernel
// and "wired" memory, but here it should be good enough
// to write bits into the buffer to get it into primary
// memory.

static uint16_t *getbuf( size_t size )
{
	size_t bytes = size * sizeof( uint16_t );
	uint16_t *b = malloc( bytes );
	
	if( !b ) {
		perror( "getbuf" );
		exit( EXIT_FAILURE );
	}
	
	return memset( b, 0xaa, bytes );
}


// Get a pointer to the registers the FPGA firmware implements

static void *locate_regs( void )
{
	void *ra;
	int fd = open("/dev/mem", O_RDWR|O_SYNC);
	if (fd < 0) {
		perror("/dev/mem");
		exit( EXIT_FAILURE );
	}


	ra = mmap(0, 8192, PROT_READ|PROT_WRITE, MAP_SHARED, 
		fd, FPGA_ADDRESS);
	if (ra == MAP_FAILED) {
		perror("mmap");
		exit( EXIT_FAILURE );
	}
	
	return ra;
}


// FPGA register access

static inline uint16_t getreg( int reg )
{
	return * (volatile uint16_t *) (regp + reg);
}


static inline void putreg( int reg, uint16_t val )
{
	* (volatile uint16_t *) (regp + reg) = val;
}


// If the ID register is wrong, give up

static void checkID( void )
{
	uint16_t id = getreg( C_ID );
	
	if( C_ID_NUM != C_ID ) {
		fprintf( stderr, "Id 0x%x != expected 0x%x\n", id, C_ID_NUM );
		exit( EXIT_FAILURE );
	}
}


// Read a bufferful

static void getem( uint16_t *buf, int count )
{
	while( count-- ) {
		while( !getreg( C_COUNT )) ;	/* spin */
		*buf++ = getreg( C_DATA );
	}
}


// Write a bufferful

static void dumpem( uint16_t *buf, int count )
{
	int r = write( 1, buf, count * sizeof( uint16_t ));

	if( r < 0 ) {
		perror( "Can't output" );
		exit( EXIT_FAILURE );
	}
}


// If you're not root, this won't work, but just print a warning	

static void priority( void )
{
	if( -20 != nice( -20 )) perror( "priority" );
}


int main(int argc, char **argv, char **envp)
{
	uint16_t *buf;
	
	priority();	// raise priority to avoid data loss
	
	buf = getbuf( COUNT );
	
	regp = locate_regs();
	
	checkID();
	
	getem( buf, COUNT );
	
	dumpem( buf, COUNT );
	
	exit( EXIT_SUCCESS );
}
	
	
