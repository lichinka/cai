#!/bin/bash

#
# Network data from mg_joe
#
psql -h mg_joe.mobitel.si -U garufa -d umts \
     -c "SELECT s.name, \
                ((Y(c.location)-319950)/100)::integer as col, 
                ((224050-X(c.location))/100)::integer as row  
           FROM network.site s JOIN gis.coordinate_gk c USING (id_coordinate) 
          WHERE s.name IN ('ABEZI',
                            'ABEZIT',
                            'ABROD',
                            'ACERNE',
                            'ACHEMO',
                            'ACRGMA',
                            'ADELO',
                            'ADRAV',
                            'AELNA',
                            'AFORD',
                            'AFRANK',
                            'AGEOPL',
                            'AGRAM',
                            'AGRIC',
                            'AGZ',
                            'AHALA',
                            'AHLEV',
                            'AJEZKZ',
                            'AKOLIN',
                            'AKOSEG',
                            'AKOSEZ',
                            'AKOSME',
                            'AKOTNI',
                            'AKOVIN',
                            'ALMLEK',
                            'ALPP',
                            'AMHOTE',
                            'AMOBI',
                            'AMZS',
                            'APETRO',
                            'APODUT',
                            'APOPTV',
                            'APRZAC',
                            'APRZAN',
                            'ASAVLJ',
                            'ASISKP',
                            'ASKZ',
                            'ASLOM',
                            'ASMELT',
                            'ASONCE',
                            'ASTEG',
                            'ASTRAL',
                            'ATABOR',
                            'ATEGR',
                            'ATIVO',
                            'ATLK',
                            'ATOPNI',
                            'ATVSLO',
                            'AURSKA',
                            'AVECNA',
                            'AVEROV',
                            'AVILA',
                            'AVIZMA',
                            'AVODM',
                            'AZAPUZ',
                            'AZELEZ');" > /tmp/.sites.txt

#
# Rearrange to C-friendly form
#
echo "/**"
echo " * Test transmitters "
echo " *    LJUBLJANA: 455000, 97000 - 470000, 110000 "
echo " * "
cat /tmp/.sites.txt | grep A | sed -e 's/^ / * /g'
echo " */"

i=0;
for c in $(cat /tmp/.sites.txt | grep A | cut -d'|' -f2,3 | tr -d ' '); 
do 
    echo "test_tx[${i}] = (cl_int2) {$( echo ${c} | sed -e 's/|/,/g' )};"; 
    let i+=1; 
done


