SELECT MAX(date_time) AS time, X, Y, cell, AVG(rx_level) AS rx_level FROM (
SELECT T.date_time, T.x AS Y, T.y AS X, 'KBOHBI1' AS cell, T.rx_level   FROM tems_gis_history_2010_02_5 T   JOIN network.cell C     ON C.name = 'KBOHBI1'    AND C.network_identity = T.cell_network_identity  WHERE T.mobile_network_code = 41    AND T.rx_level < 0 
UNION
SELECT T.date_time, T.x AS Y, T.y AS X, 'KCESNJ1' AS cell, T.rx_level   FROM tems_gis_history_2010_02_5 T   JOIN network.cell C     ON C.name = 'KCESNJ1'    AND C.network_identity = T.cell_network_identity  WHERE T.mobile_network_code = 41    AND T.rx_level < 0 
UNION
SELECT T.date_time, T.x AS Y, T.y AS X, 'KCESNJ2' AS cell, T.rx_level   FROM tems_gis_history_2010_02_5 T   JOIN network.cell C     ON C.name = 'KCESNJ2'    AND C.network_identity = T.cell_network_identity  WHERE T.mobile_network_code = 41    AND T.rx_level < 0 
UNION
SELECT T.date_time, T.x AS Y, T.y AS X, 'KHOP1' AS cell, T.rx_level   FROM tems_gis_history_2010_02_5 T   JOIN network.cell C     ON C.name = 'KHOP1'    AND C.network_identity = T.cell_network_identity  WHERE T.mobile_network_code = 41    AND T.rx_level < 0 
UNION
SELECT T.date_time, T.x AS Y, T.y AS X, 'KORLOV1' AS cell, T.rx_level   FROM tems_gis_history_2010_02_5 T   JOIN network.cell C     ON C.name = 'KORLOV1'    AND C.network_identity = T.cell_network_identity  WHERE T.mobile_network_code = 41    AND T.rx_level < 0 
UNION
SELECT T.date_time, T.x AS Y, T.y AS X, 'KORLOV2' AS cell, T.rx_level   FROM tems_gis_history_2010_02_5 T   JOIN network.cell C     ON C.name = 'KORLOV2'    AND C.network_identity = T.cell_network_identity  WHERE T.mobile_network_code = 41    AND T.rx_level < 0 
UNION
SELECT T.date_time, T.x AS Y, T.y AS X, 'KPOKL1' AS cell, T.rx_level   FROM tems_gis_history_2010_02_5 T   JOIN network.cell C     ON C.name = 'KPOKL1'    AND C.network_identity = T.cell_network_identity  WHERE T.mobile_network_code = 41    AND T.rx_level < 0 
UNION
SELECT T.date_time, T.x AS Y, T.y AS X, 'KPOKL2' AS cell, T.rx_level   FROM tems_gis_history_2010_02_5 T   JOIN network.cell C     ON C.name = 'KPOKL2'    AND C.network_identity = T.cell_network_identity  WHERE T.mobile_network_code = 41    AND T.rx_level < 0 
UNION
SELECT T.date_time, T.x AS Y, T.y AS X, 'KPOKL3' AS cell, T.rx_level   FROM tems_gis_history_2010_02_5 T   JOIN network.cell C     ON C.name = 'KPOKL3'    AND C.network_identity = T.cell_network_identity  WHERE T.mobile_network_code = 41    AND T.rx_level < 0 
UNION
SELECT T.date_time, T.x AS Y, T.y AS X, 'KRIBL1' AS cell, T.rx_level   FROM tems_gis_history_2010_02_5 T   JOIN network.cell C     ON C.name = 'KRIBL1'    AND C.network_identity = T.cell_network_identity  WHERE T.mobile_network_code = 41    AND T.rx_level < 0 
UNION
SELECT T.date_time, T.x AS Y, T.y AS X, 'KRIBL2' AS cell, T.rx_level   FROM tems_gis_history_2010_02_5 T   JOIN network.cell C     ON C.name = 'KRIBL2'    AND C.network_identity = T.cell_network_identity  WHERE T.mobile_network_code = 41    AND T.rx_level < 0 
UNION
SELECT T.date_time, T.x AS Y, T.y AS X, 'KRIBL3' AS cell, T.rx_level   FROM tems_gis_history_2010_02_5 T   JOIN network.cell C     ON C.name = 'KRIBL3'    AND C.network_identity = T.cell_network_identity  WHERE T.mobile_network_code = 41    AND T.rx_level < 0 
UNION
SELECT T.date_time, T.x AS Y, T.y AS X, 'KVOGEL1' AS cell, T.rx_level   FROM tems_gis_history_2010_02_5 T   JOIN network.cell C     ON C.name = 'KVOGEL1'    AND C.network_identity = T.cell_network_identity  WHERE T.mobile_network_code = 41    AND T.rx_level < 0 
UNION
SELECT T.date_time, T.x AS Y, T.y AS X, 'KVOGEL2' AS cell, T.rx_level   FROM tems_gis_history_2010_02_5 T   JOIN network.cell C     ON C.name = 'KVOGEL2'    AND C.network_identity = T.cell_network_identity  WHERE T.mobile_network_code = 41    AND T.rx_level < 0 
UNION
SELECT T.date_time, T.x AS Y, T.y AS X, 'KVOGEL3' AS cell, T.rx_level   FROM tems_gis_history_2010_02_5 T   JOIN network.cell C     ON C.name = 'KVOGEL3'    AND C.network_identity = T.cell_network_identity  WHERE T.mobile_network_code = 41    AND T.rx_level < 0 
) foo
GROUP BY X, Y, cell ORDER BY cell, X, Y, MAX(date_time)
