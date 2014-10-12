#include "prot.h"
#include "random.cl"





/**
 * Implements an autonomous agent optimizing the service area.
 * Agent behavior is explained in the README file.
 *
 * int ntx .................. number of transmitters being processed. This
 *                            is the length of the 'tx_pwr' vector and the
 *                            depth of the 'pl_in' cube.
 * int ncols ................ total number of columns in the area.
 * int4 mdim ................ area widthin which the agents may move.
 * int uncovered count ...... number of uncovered raster cells.
 * __gl u char pl_in ........ 3D matrix containing path-loss values in dB
 *                            (i.e. between 0 and 255) for every coordinate
 *                            (2D) and each of the 'ntx' transmitters (3rd
 *                            dimension) in the area.
 * __gl int4 offsets_in ..... vector of tuples containing the offsets for
 *                            each of the path-loss matrices (col-min, 
 *                            row-min, width, height).
 * __gl float qrm_in ........ 2D matrix containing interference values for
 *                            every coordinate in the area.
 * __gl float cov_in ........ 2D matrix containing the service area coverage.
 * __gl short uncov_coord_in. a vector containing coordinates of uncovered 
 *                            raster cells.
 * __gl int tx_pwr .......... pilot powers for 'ntx' transmitters (in 
 *                            milliwatts).
 * __lo float pblock ........ local memory used to speed up the whole 
 *                            process. The new pilot powers with the 
 *                            transmitter IDs are saved here.
 */
__kernel void agent_kern (const int ntx,
                          const int ncols,
                          const int4 mdim,
                          const int uncovered_count,
                          __global unsigned char *pl_in,
                          __global int4 *offsets_in,
                          __global float *qrm_in,
                          __global float *cov_in,
                          __global unsigned short *uncov_coord_in,
                          __global int *tx_pwr,
                          __local unsigned short *pblock)
{
    int tx;
    int idx_thread = get_local_id(0);
    int2 ccoord = (int2) (-1, -1);

    // thread id as the random seed
    random_state randstate;
    seed_random (&randstate, idx_thread);

    // is this a special agent?
    if ((idx_thread % 2) == 0)
    {
        // randomly select a non-covered pixel
        // from the uncovered coordinates
        if (uncovered_count > 0)
        {
            int idx_coord = (int) (random(&randstate) % uncovered_count);
            ccoord.x = (int) uncov_coord_in[2*idx_coord];
            ccoord.y = (int) uncov_coord_in[2*idx_coord+1];
        }
    }
    // already have a coordinate?
    if (ccoord.x < 0)
    {
        // select a random coordinate from the whole area
        ccoord.x = (int) (random(&randstate) % (mdim.z - mdim.x));
        ccoord.x += mdim.x;
        ccoord.y = (int) (random(&randstate) % (mdim.w - mdim.y));
        ccoord.y += mdim.y;
    }

    int idx_2d = ccoord.y * ncols + ccoord.x;
    // is this coordinate under network coverage?
    if (cov_in[idx_2d] < _AG_MINIMUM_GAMMA_COVERAGE_)
    {
        // coordinate NOT covered, analyze signals
        float2 max_signal = (float2) (-1.0f, _AG_EMPTY_VALUE_);

        for (tx = 0; tx < ntx; tx++)
        {
            int idx_pl = (ccoord.y - offsets_in[tx].y) * offsets_in[tx].z;
            idx_pl += ccoord.x - offsets_in[tx].x;
            
            float pl_value = (float) pl_in[idx_pl];

            // transform the path loss to a linear scale
            if (pl_value > _HATA_MAX_PATH_LOSS_)
                pl_value = _HATA_MAX_PATH_LOSS_;
        
            pl_value = (float) 1.0f - (pl_value /
                       (_HATA_MAX_PATH_LOSS_ - _HATA_MIN_PATH_LOSS_));
          
            // calculate gamma at this coordinate for this transmitter
            pl_value = ((tx_pwr[tx]/1000.0f) * pl_value) / qrm_in[idx_2d];

            // keep the maximum signal
            if (max_signal.y < pl_value)
            {
                max_signal.x = (float) tx;
                max_signal.y = pl_value;
            }
        }
        // raise pilot power of the transmitter with max rcv signal
        int tx_id = (int) max_signal.x;
        float tx_new_pwr = _AG_INCREASE_PILOT_DB_ / 10.0f;
        tx_new_pwr = pow(10, tx_new_pwr);

        // save it to local memory
        pblock[2*idx_thread] = tx_id;
        pblock[2*idx_thread+1] = (unsigned short) (tx_new_pwr*tx_pwr[tx_id]);
    }
    else
    {
        // coordinate covered, analyze signals
        float2 min_signal = (float2) (-1.0f, _AG_EMPTY_VALUE_ * -1);

        for (tx = 0; tx < ntx; tx++)
        {
            int idx_pl = (ccoord.y - offsets_in[tx].y) * offsets_in[tx].z;
            idx_pl += ccoord.x - offsets_in[tx].x;
            
            float pl_value = (float) pl_in[idx_pl];

            // transform the path loss to a linear scale
            if (pl_value > _HATA_MAX_PATH_LOSS_)
                pl_value = _HATA_MAX_PATH_LOSS_;
        
            pl_value = (float) 1.0f - (pl_value /
                       (_HATA_MAX_PATH_LOSS_ - _HATA_MIN_PATH_LOSS_));
          
            // calculate gamma at this coordinate for this transmitter
            pl_value = ((tx_pwr[tx]/1000.0f) * pl_value) / qrm_in[idx_2d];

            // keep the minimum signal
            if (min_signal.y > pl_value)
            {
                min_signal.x = (float) tx;
                min_signal.y = pl_value;
            }
        }
        // lower pilot power of the transmitter with min rcv signal
        int tx_id = (int) min_signal.x;
        float tx_new_pwr = _AG_DECREASE_PILOT_DB_ / 10.0f;
        tx_new_pwr = pow(10, tx_new_pwr);

        // save it to local memory
        pblock[2*idx_thread] = (unsigned short) tx_id;
        pblock[2*idx_thread+1] = (unsigned short) (tx_new_pwr*tx_pwr[tx_id]);
    }
    // wait for all other threads to finish
    barrier (CLK_LOCAL_MEM_FENCE);

    // save all the results at once
    int idx_local = pblock[2*idx_thread];

    // FIXME multiply this value by -1 and correct the coverage kernel!
    tx_pwr[idx_local] = pblock[2*idx_thread+1]; // * -1;
}




/**
 * Calculates the coverage in the current area, by searching/analyzing
 * 3D cubes of path loss matrices and interference. The kernel is 
 * limited by the amount of memory on the GPU. It uses a scattered 
 * approach (by Hwu), i.e. output aligned, and local memory to reach
 * as many GFlops as possible.
 *
 * int ntx .................. number of transmitters being processed. This
 *                            is the length of the 'tx_pwr' vector and the
 *                            depth of the 'pl_in' cube.
 * int ncols ................ total number of columns in the area.
 * __gl u char pl_in ........ 3D matrix containing path-loss values in dB
 *                            (i.e. between 0 and 255) for every coordinate
 *                            (2D) and each of the 'ntx' transmitters (3rd
 *                            dimension) in the area.
 * __gl int4 offsets_in ..... vector of tuples containing the offsets for
 *                            each of the path-loss matrices (col-min, 
 *                            row-min, width, height).
 * __gl float qrm_in ........ 2D matrix containing interference values for
 *                            every coordinate in the area.
 * __gl int tx_pwr_in ....... pilot powers for 'ntx' transmitters (in 
 *                            milliwatts).
 * __gl float cov_out ....... coverage matrix where the results are saved.
 * __gl short cov_ctr_out ... coverage count vector, containing the number of
 *                            uncovered raster cells.
 * __gl short cov_coord_out . a vector containing coordinates of uncovered 
 *                            raster cells. Only some, randomly-selected,
 *                            coordinates are saved here.
 * int lmem_ctr_offset ...... the beggining of the uncovered counters within
 *                            local memory.
 * int lmem_coord_offset .... the beggining of the uncovered coordinates 
 *                            within local memory.
 * __lo float pblock ........ local memory used to speed up the whole 
 *                            process. The best received energy at every 
 *                            coordinate is saved here. And flags to count
 *                            the number of uncovered coordinates.
 */
__kernel void coverage_kern (const int ntx,
                             const int ncols,
                             __global unsigned char *pl_in,
                             __global int4 *offsets_in,
                             __global float *qrm_in,
                             __global int *tx_pwr,
                             __global float *cov_out,
                             __global unsigned short *cov_ctr_out,
                             __global unsigned short *cov_coord_out,
                             const int lmem_ctr_offset,
                             const int lmem_coord_offset,
                             __local float *pblock)
{
    int tx;
    int2 ccoord = (int2) (get_global_id(0), get_global_id(1));
    int idx_2d = ccoord.y * ncols + ccoord.x;

    // we will calculate the maximum received energy at each coordinate
    uint idx_local = get_local_id(1) * get_local_size(0) + get_local_id(0);
    // initialize the gamma value for coverage
    pblock[idx_local] = (float) NAN;
    // initialize the uncovered counter
    pblock[lmem_ctr_offset + idx_local] = 0.0f;

    // first transmitter
    // make sure we have path loss data here ...
    if ((ccoord.x >= offsets_in[0].x) &&
       ((ccoord.x - offsets_in[0].x) < offsets_in[0].z))
    {
        if ((ccoord.y >= offsets_in[0].y) &&
           ((ccoord.y - offsets_in[0].y) < offsets_in[0].w))
        {
            int idx_pl = (ccoord.y - offsets_in[0].y) * offsets_in[0].z;
            idx_pl += ccoord.x - offsets_in[0].x;
            
            float pl_value = (float) pl_in[idx_pl];

            // transform the path loss to a linear scale
            if (pl_value > _HATA_MAX_PATH_LOSS_)
                pl_value = _HATA_MAX_PATH_LOSS_;
        
            pl_value = (float) 1.0f - (pl_value /
                       (_HATA_MAX_PATH_LOSS_ - _HATA_MIN_PATH_LOSS_));
          
            // calculate gamma at this coordinate for this transmitter
            pblock[idx_local] = ((tx_pwr[0]/1000.0f) * pl_value) / qrm_in[idx_2d];
        }
    }

    // for every other transmitter
    for (tx = 1; tx < ntx; tx++)
    {
        // make sure we have path loss data here ...
        if ((ccoord.x >= offsets_in[tx].x) &&
           ((ccoord.x - offsets_in[tx].x) < offsets_in[tx].z))
        {
            if ((ccoord.y >= offsets_in[tx].y) &&
               ((ccoord.y - offsets_in[tx].y) < offsets_in[tx].w))
            {
                int idx_pl = offsets_in[tx].z * offsets_in[tx].w * tx;
                idx_pl += (ccoord.y - offsets_in[tx].y) * offsets_in[tx].w;
                idx_pl += ccoord.x - offsets_in[tx].x;
                
                float pl_value = (float) pl_in[idx_pl];

                // transform the path loss to a linear scale
                if (pl_value > _HATA_MAX_PATH_LOSS_)
                    pl_value = _HATA_MAX_PATH_LOSS_;
            
                pl_value = (float) 1.0f - (pl_value /
                           (_HATA_MAX_PATH_LOSS_ - _HATA_MIN_PATH_LOSS_));
              
                // calculate gamma at this coordinate for this transmitter
                pl_value = ((tx_pwr[tx]/1000.0f) * pl_value) / qrm_in[idx_2d];
                
                // keep only the maximum value
                if (pl_value > pblock[idx_local])
                    pblock[idx_local] = pl_value;
            }
        }
    }
    // count uncovered coordinates
    if (pblock[idx_local] < _AG_MINIMUM_GAMMA_COVERAGE_)
    {
        pblock[lmem_ctr_offset + idx_local] = (float) ccoord.x;
        pblock[lmem_coord_offset + idx_local] = (float) ccoord.y;
    }
    // wait for other threads to finish
    barrier (CLK_LOCAL_MEM_FENCE);

    // save all the results at once (coalesced write!)
    cov_out[idx_2d] = pblock[idx_local];

    // save the reduction sum of uncovered pixels
    if (idx_local == 0)
    {
        int cov_ctr = 0;
        int2 cov_coord = (int2) {0, 0};
        int idx_reduced = get_global_id(1) / _HATA_GPU_WITEM_PER_DIM_;
        idx_reduced *= get_global_size(0) / _HATA_GPU_WITEM_PER_DIM_;
        idx_reduced += get_global_id(0) / _HATA_GPU_WITEM_PER_DIM_;
        int local_size = get_local_size(0) * get_local_size(1);

        for (tx = 0; tx < local_size; tx ++)
        {
            if (pblock[lmem_ctr_offset + tx] != 0.0f)
            {
                cov_ctr ++;
                cov_coord = (int2) {(int) pblock[lmem_ctr_offset + tx],
                                    (int) pblock[lmem_coord_offset + tx]};
            }
        }
        cov_ctr_out[idx_reduced] = cov_ctr;
        cov_coord_out[2*idx_reduced] = cov_coord.x;
        cov_coord_out[2*idx_reduced + 1] = cov_coord.y;
    }
}




/**
 * Calculates the interference matrix for an area by accumulating the 
 * path loss for each transmitter using Hata's model for urban areas. 
 * All coordinates are expressed in raster cells.
 *
 * int cell_res ......... size of one raster cell (in meters).
 * int ncols ............ total number of columns in the area.
 * int4 tx_data ......... coordinates, elevation and anthenna height of 
 *                        the transmitter (coordinates expressed in raster
 *                        cells).
 * int2 tx_offset ....... offset of the current transmitter within the
 *                        area, including the calculation radius (in raster
 *                        cells).
 * float rx_height ...... height of the receiver above ground (in mts).
 * float frequency ...... transmitter frequency in Mhz.
 * float ahr ............ a constant part of Hata's formula.
 * __gl float dem_in .... digital elevation model data for the area.
 * __gl float pl_out .... path loss matrix where the results are saved.
 * __lo float2 pblock ... local memory used to speed up the whole process.
 *                        Intermediate numbers, like distance and height,
 *                        are saved here.
 */
__kernel void hata_urban_interference (const int cell_res,
                                       const int ncols, 
                                       const int4 tx_data, const int2 tx_offset,
                                       const float rx_height, const float frequency, 
                                       const float ahr,
                                       __global float *dem_in,
                                       __global float *qrm_out,
                                       __local float2 *pblock)
{
    float dist, height_diff;

    // cell coordinates 
    int2 ccoord = (int2) (tx_offset.x + get_global_id(0),
                          tx_offset.y + get_global_id(1));
    uint element_idx = ccoord.y * ncols + ccoord.x;

    // calculate the distance using the raster coordinates
    dist = (tx_data.x - ccoord.x) * (tx_data.x - ccoord.x);
    dist += (tx_data.y - ccoord.y) * (tx_data.y - ccoord.y);
    dist = sqrt(dist) * cell_res;

    // correct the distance if it is smaller than 10m
    if (dist < 10.0f)
        dist = cell_res / 2.0f;

    // transform distance to km 
    dist /= 1000.0f;
   
    // effective height between tx and rx
    if ((float)tx_data.z > (float)dem_in[element_idx])
    {
        height_diff = tx_data.z + tx_data.w;
        height_diff -= dem_in[element_idx] + rx_height;
    }
    else
    {
        height_diff = tx_data.w;
    }

    // cache the distance and height difference
    uint local_idx = get_local_id(1) * get_local_size(0) + 
                     get_local_id(0);
    pblock[local_idx] = (float2) (dist, height_diff);

    // wait for other work items to cache their values
    barrier (CLK_LOCAL_MEM_FENCE);

    // urban path loss in dB 
    float pl_db = (float) 69.55f + 26.16f*log10(frequency) - 
                  13.82f*log10(pblock[local_idx].y) - ahr +
                  (44.9f-6.55f*log10(pblock[local_idx].y))*
                  log10(pblock[local_idx].x);

    // transform the path-loss to a linear scale
    if (pl_db > _HATA_MAX_PATH_LOSS_)
        pl_db = _HATA_MAX_PATH_LOSS_;

    pl_db = (float) 1.0f - (pl_db / 
            (_HATA_MAX_PATH_LOSS_ - _HATA_MIN_PATH_LOSS_));

    qrm_out[element_idx] += pl_db * _HATA_MAX_CELL_POWER_;
}



/**
 * Calculates the path loss matrix for one transmitter using Hata's model
 * for urban areas. All coordinates are expressed in raster cells.
 *
 * int cell_res ......... size of one raster cell (in meters).
 * int ncols ............ total number of columns in the area.
 * int4 tx_data ......... coordinates, elevation and anthenna height of 
 *                        the transmitter (coordinates expressed in raster
 *                        cells).
 * int2 tx_offset ....... offset of the current transmitter within the
 *                        area, including the calculation radius (in raster
 *                        cells).
 * float rx_height ...... height of the receiver above ground (in mts).
 * float frequency ...... transmitter frequency in Mhz.
 * float ahr ............ a constant part of Hata's formula.
 * __gl float dem_in .... digital elevation model data for the area.
 * __gl float pl_out .... path loss matrix where the results are saved.
 * __lo float2 pblock ... local memory used to speed up the whole process.
 *                        Intermediate numbers, like distance and height,
 *                        are saved here.
 */
__kernel void hata_urban_kern_per_tx (const int cell_res,
                                      const int ncols, 
                                      const int4 tx_data, const int2 tx_offset,
                                      const float rx_height, const float frequency, 
                                      const float ahr,
                                      __global float *dem_in,
                                      __global float *pl_out,
                                      __local float2 *pblock)
{
    float dist, height_diff;

    // cell coordinates 
    int2 ccoord = (int2) (tx_offset.x + get_global_id(0),
                          tx_offset.y + get_global_id(1));
   
    // calculate the distance using the raster coordinates
    dist = (tx_data.x - ccoord.x) * (tx_data.x - ccoord.x);
    dist += (tx_data.y - ccoord.y) * (tx_data.y - ccoord.y);
    dist = sqrt(dist) * cell_res;

    // correct the distance if it is smaller than 10m
    if (dist < 10.0f)
        dist = cell_res / 2.0f;
    
    uint dem_idx = ccoord.y * ncols + ccoord.x;
    uint element_idx = get_global_id(1) * get_global_size(0) + 
                       get_global_id(0);

    // transform distance to km 
    dist /= 1000.0f;
   
    // effective height between tx and rx
    if ((float)tx_data.z > (float)dem_in[dem_idx])
    {
        height_diff = tx_data.z + tx_data.w;
        height_diff -= dem_in[dem_idx] + rx_height;
    }
    else
    {
        height_diff = tx_data.w;
    }

    // cache the distance and height difference
    uint local_idx = get_local_id(1) * get_local_size(0) + 
                     get_local_id(0);
    pblock[local_idx] = (float2) (dist, height_diff);

    // wait for other work items to cache their values
    barrier (CLK_LOCAL_MEM_FENCE);

    // urban path loss in dB
    pl_out[element_idx] = (float) 69.55f + 26.16f*log10(frequency) - 
                          13.82f*log10(pblock[local_idx].y) - ahr +
                          (44.9f-6.55f*log10(pblock[local_idx].y))*
                          log10(pblock[local_idx].x);

    /* transform path loss to a linear scale
    if (pl_db > _HATA_MAX_PATH_LOSS_)
        pl_db = _HATA_MAX_PATH_LOSS_;

    pl_out[element_idx] = (float) 1.0f - (pl_db / 
                          (_HATA_MAX_PATH_LOSS_ - _HATA_MIN_PATH_LOSS_));*/
}

