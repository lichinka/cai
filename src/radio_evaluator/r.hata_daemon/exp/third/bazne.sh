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
                            'ABIZOV',
                            'ABOKAL',
                            'ABRDO',
                            'ABROD',
                            'ABTC',
                            'ABTCMI',
                            'ACERNE',
                            'ACHEMO',
                            'ACRGMA',
                            'ACRNUC',
                            'ADELO',
                            'ADNEVN',
                            'ADOLGI',
                            'ADRAV',
                            'AEJATA',
                            'AELNA',
                            'AELOK',
                            'AFORD',
                            'AFRANK',
                            'AFUZIN',
                            'AGAMGD',
                            'AGEOPL',
                            'AGPG',
                            'AGRAD',
                            'AGRAM',
                            'AGRIC',
                            'AGURS',
                            'AGZ',
                            'AHLEV',
                            'AIJS',
                            'AIMKO',
                            'AJELSA',
                            'AJEZA',
                            'AJEZKZ',
                            'AJOZEF',
                            'AKASEL',
                            'AKODEL',
                            'AKOLEZ',
                            'AKOLIN',
                            'AKONEX',
                            'AKOSEG',
                            'AKOSET',
                            'AKOSEZ',
                            'AKOSME',
                            'AKOTNI',
                            'AKOVIN',
                            'AKOZAR',
                            'ALITIJ',
                            'ALIVAD',
                            'ALMLEK',
                            'ALPP',
                            'AMHOTE',
                            'AMOBI',
                            'AMOSTE',
                            'AMURGL',
                            'AMZS',
                            'ANADGO',
                            'ANAMA',
                            'ANTENA',
                            'AOBI',
                            'APETER',
                            'APLAMA',
                            'APODUT',
                            'APOLCE',
                            'APOPTV',
                            'APOVSE',
                            'APROGA',
                            'APRZAC',
                            'ARAK',
                            'ARAKTK',
                            'ARESEV',
                            'AROZNA',
                            'ASAVLJ',
                            'ASAZU',
                            'ASEME',
                            'ASISKP',
                            'ASKZ',
                            'ASKZK',
                            'ASLOM',
                            'ASMAR',
                            'ASMARG',
                            'ASMART',
                            'ASMELT',
                            'ASOSTR',
                            'ASPAR',
                            'ASTARA',
                            'ASTEG',
                            'ASTEP',
                            'ASTRAL',
                            'ATABOR',
                            'ATACGD',
                            'ATEGR',
                            'ATIVO',
                            'ATOMAC',
                            'ATOPLA',
                            'ATOPNI',
                            'ATOTRA',
                            'ATRNOV',
                            'ATRUB',
                            'ATUNEL',
                            'ATVSLO',
                            'AURSKA',
                            'AVARNO',
                            'AVECNA',
                            'AVEGAS',
                            'AVELAN',
                            'AVEROV',
                            'AVEVCE',
                            'AVIC',
                            'AVICTK',
                            'AVILA',
                            'AVIZMA',
                            'AVLADA',
                            'AVRHO',
                            'AVRHOV',
                            'AZADOB',
                            'AZALOG',
                            'AZAPUZ',
                            'AZELEZ',
                            'AZIMA',
                            'AZITO',
                            'LBRESZ',
                            'LDOBRO',
                            'LDRAG',
                            'LPODG',
                            'LTRZIN',
                            'LTRZV');" > /tmp/.sites.txt

#
# Rearrange to C-friendly form
#
echo "/**"
echo " * Test transmitters "
echo " *    LJUBLANA + Okolica: 445000,158000 - 535000,68000"
echo " * "
cat /tmp/.sites.txt | egrep -v '\-|col|row' | sed -e 's/^ / * /g'
echo " */"

i=0;
for c in $(cat /tmp/.sites.txt | egrep -v '\-|col|row' | cut -d'|' -f2,3 | tr -d ' '); 
do 
    echo "test_tx[${i}] = (cl_int2) {$( echo ${c} | sed -e 's/|/,/g' )};"; 
    let i+=1; 
done




