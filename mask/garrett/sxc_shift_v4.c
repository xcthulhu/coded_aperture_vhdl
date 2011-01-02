#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include "sxc_shift_v4.h"

#define rand01() (lrand48() / 2147483648.0)

typedef  short int16 ;

/* read_int_array() reads an array of integers from a file, 
 * and returns the size.
 * ...Not as fast as possible, but it doesn't matter for 
 * small files */
int read_int_array(char * fn, int **iptr) {
  FILE * fp = fopen(fn, "r");
  int i, size = 0;
  while (! feof(fp)) { fscanf(fp, "%*d "); size++; }
  *iptr = malloc(sizeof(int)*size);
  freopen(fn,"r",fp);
  for (i=0; i<size; i++) { fscanf(fp, "%d", (*iptr) + i); }
  fclose(fp);
  return size;
}

/* int_array_range() calculates the range of an array, 
 * along with min and max values as side-effects */
int int_array_range(int *iptr, int size, 
                    int *min, int *max) {
  if (size <= 0) { *min = *max = 0; }
  else {
    int i;
    *min = *max = iptr[0];
    for (i = 0; i < size; i++) {
      if (iptr[i] > *max) { *max = iptr[i]; }
      if (iptr[i] < *min) { *min = iptr[i]; } } }
  return *max - *min + 1;
}

int main (int argc, char **argv)
{
    // Read in the event array and the mask
    int *events, *mask;
    int EVENT_SIZE = read_int_array("events.dat", &events);
    int MASK_SIZE = read_int_array("mask.dat", &mask);
    // Calculate the min, max, and range of events[]
    int MinEvtValue, MaxEvtValue;
    int DATA_SIZE = int_array_range(events, EVENT_SIZE, 
                               &MinEvtValue, &MaxEvtValue);

    int i, j, k, l, m, test1, test2 ;
    int min_image, max_image ;
    int min_image_idx, max_image_idx ;
    int ie,ev;
    int Nevent;
    int Nstart;
    int Noff;
    int Ndata;
    int SR[MASK_SIZE];

/* Get the appropriate values of "MASK_SIZE" and "mask" from mask.h" */

    int16   *data ;
    int16   image[MASK_SIZE] ;

/* 2.5 Nevent must be less than EVENT_SIZE */


#ifdef DBG_SXC
      printf ("\nsxc_mask program:  f= %s   l= %d\n",
	  __FILE__, __LINE__) ;
      fflush (stdout) ;
      printf ("   MASK_SIZE= %d   DATA_SIZE= %d\n",
	  MASK_SIZE, DATA_SIZE) ;
      fflush (stdout) ;
#endif

/* use a set of  500 events of real Sco X-1 data*/
    Nevent = 500;
    // Nstart = 5000;
    Nstart = 0;
    Noff   = 400;
    ie = 0;

#ifdef RESET_EVENTS
    for (i = Nstart; i <EVENT_SIZE; i++)
    {
      if ( (events[i] >= Noff) && (events[i]<=(1023+Noff)) ) events[ie++]=events[i]-Noff;
      if (ie==Nevent) break;
    }
#else
    ie = EVENT_SIZE ;
#endif

#define DBG_SXC_OUTPUT_EVENTS
#ifdef DBG_SXC_OUTPUT_EVENTS
      printf ("\n   Final Events:  l= %d   ie= %d\n", __LINE__, ie) ;
      fflush (stdout) ;
      for (i = 0; i < ie; i++)
          {
	  printf ("      events[%d]= %d\n", i, events[i]) ;
          fflush (stdout) ;
	  }
#endif

/* Scan for the minimum and maximum values of "events".  This will
 * determine the size of "data".
 */

    data = (int16 *) malloc ((size_t) (DATA_SIZE * sizeof(int16))) ;
    Ndata  = DATA_SIZE;

#ifdef DBG_SXC_OUTPUT_EVENTS
      printf ("\n   MinEvtValue= %d   MaxEvtValue= %d\n",
          MinEvtValue, MaxEvtValue) ;
      fflush (stdout) ;
      printf ("\n   DATA_SIZE= %d\n", DATA_SIZE) ;
      fflush (stdout) ;
#endif

#ifdef Test
/* this entire section replaces the real Sco X-1 data with Test data */

/* The following is just a dummy test source at center of field: */
    test1 = (MASK_SIZE - DATA_SIZE )/ 2 ;
/* add a second test source 117 bins away from the central source */
    test2 = test1 + 117 ;

/* Build two test sources and background with correct Poisson noise */
    
/* zero the events array */
    ie = 0;
    for (i = 0; i <EVENT_SIZE; i++)
    {
      events[i] = 0;
    }

/* main loop to create the simulated events */
    for (i = 0; i <2*Nevent; i++)
    {
/* build events for source 1 at location 117 */
       if (rand01()<0.5)
       {
        do {
          ev = (int)( rand01()*(double)Ndata );
        } while (mask[ev + test1] == 0);
        events[ie++] = ev;
       }

/* second source is 1/2 as bright */
       if (rand01()<0.25)
       {
          do {
             ev = (int)( rand01()*(double)Ndata );
          } while (mask[test2 + ev] == 0); 
          events[ie++] = ev;
       }

/* background is equal to source 1 */
       if (rand01()<0.5)
       {
         ev = (int)( rand01()*(double)Ndata );
         events[ie++] = ev;
       }

/* check for outflow of events arrays */
       if (ie>=EVENT_SIZE) 
       {
          printf("ie has exceeded %d/n", (int) EVENT_SIZE);
          fflush(stdout);
          exit(30);
       }
    }  /* this ends the Nevent loop */
#endif

#ifdef DBG_SXC1
      printf ("\n   l= %d   ie = %d\n",
	  __LINE__, ie) ;
      fflush (stdout) ;
#endif

/* output events array */
    for (i = 0; i <ie ; i++)
    {
        printf("event %d %d\n",i,events[i]);
        fflush(stdout);
    }

/* compute histogram of data */
    for (i = 0; i < DATA_SIZE; i++)
    {
        data[i] = 0;
    }

/* the last of ie is the number of events -1 */
    ie = 500 ;
    for (i = 0; i < ie; i++)
    {
        if ( (events[i]<MinEvtValue)||(events[i]>MaxEvtValue) )
        {
           printf("debug: illegal location in histogram %d\n",events[i]);
           fflush(stdout);
	   continue ;
           exit(31);
        }
        data[events[i] - MinEvtValue] += 1;
    }


/* output data histogram for plotting only */
/* data histogram is longer used to compute image */
    for (i = 0; i < DATA_SIZE; i++)
    {
        printf("data %d %d\n",i,data[i]);
        fflush(stdout);
    }

/* Note:   MASK_SIZE must be >= DATA_SIZE in reality: */


#ifdef DBG_SXC
      printf ("\n   l= %d   before MASK_SIZE (%d) loop:\n",
	  __LINE__, MASK_SIZE) ;
      fflush (stdout) ;
#endif

/* this is the main computation loop */

/* zero the image */
    for (k = 0; k < MASK_SIZE - DATA_SIZE; k++)
    {
      image[k] = 0 ;
    }


    for (k = 0; k < ie; k++)
    {
#ifdef DBG_SXC
      printf ("\n   l= %d   k= %d\n", __LINE__, k) ;
      fflush (stdout) ;
#endif

      /*
      ev = events[k] ;
      */
      ev = events[k] - MinEvtValue ;

/* The next j loop should be parallel in FPGA hardware */
/* The next double shifts right ev steps */

/* initialize SR in one clk step */
      for(l=0; l<MASK_SIZE; l++)
      {
        SR[l] = mask[l];
      }
/* shift SR by ev steps in ev clock steps - this may be slow in hardware - speed up ?*/
      for(l=0; l<ev; l++)
      {
        /* start simulated shift left by 1 */
        for(m=0; m<MASK_SIZE-1; m++)
        {
          SR[m] = SR[m+1];        
        }
      }
      SR[MASK_SIZE-1] = 0;
      /* end simulated shift right by 1 */

/* inner most loop that would occur in one clock step in hardware */
      for (j = 0; j < MASK_SIZE - DATA_SIZE; j++)
      {
           if (SR[j] == 1)
	   {
	     /* If "mask[ev]" is "1", then it's open (+4), */
             image[j] += 4;
           } else {
	     // If "mask[ev]" is "0", then it's closed (-1)
             image[j] -= 1;
           }
      }  
/* end:  for (j = 0; j < MASK_SIZE - DATA_SIZE; j++) *
 * end of section to be implemented in FPGA hardware */


      }  /* end:  for (k = 0; k < ie; k++) */

   /* Print out "image".  There should be a peak at
    * "test_source_location"/
    */
    min_image_idx = -1 ;
    max_image_idx = -1 ;
    for (k = 0; k< MASK_SIZE - DATA_SIZE; k++)
      {
      printf ("image %d %d\n", k, image[k]) ;
      fflush(stdout) ;
      if (min_image_idx < 0)
          {
	  min_image_idx = k ;
	  min_image = image[k] ;
	  }
      else
          {
	  if (image[k] < min_image)
	      {
	      min_image_idx = k ;
	      min_image = image[k] ;
	      }
	  }

      if (max_image_idx < 0)
          {
	  max_image_idx = k ;
	  max_image = image[k] ;
	  }
      else
          {
	  if (image[k] > max_image)
	      {
	      max_image_idx = k ;
	      max_image = image[k] ;
	      }
	  }
      }

    printf ("\nimage minimum:  index= %d   value= %d\n",
        min_image_idx, min_image) ;
    fflush(stdout) ;
    printf ("image maximum:  index= %d   value= %d\n",
        max_image_idx, max_image) ;
    fflush(stdout) ;

    return (0) ;
}
