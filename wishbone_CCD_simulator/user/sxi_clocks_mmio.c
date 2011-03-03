#define COUNT 2000000

static void *regp;

// We need to avoid page faults during acquision.
// Otherwise we could lose data.
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

// Get a pointer to the registers the FPGA firmware implements

void *locate_regs( void )
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


static inline uint16_t getreg( int reg )
{
	return * (uint16_t *) (regp + reg);
}


static inline void putreg( int reg, uint16_t val )
{
	* (uint16_t *) (regp + reg) = val;
}


int main(int argc, char **argv, **envp)
{
	uint16_t *buf = getbuf( COUNT );
	
	regp = locate_regs();
	
	getem( regs, buf, COUNT);
	
	dumpem( buf, count );
	
	exit( 0 );
}
	
	
