#include <stdio.h>
#include <mpi.h>
#include "prot.h"



/*
 * Logs the agent in and sends back the matrix dimension.
 *
 * int aid ........ the agent's id (i.e. the MPI rank number)
 */
void agent_login (const int aid)
{
    int mdim[4] = {0, 0, 3521, 2241};

    printf ("%d. agent just logged in\n", aid);
    
    int result = MPI_Send (mdim, 4, MPI_INT, aid, 
                           _AG_REPLY_TAG_, MPI_COMM_WORLD);
    if (result != MPI_SUCCESS)
        fprintf (stderr, "Error while sending matrix dimenstions to %d. agent\n", aid);
}



/*
 * Master code
 */
void master ( )
{
    int aid, nrank;
    int ibuf [_AG_INT_BUFFER_SIZE_];
    MPI_Status status;
    
    MPI_Comm_size (MPI_COMM_WORLD, &nrank);

    printf ("Master waiting for %d slaves ...\n", nrank-1);

    // keep running for as long as there is an agent out there
    while (nrank > 1)
    {
        MPI_Recv (&ibuf, _AG_INT_BUFFER_SIZE_, MPI_INT, 
                  MPI_ANY_SOURCE, MPI_ANY_TAG, MPI_COMM_WORLD, 
                  &status);
        aid = status.MPI_SOURCE;

        switch (status.MPI_TAG)
        {
            case (_AG_LOGIN_TAG_):
                agent_login (aid);
                break;

            case (_AG_SUM_TAG_):
                printf ("%d. agent requested sum\n", aid);

                // calculate the sum and return the result
                ibuf[0] = ibuf[0] + ibuf[1];
                MPI_Send (&ibuf, 1, MPI_INT, aid, _AG_REPLY_TAG_, 
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
