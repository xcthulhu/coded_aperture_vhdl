#include <stdio.h>

#define BitA(n) (1<<(n))
#define BitB(n)	(1<<((n)+8))

#define	P1VI	(BitA(0))
#define P2VI	(BitA(1))
#define P1VS	(BitA(2))
#define P2VS	(BitA(3))
#define TG	(BitA(4))
#define P1H	(BitB(0))
#define P3H	(BitB(1))
#define P2A4BH	(BitB(2))
#define P4A2BH	(BitB(3))
#define P2C4DH	(BitB(4))
#define P4C2DH	(BitB(5))
#define SG	(BitB(6))
#define SPARE	(BitB(7))

#define high(x)	(state|=(x))
#define low(x)	(state&=~(x))

static int state;

void step()
{
	int bit;

	for( bit = 7; bit >= 0; bit -= 1 ) {
		int a = ((state & BitA( bit )) !=0 );
		int b = ((state & BitB( bit )) !=0 );
		int strobe = 1;
		
		printf("0 %d %d %d\n", a, b, strobe);
		if( bit == 0 ) strobe = 0;
		printf("1 %d %d %d\n", a, b, strobe);
	}
}

void pixel()
{
	step();
	high( P1H );
	high( P2A4BH );
	high( P4A2BH );
	low( P3H );
	low( P2C4DH );
	low( P4C2DH );
	low( SG);
	step();
	step();
	step();
	step();
	low( P1H );
	low( P2A4BH );
	low( P4A2BH );
	high( P3H );
	high( P2C4DH );
	high( P4C2DH );
	high( SG);
	step();
	step();
	step();
	step();
}

void pixel_maybe( int ft )
{
	int i;
	
	if( ft ) pixel();
	else for( i = 0; i < 9; i += 1 ) step();
}


void down( int ft )
{
	high(P1VI);
	high(P1VS);
	low(P2VI);
	low(P2VS);
	low(TG);
	pixel_maybe( ft );
	low(P1VI);
	low(P1VS);
	high(P2VI);
	high(P2VS);
	high(TG);
	pixel_maybe( ft );
}

void frame()
{
	int i;

	for( i = 0; i < 1280; i +=1 ) down(1);
	low( P2VI );
}

void row()
{
	int i;
	
	down(0);
	for( i = 0; i < 1280; i +=1 ) pixel();
}

void readout()
{
	int i;

	for( i = 0; i < 1280; i +=1 ) row();
}

int main()
{
	printf( "#SCLK SEQA SEQB STROBE\n" );
	frame();
//	readout();
	return 0;
}	
