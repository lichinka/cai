N_TX=129
MIN_X=445
MAX_X=535
MIN_Y=68
MAX_Y=158

#
# random transmitter within the area
#
TX_X=$(( ${MAX_X} - ${MIN_X} ))
TX_X=$(( ${RANDOM} % ${TX_X} + ${MIN_X} + 1 ))
TX_X=$(( ${TX_X} * 1000 ))
TX_Y=$(( ${MAX_Y} - ${MIN_Y} ))
TX_Y=$(( ${RANDOM} % ${TX_Y} + ${MIN_Y} + 1 ))
TX_Y=$(( ${TX_Y} * 1000 ))

echo "Measuring time for ${N_TX} transmitters ..."

START=$( date +%s )
for i in $( seq 1 ${N_TX} );
do
    r.hata_gpu input=dem100i_mo@PERMANENT output=ijs_map coordinate=${TX_X},${TX_Y} ant_height=8 radius=20 area_type=urban frequency=2157.8 default_DEM_height=300 opencl=no --overwrite > /dev/null 2>&1
done
END=$( date +%s )
DIFF=$(( ${END} - ${START} ))
echo "  Total time for ${N_TX} transmitters was ${DIFF} seconds"

