#cython: wraparound=False
#cython: boundscheck=False
#cython: cdivision=True

import numpy as np
cimport numpy as np
cimport cython

cdef extern from "fft_bindings.h":
    int prepare(int size, int jobs)
    void compute(np.complex_t** data, int inverse)
    int release()
