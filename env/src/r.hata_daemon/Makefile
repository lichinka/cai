#
# GRASS installation directory
#
MODULE_TOPDIR = /usr/local/grass-6.4.1RC1

PGM = r.hata_daemon

MOD_OBJS = $(subst .c,.o,$(wildcard *.c)) $(subst .cpp,.o,$(wildcard *.cpp))

include $(MODULE_TOPDIR)/include/Make/Module.make

#
# Path to where the OpenCL kernel file will be installed,
# including its dependencies
#
OCL_KRN_INSTALL_DIR = $(MODULE_TOPDIR)/bin
OCL_KRN_DEP = prot.h random.cl

#
# Link the OpenCL library with the final executable
#
LIBES = $(GISLIB) -lOpenCL -lstdc++
DEPENDENCIES = $(GISDEP)

#
# Use a different compiler and flags 
# for C++ source files
#
ifeq ($(CXX),)
CXX = g++
endif
CXXFLAGS = -g -O0 -Wall -Wno-missing-braces -fbounds-check -D_OCL_KERNEL_INCLUDE_DIR_=\""$(OCL_KRN_INSTALL_DIR)"\"

#
# Include and Libs for MPI
#
MPI_INC = $(shell mpicc --showme:compile)
MPI_LIB = $(shell mpicc --showme:link)

#
# Include and libs for our OpenCL C++ library
#
OCL_CPP_INC = -I../ocl_cpp
OCL_CPP_LIB = -lstdc++


ARCH_INC += $(MPI_INC) $(OCL_CPP_INC) -I${ATISTREAMSDKROOT}/include -I.
ARCH_LIBPATH += -L${ATISTREAMSDKROOT}/lib
LIBES += $(MPI_LIB) $(OCL_CPP_LIB) -lOpenCL

default: test_cl_kernel install_cl_kernel cmd 

test_cl_kernel:
	cp $(OCL_KRN_DEP) /tmp
	openclcc $(PGM).cl

install_cl_kernel:
	cp $(OCL_KRN_DEP) $(OCL_KRN_INSTALL_DIR)
	cp $(PGM).cl $(OCL_KRN_INSTALL_DIR)

