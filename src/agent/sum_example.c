#define _MASTER_RANK_   0

#include <stdio.h>
#include <mpi.h>


int main (int argc, char* argv[])
{
    int rank;

    MPI_Init (&argc, &argv);
    MPI_Comm_rank(MPI_COMM_WORLD, &rank);

    if (rank == _MASTER_RANK_)
    {
        int i, nrank;
        int result = MPI_Comm_size (MPI_COMM_WORLD, &nrank);

        if (result == MPI_SUCCESS)
        {
            int value [2];

            printf ("Master waiting for %d slaves ...\n", nrank-1);

            while (1)
            {
                for (i = 1; i < nrank; i++)
                {
                    result = MPI_Recv (&value, 2, MPI_INT, i, 0,
                                       MPI_COMM_WORLD, MPI_STATUS_IGNORE);

                    if (result == MPI_SUCCESS)
                    {
                        printf ("Master received %d and %d from %d. slave\n", 
                                value[0], value[1], i);

                        // calculate the sum and return the result
                        value[0] = value[0] + value[1];
                        result = MPI_Send (&value, 1, MPI_INT, i, 0, 
                                           MPI_COMM_WORLD);
                    }
                }
            }
        }
    } 
    else
    {
        int value [2];
        
        value[0] = rank;
        value[1] = rank * 10;

        int result = MPI_Send (&value, 2, MPI_INT, _MASTER_RANK_, 0, 
                               MPI_COMM_WORLD);

        if (result == MPI_SUCCESS)
        {
            printf ("%d. agent sent %d and %d to MASTER\n", rank, 
                                                            value[0],
                                                            value[1]);
            // wait for master's reply
            result = MPI_Recv (&value, 1, MPI_INT, _MASTER_RANK_, 0,
                               MPI_COMM_WORLD, MPI_STATUS_IGNORE);

            if (result == MPI_SUCCESS)
            {
                printf ("Master returned %d\n", value[0]);
            }
            else
            {
                printf ("Error while waiting for master's reply in %d. agent\n", rank);
            }
        }
        else
        {
            printf ("Error while sending from %. agent\n", rank);
        }
    }

    MPI_Finalize ( );
    return 0;
} 

