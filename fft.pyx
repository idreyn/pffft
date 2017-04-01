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

jobs = 1
size = 10

test_np = np.zeros((2 ** size, jobs), dtype=complex)
test_gpu = np.zeros((2 ** size, jobs), dtype=complex)

print test_np
print test_gpu
print test_np is test_gpu

print "====="

for j in xrange(jobs):
    test_np[:,j] = np.sin(np.linspace(0, 100 * (j + 1), 2 ** size))
    test_gpu[:,j] = np.sin(np.linspace(0, 100 * (j + 1), 2 ** size))

print test_np
print test_gpu

print "====="

pffft_prepare(size, jobs) 

def do_thing(np.ndarray[complex, ndim=2] data, size, jobs):
    pffft_compute(&data[0,0], 0)

t0 = time.time()
test_np = np.fft.fft(test_np)
print "np fft in", time.time() - t0

t0 = time.time()
do_thing(test_gpu, size, jobs)
print "gpu fft in", time.time() - t0

print "====="

print test_np
print test_gpu

np.savetxt("test_np.csv", test_np)
np.savetxt("test_gpu.csv", test_gpu)

pffft_release()
