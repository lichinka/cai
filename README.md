FIXME: Find out why there is a value 0.05012531 comming out of transmitter 22


Installing GRASS and the prediction modules
===========================================
- Download GRASS source code from http://grass.fbk.eu/download/software.php#g64x
- Unpack the .tar.gz file in /usr/local/src (as root).
- For freshly installed machines, you will need PROJ4, GDAL, FFTW, Python 2.x and some GUI toolkit (WxWidgets, Tcl/Tk, ...) installed. The method on how to provide these dependencies differs among distributions. To indicate a different Python interpreter, be sure that a symlink exists to the correct one, e.g.:
    
    $> ls -lah /usr/bin/python
    lrwxrwxrwx 1 root root 16 Feb 11 11:00 /usr/bin/python -> /usr/bin/python2

... or change the PYTHON setting in include/Make/Platform.make and Platform.make.in, e.g.:
    
    PYTHON=python2

- Compile and install GRASS from the source code (as root). Binary installations (i.e. from a package manager) are not good! For example:

	$> ./configure --with-sqlite --enable-64bit --with-tcltk --with-python=/usr/bin/python2.7-config --prefix=/usr/local

- After `configure` has finished correctly, issue `make` and the `make install`. The resulting installation should now be located at /usr/local/grass-6.4xxx, including the binaries to fire the program at /usr/local/bin.
- If you are planning to do GRASS module development, change both directories ownerships (i.e. the source code tree and the installation one) to avoid module compilation as root. For example, if your everyday user is a member of the group 'users':

	$> sudo chown --recursive root:users /usr/local/grass-6.4xxx
	$> sudo chown --recursive root:users /usr/local/src/grass-6.4xxx
	$> sudo chmod --recursive g+w /usr/local/grass-6.4xxx
	$> sudo chmod --recursive g+w /usr/local/src/grass-6.4xxx

- Change into the RaPlaT directory of the module to be installed (e.g. moduli_xxxxxx/raster/...).
- Change the Makefile variable 'MODULE_TOPDIR' and point it to the directory where GRASS has been installed (e.g. /usr/local/grass-6.4xxx).
- Type 'make' to compile the current RaPlaT module.
- Type 'make install' to install the module into the GRASS directory pointed by MODULE_TOPDIR. Verify it by checking that /usr/local/grass-6.4xxx/bin contains an executable with the name of the installed RaPlaT module.
- Create a 'grassdata' directory where all GIS files will be saved.
- Create a location for Slovenija, keeping all data layers (e.g. DEM, clutter, ...) in the same resolution! Check it by running (from within GRASS):

	grass$> g.region -p | grep res
	nsres:      100
	ewres:      100

- Run the RaPlaT modules, comparing the results from those in the user's documentation. They should match to assure a correct compilation and installation, e.g.

    grass$> r.hata input=dem100i_mo@PERMANENT output=my_map coordinate=463094,102454 ant_height=8 radius=10 area_type=suburban frequency=2040 default_DEM_height=300 --overwrite --quiet

- Use r.mapcalc to calculate the difference between the serial implementation (e.g. r.hata) and the parallel one (e.g. r.hata_gpu). This calculalation is the basis for the GPU test case.


Preparing the OpenCL development environment
============================================
- Download and install the AMD OpenCL SDK from http://developer.amd.com/gpu/AMDAPPSDK/Pages/default.aspx
- Make sure it is working correctly by compiling and running 'CLInfo' (in 'samples/'). The program should find and print out information about the CPU(s) and GPU(s) present on the system.
- Download and install the lastest version of the COPRTHR SDK (http://www.browndeertechnology.com/coprthr.htm) or clone their Git repository:

    $> git clone https://github.com/browndeer/coprthr.git
    $> cd coprthr
    $> ./configure --with-amd-sdk=${place where you've just installed the AMD OpenCL SDK} --prefix=/usr/local
    $> make && make install && make test

- Ensure that /usr/local/bin is added to PATH, if it is not in the standard search path for executables. For example:

    $> export PATH=${PATH}:/usr/local/bin

- Also ensure that /usr/local/lib is added to LD_LIBRARY_PATH and /usr/local/man is added to MANPATH.
- When compiling programs that use libstdcl, include the following in your Makefile:

    INCS += -I/usr/local/include
    LIBS += -L/usr/local/lib -lstdcl

- Now that the environment is ready, implement a GPU optimized version based on OpenCL.


Implementing an OpenCL version of the Hata propagation model
============================================================
- The first version should enable the same use as the serial (i.e. original) one, but running on OpenCL.
- The second version should be able to calculate the path losses of many transmitters at once.
    * Keep in mind that radio propagations for one transmitter are calculated only within a given area, say 10 km radius.
    * Combining this fact with different work-group/work-items dimensions and shared memory may result in interesting speed ups. For example, think about keeping the data used by the calculation of one transmitter within shared memory. The use of delta values (i.e. not absolute ones) may shorten the data types needed to encode the problem instance, resulting in higher encoded data per byte ratio.
- Changing the local dimension of a work group (i.e. _HATA_WITEM_PER_DIM_) to 23 or more generates an error on the GTX 260. Using a CPU, the constant was risen up to 42 without any problems (after that number the local memory limit is hit). It follows that exists a relation between this constant value and the hardware itself. The limit is imposed by CL_DEVICE_MAX_WORK_GROUP_SIZE, which is 512 for the GTX 260.
- The third version of the radio evaluator should calculate the interference among the transmitters. Make sure to take these constants into account: thermal noise, urban thermal noise, anthenna gain. Find a scientific reference where these are correctly explained (WCDMA blue book?).
    * Remember that the path loss matrix is constant for a given transmitter. Take advantage of this fact by (maybe?) loading the calculated path loss matrices to texture memory.
    * It will be an interesting challenge to calculate the interference fast enough, because of the data memory layout.
- The fourth version should exploit the use of many GPUs at once.


Using data from the MOMENTUM project in the newly created evaluator
===================================================================
- Generate DEM, clutter and anthena data files for the Berlin scenario, based on the XML data files.
- Compare EcNo coverage maps from the MOMENTUM evaluator with those from the RaPlaT, then find out which prediction algorithm generates the most similar results to those of MOMENTUM.
- Write a test case, based on the difference of two pictures (PNGs), to compare the GPU and the RaPlaT (serial) version of the chosen prediction algorithm (or algorithms, if there are more).


Using the created evaluator as a daemon for evaluating the objective function
=============================================================================
- Install any implementation of MPI. Links to supported implementations are available here:

    http://www.boost.org/doc/libs/1_46_0/doc/html/mpi/getting_started.html#mpi.mpi_impl

- Compile the 'src/agent/test_mpi.c' program to be sure that the environment has been set up correctly:
    
    ...src/agent$> make -f Makefile.test

- Run the program and check that the output is as expected. For example, for OpenMPI:

    ...src/agent$> mpirun -np 2 ./test_mpi
    Master OK!
    1st agent OK!

- Write a very simple MPI server that is able to communicate the result of a summation to its clients (point-to-point).
    * Implemented in 'sum_example.c', it features a master process and 'n-1' agents, where 'n' is the number of started MPI processes.
    * A bad thing is that a call to blocking receive, 'MPI_Recv', uses 100% of one core. OpenMPI docs say this is normal.

- After loading DEM raster data, send the matrix dimensions to each newly connected client, so that they will know where to move.
- Implement an MPI agent that will move randomly inside the matrix and, at each step, ask for the terrain height at the current position (point-to-point).
- MPI requests are received from the independent agents and answered accordingly.


