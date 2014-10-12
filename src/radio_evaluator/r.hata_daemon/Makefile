
PGM = r.hata_daemon

include ../Makefile

#
# OpenCL compiler
#
CL_CC = clld

#
# Include and Libs for MPI
#
MPI_INC = $(shell mpicc --showme:compile)
MPI_LIB = $(shell mpicc --showme:link)

#
# Include and lib dirs for the StdCL library
#
ARCH_INC += $(MPI_INC) -I. -I${ATISTREAMSDKROOT}/include -I/usr/local/browndeer/include
ARCH_LIBPATH += -L/usr/local/browndeer/lib
LIBES += $(MPI_LIB) out_clld.o -lstdcl 

default: cl_kernel cmd

cl_kernel:
	$(CL_CC) --cl-source hata_kernel.cl


