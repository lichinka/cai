#include <stdio.h>
#include <mpi.h>

main(int argc, char **argv)
{
    int my_id;
    char port_name[MPI_MAX_PORT_NAME];
    MPI_Comm newcomm;
    int passed_num;

    MPI_Init(&argc, &argv);
    MPI_Comm_rank(MPI_COMM_WORLD, &my_id);

    passed_num = 111;

    if (my_id == 0)
    {
        MPI_Open_port(MPI_INFO_NULL, port_name);
        printf("%s\n\n", port_name); fflush(stdout);
    }

    MPI_Comm_accept(port_name, MPI_INFO_NULL, 0, MPI_COMM_WORLD, &newcomm); 

    if (my_id == 0)
    {
        MPI_Send(&passed_num, 1, MPI_INT, 0, 0, newcomm);
        printf("after sending passed_num %d\n", passed_num); fflush(stdout);
        MPI_Close_port(port_name);
    }

    MPI_Finalize();

    return 0;

}

