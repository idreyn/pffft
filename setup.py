import os
from Cython.Distutils import build_ext
from distutils.core import setup
from distutils.extension import Extension

gpu_fft_src_path = '/opt/vc/src/hello_pi/hello_fft/'
gpu_fft_src_files = ('gpu_fft_base.c', 'gpu_fft.c', 'gpu_fft_shaders.c',
        'gpu_fft_twiddles.c', 'gpu_fft_trans.c', 'mailbox.c')

sources = ['fft.pyx', 'fft_bindings.c']
sources.extend([gpu_fft_src_path + p for p in gpu_fft_src_files])

setup(
    name="pffft",
    version="0.0.1",
    install_requires=['cython>=0.19.1', 'numpy'],
    cmdclass={'build_ext': build_ext},
    ext_modules=[
        Extension(
            "pffft",
            sources=sources,
            extra_compile_args=['-I' + gpu_fft_src_path],
            extra_link_args=['-lrt', '-lm']
        )
    ]
)

