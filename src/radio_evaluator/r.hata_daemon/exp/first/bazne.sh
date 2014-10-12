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
                            'ACIGO',
                            'ACRGMA',
                            'ADELO',
                            'ADRAV',
                            'ADRAVC',
                            'AELNA',
                            'AFORD',
                            'AFRANK',
                            'AGAMGD',
                            'AGEOPL',
                            'AGR',
                            'AGRAM',
                            'AGRIC',
                            'AGZ',
                            'AHALA',
                            'AHLEV',
                            'AJEZKZ',
                            'AKAMNA',
                            'AKLINI',
                            'AKOLIN',
                            'AKORA',
                            'AKOSEG',
                            'AKOSET',
                            'AKOSEZ',
                            'AKOSME',
                            'AKOTNI',
                            'AKOVIN',
                            'ALEK',
                            'ALMLEK',
                            'ALPP',
                            'AMHOTE',
                            'AMOBI',
                            'AMOBLI',
                            'AMSC',
                            'AMZS',
                            'ANDREJ',
                            'APODUT',
                            'APOPTV',
                            'APRZAC',
                            'ARESEV',
                            'ARNC',
                            'ASAVLJ',
                            'ASENTP',
                            'ASISKP',
                            'ASKZ',
                            'ASKZK',
                            'ASLOM',
                            'ASMAR',
                            'ASMELT',
                            'ASONCE',
                            'ASTEG',
                            'ASTOZI',
                            'ASTRAL',
                            'ATABOR',
                            'ATACBR',
                            'ATACGD',
                            'ATEGR',
                            'ATIVO',
                            'ATLK',
                            'ATOPNI',
                            'ATVSLO',
                            'AURSKA',
                            'AVECNA',
                            'AVELAN',
                            'AVEROV',
                            'AVILA',
                            'AVIZMA',
                            'AZAPUZ',
                            'AZELEZ',
                            'LDOBRO',
                            'LMEDVO',
                            'LPIRN');" > /tmp/.sites.txt


#
# Rearrange to C-friendly form
#
echo "/**"
echo " * Test transmitters "
echo " *    LJUBLANA Center: 454000,111000 - 464000,101000"
echo " * "
cat /tmp/.sites.txt | egrep -v '\-|col|row' | sed -e 's/^ / * /g'
echo " */"

i=0;
for c in $(cat /tmp/.sites.txt | egrep -v '\-|col|row' | cut -d'|' -f2,3 | tr -d ' '); 
do 
    echo "test_tx[${i}] = (cl_int2) {$( echo ${c} | sed -e 's/|/,/g' )};"; 
    let i+=1; 
done



