#!/bin/bash

#
# Network data from mg_joe
#
psql -h mg_joe.mobitel.si -U garufa -d umts \
     -c "SELECT s.name, \
                ((Y(c.location)-319950)/100)::integer as col, 
                ((224050-X(c.location))/100)::integer as row  
           FROM network.site s JOIN gis.coordinate_gk c USING (id_coordinate) 
          WHERE s.name IN ('MJURSI',
                            'MZAMU',
                            'SARCON',
                            'SBAKOV',
                            'SBANOV',
                            'SBELTI',
                            'SBORAC',
                            'SCERNE',
                            'SEJEM',
                            'SHRASE',
                            'SILOS',
                            'SLJUTK',
                            'SMORTO',
                            'SOBGD',
                            'SOBJUG',
                            'SOBKOM',
                            'SOBOT',
                            'SODRAN',
                            'SPOLAN',
                            'SPUCON',
                            'SRADEN',
                            'SRADG',
                            'STURNI');" > /tmp/.sites.txt

#
# Rearrange to C-friendly form
#
echo "/**"
echo " * Test transmitters "
echo " *    LJUTOMER: 572000,175000 - 607000,142000"
echo " * "
cat /tmp/.sites.txt | egrep -v '\-|col|row' | sed -e 's/^ / * /g'
echo " */"

i=0;
for c in $(cat /tmp/.sites.txt | egrep -v '\-|col|row' | cut -d'|' -f2,3 | tr -d ' '); 
do 
    echo "test_tx[${i}] = (cl_int2) {$( echo ${c} | sed -e 's/|/,/g' )};"; 
    let i+=1; 
done


