/* 
 * The path loss constants define the path loss scale used to convert
 * the resulting dB in a real number. They are directly related
 * to the value of gamma_c of formula (1) in Benedičič et al. (2010).
 */
#define _HATA_MIN_PATH_LOSS_    1
#define _HATA_MAX_PATH_LOSS_    155

/*
 * The maximum cell power of a single cell (all channels included) in Watts.
 * This constant is used to calculate interference.
 */
#define _HATA_MAX_CELL_POWER_   19.95f




/**
 * Calculates the interference matrix for an area by accumulating the 
 * path loss for each transmitter using Hata's model for urban areas. 
 * All coordinates are expressed in raster cells.
 *
 * int ncols ............ total number of columns in the area.
 * int4 tx_data ......... coordinates, elevation and anthenna height of 
 *                        the transmitter.
 * int2 tx_offset ....... offset of the current transmitter within the
 *                        area, including the calculation radius.
 * float rx_height ...... height of the receiver above ground (in mts).
 * float frequency ...... transmitter frequency in Mhz.
 * float ahr ............ a constant part of Hata's formula.
 * __gl float dem_in .... digital elevation model data for the area.
 * __gl float qrm_out ... interference matrix where the results are
 *                        accumulated. It should be initialized with the
 *                        thermal noise before the first call.
 * __lo float2 pblock ... local memory used to speed up the whole process.
 *                        Intermediate numbers, like distance and height,
 *                        are saved here.
 */
__kernel void hata_urban_interference (const int ncols, 
                                       const int4 tx_data, const int2 tx_offset,
                                       const float rx_height, const float frequency, 
                                       const float ahr,
                                       __global float *dem_in,
                                       __global float *qrm_out,
                                       __local float2 *pblock)
{
    float dist, height_diff;

    /* cell coordinates */
    float2 ccoord = (float2) (tx_offset.x + get_global_id(0),
                              tx_offset.y + get_global_id(1));

    int element_idx = ccoord.y * ncols + ccoord.x;
    
    // calculate the distance using the raster coordinates
    dist = (tx_data.x - ccoord.x) * (tx_data.x - ccoord.x);
    dist += (tx_data.y - ccoord.y) * (tx_data.y - ccoord.y);
    // transform distance to km 
    dist = sqrt (dist) / 10.0f;

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
    uint local_idx = get_local_id(1) * get_local_size(0) + get_local_id(0);
    pblock[local_idx] = (float2) (dist, height_diff);

    // wait for other work items to cache their values
    barrier (CLK_LOCAL_MEM_FENCE);

    // ignore if the distance between tx and rx is less than 10m
    if (pblock[local_idx].x > 0.01f)
    {
        /* Urban path loss in dB */
        float pl_db = (float) 69.55f + 26.16f*log10(frequency) - 
                      13.82f*log10(pblock[local_idx].y) - ahr +
                      (44.9f-6.55f*log10(pblock[local_idx].y))*
                      log10(pblock[local_idx].x);

        /* Transform it to a real number */
        pl_db = (float) pl_db / 
                (_HATA_MAX_PATH_LOSS_ - _HATA_MIN_PATH_LOSS_);

        qrm_out[element_idx] += pl_db * _HATA_MAX_CELL_POWER_;
    }
}



/**
 * Calculates the path loss matrix for one transmitter using Hata's model
 * for urban areas. All coordinates are expressed in raster cells.
 *
 * int ncols ............ total number of columns in the area.
 * int4 tx_data ......... coordinates, elevation and anthenna height of 
 *                        the transmitter.
 * int2 tx_offset ....... offset of the current transmitter within the
 *                        area, including the calculation radius.
 * float rx_height ...... height of the receiver above ground (in mts).
 * float frequency ...... transmitter frequency in Mhz.
 * float ahr ............ a constant part of Hata's formula.
 * __gl float dem_in .... digital elevation model data for the area.
 * __gl float pl_out .... path loss matrix where the results are saved.
 * __lo float2 pblock ... local memory used to speed up the whole process.
 *                        Intermediate numbers, like distance and height,
 *                        are saved here.
 */
__kernel void hata_urban_kern_per_tx (const int ncols, 
                                      const int4 tx_data, const int2 tx_offset,
                                      const float rx_height, const float frequency, 
                                      const float ahr,
                                      __global float *dem_in,
                                      __global float *pl_out,
                                      __local float2 *pblock)
{
    float dist, height_diff;

    /* cell coordinates */
    float2 ccoord = (float2) (tx_offset.x + get_global_id(0),
                              tx_offset.y + get_global_id(1));

    int element_idx = ccoord.y * ncols + ccoord.x;
    
    // calculate the distance using the raster coordinates
    dist = (tx_data.x - ccoord.x) * (tx_data.x - ccoord.x);
    dist += (tx_data.y - ccoord.y) * (tx_data.y - ccoord.y);
    // transform distance to km 
    dist = sqrt (dist) / 10.0f;

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
    uint local_idx = get_local_id(1) * get_local_size(0) + get_local_id(0);
    pblock[local_idx] = (float2) (dist, height_diff);

    // wait for other work items to cache their values
    barrier (CLK_LOCAL_MEM_FENCE);

    // ignore if the distance between tx and rx is less than 10m
    if (pblock[local_idx].x > 0.01f)
    {
        /* Urban path loss in dB */ 
        pl_out[element_idx] = (float) 69.55f + 26.16f*log10(frequency) - 
                              13.82f*log10(pblock[local_idx].y) - ahr +
                              (44.9f-6.55f*log10(pblock[local_idx].y))*
                              log10(pblock[local_idx].x);

        /* Transform it to a real number */
        pl_out[element_idx] = (float) pl_out[element_idx] / 
                              (_HATA_MAX_PATH_LOSS_ - _HATA_MIN_PATH_LOSS_);
                                                        
    }
}



/**
 * Calculates the path loss matrix of one transmitter using Hata's model
 * for urban areas. The dimension of dem_out is equal to that of dem_in.
 *
 * int ncols ............ total number of columns in the area.
 * int4 tx_data ......... coordinates, elevation and anthenna height of 
 *                        the transmitter.
 * int2 tx_offset ....... offset of the current transmitter within the
 *                        area, including the calculation radius.
 * float rx_height ...... height of the receiver above ground (in mts).
 * float frequency ...... transmitter frequency in Mhz.
 * float ahr ............ a constant part of Hata's formula.
 * __gl float dem_in .... digital elevation model data for the area.
 * __gl float dem_out ... common path loss matrix where the results are
 *                        saved. The minimum is taken between two already
 *                        existing values.
 * __lo float2 pblock ... local memory used to speed up the whole process.
 *                        Intermediate numbers, like distance and height,
 *                        are saved here.
 */
__kernel void hata_urban_kern (const int ncols, 
                               const int4 tx_data, const int2 tx_offset,
                               const float rx_height, const float frequency, 
                               const float ahr,
                               __global float *dem_in,
                               __global float *dem_out,
                               __local float2 *pblock)
{
    float dist, height_diff;

    /* cell coordinates */
    float2 ccoord = (float2) (tx_offset.x + get_global_id(0),
                              tx_offset.y + get_global_id(1));

    int element_idx = ccoord.y * ncols + ccoord.x;
    
    // calculate the distance using the raster coordinates
    dist = (tx_data.x - ccoord.x) * (tx_data.x - ccoord.x);
    dist += (tx_data.y - ccoord.y) * (tx_data.y - ccoord.y);
    // transform distance to km 
    dist = sqrt (dist) / 10.0f;

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
    uint local_idx = get_local_id(1) * get_local_size(0) + get_local_id(0);
    pblock[local_idx] = (float2) (dist, height_diff);

    // wait for other work items to cache their values
    barrier (CLK_LOCAL_MEM_FENCE);

    // ignore if the distance between tx and rx is less than 10m
    if (pblock[local_idx].x > 0.01f)
    {
        // Urban path loss 
        if (isnan(dem_out[element_idx]))
        {
            dem_out[element_idx] = 69.55f + 26.16f*log10(frequency) - 
                                   13.82f*log10(pblock[local_idx].y) - ahr +
                                   (44.9f-6.55f*log10(pblock[local_idx].y))*
                                   log10(pblock[local_idx].x);
        }
        else
        {
            float pl =  69.55f + 26.16f*log10(frequency) -
                        13.82f*log10(pblock[local_idx].y) - ahr +
                        (44.9f-6.55f*log10(pblock[local_idx].y))*
                        log10(pblock[local_idx].x);
            dem_out[element_idx] = (dem_out[element_idx] < pl)? dem_out[element_idx] : pl;
        }
    }
}




/**
 * A naive implementation of Hata's model for urban areas. It calculates
 * the path loss matrix of one transmitter. The dimension of dem_out is 
 * equal to that of dem_in.
 */
__kernel void hata_kern_no_local_mem (const float tx_coord_col, const float tx_coord_row,
                                      const int tx_elevation, const int tx_anthena_height,
                                      const float rx_height, const float frequency, 
                                      __global float *dem_in,
                                      __global float *dem_out)
{
    float dist, height_diff;

    int tsize_cols = get_global_size (1);
    int tid_row = get_global_id (0);
    int tid_col = get_global_id (1);
    int element_idx = tid_row * tsize_cols + tid_col;
 
    /* calculate the distance using the raster coordinates */ 
    dist = (tx_coord_col - tid_col) * (tx_coord_col - tid_col);
    dist += (tx_coord_row - tid_row) * (tx_coord_row - tid_row);

    /* transform distance to km */
    dist = sqrt (dist) / 10.0f;

    /* ignore if the distance between tx and rx is less than 10m */
    if ((dist > 0.01f))
    {
        /* effective height between tx and rx */
        if ((float)tx_elevation > (float)dem_in[element_idx])
        {
            height_diff = tx_elevation + tx_anthena_height;
            height_diff -= dem_in[element_idx] + rx_height;
        }
        else
        {
            height_diff = tx_anthena_height;
        }

        height_diff = fabs (height_diff);

        /* correction factor ahr */
        float ahr = (1.1f*log10(frequency) - 0.7f)*rx_height - 
                    (1.56f*log10(frequency) - 0.8f);

        /* Urban path loss */ 
        dem_out[element_idx] = 69.55f + 26.16f*log10(frequency) - 
                               13.82f*log10(height_diff) - ahr +
                               (44.9f-6.55f*log10(height_diff))*log10(dist);
    }
}



/**
 * This kernel calculates the distance between a transmitter and all
 * points within the given DEM (i.e. dem_in).
 */
__kernel void dist_height_kern (const int tx_coord_x, const int tx_coord_y,
                                const int tx_total_height, const float rx_height,
                                __global float *dem_in,
                                __global float *dem_out,
                                __local float *pblock)
{
    float dist, height_diff;

    int tsize_x = get_global_size (0);
    int tid_x = get_global_id (0);
    int tid_y = get_global_id (1);
    int element_idx = tid_y * tsize_x + tid_x;
    
    dist = (tx_coord_x - tid_x) * (tx_coord_x - tid_x);
    dist += (tx_coord_y - tid_y) * (tx_coord_y - tid_y);
    /* transform distance to mts */
    dist = sqrt (dist) * 100;

    height_diff = tx_total_height - rx_height - dem_in[element_idx];

    dem_out[element_idx] = height_diff;
}



__kernel void example_nbody_kern (float dt1, float eps,
                                   __global float *pos_old,
                                   __global float *pos_new,
                                   __global float *vel,
                                   __local float *pblock)
{
    const float dt = dt1;

    int gti = get_global_id (0);
    int ti = get_local_id (0);

    int n = get_global_size(0);
    int nt = get_local_size(0);
    int nb = n/nt;

    float p = pos_old[gti];
    float v = vel[gti];

    float a = 0.0f;

    // For each block ... 
    for (int jb=0; jb<nb; jb++)
    {
        // cache one particle position 
        pblock[ti] = pos_old[jb*nt + ti];
        // wait for others in the work group to cache their positions 
        barrier (CLK_LOCAL_MEM_FENCE);

        // For all cached particles positions 
        for (int j=0; j<nt; j++)
        {
            // read a cached particle position
            float p2 = pblock[j];
            float d = p2 - p;
            float invr = rsqrt (d*d + eps);
            float f = p2 * invr * invr * invr;
            
            // accumulate acceleration
            a += f*d;
        }

        // wait for others in the work group to finish their calculations
        barrier (CLK_LOCAL_MEM_FENCE);
    }

    p += dt*v + 0.5f*dt*dt*a;
    v += dt*a;

    pos_new[gti] = p;
    vel[gti] = v;
}

