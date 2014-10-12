for cell in `cat celice-LJ-vecje_obmocje.txt`;
do
	echo "SELECT R.time, R.gk_x AS Y, R.gk_y AS X, '${cell}' AS cell, R.rscp FROM romes_history_rscp_od_2005 R WHERE text  ~ '${cell}' AND text !~ E'0[2-9]\. ${cell}' AND text !~ E'1[0-9]\. ${cell}'"
	echo "UNION"
done

