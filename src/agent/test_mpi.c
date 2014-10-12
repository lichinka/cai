#define _MASTER_RANK_   0

#include <mpi.h>
#include <stdio.h>


int main(int argc, char* argv[])
{
    int rank;

    MPI_Init (&argc, &argv);
    MPI_Comm_rank(MPI_COMM_WORLD, &rank);

    if (rank == _MASTER_RANK_)
    {
        int value = 17;
        int result = MPI_Send (&value, 1, MPI_INT, 1, 0,
                               MPI_COMM_WORLD);

        if (result == MPI_SUCCESS)
          printf ("Master OK!\n");
    } 
    else if (rank == 1) 
    {
        int value;
        int result = MPI_Recv (&value, 1, MPI_INT, 0, 0, 
                               MPI_COMM_WORLD, MPI_STATUS_IGNORE);

        if (result == MPI_SUCCESS && value == 17)
          printf ("1st agent OK!\n");
    }
    MPI_Finalize ( );
    return 0;
} 

