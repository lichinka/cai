#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <mpi.h>
#include "prot.h"



/*
 * Logs the current agent into the master process.
 *
 * int rank ........ this agent's id (i.e. the MPI rank number)
 * int *mdim ....... a four-element array where the received matrix
 *                   dimensions will be saved.
 */
void login (const int rank, int *mdim)
{
    int result = MPI_Send (NULL, 0, MPI_INT, _AG_MASTER_RANK_, 
                           _AG_LOGIN_TAG_, MPI_COMM_WORLD);
    if (result != MPI_SUCCESS)
    {
        fprintf (stderr, "Error during login of %d. agent\n", rank);
    }
    else
    {
        // wait for the matrix dimensions
        result = MPI_Recv (mdim, 4, MPI_INT, _AG_MASTER_RANK_, 
                           _AG_REPLY_TAG_, MPI_COMM_WORLD,
                           MPI_STATUS_IGNORE);
        if (result != MPI_SUCCESS)
            fprintf (stderr, "Error while receiving matrix dimensions at %d. agent\n", rank);
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



/*
 * Request all signals at the given coordinate.
 *
 * int rank ........ this agent's id (i.e. the MPI rank number)
 * int *coord ...... the coordinate, expressed in raster cells.
 */
void signals (const int rank, int *coord)
{
    float fbuf[_AG_FLOAT_BUFFER_SIZE_];
    int result = MPI_Send (coord, 2, MPI_INT, _AG_MASTER_RANK_,
                           _AG_SIGNALS_TAG_, MPI_COMM_WORLD);

    if (result == MPI_SUCCESS)
    {
        // wait for master's reply
        result = MPI_Recv (fbuf, _AG_FLOAT_BUFFER_SIZE_, MPI_INT, 
                           _AG_MASTER_RANK_, _AG_REPLY_TAG_, 
                           MPI_COMM_WORLD, MPI_STATUS_IGNORE);

        printf ("Master returned signals\n");
    }
    else
    {
        fprintf (stderr, "Error while sending from %d. agent\n", rank);
    }
}



/*
 * Entry point of the agent's code.
 *
 * int rank ........ this agent's id (i.e. the MPI rank number)
 */
void agent (const int rank)
{
    int i; 
    int mdim[4];        // Matrix dimension (min_x, min_y, max_x, max_y)
    int coord[2];       // Agent's current position within the matrix
    
    // log into master. Master's answer should be the 
    // dimension of the matrix where the agent may move.
    login (rank, mdim);

    printf ("Received dimensions are (%d,%d)x(%d,%d)\n", mdim[0],
                                                         mdim[1],
                                                         mdim[2],
                                                         mdim[3]);
    // agent's rank as seed, so that every agent will
    // follow a different reproducible path
    srand (rank);
    int res_x = RAND_MAX / (mdim[2] - mdim[0]);
    int res_y = RAND_MAX / (mdim[3] - mdim[1]);
        
    // start moving around for a number of steps
    for (i=0; i < 50000; i++)
    {
        coord[0] = rand ( ) / res_x;
        coord[1] = rand ( ) / res_y;

        signals (rank, coord);
    }
        
    // log off. Master should shut down after 
    // the last agent has logged off
    logoff (rank);
    return;
} 

