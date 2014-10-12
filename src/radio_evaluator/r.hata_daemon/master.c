
/****************************************************************************
 *
 * MODULE:       r.hata_daemon
 * AUTHOR(S):    Andrej Vilhar, Jozef Stefan Institute                
 *
 * PURPOSE:      Calculates radio coverage from many base stations according
 *               to Hata's model. This module works as a daemon, waiting for
 *               remote agents to send queries about the coverage of specific
 *               areas. Remote communications are implemented using MPI.
 *             
 *
 * COPYRIGHT:    (C) 2009 Jozef Stefan Institute
 *
 * OpenCL and MPI code contribution by Lucas Benedičič (lucas.benedicic@mobitel.si)
 *
 *****************************************************************************/


#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>
#include <mpi.h>
#include <stdcl.h>
#include <grass/gis.h>
#include <grass/glocale.h>
#include "prot.h"
#include "ag_structs.h"




extern CONTEXT * init_context ( );

extern FCELL* load_raster (CONTEXT *ctx,
                           const int nrows, const int ncols,
                           const int infd,
                           RASTER_MAP_TYPE rtype);

extern void save_raster_to_file (const char *name,
                                 FCELL *rastdata,
                                 const int col_offset, const int row_offset,
                                 const int width, const int height,
                                 const int ncols, const int nrows);

extern int hata_path_loss_cl (CONTEXT *ctx,
                              const int raster_res,
                              const int nrows, const int ncols,
                              cl_int2 *test_tx, const int ntest_tx,
                              const int tx_anthena_height,
                              const float rx_height, const float frequency,
                              const int radius,
                              const int infd, const char *outname,
                              RASTER_MAP_TYPE rtype);

extern void hata_interference_cl (CONTEXT *ctx,
                                  const int raster_res,
                                  const int nrows, const int ncols,
                                  cl_int2 *test_tx, const int ntest_tx,
                                  const int tx_anthena_height,
                                  const float rx_height, const float frequency,
                                  const int radius,
                                  const int infd, const int outfd,
                                  RASTER_MAP_TYPE rtype);

extern struct_cov_info initial_coverage_cl (CONTEXT *ctx,
                                   int *pilots,
                                   struct_path_loss pl,
                                   float *interference,
                                   const int nrows, const int ncols,
                                   const int ntx);

extern struct_cov_info coverage_cl (CONTEXT *ctx,
                                    struct_cov_info cov_info,
                                    int *pilots,
                                    const int nrows, const int ncols,
                                    const int ntx);


/**
 * Returns the size of the area matrix from GRASS.
 *
 * int *mdim ........ output parameter (colMin, rowMin, colMax, rowMax)
 */
void get_matrix_dimension (int *mdim)
{
    mdim[0] = 0;
    mdim[1] = 0;
    mdim[2] = G_window_cols ( );
    mdim[3] = G_window_rows ( );
}



/**
 * Loads 'nfile' path loss matrices with name 'raster_name'_i.
 * It allocates memory for all of them (within the current context)
 * and it returns a struct containing two pointers:
 *      - the first one, of type char*, points to the 3D matrix created,
 *        with size (cols, rows, tx), containing dB value from 0 to 255.
 *        It contains 'nelements*nfile' elements of type char.
 *      - the second one, of type cl_int4*, points to a vector containing
 *        the offsets and matrix sizes for each of the transmitters.
 *        It contains 'nfile' elements of type cl_int4 (col_offset, 
 *        row_offset, width, height).
 *
 * CONTEXT *ctx .................. active OpenCL context.
 * char *raster_name ............. base name of all rasters to be loaded.
 * int nfile ..................... number of raster files (i.e. path loss
 *                                 matrices).
 * int nelements ................. number of elements in each path-loss 
 *                                 matrix.
 * RASTER_MAP_TYPE rtype ......... raster element type.
 */
struct_path_loss load_pl_matrices (CONTEXT *ctx, 
                                   char *raster_name, 
                                   const int nfile,
                                   const int nelements,
                                   RASTER_MAP_TYPE rtype)
{
    int mdim[4], col, row, i, j, k, infd;
    int width = (int) sqrt (nelements);
    int height = width;
    struct_path_loss ret_value;

    if (rtype != FCELL_TYPE && G_raster_size(rtype) != sizeof(float))
    {
        G_fatal_error ("Wrong element type in 'load_pl_matrix'");
        ret_value.data = NULL;
        ret_value.offsets = NULL;
        return ret_value;
    }

    char *file_name = (char *) malloc (100 * sizeof(char));

    // area dimensions
    get_matrix_dimension (mdim);
    int ncols = mdim[2] - mdim[0];
    int nrows = mdim[3] - mdim[1];

    unsigned char *pl_data = (unsigned char *) clmalloc (ctx, 
                                                nelements*nfile*sizeof(char),
                                                0);
    cl_int4 *pl_offsets = (cl_int4 *) clmalloc (ctx,
                                                nfile*sizeof(cl_int4),
                                                0);
    FCELL *loadbuf = (FCELL *) malloc (ncols * G_raster_size (rtype));

    // for each path-loss matrix
    for (i=0; i<nfile; i++)
    {
        sprintf (file_name, "%s_%d", raster_name, i);
        if ((infd = G_open_cell_old (file_name, G_mapset ( ))) < 0)
            G_fatal_error ("Unable to open raster map <%s>", file_name);
        G_message ("Loading path loss matrix from <%s> ...", file_name);

        int min_col_offset = ncols, max_col_offset = -1;
        int min_row_offset = nrows, max_row_offset = -1;

        // find the extend of the path loss data in this file
        for (row = 0; row < nrows; row++)
        {    
            if (G_get_raster_row (infd, loadbuf, row, rtype) < 0)
                G_fatal_error ("Unable to read from raster map");
    
            for (col = 0; col < ncols; col ++)
            {
                if (! (G_is_f_null_value (loadbuf+col)))
                {
                    // update the data offsets
                    min_col_offset = (min_col_offset>col) ? col : min_col_offset;
                    max_col_offset = (max_col_offset<col) ? col : max_col_offset;
                    min_row_offset = (min_row_offset>row) ? row : min_row_offset;
                    max_row_offset = (max_row_offset<row) ? row : max_row_offset;
                }
            }
        }

        // load raster in memory row by row 
        row = min_row_offset;
        for (j = 0; j < height; j++)
        {    
            // display completion percentage 
            G_percent (j, height, 2);

            if (G_get_raster_row (infd, loadbuf, row, rtype) < 0)
                G_fatal_error ("Unable to read from raster map");

            // start copying data
            col = min_col_offset;
            for (k = 0; k < width; k++)
            {
                pl_data[width*height*i + (j*width+k)] = (unsigned char) roundf(loadbuf[col]);
                col ++;
            }
            row ++;
        }
        // save the offsets for this transmitter
        pl_offsets[i] = (cl_int4) {min_col_offset,
                                   min_row_offset,
                                   max_col_offset - min_col_offset + 1,
                                   max_row_offset - min_row_offset + 1};
    }

    /* free allocated resources */
    free (loadbuf);
    free (file_name);

    /* save the resulting pointers */
    ret_value.data = pl_data;
    ret_value.offsets = pl_offsets;

    return ret_value;
}


/**
 * Calculates the attenuation-based pilot powers as in Siomina et al. (2008)
 */
void calculate_attenuation_pilots (struct_path_loss pl,
                                   int *pilots,
                                   float *interference,
                                   const int ntx)
{
    int i, x, y, mdim[4], idx_2d, idx_3d;

    get_matrix_dimension (mdim);
    int ncols = mdim[2] - mdim[0];
    int nrows = mdim[3] - mdim[1];

    for (x = 0; x < ncols; x++)
    {
        for (y = 0; y < nrows; y++)
        {
            idx_2d = y * ncols + x;
            float max_lin_pl[2] = {-1.0f, _HATA_MIN_PATH_LOSS_};

            // for each transmitter
            for (i=0; i<ntx; i++)
            {
                // coordinates must be within the area of this tx
                float pl_value = _HATA_MAX_PATH_LOSS_;
                int tx_min_col = pl.offsets[i].x;
                int tx_min_row = pl.offsets[i].y;
                int tx_max_col = tx_min_col + pl.offsets[i].z;
                int tx_max_row = tx_min_row + pl.offsets[i].w;

                if ((x>=tx_min_col) && (x<=tx_max_col))
                {
                    if ((y>=tx_min_row) && (y<=tx_max_row))
                    {
                        idx_3d  = pl.offsets[i].z * pl.offsets[i].w * i;
                        idx_3d += (y - tx_min_row) * pl.offsets[i].w;
                        idx_3d += x - tx_min_col;
                        pl_value = (float) pl.data[idx_3d];

                        // transform the path loss to a linear scale
                        if (pl_value > _HATA_MAX_PATH_LOSS_)
                            pl_value = _HATA_MAX_PATH_LOSS_;
                        
                        pl_value = 1.0f - (pl_value /
                                          (_HATA_MAX_PATH_LOSS_ - _HATA_MIN_PATH_LOSS_));
                       
                        // keep the maximum linear path-loss only
                        if (max_lin_pl[1] < pl_value)
                        {
                            max_lin_pl[0] = (float) i;
                            max_lin_pl[1] = pl_value;
                        }
                    }
                }
            }
            // calculate the pilot power needed to cover this coordinate
            if (max_lin_pl[0] != -1.0f)
            {
                float pilot_pwr = (_AG_MINIMUM_GAMMA_COVERAGE_ * interference[idx_2d]) /
                                  max_lin_pl[1];

                // display the value found
                G_message ("%d|%d|%10.6f|%d|%10.6f", x, y, 
                                                     max_lin_pl[1],
                                                     (int)max_lin_pl[0],
                                                     pilot_pwr);
            }
        }
    }
}





/**
 * Loads the interference matrix 'raster_name'. 
 * It allocates memory for it (within the current context),
 * and returns a pointer to the 2D matrix created (cols, rows).
 *
 * CONTEXT *ctx .................. active OpenCL context.
 * char *raster_name ............. name of the raster containing the matrix.
 * RASTER_MAP_TYPE rtype ......... raster element type.
 */
float* load_interference (CONTEXT *ctx,
                          char *raster_name, 
                          RASTER_MAP_TYPE rtype)
{
    int mdim[4], row, infd;

    G_message ("Loading interference matrix from raster <%s> ...", raster_name);

    if (rtype != FCELL_TYPE && G_raster_size(rtype) != sizeof(float))
    {
        G_fatal_error ("Wrong element type in 'load_interference'");
        return NULL;
    }

    // area dimensions 
    get_matrix_dimension (mdim);
    int ncols = mdim[2] - mdim[0];
    int nrows = mdim[3] - mdim[1];

    // try to open the raster file
    if ((infd = G_open_cell_old (raster_name, G_mapset ( ))) < 0)
        G_fatal_error ("Unable to open raster map <%s>", raster_name);

    // resulting matrix
    return (float*) load_raster (ctx, nrows, ncols, infd, rtype);
}



/**
 * Allocates a vector containing initial pilot powers for all 
 * transmitters with randomly-generated pilots powers in milliwatts.
 *
 * CONTEXT *ctx ............... active OpenCL context.
 * int ntx .................... number of transmitters in the area.
 */
int* init_random_pilots (CONTEXT *ctx, 
                         const int ntx) 
{
    int i;
    G_message ("Setting initial pilot powers to a random configuration ...");

    // resulting vector
    int *ret_value = clmalloc (ctx,
                               ntx * sizeof(int),
                               0);
    // random seed
    struct timeval detail_time;
    gettimeofday (&detail_time, NULL);
    srandom ((unsigned int) detail_time.tv_usec / 1000); /* milliseconds */

    // for each transmitter
    for (i = 0; i < ntx; i++)
    {    
        G_percent (i, ntx, 2);
        ret_value[i] = random( ) % (_AG_MAX_PILOT_POWER_MW_ / 2);
    }

    return ret_value;
}




/**
 * Allocates a vector containing initial pilot powers for all 
 * transmitters to the constant given in milliwatts.
 *
 * CONTEXT *ctx ............... active OpenCL context.
 * int ntx .................... number of transmitters in the area.
 * unsig short init_pwr ....... initial pilot power in milliwats.
 */
int* init_pilots (CONTEXT *ctx, 
                  const int ntx, 
                  const unsigned short init_pwr)
{
    int i;

    G_message ("Setting initial pilot powers to %d mW ...", init_pwr);

    // resulting vector
    int *ret_value = clmalloc (ctx,
                               ntx * sizeof(int),
                               0);
    // for each transmitter
    for (i = 0; i < ntx; i++)
    {    
        G_percent (i, ntx, 2);
        ret_value[i] = init_pwr;
    }

    return ret_value;
}




/**
 * Initializes matrix dimensions within which the agents may move.
 *
 * int *mdim ................. output is saved here (min_x, min_y, 
 *                             max_x, max_y).
 * struct_path_loss pl ....... contains data and meta-data about path loss
 *                             values for all the transmitters on every
 *                             coordinate in the area.
 * int ntx ................... total number of transmitters in the area.
 */
void init_agent_area (int *mdim,
                      struct_path_loss pl,
                      const int ntx)
{
    int i;

    // initialize the dimensions to those of the whole area
    get_matrix_dimension (mdim);
    i = mdim[0]; mdim[0] = mdim[2]; mdim[2] = i;
    i = mdim[1]; mdim[1] = mdim[3]; mdim[3] = i;

    // the agents should move inside the extent where
    // path-loss data is available.
    for (i=0; i<ntx; i++)
    {
        // minimum column
        if (mdim[0] > pl.offsets[i].x)
            mdim[0] = pl.offsets[i].x;
        // minimum row
        if (mdim[1] > pl.offsets[i].y)
            mdim[1] = pl.offsets[i].y;
        // maximum column
        if (mdim[2] < (pl.offsets[i].x + pl.offsets[i].z))
            mdim[2] = (pl.offsets[i].x + pl.offsets[i].z);
        // maximum row
        if (mdim[3] < (pl.offsets[i].y + pl.offsets[i].w))
            mdim[3] = (pl.offsets[i].y + pl.offsets[i].w);
    }
}



/**
 * Logs the agent in and sends back information about matrix
 * dimensions and total number of active transmitters in the area.
 *
 * int aid ................... agent's id (i.e. the MPI rank number)
 * struct_path_loss pl ....... contains data and meta-data about path loss
 *                             values for all the transmitters on every
 *                             coordinate in the area.
 * int ntx ................... total number of transmitters in the area.
 */
void agent_login (const int aid,
                  struct_path_loss pl,
                  const int ntx)
{
    int buff[5], i;

    printf ("%d. agent just logged in\n", aid);
    
    // the agents should move inside the extent where
    // path-loss data is available.
    init_agent_area (buff, pl, ntx);

    // number of transmitters in the area
    buff[4] = ntx;
    
    int result = MPI_Send (buff, 5, MPI_INT, aid, 
                           _AG_REPLY_TAG_, MPI_COMM_WORLD);
    if (result != MPI_SUCCESS)
        fprintf (stderr, "Error while sending login info to %d. agent\n", aid);
}




/**
 * Returns the signals available at the given coordinate.
 * The signal power is calculated according to (1) in Benedičič et al (2010).
 *
 * int *coord ............. area coordinate where the signal is being 
 *                          queried.
 * struct_path_loss pl .... contains data and meta-data about path loss
 *                          values for all the transmitters on every
 *                          coordinate in the area.
 * float *interference .... 2D matrix containing the total interference
 *                          in the area.
 * int *pilots ............ vector containing the pilot power of each
 *                          transmitter in milliwatts.
 * int ntx ................ total number of transmitters in the area.
 * float *fbuf ............ output parameter, where the signals are saved.
 */
void get_signals_at (int *coord,
                     struct_path_loss pl,
                     float *interference,
                     int *pilots,
                     const int ntx,
                     float *fbuf)
{
    int i, mdim[4], idx_2d, idx_3d;

    get_matrix_dimension (mdim);
    int ncols = mdim[2] - mdim[0];
    int nrows = mdim[3] - mdim[1];

    idx_2d = coord[1] * ncols + coord[0];

    // for each transmitter
    for (i=0; i<ntx; i++)
    {
        // coordinates must be within the area of this tx
        float pl_value = _HATA_MAX_PATH_LOSS_;
        int tx_min_col = pl.offsets[i].x;
        int tx_min_row = pl.offsets[i].y;
        int tx_max_col = tx_min_col + pl.offsets[i].z;
        int tx_max_row = tx_min_row + pl.offsets[i].w;

        if ((coord[0]>=tx_min_col) && (coord[0]<=tx_max_col))
        {
            if ((coord[1]>=tx_min_row) && (coord[1]<=tx_max_row))
            {
                idx_3d  = pl.offsets[i].z * pl.offsets[i].w * i;
                idx_3d += (coord[1] - tx_min_row) * pl.offsets[i].w;
                idx_3d += coord[0] - tx_min_col;
                pl_value = (float) pl.data[idx_3d];
            }
        }
        // transform the path loss to a linear scale
        if (pl_value > _HATA_MAX_PATH_LOSS_)
            pl_value = _HATA_MAX_PATH_LOSS_;
        
        pl_value = (float) 1.0f - (pl_value /
                   (_HATA_MAX_PATH_LOSS_ - _HATA_MIN_PATH_LOSS_));

        // calculate gamma at this coordinate for this transmitter
        fbuf[i] = ((pilots[i]/1000.0f) * pl_value) / interference[idx_2d];
    }
}




/**
 * Sets the pilot power of a specific transmitter to
 * a new value in milliWatts.
 *
 * int *ibuf .............. received data from the agent.
 * int *pilots ............ vector containing the pilot power of each
 *                          transmitter in milliwatts.
 * int ntx ................ total number of transmitters in the area.
 */
void set_pilot_power (int *ibuf,
                      int *pilots,
                      const int ntx)
{
    int tx_id = ibuf[0];
    int tx_pwr = ibuf[1];

    if (tx_id > ntx)
    {
        fprintf (stderr, "Invalid transmitter id (%d) when setting pilot power\n", tx_id);
    }
    else
    {
        pilots[tx_id] = tx_pwr;
    }
}



/**
 * The the uncovered coordinates to the specific agent.
 *
 * int aid .................... agent's id (i.e. the MPI rank number)
 * short *uncovered_coord ..... points to the vector containing the
 *                              coordinates of the uncovered raster cells.
 * int uncovered_coord_length . the number of coordinates in the vector 
 *                              'uncovered_coord'.
 */
void get_uncovered_coordinates (const int aid,
                                unsigned short *uncovered_coord,
                                const int uncovered_coord_length)
{
    // randomly select one uncovered coordinate from the vector
    int i, rnd_idx, rnd_coord[2];

    for (i = 0; i < 1000; i++) 
    {    
        rnd_idx = random( ) % uncovered_coord_length - 1; 
        rnd_coord[0] = uncovered_coord[2*rnd_idx];
        rnd_coord[1] = uncovered_coord[2*rnd_idx + 1];

        if (rnd_coord[0] != 0)
            break;
    }    
   
    MPI_Send (rnd_coord, 2,
              MPI_INT, aid, 
              _AG_REPLY_TAG_,
              MPI_COMM_WORLD);
}



/**
 * Executes the agents kernel for optimization, returning a the
 * agent's kernel structure used for further calls.
 *
 * CONTEXT *ctx ................ OpenCL context.
 * struct_agent_kernel agt_krn . contains data needed to re-execute the
 *                               agent kernel with minimum overhead.
 * cl_int4 mdim ................ area within which the agents may move.
 * int *pilots ................. vector containing the pilot power of each
 *                               transmitter in milliwatts.  
 * struct_path_loss pl ......... contains data and meta-data about path loss
 *                               values for all the transmitters on every
 *                               coordinate in the area
 * float *interference ......... 2D matrix containing interference value for
 *                               every coordinate in the area.
 * struct_cov_info cov_info .... contains all the needed information to
 *                               re-execute the coverage kernel with 
 *                               minimum overhead.
 * int ncols ................... total number of columns in the area.
 * int ntx ..................... total number of transmitters in the area.
 */
struct_agent_kernel optimize_cl (CONTEXT *ctx,
                                 struct_agent_kernel agt_krn,
                                 cl_int4 mdim,
                                 int *pilots,
                                 struct_path_loss pl,
                                 float *interference,
                                 struct_cov_info cov_info,
                                 const int ncols,
                                 const int ntx)
{
    int *tx_pwr = pilots;

    // initialize the random seed
    unsigned long random_seed = random( );

    // do we have to initialize the structure?
    if (agt_krn.kernel == NULL)
    {
        G_message ("Launching first agent kernel ...");

        agt_krn.handler = clopen (ctx, NULL, CLLD_NOW);
        // select the correct kernel
        agt_krn.kernel = clsym (ctx, agt_krn.handler, "agent_kern", CLLD_NOW);
        // threads are arranged in a 1D grid
        clndrange_t ndr = clndrange_init1d (0,_AG_AGENT_NUMBER_,_AG_AGENT_NUMBER_);
        agt_krn.kernel_range = ndr; 

        // references to kernel parameters
        unsigned char *pl_in = pl.data;
        cl_int4 *offsets_in = pl.offsets;
        float *qrm_in = interference;
        float *cov_in = cov_info.coverage;
        unsigned short *uncov_coord_in = cov_info.uncovered_coord;
       
        // transfer data to the device only the first time
        clmsync (ctx, 0, pl_in, CL_MEM_DEVICE|CL_EVENT_NOWAIT);
        clmsync (ctx, 0, offsets_in, CL_MEM_DEVICE|CL_EVENT_NOWAIT);
        clmsync (ctx, 0, qrm_in, CL_MEM_DEVICE|CL_EVENT_NOWAIT);
        clmsync (ctx, 0, cov_in, CL_MEM_DEVICE|CL_EVENT_NOWAIT);
        clmsync (ctx, 0, uncov_coord_in, CL_MEM_DEVICE|CL_EVENT_NOWAIT);
        clmsync (ctx, 0, tx_pwr, CL_MEM_DEVICE|CL_EVENT_WAIT);

        // set kernel parameters
        clarg_set (ctx, agt_krn.kernel, 0, ntx);
        clarg_set (ctx, agt_krn.kernel, 1, ncols);
        clarg_set (ctx, agt_krn.kernel, 2, mdim);
        clarg_set (ctx, agt_krn.kernel, 3, cov_info.uncovered_count);
        clarg_set (ctx, agt_krn.kernel, 4, cov_info.uncovered_coord_length);
        clarg_set (ctx, agt_krn.kernel, 5, random_seed);
        clarg_set_global (ctx, agt_krn.kernel, 6, pl_in);
        clarg_set_global (ctx, agt_krn.kernel, 7, offsets_in);
        clarg_set_global (ctx, agt_krn.kernel, 8, qrm_in);
        clarg_set_global (ctx, agt_krn.kernel, 9, cov_in);
        clarg_set_global (ctx, agt_krn.kernel, 10, uncov_coord_in);
        clarg_set_global (ctx, agt_krn.kernel, 11, tx_pwr);

        // shared memory allocation
        size_t lmem_size = _AG_AGENT_NUMBER_ * 2 * sizeof(short);
        if (lmem_size > _HATA_GPU_MAX_LOCAL_MEM_)
            G_fatal_error ("Allocated local memory (%d) exceeds %d bytes.", lmem_size,
                                                                            _HATA_GPU_MAX_LOCAL_MEM_);
        clarg_set_local (ctx, agt_krn.kernel, 12, lmem_size);
    }
    else
    {
        G_message ("Optimizing ...");

        // set only updated parameters from the last execution
        clarg_set (ctx, agt_krn.kernel, 3, cov_info.uncovered_count);
        clarg_set (ctx, agt_krn.kernel, 4, cov_info.uncovered_coord_length);
        clarg_set (ctx, agt_krn.kernel, 5, random_seed);
    }

    // start kernel execution 
    clfork (ctx, 0, agt_krn.kernel, &agt_krn.kernel_range, CL_EVENT_WAIT);
    clwait (ctx, 0, CL_KERNEL_EVENT|CL_MEM_EVENT|CL_EVENT_RELEASE);

    // sync memory
    clmsync (ctx, 0, tx_pwr, CL_MEM_HOST|CL_EVENT_WAIT);

    // display the updated transmitter settings
    int i;
    for (i=0; i<ntx; i++)
        printf ("\t%d. transmitter power is %d\n", i, tx_pwr[i]);

    return agt_krn;
}



/**
 * Master listens for agents' queries here.
 *
 * CONTEXT *ctx .............. OpenCL context.
 * int *pilots ............... vector containing the pilot power of each
 *                             transmitter in milliwatts.  
 * struct_path_loss pl ....... contains data and meta-data about path loss
 *                             values for all the transmitters on every
 *                             coordinate in the area
 * float *interference ....... 2D matrix containing interference value for
 *                             every coordinate in the area.
 * struct_cov_info cov_info .. contains all the needed information to
 *                             re-execute the coverage kernel with 
 *                             minimum overhead.
 * int nrows ................. the number of rows in the area.
 * int ncols ................. the number of columns in the area.
 * int ntx ................... total number of transmitters in the area.
 */
void listen_for_agents (CONTEXT *ctx,
                        int *pilots,
                        struct_path_loss pl,
                        float *interference,
                        struct_cov_info cov_info,
                        const int nrows,
                        const int ncols,
                        const int ntx)
{
    int i, aid, nrank, nsignal;
    int ibuf[_AG_INT_BUFFER_SIZE_];
    float fbuf[ntx];
    MPI_Status status;

    MPI_Comm_size (MPI_COMM_WORLD, &nrank);

    printf ("Master waiting for %d slaves ...\n", nrank-1);

    // keep running for as long as 
    // there is an agent out there
    while (nrank > 1)
    {
        MPI_Recv (&ibuf, _AG_INT_BUFFER_SIZE_, MPI_INT, 
                  MPI_ANY_SOURCE, MPI_ANY_TAG, MPI_COMM_WORLD, 
                  &status);
        aid = status.MPI_SOURCE;

        switch (status.MPI_TAG)
        {
            case (_AG_LOGIN_TAG_):
                agent_login (aid, pl, ntx);
                break;

            case (_AG_PILOTS_TAG_):
                MPI_Send (pilots, ntx, MPI_SHORT, aid,
                          _AG_REPLY_TAG_, MPI_COMM_WORLD);
                break;

            case (_AG_SIGNALS_TAG_):
                get_signals_at (ibuf, pl, interference, pilots, ntx, fbuf);
                MPI_Send (fbuf, ntx, MPI_FLOAT, aid,
                          _AG_REPLY_TAG_, MPI_COMM_WORLD);
                break;

            case (_AG_CHANGE_PILOT_TAG_):
                set_pilot_power (ibuf, pilots, ntx);
                // recalculate coverage after a change in pilot power
                cov_info = coverage_cl (ctx,
                                        cov_info,
                                        pilots,
                                        nrows,
                                        ncols,
                                        ntx);
                break;

            case (_AG_OBJECTIVE_TAG_):
                ibuf[0] = cov_info.uncovered_count;
                ibuf[1] = cov_info.total_power;
                MPI_Send (ibuf, 2, MPI_INT, aid,
                          _AG_REPLY_TAG_, MPI_COMM_WORLD);
                break;

            case (_AG_UNCOVERED_TAG_):
                get_uncovered_coordinates (aid, 
                                           cov_info.uncovered_coord,
                                           cov_info.uncovered_coord_length);
                break;

            case (_AG_SUM_TAG_):
                printf ("%d. agent requested sum\n", aid);

                // calculate the sum and return the result
                ibuf[0] = ibuf[0] + ibuf[1];
                MPI_Send (ibuf, 1, MPI_INT, aid, _AG_REPLY_TAG_, 
                          MPI_COMM_WORLD);
                break;

            case (_AG_LOGOFF_TAG_):
                printf ("%d. agent logged off\n", aid);
                nrank --;
                break;

            default:
                fprintf (stderr, "Unknown message from %d. agent\n", aid);
        }
    }
    return;
}



/**
 * The MPI master process.
 */
void master (int argc, char *argv[])
{
    double east_double;
    double north_double;
    float east;
    float north;

    double ant_height, frequency, radius, dem_height;
    double rec_height = 1.5;        /* height of receiver above ground */
    
    struct Cell_head window;	    /* database window oz. region  */
    struct Cell_head cellhd;	    /* region and header information of
				                       rasters */
    char *name;			            /* input raster name */
    char *result;		            /* output raster name */
    char *mapset;		            /* mapset name */
    void *inrast;		            /* input buffer */
    unsigned char *outrast;	        /* output buffer */
    int nrows, ncols;
    int row, col;
    int tr_row, tr_col;
    int infd, outfd;		        /* file descriptors */
    int verbose;
    struct History history;	        /* holds raster meta-data 
                                       (title, comments,..) */
    struct GModule *module;	        /* GRASS module for parsing arguments */

    struct Option *input,*opt1, *opt2, *opt3, *opt4, *opt5,
                  *opt6, *opt7, *output;	/* options */
    struct Flag *flag1;		        /* flags */
    
    int dem_defined = 0;

    /* initialize GIS environment */
    G_gisinit (argv[0]);		    /* reads grass env, stores program name
                                       to G_program_name() */

    /* initialize module */
    module = G_define_module();
    module->keywords = _("raster, hata, gpu, mpi");
    module->description = _("Hata daemon, optimized for GPU");

    /* Define the different options as defined in gis.h */
    input = G_define_standard_option(G_OPT_R_INPUT);        
    output = G_define_standard_option(G_OPT_R_OUTPUT);

    /* Define the different flags */
    flag1 = G_define_flag();
    flag1->key = 'q';
    flag1->description = _("Quiet");

    opt1 = G_define_option();
    opt1->key = "coordinate";
    opt1->type = TYPE_STRING;
    opt1->required = YES;
    opt1->key_desc = "x,y";
    opt1->description = _("Base station coordinates");

    opt2 = G_define_option();
    opt2->key = "ant_height";
    opt2->type = TYPE_DOUBLE;
    opt2->required = NO;
    opt2->answer = "10";
    opt2->description = _("Height of the anntenas (m)");

    opt4 = G_define_option();
    opt4->key = "radius";
    opt4->type = TYPE_DOUBLE;
    opt4->required = NO;
    opt4->answer = "10";
    opt4->description = _("Radius of calculation (km)");

    opt5 = G_define_option();
    opt5->key = "area_type";
    opt5->type = TYPE_STRING;
    opt5->required = NO;
    opt5->description = _("Type of area");
    opt5->options = "urban,suburban,open";
    opt5->answer = "urban";

    opt3 = G_define_option();
    opt3->key = "frequency";
    opt3->type = TYPE_DOUBLE;
    opt3->required = YES;
    opt3->description = _("Frequency (MHz)");

    opt6 = G_define_option();
    opt6->key = "default_DEM_height";
    opt6->type = TYPE_DOUBLE;
    opt6->required = NO;
    //opt6->answer = "0";
    opt6->description = _("Default DEM height (m)");

    opt7 = G_define_option();
    opt7->key = "opencl";
    opt7->type = TYPE_STRING;
    opt7->required = NO;
    opt7->description = _("Enable OpenCL for calculation");
    opt7->options = "yes,no";
    opt7->answer = "no";

    /* options and flags parser */
    if (G_parser(argc, argv))
	    exit (EXIT_FAILURE);

    /* stores options and flags to variables */
    name = input->answer;
    result = output->answer;
    verbose = (!flag1->answer);
    G_scan_easting(opt1->answers[0], &east_double, G_projection());
    G_scan_northing(opt1->answers[1], &north_double, G_projection());
    sscanf(opt2->answer, "%lf", &ant_height);
    sscanf(opt4->answer, "%lf", &radius);
    sscanf(opt3->answer, "%lf", &frequency);						

    G_message(_("Starting ..."));
        
    /* returns NULL if the map was not found in any mapset, 
     * mapset name otherwise */
    mapset = G_find_cell2(name, "");
    if (mapset == NULL)
	    G_fatal_error(_("Raster map <%s> not found"), name);

    if (G_legal_filename(result) < 0)
	    G_fatal_error(_("<%s> is an illegal file name"), result);


    /* G_open_cell_old - returns file destriptor (>0) */
    if ((infd = G_open_cell_old(name, mapset)) < 0)		
	    G_fatal_error(_("Unable to open raster map <%s>"), name);


    /* controlling, if we can open input raster */
    if (G_get_cellhd(name, mapset, &cellhd) < 0)
	    G_fatal_error(_("Unable to read file header of <%s>"), name);

    G_message ("Raster meta-data from '%s'", name);
    G_message (". . . Number of bytes per cell element %d", cellhd.format + 1);
    G_message (". . . Number of rows %d", cellhd.rows);
    G_message (". . . Number of columns %d", cellhd.cols);

    /* Query the current active region */
    G_get_window (&window);

    /* Allocate the buffers, with size

           window.cols * G_raster_size (FCELL_TYPE)
    */
    inrast = G_allocate_raster_buf (FCELL_TYPE);
    outrast = G_allocate_raster_buf(FCELL_TYPE);

    /* Allocate output buffer, use input map data_type */
    nrows = G_window_rows();
    ncols = G_window_cols();

    /* controlling, if we can write the raster */
    if ((outfd = G_open_raster_new(result, FCELL_TYPE)) < 0)
	    G_fatal_error(_("Unable to create raster map <%s>"), result);

    /* check if specified transmitter location inside window */
    east = (float) east_double;
    north = (float) north_double;
	if (east < window.west || east > window.east
	    || north > window.north || north < window.south)
      G_fatal_error(_("Specified base station coordinates are outside current region bounds."));
    
    // map array coordinates for transmitter 
	tr_row = (window.north - north) / window.ns_res;
	tr_col = (east - window.west) / window.ew_res;

    // total height of transmitter 
    FCELL trans_elev;
    double trans_total_height;
    if (G_get_raster_row(infd, inrast, tr_row, FCELL_TYPE) < 0)
        G_fatal_error(_("Unable to read raster map <%s> row %d"), name, tr_row);

    trans_elev = ((FCELL *) inrast)[tr_col];

	G_message (_("Transmiter elevation [%f]"), trans_elev);

    trans_total_height = (double)trans_elev + ant_height;

    // check if transmitter is on DEM - ********************************************
    if ( isnan((double)trans_elev))							
	{
		G_fatal_error(_("Transmiter outside raster DEM map."));
	}
    else
    {
        G_message(_("Total transmiter elevation [%f]"), trans_total_height);
    }

    /* Use OpenCL? */
    if (strcmp (opt7->answer, "yes") == 0)
    {
        /* we need the radius expressed in raster cells */
        if (window.ew_res != window.ns_res)
        {
            G_warning (_("The column and row resolutions do not match."));
            G_fatal_error (_("Cannot use OpenCL for such raster data."));
        }
        else
        {
            float cells_per_km = 1000.0f/window.ew_res;

            if ((cells_per_km*window.ew_res) != 1000.0f)
            {
                G_fatal_error ("Radius is not divisible by the raster resolution %f", cells_per_km*window.ew_res);
            }
            else
            {
                // ******************************************************
                // OpenCL HATA
                // ******************************************************


                /**
                 * Test transmitters 
                 *    LJUBLANA + Okolica: 445000,158000 - 535000,68000
                 * 
                 * ATOTRA | 1463 | 1233
                 * ASKZK  | 1395 | 1180
                 * ALPP   | 1406 | 1205
                 * ANAMA  | 1420 | 1231
                 * ATIVO  | 1418 | 1226
                 * AZAPUZ | 1392 | 1196
                 * ASMAR  | 1404 | 1150
                 * ATACGD | 1390 | 1156
                 * AEJATA | 1445 | 1218
                 * AZADOB | 1482 | 1206
                 * AELNA  | 1436 | 1177
                 * ANTENA | 1397 | 1238
                 * AJELSA | 1416 | 1259
                 * AVRHOV | 1394 | 1242
                 * LTRZIN | 1454 | 1158
                 * ABIZOV | 1472 | 1247
                 * ATOMAC | 1443 | 1194
                 * ATUNEL | 1424 | 1239
                 * AKOSET | 1398 | 1206
                 * ASPAR  | 1400 | 1245
                 * ACHEMO | 1431 | 1226
                 * ALIVAD | 1423 | 1248
                 * ASMARG | 1460 | 1203
                 * ABTC   | 1451 | 1215
                 * AZIMA  | 1471 | 1236
                 * ASTARA | 1422 | 1235
                 * AVEGAS | 1434 | 1257
                 * APOVSE | 1436 | 1232
                 * LPODG  | 1492 | 1183
                 * APODUT | 1378 | 1202
                 * AGRIC  | 1385 | 1207
                 * ADELO  | 1421 | 1222
                 * AJEZA  | 1459 | 1182
                 * AMOBI  | 1429 | 1222
                 * ASKZ   | 1396 | 1181
                 * ADNEVN | 1426 | 1232
                 * AMHOTE | 1409 | 1212
                 * AVIC   | 1414 | 1236
                 * AJOZEF | 1429 | 1234
                 * ATVSLO | 1425 | 1228
                 * ACRNUC | 1445 | 1172
                 * AKOSEG | 1401 | 1210
                 * AGRAM  | 1421 | 1195
                 * ARAKTK | 1436 | 1249
                 * AIMKO  | 1445 | 1179
                 * AKOVIN | 1412 | 1214
                 * ADOLGI | 1388 | 1250
                 * APETER | 1431 | 1231
                 * AOBI   | 1443 | 1268
                 * AMZS   | 1427 | 1203
                 * AVICTK | 1403 | 1240
                 * APOLCE | 1482 | 1228
                 * AKASEL | 1497 | 1232
                 * ASISKP | 1399 | 1189
                 * AKOZAR | 1373 | 1247
                 * ASEME  | 1448 | 1262
                 * AURSKA | 1424 | 1220
                 * ABEZIT | 1427 | 1199
                 * AVEROV | 1416 | 1201
                 * ATEGR  | 1419 | 1209
                 * LDOBRO | 1353 | 1229
                 * ATRUB  | 1423 | 1231
                 * AKOLIN | 1436 | 1221
                 * AVELAN | 1439 | 1218
                 * ABEZI  | 1431 | 1216
                 * AGAMGD | 1418 | 1148
                 * AGURS  | 1431 | 1237
                 * AGPG   | 1419 | 1237
                 * AKOSME | 1397 | 1210
                 * ASOSTR | 1498 | 1253
                 * AROZNA | 1404 | 1235
                 * AVRHO  | 1380 | 1242
                 * ARAK   | 1430 | 1244
                 * AVILA  | 1404 | 1230
                 * AKOLEZ | 1413 | 1241
                 * AJEZKZ | 1427 | 1185
                 * AKOTNI | 1429 | 1226
                 * AVIZMA | 1386 | 1173
                 * AMOSTE | 1443 | 1227
                 * ATOPNI | 1425 | 1212
                 * AGZ    | 1429 | 1209
                 * LBRESZ | 1361 | 1264
                 * APRZAC | 1386 | 1192
                 * ALITIJ | 1455 | 1235
                 * ASMELT | 1429 | 1196
                 * ACRGMA | 1439 | 1166
                 * AFORD  | 1439 | 1215
                 * ABROD  | 1388 | 1168
                 * ATABOR | 1429 | 1228
                 * ATRNOV | 1421 | 1242
                 * ARESEV | 1438 | 1228
                 * ABTCMI | 1450 | 1216
                 * ASMART | 1446 | 1213
                 * APROGA | 1382 | 1251
                 * ABRDO  | 1382 | 1235
                 * AKONEX | 1387 | 1237
                 * AZITO  | 1456 | 1213
                 * ASLOM  | 1425 | 1226
                 * APLAMA | 1448 | 1202
                 * AGRAD  | 1470 | 1218
                 * AFUZIN | 1463 | 1228
                 * ASAZU  | 1421 | 1235
                 * AZALOG | 1500 | 1225
                 * ALMLEK | 1422 | 1202
                 * ACERNE | 1415 | 1212
                 * ADRAV  | 1396 | 1201
                 * APOPTV | 1435 | 1211
                 * AFRANK | 1417 | 1220
                 * ASTEP  | 1450 | 1235
                 * AZELEZ | 1428 | 1218
                 * AMURGL | 1415 | 1246
                 * AIJS   | 1407 | 1241
                 * AELOK  | 1459 | 1225
                 * LDRAG  | 1493 | 1172
                 * ASAVLJ | 1417 | 1182
                 * LTRZV  | 1465 | 1144
                 * AKODEL | 1439 | 1236
                 * AHLEV  | 1388 | 1163
                 * ATOPLA | 1451 | 1224
                 * AVECNA | 1391 | 1222
                 * ANADGO | 1462 | 1178
                 * ABOKAL | 1379 | 1231
                 * AVARNO | 1404 | 1250
                 * ASTRAL | 1422 | 1227
                 * AVEVCE | 1488 | 1234
                 * AGEOPL | 1406 | 1198
                 * AVLADA | 1415 | 1234
                 * ASTEG  | 1404 | 1193
                 * AKOSEZ | 1392 | 1207
                 */

                const int ntest_tx = 129;
                cl_int2 *test_tx = malloc (ntest_tx * sizeof(cl_int2));
 
                test_tx[0] = (cl_int2) {1463,1233};
                test_tx[1] = (cl_int2) {1395,1180};
                test_tx[2] = (cl_int2) {1406,1205};
                test_tx[3] = (cl_int2) {1420,1231};
                test_tx[4] = (cl_int2) {1418,1226};
                test_tx[5] = (cl_int2) {1392,1196};
                test_tx[6] = (cl_int2) {1404,1150};
                test_tx[7] = (cl_int2) {1390,1156};
                test_tx[8] = (cl_int2) {1445,1218};
                test_tx[9] = (cl_int2) {1482,1206};
                test_tx[10] = (cl_int2) {1436,1177};
                test_tx[11] = (cl_int2) {1397,1238};
                test_tx[12] = (cl_int2) {1416,1259};
                test_tx[13] = (cl_int2) {1394,1242};
                test_tx[14] = (cl_int2) {1454,1158};
                test_tx[15] = (cl_int2) {1472,1247};
                test_tx[16] = (cl_int2) {1443,1194};
                test_tx[17] = (cl_int2) {1424,1239};
                test_tx[18] = (cl_int2) {1398,1206};
                test_tx[19] = (cl_int2) {1400,1245};
                test_tx[20] = (cl_int2) {1431,1226};
                test_tx[21] = (cl_int2) {1423,1248};
                test_tx[22] = (cl_int2) {1460,1203};
                test_tx[23] = (cl_int2) {1451,1215};
                test_tx[24] = (cl_int2) {1471,1236};
                test_tx[25] = (cl_int2) {1422,1235};
                test_tx[26] = (cl_int2) {1434,1257};
                test_tx[27] = (cl_int2) {1436,1232};
                test_tx[28] = (cl_int2) {1492,1183};
                test_tx[29] = (cl_int2) {1378,1202};
                test_tx[30] = (cl_int2) {1385,1207};
                test_tx[31] = (cl_int2) {1421,1222};
                test_tx[32] = (cl_int2) {1459,1182};
                test_tx[33] = (cl_int2) {1429,1222};
                test_tx[34] = (cl_int2) {1396,1181};
                test_tx[35] = (cl_int2) {1426,1232};
                test_tx[36] = (cl_int2) {1409,1212};
                test_tx[37] = (cl_int2) {1414,1236};
                test_tx[38] = (cl_int2) {1429,1234};
                test_tx[39] = (cl_int2) {1425,1228};
                test_tx[40] = (cl_int2) {1445,1172};
                test_tx[41] = (cl_int2) {1401,1210};
                test_tx[42] = (cl_int2) {1421,1195};
                test_tx[43] = (cl_int2) {1436,1249};
                test_tx[44] = (cl_int2) {1445,1179};
                test_tx[45] = (cl_int2) {1412,1214};
                test_tx[46] = (cl_int2) {1388,1250};
                test_tx[47] = (cl_int2) {1431,1231};
                test_tx[48] = (cl_int2) {1443,1268};
                test_tx[49] = (cl_int2) {1427,1203};
                test_tx[50] = (cl_int2) {1403,1240};
                test_tx[51] = (cl_int2) {1482,1228};
                test_tx[52] = (cl_int2) {1497,1232};
                test_tx[53] = (cl_int2) {1399,1189};
                test_tx[54] = (cl_int2) {1373,1247};
                test_tx[55] = (cl_int2) {1448,1262};
                test_tx[56] = (cl_int2) {1424,1220};
                test_tx[57] = (cl_int2) {1427,1199};
                test_tx[58] = (cl_int2) {1416,1201};
                test_tx[59] = (cl_int2) {1419,1209};
                test_tx[60] = (cl_int2) {1353,1229};
                test_tx[61] = (cl_int2) {1423,1231};
                test_tx[62] = (cl_int2) {1436,1221};
                test_tx[63] = (cl_int2) {1439,1218};
                test_tx[64] = (cl_int2) {1431,1216};
                test_tx[65] = (cl_int2) {1418,1148};
                test_tx[66] = (cl_int2) {1431,1237};
                test_tx[67] = (cl_int2) {1419,1237};
                test_tx[68] = (cl_int2) {1397,1210};
                test_tx[69] = (cl_int2) {1498,1253};
                test_tx[70] = (cl_int2) {1404,1235};
                test_tx[71] = (cl_int2) {1380,1242};
                test_tx[72] = (cl_int2) {1430,1244};
                test_tx[73] = (cl_int2) {1404,1230};
                test_tx[74] = (cl_int2) {1413,1241};
                test_tx[75] = (cl_int2) {1427,1185};
                test_tx[76] = (cl_int2) {1429,1226};
                test_tx[77] = (cl_int2) {1386,1173};
                test_tx[78] = (cl_int2) {1443,1227};
                test_tx[79] = (cl_int2) {1425,1212};
                test_tx[80] = (cl_int2) {1429,1209};
                test_tx[81] = (cl_int2) {1361,1264};
                test_tx[82] = (cl_int2) {1386,1192};
                test_tx[83] = (cl_int2) {1455,1235};
                test_tx[84] = (cl_int2) {1429,1196};
                test_tx[85] = (cl_int2) {1439,1166};
                test_tx[86] = (cl_int2) {1439,1215};
                test_tx[87] = (cl_int2) {1388,1168};
                test_tx[88] = (cl_int2) {1429,1228};
                test_tx[89] = (cl_int2) {1421,1242};
                test_tx[90] = (cl_int2) {1438,1228};
                test_tx[91] = (cl_int2) {1450,1216};
                test_tx[92] = (cl_int2) {1446,1213};
                test_tx[93] = (cl_int2) {1382,1251};
                test_tx[94] = (cl_int2) {1382,1235};
                test_tx[95] = (cl_int2) {1387,1237};
                test_tx[96] = (cl_int2) {1456,1213};
                test_tx[97] = (cl_int2) {1425,1226};
                test_tx[98] = (cl_int2) {1448,1202};
                test_tx[99] = (cl_int2) {1470,1218};
                test_tx[100] = (cl_int2) {1463,1228};
                test_tx[101] = (cl_int2) {1421,1235};
                test_tx[102] = (cl_int2) {1500,1225};
                test_tx[103] = (cl_int2) {1422,1202};
                test_tx[104] = (cl_int2) {1415,1212};
                test_tx[105] = (cl_int2) {1396,1201};
                test_tx[106] = (cl_int2) {1435,1211};
                test_tx[107] = (cl_int2) {1417,1220};
                test_tx[108] = (cl_int2) {1450,1235};
                test_tx[109] = (cl_int2) {1428,1218};
                test_tx[110] = (cl_int2) {1415,1246};
                test_tx[111] = (cl_int2) {1407,1241};
                test_tx[112] = (cl_int2) {1459,1225};
                test_tx[113] = (cl_int2) {1493,1172};
                test_tx[114] = (cl_int2) {1417,1182};
                test_tx[115] = (cl_int2) {1465,1144};
                test_tx[116] = (cl_int2) {1439,1236};
                test_tx[117] = (cl_int2) {1388,1163};
                test_tx[118] = (cl_int2) {1451,1224};
                test_tx[119] = (cl_int2) {1391,1222};
                test_tx[120] = (cl_int2) {1462,1178};
                test_tx[121] = (cl_int2) {1379,1231};
                test_tx[122] = (cl_int2) {1404,1250};
                test_tx[123] = (cl_int2) {1422,1227};
                test_tx[124] = (cl_int2) {1488,1234};
                test_tx[125] = (cl_int2) {1406,1198};
                test_tx[126] = (cl_int2) {1415,1234};
                test_tx[127] = (cl_int2) {1404,1193};
                test_tx[128] = (cl_int2) {1392,1207};

                CONTEXT * ctx = init_context ( );
                int cell_radius = radius*cells_per_km;
               
                /* calculate the path loss matrix for each of the Tx */
                int npathloss = hata_path_loss_cl (ctx,
                                                   (int) window.ns_res,
                                                   nrows, ncols,
                                                   test_tx, ntest_tx,
                                                   (int) ant_height,
                                                   rec_height, 
                                                   (float) frequency, 
                                                   cell_radius,
                                                   infd, result,
                                                   FCELL_TYPE);

                /* calculate interference matrix */
                hata_interference_cl (ctx,
                                      (int) window.ns_res,
                                      nrows, ncols, 
                                      test_tx, ntest_tx, 
                                      (int) ant_height,
                                      rec_height, (float) frequency, 
                                      cell_radius,
                                      infd, outfd,
                                      FCELL_TYPE);

                // closing raster maps 
                G_close_cell(infd);
                G_close_cell(outfd);

                // load the interference matrix in host memory 
                float *interference = load_interference (ctx, 
                                                         result,
                                                         FCELL_TYPE);

                // initialize all pilot powers in host memory
                int *pilots = init_random_pilots (ctx,
                                                  ntest_tx);

                /* pilot powers as resulted from the attenuation-based method
                pilots[125] = 7409;
                pilots[126] = 7526;
                pilots[127] = 7508;
                pilots[128] = 7115; */

                // load each of the path loss matrices in host memory
                // (there is one path loss matrix for each transmitter),
                // including their meta-data about offsets and size
                struct_path_loss loaded_pl = load_pl_matrices (ctx,
                                                               result, 
                                                               ntest_tx, 
                                                               npathloss,
                                                               FCELL_TYPE);
                /* calculate attenuation-based pilot powers
                calculate_attenuation_pilots (loaded_pl,
                                              pilots,
                                              interference,
                                              ntest_tx);*/

                // calculate coverage for the first time 
                struct_cov_info cov_info = initial_coverage_cl (ctx, 
                                                                pilots, 
                                                                loaded_pl, 
                                                                interference, 
                                                                nrows, 
                                                                ncols, 
                                                                ntest_tx);

                /** 
                 * GPU-based agents
                 *
                // the area within which the agents may move
                int agent_area[4];
                init_agent_area (agent_area, loaded_pl, ntest_tx);
                cl_int4 mdim = (cl_int4) {agent_area[0], agent_area[1],
                                          agent_area[2], agent_area[3]};
                // this structure saves needed data for subsequent 
                // calls of the agent's kernel with minimum overhead
                struct_agent_kernel agent_krn;
                agent_krn.handler = NULL;
                agent_krn.kernel = NULL;

                int i;
                for (i = 0; i < _AG_MAX_AGENT_STEPS_; i++)
                {
                    printf("Objective function, %d uncovered, using %d mW\n", cov_info.uncovered_count,
                                                                              cov_info.total_power);
                    // optimize once
                    agent_krn = optimize_cl (ctx,
                                             agent_krn,
                                             mdim,
                                             pilots,
                                             loaded_pl,
                                             interference,
                                             cov_info,
                                             ncols,
                                             ntest_tx);

                    // calculate new coverage
                    cov_info = coverage_cl (ctx,
                                            cov_info,
                                            pilots,
                                            nrows,
                                            ncols,
                                            ntest_tx);
                }
                *
                */

                // listen for MPI agent queries
                listen_for_agents (ctx,
                                   pilots, 
                                   loaded_pl, 
                                   interference,
                                   cov_info,
                                   nrows,
                                   ncols,
                                   ntest_tx);

                // save last coverage before closing
                clmsync (ctx, 0, cov_info.coverage, CL_MEM_HOST|CL_EVENT_WAIT);
                save_raster_to_file ("coverage_final", 
                                      cov_info.coverage,
                                      0, 0,
                                      ncols, nrows,
                                      ncols, nrows);

                // free memory before closing
                clfree (pilots);
                clfree (cov_info.uncovered_count_reduction);
                clfree (cov_info.uncovered_coord);
                clfree (cov_info.coverage);
                clfree (loaded_pl.data);
                clfree (loaded_pl.offsets);
                clfree (interference);
                free (test_tx);
                clclose (ctx, cov_info.handler);
            }
        }
    }
    else
    {
        // ************************************************************************
        // Serial HATA - not implemented in daemon mode
        // ************************************************************************
        G_fatal_error ("The serial implementation is not available in daemon mode");
    }

    /* memory cleanup */
    G_free(inrast);
    G_free(outrast);

    /* add command line incantation to history file */
    G_short_history(result, "raster", &history);
    G_command_history(&history);
    G_write_history(result, &history);

    /* go back to the MPI entry point */
    return;
}

