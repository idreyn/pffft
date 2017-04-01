#include <complex.h>
#include <stdio.h>
#include <unistd.h>

#include "mailbox.h"
#include "gpu_fft.h"

static struct GPU_FFT *fft;
static int fft_size;
static int fft_jobs;
static int mailbox = 0;


int pffft_prepare(int size, int jobs) {
    fft_size = size;
    fft_jobs = jobs;
    if (mailbox == 0) {
        mailbox = mbox_open();
    }
    return gpu_fft_prepare(mailbox, size, GPU_FFT_REV, jobs, &fft);
}

void pffft_compute(complex* data, int inverse) {
    struct GPU_FFT_COMPLEX *base;
    int length = 1 << fft_size; // In other words, 2 ** fft_size
    int i, j;
    int inverse_factor = inverse? -1 : 1;
   
    for(j=0; j<fft_jobs; ++j) {
        base = fft->in + j * fft->step;
        for (i=0; i<length; ++i) {
            base[i].re =  creal(data[i]);
            base[i].im = cimag(data[i]) * inverse_factor;
        }
    }

    gpu_fft_execute(fft);

    for(j=0; j<fft_jobs; ++j) {
        base = fft->in + j * fft->step;
        for (i=0; i<length; ++i) {
            data[i] = base[i].re + I * base[i].im * inverse_factor;
        }
    }
}

int pffft_release(void) {
    gpu_fft_release(fft);
    if (mailbox > 0) {
        mbox_close(mailbox);
        mailbox = 0;
    }
    return 0;
}

