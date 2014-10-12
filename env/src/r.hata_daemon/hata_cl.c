
/****************************************************************************
 *
 * MODULE:       r.hata_daemon
 * AUTHOR(S):    Andrej Vilhar, Jozef Stefan Institute                
 *
 * PURPOSE:      Calculates the interference matrix of many base stations
 *               according to Hata's model.
 *             
 *
 * COPYRIGHT:    (C) 2009 Jozef Stefan Institute
 *
 * OpenCL code contribution by Lucas Benedičič (lucas.benedicic@mobitel.si)
 *
 *****************************************************************************/
#include <stdlib.h>
#include <math.h>
#include <grass/gis.h>
#include "oclkernel.hpp"
#include "prot.h"
#include "ag_structs.h"




/**
 * Dumps a piece of memory.
 */
void debug_dump_float_memory (float *data, 
                              const int ncols, const int nrows,
                              const char stop)
{
    /**
     * Memory dump
     */
    int i, j; 
    for (i=0; i<nrows; i++)
    {
        for (j=0; j<ncols; j++)
        {
            printf ("dump\t%d,%d\t%10.8f\n", j, i, data[i*ncols+j]);
        }
    }

    if (stop)
        G_fatal_error ("= = = = = = = =\nDump finished");
    else
        G_message ("- - - - - - - - -\nDump finished");
}



/**
 * Dumps a piece of memory.
 */
void debug_dump_char_memory (unsigned char *data, 
                             const int ncols, const int nrows,
                             const char stop)
{
    /**
     * Memory dump
     */
    int i, j; 
    for (i=0; i<nrows; i++)
    {
        for (j=0; j<ncols; j++)
        {
            printf ("dump\t%d,%d\t%d\n", j, i, data[i*ncols+j]);
        }
    }

    if (stop)
        G_fatal_error ("= = = = = = = =\nDump finished");
    else
        G_message ("- - - - - - - - -\nDump finished");
}



/**
 * Initializes a CL context and displays information about it.
 * Returns a pointer to the created context.
 *
 */
CONTEXT * init_context ( )
{
    CONTEXT * ctx = (stdgpu)? stdgpu : stdcpu;

    /* Query the created context for devices */
    G_message ("Querying platform for OpenCL devices ...");

    int ndev = clgetndev (ctx);

    struct cldev_info *dev_info = (struct cldev_info*)
                                   malloc(ndev*sizeof(struct cldev_info));
        
    clgetdevinfo (ctx, dev_info);

    clfreport_devinfo (stdout, ndev, dev_info);

    free (dev_info);

    return ctx;
}



/*
 * Loads raster data to host memory and returns a pointer to it.
 * The operation is performed within the current context.
 *
 * CONTEXT *ctx ........... an active OpenCL context.
 * int nrows .............. the number of rows in the DEM.
 * int ncols .............. the number of columns in the DEM.
 * int infd ............... file descriptor to read from the DEM.
 * RASTER_MAP_TYPE rtype .. DEM element data type.
 *
 */
FCELL* load_raster (CONTEXT *ctx,
                    const int nrows, const int ncols, 
                    const int infd,
                    RASTER_MAP_TYPE rtype)
{
    int row, col;

    if (rtype != FCELL_TYPE)
    {
        G_fatal_error ("Wrong element data type in 'load_raster'");
        return NULL;
    }
    else
    {
        FCELL *rastbuf = malloc (ncols * G_raster_size (rtype));

        G_message ("Loading raster data into memory ...");

        /* allocate raster DEM data */
        FCELL *ret_value = (FCELL *) clmalloc (ctx, 
                                      nrows * ncols * G_raster_size (rtype), 0);

        /* Load input map in device memory row by row */
        for (row = 0; row < nrows; row++)
        {
            /* display completion percentage */
            G_percent (row, nrows, 2);
            
            /* read input map */
            if (G_get_raster_row (infd, rastbuf, row, rtype) < 0)
                G_fatal_error ("Unable to read from raster map");

            /* copy this row to the device buffer */
            FCELL *offset = ret_value + row * ncols;

            if (offset != memcpy (offset, rastbuf, ncols * G_raster_size (rtype)))
                G_fatal_error ("Error while copying memory!");
        }

        /* free buffers */
        free (rastbuf);

        /* Return a pointer to the allocated resources */
        return ret_value;
    }
}



/*
 * Allocates or resets raster data in host memory, returning a 
 * pointer to it. The operation is performed within the given
 * OpenCL context. Raster data is initialized to the given value.
 *
 * CONTEXT *ctx ........... an active OpenCL context.
 * int nrows .............. the number of rows in the DEM.
 * int ncols .............. the number of columns in the DEM.
 * RASTER_MAP_TYPE rtype .. DEM element data type.
 * FCELL init_value ....... initial value used for reseting or allocating
 *                          raster data. If NAN is given, the raster is
 *                          nullified.
 * void *alloc_ptr ........ a pointer to previously allocated memory. 
 *                          If it is valie, the memory is just set to
 *                          'init_value' without new memory allocation.
 *
 */
FCELL* alloc_raster (CONTEXT *ctx,
                     const int nrows, const int ncols, 
                     RASTER_MAP_TYPE rtype,
                     FCELL init_value,
                     void *alloc_ptr) 
{
    int i,j;

    if (rtype != FCELL_TYPE)
    {
        G_fatal_error ("Wrong element data type in 'alloc_raster'");
        return NULL;
    }
    else
    {
        FCELL *ret_value;

        if (alloc_ptr == NULL)
        {
            G_message ("Allocating NULL raster data into memory ...");

            /* allocate raster DEM data */
            ret_value = (FCELL *) clmalloc (ctx, 
                                   nrows * ncols * G_raster_size (rtype), 0);
        }
        else
        {
            G_message ("Resetting memory ...");
            ret_value = alloc_ptr;
        }

        /* Initialize the whole piece of memory */
        if (init_value == NAN)
        {
            G_set_f_null_value (ret_value, nrows * ncols);
        }
        else
        {
            for (i=0; i<nrows; i++)
            {
                for (j=0; j<ncols; j++)
                {
                    ret_value[i*ncols+j] = init_value;
                }
            }
        }

        /* Return a pointer to the allocated resources */
        return ret_value;
    }
}



/*
 * Allocates or resets raster data in host memory, returning a 
 * pointer to it. The operation is performed within the given
 * OpenCL context. Raster data is initialized to NULL.
 *
 * CONTEXT *ctx ........... an active OpenCL context.
 * int nrows .............. the number of rows in the DEM.
 * int ncols .............. the number of columns in the DEM.
 * RASTER_MAP_TYPE rtype .. DEM element data type.
 * void *alloc_ptr ........ a pointer to previously allocated
 *                          memory. If it is given, the memory
 *                          pointed by alloc_ptr is just set to
 *                          NULL (without new memory allocation).
 *
 */
FCELL* null_raster (CONTEXT *ctx,
                    const int nrows, const int ncols, 
                    RASTER_MAP_TYPE rtype,
                    void *alloc_ptr)
{
    return alloc_raster (ctx, nrows, ncols, rtype, (FCELL)NAN, alloc_ptr);
}



/**
 * Saves raster data pointed by 'rastdata', using the received file
 * descriptor.
 *
 * FCELL *rastdata ........ raster data to be saved.
 * int col_offset ......... column offset of the data being saved.
 * int row_offset ......... row offset of the data being saved.
 * int width .............. width (i.e. number of columns) of the data.
 * int height ............. height (i.e. number of rows) of the data.
 * int ncols .............. the number of columns in the final raster data.
 * int nrows .............. the number of rows in the final raster.
 * int outfd .............. file descriptor used for writing.
 */
void save_raster (FCELL *rastdata,
                  const int col_offset, const int row_offset,
                  const int width, const int height,
                  const int ncols, const int nrows,
                  const int outfd)
{
    int row, col;

    if ((width <= ncols) && (height <= nrows))
    {
        FCELL *savebuf = (FCELL*) malloc (ncols * G_raster_size (FCELL_TYPE));

        G_message ("Creating output raster (offset %d,%d) ...", col_offset,
                                                                row_offset);
        // save raster data row by row
        for (row = 0; row < nrows; row++)
        {
            // display completion percentage
            G_percent (row, nrows, 2);

            // nullify this row
            G_set_f_null_value (savebuf, ncols);

            int row_idx = row-row_offset;
            if ((row_idx >= 0) && (row_idx < height))
            {
                for (col = 0; col < width; col++)
                {
                    savebuf[col_offset + col] = rastdata[row_idx*width+col];
                }
            }
            if (G_put_raster_row (outfd, savebuf, FCELL_TYPE) < 0)
                G_fatal_error ("Failed writing output raster map");
        }

        /* free buffers */
        free (savebuf);
    }
    else
    {
        if ((col_offset == 0) && (row_offset == 0))
        {
            FCELL *savebuf = (FCELL*) malloc (ncols * G_raster_size (FCELL_TYPE));

            G_message ("Creating smaller raster than received data ...");

            // save raster data row by row
            for (row = 0; row < nrows; row++)
            {
                // display completion percentage
                G_percent (row, nrows, 2);

                // nullify this row
                G_set_f_null_value (savebuf, ncols);

                for (col = 0; col < ncols; col++)
                {
                    savebuf[col] = rastdata[row*width + col];
                }

                if (G_put_raster_row (outfd, savebuf, FCELL_TYPE) < 0)
                    G_fatal_error ("Failed writing output raster map");
            }

            /* free buffers */
            free (savebuf);
        }
        else
        {
            G_fatal_error ("Saving save raster data bigger than the final raster with non-zero offsets is not supported!");
        }
    }
}



/**
 * Saves raster data pointed by 'rastdata' to a raster map named 'name'.
 *
 * char *name ............. the name of the raster map to where save to.
 * FCELL *rastdata ........ raster data to be saved.
 * int col_offset ......... column offset of the data being saved.
 * int row_offset ......... row offset of the data being saved.
 * int width .............. width (i.e. number of columns) of the data.
 * int height ............. height (i.e. number of rows) of the data.
 * int ncols .............. the number of columns in the final raster data.
 * int nrows .............. the number of rows in the final raster.
 */
void save_raster_to_file (const char *name,
                          FCELL *rastdata,
                          const int col_offset, const int row_offset,
                          const int width, const int height,
                          const int ncols, const int nrows)
{
    // output file descriptor 
    int outfd = G_open_raster_new (name, FCELL_TYPE);

    if (outfd < 0)
    {
        G_fatal_error("Unable to create raster map <%s>", name);
    }
    else
    {
        save_raster (rastdata, 
                     col_offset, row_offset, 
                     width, height,
                     ncols, nrows, outfd);
        G_close_cell (outfd);
    }
}




/**
 * Calculates coverage for the whole area, taking advantage of 
 * previous calculations, so that CPU-GPU transfers are minimized.
 * Returns a structure used for any subsequent calls.
 *
 * CONTEXT *ctx .............. OpenCL context.
 * struct_cov_info cov_info .. contains all the needed information to
 *                             re-execute the coverage kernel with 
 *                             minimum overhead.
 * int *pilots ............... vector containing the pilot power of each
 *                             transmitter in milliwatts.  
 * int nrows ................. the number of rows in the area.
 * int ncols ................. the number of columns in the area.
 * int ntx ................... total number of transmitters in the area.
 */
struct_cov_info coverage_cl (CONTEXT *ctx,
                             struct_cov_info cov_info,
                             int *pilots,
                             const int nrows,
                             const int ncols,
                             const int ntx)
{
    // kernel parameters to be refreshed
    int *tx_pwr = pilots;
    float *cov_out = cov_info.coverage;
    unsigned short *cov_ctr_out = cov_info.uncovered_count_reduction;
    unsigned short *cov_coord_out = cov_info.uncovered_coord;

    G_message ("Simulating coverage ...");

    // no need to transfer the data to the device!
    //clmsync (ctx, 0, tx_pwr, CL_MEM_DEVICE|CL_EVENT_NOWAIT);
    //clarg_set_global (ctx, cov_info.kernel, 5, tx_pwr);

    // start kernel execution 
    clfork (ctx, 0, cov_info.kernel, &cov_info.kernel_range, CL_EVENT_NOWAIT);
    clwait (ctx, 0, CL_KERNEL_EVENT|CL_MEM_EVENT|CL_EVENT_RELEASE);

    // sync memory 
    clmsync (ctx, 0, cov_ctr_out, CL_MEM_HOST|CL_EVENT_NOWAIT);
    clmsync (ctx, 0, cov_coord_out, CL_MEM_HOST|CL_EVENT_WAIT);

    /*
     * DEBUG: Compare the number of uncovered pixels on GPU and CPU
     *
    int i, j, k = 0;

    for (i = 0; i < nrows; i++)
    {
        for (j = 0; j < ncols; j++)
        {
            // this comparisson ignores raster cells where
            // the value is NaN (i.e. where there is no path-loss data)
            if (cov_out[i*ncols+j] < _AG_MINIMUM_GAMMA_COVERAGE_)
            {
                //ret_value.uncovered_coord[2*k] = j;
                //ret_value.uncovered_coord[2*k+1] = i;
                k ++;
            }
        }
    }
    G_message ("CPU says there are %d uncovered pixels", k); */

    /*
     * DEBUG: display some uncovered coordinates
     *
    for (i = 0; i <  cov_info.uncovered_coord_length; i++)
        G_message ("Uncovered coordinate %d x %d", cov_coord_out[2*i],
                                                   cov_coord_out[2*i+1]);
    */

    int i;

    // save the sum of uncovered pixels from the reduced vector
    cov_info.uncovered_count = 0;
    for (i = 0; i < cov_info.uncovered_coord_length; i++)
        cov_info.uncovered_count += cov_ctr_out[i];

    // calculate the total amount of energy used
    float totpwr = 0.0f;
    for (i = 0; i < ntx; i++)
        totpwr += (float) pilots[i];

    // return enough information for subsequent calls
    cov_info.kernel = cov_info.kernel;
    cov_info.kernel_range = cov_info.kernel_range;
    cov_info.coverage = cov_out;
    cov_info.uncovered_coord = cov_coord_out;
    cov_info.uncovered_count_reduction = cov_ctr_out;
    cov_info.total_power = totpwr;

    return cov_info;
}




/**
 * Calculates the initial coverage for the whole area. 
 * Returns a structure used for any subsequent calls.
 *
 * CONTEXT *ctx ........... OpenCL context.
 * int *pilots ............ vector containing the pilot power of each
 *                          transmitter in milliwatts.  
 * struct_path_loss pl .... contains data and meta-data about path loss
 *                          values for all the transmitters on every
 *                          coordinate in the area
 * float *interference .... 2D matrix containing interference value for
 *                          every coordinate in the area.
 * int nrows .............. the number of rows in the area.
 * int ncols .............. the number of columns in the area.
 * int ntx ................ total number of transmitters in the area.
 */
struct_cov_info initial_coverage_cl (CONTEXT *ctx,
                                     int *pilots,
                                     struct_path_loss pl,
                                     float *interference,
                                     const int nrows, const int ncols,
                                     const int ntx)
{
    // number of processing tiles for the whole area
    int ntile_x = ncols / _HATA_GPU_WITEM_PER_DIM_;
    int ntile_y = nrows / _HATA_GPU_WITEM_PER_DIM_;

    // load, compile and link the OpenCL kernel file 
    void* h = clopen (ctx, NULL, CLLD_NOW);

    // select a kernel function from the loaded file
    cl_kernel krn = clsym (ctx, h, "coverage_kern", CLLD_NOW);

    // defines a 2D matrix of work groups & work items 
    size_t global_wsize_x = ntile_x * _HATA_GPU_WITEM_PER_DIM_;
    size_t global_wsize_y = ntile_y * _HATA_GPU_WITEM_PER_DIM_;
    size_t local_wsize = _HATA_GPU_WITEM_PER_DIM_;

    if (((global_wsize_x % local_wsize) != 0) ||
        ((global_wsize_y % local_wsize) != 0))
        G_fatal_error ("Work group dimensions are incorrect.");
    else
        G_message ("Creating %dx%d work-group(s) of [%dx%d] threads each", 
                   ntile_x, ntile_y,
                   local_wsize, local_wsize);

    clndrange_t ndr = clndrange_init2d (0,global_wsize_x,local_wsize, 
                                        0,global_wsize_y,local_wsize);
   
    unsigned char *pl_in = pl.data;
    cl_int4 *offsets_in = pl.offsets;
    float *qrm_in = interference;
    int *tx_pwr = pilots;
    float *cov_out;
    unsigned short *cov_ctr_out;
    unsigned short *cov_coord_out;

    G_message ("Simulating first coverage ...");
    cov_out = (float*) null_raster (ctx, 
                                    nrows,
                                    ncols,
                                    FCELL_TYPE, NULL);
    cov_ctr_out = (unsigned short*) clmalloc (ctx, 
                                              ntile_x * ntile_y * sizeof(short), 0);
    cov_coord_out = (unsigned short*) clmalloc (ctx, 
                                                ntile_x * ntile_y * 2 * sizeof(short), 0);
    // transfer data to the device
    clmsync (ctx, 0, pl_in, CL_MEM_DEVICE|CL_EVENT_NOWAIT);
    clmsync (ctx, 0, offsets_in, CL_MEM_DEVICE|CL_EVENT_NOWAIT);
    clmsync (ctx, 0, qrm_in, CL_MEM_DEVICE|CL_EVENT_NOWAIT);
    clmsync (ctx, 0, tx_pwr, CL_MEM_DEVICE|CL_EVENT_NOWAIT);
    clmsync (ctx, 0, cov_out, CL_MEM_DEVICE|CL_EVENT_NOWAIT);
    clmsync (ctx, 0, cov_ctr_out, CL_MEM_DEVICE|CL_EVENT_NOWAIT);
    clmsync (ctx, 0, cov_coord_out, CL_MEM_DEVICE|CL_EVENT_WAIT);

    // kernel parameters and local memory size
    clarg_set (ctx, krn, 0, ntx);
    clarg_set (ctx, krn, 1, ncols);
    clarg_set_global (ctx, krn, 2, pl_in);
    clarg_set_global (ctx, krn, 3, offsets_in);
    clarg_set_global (ctx, krn, 4, qrm_in);
    clarg_set_global (ctx, krn, 5, tx_pwr);
    clarg_set_global (ctx, krn, 6, cov_out);
    clarg_set_global (ctx, krn, 7, cov_ctr_out);
    clarg_set_global (ctx, krn, 8, cov_coord_out);

    // this offset marks where the counters start in local memory
    int lmem_ctr_offset = _HATA_GPU_WITEM_PER_DIM_ *
                          _HATA_GPU_WITEM_PER_DIM_;
    // this offset marks where the coordinates start in local memory
    int lmem_coord_offset = lmem_ctr_offset + 
                            _HATA_GPU_WITEM_PER_DIM_ *
                            _HATA_GPU_WITEM_PER_DIM_;
    size_t lmem_size = lmem_coord_offset + 
                       _HATA_GPU_WITEM_PER_DIM_ *
                       _HATA_GPU_WITEM_PER_DIM_;
    lmem_size *= sizeof(float);
    if (lmem_size > _HATA_GPU_MAX_LOCAL_MEM_)
        G_fatal_error ("Allocated local memory (%d) exceeds %d bytes.", lmem_size,
                                                                        _HATA_GPU_MAX_LOCAL_MEM_);
    else
        G_message ("Allocated %d bytes of local memory for %d float elements.", lmem_size,
                                                                                lmem_size / sizeof(float));
    clarg_set (ctx, krn, 9, lmem_ctr_offset);
    clarg_set (ctx, krn, 10, lmem_coord_offset);
    clarg_set_local (ctx, krn, 11, lmem_size);

    // start kernel execution 
    clfork (ctx, 0, krn, &ndr, CL_EVENT_NOWAIT);
    clwait (ctx, 0, CL_KERNEL_EVENT|CL_MEM_EVENT|CL_EVENT_RELEASE);

    // sync memory 
    clmsync (ctx, 0, cov_out, CL_MEM_HOST|CL_EVENT_NOWAIT);
    clmsync (ctx, 0, cov_ctr_out, CL_MEM_HOST|CL_EVENT_NOWAIT);
    clmsync (ctx, 0, cov_coord_out, CL_MEM_HOST|CL_EVENT_WAIT);

    /*
     * DEBUG: Compare the number of uncovered pixels on GPU and CPU
     *

    for (i = 0; i < nrows; i++)
    {
        for (j = 0; j < ncols; j++)
        {
            // this comparisson ignores raster cells where
            // the value is NaN (i.e. where there is no path-loss data)
            if (cov_out[i*ncols+j] < _AG_MINIMUM_GAMMA_COVERAGE_)
            {
                //ret_value.uncovered_coord[2*k] = j;
                //ret_value.uncovered_coord[2*k+1] = i;
                k ++;
            }
        }
    }
    G_message ("CPU says there are %d uncovered pixels", k);
    */

    /*
     * DEBUG: display some uncovered coordinates
     *
    for (i = 0; i < ntile_x; i++)
    {
        for (j = 0; j < ntile_y; j++)
        {
            int idx_reduced = j * ntile_x + i;
            G_message ("Uncovered coordinate %d x %d", cov_coord_out[2*idx_reduced],
                                                       cov_coord_out[2*idx_reduced+1]);
        }
    }*/
    
    int i;

    // save the sum of uncovered pixels from the reduced vector
    struct_cov_info ret_value;
    ret_value.uncovered_coord_length = ntile_x * ntile_y;
    ret_value.uncovered_count = 0;
    for (i = 0; i < ret_value.uncovered_coord_length; i++)
        ret_value.uncovered_count += cov_ctr_out[i];

    // calculate the total amount of energy used
    float totpwr = 0.0f;
    for (i = 0; i < ntx; i++)
        totpwr += (float) pilots[i];

    save_raster_to_file ("coverage", cov_out,
                         0, 0,
                         ncols, nrows,
                         ncols, nrows);
    
    // return enough information for subsequent calls
    ret_value.handler = h;
    ret_value.kernel = krn;
    ret_value.kernel_range = ndr;
    ret_value.coverage = cov_out;
    ret_value.uncovered_coord = cov_coord_out;
    ret_value.uncovered_count_reduction = cov_ctr_out;
    ret_value.total_power = totpwr;

    return ret_value;
}




/**
 * Calculates an interference matrix resulting from the tx power of all
 * transmitters combined with their respective path losses and the thermal
 * noise. The output is saved in one raster map (ie. outfd).
 *
 * CONTEXT *ctx ........... OpenCL context.
 * int raster_res ......... size of one raster cell (in meters).
 * int nrows .............. the number of rows in the DEM.
 * int ncols .............. the number of columns in the DEM.
 * cl_int2 *test_tx ....... array containing all transmitters.
 * int ntest_tx ........... number of transmitters in 'test_tx'.
 * int anthena_height ..... height of transmitter anthena above ground.
 * float rx_height ........ receiver height above ground.
 * float frequency ........ transmitter frequency in Mhz.
 * int radius ............. calculation radius around each transmitter
 *                          (in raster cells).
 * int infd ............... file descriptor to read from the DEM.
 * int outfd .............. file descriptor to write the interference
 *                          data to.
 * RASTER_MAP_TYPE rtype .. DEM element data type.
 *
 */
void hata_interference_cl (CONTEXT *ctx,
                           const int raster_res,
                           const int nrows, const int ncols,
                           cl_int2 *test_tx, const int ntest_tx,
                           const int tx_anthena_height,
                           const float rx_height, const float frequency,
                           const int radius,
                           const int infd, const int outfd,
                           RASTER_MAP_TYPE rtype)
{
    int i;

    /* number of processing tiles needed around each transmitter */
    int ntile = (radius*2) / _HATA_GPU_WITEM_PER_DIM_ + 1;

    /* load, compile and link the OpenCL kernel file */
    void* h = clopen (ctx, NULL, CLLD_NOW);

    /* select a kernel function from the loaded file */
    cl_kernel krn = clsym (ctx, h, "hata_urban_interference", CLLD_NOW);

    /* defines a 2D matrix of work groups & work items */
    size_t global_wsize = ntile*_HATA_GPU_WITEM_PER_DIM_;
    size_t local_wsize = _HATA_GPU_WITEM_PER_DIM_;

    if ((global_wsize % local_wsize) != 0)
        G_fatal_error ("Work-group dimensions are incorrect.");
    else
        G_message ("Creating %d work-group(s) of [%d x %d] threads each", 
                   global_wsize/local_wsize,
                   local_wsize, local_wsize);

    clndrange_t ndr = clndrange_init2d (0,global_wsize,local_wsize, 
                                        0,global_wsize,local_wsize);

    // correction factor ahr
    float ahr = (1.1f*log10(frequency) - 0.7f)*rx_height - 
                (1.56f*log10(frequency) - 0.8f);

    // initialize raster data 
    FCELL *dem_in = load_raster (ctx, nrows, ncols, infd, rtype);

    // interference matrix
    FCELL *qrm_out = alloc_raster (ctx, nrows, ncols, rtype, 
                                   (FCELL)_HATA_THERMAL_NOISE_, NULL);

    // kernel parameters and local memory size
    clarg_set (ctx, krn, 0, raster_res);
    clarg_set (ctx, krn, 1, ncols);
    clarg_set (ctx, krn, 4, rx_height);
    clarg_set (ctx, krn, 5, frequency);
    clarg_set (ctx, krn, 6, ahr);

    size_t lmem_size = _HATA_GPU_WITEM_PER_DIM_ *
                       _HATA_GPU_WITEM_PER_DIM_ *
                       sizeof(cl_float2);

    if (lmem_size > _HATA_GPU_MAX_LOCAL_MEM_)
        G_fatal_error ("Allocated local memory (%d) exceeds %d bytes.", lmem_size,
                                                                        _HATA_GPU_MAX_LOCAL_MEM_);
    clarg_set_local (ctx, krn, 9, lmem_size);

    // transfer data to the device 
    clmsync (ctx, 0, dem_in, CL_MEM_DEVICE|CL_EVENT_NOWAIT);
    clmsync (ctx, 0, qrm_out, CL_MEM_DEVICE|CL_EVENT_WAIT);

    /* set remaining kernel parameters */
    clarg_set_global (ctx, krn, 7, dem_in);
    clarg_set_global (ctx, krn, 8, qrm_out);

    G_message ("Simulating interference matrix ...");

    // for each transmitter
    for (i = 0; i < ntest_tx; i++)
    {
        // display completion percentage
        G_percent (i, ntest_tx, 1);

        // transmitter data 
        cl_int4 tx_data = (cl_int4) {test_tx[i].x, 
                                     test_tx[i].y,
                                     (int) dem_in[test_tx[i].y*ncols + test_tx[i].x],
                                     tx_anthena_height};

        G_message ("The transmitter is located at %d,%d,%d", tx_data.x,
                                                             tx_data.y,
                                                             tx_data.z);
        // tile offset within the raster 
        cl_int2 tx_offset = (cl_int2) {tx_data.x - radius,
                                       tx_data.y - radius};

        // set (more) remaining kernel parameters
        clarg_set (ctx, krn, 2, tx_data);
        clarg_set (ctx, krn, 3, tx_offset);

        // start kernel execution
        clfork (ctx, 0, krn, &ndr, CL_EVENT_NOWAIT);

        clwait (ctx, 0, CL_KERNEL_EVENT|CL_MEM_EVENT|CL_EVENT_RELEASE);
    }

    // sync memory 
    clmsync (ctx, 0, qrm_out, CL_MEM_HOST|CL_EVENT_WAIT);

    // write the calculation output
    save_raster (qrm_out, 0, 0, ncols, nrows, ncols, nrows, outfd);

    // free allocated resources
    clclose (ctx, h);
    clfree (qrm_out);
    clfree (dem_in);
}




/**
 * Calculates a path loss matrix for each of the transmitters.
 * The output is saved in separate raster maps (i.e. one for each tx).
 * Returns the number of elements in each path loss matrix. Because the
 * matrix is square, sqrt() gives the size of the matrix in each dimension.
 *
 * CONTEXT *ctx ........... OpenCL context.
 * int raster_res ......... size of one raster cell (in meters).
 * int nrows .............. the number of rows in the DEM.
 * int ncols .............. the number of columns in the DEM.
 * cl_int2 *test_tx ....... array containing all transmitters.
 * int ntest_tx ........... number of transmitters in 'test_tx'.
 * int anthena_height ..... height of transmitter anthena above ground.
 * float rx_height ........ receiver height above ground.
 * float frequency ........ transmitter frequency in Mhz.
 * int radius ............. calculation radius around to the transmitter
 *                          (in raster cells).
 * int infd ............... file descriptor to read from the DEM.
 * char *outname .......... the base name of all generated rasters.
 * RASTER_MAP_TYPE rtype .. DEM element data type.
 *
 */
int hata_path_loss_cl (CONTEXT *ctx,
                       const int raster_res,
                       const int nrows, const int ncols,
                       cl_int2 *test_tx, const int ntest_tx,
                       const int tx_anthena_height,
                       const float rx_height, const float frequency,
                       const int radius,
                       const int infd, const char *outname, 
                       RASTER_MAP_TYPE rtype)
{
    int i;
    char *raster_outname = (char *) malloc (100 * sizeof(char));

    /* number of processing tiles needed around each transmitter */
    int ntile = (radius*2) / _HATA_GPU_WITEM_PER_DIM_ + 1;

    G_message ("Receiver height above ground is %5.2f mts", rx_height);
    G_message ("Transmitter frequency is %7.2f Mhz", frequency);
    G_message ("Calculation radius is %d raster cells", radius);

    /* load, compile and link the OpenCL kernel file */
    void* h = clopen (ctx, NULL, CLLD_NOW);

    /* select a kernel function from the loaded file */
    cl_kernel krn = clsym (ctx, h, "hata_urban_kern_per_tx", CLLD_NOW);

    /* defines a 2D matrix of work groups & work items */
    size_t global_wsize = ntile*_HATA_GPU_WITEM_PER_DIM_;
    size_t local_wsize = _HATA_GPU_WITEM_PER_DIM_;

    if ((global_wsize % local_wsize) != 0)
        G_fatal_error ("Work group dimensions are incorrect.");
    else
        G_message ("Creating %d work-group(s) of [%d x %d] threads each", 
                   global_wsize/local_wsize,
                   local_wsize, local_wsize);

    clndrange_t ndr = clndrange_init2d (0,global_wsize,local_wsize, 
                                        0,global_wsize,local_wsize);
    // correction factor ahr
    float ahr = (1.1f*log10(frequency) - 0.7f)*rx_height - 
                (1.56f*log10(frequency) - 0.8f);

    /* initialize raster data */
    FCELL *dem_in = load_raster (ctx, nrows, ncols, infd, rtype);

    /* path loss matrix for one transmitter */
    FCELL *pl_out = alloc_raster (ctx, 
                                  global_wsize,
                                  global_wsize,
                                  rtype,
                                  _HATA_MAX_PATH_LOSS_,
                                  NULL);

    // kernel parameters and local memory size
    clarg_set (ctx, krn, 0, raster_res);
    clarg_set (ctx, krn, 1, ncols);
    clarg_set (ctx, krn, 4, rx_height);
    clarg_set (ctx, krn, 5, frequency);
    clarg_set (ctx, krn, 6, ahr);

    size_t lmem_size = _HATA_GPU_WITEM_PER_DIM_ *
                       _HATA_GPU_WITEM_PER_DIM_ *
                       sizeof(cl_float2);

    if (lmem_size > _HATA_GPU_MAX_LOCAL_MEM_)
        G_fatal_error ("Allocated local memory (%d) exceeds %d bytes.", lmem_size,
                                                                        _HATA_GPU_MAX_LOCAL_MEM_);
    clarg_set_local (ctx, krn, 9, lmem_size);

    // transfer data to the device
    clmsync (ctx, 0, dem_in, CL_MEM_DEVICE|CL_EVENT_NOWAIT);

    // set remaining kernel parameters
    clarg_set_global (ctx, krn, 7, dem_in);
    clarg_set_global (ctx, krn, 8, pl_out);

    G_message ("Simulating path losses ...");

    /* for each transmitter */
    for (i = 0; i < ntest_tx; i++)
    {
        // display completion percentage 
        G_percent (i, ntest_tx, 1);

        // reset memory for the path loss matrix
        alloc_raster (ctx, 
                      global_wsize,
                      global_wsize,
                      rtype,
                      _HATA_MAX_PATH_LOSS_,
                      pl_out);

        // transfer data to the device 
        clmsync (ctx, 0, pl_out, CL_MEM_DEVICE|CL_EVENT_WAIT);

        // transmitter data
        cl_int4 tx_data = (cl_int4) {test_tx[i].x,
                                     test_tx[i].y,
                                     (int) dem_in[test_tx[i].y*ncols + test_tx[i].x],
                                     tx_anthena_height};

        G_message ("The transmitter is located at %d,%d,%d", tx_data.x,
                                                             tx_data.y,
                                                             tx_data.z);
        // tile offset within the raster
        cl_int2 tx_offset = (cl_int2) {tx_data.x - radius,
                                       tx_data.y - radius};

        // set (more) remaining kernel parameters
        clarg_set (ctx, krn, 2, tx_data);
        clarg_set (ctx, krn, 3, tx_offset);

        // start kernel execution 
        clfork (ctx, 0, krn, &ndr, CL_EVENT_NOWAIT);
        clwait (ctx, 0, CL_KERNEL_EVENT|CL_MEM_EVENT|CL_EVENT_RELEASE);

        // sync memory 
        clmsync (ctx, 0, pl_out, CL_MEM_HOST|CL_EVENT_WAIT);

        // write the calculation output 
        sprintf (raster_outname, "%s_%d", outname, i);
        save_raster_to_file (raster_outname, pl_out,
                             tx_offset.x, tx_offset.y,
                             global_wsize,
                             global_wsize,
                             ncols, nrows);
    }

    // free allocated resources
    free (raster_outname);
    clclose (ctx, h);
    clfree (pl_out);
    clfree (dem_in);

    return (global_wsize*global_wsize);
}

