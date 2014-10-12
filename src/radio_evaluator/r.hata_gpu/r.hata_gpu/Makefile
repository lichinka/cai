
PGM = r.hata_gpu

include ../Makefile

#
# OpenCL compiler
#
CL_CC = clld

#
# Include and lib dirs for the StdCL library
#
ARCH_INC += -I${ATISTREAMSDKROOT}/include -I/usr/local/browndeer/include
ARCH_LIBPATH += -L/usr/local/browndeer/lib
LIBES += out_clld.o -lstdcl

default: cl_kernel cmd

cl_kernel:
	$(CL_CC) --cl-source hata_kernel.cl


