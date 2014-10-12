SELECT MAX(date_time) AS time, X, Y, cell, AVG(rx_level) AS rx_level FROM (
SELECT T.date_time, T.x AS Y, T.y AS X, 'SBAKOV1' AS cell, T.rx_level   FROM tems_gis_history_2010_02_5 T   JOIN network.cell C     ON C.name = 'SBAKOV1'    AND C.network_identity = T.cell_network_identity  WHERE T.mobile_network_code = 41    AND T.rx_level < 0 
UNION
SELECT T.date_time, T.x AS Y, T.y AS X, 'SBAKOV2' AS cell, T.rx_level   FROM tems_gis_history_2010_02_5 T   JOIN network.cell C     ON C.name = 'SBAKOV2'    AND C.network_identity = T.cell_network_identity  WHERE T.mobile_network_code = 41    AND T.rx_level < 0 
UNION
SELECT T.date_time, T.x AS Y, T.y AS X, 'SBAKOV3' AS cell, T.rx_level   FROM tems_gis_history_2010_02_5 T   JOIN network.cell C     ON C.name = 'SBAKOV3'    AND C.network_identity = T.cell_network_identity  WHERE T.mobile_network_code = 41    AND T.rx_level < 0 
UNION
SELECT T.date_time, T.x AS Y, T.y AS X, 'SBAKOV4' AS cell, T.rx_level   FROM tems_gis_history_2010_02_5 T   JOIN network.cell C     ON C.name = 'SBAKOV4'    AND C.network_identity = T.cell_network_identity  WHERE T.mobile_network_code = 41    AND T.rx_level < 0 
UNION
SELECT T.date_time, T.x AS Y, T.y AS X, 'SBAKOV5' AS cell, T.rx_level   FROM tems_gis_history_2010_02_5 T   JOIN network.cell C     ON C.name = 'SBAKOV5'    AND C.network_identity = T.cell_network_identity  WHERE T.mobile_network_code = 41    AND T.rx_level < 0 
UNION
SELECT T.date_time, T.x AS Y, T.y AS X, 'SBAKOV6' AS cell, T.rx_level   FROM tems_gis_history_2010_02_5 T   JOIN network.cell C     ON C.name = 'SBAKOV6'    AND C.network_identity = T.cell_network_identity  WHERE T.mobile_network_code = 41    AND T.rx_level < 0 
UNION
SELECT T.date_time, T.x AS Y, T.y AS X, 'SBANOV1' AS cell, T.rx_level   FROM tems_gis_history_2010_02_5 T   JOIN network.cell C     ON C.name = 'SBANOV1'    AND C.network_identity = T.cell_network_identity  WHERE T.mobile_network_code = 41    AND T.rx_level < 0 
UNION
SELECT T.date_time, T.x AS Y, T.y AS X, 'SBANOV2' AS cell, T.rx_level   FROM tems_gis_history_2010_02_5 T   JOIN network.cell C     ON C.name = 'SBANOV2'    AND C.network_identity = T.cell_network_identity  WHERE T.mobile_network_code = 41    AND T.rx_level < 0 
UNION
SELECT T.date_time, T.x AS Y, T.y AS X, 'SBANOV3' AS cell, T.rx_level   FROM tems_gis_history_2010_02_5 T   JOIN network.cell C     ON C.name = 'SBANOV3'    AND C.network_identity = T.cell_network_identity  WHERE T.mobile_network_code = 41    AND T.rx_level < 0 
UNION
SELECT T.date_time, T.x AS Y, T.y AS X, 'SBELT1' AS cell, T.rx_level   FROM tems_gis_history_2010_02_5 T   JOIN network.cell C     ON C.name = 'SBELT1'    AND C.network_identity = T.cell_network_identity  WHERE T.mobile_network_code = 41    AND T.rx_level < 0 
UNION
SELECT T.date_time, T.x AS Y, T.y AS X, 'SBELTI1' AS cell, T.rx_level   FROM tems_gis_history_2010_02_5 T   JOIN network.cell C     ON C.name = 'SBELTI1'    AND C.network_identity = T.cell_network_identity  WHERE T.mobile_network_code = 41    AND T.rx_level < 0 
UNION
SELECT T.date_time, T.x AS Y, T.y AS X, 'SBELTI2' AS cell, T.rx_level   FROM tems_gis_history_2010_02_5 T   JOIN network.cell C     ON C.name = 'SBELTI2'    AND C.network_identity = T.cell_network_identity  WHERE T.mobile_network_code = 41    AND T.rx_level < 0 
UNION
SELECT T.date_time, T.x AS Y, T.y AS X, 'SBELTI3' AS cell, T.rx_level   FROM tems_gis_history_2010_02_5 T   JOIN network.cell C     ON C.name = 'SBELTI3'    AND C.network_identity = T.cell_network_identity  WHERE T.mobile_network_code = 41    AND T.rx_level < 0 
UNION
SELECT T.date_time, T.x AS Y, T.y AS X, 'SLJUT1' AS cell, T.rx_level   FROM tems_gis_history_2010_02_5 T   JOIN network.cell C     ON C.name = 'SLJUT1'    AND C.network_identity = T.cell_network_identity  WHERE T.mobile_network_code = 41    AND T.rx_level < 0 
UNION
SELECT T.date_time, T.x AS Y, T.y AS X, 'SLJUT2' AS cell, T.rx_level   FROM tems_gis_history_2010_02_5 T   JOIN network.cell C     ON C.name = 'SLJUT2'    AND C.network_identity = T.cell_network_identity  WHERE T.mobile_network_code = 41    AND T.rx_level < 0 
UNION
SELECT T.date_time, T.x AS Y, T.y AS X, 'SLJUT4' AS cell, T.rx_level   FROM tems_gis_history_2010_02_5 T   JOIN network.cell C     ON C.name = 'SLJUT4'    AND C.network_identity = T.cell_network_identity  WHERE T.mobile_network_code = 41    AND T.rx_level < 0 
UNION
SELECT T.date_time, T.x AS Y, T.y AS X, 'SLJUT5' AS cell, T.rx_level   FROM tems_gis_history_2010_02_5 T   JOIN network.cell C     ON C.name = 'SLJUT5'    AND C.network_identity = T.cell_network_identity  WHERE T.mobile_network_code = 41    AND T.rx_level < 0 
UNION
SELECT T.date_time, T.x AS Y, T.y AS X, 'SLJUTK1' AS cell, T.rx_level   FROM tems_gis_history_2010_02_5 T   JOIN network.cell C     ON C.name = 'SLJUTK1'    AND C.network_identity = T.cell_network_identity  WHERE T.mobile_network_code = 41    AND T.rx_level < 0 
UNION
SELECT T.date_time, T.x AS Y, T.y AS X, 'SLJUTK2' AS cell, T.rx_level   FROM tems_gis_history_2010_02_5 T   JOIN network.cell C     ON C.name = 'SLJUTK2'    AND C.network_identity = T.cell_network_identity  WHERE T.mobile_network_code = 41    AND T.rx_level < 0 
) foo
GROUP BY X, Y, cell ORDER BY cell, X, Y, MAX(date_time)
