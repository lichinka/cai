echo "SELECT MAX(date_time) AS time, X, Y, cell, AVG(rx_level) AS rx_level FROM ("

for cell in `cat celice-LJ-vecje_obmocje.txt`;
do
	echo -n "SELECT T.date_time, T.x AS Y, T.y AS X, '${cell}' AS cell, T.rx_level "
	echo -n "  FROM tems_gis_history_2010_02_5 T "
	echo -n "  JOIN network.cell C "
	echo -n "    ON C.name = '${cell}' "
	echo -n "   AND C.network_identity = T.cell_network_identity "
	echo -n " WHERE T.mobile_network_code = 41 "
	echo    "   AND T.rx_level < 0 "
	echo "UNION"
done

echo ") foo"
echo "GROUP BY X, Y, cell ORDER BY cell, X, Y, MAX(date_time)"
