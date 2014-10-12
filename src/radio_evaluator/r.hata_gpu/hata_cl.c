
/****************************************************************************
 *
 * MODULE:       r.hata_gpu
 * AUTHOR(S):    Andrej Vilhar, Jozef Stefan Institute                
 *
 * PURPOSE:      Calculates radio coverage from a single base station 
 *               according to Hata model
 *             
 *
 * COPYRIGHT:    (C) 2009 Jozef Stefan Institute
 *
 * OpenCL CODE CONTRIBUTION BY Lucas Benedičič (lucas.benedicic@mobitel.si)
 *
 *****************************************************************************/

#define _HATA_WITEM_PER_DIM_                20
#define _HATA_MAX_LOCAL_MEM_                16384
#define _HATA_THERMAL_NOISE_                1.5488e-14

#include <stdlib.h>
#include <math.h>
#include <grass/gis.h>



/*
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

    clfreport_devinfo (stdout,ndev,dev_info);

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
        FCELL *dem_device = (FCELL *) clmalloc (ctx, 
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
            FCELL *offset = dem_device + row * ncols;

            if (offset != memcpy (offset, rastbuf, ncols * G_raster_size (rtype)))
                G_fatal_error ("Error while copying memory!");
        }

        /* free buffers */
        free (rastbuf);

        /* Return a pointer to the allocated resources */
        return dem_device;
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
        G_fatal_error ("Wrong element data type in 'null_raster'");
        return NULL;
    }
    else
    {
        FCELL *dem_device;

        if (alloc_ptr == NULL)
        {
            G_message ("Allocating NULL raster data into memory ...");

            /* allocate raster DEM data */
            dem_device = (FCELL *) clmalloc (ctx, 
                                   nrows * ncols * G_raster_size (rtype), 0);
        }
        else
        {
            G_message ("Resetting memory ...");
            dem_device = alloc_ptr;
        }

        /* Initialize the whole piece of memory */
        if (init_value == NAN)
        {
            G_set_f_null_value (dem_device, nrows * ncols);
        }
        else
        {
            for (i=0; i<nrows; i++)
            {
                for (j=0; j<ncols; j++)
                {
                    dem_device[i*ncols+j] = init_value;
                }
            }
        }

        /* Return a pointer to the allocated resources */
        return dem_device;
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



/*
 * Saves raster data pointed by 'rastdata', using the received file
 * descriptor. It returns the sum of all elements in 'rastdata'.
 *
 * FCELL *rastdata ........ raster data to be saved.
 * int nrows .............. the number of rows in the raster data.
 * int ncols .............. the number of columns in the raster data.
 * int outfd .............. file descriptor used for writing.
 *
 */
FCELL save_raster (FCELL *rastdata,
                   const int nrows, const int ncols, 
                   const int outfd)
{
    int row, col;
    FCELL ret_value = (FCELL) 0.0f;

    FCELL *rastbuf = malloc (ncols * G_raster_size (FCELL_TYPE));

    G_message ("Creating output raster from host memory ...");

    /* Save raster data row by row */
    for (row = 0; row < nrows; row++)
    {
        /* display completion percentage */
        G_percent (row, nrows, 2);
       
        for (col = 0; col<ncols; col++)
        {
            ((FCELL *) rastbuf)[col] = rastdata[row * ncols + col];

            if (! isnan(rastbuf[col]))
                ret_value += rastbuf[col];
        }

        if (G_put_raster_row (outfd, rastbuf, FCELL_TYPE) < 0)
            G_fatal_error ("Failed writing output raster map");
    }

    /* free buffers */
    free (rastbuf);

    return ret_value;
}



/*
 * Saves raster data pointed by 'rastdata' to a raster map named 'name'.
 * It returns the sum of all elements in 'rastdata'.
 *
 * char *name ............. the name of the raster map to where save to.
 * void *rastdata ......... raster data to be saved.
 * int nrows .............. the number of rows in the raster data.
 * int ncols .............. the number of columns in the raster data.
 *
 */
FCELL save_raster_to_file (const char *name,
                          FCELL *rastdata,
                          const int nrows, const int ncols)
{
    FCELL ret_value = (FCELL) 0.0f;

    /* output file descriptor */
    int outfd = G_open_raster_new (name, FCELL_TYPE);

    if (outfd < 0)
    {
        G_fatal_error("Unable to create raster map <%s>", name);
    }
    else
    {
        ret_value = save_raster (rastdata, nrows, ncols, outfd);
        G_close_cell (outfd);
    }

    return ret_value;
}




/*
 * Calculates an interference matrix resulting from the tx power of all
 * transmitters combined with their respective path losses and the thermal
 * noise. The output is saved in one raster map.
 *
 * int nrows .............. the number of rows in the DEM.
 * int ncols .............. the number of columns in the DEM.
 * int tx_coord_col ....... transmitter column coordinate (in raster cells).
 * int tx_coord_row ....... transmitter row coordinate (in raster cells).
 * int tx_elevation ....... transmitter height above sea level.
 * int anthena_height ..... height of transmitter anthena above ground.
 * float rx_height ........ receiver height above ground.
 * float frequency ........ transmitter frequency in Mhz.
 * int radius ............. calculation radius around to the transmitter
 *                          (in raster cells).
 * int infd ............... file descriptor to read from the DEM.
 * int outfd .............. file descriptor to write the interference
 *                          data to.
 * RASTER_MAP_TYPE rtype .. DEM element data type.
 *
 */
void hata_interference_cl (const int nrows, const int ncols,
                           const int tx_coord_col, const int tx_coord_row,
                           const int tx_elevation, const int tx_anthena_height,
                           const float rx_height, const float frequency,
                           const int radius,
                           const int infd, const int outfd, 
                           RASTER_MAP_TYPE rtype)
{
    int i;

    /* number of processing tiles needed around each transmitter */
    int ntile = (radius*2) / _HATA_WITEM_PER_DIM_ + 1;

    G_message ("Receiver height above ground is %5.2f mts", rx_height);
    G_message ("Transmitter frequency is %7.2f Mhz", frequency);
    G_message ("Calculation radius is %d raster cells", radius);

    CONTEXT * ctx = init_context ( );

    /* initialize raster data */
    void *dem_in = load_raster (ctx, nrows, ncols, infd, rtype);

    /* interference matrix */
    void *qrm_out = alloc_raster (ctx, nrows, ncols, rtype, 
                                  (FCELL)_HATA_THERMAL_NOISE_, NULL);

    /* load, compile and link the OpenCL kernel file */
    void* h = clopen (ctx, NULL, CLLD_NOW);

    /* select a kernel function from the loaded file */
    cl_kernel krn = clsym (ctx, h, "hata_urban_interference", CLLD_NOW);

    /* defines a 2D matrix of work groups & work items */
    size_t global_wsize = ntile * _HATA_WITEM_PER_DIM_;
    size_t local_wsize = _HATA_WITEM_PER_DIM_;

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

    /* set kernel parameters and local memory size */
    clarg_set (ctx, krn, 0, ncols);
    clarg_set (ctx, krn, 3, rx_height);
    clarg_set (ctx, krn, 4, frequency);
    clarg_set (ctx, krn, 5, ahr);

    size_t lmem_size = _HATA_WITEM_PER_DIM_*_HATA_WITEM_PER_DIM_*
                       sizeof(cl_float2);

    if (lmem_size > _HATA_MAX_LOCAL_MEM_)
        G_fatal_error ("Allocated local memory (%d) exceeds %d bytes.", lmem_size,
                                                                        _HATA_MAX_LOCAL_MEM_);

    clarg_set_local (ctx, krn, 8, lmem_size);

    /* transfer data to the device */
    clmsync (ctx, 0, dem_in, CL_MEM_DEVICE|CL_EVENT_NOWAIT);
    clmsync (ctx, 0, qrm_out, CL_MEM_DEVICE|CL_EVENT_WAIT);

    /* set remaining kernel parameters */
    clarg_set_global (ctx, krn, 6, dem_in);
    clarg_set_global (ctx, krn, 7, qrm_out);

    G_message ("Simulating ...");

    /**
     * Test transmitters 
     * 
     * ASNEBE  | 1468 | 1200
     * ASKZK   | 1395 | 1180
     * ALEK    | 1408 | 1211
     * ANDREJ  | 1431 | 1212
     * AMALENA | 1462 | 1272
     * APOLJE  | 1483 | 1227
     * AMONS   | 1381 | 1230
     * ANTENA  | 1397 | 1238
     * ATOMAC  | 1443 | 1194
     * ATUNEL  | 1424 | 1239
     * AKOSET  | 1398 | 1206
     * ASPAR   | 1400 | 1245
     * ACHEMO  | 1431 | 1226
     * ALIVAD  | 1423 | 1248
     * ASMARG  | 1460 | 1203
     * ABTC    | 1451 | 1215
     * AZIMA   | 1471 | 1236
     * ASTARA  | 1422 | 1235
     * AVEGAS  | 1434 | 1257
     * APOVSE  | 1436 | 1232
     * ABTCST  | 1449 | 1213
     * AMOBI   | 1429 | 1222
     * APODUT  | 1378 | 1202
     * AOBZEL  | 1444 | 1222
     * AGRIC   | 1385 | 1207
     * ADELO   | 1421 | 1222
     * AJEZA   | 1459 | 1182
     * ASKZ    | 1396 | 1181
     * ATLK    | 1422 | 1225
     * AGR     | 1424 | 1220
     * ADNEVN  | 1426 | 1232
     * AMHOTE  | 1409 | 1212
     * AVIC    | 1414 | 1236
     * AJOZEF  | 1429 | 1234
     * ATVSLO  | 1425 | 1228
     * ACRNUC  | 1445 | 1172
     * ANGEL   | 1508 | 1219
     * AKOSEG  | 1401 | 1210
     * AMSC    | 1429 | 1222
     * AGRAM   | 1421 | 1195
     * ARAKTK  | 1436 | 1249
     * AIMKO   | 1445 | 1179
     * AKOVIN  | 1412 | 1214
     * ADOLGI  | 1388 | 1250
     * APETER  | 1431 | 1231
     * ASENTP  | 1387 | 1185
     * AOBI    | 1443 | 1268
     * AMZS    | 1427 | 1203
     * AVICTK  | 1403 | 1240
     * AZUR    | 1397 | 1238
     * AKAMNA  | 1388 | 1200
     * APOLCE  | 1482 | 1228
     * AKASEL  | 1497 | 1232
     * ASISKP  | 1399 | 1189
     * AKOZAR  | 1373 | 1247
     * ASEME   | 1448 | 1262
     * AURSKA  | 1424 | 1220
     * ABEZIT  | 1427 | 1199
     * AVEROV  | 1416 | 1201
     * ATEGR   | 1419 | 1209
     * ATRUB   | 1423 | 1231
     * AKOLIN  | 1436 | 1221
     * AVELAN  | 1439 | 1218
     * ABEZI   | 1431 | 1216
     * AGAMGD  | 1418 | 1148
     * AGURS   | 1431 | 1237
     * AGPG    | 1419 | 1237
     * AKOSME  | 1397 | 1210
     * AZALOG  | 1500 | 1225
     * ASOSTR  | 1498 | 1253
     * AROZNA  | 1404 | 1235
     * AVRHO   | 1380 | 1242
     * ARAK    | 1430 | 1244
     * AVILA   | 1404 | 1230
     * AKOLEZ  | 1413 | 1241
     * AJEZKZ  | 1427 | 1185
     * AVIZMA  | 1386 | 1173
     * AKOTNI  | 1429 | 1226
     * AMOSTE  | 1443 | 1227
     * ATOPNI  | 1425 | 1212
     * AGZ     | 1429 | 1209
     * APRZAC  | 1386 | 1192
     * ALITIJ  | 1455 | 1235
     * ATEHNO  | 1387 | 1233
     * ASMELT  | 1429 | 1196
     * ACRGMA  | 1439 | 1166
     * AFORD   | 1439 | 1215
     * ADRAVC  | 1396 | 1197
     * ABROD   | 1388 | 1168
     * ATABOR  | 1429 | 1228
     * ATRNOV  | 1421 | 1242
     * AGOLOV  | 1467 | 1263
     * ARESEV  | 1438 | 1228
     * ABTCMI  | 1450 | 1216
     * ASMART  | 1446 | 1213
     * APROGA  | 1382 | 1251
     * ABRDO   | 1382 | 1235
     * AKONEX  | 1387 | 1237
     * AZITO   | 1456 | 1213
     * ASLOM   | 1425 | 1226
     * APLAMA  | 1448 | 1202
     * AGRAD   | 1470 | 1218
     * AFUZIN  | 1463 | 1228
     * ASAZU   | 1421 | 1235
     * ATOTRA  | 1463 | 1233
     * AHALA   | 1414 | 1221
     * ASONCE  | 1433 | 1208
     * ALMLEK  | 1422 | 1202
     * ACERNE  | 1415 | 1212
     * ADRAV   | 1396 | 1201
     * ALGRAD  | 1424 | 1234
     * ALPP    | 1406 | 1205
     * ANAMA   | 1420 | 1231
     * ATIVO   | 1418 | 1226
     * AZAPUZ  | 1392 | 1196
     * ASMAR   | 1404 | 1150
     * ACANK   | 1416 | 1233
     * ATACGD  | 1390 | 1156
     * APOPTV  | 1435 | 1211
     * AFRANK  | 1417 | 1220
     * ASTEP   | 1450 | 1235
     * AEJATA  | 1445 | 1218
     * AZADOB  | 1482 | 1206
     * AELNA   | 1436 | 1177
     * AZELEZ  | 1428 | 1218
     * AMURGL  | 1415 | 1246
     * ACIGO   | 1423 | 1225
     * AIJS    | 1407 | 1241
     * AELOK   | 1459 | 1225
     * ATACBR  | 1385 | 1160
     * AJELSA  | 1416 | 1259
     * AVRHOV  | 1394 | 1242
     * ABIZOV  | 1472 | 1247
     * ACITYP  | 1454 | 1214
     * ASAVLJ  | 1417 | 1182
     * AKLINI  | 1434 | 1228
     * AKODEL  | 1439 | 1236
     * ASTOZI  | 1436 | 1198
     * AKORA   | 1422 | 1226
     * AHLEV   | 1388 | 1163
     * ATOPLA  | 1451 | 1224
     * AMALEN  | 1461 | 1273
     * AVECNA  | 1391 | 1222
     * ANADGO  | 1462 | 1178
     * ABOKAL  | 1379 | 1231
     * AVARNO  | 1404 | 1250
     * ASTRAL  | 1422 | 1227
     * AVEVCE  | 1488 | 1234
     * ARNC    | 1423 | 1225
     * AGEOPL  | 1406 | 1198
     * AMOBLI  | 1415 | 1200
     * AVLADA  | 1415 | 1234
     * ASTEG   | 1404 | 1193
     * AKOSEZ  | 1392 | 1207
     */

    const int ntest_tx = 154;
    cl_int2 *test_tx = malloc (ntest_tx * sizeof(cl_int2));

    test_tx[0] = (cl_int2) {1468,1200};
    test_tx[1] = (cl_int2) {1395,1180};
    test_tx[2] = (cl_int2) {1408,1211};
    test_tx[3] = (cl_int2) {1431,1212};
    test_tx[4] = (cl_int2) {1462,1272};
    test_tx[5] = (cl_int2) {1483,1227};
    test_tx[6] = (cl_int2) {1381,1230};
    test_tx[7] = (cl_int2) {1397,1238};
    test_tx[8] = (cl_int2) {1443,1194};
    test_tx[9] = (cl_int2) {1424,1239};
    test_tx[10] = (cl_int2) {1398,1206};
    test_tx[11] = (cl_int2) {1400,1245};
    test_tx[12] = (cl_int2) {1431,1226};
    test_tx[13] = (cl_int2) {1423,1248};
    test_tx[14] = (cl_int2) {1460,1203};
    test_tx[15] = (cl_int2) {1451,1215};
    test_tx[16] = (cl_int2) {1471,1236};
    test_tx[17] = (cl_int2) {1422,1235};
    test_tx[18] = (cl_int2) {1434,1257};
    test_tx[19] = (cl_int2) {1436,1232};
    test_tx[20] = (cl_int2) {1449,1213};
    test_tx[21] = (cl_int2) {1429,1222};
    test_tx[22] = (cl_int2) {1378,1202};
    test_tx[23] = (cl_int2) {1444,1222};
    test_tx[24] = (cl_int2) {1385,1207};
    test_tx[25] = (cl_int2) {1421,1222};
    test_tx[26] = (cl_int2) {1459,1182};
    test_tx[27] = (cl_int2) {1396,1181};
    test_tx[28] = (cl_int2) {1422,1225};
    test_tx[29] = (cl_int2) {1424,1220};
    test_tx[30] = (cl_int2) {1426,1232};
    test_tx[31] = (cl_int2) {1409,1212};
    test_tx[32] = (cl_int2) {1414,1236};
    test_tx[33] = (cl_int2) {1429,1234};
    test_tx[34] = (cl_int2) {1425,1228};
    test_tx[35] = (cl_int2) {1445,1172};
    test_tx[36] = (cl_int2) {1508,1219};
    test_tx[37] = (cl_int2) {1401,1210};
    test_tx[38] = (cl_int2) {1429,1222};
    test_tx[39] = (cl_int2) {1421,1195};
    test_tx[40] = (cl_int2) {1436,1249};
    test_tx[41] = (cl_int2) {1445,1179};
    test_tx[42] = (cl_int2) {1412,1214};
    test_tx[43] = (cl_int2) {1388,1250};
    test_tx[44] = (cl_int2) {1431,1231};
    test_tx[45] = (cl_int2) {1387,1185};
    test_tx[46] = (cl_int2) {1443,1268};
    test_tx[47] = (cl_int2) {1427,1203};
    test_tx[48] = (cl_int2) {1403,1240};
    test_tx[49] = (cl_int2) {1397,1238};
    test_tx[50] = (cl_int2) {1388,1200};
    test_tx[51] = (cl_int2) {1482,1228};
    test_tx[52] = (cl_int2) {1497,1232};
    test_tx[53] = (cl_int2) {1399,1189};
    test_tx[54] = (cl_int2) {1373,1247};
    test_tx[55] = (cl_int2) {1448,1262};
    test_tx[56] = (cl_int2) {1424,1220};
    test_tx[57] = (cl_int2) {1427,1199};
    test_tx[58] = (cl_int2) {1416,1201};
    test_tx[59] = (cl_int2) {1419,1209};
    test_tx[60] = (cl_int2) {1423,1231};
    test_tx[61] = (cl_int2) {1436,1221};
    test_tx[62] = (cl_int2) {1439,1218};
    test_tx[63] = (cl_int2) {1431,1216};
    test_tx[64] = (cl_int2) {1418,1148};
    test_tx[65] = (cl_int2) {1431,1237};
    test_tx[66] = (cl_int2) {1419,1237};
    test_tx[67] = (cl_int2) {1397,1210};
    test_tx[68] = (cl_int2) {1500,1225};
    test_tx[69] = (cl_int2) {1498,1253};
    test_tx[70] = (cl_int2) {1404,1235};
    test_tx[71] = (cl_int2) {1380,1242};
    test_tx[72] = (cl_int2) {1430,1244};
    test_tx[73] = (cl_int2) {1404,1230};
    test_tx[74] = (cl_int2) {1413,1241};
    test_tx[75] = (cl_int2) {1427,1185};
    test_tx[76] = (cl_int2) {1386,1173};
    test_tx[77] = (cl_int2) {1429,1226};
    test_tx[78] = (cl_int2) {1443,1227};
    test_tx[79] = (cl_int2) {1425,1212};
    test_tx[80] = (cl_int2) {1429,1209};
    test_tx[81] = (cl_int2) {1386,1192};
    test_tx[82] = (cl_int2) {1455,1235};
    test_tx[83] = (cl_int2) {1387,1233};
    test_tx[84] = (cl_int2) {1429,1196};
    test_tx[85] = (cl_int2) {1439,1166};
    test_tx[86] = (cl_int2) {1439,1215};
    test_tx[87] = (cl_int2) {1396,1197};
    test_tx[88] = (cl_int2) {1388,1168};
    test_tx[89] = (cl_int2) {1429,1228};
    test_tx[90] = (cl_int2) {1421,1242};
    test_tx[91] = (cl_int2) {1467,1263};
    test_tx[92] = (cl_int2) {1438,1228};
    test_tx[93] = (cl_int2) {1450,1216};
    test_tx[94] = (cl_int2) {1446,1213};
    test_tx[95] = (cl_int2) {1382,1251};
    test_tx[96] = (cl_int2) {1382,1235};
    test_tx[97] = (cl_int2) {1387,1237};
    test_tx[98] = (cl_int2) {1456,1213};
    test_tx[99] = (cl_int2) {1425,1226};
    test_tx[100] = (cl_int2) {1448,1202};
    test_tx[101] = (cl_int2) {1470,1218};
    test_tx[102] = (cl_int2) {1463,1228};
    test_tx[103] = (cl_int2) {1421,1235};
    test_tx[104] = (cl_int2) {1463,1233};
    test_tx[105] = (cl_int2) {1414,1221};
    test_tx[106] = (cl_int2) {1433,1208};
    test_tx[107] = (cl_int2) {1422,1202};
    test_tx[108] = (cl_int2) {1415,1212};
    test_tx[109] = (cl_int2) {1396,1201};
    test_tx[110] = (cl_int2) {1424,1234};
    test_tx[111] = (cl_int2) {1406,1205};
    test_tx[112] = (cl_int2) {1420,1231};
    test_tx[113] = (cl_int2) {1418,1226};
    test_tx[114] = (cl_int2) {1392,1196};
    test_tx[115] = (cl_int2) {1404,1150};
    test_tx[116] = (cl_int2) {1416,1233};
    test_tx[117] = (cl_int2) {1390,1156};
    test_tx[118] = (cl_int2) {1435,1211};
    test_tx[119] = (cl_int2) {1417,1220};
    test_tx[120] = (cl_int2) {1450,1235};
    test_tx[121] = (cl_int2) {1445,1218};
    test_tx[122] = (cl_int2) {1482,1206};
    test_tx[123] = (cl_int2) {1436,1177};
    test_tx[124] = (cl_int2) {1428,1218};
    test_tx[125] = (cl_int2) {1415,1246};
    test_tx[126] = (cl_int2) {1423,1225};
    test_tx[127] = (cl_int2) {1407,1241};
    test_tx[128] = (cl_int2) {1459,1225};
    test_tx[129] = (cl_int2) {1385,1160};
    test_tx[130] = (cl_int2) {1416,1259};
    test_tx[131] = (cl_int2) {1394,1242};
    test_tx[132] = (cl_int2) {1472,1247};
    test_tx[133] = (cl_int2) {1454,1214};
    test_tx[134] = (cl_int2) {1417,1182};
    test_tx[135] = (cl_int2) {1434,1228};
    test_tx[136] = (cl_int2) {1439,1236};
    test_tx[137] = (cl_int2) {1436,1198};
    test_tx[138] = (cl_int2) {1422,1226};
    test_tx[139] = (cl_int2) {1388,1163};
    test_tx[140] = (cl_int2) {1451,1224};
    test_tx[141] = (cl_int2) {1461,1273};
    test_tx[142] = (cl_int2) {1391,1222};
    test_tx[143] = (cl_int2) {1462,1178};
    test_tx[144] = (cl_int2) {1379,1231};
    test_tx[145] = (cl_int2) {1404,1250};
    test_tx[146] = (cl_int2) {1422,1227};
    test_tx[147] = (cl_int2) {1488,1234};
    test_tx[148] = (cl_int2) {1423,1225};
    test_tx[149] = (cl_int2) {1406,1198};
    test_tx[150] = (cl_int2) {1415,1200};
    test_tx[151] = (cl_int2) {1415,1234};
    test_tx[152] = (cl_int2) {1404,1193};
    test_tx[153] = (cl_int2) {1392,1207};

    /* for each transmitter */
    for (i = 0; i < ntest_tx; i++)
    {
        /* display completion percentage */
        G_percent (i, ntest_tx, 1);

        /* Transmitter coordinates */
        cl_int2 tx_coord = test_tx[i];

        G_message ("The transmitter is located at %d, %d", tx_coord.x,
                                                           tx_coord.y);
        /* Transmitter heights */
        //G_message ("Transmitter height above sea level is %d mts", tx_elevation);
        //G_message ("Transmitter anthena height above ground is %d mts", tx_anthena_height);

        /* transmitter data */ 
        cl_int4 tx_data = (cl_int4) {tx_coord.x, tx_coord.y,
                                     tx_elevation, tx_anthena_height};

        /* tile offset within the raster */
        cl_int2 tx_offset = (cl_int2) {tx_coord.x - radius,
                                       tx_coord.y - radius};

        /* set (more) remaining kernel parameters */
        clarg_set (ctx, krn, 1, tx_data);
        clarg_set (ctx, krn, 2, tx_offset);

        /* start kernel execution */
        clfork (ctx, 0, krn, &ndr, CL_EVENT_NOWAIT);

        clwait (ctx, 0, CL_KERNEL_EVENT|CL_MEM_EVENT|CL_EVENT_RELEASE);
    }

    /* sync memory */
    clmsync (ctx, 0, qrm_out, CL_MEM_HOST|CL_EVENT_WAIT);

    /* write the calculation output */
    save_raster (qrm_out, nrows, ncols, outfd);

    /* free allocated resources */
    free (test_tx);
    clclose (ctx, h);
    clfree (qrm_out);
    clfree (dem_in);

}



/*
 * Calculates a path loss matrix for each of the transmitters.
 * The output is saved in separate raster maps (i.e. one for each tx).
 *
 * int nrows .............. the number of rows in the DEM.
 * int ncols .............. the number of columns in the DEM.
 * int tx_coord_col ....... transmitter column coordinate (in raster cells).
 * int tx_coord_row ....... transmitter row coordinate (in raster cells).
 * int tx_elevation ....... transmitter height above sea level.
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
void hata_path_loss_cl (const int nrows, const int ncols,
                        const int tx_coord_col, const int tx_coord_row,
                        const int tx_elevation, const int tx_anthena_height,
                        const float rx_height, const float frequency,
                        const int radius,
                        const int infd, const char *outname, 
                        RASTER_MAP_TYPE rtype)
{
    int i;
    char *raster_outname = (char *) malloc (100 * sizeof(char));

    /* number of processing tiles needed around each transmitter */
    int ntile = (radius*2) / _HATA_WITEM_PER_DIM_ + 1;

    G_message ("Receiver height above ground is %5.2f mts", rx_height);
    G_message ("Transmitter frequency is %7.2f Mhz", frequency);
    G_message ("Calculation radius is %d raster cells", radius);

    CONTEXT * ctx = init_context ( );

    /* initialize raster data */
    void *dem_in = load_raster (ctx, nrows, ncols, infd, rtype);

    /* path loss matrix of each transmitter */
    void *pl_out = null_raster (ctx, nrows, ncols, rtype, NULL);

    /* load, compile and link the OpenCL kernel file */
    void* h = clopen (ctx, NULL, CLLD_NOW);

    /* select a kernel function from the loaded file */
    cl_kernel krn = clsym (ctx, h, "hata_urban_kern_per_tx", CLLD_NOW);

    /* defines a 2D matrix of work groups & work items */
    size_t global_wsize = ntile * _HATA_WITEM_PER_DIM_;
    size_t local_wsize = _HATA_WITEM_PER_DIM_;

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

    /* set kernel parameters and local memory size */
    clarg_set (ctx, krn, 0, ncols);
    clarg_set (ctx, krn, 3, rx_height);
    clarg_set (ctx, krn, 4, frequency);
    clarg_set (ctx, krn, 5, ahr);

    size_t lmem_size = _HATA_WITEM_PER_DIM_*_HATA_WITEM_PER_DIM_*
                       sizeof(cl_float2);

    if (lmem_size > _HATA_MAX_LOCAL_MEM_)
        G_fatal_error ("Allocated local memory (%d) exceeds %d bytes.", lmem_size,
                                                                        _HATA_MAX_LOCAL_MEM_);

    clarg_set_local (ctx, krn, 8, lmem_size);

    /* transfer data to the device */
    clmsync (ctx, 0, dem_in, CL_MEM_DEVICE|CL_EVENT_NOWAIT);

    /* set remaining kernel parameters */
    clarg_set_global (ctx, krn, 6, dem_in);
    clarg_set_global (ctx, krn, 7, pl_out);

    G_message ("Simulating ...");

    /* test transmitters */
    const int ntest_tx = 21;
    cl_int2 *test_tx = malloc (ntest_tx * sizeof(cl_int2));

    test_tx[0] = (cl_int2) {1468,1200};
    test_tx[1] = (cl_int2) {1395,1180};
    test_tx[2] = (cl_int2) {1400,1245};
    test_tx[3] = (cl_int2) {1460,1203};
    test_tx[4] = (cl_int2) {1422,1235};
    test_tx[5] = (cl_int2) {1396,1181};
    test_tx[6] = (cl_int2) {1387,1185};
    test_tx[7] = (cl_int2) {1399,1189};
    test_tx[8] = (cl_int2) {1448,1262};
    test_tx[9] = (cl_int2) {1498,1253};
    test_tx[10] = (cl_int2) {1429,1196};
    test_tx[11] = (cl_int2) {1446,1213};
    test_tx[12] = (cl_int2) {1425,1226};
    test_tx[13] = (cl_int2) {1421,1235};
    test_tx[14] = (cl_int2) {1433,1208};
    test_tx[15] = (cl_int2) {1404,1150};
    test_tx[16] = (cl_int2) {1450,1235};
    test_tx[17] = (cl_int2) {1417,1182};
    test_tx[18] = (cl_int2) {1436,1198};
    test_tx[19] = (cl_int2) {1422,1227};
    test_tx[20] = (cl_int2) {1404,1193};

    /* for each transmitter */
    for (i = 0; i < ntest_tx; i++)
    {
        /* display completion percentage */
        G_percent (i, ntest_tx, 1);

        /* allocate memory for the path loss matrix */
        null_raster (ctx, nrows, ncols, rtype, pl_out);

        /* transfer data to the device */
        clmsync (ctx, 0, pl_out, CL_MEM_DEVICE|CL_EVENT_WAIT);

        /* Transmitter coordinates */
        cl_int2 tx_coord = test_tx[i];

        G_message ("The transmitter is located at %d, %d", tx_coord.x,
                                                           tx_coord.y);
        /* Transmitter heights */
        //G_message ("Transmitter height above sea level is %d mts", tx_elevation);
        //G_message ("Transmitter anthena height above ground is %d mts", tx_anthena_height);

        /* transmitter data */ 
        cl_int4 tx_data = (cl_int4) {tx_coord.x, tx_coord.y,
                                     tx_elevation, tx_anthena_height};

        /* tile offset within the raster */
        cl_int2 tx_offset = (cl_int2) {tx_coord.x - radius,
                                       tx_coord.y - radius};

        /* set (more) remaining kernel parameters */
        clarg_set (ctx, krn, 1, tx_data);
        clarg_set (ctx, krn, 2, tx_offset);

        /* start kernel execution */
        clfork (ctx, 0, krn, &ndr, CL_EVENT_NOWAIT);

        clwait (ctx, 0, CL_KERNEL_EVENT|CL_MEM_EVENT|CL_EVENT_RELEASE);

        /* sync memory */
        clmsync (ctx, 0, pl_out, CL_MEM_HOST|CL_EVENT_WAIT);

        /* write the calculation output */
        sprintf (raster_outname, "%s_%d", outname, i);
        save_raster_to_file (raster_outname, pl_out, nrows, ncols);
    }

    /* free allocated resources */
    free (raster_outname);
    free (test_tx);
    clclose (ctx, h);
    clfree (pl_out);
    clfree (dem_in);

}



/*
 * Calculates the path loss matrix for many transmitters and saves the
 * output to one common raster map.
 *
 * int nrows .............. the number of rows in the DEM.
 * int ncols .............. the number of columns in the DEM.
 * int tx_coord_col ....... transmitter column coordinate (in raster cells).
 * int tx_coord_row ....... transmitter row coordinate (in raster cells).
 * int tx_elevation ....... transmitter height above sea level.
 * int anthena_height ..... height of transmitter anthena above ground.
 * float rx_height ........ receiver height above ground.
 * float frequency ........ transmitter frequency in Mhz.
 * int radius ............. calculation radius around to the transmitter
 *                          (in raster cells).
 * int infd ............... file descriptor to read from the DEM.
 * int outfd .............. file descriptor to write resulting raster.
 * RASTER_MAP_TYPE rtype .. DEM element data type.
 *
 */
void hata_cl (const int nrows, const int ncols,
              const int tx_coord_col, const int tx_coord_row,
              const int tx_elevation, const int tx_anthena_height,
              const float rx_height, const float frequency,
              const int radius,
              const int infd, const int outfd, 
              RASTER_MAP_TYPE rtype)
{
    int i;

    /* number of processing tiles needed around each transmitter */
    int ntile = (radius*2) / _HATA_WITEM_PER_DIM_ + 1;

    G_message ("Receiver height above ground is %5.2f mts", rx_height);
    G_message ("Transmitter frequency is %7.2f Mhz", frequency);
    G_message ("Calculation radius is %d raster cells", radius);

    CONTEXT * ctx = init_context ( );

    /* initialize raster data */
    void *dem_in = load_raster (ctx, nrows, ncols, infd, rtype);
    void *dem_out = null_raster (ctx, nrows, ncols, rtype, NULL);

    /* load, compile and link the OpenCL kernel file */
    void* h = clopen (ctx, NULL, CLLD_NOW);
    /* select a kernel function from the loaded file */
    cl_kernel krn = clsym (ctx, h, "hata_urban_kern", CLLD_NOW);

    /* defines a 2D matrix of work groups & work items */
    size_t global_wsize = ntile * _HATA_WITEM_PER_DIM_;
    size_t local_wsize = _HATA_WITEM_PER_DIM_;

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

    /* set kernel parameters and local memory size */
    clarg_set (ctx, krn, 0, ncols);
    clarg_set (ctx, krn, 3, rx_height);
    clarg_set (ctx, krn, 4, frequency);
    clarg_set (ctx, krn, 5, ahr);

    size_t lmem_size = _HATA_WITEM_PER_DIM_*_HATA_WITEM_PER_DIM_*
                       sizeof(cl_float2);

    if (lmem_size > _HATA_MAX_LOCAL_MEM_)
        G_fatal_error ("Allocated local memory (%d) exceeds %d bytes.", lmem_size,
                                                                        _HATA_MAX_LOCAL_MEM_);

    clarg_set_local (ctx, krn, 8, lmem_size);

    /* transfer data to the device */
    clmsync (ctx, 0, dem_in, CL_MEM_DEVICE|CL_EVENT_NOWAIT);
    clmsync (ctx, 0, dem_out, CL_MEM_DEVICE|CL_EVENT_NOWAIT);

    /* set remaining kernel parameters */
    clarg_set_global (ctx, krn, 6, dem_in);
    clarg_set_global (ctx, krn, 7, dem_out);

    G_message ("Simulating ...");

    /* test transmitters

         ASNEBE | 1468 | 1200
         ASKZK  | 1395 | 1180
         ASPAR  | 1400 | 1245
         ASMARG | 1460 | 1203
         ASTARA | 1422 | 1235
         ASKZ   | 1396 | 1181
         ASENTP | 1387 | 1185
         ASISKP | 1399 | 1189
         ASEME  | 1448 | 1262
         ASOSTR | 1498 | 1253
         ASMELT | 1429 | 1196
         ASMART | 1446 | 1213
         ASLOM  | 1425 | 1226
         ASAZU  | 1421 | 1235
         ASONCE | 1433 | 1208
         ASMAR  | 1404 | 1150
         ASTEP  | 1450 | 1235
         ASAVLJ | 1417 | 1182
         ASTOZI | 1436 | 1198
         ASTRAL | 1422 | 1227
         ASTEG  | 1404 | 1193
    */
    const int ntest_tx = 21;
    cl_int2 *test_tx = malloc (ntest_tx * sizeof(cl_int2));

    test_tx[0] = (cl_int2) {1468,1200};
    test_tx[1] = (cl_int2) {1395,1180};
    test_tx[2] = (cl_int2) {1400,1245};
    test_tx[3] = (cl_int2) {1460,1203};
    test_tx[4] = (cl_int2) {1422,1235};
    test_tx[5] = (cl_int2) {1396,1181};
    test_tx[6] = (cl_int2) {1387,1185};
    test_tx[7] = (cl_int2) {1399,1189};
    test_tx[8] = (cl_int2) {1448,1262};
    test_tx[9] = (cl_int2) {1498,1253};
    test_tx[10] = (cl_int2) {1429,1196};
    test_tx[11] = (cl_int2) {1446,1213};
    test_tx[12] = (cl_int2) {1425,1226};
    test_tx[13] = (cl_int2) {1421,1235};
    test_tx[14] = (cl_int2) {1433,1208};
    test_tx[15] = (cl_int2) {1404,1150};
    test_tx[16] = (cl_int2) {1450,1235};
    test_tx[17] = (cl_int2) {1417,1182};
    test_tx[18] = (cl_int2) {1436,1198};
    test_tx[19] = (cl_int2) {1422,1227};
    test_tx[20] = (cl_int2) {1404,1193};

    /* for each transmitter */
    for (i = 0; i < ntest_tx; i++)
    {
        /* display completion percentage */
        G_percent (i, ntest_tx, 1);

        /* Transmitter coordinates */
        cl_int2 tx_coord = test_tx[i];

        //G_message ("The transmitter is located at %d, %d", tx_coord.x,
        //                                                   tx_coord.y);
        /* Transmitter heights */
        //G_message ("Transmitter height above sea level is %d mts", tx_elevation);
        //G_message ("Transmitter anthena height above ground is %d mts", tx_anthena_height);

        /* transmitter data */ 
        cl_int4 tx_data = (cl_int4) {tx_coord.x, tx_coord.y,
                                     tx_elevation, tx_anthena_height};

        /* tile offset within the raster */
        cl_int2 tx_offset = (cl_int2) {tx_coord.x - radius,
                                       tx_coord.y - radius};

        /* set (more) remaining kernel parameters */
        clarg_set (ctx, krn, 1, tx_data);
        clarg_set (ctx, krn, 2, tx_offset);

        /* start kernel execution */
        clfork (ctx, 0, krn, &ndr, CL_EVENT_NOWAIT);

        clwait (ctx, 0, CL_KERNEL_EVENT|CL_MEM_EVENT|CL_EVENT_RELEASE);
    }

    /* sync memory */
    clmsync (ctx, 0, dem_out, CL_MEM_HOST|CL_EVENT_WAIT);

    /* write the calculation output */
    save_raster (dem_out, nrows, ncols, outfd);

    /* free allocated resources */
    free (test_tx);
    clclose (ctx, h);
    clfree (dem_out);
    clfree (dem_in);
}



/*
 * Tests memory allocation on the GPU by reading raster data in and,
 * after transfering it to the device, read it back and creating an
 * output raster that should be identical to the input one.
 *
 * int nrows .............. the number of rows in the DEM.
 * int ncols .............. the number of columns in the DEM.
 * int infd ............... file descriptor to read from the DEM.
 * int outfd .............. file descriptor to write to an output raster.
 * RASTER_MAP_TYPE rtype .. DEM element data type.
 *
 */
void test_cl (const int nrows, const int ncols,
              const int infd, const int outfd,
              RASTER_MAP_TYPE rtype)
{
    int row, col;

    CONTEXT * ctx = init_context ( );

    /* load raster DEM data */
    FCELL *dem_device = load_raster (ctx, nrows, ncols, infd, rtype);

    G_message ("Transfering raster data to the device ...");

    clmsync (ctx, 0, dem_device, CL_MEM_DEVICE|CL_EVENT_WAIT);

    G_message ("Transfering data from the device to the host ...");

    clmsync (ctx, 0, dem_device, CL_MEM_HOST|CL_EVENT_WAIT);

    /* save raster data */
    save_raster (dem_device, nrows, ncols, outfd);

    /* free allocated resources */
    clfree (dem_device);
}


