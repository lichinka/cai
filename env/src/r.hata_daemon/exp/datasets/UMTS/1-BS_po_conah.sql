--
-- BOHINJ: 403000, 122000 - 423000, 136000
--
--SELECT C.name
--  FROM network.cell C 
--  JOIN network.site S ON C.id_site = S.id_site
--  JOIN gis.coordinate_gk CO ON S.id_coordinate = CO.id_coordinate
--   AND X(CO.location) BETWEEN 122000 AND 136000
--   AND Y(CO.location) BETWEEN 403000 AND 423000;


--
-- LJUBLJANA: 456000, 101000 - 464000, 108000
--
SELECT C.name
  FROM network.cell C 
  JOIN network.site S ON C.id_site = S.id_site
  JOIN gis.coordinate_gk CO ON S.id_coordinate = CO.id_coordinate
   AND X(CO.location) BETWEEN 101000 AND 108000
   AND Y(CO.location) BETWEEN 456000 AND 464000;

--
-- LJUTOMER: 582000, 152000 - 597000, 165000 
--
--SELECT C.name
--  FROM network.cell C
--  JOIN network.site S ON C.id_site = S.id_site
--  JOIN gis.coordinate_gk CO ON S.id_coordinate = CO.id_coordinate
--   AND X(CO.location) BETWEEN 152000 AND 165000
--   AND Y(CO.location) BETWEEN 582000 AND 597000;

