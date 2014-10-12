#include <stdio.h>
#include <mpi.h>

main(int argc, char **argv)
{
    int passed_num;
    int my_id;
    MPI_Comm newcomm;

    MPI_Init(&argc, &argv);
    MPI_Comm_rank(MPI_COMM_WORLD, &my_id);

    MPI_Comm_connect(argv[1], MPI_INFO_NULL, 0, MPI_COMM_WORLD, &newcomm); 

    if (my_id == 0)
    {
        MPI_Status status;
        MPI_Recv(&passed_num, 1, MPI_INT, 0, 0, newcomm, &status);
        printf("after receiving passed_num %d\n", passed_num); fflush(stdout);
    }

    MPI_Finalize();

    return 0;

}

