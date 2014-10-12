/**
 * Constants used for MPI communication
 * between the master process and the agents.
 */
#define _AG_MASTER_RANK_            0
#define _AG_INT_BUFFER_SIZE_        10
#define _AG_EMPTY_VALUE_            -9999.9f
#define _AG_LOGIN_TAG_              1
#define _AG_LOGOFF_TAG_             100
#define _AG_SUM_TAG_                2
#define _AG_PILOTS_TAG_             3
#define _AG_SIGNALS_TAG_            4
#define _AG_CHANGE_PILOT_TAG_       5
#define _AG_OBJECTIVE_TAG_          6
#define _AG_UNCOVERED_TAG_          7
#define _AG_REPLY_TAG_              200

/**
 * Algorithm parameters are defined here.
 */
#define _AG_AGENT_NUMBER_           8
#define _AG_MAX_AGENT_STEPS_        10
#define _AG_MINIMUM_GAMMA_COVERAGE_ 0.01f
#define _AG_INCREASE_PILOT_DB_      1.0f
#define _AG_DECREASE_PILOT_DB_      -0.1f
#define _AG_MAX_PILOT_POWER_MW_     19950   // same limit as in Siomina et.al. (2008)

/**
 * The initial pilot power for all transmitters (in milliwatts).
 */
#define _HATA_INITIAL_PILOT_POWER_  400

/**
 * Some constants for Hata's model calculation.
 *  - Number of work items per dim (in 2D work groups). The square of
 *    this number would ideally be multiple of 32 (i.e. number of work
 *    items within a warp).
 *  - The total amount of shared memory per work group (in bytes). This 
 *    number is limited by the GPU hardware.
 *  - The total amount of on-board memory on the GPU (in bytes).
 */
#define _HATA_GPU_WITEM_PER_DIM_    16
#define _HATA_GPU_MAX_LOCAL_MEM_    16384
#define _HATA_GPU_MAX_DEVICE_MEM_   304087040

/**
 * Thermal noise (i.e. the minimum possible interference).
 */
#define _HATA_THERMAL_NOISE_        1.5488e-14

/** 
 * The path loss constants define the path loss scale used to convert
 * the resulting dB in a real number. They are directly related
 * to the value of gamma_c of formula (1) in Benedičič et al. (2010).
 */
#define _HATA_MIN_PATH_LOSS_            0.0f
#define _HATA_MAX_PATH_LOSS_            255.0f

/**
 * The maximum cell power of a single cell (all channels included) in Watts.
 * This constant is used to calculate interference (in watts).
 */
#define _HATA_MAX_CELL_POWER_           19.95f

