#include <complex.h>

#ifndef __RPI_FAST_FFT__
#define __RPI_FAST_FFT__

int prepare(int size, int jobs);
void compute(double complex** data, int inverse);
int release(void);

#endif
