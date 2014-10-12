#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <mpi.h>
#include "prot.h"



/*
 * Logs the current agent into the master process.
 *
 * int rank ........ this agent's id (i.e. the MPI rank number)
 * int *buff ....... a five-element array where the received matrix
 *                   dimensions and the number of active transmitters
 *                   will be saved.
 */
void login (const int rank, int *buff)
{
    int result = MPI_Send (NULL, 0, MPI_INT, _AG_MASTER_RANK_, 
                           _AG_LOGIN_TAG_, MPI_COMM_WORLD);
    if (result != MPI_SUCCESS)
    {
        fprintf (stderr, "Error during login of %d. agent\n", rank);
    }
    else
    {
        // wait for the matrix dimensions and number of Tx
        result = MPI_Recv (buff, 5, MPI_INT, _AG_MASTER_RANK_, 
                           _AG_REPLY_TAG_, MPI_COMM_WORLD,
                           MPI_STATUS_IGNORE);
        if (result != MPI_SUCCESS)
            fprintf (stderr, "Error while receiving login info at %d. agent\n", rank);
    }
}



/*
 * Logs the current agent off the master process.
 *
 * int rank ........ this agent's id (i.e. the MPI rank number)
 */
void logoff (const int rank)
{
    int result = MPI_Send (NULL, 0, MPI_INT, _AG_MASTER_RANK_, 
                           _AG_LOGOFF_TAG_, MPI_COMM_WORLD);
    if (result != MPI_SUCCESS)
        fprintf (stderr, "Error during logoff of %d. agent\n", rank);
}



/*
 * Calculates the sum of two numbers by sending them to the master.
 *
 * int rank ........ this agent's id (i.e. the MPI rank number)
 * int *pair ....... the pair of number for which to calculate sum
 */
void sum (const int rank, int *pair)
{
    int result = MPI_Send (pair, 2, MPI_INT, _AG_MASTER_RANK_,
                           _AG_SUM_TAG_, MPI_COMM_WORLD);

    if (result == MPI_SUCCESS)
    {
        // wait for master's reply
        result = MPI_Recv (pair, 1, MPI_INT, _AG_MASTER_RANK_,
                           _AG_REPLY_TAG_, MPI_COMM_WORLD, 
                           MPI_STATUS_IGNORE);

        printf ("Master returned %d\n", pair[0]);
    }
    else
    {
        fprintf (stderr, "Error while sending from %d. agent\n", rank);
    }
}



/**
 * Requests the objective function value.
 * It returns the number of uncovered pixels in the area.
 *
 * int rank ............ this agent's id (i.e. the MPI rank number)
 */
int get_objective_function (const int rank)
{
    int ret_value[2];
    int result = MPI_Send (NULL, 0, MPI_INT, _AG_MASTER_RANK_,
                           _AG_OBJECTIVE_TAG_, MPI_COMM_WORLD);

    if (result == MPI_SUCCESS)
    {
        // wait for master's reply
        result = MPI_Recv (&ret_value, 2, MPI_INT, _AG_MASTER_RANK_,
                           _AG_REPLY_TAG_, MPI_COMM_WORLD, MPI_STATUS_IGNORE);

        if (result == MPI_SUCCESS)
            printf("Objective function, %d uncovered, using %d mW\n", ret_value[0],
                                                                      ret_value[1]);
        else
            fprintf (stderr, "Error while receiving from master (%d.ag)\n", rank);
    }
    else
    {
        fprintf (stderr, "Error while sending from %d. agent\n", rank);
    }

    return ret_value[0];
}



/**
 * Request pilot power of all active transmitters.
 *
 * int rank ............ this agent's id (i.e. the MPI rank number)
 * int *sbuf ........... output buffer.
 * int ntx  ............ number of expected transmitter pilots.
 */
void get_pilots (const int rank, 
                 int *sbuf,
                 const int ntx)
{
    int i;
    int result = MPI_Send (NULL, 0, MPI_INT, _AG_MASTER_RANK_,
                           _AG_PILOTS_TAG_, MPI_COMM_WORLD);

    if (result == MPI_SUCCESS)
    {
        // wait for master's reply
        result = MPI_Recv (sbuf, ntx, MPI_SHORT, _AG_MASTER_RANK_,
                           _AG_REPLY_TAG_, MPI_COMM_WORLD, MPI_STATUS_IGNORE);

        if (result == MPI_SUCCESS)
        {
            printf ("Master returned current pilot powers:\n");

            // decode the received signals
            for (i = 0; i < ntx; i++)
            {
                printf ("\tTx%d pilot is %d milliwatts\n", i, sbuf[i]);
            }
        }
        else
        {
            fprintf (stderr, "Error while receiving from master (%d.ag)\n", rank);
        }
    }
    else
    {
        fprintf (stderr, "Error while sending from %d. agent\n", rank);
    }
}



/**
 * Request all signals at the given coordinate.
 *
 * int rank ........ this agent's id (i.e. the MPI rank number)
 * int *coord ...... the coordinate, expressed in raster cells.
 * float *fbuf ..... output buffer, where the received data are saved.
 * int ntx ......... total number of transmitters in the area.
 */
void get_signals (const int rank, int *coord,
                  float *fbuf, const int ntx)
{
    int i;
    int result = MPI_Send (coord, 2, MPI_INT, _AG_MASTER_RANK_,
                           _AG_SIGNALS_TAG_, MPI_COMM_WORLD);

    if (result == MPI_SUCCESS)
    {
        // wait for master's reply
        result = MPI_Recv (fbuf, ntx, MPI_FLOAT, _AG_MASTER_RANK_,
                           _AG_REPLY_TAG_, MPI_COMM_WORLD,
                           MPI_STATUS_IGNORE);

        if (result == MPI_SUCCESS)
        {
            printf ("Master returned signals for (%d,%d):\n", coord[0],
                                                              coord[1]);
            // decode the received signals
            for (i=0; i<ntx; i++)
            {
                printf ("\tGamma for Tx%d is %10.8f\n", i, fbuf[i]);
            }
        }
        else
        {
            fprintf (stderr, "Error while receiving from master (%d.ag)\n", rank);
        }
    }
    else
    {
        fprintf (stderr, "Error while sending from %d. agent\n", rank);
    }
}



/**
 * Sends the new pilot power of the given transmitter to master.
 *
 * int tx_id .......... transmitter id.
 * int tx_pwr ......... current transmitter power.
 * float db  .......... change of power in dB.
 */
void change_pilot_power (int tx_id, int tx_pwr, float db)
{
    float new_pwr = db/10.0f;
    new_pwr = powf(10.0f, new_pwr) * tx_pwr;

    // if new pilot power overflows, set to maximum
    if ((int) new_pwr > _AG_MAX_PILOT_POWER_MW_)
        new_pwr = (float) _AG_MAX_PILOT_POWER_MW_;
    
    int ibuf[2] = {tx_id, (int)new_pwr};
    int result = MPI_Send (ibuf, 2, MPI_INT, _AG_MASTER_RANK_,
                           _AG_CHANGE_PILOT_TAG_, MPI_COMM_WORLD);

    if (result == MPI_SUCCESS)
    {
        printf ("\t\tSetting Tx%d pilot to %d mW\n", tx_id,
                                                     (int)new_pwr);
    }
    else
    {
        fprintf (stderr, "Error while sending from agent\n");
    }
}
 


/**
 * Function used to sort the received 
 * signals array from 'analyze_signals'.
 */
static int signalcmp (const void *el1, const void *el2)
{
    const float *val1 = (const float *) el1;
    const float *val2 = (const float *) el2;

    return (int) ((val1[1] - val2[1]) * 100000.0f);
}

/**
 * Analize a bunch of received signals and decide
 * what to do with the pilot powers of the transmitters.
 *
 * int *coord ......... coordinate of the data.
 * float *signals ..... all transmitter received signals at this coordinate.
 * int *pilots ........ vector containing the current pilot powers
 *                      of all active transmitters.
 * int ntx ............ total number of signals/transmitters.
 */
void analyze_signals (int *coord, float *signals, 
                      int *pilots, 
                      const int ntx)
{
    int row;
    float ldata[2*ntx];    // each row in this matrix has two elements
    
    // add an id to each signal, so we'll
    // know to which transmitter it belongs
    for (row=0; row<ntx; row++)
    {
        ldata[2*row] = (float) row;       // Tx id
        ldata[2*row+1] = signals[row];    // Gamma of this Tx at coord
    }
    // sort by received signal strength
    qsort (ldata, ntx, sizeof(float *), signalcmp);

    // transmitter with maximum received signal
    float max_tx[2] = {ldata[2*(ntx-1)], ldata[2*(ntx-1)+1]};

    if (max_tx[1] < _AG_MINIMUM_GAMMA_COVERAGE_)
    {
        // current coordinate is NOT covered
        printf ("\t\tCoordinate (%d,%d) NOT covered\n", coord[0],
                                                        coord[1]);
        change_pilot_power ((int) max_tx[0],
                            pilots[(int) max_tx[0]],
                            _AG_INCREASE_PILOT_DB_);
    }
    else
    {
        // current coordinate IS covered
        printf ("\t\tTx%d covers coordinate (%d,%d)\n", (int)max_tx[0],
                                                        coord[0],
                                                        coord[1]);
        // lower the pilot of the transmitter with minimum power
        for (row=0; row<ntx; row++)
        {
            int tx_id = ldata[2*row];
            // be sure this pilot is still active
            if (pilots[tx_id] > 0)
            {
                change_pilot_power ((int) ldata[2*row],
                                    pilots[(int) ldata[2*row]],
                                    _AG_DECREASE_PILOT_DB_);
                break;
            }
        }
    }
}



/**
 * Receives one randomly selected uncovered coordinate 
 * from master and tries to correct it.
 *
 * int rank ........... this agent's id (i.e. the MPI rank number)
 * int *mdim .......... matrix dimensions (i.e. coordinate limits, where
 *                      an agent may move).
 * float *signals ..... all transmitter received signals at this coordinate.
 * int *pilots ........ vector containing the current pilot powers
 *                      of all active transmitters.
 * int ntx ............ total number of signals/transmitters.
 */
void correct_coverage (const int rank,
                       int *mdim,
                       float *signals,
                       int *pilots,
                       const int ntx)
{
    int coord[2];
    int result = MPI_Send (NULL, 0, MPI_INT, _AG_MASTER_RANK_,
                           _AG_UNCOVERED_TAG_, MPI_COMM_WORLD);

    if (result == MPI_SUCCESS)
    {
        // wait for master's reply
        result = MPI_Recv (coord, 2, MPI_INT, 
                           _AG_MASTER_RANK_, _AG_REPLY_TAG_, 
                           MPI_COMM_WORLD, MPI_STATUS_IGNORE);

        if (result == MPI_SUCCESS)
        {
            // make sure the selected coordinate
            // is within the permitted area
            if ((coord[0] >= mdim[0]) && (coord[0] <= mdim[2]))
            {
                if ((coord[1] >= mdim[1]) && (coord[1] <= mdim[3]))
                {
                    printf ("%d. agent selected uncovered pixel at (%d,%d)\n", rank,
                                                                               coord[0],
                                                                               coord[1]);
                    // proceed to analyze this coordinate
                    get_signals (rank, coord, signals, ntx);
                    analyze_signals (coord, signals, pilots, ntx);
                }
            }
        }
        else
        {
            fprintf (stderr, "Error while receiving from master (%d.ag)\n", rank);
        }
    }
    else
    {
        fprintf (stderr, "Error while sending from %d. agent\n", rank);
    }
}




/**
 * Analyzes and tries to optimize coverage.
 *
 * int rank ........... this agent's id (i.e. the MPI rank number)
 * int *mdim .......... matrix dimensions (i.e. coordinate limits, where
 *                      an agent may move).
 * float *signals ..... all transmitter received signals at this coordinate.
 * int *pilots ........ vector containing the current pilot powers
 *                      of all active transmitters.
 * int ntx ............ total number of signals/transmitters.
 */
void optimize_coverage (const int rank,
                        int *mdim,
                        float *signals,
                        int *pilots,
                        const int ntx)
{
    int coord[2];
    int res_x = RAND_MAX / (mdim[2] - mdim[0]);
    int res_y = RAND_MAX / (mdim[3] - mdim[1]);
    
    coord[0] = rand ( ) / res_x + mdim[0];
    coord[1] = rand ( ) / res_y + mdim[1];
    get_signals (rank, coord, signals, ntx);
    analyze_signals (coord, signals, pilots, ntx);
}




/**
 * Entry point of the agent's code.
 *
 * int rank ........ this agent's id (i.e. the MPI rank number)
 */
void agent (const int rank)
{
    int i; 
    int ibuff[_AG_INT_BUFFER_SIZE_];             // integer comm buffer
    int mdim[4];        // matrix dimension (min_x, min_y, max_x, max_y)
    int ntx;            // number of active transmitters in the area

    // log into master
    login (rank, ibuff);

    // matrix dimensions
    mdim[0] = ibuff[0]; mdim[1] = ibuff[1];
    mdim[2] = ibuff[2]; mdim[3] = ibuff[3];
    printf ("Received dimensions are (%d,%d)x(%d,%d)\n", mdim[0],
                                                         mdim[1],
                                                         mdim[2],
                                                         mdim[3]);
    // number of transmitters
    ntx = ibuff[4];
    printf ("There are %d active transmitters in the area\n", ntx);

    // transmitter pilot powers vector
    int pilots[ntx];
    // received signals for all transmitters
    float signals[ntx];

    // agent's rank as seed, so that every agent will
    // follow a different reproducible path
    srand (rank);
        
    // start moving around for a number of steps
    for (i=0; i < _AG_MAX_AGENT_STEPS_; i++)
    {
        int not_covered = get_objective_function (rank);
        get_pilots (rank, pilots, ntx);

        // is the current solution valid?
        if (not_covered > 0)
        {
            // all evenly-ranked agents should 
            // work just to correct coverage.
            // Others should work as usual.
            if ((rank%2) == 0)
                correct_coverage (rank, mdim, signals, pilots, ntx);
            else
                optimize_coverage (rank, mdim, signals, pilots, ntx);
        }
        else
        {
            // all agents will try to optimize
            // the current valid solution
            optimize_coverage (rank, mdim, signals, pilots, ntx);
        }
    }
        
    // log off 
    logoff (rank);
    return;
} 

