#include <stdio.h>
#include <stdlib.h>
#include <mpi.h>
#include "prot.h"


extern void master (int argc, char *argv[]);
extern void agent ( );


int main (int argc, char *argv[])
{
    int rank;

    MPI_Init (&argc, &argv);
    MPI_Comm_rank (MPI_COMM_WORLD, &rank);

    if (rank == _AG_MASTER_RANK_)
    {
        master (argc, argv);
    } 
    else
    {
        agent (rank);
    }

    MPI_Finalize ( );
    exit (EXIT_SUCCESS);
} 

