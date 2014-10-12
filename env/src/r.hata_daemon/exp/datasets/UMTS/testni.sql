--
-- BOHINJ: 403000, 122000 - 423000, 136000
--
SELECT R.time, R.gk_x AS Y, R.gk_y AS X, C.name, R.rscp
  FROM romes_history_rscp_od_2005 R
  JOIN network.cell C ON R.cellid = C.network_identity
  JOIN network.site S ON C.id_site = S.id_site
  JOIN gis.coordinate_gk CO ON S.id_coordinate = CO.id_coordinate
   AND X(CO.location) BETWEEN 122000 AND 136000
   AND Y(CO.location) BETWEEN 403000 AND 423000;

SELECT R.time, R.gk_x AS Y, R.gk_y AS X, R.cellid
  FROM romes_history_rscp_od_2005 R
 WHERE R.text LIKE '%KRIBLA%'
ORDER BY R.cellid

SELECT R.time, R.gk_x AS Y, R.gk_y AS X, C.name, R.rscp
  FROM romes_history_rscp_od_2005 R
  JOIN network.cell C ON R.cellid = C.network_identity
   AND C.name LIKE 'KBOHBI%'

SELECT C.name, C.network_identity
  FROM network.cell C 
  JOIN network.site S ON C.id_site = S.id_site
  JOIN gis.coordinate_gk CO ON S.id_coordinate = CO.id_coordinate
   AND X(CO.location) BETWEEN 122000 AND 136000
   AND Y(CO.location) BETWEEN 403000 AND 423000;

SELECT R.time, gk_x AS Y, gk_y AS X, R.rscp
  FROM romes_history_rscp_od_2005 R
 WHERE R.gk_y BETWEEN 152000 AND 165000
   AND R.gk_x BETWEEN 582000 AND 597000
   ORDER BY R.time
 
 
--
-- LJUBLJANA: 456000, 101000 - 464000, 108000
--
SELECT R.time, gk_x AS Y, gk_y AS X, C.name, R.rscp
  FROM romes_history_rscp_od_2005 R
  JOIN network.cell C ON R.cellid = C.network_identity
 WHERE R.gk_y BETWEEN 101000 AND 108000
   AND R.gk_x BETWEEN 456000 AND 464000;

--
-- LJUTOMER: 582000, 152000 - 597000, 165000 
--
SELECT R.time, R.gk_x AS Y, R.gk_y AS X, C.name, R.rscp
  FROM romes_history_rscp_od_2005 R
  JOIN network.cell C ON R.cellid = C.network_identity
  JOIN network.site S ON C.id_site = S.id_site
  JOIN gis.coordinate_gk CO ON S.id_coordinate = CO.id_coordinate
   AND X(CO.location) BETWEEN 152000 AND 165000
   AND Y(CO.location) BETWEEN 582000 AND 597000;


SELECT * 
  FROM romes_history_rscp_od_2005 R
 WHERE text ~ ' ---\n.*KRIBLA.*[-]+'
 
 WHERE text ~ '\s+---.+---.*KRIBLA' .+-------------------------.+'
