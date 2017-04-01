#cython: wraparound=False
#cython: boundscheck=False
#cython: cdivision=True

import time

import numpy as np
cimport numpy as np
cimport cython

cdef extern from "fft_bindings.h":
    int pffft_prepare(int size, int jobs)
    void pffft_compute(complex* data, int inverse)
    int pffft_release()

class FFT(object):
    def __init__(self, int size, int jobs):
        self.size = size
        self.jobs = jobs
        res = pffft_prepare(self.size, self.jobs)
        if res != 0:
            raise Exception("Unable to start FFT: %s" % res)

    def run(self, np.ndarray[dtype=complex, ndim=2] data, inverse=False):
        pffft_compute(&data[0,0], inverse)

    def release(self):
        pffft_release()

