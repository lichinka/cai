SELECT MAX(date_time) AS time, X, Y, cell, AVG(rx_level) AS rx_level FROM (
SELECT T.date_time, T.x AS Y, T.y AS X, 'ABEZI1' AS cell, T.rx_level   FROM tems_gis_history_2010_02_5 T   JOIN network.cell C     ON C.name = 'ABEZI1'    AND C.network_identity = T.cell_network_identity  WHERE T.mobile_network_code = 41    AND T.rx_level < 0 
UNION
SELECT T.date_time, T.x AS Y, T.y AS X, 'ABEZI2' AS cell, T.rx_level   FROM tems_gis_history_2010_02_5 T   JOIN network.cell C     ON C.name = 'ABEZI2'    AND C.network_identity = T.cell_network_identity  WHERE T.mobile_network_code = 41    AND T.rx_level < 0 
UNION
SELECT T.date_time, T.x AS Y, T.y AS X, 'ABEZI3' AS cell, T.rx_level   FROM tems_gis_history_2010_02_5 T   JOIN network.cell C     ON C.name = 'ABEZI3'    AND C.network_identity = T.cell_network_identity  WHERE T.mobile_network_code = 41    AND T.rx_level < 0 
UNION
SELECT T.date_time, T.x AS Y, T.y AS X, 'ABEZIT1' AS cell, T.rx_level   FROM tems_gis_history_2010_02_5 T   JOIN network.cell C     ON C.name = 'ABEZIT1'    AND C.network_identity = T.cell_network_identity  WHERE T.mobile_network_code = 41    AND T.rx_level < 0 
UNION
SELECT T.date_time, T.x AS Y, T.y AS X, 'ABROD1' AS cell, T.rx_level   FROM tems_gis_history_2010_02_5 T   JOIN network.cell C     ON C.name = 'ABROD1'    AND C.network_identity = T.cell_network_identity  WHERE T.mobile_network_code = 41    AND T.rx_level < 0 
UNION
SELECT T.date_time, T.x AS Y, T.y AS X, 'ABROD2' AS cell, T.rx_level   FROM tems_gis_history_2010_02_5 T   JOIN network.cell C     ON C.name = 'ABROD2'    AND C.network_identity = T.cell_network_identity  WHERE T.mobile_network_code = 41    AND T.rx_level < 0 
UNION
SELECT T.date_time, T.x AS Y, T.y AS X, 'ABROD3' AS cell, T.rx_level   FROM tems_gis_history_2010_02_5 T   JOIN network.cell C     ON C.name = 'ABROD3'    AND C.network_identity = T.cell_network_identity  WHERE T.mobile_network_code = 41    AND T.rx_level < 0 
UNION
SELECT T.date_time, T.x AS Y, T.y AS X, 'ACERNE4' AS cell, T.rx_level   FROM tems_gis_history_2010_02_5 T   JOIN network.cell C     ON C.name = 'ACERNE4'    AND C.network_identity = T.cell_network_identity  WHERE T.mobile_network_code = 41    AND T.rx_level < 0 
UNION
SELECT T.date_time, T.x AS Y, T.y AS X, 'ACERNE5' AS cell, T.rx_level   FROM tems_gis_history_2010_02_5 T   JOIN network.cell C     ON C.name = 'ACERNE5'    AND C.network_identity = T.cell_network_identity  WHERE T.mobile_network_code = 41    AND T.rx_level < 0 
UNION
SELECT T.date_time, T.x AS Y, T.y AS X, 'ACERNE6' AS cell, T.rx_level   FROM tems_gis_history_2010_02_5 T   JOIN network.cell C     ON C.name = 'ACERNE6'    AND C.network_identity = T.cell_network_identity  WHERE T.mobile_network_code = 41    AND T.rx_level < 0 
UNION
SELECT T.date_time, T.x AS Y, T.y AS X, 'ACHEMO1' AS cell, T.rx_level   FROM tems_gis_history_2010_02_5 T   JOIN network.cell C     ON C.name = 'ACHEMO1'    AND C.network_identity = T.cell_network_identity  WHERE T.mobile_network_code = 41    AND T.rx_level < 0 
UNION
SELECT T.date_time, T.x AS Y, T.y AS X, 'ACHEMO2' AS cell, T.rx_level   FROM tems_gis_history_2010_02_5 T   JOIN network.cell C     ON C.name = 'ACHEMO2'    AND C.network_identity = T.cell_network_identity  WHERE T.mobile_network_code = 41    AND T.rx_level < 0 
UNION
SELECT T.date_time, T.x AS Y, T.y AS X, 'ACHEMO3' AS cell, T.rx_level   FROM tems_gis_history_2010_02_5 T   JOIN network.cell C     ON C.name = 'ACHEMO3'    AND C.network_identity = T.cell_network_identity  WHERE T.mobile_network_code = 41    AND T.rx_level < 0 
UNION
SELECT T.date_time, T.x AS Y, T.y AS X, 'ACHEMO4' AS cell, T.rx_level   FROM tems_gis_history_2010_02_5 T   JOIN network.cell C     ON C.name = 'ACHEMO4'    AND C.network_identity = T.cell_network_identity  WHERE T.mobile_network_code = 41    AND T.rx_level < 0 
UNION
SELECT T.date_time, T.x AS Y, T.y AS X, 'ACRGMA1' AS cell, T.rx_level   FROM tems_gis_history_2010_02_5 T   JOIN network.cell C     ON C.name = 'ACRGMA1'    AND C.network_identity = T.cell_network_identity  WHERE T.mobile_network_code = 41    AND T.rx_level < 0 
UNION
SELECT T.date_time, T.x AS Y, T.y AS X, 'ACRGMA2' AS cell, T.rx_level   FROM tems_gis_history_2010_02_5 T   JOIN network.cell C     ON C.name = 'ACRGMA2'    AND C.network_identity = T.cell_network_identity  WHERE T.mobile_network_code = 41    AND T.rx_level < 0 
UNION
SELECT T.date_time, T.x AS Y, T.y AS X, 'ADELO1' AS cell, T.rx_level   FROM tems_gis_history_2010_02_5 T   JOIN network.cell C     ON C.name = 'ADELO1'    AND C.network_identity = T.cell_network_identity  WHERE T.mobile_network_code = 41    AND T.rx_level < 0 
UNION
SELECT T.date_time, T.x AS Y, T.y AS X, 'ADELO2' AS cell, T.rx_level   FROM tems_gis_history_2010_02_5 T   JOIN network.cell C     ON C.name = 'ADELO2'    AND C.network_identity = T.cell_network_identity  WHERE T.mobile_network_code = 41    AND T.rx_level < 0 
UNION
SELECT T.date_time, T.x AS Y, T.y AS X, 'ADELO3' AS cell, T.rx_level   FROM tems_gis_history_2010_02_5 T   JOIN network.cell C     ON C.name = 'ADELO3'    AND C.network_identity = T.cell_network_identity  WHERE T.mobile_network_code = 41    AND T.rx_level < 0 
UNION
SELECT T.date_time, T.x AS Y, T.y AS X, 'ADELO4' AS cell, T.rx_level   FROM tems_gis_history_2010_02_5 T   JOIN network.cell C     ON C.name = 'ADELO4'    AND C.network_identity = T.cell_network_identity  WHERE T.mobile_network_code = 41    AND T.rx_level < 0 
UNION
SELECT T.date_time, T.x AS Y, T.y AS X, 'ADELO5' AS cell, T.rx_level   FROM tems_gis_history_2010_02_5 T   JOIN network.cell C     ON C.name = 'ADELO5'    AND C.network_identity = T.cell_network_identity  WHERE T.mobile_network_code = 41    AND T.rx_level < 0 
UNION
SELECT T.date_time, T.x AS Y, T.y AS X, 'ADRAV1' AS cell, T.rx_level   FROM tems_gis_history_2010_02_5 T   JOIN network.cell C     ON C.name = 'ADRAV1'    AND C.network_identity = T.cell_network_identity  WHERE T.mobile_network_code = 41    AND T.rx_level < 0 
UNION
SELECT T.date_time, T.x AS Y, T.y AS X, 'ADRAV2' AS cell, T.rx_level   FROM tems_gis_history_2010_02_5 T   JOIN network.cell C     ON C.name = 'ADRAV2'    AND C.network_identity = T.cell_network_identity  WHERE T.mobile_network_code = 41    AND T.rx_level < 0 
UNION
SELECT T.date_time, T.x AS Y, T.y AS X, 'ADRAV3' AS cell, T.rx_level   FROM tems_gis_history_2010_02_5 T   JOIN network.cell C     ON C.name = 'ADRAV3'    AND C.network_identity = T.cell_network_identity  WHERE T.mobile_network_code = 41    AND T.rx_level < 0 
UNION
SELECT T.date_time, T.x AS Y, T.y AS X, 'AELNA1' AS cell, T.rx_level   FROM tems_gis_history_2010_02_5 T   JOIN network.cell C     ON C.name = 'AELNA1'    AND C.network_identity = T.cell_network_identity  WHERE T.mobile_network_code = 41    AND T.rx_level < 0 
UNION
SELECT T.date_time, T.x AS Y, T.y AS X, 'AELNA2' AS cell, T.rx_level   FROM tems_gis_history_2010_02_5 T   JOIN network.cell C     ON C.name = 'AELNA2'    AND C.network_identity = T.cell_network_identity  WHERE T.mobile_network_code = 41    AND T.rx_level < 0 
UNION
SELECT T.date_time, T.x AS Y, T.y AS X, 'AELNA3' AS cell, T.rx_level   FROM tems_gis_history_2010_02_5 T   JOIN network.cell C     ON C.name = 'AELNA3'    AND C.network_identity = T.cell_network_identity  WHERE T.mobile_network_code = 41    AND T.rx_level < 0 
UNION
SELECT T.date_time, T.x AS Y, T.y AS X, 'AFORD1' AS cell, T.rx_level   FROM tems_gis_history_2010_02_5 T   JOIN network.cell C     ON C.name = 'AFORD1'    AND C.network_identity = T.cell_network_identity  WHERE T.mobile_network_code = 41    AND T.rx_level < 0 
UNION
SELECT T.date_time, T.x AS Y, T.y AS X, 'AFRANK1' AS cell, T.rx_level   FROM tems_gis_history_2010_02_5 T   JOIN network.cell C     ON C.name = 'AFRANK1'    AND C.network_identity = T.cell_network_identity  WHERE T.mobile_network_code = 41    AND T.rx_level < 0 
UNION
SELECT T.date_time, T.x AS Y, T.y AS X, 'AFRANK2' AS cell, T.rx_level   FROM tems_gis_history_2010_02_5 T   JOIN network.cell C     ON C.name = 'AFRANK2'    AND C.network_identity = T.cell_network_identity  WHERE T.mobile_network_code = 41    AND T.rx_level < 0 
UNION
SELECT T.date_time, T.x AS Y, T.y AS X, 'AFRANK3' AS cell, T.rx_level   FROM tems_gis_history_2010_02_5 T   JOIN network.cell C     ON C.name = 'AFRANK3'    AND C.network_identity = T.cell_network_identity  WHERE T.mobile_network_code = 41    AND T.rx_level < 0 
UNION
SELECT T.date_time, T.x AS Y, T.y AS X, 'AFRANK4' AS cell, T.rx_level   FROM tems_gis_history_2010_02_5 T   JOIN network.cell C     ON C.name = 'AFRANK4'    AND C.network_identity = T.cell_network_identity  WHERE T.mobile_network_code = 41    AND T.rx_level < 0 
UNION
SELECT T.date_time, T.x AS Y, T.y AS X, 'AFRANK5' AS cell, T.rx_level   FROM tems_gis_history_2010_02_5 T   JOIN network.cell C     ON C.name = 'AFRANK5'    AND C.network_identity = T.cell_network_identity  WHERE T.mobile_network_code = 41    AND T.rx_level < 0 
UNION
SELECT T.date_time, T.x AS Y, T.y AS X, 'AFRANK7' AS cell, T.rx_level   FROM tems_gis_history_2010_02_5 T   JOIN network.cell C     ON C.name = 'AFRANK7'    AND C.network_identity = T.cell_network_identity  WHERE T.mobile_network_code = 41    AND T.rx_level < 0 
UNION
SELECT T.date_time, T.x AS Y, T.y AS X, 'AGEOPL1' AS cell, T.rx_level   FROM tems_gis_history_2010_02_5 T   JOIN network.cell C     ON C.name = 'AGEOPL1'    AND C.network_identity = T.cell_network_identity  WHERE T.mobile_network_code = 41    AND T.rx_level < 0 
UNION
SELECT T.date_time, T.x AS Y, T.y AS X, 'AGEOPL2' AS cell, T.rx_level   FROM tems_gis_history_2010_02_5 T   JOIN network.cell C     ON C.name = 'AGEOPL2'    AND C.network_identity = T.cell_network_identity  WHERE T.mobile_network_code = 41    AND T.rx_level < 0 
UNION
SELECT T.date_time, T.x AS Y, T.y AS X, 'AGEOPL3' AS cell, T.rx_level   FROM tems_gis_history_2010_02_5 T   JOIN network.cell C     ON C.name = 'AGEOPL3'    AND C.network_identity = T.cell_network_identity  WHERE T.mobile_network_code = 41    AND T.rx_level < 0 
UNION
SELECT T.date_time, T.x AS Y, T.y AS X, 'AGRAM1' AS cell, T.rx_level   FROM tems_gis_history_2010_02_5 T   JOIN network.cell C     ON C.name = 'AGRAM1'    AND C.network_identity = T.cell_network_identity  WHERE T.mobile_network_code = 41    AND T.rx_level < 0 
UNION
SELECT T.date_time, T.x AS Y, T.y AS X, 'AGRAM2' AS cell, T.rx_level   FROM tems_gis_history_2010_02_5 T   JOIN network.cell C     ON C.name = 'AGRAM2'    AND C.network_identity = T.cell_network_identity  WHERE T.mobile_network_code = 41    AND T.rx_level < 0 
UNION
SELECT T.date_time, T.x AS Y, T.y AS X, 'AGRAM3' AS cell, T.rx_level   FROM tems_gis_history_2010_02_5 T   JOIN network.cell C     ON C.name = 'AGRAM3'    AND C.network_identity = T.cell_network_identity  WHERE T.mobile_network_code = 41    AND T.rx_level < 0 
UNION
SELECT T.date_time, T.x AS Y, T.y AS X, 'AGRIC1' AS cell, T.rx_level   FROM tems_gis_history_2010_02_5 T   JOIN network.cell C     ON C.name = 'AGRIC1'    AND C.network_identity = T.cell_network_identity  WHERE T.mobile_network_code = 41    AND T.rx_level < 0 
UNION
SELECT T.date_time, T.x AS Y, T.y AS X, 'AGRIC2' AS cell, T.rx_level   FROM tems_gis_history_2010_02_5 T   JOIN network.cell C     ON C.name = 'AGRIC2'    AND C.network_identity = T.cell_network_identity  WHERE T.mobile_network_code = 41    AND T.rx_level < 0 
UNION
SELECT T.date_time, T.x AS Y, T.y AS X, 'AGRIC3' AS cell, T.rx_level   FROM tems_gis_history_2010_02_5 T   JOIN network.cell C     ON C.name = 'AGRIC3'    AND C.network_identity = T.cell_network_identity  WHERE T.mobile_network_code = 41    AND T.rx_level < 0 
UNION
SELECT T.date_time, T.x AS Y, T.y AS X, 'AGZ1' AS cell, T.rx_level   FROM tems_gis_history_2010_02_5 T   JOIN network.cell C     ON C.name = 'AGZ1'    AND C.network_identity = T.cell_network_identity  WHERE T.mobile_network_code = 41    AND T.rx_level < 0 
UNION
SELECT T.date_time, T.x AS Y, T.y AS X, 'AGZ2' AS cell, T.rx_level   FROM tems_gis_history_2010_02_5 T   JOIN network.cell C     ON C.name = 'AGZ2'    AND C.network_identity = T.cell_network_identity  WHERE T.mobile_network_code = 41    AND T.rx_level < 0 
UNION
SELECT T.date_time, T.x AS Y, T.y AS X, 'AGZ3' AS cell, T.rx_level   FROM tems_gis_history_2010_02_5 T   JOIN network.cell C     ON C.name = 'AGZ3'    AND C.network_identity = T.cell_network_identity  WHERE T.mobile_network_code = 41    AND T.rx_level < 0 
UNION
SELECT T.date_time, T.x AS Y, T.y AS X, 'AGZ4' AS cell, T.rx_level   FROM tems_gis_history_2010_02_5 T   JOIN network.cell C     ON C.name = 'AGZ4'    AND C.network_identity = T.cell_network_identity  WHERE T.mobile_network_code = 41    AND T.rx_level < 0 
UNION
SELECT T.date_time, T.x AS Y, T.y AS X, 'AGZ5' AS cell, T.rx_level   FROM tems_gis_history_2010_02_5 T   JOIN network.cell C     ON C.name = 'AGZ5'    AND C.network_identity = T.cell_network_identity  WHERE T.mobile_network_code = 41    AND T.rx_level < 0 
UNION
SELECT T.date_time, T.x AS Y, T.y AS X, 'AGZ6' AS cell, T.rx_level   FROM tems_gis_history_2010_02_5 T   JOIN network.cell C     ON C.name = 'AGZ6'    AND C.network_identity = T.cell_network_identity  WHERE T.mobile_network_code = 41    AND T.rx_level < 0 
UNION
SELECT T.date_time, T.x AS Y, T.y AS X, 'AHALA1' AS cell, T.rx_level   FROM tems_gis_history_2010_02_5 T   JOIN network.cell C     ON C.name = 'AHALA1'    AND C.network_identity = T.cell_network_identity  WHERE T.mobile_network_code = 41    AND T.rx_level < 0 
UNION
SELECT T.date_time, T.x AS Y, T.y AS X, 'AHLEV1' AS cell, T.rx_level   FROM tems_gis_history_2010_02_5 T   JOIN network.cell C     ON C.name = 'AHLEV1'    AND C.network_identity = T.cell_network_identity  WHERE T.mobile_network_code = 41    AND T.rx_level < 0 
UNION
SELECT T.date_time, T.x AS Y, T.y AS X, 'AHLEV2' AS cell, T.rx_level   FROM tems_gis_history_2010_02_5 T   JOIN network.cell C     ON C.name = 'AHLEV2'    AND C.network_identity = T.cell_network_identity  WHERE T.mobile_network_code = 41    AND T.rx_level < 0 
UNION
SELECT T.date_time, T.x AS Y, T.y AS X, 'AHLEV3' AS cell, T.rx_level   FROM tems_gis_history_2010_02_5 T   JOIN network.cell C     ON C.name = 'AHLEV3'    AND C.network_identity = T.cell_network_identity  WHERE T.mobile_network_code = 41    AND T.rx_level < 0 
UNION
SELECT T.date_time, T.x AS Y, T.y AS X, 'AJEZKZ1' AS cell, T.rx_level   FROM tems_gis_history_2010_02_5 T   JOIN network.cell C     ON C.name = 'AJEZKZ1'    AND C.network_identity = T.cell_network_identity  WHERE T.mobile_network_code = 41    AND T.rx_level < 0 
UNION
SELECT T.date_time, T.x AS Y, T.y AS X, 'AJEZKZ2' AS cell, T.rx_level   FROM tems_gis_history_2010_02_5 T   JOIN network.cell C     ON C.name = 'AJEZKZ2'    AND C.network_identity = T.cell_network_identity  WHERE T.mobile_network_code = 41    AND T.rx_level < 0 
UNION
SELECT T.date_time, T.x AS Y, T.y AS X, 'AJEZKZ3' AS cell, T.rx_level   FROM tems_gis_history_2010_02_5 T   JOIN network.cell C     ON C.name = 'AJEZKZ3'    AND C.network_identity = T.cell_network_identity  WHERE T.mobile_network_code = 41    AND T.rx_level < 0 
UNION
SELECT T.date_time, T.x AS Y, T.y AS X, 'AKOLIN1' AS cell, T.rx_level   FROM tems_gis_history_2010_02_5 T   JOIN network.cell C     ON C.name = 'AKOLIN1'    AND C.network_identity = T.cell_network_identity  WHERE T.mobile_network_code = 41    AND T.rx_level < 0 
UNION
SELECT T.date_time, T.x AS Y, T.y AS X, 'AKOLIN2' AS cell, T.rx_level   FROM tems_gis_history_2010_02_5 T   JOIN network.cell C     ON C.name = 'AKOLIN2'    AND C.network_identity = T.cell_network_identity  WHERE T.mobile_network_code = 41    AND T.rx_level < 0 
UNION
SELECT T.date_time, T.x AS Y, T.y AS X, 'AKOLIN3' AS cell, T.rx_level   FROM tems_gis_history_2010_02_5 T   JOIN network.cell C     ON C.name = 'AKOLIN3'    AND C.network_identity = T.cell_network_identity  WHERE T.mobile_network_code = 41    AND T.rx_level < 0 
UNION
SELECT T.date_time, T.x AS Y, T.y AS X, 'AKOSEG1' AS cell, T.rx_level   FROM tems_gis_history_2010_02_5 T   JOIN network.cell C     ON C.name = 'AKOSEG1'    AND C.network_identity = T.cell_network_identity  WHERE T.mobile_network_code = 41    AND T.rx_level < 0 
UNION
SELECT T.date_time, T.x AS Y, T.y AS X, 'AKOSEG2' AS cell, T.rx_level   FROM tems_gis_history_2010_02_5 T   JOIN network.cell C     ON C.name = 'AKOSEG2'    AND C.network_identity = T.cell_network_identity  WHERE T.mobile_network_code = 41    AND T.rx_level < 0 
UNION
SELECT T.date_time, T.x AS Y, T.y AS X, 'AKOSEG3' AS cell, T.rx_level   FROM tems_gis_history_2010_02_5 T   JOIN network.cell C     ON C.name = 'AKOSEG3'    AND C.network_identity = T.cell_network_identity  WHERE T.mobile_network_code = 41    AND T.rx_level < 0 
UNION
SELECT T.date_time, T.x AS Y, T.y AS X, 'AKOSEZ1' AS cell, T.rx_level   FROM tems_gis_history_2010_02_5 T   JOIN network.cell C     ON C.name = 'AKOSEZ1'    AND C.network_identity = T.cell_network_identity  WHERE T.mobile_network_code = 41    AND T.rx_level < 0 
UNION
SELECT T.date_time, T.x AS Y, T.y AS X, 'AKOSEZ2' AS cell, T.rx_level   FROM tems_gis_history_2010_02_5 T   JOIN network.cell C     ON C.name = 'AKOSEZ2'    AND C.network_identity = T.cell_network_identity  WHERE T.mobile_network_code = 41    AND T.rx_level < 0 
UNION
SELECT T.date_time, T.x AS Y, T.y AS X, 'AKOSEZ3' AS cell, T.rx_level   FROM tems_gis_history_2010_02_5 T   JOIN network.cell C     ON C.name = 'AKOSEZ3'    AND C.network_identity = T.cell_network_identity  WHERE T.mobile_network_code = 41    AND T.rx_level < 0 
UNION
SELECT T.date_time, T.x AS Y, T.y AS X, 'AKOSME1' AS cell, T.rx_level   FROM tems_gis_history_2010_02_5 T   JOIN network.cell C     ON C.name = 'AKOSME1'    AND C.network_identity = T.cell_network_identity  WHERE T.mobile_network_code = 41    AND T.rx_level < 0 
UNION
SELECT T.date_time, T.x AS Y, T.y AS X, 'AKOTNI4' AS cell, T.rx_level   FROM tems_gis_history_2010_02_5 T   JOIN network.cell C     ON C.name = 'AKOTNI4'    AND C.network_identity = T.cell_network_identity  WHERE T.mobile_network_code = 41    AND T.rx_level < 0 
UNION
SELECT T.date_time, T.x AS Y, T.y AS X, 'AKOTNI5' AS cell, T.rx_level   FROM tems_gis_history_2010_02_5 T   JOIN network.cell C     ON C.name = 'AKOTNI5'    AND C.network_identity = T.cell_network_identity  WHERE T.mobile_network_code = 41    AND T.rx_level < 0 
UNION
SELECT T.date_time, T.x AS Y, T.y AS X, 'AKOTNI6' AS cell, T.rx_level   FROM tems_gis_history_2010_02_5 T   JOIN network.cell C     ON C.name = 'AKOTNI6'    AND C.network_identity = T.cell_network_identity  WHERE T.mobile_network_code = 41    AND T.rx_level < 0 
UNION
SELECT T.date_time, T.x AS Y, T.y AS X, 'AKOVIN1' AS cell, T.rx_level   FROM tems_gis_history_2010_02_5 T   JOIN network.cell C     ON C.name = 'AKOVIN1'    AND C.network_identity = T.cell_network_identity  WHERE T.mobile_network_code = 41    AND T.rx_level < 0 
UNION
SELECT T.date_time, T.x AS Y, T.y AS X, 'AKOVIN2' AS cell, T.rx_level   FROM tems_gis_history_2010_02_5 T   JOIN network.cell C     ON C.name = 'AKOVIN2'    AND C.network_identity = T.cell_network_identity  WHERE T.mobile_network_code = 41    AND T.rx_level < 0 
UNION
SELECT T.date_time, T.x AS Y, T.y AS X, 'AKOVIN3' AS cell, T.rx_level   FROM tems_gis_history_2010_02_5 T   JOIN network.cell C     ON C.name = 'AKOVIN3'    AND C.network_identity = T.cell_network_identity  WHERE T.mobile_network_code = 41    AND T.rx_level < 0 
UNION
SELECT T.date_time, T.x AS Y, T.y AS X, 'ALMLEK4' AS cell, T.rx_level   FROM tems_gis_history_2010_02_5 T   JOIN network.cell C     ON C.name = 'ALMLEK4'    AND C.network_identity = T.cell_network_identity  WHERE T.mobile_network_code = 41    AND T.rx_level < 0 
UNION
SELECT T.date_time, T.x AS Y, T.y AS X, 'ALPP1' AS cell, T.rx_level   FROM tems_gis_history_2010_02_5 T   JOIN network.cell C     ON C.name = 'ALPP1'    AND C.network_identity = T.cell_network_identity  WHERE T.mobile_network_code = 41    AND T.rx_level < 0 
UNION
SELECT T.date_time, T.x AS Y, T.y AS X, 'ALPP2' AS cell, T.rx_level   FROM tems_gis_history_2010_02_5 T   JOIN network.cell C     ON C.name = 'ALPP2'    AND C.network_identity = T.cell_network_identity  WHERE T.mobile_network_code = 41    AND T.rx_level < 0 
UNION
SELECT T.date_time, T.x AS Y, T.y AS X, 'ALPP3' AS cell, T.rx_level   FROM tems_gis_history_2010_02_5 T   JOIN network.cell C     ON C.name = 'ALPP3'    AND C.network_identity = T.cell_network_identity  WHERE T.mobile_network_code = 41    AND T.rx_level < 0 
UNION
SELECT T.date_time, T.x AS Y, T.y AS X, 'AMHOTE1' AS cell, T.rx_level   FROM tems_gis_history_2010_02_5 T   JOIN network.cell C     ON C.name = 'AMHOTE1'    AND C.network_identity = T.cell_network_identity  WHERE T.mobile_network_code = 41    AND T.rx_level < 0 
UNION
SELECT T.date_time, T.x AS Y, T.y AS X, 'AMHOTE2' AS cell, T.rx_level   FROM tems_gis_history_2010_02_5 T   JOIN network.cell C     ON C.name = 'AMHOTE2'    AND C.network_identity = T.cell_network_identity  WHERE T.mobile_network_code = 41    AND T.rx_level < 0 
UNION
SELECT T.date_time, T.x AS Y, T.y AS X, 'AMHOTE3' AS cell, T.rx_level   FROM tems_gis_history_2010_02_5 T   JOIN network.cell C     ON C.name = 'AMHOTE3'    AND C.network_identity = T.cell_network_identity  WHERE T.mobile_network_code = 41    AND T.rx_level < 0 
UNION
SELECT T.date_time, T.x AS Y, T.y AS X, 'AMOBI1' AS cell, T.rx_level   FROM tems_gis_history_2010_02_5 T   JOIN network.cell C     ON C.name = 'AMOBI1'    AND C.network_identity = T.cell_network_identity  WHERE T.mobile_network_code = 41    AND T.rx_level < 0 
UNION
SELECT T.date_time, T.x AS Y, T.y AS X, 'AMOBI2' AS cell, T.rx_level   FROM tems_gis_history_2010_02_5 T   JOIN network.cell C     ON C.name = 'AMOBI2'    AND C.network_identity = T.cell_network_identity  WHERE T.mobile_network_code = 41    AND T.rx_level < 0 
UNION
SELECT T.date_time, T.x AS Y, T.y AS X, 'AMOBI3' AS cell, T.rx_level   FROM tems_gis_history_2010_02_5 T   JOIN network.cell C     ON C.name = 'AMOBI3'    AND C.network_identity = T.cell_network_identity  WHERE T.mobile_network_code = 41    AND T.rx_level < 0 
UNION
SELECT T.date_time, T.x AS Y, T.y AS X, 'AMOBI4' AS cell, T.rx_level   FROM tems_gis_history_2010_02_5 T   JOIN network.cell C     ON C.name = 'AMOBI4'    AND C.network_identity = T.cell_network_identity  WHERE T.mobile_network_code = 41    AND T.rx_level < 0 
UNION
SELECT T.date_time, T.x AS Y, T.y AS X, 'AMZS1' AS cell, T.rx_level   FROM tems_gis_history_2010_02_5 T   JOIN network.cell C     ON C.name = 'AMZS1'    AND C.network_identity = T.cell_network_identity  WHERE T.mobile_network_code = 41    AND T.rx_level < 0 
UNION
SELECT T.date_time, T.x AS Y, T.y AS X, 'AMZS2' AS cell, T.rx_level   FROM tems_gis_history_2010_02_5 T   JOIN network.cell C     ON C.name = 'AMZS2'    AND C.network_identity = T.cell_network_identity  WHERE T.mobile_network_code = 41    AND T.rx_level < 0 
UNION
SELECT T.date_time, T.x AS Y, T.y AS X, 'AMZS3' AS cell, T.rx_level   FROM tems_gis_history_2010_02_5 T   JOIN network.cell C     ON C.name = 'AMZS3'    AND C.network_identity = T.cell_network_identity  WHERE T.mobile_network_code = 41    AND T.rx_level < 0 
UNION
SELECT T.date_time, T.x AS Y, T.y AS X, 'AMZS4' AS cell, T.rx_level   FROM tems_gis_history_2010_02_5 T   JOIN network.cell C     ON C.name = 'AMZS4'    AND C.network_identity = T.cell_network_identity  WHERE T.mobile_network_code = 41    AND T.rx_level < 0 
UNION
SELECT T.date_time, T.x AS Y, T.y AS X, 'AMZS5' AS cell, T.rx_level   FROM tems_gis_history_2010_02_5 T   JOIN network.cell C     ON C.name = 'AMZS5'    AND C.network_identity = T.cell_network_identity  WHERE T.mobile_network_code = 41    AND T.rx_level < 0 
UNION
SELECT T.date_time, T.x AS Y, T.y AS X, 'AMZS6' AS cell, T.rx_level   FROM tems_gis_history_2010_02_5 T   JOIN network.cell C     ON C.name = 'AMZS6'    AND C.network_identity = T.cell_network_identity  WHERE T.mobile_network_code = 41    AND T.rx_level < 0 
UNION
SELECT T.date_time, T.x AS Y, T.y AS X, 'APETRO4' AS cell, T.rx_level   FROM tems_gis_history_2010_02_5 T   JOIN network.cell C     ON C.name = 'APETRO4'    AND C.network_identity = T.cell_network_identity  WHERE T.mobile_network_code = 41    AND T.rx_level < 0 
UNION
SELECT T.date_time, T.x AS Y, T.y AS X, 'APODUT1' AS cell, T.rx_level   FROM tems_gis_history_2010_02_5 T   JOIN network.cell C     ON C.name = 'APODUT1'    AND C.network_identity = T.cell_network_identity  WHERE T.mobile_network_code = 41    AND T.rx_level < 0 
UNION
SELECT T.date_time, T.x AS Y, T.y AS X, 'APODUT2' AS cell, T.rx_level   FROM tems_gis_history_2010_02_5 T   JOIN network.cell C     ON C.name = 'APODUT2'    AND C.network_identity = T.cell_network_identity  WHERE T.mobile_network_code = 41    AND T.rx_level < 0 
UNION
SELECT T.date_time, T.x AS Y, T.y AS X, 'APODUT3' AS cell, T.rx_level   FROM tems_gis_history_2010_02_5 T   JOIN network.cell C     ON C.name = 'APODUT3'    AND C.network_identity = T.cell_network_identity  WHERE T.mobile_network_code = 41    AND T.rx_level < 0 
UNION
SELECT T.date_time, T.x AS Y, T.y AS X, 'APOPTV1' AS cell, T.rx_level   FROM tems_gis_history_2010_02_5 T   JOIN network.cell C     ON C.name = 'APOPTV1'    AND C.network_identity = T.cell_network_identity  WHERE T.mobile_network_code = 41    AND T.rx_level < 0 
UNION
SELECT T.date_time, T.x AS Y, T.y AS X, 'APOPTV2' AS cell, T.rx_level   FROM tems_gis_history_2010_02_5 T   JOIN network.cell C     ON C.name = 'APOPTV2'    AND C.network_identity = T.cell_network_identity  WHERE T.mobile_network_code = 41    AND T.rx_level < 0 
UNION
SELECT T.date_time, T.x AS Y, T.y AS X, 'APOPTV3' AS cell, T.rx_level   FROM tems_gis_history_2010_02_5 T   JOIN network.cell C     ON C.name = 'APOPTV3'    AND C.network_identity = T.cell_network_identity  WHERE T.mobile_network_code = 41    AND T.rx_level < 0 
UNION
SELECT T.date_time, T.x AS Y, T.y AS X, 'APRZAC1' AS cell, T.rx_level   FROM tems_gis_history_2010_02_5 T   JOIN network.cell C     ON C.name = 'APRZAC1'    AND C.network_identity = T.cell_network_identity  WHERE T.mobile_network_code = 41    AND T.rx_level < 0 
UNION
SELECT T.date_time, T.x AS Y, T.y AS X, 'APRZAN1' AS cell, T.rx_level   FROM tems_gis_history_2010_02_5 T   JOIN network.cell C     ON C.name = 'APRZAN1'    AND C.network_identity = T.cell_network_identity  WHERE T.mobile_network_code = 41    AND T.rx_level < 0 
UNION
SELECT T.date_time, T.x AS Y, T.y AS X, 'ASAVLJ1' AS cell, T.rx_level   FROM tems_gis_history_2010_02_5 T   JOIN network.cell C     ON C.name = 'ASAVLJ1'    AND C.network_identity = T.cell_network_identity  WHERE T.mobile_network_code = 41    AND T.rx_level < 0 
UNION
SELECT T.date_time, T.x AS Y, T.y AS X, 'ASAVLJ2' AS cell, T.rx_level   FROM tems_gis_history_2010_02_5 T   JOIN network.cell C     ON C.name = 'ASAVLJ2'    AND C.network_identity = T.cell_network_identity  WHERE T.mobile_network_code = 41    AND T.rx_level < 0 
UNION
SELECT T.date_time, T.x AS Y, T.y AS X, 'ASAVLJ3' AS cell, T.rx_level   FROM tems_gis_history_2010_02_5 T   JOIN network.cell C     ON C.name = 'ASAVLJ3'    AND C.network_identity = T.cell_network_identity  WHERE T.mobile_network_code = 41    AND T.rx_level < 0 
UNION
SELECT T.date_time, T.x AS Y, T.y AS X, 'ASISKP1' AS cell, T.rx_level   FROM tems_gis_history_2010_02_5 T   JOIN network.cell C     ON C.name = 'ASISKP1'    AND C.network_identity = T.cell_network_identity  WHERE T.mobile_network_code = 41    AND T.rx_level < 0 
UNION
SELECT T.date_time, T.x AS Y, T.y AS X, 'ASISKP2' AS cell, T.rx_level   FROM tems_gis_history_2010_02_5 T   JOIN network.cell C     ON C.name = 'ASISKP2'    AND C.network_identity = T.cell_network_identity  WHERE T.mobile_network_code = 41    AND T.rx_level < 0 
UNION
SELECT T.date_time, T.x AS Y, T.y AS X, 'ASISKP3' AS cell, T.rx_level   FROM tems_gis_history_2010_02_5 T   JOIN network.cell C     ON C.name = 'ASISKP3'    AND C.network_identity = T.cell_network_identity  WHERE T.mobile_network_code = 41    AND T.rx_level < 0 
UNION
SELECT T.date_time, T.x AS Y, T.y AS X, 'ASKZ1' AS cell, T.rx_level   FROM tems_gis_history_2010_02_5 T   JOIN network.cell C     ON C.name = 'ASKZ1'    AND C.network_identity = T.cell_network_identity  WHERE T.mobile_network_code = 41    AND T.rx_level < 0 
UNION
SELECT T.date_time, T.x AS Y, T.y AS X, 'ASKZ2' AS cell, T.rx_level   FROM tems_gis_history_2010_02_5 T   JOIN network.cell C     ON C.name = 'ASKZ2'    AND C.network_identity = T.cell_network_identity  WHERE T.mobile_network_code = 41    AND T.rx_level < 0 
UNION
SELECT T.date_time, T.x AS Y, T.y AS X, 'ASKZ3' AS cell, T.rx_level   FROM tems_gis_history_2010_02_5 T   JOIN network.cell C     ON C.name = 'ASKZ3'    AND C.network_identity = T.cell_network_identity  WHERE T.mobile_network_code = 41    AND T.rx_level < 0 
UNION
SELECT T.date_time, T.x AS Y, T.y AS X, 'ASLOM1' AS cell, T.rx_level   FROM tems_gis_history_2010_02_5 T   JOIN network.cell C     ON C.name = 'ASLOM1'    AND C.network_identity = T.cell_network_identity  WHERE T.mobile_network_code = 41    AND T.rx_level < 0 
UNION
SELECT T.date_time, T.x AS Y, T.y AS X, 'ASLOM2' AS cell, T.rx_level   FROM tems_gis_history_2010_02_5 T   JOIN network.cell C     ON C.name = 'ASLOM2'    AND C.network_identity = T.cell_network_identity  WHERE T.mobile_network_code = 41    AND T.rx_level < 0 
UNION
SELECT T.date_time, T.x AS Y, T.y AS X, 'ASLOM3' AS cell, T.rx_level   FROM tems_gis_history_2010_02_5 T   JOIN network.cell C     ON C.name = 'ASLOM3'    AND C.network_identity = T.cell_network_identity  WHERE T.mobile_network_code = 41    AND T.rx_level < 0 
UNION
SELECT T.date_time, T.x AS Y, T.y AS X, 'ASLOM4' AS cell, T.rx_level   FROM tems_gis_history_2010_02_5 T   JOIN network.cell C     ON C.name = 'ASLOM4'    AND C.network_identity = T.cell_network_identity  WHERE T.mobile_network_code = 41    AND T.rx_level < 0 
UNION
SELECT T.date_time, T.x AS Y, T.y AS X, 'ASLOM5' AS cell, T.rx_level   FROM tems_gis_history_2010_02_5 T   JOIN network.cell C     ON C.name = 'ASLOM5'    AND C.network_identity = T.cell_network_identity  WHERE T.mobile_network_code = 41    AND T.rx_level < 0 
UNION
SELECT T.date_time, T.x AS Y, T.y AS X, 'ASLOM6' AS cell, T.rx_level   FROM tems_gis_history_2010_02_5 T   JOIN network.cell C     ON C.name = 'ASLOM6'    AND C.network_identity = T.cell_network_identity  WHERE T.mobile_network_code = 41    AND T.rx_level < 0 
UNION
SELECT T.date_time, T.x AS Y, T.y AS X, 'ASMELT1' AS cell, T.rx_level   FROM tems_gis_history_2010_02_5 T   JOIN network.cell C     ON C.name = 'ASMELT1'    AND C.network_identity = T.cell_network_identity  WHERE T.mobile_network_code = 41    AND T.rx_level < 0 
UNION
SELECT T.date_time, T.x AS Y, T.y AS X, 'ASMELT2' AS cell, T.rx_level   FROM tems_gis_history_2010_02_5 T   JOIN network.cell C     ON C.name = 'ASMELT2'    AND C.network_identity = T.cell_network_identity  WHERE T.mobile_network_code = 41    AND T.rx_level < 0 
UNION
SELECT T.date_time, T.x AS Y, T.y AS X, 'ASMELT4' AS cell, T.rx_level   FROM tems_gis_history_2010_02_5 T   JOIN network.cell C     ON C.name = 'ASMELT4'    AND C.network_identity = T.cell_network_identity  WHERE T.mobile_network_code = 41    AND T.rx_level < 0 
UNION
SELECT T.date_time, T.x AS Y, T.y AS X, 'ASMELT5' AS cell, T.rx_level   FROM tems_gis_history_2010_02_5 T   JOIN network.cell C     ON C.name = 'ASMELT5'    AND C.network_identity = T.cell_network_identity  WHERE T.mobile_network_code = 41    AND T.rx_level < 0 
UNION
SELECT T.date_time, T.x AS Y, T.y AS X, 'ASMELT6' AS cell, T.rx_level   FROM tems_gis_history_2010_02_5 T   JOIN network.cell C     ON C.name = 'ASMELT6'    AND C.network_identity = T.cell_network_identity  WHERE T.mobile_network_code = 41    AND T.rx_level < 0 
UNION
SELECT T.date_time, T.x AS Y, T.y AS X, 'ASONCE4' AS cell, T.rx_level   FROM tems_gis_history_2010_02_5 T   JOIN network.cell C     ON C.name = 'ASONCE4'    AND C.network_identity = T.cell_network_identity  WHERE T.mobile_network_code = 41    AND T.rx_level < 0 
UNION
SELECT T.date_time, T.x AS Y, T.y AS X, 'ASONCE5' AS cell, T.rx_level   FROM tems_gis_history_2010_02_5 T   JOIN network.cell C     ON C.name = 'ASONCE5'    AND C.network_identity = T.cell_network_identity  WHERE T.mobile_network_code = 41    AND T.rx_level < 0 
UNION
SELECT T.date_time, T.x AS Y, T.y AS X, 'ASTEG1' AS cell, T.rx_level   FROM tems_gis_history_2010_02_5 T   JOIN network.cell C     ON C.name = 'ASTEG1'    AND C.network_identity = T.cell_network_identity  WHERE T.mobile_network_code = 41    AND T.rx_level < 0 
UNION
SELECT T.date_time, T.x AS Y, T.y AS X, 'ASTEG2' AS cell, T.rx_level   FROM tems_gis_history_2010_02_5 T   JOIN network.cell C     ON C.name = 'ASTEG2'    AND C.network_identity = T.cell_network_identity  WHERE T.mobile_network_code = 41    AND T.rx_level < 0 
UNION
SELECT T.date_time, T.x AS Y, T.y AS X, 'ASTEG3' AS cell, T.rx_level   FROM tems_gis_history_2010_02_5 T   JOIN network.cell C     ON C.name = 'ASTEG3'    AND C.network_identity = T.cell_network_identity  WHERE T.mobile_network_code = 41    AND T.rx_level < 0 
UNION
SELECT T.date_time, T.x AS Y, T.y AS X, 'ASTEG4' AS cell, T.rx_level   FROM tems_gis_history_2010_02_5 T   JOIN network.cell C     ON C.name = 'ASTEG4'    AND C.network_identity = T.cell_network_identity  WHERE T.mobile_network_code = 41    AND T.rx_level < 0 
UNION
SELECT T.date_time, T.x AS Y, T.y AS X, 'ASTEG5' AS cell, T.rx_level   FROM tems_gis_history_2010_02_5 T   JOIN network.cell C     ON C.name = 'ASTEG5'    AND C.network_identity = T.cell_network_identity  WHERE T.mobile_network_code = 41    AND T.rx_level < 0 
UNION
SELECT T.date_time, T.x AS Y, T.y AS X, 'ASTRAL1' AS cell, T.rx_level   FROM tems_gis_history_2010_02_5 T   JOIN network.cell C     ON C.name = 'ASTRAL1'    AND C.network_identity = T.cell_network_identity  WHERE T.mobile_network_code = 41    AND T.rx_level < 0 
UNION
SELECT T.date_time, T.x AS Y, T.y AS X, 'ASTRAL2' AS cell, T.rx_level   FROM tems_gis_history_2010_02_5 T   JOIN network.cell C     ON C.name = 'ASTRAL2'    AND C.network_identity = T.cell_network_identity  WHERE T.mobile_network_code = 41    AND T.rx_level < 0 
UNION
SELECT T.date_time, T.x AS Y, T.y AS X, 'ASTRAL3' AS cell, T.rx_level   FROM tems_gis_history_2010_02_5 T   JOIN network.cell C     ON C.name = 'ASTRAL3'    AND C.network_identity = T.cell_network_identity  WHERE T.mobile_network_code = 41    AND T.rx_level < 0 
UNION
SELECT T.date_time, T.x AS Y, T.y AS X, 'ATABOR4' AS cell, T.rx_level   FROM tems_gis_history_2010_02_5 T   JOIN network.cell C     ON C.name = 'ATABOR4'    AND C.network_identity = T.cell_network_identity  WHERE T.mobile_network_code = 41    AND T.rx_level < 0 
UNION
SELECT T.date_time, T.x AS Y, T.y AS X, 'ATEGR1' AS cell, T.rx_level   FROM tems_gis_history_2010_02_5 T   JOIN network.cell C     ON C.name = 'ATEGR1'    AND C.network_identity = T.cell_network_identity  WHERE T.mobile_network_code = 41    AND T.rx_level < 0 
UNION
SELECT T.date_time, T.x AS Y, T.y AS X, 'ATEGR2' AS cell, T.rx_level   FROM tems_gis_history_2010_02_5 T   JOIN network.cell C     ON C.name = 'ATEGR2'    AND C.network_identity = T.cell_network_identity  WHERE T.mobile_network_code = 41    AND T.rx_level < 0 
UNION
SELECT T.date_time, T.x AS Y, T.y AS X, 'ATEGR3' AS cell, T.rx_level   FROM tems_gis_history_2010_02_5 T   JOIN network.cell C     ON C.name = 'ATEGR3'    AND C.network_identity = T.cell_network_identity  WHERE T.mobile_network_code = 41    AND T.rx_level < 0 
UNION
SELECT T.date_time, T.x AS Y, T.y AS X, 'ATEGR4' AS cell, T.rx_level   FROM tems_gis_history_2010_02_5 T   JOIN network.cell C     ON C.name = 'ATEGR4'    AND C.network_identity = T.cell_network_identity  WHERE T.mobile_network_code = 41    AND T.rx_level < 0 
UNION
SELECT T.date_time, T.x AS Y, T.y AS X, 'ATIVO1' AS cell, T.rx_level   FROM tems_gis_history_2010_02_5 T   JOIN network.cell C     ON C.name = 'ATIVO1'    AND C.network_identity = T.cell_network_identity  WHERE T.mobile_network_code = 41    AND T.rx_level < 0 
UNION
SELECT T.date_time, T.x AS Y, T.y AS X, 'ATIVO2' AS cell, T.rx_level   FROM tems_gis_history_2010_02_5 T   JOIN network.cell C     ON C.name = 'ATIVO2'    AND C.network_identity = T.cell_network_identity  WHERE T.mobile_network_code = 41    AND T.rx_level < 0 
UNION
SELECT T.date_time, T.x AS Y, T.y AS X, 'ATIVO3' AS cell, T.rx_level   FROM tems_gis_history_2010_02_5 T   JOIN network.cell C     ON C.name = 'ATIVO3'    AND C.network_identity = T.cell_network_identity  WHERE T.mobile_network_code = 41    AND T.rx_level < 0 
UNION
SELECT T.date_time, T.x AS Y, T.y AS X, 'ATIVO4' AS cell, T.rx_level   FROM tems_gis_history_2010_02_5 T   JOIN network.cell C     ON C.name = 'ATIVO4'    AND C.network_identity = T.cell_network_identity  WHERE T.mobile_network_code = 41    AND T.rx_level < 0 
UNION
SELECT T.date_time, T.x AS Y, T.y AS X, 'ATIVO5' AS cell, T.rx_level   FROM tems_gis_history_2010_02_5 T   JOIN network.cell C     ON C.name = 'ATIVO5'    AND C.network_identity = T.cell_network_identity  WHERE T.mobile_network_code = 41    AND T.rx_level < 0 
UNION
SELECT T.date_time, T.x AS Y, T.y AS X, 'ATIVO6' AS cell, T.rx_level   FROM tems_gis_history_2010_02_5 T   JOIN network.cell C     ON C.name = 'ATIVO6'    AND C.network_identity = T.cell_network_identity  WHERE T.mobile_network_code = 41    AND T.rx_level < 0 
UNION
SELECT T.date_time, T.x AS Y, T.y AS X, 'ATLK4' AS cell, T.rx_level   FROM tems_gis_history_2010_02_5 T   JOIN network.cell C     ON C.name = 'ATLK4'    AND C.network_identity = T.cell_network_identity  WHERE T.mobile_network_code = 41    AND T.rx_level < 0 
UNION
SELECT T.date_time, T.x AS Y, T.y AS X, 'ATLK5' AS cell, T.rx_level   FROM tems_gis_history_2010_02_5 T   JOIN network.cell C     ON C.name = 'ATLK5'    AND C.network_identity = T.cell_network_identity  WHERE T.mobile_network_code = 41    AND T.rx_level < 0 
UNION
SELECT T.date_time, T.x AS Y, T.y AS X, 'ATOPNI1' AS cell, T.rx_level   FROM tems_gis_history_2010_02_5 T   JOIN network.cell C     ON C.name = 'ATOPNI1'    AND C.network_identity = T.cell_network_identity  WHERE T.mobile_network_code = 41    AND T.rx_level < 0 
UNION
SELECT T.date_time, T.x AS Y, T.y AS X, 'ATOPNI2' AS cell, T.rx_level   FROM tems_gis_history_2010_02_5 T   JOIN network.cell C     ON C.name = 'ATOPNI2'    AND C.network_identity = T.cell_network_identity  WHERE T.mobile_network_code = 41    AND T.rx_level < 0 
UNION
SELECT T.date_time, T.x AS Y, T.y AS X, 'ATOPNI3' AS cell, T.rx_level   FROM tems_gis_history_2010_02_5 T   JOIN network.cell C     ON C.name = 'ATOPNI3'    AND C.network_identity = T.cell_network_identity  WHERE T.mobile_network_code = 41    AND T.rx_level < 0 
UNION
SELECT T.date_time, T.x AS Y, T.y AS X, 'ATOPNI4' AS cell, T.rx_level   FROM tems_gis_history_2010_02_5 T   JOIN network.cell C     ON C.name = 'ATOPNI4'    AND C.network_identity = T.cell_network_identity  WHERE T.mobile_network_code = 41    AND T.rx_level < 0 
UNION
SELECT T.date_time, T.x AS Y, T.y AS X, 'ATVSLO1' AS cell, T.rx_level   FROM tems_gis_history_2010_02_5 T   JOIN network.cell C     ON C.name = 'ATVSLO1'    AND C.network_identity = T.cell_network_identity  WHERE T.mobile_network_code = 41    AND T.rx_level < 0 
UNION
SELECT T.date_time, T.x AS Y, T.y AS X, 'ATVSLO2' AS cell, T.rx_level   FROM tems_gis_history_2010_02_5 T   JOIN network.cell C     ON C.name = 'ATVSLO2'    AND C.network_identity = T.cell_network_identity  WHERE T.mobile_network_code = 41    AND T.rx_level < 0 
UNION
SELECT T.date_time, T.x AS Y, T.y AS X, 'ATVSLO3' AS cell, T.rx_level   FROM tems_gis_history_2010_02_5 T   JOIN network.cell C     ON C.name = 'ATVSLO3'    AND C.network_identity = T.cell_network_identity  WHERE T.mobile_network_code = 41    AND T.rx_level < 0 
UNION
SELECT T.date_time, T.x AS Y, T.y AS X, 'ATVSLO4' AS cell, T.rx_level   FROM tems_gis_history_2010_02_5 T   JOIN network.cell C     ON C.name = 'ATVSLO4'    AND C.network_identity = T.cell_network_identity  WHERE T.mobile_network_code = 41    AND T.rx_level < 0 
UNION
SELECT T.date_time, T.x AS Y, T.y AS X, 'AURSKA1' AS cell, T.rx_level   FROM tems_gis_history_2010_02_5 T   JOIN network.cell C     ON C.name = 'AURSKA1'    AND C.network_identity = T.cell_network_identity  WHERE T.mobile_network_code = 41    AND T.rx_level < 0 
UNION
SELECT T.date_time, T.x AS Y, T.y AS X, 'AURSKA2' AS cell, T.rx_level   FROM tems_gis_history_2010_02_5 T   JOIN network.cell C     ON C.name = 'AURSKA2'    AND C.network_identity = T.cell_network_identity  WHERE T.mobile_network_code = 41    AND T.rx_level < 0 
UNION
SELECT T.date_time, T.x AS Y, T.y AS X, 'AURSKA3' AS cell, T.rx_level   FROM tems_gis_history_2010_02_5 T   JOIN network.cell C     ON C.name = 'AURSKA3'    AND C.network_identity = T.cell_network_identity  WHERE T.mobile_network_code = 41    AND T.rx_level < 0 
UNION
SELECT T.date_time, T.x AS Y, T.y AS X, 'AURSKA4' AS cell, T.rx_level   FROM tems_gis_history_2010_02_5 T   JOIN network.cell C     ON C.name = 'AURSKA4'    AND C.network_identity = T.cell_network_identity  WHERE T.mobile_network_code = 41    AND T.rx_level < 0 
UNION
SELECT T.date_time, T.x AS Y, T.y AS X, 'AURSKA5' AS cell, T.rx_level   FROM tems_gis_history_2010_02_5 T   JOIN network.cell C     ON C.name = 'AURSKA5'    AND C.network_identity = T.cell_network_identity  WHERE T.mobile_network_code = 41    AND T.rx_level < 0 
UNION
SELECT T.date_time, T.x AS Y, T.y AS X, 'AURSKA6' AS cell, T.rx_level   FROM tems_gis_history_2010_02_5 T   JOIN network.cell C     ON C.name = 'AURSKA6'    AND C.network_identity = T.cell_network_identity  WHERE T.mobile_network_code = 41    AND T.rx_level < 0 
UNION
SELECT T.date_time, T.x AS Y, T.y AS X, 'AVECNA1' AS cell, T.rx_level   FROM tems_gis_history_2010_02_5 T   JOIN network.cell C     ON C.name = 'AVECNA1'    AND C.network_identity = T.cell_network_identity  WHERE T.mobile_network_code = 41    AND T.rx_level < 0 
UNION
SELECT T.date_time, T.x AS Y, T.y AS X, 'AVEROV1' AS cell, T.rx_level   FROM tems_gis_history_2010_02_5 T   JOIN network.cell C     ON C.name = 'AVEROV1'    AND C.network_identity = T.cell_network_identity  WHERE T.mobile_network_code = 41    AND T.rx_level < 0 
UNION
SELECT T.date_time, T.x AS Y, T.y AS X, 'AVEROV2' AS cell, T.rx_level   FROM tems_gis_history_2010_02_5 T   JOIN network.cell C     ON C.name = 'AVEROV2'    AND C.network_identity = T.cell_network_identity  WHERE T.mobile_network_code = 41    AND T.rx_level < 0 
UNION
SELECT T.date_time, T.x AS Y, T.y AS X, 'AVEROV3' AS cell, T.rx_level   FROM tems_gis_history_2010_02_5 T   JOIN network.cell C     ON C.name = 'AVEROV3'    AND C.network_identity = T.cell_network_identity  WHERE T.mobile_network_code = 41    AND T.rx_level < 0 
UNION
SELECT T.date_time, T.x AS Y, T.y AS X, 'AVILA4' AS cell, T.rx_level   FROM tems_gis_history_2010_02_5 T   JOIN network.cell C     ON C.name = 'AVILA4'    AND C.network_identity = T.cell_network_identity  WHERE T.mobile_network_code = 41    AND T.rx_level < 0 
UNION
SELECT T.date_time, T.x AS Y, T.y AS X, 'AVILA5' AS cell, T.rx_level   FROM tems_gis_history_2010_02_5 T   JOIN network.cell C     ON C.name = 'AVILA5'    AND C.network_identity = T.cell_network_identity  WHERE T.mobile_network_code = 41    AND T.rx_level < 0 
UNION
SELECT T.date_time, T.x AS Y, T.y AS X, 'AVILA6' AS cell, T.rx_level   FROM tems_gis_history_2010_02_5 T   JOIN network.cell C     ON C.name = 'AVILA6'    AND C.network_identity = T.cell_network_identity  WHERE T.mobile_network_code = 41    AND T.rx_level < 0 
UNION
SELECT T.date_time, T.x AS Y, T.y AS X, 'AVIZMA1' AS cell, T.rx_level   FROM tems_gis_history_2010_02_5 T   JOIN network.cell C     ON C.name = 'AVIZMA1'    AND C.network_identity = T.cell_network_identity  WHERE T.mobile_network_code = 41    AND T.rx_level < 0 
UNION
SELECT T.date_time, T.x AS Y, T.y AS X, 'AVIZMA2' AS cell, T.rx_level   FROM tems_gis_history_2010_02_5 T   JOIN network.cell C     ON C.name = 'AVIZMA2'    AND C.network_identity = T.cell_network_identity  WHERE T.mobile_network_code = 41    AND T.rx_level < 0 
UNION
SELECT T.date_time, T.x AS Y, T.y AS X, 'AVODM1' AS cell, T.rx_level   FROM tems_gis_history_2010_02_5 T   JOIN network.cell C     ON C.name = 'AVODM1'    AND C.network_identity = T.cell_network_identity  WHERE T.mobile_network_code = 41    AND T.rx_level < 0 
UNION
SELECT T.date_time, T.x AS Y, T.y AS X, 'AVODM2' AS cell, T.rx_level   FROM tems_gis_history_2010_02_5 T   JOIN network.cell C     ON C.name = 'AVODM2'    AND C.network_identity = T.cell_network_identity  WHERE T.mobile_network_code = 41    AND T.rx_level < 0 
UNION
SELECT T.date_time, T.x AS Y, T.y AS X, 'AVODM3' AS cell, T.rx_level   FROM tems_gis_history_2010_02_5 T   JOIN network.cell C     ON C.name = 'AVODM3'    AND C.network_identity = T.cell_network_identity  WHERE T.mobile_network_code = 41    AND T.rx_level < 0 
UNION
SELECT T.date_time, T.x AS Y, T.y AS X, 'AZAPUZ1' AS cell, T.rx_level   FROM tems_gis_history_2010_02_5 T   JOIN network.cell C     ON C.name = 'AZAPUZ1'    AND C.network_identity = T.cell_network_identity  WHERE T.mobile_network_code = 41    AND T.rx_level < 0 
UNION
SELECT T.date_time, T.x AS Y, T.y AS X, 'AZAPUZ2' AS cell, T.rx_level   FROM tems_gis_history_2010_02_5 T   JOIN network.cell C     ON C.name = 'AZAPUZ2'    AND C.network_identity = T.cell_network_identity  WHERE T.mobile_network_code = 41    AND T.rx_level < 0 
UNION
SELECT T.date_time, T.x AS Y, T.y AS X, 'AZAPUZ3' AS cell, T.rx_level   FROM tems_gis_history_2010_02_5 T   JOIN network.cell C     ON C.name = 'AZAPUZ3'    AND C.network_identity = T.cell_network_identity  WHERE T.mobile_network_code = 41    AND T.rx_level < 0 
UNION
SELECT T.date_time, T.x AS Y, T.y AS X, 'AZELEZ1' AS cell, T.rx_level   FROM tems_gis_history_2010_02_5 T   JOIN network.cell C     ON C.name = 'AZELEZ1'    AND C.network_identity = T.cell_network_identity  WHERE T.mobile_network_code = 41    AND T.rx_level < 0 
UNION
SELECT T.date_time, T.x AS Y, T.y AS X, 'AZELEZ2' AS cell, T.rx_level   FROM tems_gis_history_2010_02_5 T   JOIN network.cell C     ON C.name = 'AZELEZ2'    AND C.network_identity = T.cell_network_identity  WHERE T.mobile_network_code = 41    AND T.rx_level < 0 
UNION
SELECT T.date_time, T.x AS Y, T.y AS X, 'AZELEZ3' AS cell, T.rx_level   FROM tems_gis_history_2010_02_5 T   JOIN network.cell C     ON C.name = 'AZELEZ3'    AND C.network_identity = T.cell_network_identity  WHERE T.mobile_network_code = 41    AND T.rx_level < 0 
) foo
GROUP BY X, Y, cell ORDER BY cell, X, Y, MAX(date_time)
