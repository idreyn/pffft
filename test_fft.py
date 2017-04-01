import time
import numpy as np

from pffft import *

jobs = 10
size_log2 = 10

data = np.ascontiguousarray(
    np.random.normal(size=(2 ** size_log2, jobs)).astype(complex)
)

tdp = np.sum(np.abs(data) ** 2)


data_copy = np.copy(data)

f = FFT(size_log2, jobs)

# print data

t0 = time.time()
f.run(data)
# print time.time() - t0

fdp =  np.sum(np.abs(data) ** 2)

print "TDP", tdp, "FDP", fdp, fdp / tdp


#t0 = time.time()
ref =  np.fft.fft(data_copy)
#print time.time() - t0

ref_fdp =  np.sum(np.abs(ref) ** 2)
print "REF_FDP", ref_fdp

print ref_fdp / tdp 


# print "and back"
# f.run(data, True)
# print data / 1024
# print np.max((data / 1024) - data_copy)

f.release()
