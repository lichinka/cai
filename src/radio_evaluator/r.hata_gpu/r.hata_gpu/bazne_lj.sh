#!/bin/bash

#
# Network data from mg_joe
#
psql -h mg_joe.mobitel.si -U garufa -d umts \
     -c "SELECT s.name, \
                ((Y(c.location)-319950)/100)::integer as col, 
                ((224050-X(c.location))/100)::integer as row  
           FROM network.site s JOIN gis.coordinate_gk c USING (id_coordinate) 
          WHERE s.name LIKE 'A%' 
            AND s.name NOT LIKE 'ATEST%';" > /tmp/.sites.txt

#
# Rearrange to C-friendly form
#
echo "/**"
echo " * Test transmitters "
echo " * "
cat /tmp/.sites.txt | grep A | sed -e 's/^ / * /g'
echo " */"

i=0;
for c in $(cat /tmp/.sites.txt | grep A | cut -d'|' -f2,3 | tr -d ' '); 
do 
    echo "test_tx[${i}] = (cl_int2) {$( echo ${c} | sed -e 's/|/,/g' )};"; 
    let i+=1; 
done

