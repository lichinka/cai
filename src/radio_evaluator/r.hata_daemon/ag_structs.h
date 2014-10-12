/**
 * A structure that contains two pointers to correctly handle
 * reduced path-loss matrices:
 *
 *  - first for the path loss matrices of all transmitters,
 *  - second for the offsets of this matrices within the area
 *    and their sizes.
 */
typedef struct {
    unsigned char *data; // path-loss values in dB for this transmitter,
                         // containing values between 0 and 255.
    cl_int4 *offsets;    // offset of each matrix within the area:
                         // (col_offset, row_offset, width, height)
} struct_path_loss;


/**
 * A structure that enables subsequent calls of the coverage
 * kernel without repeating kernel compilation and CPU-GPU 
 * transfers of unchanged data.
 */
typedef struct {
    void *handler;                  // an opaque handler used to free
                                    // all memory associated with a kernel
                                    // when is it no longer needed.
    cl_kernel kernel;               // the kernel object to be executed.
    clndrange_t kernel_range;       // the range of the kernel to be executed.
    float *coverage;                // the last coverage calculated.
    unsigned short *uncovered_coord;// coordinates of the uncovered pixels.
                                    // The length of this vector is twice 
                                    // (2x) 'uncovered_coord_length'. 
                                    // X coordinates are the even vector
                                    // positions; the Y coordinates are
                                    // in the odd ones.
    int uncovered_coord_length;     // This value depends on the number 
                                    // of work groups used during coverage
                                    // calculation on GPU.
    unsigned short *uncovered_count_reduction; // a vector used to count
                                    // the number of uncovered pixels via
                                    // GPU reduction. Its length is
                                    // 'uncovered_coord_length'.
    int uncovered_count;            // number of uncovered pixels in the
                                    // area.
    int total_power;                // total pilot power in milliwatts.
} struct_cov_info;


/**
 * A structure that enables subsequent calls of the agent's
 * kernel without repeating kernel compilation and CPU-GPU 
 * transfers of unchanged data.
 */
typedef struct {
    void *handler;                  // an opaque handler used to free
                                    // all memory associated with a kernel
                                    // when is it no longer needed.
    cl_kernel kernel;               // the kernel object to be executed.
    clndrange_t kernel_range;       // the range of kernel to be executed.
} struct_agent_kernel;

