#!/bin/bash

LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:/usr/local/grass-6.4.1RC1/lib

INPUT_DEM=dem100i_mo@PERMANENT
OUTPUT=qrm_154
ANTHENNA_HEIGHT=8
AREA=urban
FREQUENCY=2157.8
RADIUS=5
HOSTFILE=hostfile.local

COMMAND="mpirun -x LD_LIBRARY_PATH --hostfile ${HOSTFILE} /usr/local/grass-6.4.1RC1/bin/r.hata_daemon input=${INPUT_DEM} output=${OUTPUT} coordinate=463094,102454 ant_height=${ANTHENNA_HEIGHT} radius=${RADIUS} area_type=${AREA} frequency=${FREQUENCY} default_DEM_height=300 opencl=yes --overwrite"

echo "${COMMAND}" > daemon.log 2>&1
echo "- - - - - - - - - - - - - - - - - - - - - -" >> daemon.log 2>&1
${COMMAND} >> daemon.log 2>&1

