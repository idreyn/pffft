#include <complex.h>

#ifndef __PFFFT__
#define __PFFFT__

int pffft_prepare(int size, int jobs);
void pffft_compute(complex* data, int inverse);
int pffft_release(void);

#endif
