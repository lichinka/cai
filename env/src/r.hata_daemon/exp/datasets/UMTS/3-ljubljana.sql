SELECT R.time, R.gk_x AS Y, R.gk_y AS X, 'ABEZIA' AS cell, R.rscp FROM romes_history_rscp_od_2005 R WHERE text  ~ 'ABEZIA' AND text !~ E'0[2-9]\. ABEZIA' AND text !~ E'1[0-9]\. ABEZIA'
UNION
SELECT R.time, R.gk_x AS Y, R.gk_y AS X, 'ABEZIB' AS cell, R.rscp FROM romes_history_rscp_od_2005 R WHERE text  ~ 'ABEZIB' AND text !~ E'0[2-9]\. ABEZIB' AND text !~ E'1[0-9]\. ABEZIB'
UNION
SELECT R.time, R.gk_x AS Y, R.gk_y AS X, 'ABEZIC' AS cell, R.rscp FROM romes_history_rscp_od_2005 R WHERE text  ~ 'ABEZIC' AND text !~ E'0[2-9]\. ABEZIC' AND text !~ E'1[0-9]\. ABEZIC'
UNION
SELECT R.time, R.gk_x AS Y, R.gk_y AS X, 'ABEZITA' AS cell, R.rscp FROM romes_history_rscp_od_2005 R WHERE text  ~ 'ABEZITA' AND text !~ E'0[2-9]\. ABEZITA' AND text !~ E'1[0-9]\. ABEZITA'
UNION
SELECT R.time, R.gk_x AS Y, R.gk_y AS X, 'ABEZITB' AS cell, R.rscp FROM romes_history_rscp_od_2005 R WHERE text  ~ 'ABEZITB' AND text !~ E'0[2-9]\. ABEZITB' AND text !~ E'1[0-9]\. ABEZITB'
UNION
SELECT R.time, R.gk_x AS Y, R.gk_y AS X, 'ABEZITC' AS cell, R.rscp FROM romes_history_rscp_od_2005 R WHERE text  ~ 'ABEZITC' AND text !~ E'0[2-9]\. ABEZITC' AND text !~ E'1[0-9]\. ABEZITC'
UNION
SELECT R.time, R.gk_x AS Y, R.gk_y AS X, 'ABRODA' AS cell, R.rscp FROM romes_history_rscp_od_2005 R WHERE text  ~ 'ABRODA' AND text !~ E'0[2-9]\. ABRODA' AND text !~ E'1[0-9]\. ABRODA'
UNION
SELECT R.time, R.gk_x AS Y, R.gk_y AS X, 'ABRODB' AS cell, R.rscp FROM romes_history_rscp_od_2005 R WHERE text  ~ 'ABRODB' AND text !~ E'0[2-9]\. ABRODB' AND text !~ E'1[0-9]\. ABRODB'
UNION
SELECT R.time, R.gk_x AS Y, R.gk_y AS X, 'ABRODC' AS cell, R.rscp FROM romes_history_rscp_od_2005 R WHERE text  ~ 'ABRODC' AND text !~ E'0[2-9]\. ABRODC' AND text !~ E'1[0-9]\. ABRODC'
UNION
SELECT R.time, R.gk_x AS Y, R.gk_y AS X, 'ACERNEA' AS cell, R.rscp FROM romes_history_rscp_od_2005 R WHERE text  ~ 'ACERNEA' AND text !~ E'0[2-9]\. ACERNEA' AND text !~ E'1[0-9]\. ACERNEA'
UNION
SELECT R.time, R.gk_x AS Y, R.gk_y AS X, 'ACERNEB' AS cell, R.rscp FROM romes_history_rscp_od_2005 R WHERE text  ~ 'ACERNEB' AND text !~ E'0[2-9]\. ACERNEB' AND text !~ E'1[0-9]\. ACERNEB'
UNION
SELECT R.time, R.gk_x AS Y, R.gk_y AS X, 'ACERNEC' AS cell, R.rscp FROM romes_history_rscp_od_2005 R WHERE text  ~ 'ACERNEC' AND text !~ E'0[2-9]\. ACERNEC' AND text !~ E'1[0-9]\. ACERNEC'
UNION
SELECT R.time, R.gk_x AS Y, R.gk_y AS X, 'ACHEMOA' AS cell, R.rscp FROM romes_history_rscp_od_2005 R WHERE text  ~ 'ACHEMOA' AND text !~ E'0[2-9]\. ACHEMOA' AND text !~ E'1[0-9]\. ACHEMOA'
UNION
SELECT R.time, R.gk_x AS Y, R.gk_y AS X, 'ACHEMOB' AS cell, R.rscp FROM romes_history_rscp_od_2005 R WHERE text  ~ 'ACHEMOB' AND text !~ E'0[2-9]\. ACHEMOB' AND text !~ E'1[0-9]\. ACHEMOB'
UNION
SELECT R.time, R.gk_x AS Y, R.gk_y AS X, 'ACHEMOC' AS cell, R.rscp FROM romes_history_rscp_od_2005 R WHERE text  ~ 'ACHEMOC' AND text !~ E'0[2-9]\. ACHEMOC' AND text !~ E'1[0-9]\. ACHEMOC'
UNION
SELECT R.time, R.gk_x AS Y, R.gk_y AS X, 'ACRGMAA' AS cell, R.rscp FROM romes_history_rscp_od_2005 R WHERE text  ~ 'ACRGMAA' AND text !~ E'0[2-9]\. ACRGMAA' AND text !~ E'1[0-9]\. ACRGMAA'
UNION
SELECT R.time, R.gk_x AS Y, R.gk_y AS X, 'ACRGMAB' AS cell, R.rscp FROM romes_history_rscp_od_2005 R WHERE text  ~ 'ACRGMAB' AND text !~ E'0[2-9]\. ACRGMAB' AND text !~ E'1[0-9]\. ACRGMAB'
UNION
SELECT R.time, R.gk_x AS Y, R.gk_y AS X, 'ADELOA' AS cell, R.rscp FROM romes_history_rscp_od_2005 R WHERE text  ~ 'ADELOA' AND text !~ E'0[2-9]\. ADELOA' AND text !~ E'1[0-9]\. ADELOA'
UNION
SELECT R.time, R.gk_x AS Y, R.gk_y AS X, 'ADELOB' AS cell, R.rscp FROM romes_history_rscp_od_2005 R WHERE text  ~ 'ADELOB' AND text !~ E'0[2-9]\. ADELOB' AND text !~ E'1[0-9]\. ADELOB'
UNION
SELECT R.time, R.gk_x AS Y, R.gk_y AS X, 'ADELOC' AS cell, R.rscp FROM romes_history_rscp_od_2005 R WHERE text  ~ 'ADELOC' AND text !~ E'0[2-9]\. ADELOC' AND text !~ E'1[0-9]\. ADELOC'
UNION
SELECT R.time, R.gk_x AS Y, R.gk_y AS X, 'ADRAVA' AS cell, R.rscp FROM romes_history_rscp_od_2005 R WHERE text  ~ 'ADRAVA' AND text !~ E'0[2-9]\. ADRAVA' AND text !~ E'1[0-9]\. ADRAVA'
UNION
SELECT R.time, R.gk_x AS Y, R.gk_y AS X, 'ADRAVB' AS cell, R.rscp FROM romes_history_rscp_od_2005 R WHERE text  ~ 'ADRAVB' AND text !~ E'0[2-9]\. ADRAVB' AND text !~ E'1[0-9]\. ADRAVB'
UNION
SELECT R.time, R.gk_x AS Y, R.gk_y AS X, 'ADRAVC' AS cell, R.rscp FROM romes_history_rscp_od_2005 R WHERE text  ~ 'ADRAVC' AND text !~ E'0[2-9]\. ADRAVC' AND text !~ E'1[0-9]\. ADRAVC'
UNION
SELECT R.time, R.gk_x AS Y, R.gk_y AS X, 'AELNAA' AS cell, R.rscp FROM romes_history_rscp_od_2005 R WHERE text  ~ 'AELNAA' AND text !~ E'0[2-9]\. AELNAA' AND text !~ E'1[0-9]\. AELNAA'
UNION
SELECT R.time, R.gk_x AS Y, R.gk_y AS X, 'AELNAB' AS cell, R.rscp FROM romes_history_rscp_od_2005 R WHERE text  ~ 'AELNAB' AND text !~ E'0[2-9]\. AELNAB' AND text !~ E'1[0-9]\. AELNAB'
UNION
SELECT R.time, R.gk_x AS Y, R.gk_y AS X, 'AELNAC' AS cell, R.rscp FROM romes_history_rscp_od_2005 R WHERE text  ~ 'AELNAC' AND text !~ E'0[2-9]\. AELNAC' AND text !~ E'1[0-9]\. AELNAC'
UNION
SELECT R.time, R.gk_x AS Y, R.gk_y AS X, 'AFORDA' AS cell, R.rscp FROM romes_history_rscp_od_2005 R WHERE text  ~ 'AFORDA' AND text !~ E'0[2-9]\. AFORDA' AND text !~ E'1[0-9]\. AFORDA'
UNION
SELECT R.time, R.gk_x AS Y, R.gk_y AS X, 'AFORDB' AS cell, R.rscp FROM romes_history_rscp_od_2005 R WHERE text  ~ 'AFORDB' AND text !~ E'0[2-9]\. AFORDB' AND text !~ E'1[0-9]\. AFORDB'
UNION
SELECT R.time, R.gk_x AS Y, R.gk_y AS X, 'AFORDC' AS cell, R.rscp FROM romes_history_rscp_od_2005 R WHERE text  ~ 'AFORDC' AND text !~ E'0[2-9]\. AFORDC' AND text !~ E'1[0-9]\. AFORDC'
UNION
SELECT R.time, R.gk_x AS Y, R.gk_y AS X, 'AFRANKA' AS cell, R.rscp FROM romes_history_rscp_od_2005 R WHERE text  ~ 'AFRANKA' AND text !~ E'0[2-9]\. AFRANKA' AND text !~ E'1[0-9]\. AFRANKA'
UNION
SELECT R.time, R.gk_x AS Y, R.gk_y AS X, 'AFRANKB' AS cell, R.rscp FROM romes_history_rscp_od_2005 R WHERE text  ~ 'AFRANKB' AND text !~ E'0[2-9]\. AFRANKB' AND text !~ E'1[0-9]\. AFRANKB'
UNION
SELECT R.time, R.gk_x AS Y, R.gk_y AS X, 'AFRANKC' AS cell, R.rscp FROM romes_history_rscp_od_2005 R WHERE text  ~ 'AFRANKC' AND text !~ E'0[2-9]\. AFRANKC' AND text !~ E'1[0-9]\. AFRANKC'
UNION
SELECT R.time, R.gk_x AS Y, R.gk_y AS X, 'AGEOPLA' AS cell, R.rscp FROM romes_history_rscp_od_2005 R WHERE text  ~ 'AGEOPLA' AND text !~ E'0[2-9]\. AGEOPLA' AND text !~ E'1[0-9]\. AGEOPLA'
UNION
SELECT R.time, R.gk_x AS Y, R.gk_y AS X, 'AGEOPLB' AS cell, R.rscp FROM romes_history_rscp_od_2005 R WHERE text  ~ 'AGEOPLB' AND text !~ E'0[2-9]\. AGEOPLB' AND text !~ E'1[0-9]\. AGEOPLB'
UNION
SELECT R.time, R.gk_x AS Y, R.gk_y AS X, 'AGEOPLC' AS cell, R.rscp FROM romes_history_rscp_od_2005 R WHERE text  ~ 'AGEOPLC' AND text !~ E'0[2-9]\. AGEOPLC' AND text !~ E'1[0-9]\. AGEOPLC'
UNION
SELECT R.time, R.gk_x AS Y, R.gk_y AS X, 'AGRAMA' AS cell, R.rscp FROM romes_history_rscp_od_2005 R WHERE text  ~ 'AGRAMA' AND text !~ E'0[2-9]\. AGRAMA' AND text !~ E'1[0-9]\. AGRAMA'
UNION
SELECT R.time, R.gk_x AS Y, R.gk_y AS X, 'AGRAMB' AS cell, R.rscp FROM romes_history_rscp_od_2005 R WHERE text  ~ 'AGRAMB' AND text !~ E'0[2-9]\. AGRAMB' AND text !~ E'1[0-9]\. AGRAMB'
UNION
SELECT R.time, R.gk_x AS Y, R.gk_y AS X, 'AGRAMC' AS cell, R.rscp FROM romes_history_rscp_od_2005 R WHERE text  ~ 'AGRAMC' AND text !~ E'0[2-9]\. AGRAMC' AND text !~ E'1[0-9]\. AGRAMC'
UNION
SELECT R.time, R.gk_x AS Y, R.gk_y AS X, 'AGRICA' AS cell, R.rscp FROM romes_history_rscp_od_2005 R WHERE text  ~ 'AGRICA' AND text !~ E'0[2-9]\. AGRICA' AND text !~ E'1[0-9]\. AGRICA'
UNION
SELECT R.time, R.gk_x AS Y, R.gk_y AS X, 'AGRICB' AS cell, R.rscp FROM romes_history_rscp_od_2005 R WHERE text  ~ 'AGRICB' AND text !~ E'0[2-9]\. AGRICB' AND text !~ E'1[0-9]\. AGRICB'
UNION
SELECT R.time, R.gk_x AS Y, R.gk_y AS X, 'AGRICC' AS cell, R.rscp FROM romes_history_rscp_od_2005 R WHERE text  ~ 'AGRICC' AND text !~ E'0[2-9]\. AGRICC' AND text !~ E'1[0-9]\. AGRICC'
UNION
SELECT R.time, R.gk_x AS Y, R.gk_y AS X, 'AGZA' AS cell, R.rscp FROM romes_history_rscp_od_2005 R WHERE text  ~ 'AGZA' AND text !~ E'0[2-9]\. AGZA' AND text !~ E'1[0-9]\. AGZA'
UNION
SELECT R.time, R.gk_x AS Y, R.gk_y AS X, 'AGZB' AS cell, R.rscp FROM romes_history_rscp_od_2005 R WHERE text  ~ 'AGZB' AND text !~ E'0[2-9]\. AGZB' AND text !~ E'1[0-9]\. AGZB'
UNION
SELECT R.time, R.gk_x AS Y, R.gk_y AS X, 'AGZC' AS cell, R.rscp FROM romes_history_rscp_od_2005 R WHERE text  ~ 'AGZC' AND text !~ E'0[2-9]\. AGZC' AND text !~ E'1[0-9]\. AGZC'
UNION
SELECT R.time, R.gk_x AS Y, R.gk_y AS X, 'AHLEVA' AS cell, R.rscp FROM romes_history_rscp_od_2005 R WHERE text  ~ 'AHLEVA' AND text !~ E'0[2-9]\. AHLEVA' AND text !~ E'1[0-9]\. AHLEVA'
UNION
SELECT R.time, R.gk_x AS Y, R.gk_y AS X, 'AHLEVB' AS cell, R.rscp FROM romes_history_rscp_od_2005 R WHERE text  ~ 'AHLEVB' AND text !~ E'0[2-9]\. AHLEVB' AND text !~ E'1[0-9]\. AHLEVB'
UNION
SELECT R.time, R.gk_x AS Y, R.gk_y AS X, 'AHLEVC' AS cell, R.rscp FROM romes_history_rscp_od_2005 R WHERE text  ~ 'AHLEVC' AND text !~ E'0[2-9]\. AHLEVC' AND text !~ E'1[0-9]\. AHLEVC'
UNION
SELECT R.time, R.gk_x AS Y, R.gk_y AS X, 'AJEZKZA' AS cell, R.rscp FROM romes_history_rscp_od_2005 R WHERE text  ~ 'AJEZKZA' AND text !~ E'0[2-9]\. AJEZKZA' AND text !~ E'1[0-9]\. AJEZKZA'
UNION
SELECT R.time, R.gk_x AS Y, R.gk_y AS X, 'AJEZKZB' AS cell, R.rscp FROM romes_history_rscp_od_2005 R WHERE text  ~ 'AJEZKZB' AND text !~ E'0[2-9]\. AJEZKZB' AND text !~ E'1[0-9]\. AJEZKZB'
UNION
SELECT R.time, R.gk_x AS Y, R.gk_y AS X, 'AJEZKZC' AS cell, R.rscp FROM romes_history_rscp_od_2005 R WHERE text  ~ 'AJEZKZC' AND text !~ E'0[2-9]\. AJEZKZC' AND text !~ E'1[0-9]\. AJEZKZC'
UNION
SELECT R.time, R.gk_x AS Y, R.gk_y AS X, 'AKOLINA' AS cell, R.rscp FROM romes_history_rscp_od_2005 R WHERE text  ~ 'AKOLINA' AND text !~ E'0[2-9]\. AKOLINA' AND text !~ E'1[0-9]\. AKOLINA'
UNION
SELECT R.time, R.gk_x AS Y, R.gk_y AS X, 'AKOLINB' AS cell, R.rscp FROM romes_history_rscp_od_2005 R WHERE text  ~ 'AKOLINB' AND text !~ E'0[2-9]\. AKOLINB' AND text !~ E'1[0-9]\. AKOLINB'
UNION
SELECT R.time, R.gk_x AS Y, R.gk_y AS X, 'AKOLINC' AS cell, R.rscp FROM romes_history_rscp_od_2005 R WHERE text  ~ 'AKOLINC' AND text !~ E'0[2-9]\. AKOLINC' AND text !~ E'1[0-9]\. AKOLINC'
UNION
SELECT R.time, R.gk_x AS Y, R.gk_y AS X, 'AKOSEGA' AS cell, R.rscp FROM romes_history_rscp_od_2005 R WHERE text  ~ 'AKOSEGA' AND text !~ E'0[2-9]\. AKOSEGA' AND text !~ E'1[0-9]\. AKOSEGA'
UNION
SELECT R.time, R.gk_x AS Y, R.gk_y AS X, 'AKOSEGB' AS cell, R.rscp FROM romes_history_rscp_od_2005 R WHERE text  ~ 'AKOSEGB' AND text !~ E'0[2-9]\. AKOSEGB' AND text !~ E'1[0-9]\. AKOSEGB'
UNION
SELECT R.time, R.gk_x AS Y, R.gk_y AS X, 'AKOSEGC' AS cell, R.rscp FROM romes_history_rscp_od_2005 R WHERE text  ~ 'AKOSEGC' AND text !~ E'0[2-9]\. AKOSEGC' AND text !~ E'1[0-9]\. AKOSEGC'
UNION
SELECT R.time, R.gk_x AS Y, R.gk_y AS X, 'AKOSEZA' AS cell, R.rscp FROM romes_history_rscp_od_2005 R WHERE text  ~ 'AKOSEZA' AND text !~ E'0[2-9]\. AKOSEZA' AND text !~ E'1[0-9]\. AKOSEZA'
UNION
SELECT R.time, R.gk_x AS Y, R.gk_y AS X, 'AKOSEZB' AS cell, R.rscp FROM romes_history_rscp_od_2005 R WHERE text  ~ 'AKOSEZB' AND text !~ E'0[2-9]\. AKOSEZB' AND text !~ E'1[0-9]\. AKOSEZB'
UNION
SELECT R.time, R.gk_x AS Y, R.gk_y AS X, 'AKOSEZC' AS cell, R.rscp FROM romes_history_rscp_od_2005 R WHERE text  ~ 'AKOSEZC' AND text !~ E'0[2-9]\. AKOSEZC' AND text !~ E'1[0-9]\. AKOSEZC'
UNION
SELECT R.time, R.gk_x AS Y, R.gk_y AS X, 'AKOSMEA' AS cell, R.rscp FROM romes_history_rscp_od_2005 R WHERE text  ~ 'AKOSMEA' AND text !~ E'0[2-9]\. AKOSMEA' AND text !~ E'1[0-9]\. AKOSMEA'
UNION
SELECT R.time, R.gk_x AS Y, R.gk_y AS X, 'AKOSMEB' AS cell, R.rscp FROM romes_history_rscp_od_2005 R WHERE text  ~ 'AKOSMEB' AND text !~ E'0[2-9]\. AKOSMEB' AND text !~ E'1[0-9]\. AKOSMEB'
UNION
SELECT R.time, R.gk_x AS Y, R.gk_y AS X, 'AKOSMEC' AS cell, R.rscp FROM romes_history_rscp_od_2005 R WHERE text  ~ 'AKOSMEC' AND text !~ E'0[2-9]\. AKOSMEC' AND text !~ E'1[0-9]\. AKOSMEC'
UNION
SELECT R.time, R.gk_x AS Y, R.gk_y AS X, 'AKOTNIA' AS cell, R.rscp FROM romes_history_rscp_od_2005 R WHERE text  ~ 'AKOTNIA' AND text !~ E'0[2-9]\. AKOTNIA' AND text !~ E'1[0-9]\. AKOTNIA'
UNION
SELECT R.time, R.gk_x AS Y, R.gk_y AS X, 'AKOTNIB' AS cell, R.rscp FROM romes_history_rscp_od_2005 R WHERE text  ~ 'AKOTNIB' AND text !~ E'0[2-9]\. AKOTNIB' AND text !~ E'1[0-9]\. AKOTNIB'
UNION
SELECT R.time, R.gk_x AS Y, R.gk_y AS X, 'AKOTNIC' AS cell, R.rscp FROM romes_history_rscp_od_2005 R WHERE text  ~ 'AKOTNIC' AND text !~ E'0[2-9]\. AKOTNIC' AND text !~ E'1[0-9]\. AKOTNIC'
UNION
SELECT R.time, R.gk_x AS Y, R.gk_y AS X, 'AKOVINA' AS cell, R.rscp FROM romes_history_rscp_od_2005 R WHERE text  ~ 'AKOVINA' AND text !~ E'0[2-9]\. AKOVINA' AND text !~ E'1[0-9]\. AKOVINA'
UNION
SELECT R.time, R.gk_x AS Y, R.gk_y AS X, 'AKOVINB' AS cell, R.rscp FROM romes_history_rscp_od_2005 R WHERE text  ~ 'AKOVINB' AND text !~ E'0[2-9]\. AKOVINB' AND text !~ E'1[0-9]\. AKOVINB'
UNION
SELECT R.time, R.gk_x AS Y, R.gk_y AS X, 'AKOVINC' AS cell, R.rscp FROM romes_history_rscp_od_2005 R WHERE text  ~ 'AKOVINC' AND text !~ E'0[2-9]\. AKOVINC' AND text !~ E'1[0-9]\. AKOVINC'
UNION
SELECT R.time, R.gk_x AS Y, R.gk_y AS X, 'ALMLEKA' AS cell, R.rscp FROM romes_history_rscp_od_2005 R WHERE text  ~ 'ALMLEKA' AND text !~ E'0[2-9]\. ALMLEKA' AND text !~ E'1[0-9]\. ALMLEKA'
UNION
SELECT R.time, R.gk_x AS Y, R.gk_y AS X, 'ALMLEKB' AS cell, R.rscp FROM romes_history_rscp_od_2005 R WHERE text  ~ 'ALMLEKB' AND text !~ E'0[2-9]\. ALMLEKB' AND text !~ E'1[0-9]\. ALMLEKB'
UNION
SELECT R.time, R.gk_x AS Y, R.gk_y AS X, 'ALMLEKC' AS cell, R.rscp FROM romes_history_rscp_od_2005 R WHERE text  ~ 'ALMLEKC' AND text !~ E'0[2-9]\. ALMLEKC' AND text !~ E'1[0-9]\. ALMLEKC'
UNION
SELECT R.time, R.gk_x AS Y, R.gk_y AS X, 'AMHOTEA' AS cell, R.rscp FROM romes_history_rscp_od_2005 R WHERE text  ~ 'AMHOTEA' AND text !~ E'0[2-9]\. AMHOTEA' AND text !~ E'1[0-9]\. AMHOTEA'
UNION
SELECT R.time, R.gk_x AS Y, R.gk_y AS X, 'AMHOTEB' AS cell, R.rscp FROM romes_history_rscp_od_2005 R WHERE text  ~ 'AMHOTEB' AND text !~ E'0[2-9]\. AMHOTEB' AND text !~ E'1[0-9]\. AMHOTEB'
UNION
SELECT R.time, R.gk_x AS Y, R.gk_y AS X, 'AMHOTEC' AS cell, R.rscp FROM romes_history_rscp_od_2005 R WHERE text  ~ 'AMHOTEC' AND text !~ E'0[2-9]\. AMHOTEC' AND text !~ E'1[0-9]\. AMHOTEC'
UNION
SELECT R.time, R.gk_x AS Y, R.gk_y AS X, 'AMOBIA' AS cell, R.rscp FROM romes_history_rscp_od_2005 R WHERE text  ~ 'AMOBIA' AND text !~ E'0[2-9]\. AMOBIA' AND text !~ E'1[0-9]\. AMOBIA'
UNION
SELECT R.time, R.gk_x AS Y, R.gk_y AS X, 'AMOBIB' AS cell, R.rscp FROM romes_history_rscp_od_2005 R WHERE text  ~ 'AMOBIB' AND text !~ E'0[2-9]\. AMOBIB' AND text !~ E'1[0-9]\. AMOBIB'
UNION
SELECT R.time, R.gk_x AS Y, R.gk_y AS X, 'AMOBIC' AS cell, R.rscp FROM romes_history_rscp_od_2005 R WHERE text  ~ 'AMOBIC' AND text !~ E'0[2-9]\. AMOBIC' AND text !~ E'1[0-9]\. AMOBIC'
UNION
SELECT R.time, R.gk_x AS Y, R.gk_y AS X, 'AMZSA' AS cell, R.rscp FROM romes_history_rscp_od_2005 R WHERE text  ~ 'AMZSA' AND text !~ E'0[2-9]\. AMZSA' AND text !~ E'1[0-9]\. AMZSA'
UNION
SELECT R.time, R.gk_x AS Y, R.gk_y AS X, 'AMZSB' AS cell, R.rscp FROM romes_history_rscp_od_2005 R WHERE text  ~ 'AMZSB' AND text !~ E'0[2-9]\. AMZSB' AND text !~ E'1[0-9]\. AMZSB'
UNION
SELECT R.time, R.gk_x AS Y, R.gk_y AS X, 'AMZSC' AS cell, R.rscp FROM romes_history_rscp_od_2005 R WHERE text  ~ 'AMZSC' AND text !~ E'0[2-9]\. AMZSC' AND text !~ E'1[0-9]\. AMZSC'
UNION
SELECT R.time, R.gk_x AS Y, R.gk_y AS X, 'APODUTA' AS cell, R.rscp FROM romes_history_rscp_od_2005 R WHERE text  ~ 'APODUTA' AND text !~ E'0[2-9]\. APODUTA' AND text !~ E'1[0-9]\. APODUTA'
UNION
SELECT R.time, R.gk_x AS Y, R.gk_y AS X, 'APODUTB' AS cell, R.rscp FROM romes_history_rscp_od_2005 R WHERE text  ~ 'APODUTB' AND text !~ E'0[2-9]\. APODUTB' AND text !~ E'1[0-9]\. APODUTB'
UNION
SELECT R.time, R.gk_x AS Y, R.gk_y AS X, 'APODUTC' AS cell, R.rscp FROM romes_history_rscp_od_2005 R WHERE text  ~ 'APODUTC' AND text !~ E'0[2-9]\. APODUTC' AND text !~ E'1[0-9]\. APODUTC'
UNION
SELECT R.time, R.gk_x AS Y, R.gk_y AS X, 'APOPTVA' AS cell, R.rscp FROM romes_history_rscp_od_2005 R WHERE text  ~ 'APOPTVA' AND text !~ E'0[2-9]\. APOPTVA' AND text !~ E'1[0-9]\. APOPTVA'
UNION
SELECT R.time, R.gk_x AS Y, R.gk_y AS X, 'APOPTVB' AS cell, R.rscp FROM romes_history_rscp_od_2005 R WHERE text  ~ 'APOPTVB' AND text !~ E'0[2-9]\. APOPTVB' AND text !~ E'1[0-9]\. APOPTVB'
UNION
SELECT R.time, R.gk_x AS Y, R.gk_y AS X, 'APOPTVC' AS cell, R.rscp FROM romes_history_rscp_od_2005 R WHERE text  ~ 'APOPTVC' AND text !~ E'0[2-9]\. APOPTVC' AND text !~ E'1[0-9]\. APOPTVC'
UNION
SELECT R.time, R.gk_x AS Y, R.gk_y AS X, 'APRZACA' AS cell, R.rscp FROM romes_history_rscp_od_2005 R WHERE text  ~ 'APRZACA' AND text !~ E'0[2-9]\. APRZACA' AND text !~ E'1[0-9]\. APRZACA'
UNION
SELECT R.time, R.gk_x AS Y, R.gk_y AS X, 'APRZACB' AS cell, R.rscp FROM romes_history_rscp_od_2005 R WHERE text  ~ 'APRZACB' AND text !~ E'0[2-9]\. APRZACB' AND text !~ E'1[0-9]\. APRZACB'
UNION
SELECT R.time, R.gk_x AS Y, R.gk_y AS X, 'APRZACC' AS cell, R.rscp FROM romes_history_rscp_od_2005 R WHERE text  ~ 'APRZACC' AND text !~ E'0[2-9]\. APRZACC' AND text !~ E'1[0-9]\. APRZACC'
UNION
SELECT R.time, R.gk_x AS Y, R.gk_y AS X, 'ARESEVA' AS cell, R.rscp FROM romes_history_rscp_od_2005 R WHERE text  ~ 'ARESEVA' AND text !~ E'0[2-9]\. ARESEVA' AND text !~ E'1[0-9]\. ARESEVA'
UNION
SELECT R.time, R.gk_x AS Y, R.gk_y AS X, 'ARESEVB' AS cell, R.rscp FROM romes_history_rscp_od_2005 R WHERE text  ~ 'ARESEVB' AND text !~ E'0[2-9]\. ARESEVB' AND text !~ E'1[0-9]\. ARESEVB'
UNION
SELECT R.time, R.gk_x AS Y, R.gk_y AS X, 'ARESEVC' AS cell, R.rscp FROM romes_history_rscp_od_2005 R WHERE text  ~ 'ARESEVC' AND text !~ E'0[2-9]\. ARESEVC' AND text !~ E'1[0-9]\. ARESEVC'
UNION
SELECT R.time, R.gk_x AS Y, R.gk_y AS X, 'ASAVLJA' AS cell, R.rscp FROM romes_history_rscp_od_2005 R WHERE text  ~ 'ASAVLJA' AND text !~ E'0[2-9]\. ASAVLJA' AND text !~ E'1[0-9]\. ASAVLJA'
UNION
SELECT R.time, R.gk_x AS Y, R.gk_y AS X, 'ASAVLJB' AS cell, R.rscp FROM romes_history_rscp_od_2005 R WHERE text  ~ 'ASAVLJB' AND text !~ E'0[2-9]\. ASAVLJB' AND text !~ E'1[0-9]\. ASAVLJB'
UNION
SELECT R.time, R.gk_x AS Y, R.gk_y AS X, 'ASAVLJC' AS cell, R.rscp FROM romes_history_rscp_od_2005 R WHERE text  ~ 'ASAVLJC' AND text !~ E'0[2-9]\. ASAVLJC' AND text !~ E'1[0-9]\. ASAVLJC'
UNION
SELECT R.time, R.gk_x AS Y, R.gk_y AS X, 'ASISKPA' AS cell, R.rscp FROM romes_history_rscp_od_2005 R WHERE text  ~ 'ASISKPA' AND text !~ E'0[2-9]\. ASISKPA' AND text !~ E'1[0-9]\. ASISKPA'
UNION
SELECT R.time, R.gk_x AS Y, R.gk_y AS X, 'ASISKPB' AS cell, R.rscp FROM romes_history_rscp_od_2005 R WHERE text  ~ 'ASISKPB' AND text !~ E'0[2-9]\. ASISKPB' AND text !~ E'1[0-9]\. ASISKPB'
UNION
SELECT R.time, R.gk_x AS Y, R.gk_y AS X, 'ASISKPC' AS cell, R.rscp FROM romes_history_rscp_od_2005 R WHERE text  ~ 'ASISKPC' AND text !~ E'0[2-9]\. ASISKPC' AND text !~ E'1[0-9]\. ASISKPC'
UNION
SELECT R.time, R.gk_x AS Y, R.gk_y AS X, 'ASKZA' AS cell, R.rscp FROM romes_history_rscp_od_2005 R WHERE text  ~ 'ASKZA' AND text !~ E'0[2-9]\. ASKZA' AND text !~ E'1[0-9]\. ASKZA'
UNION
SELECT R.time, R.gk_x AS Y, R.gk_y AS X, 'ASKZB' AS cell, R.rscp FROM romes_history_rscp_od_2005 R WHERE text  ~ 'ASKZB' AND text !~ E'0[2-9]\. ASKZB' AND text !~ E'1[0-9]\. ASKZB'
UNION
SELECT R.time, R.gk_x AS Y, R.gk_y AS X, 'ASKZKA' AS cell, R.rscp FROM romes_history_rscp_od_2005 R WHERE text  ~ 'ASKZKA' AND text !~ E'0[2-9]\. ASKZKA' AND text !~ E'1[0-9]\. ASKZKA'
UNION
SELECT R.time, R.gk_x AS Y, R.gk_y AS X, 'ASLOMA' AS cell, R.rscp FROM romes_history_rscp_od_2005 R WHERE text  ~ 'ASLOMA' AND text !~ E'0[2-9]\. ASLOMA' AND text !~ E'1[0-9]\. ASLOMA'
UNION
SELECT R.time, R.gk_x AS Y, R.gk_y AS X, 'ASLOMB' AS cell, R.rscp FROM romes_history_rscp_od_2005 R WHERE text  ~ 'ASLOMB' AND text !~ E'0[2-9]\. ASLOMB' AND text !~ E'1[0-9]\. ASLOMB'
UNION
SELECT R.time, R.gk_x AS Y, R.gk_y AS X, 'ASLOMC' AS cell, R.rscp FROM romes_history_rscp_od_2005 R WHERE text  ~ 'ASLOMC' AND text !~ E'0[2-9]\. ASLOMC' AND text !~ E'1[0-9]\. ASLOMC'
UNION
SELECT R.time, R.gk_x AS Y, R.gk_y AS X, 'ASMELTA' AS cell, R.rscp FROM romes_history_rscp_od_2005 R WHERE text  ~ 'ASMELTA' AND text !~ E'0[2-9]\. ASMELTA' AND text !~ E'1[0-9]\. ASMELTA'
UNION
SELECT R.time, R.gk_x AS Y, R.gk_y AS X, 'ASMELTB' AS cell, R.rscp FROM romes_history_rscp_od_2005 R WHERE text  ~ 'ASMELTB' AND text !~ E'0[2-9]\. ASMELTB' AND text !~ E'1[0-9]\. ASMELTB'
UNION
SELECT R.time, R.gk_x AS Y, R.gk_y AS X, 'ASMELTC' AS cell, R.rscp FROM romes_history_rscp_od_2005 R WHERE text  ~ 'ASMELTC' AND text !~ E'0[2-9]\. ASMELTC' AND text !~ E'1[0-9]\. ASMELTC'
UNION
SELECT R.time, R.gk_x AS Y, R.gk_y AS X, 'ASTEGA' AS cell, R.rscp FROM romes_history_rscp_od_2005 R WHERE text  ~ 'ASTEGA' AND text !~ E'0[2-9]\. ASTEGA' AND text !~ E'1[0-9]\. ASTEGA'
UNION
SELECT R.time, R.gk_x AS Y, R.gk_y AS X, 'ASTEGB' AS cell, R.rscp FROM romes_history_rscp_od_2005 R WHERE text  ~ 'ASTEGB' AND text !~ E'0[2-9]\. ASTEGB' AND text !~ E'1[0-9]\. ASTEGB'
UNION
SELECT R.time, R.gk_x AS Y, R.gk_y AS X, 'ASTEGC' AS cell, R.rscp FROM romes_history_rscp_od_2005 R WHERE text  ~ 'ASTEGC' AND text !~ E'0[2-9]\. ASTEGC' AND text !~ E'1[0-9]\. ASTEGC'
UNION
SELECT R.time, R.gk_x AS Y, R.gk_y AS X, 'ASTRALA' AS cell, R.rscp FROM romes_history_rscp_od_2005 R WHERE text  ~ 'ASTRALA' AND text !~ E'0[2-9]\. ASTRALA' AND text !~ E'1[0-9]\. ASTRALA'
UNION
SELECT R.time, R.gk_x AS Y, R.gk_y AS X, 'ASTRALB' AS cell, R.rscp FROM romes_history_rscp_od_2005 R WHERE text  ~ 'ASTRALB' AND text !~ E'0[2-9]\. ASTRALB' AND text !~ E'1[0-9]\. ASTRALB'
UNION
SELECT R.time, R.gk_x AS Y, R.gk_y AS X, 'ASTRALC' AS cell, R.rscp FROM romes_history_rscp_od_2005 R WHERE text  ~ 'ASTRALC' AND text !~ E'0[2-9]\. ASTRALC' AND text !~ E'1[0-9]\. ASTRALC'
UNION
SELECT R.time, R.gk_x AS Y, R.gk_y AS X, 'ATABORA' AS cell, R.rscp FROM romes_history_rscp_od_2005 R WHERE text  ~ 'ATABORA' AND text !~ E'0[2-9]\. ATABORA' AND text !~ E'1[0-9]\. ATABORA'
UNION
SELECT R.time, R.gk_x AS Y, R.gk_y AS X, 'ATABORB' AS cell, R.rscp FROM romes_history_rscp_od_2005 R WHERE text  ~ 'ATABORB' AND text !~ E'0[2-9]\. ATABORB' AND text !~ E'1[0-9]\. ATABORB'
UNION
SELECT R.time, R.gk_x AS Y, R.gk_y AS X, 'ATABORC' AS cell, R.rscp FROM romes_history_rscp_od_2005 R WHERE text  ~ 'ATABORC' AND text !~ E'0[2-9]\. ATABORC' AND text !~ E'1[0-9]\. ATABORC'
UNION
SELECT R.time, R.gk_x AS Y, R.gk_y AS X, 'ATEGRA' AS cell, R.rscp FROM romes_history_rscp_od_2005 R WHERE text  ~ 'ATEGRA' AND text !~ E'0[2-9]\. ATEGRA' AND text !~ E'1[0-9]\. ATEGRA'
UNION
SELECT R.time, R.gk_x AS Y, R.gk_y AS X, 'ATEGRB' AS cell, R.rscp FROM romes_history_rscp_od_2005 R WHERE text  ~ 'ATEGRB' AND text !~ E'0[2-9]\. ATEGRB' AND text !~ E'1[0-9]\. ATEGRB'
UNION
SELECT R.time, R.gk_x AS Y, R.gk_y AS X, 'ATEGRC' AS cell, R.rscp FROM romes_history_rscp_od_2005 R WHERE text  ~ 'ATEGRC' AND text !~ E'0[2-9]\. ATEGRC' AND text !~ E'1[0-9]\. ATEGRC'
UNION
SELECT R.time, R.gk_x AS Y, R.gk_y AS X, 'ATIVOA' AS cell, R.rscp FROM romes_history_rscp_od_2005 R WHERE text  ~ 'ATIVOA' AND text !~ E'0[2-9]\. ATIVOA' AND text !~ E'1[0-9]\. ATIVOA'
UNION
SELECT R.time, R.gk_x AS Y, R.gk_y AS X, 'ATIVOB' AS cell, R.rscp FROM romes_history_rscp_od_2005 R WHERE text  ~ 'ATIVOB' AND text !~ E'0[2-9]\. ATIVOB' AND text !~ E'1[0-9]\. ATIVOB'
UNION
SELECT R.time, R.gk_x AS Y, R.gk_y AS X, 'ATIVOC' AS cell, R.rscp FROM romes_history_rscp_od_2005 R WHERE text  ~ 'ATIVOC' AND text !~ E'0[2-9]\. ATIVOC' AND text !~ E'1[0-9]\. ATIVOC'
UNION
SELECT R.time, R.gk_x AS Y, R.gk_y AS X, 'ATOPNIA' AS cell, R.rscp FROM romes_history_rscp_od_2005 R WHERE text  ~ 'ATOPNIA' AND text !~ E'0[2-9]\. ATOPNIA' AND text !~ E'1[0-9]\. ATOPNIA'
UNION
SELECT R.time, R.gk_x AS Y, R.gk_y AS X, 'ATOPNIB' AS cell, R.rscp FROM romes_history_rscp_od_2005 R WHERE text  ~ 'ATOPNIB' AND text !~ E'0[2-9]\. ATOPNIB' AND text !~ E'1[0-9]\. ATOPNIB'
UNION
SELECT R.time, R.gk_x AS Y, R.gk_y AS X, 'ATOPNIC' AS cell, R.rscp FROM romes_history_rscp_od_2005 R WHERE text  ~ 'ATOPNIC' AND text !~ E'0[2-9]\. ATOPNIC' AND text !~ E'1[0-9]\. ATOPNIC'
UNION
SELECT R.time, R.gk_x AS Y, R.gk_y AS X, 'ATVSLOA' AS cell, R.rscp FROM romes_history_rscp_od_2005 R WHERE text  ~ 'ATVSLOA' AND text !~ E'0[2-9]\. ATVSLOA' AND text !~ E'1[0-9]\. ATVSLOA'
UNION
SELECT R.time, R.gk_x AS Y, R.gk_y AS X, 'ATVSLOB' AS cell, R.rscp FROM romes_history_rscp_od_2005 R WHERE text  ~ 'ATVSLOB' AND text !~ E'0[2-9]\. ATVSLOB' AND text !~ E'1[0-9]\. ATVSLOB'
UNION
SELECT R.time, R.gk_x AS Y, R.gk_y AS X, 'ATVSLOC' AS cell, R.rscp FROM romes_history_rscp_od_2005 R WHERE text  ~ 'ATVSLOC' AND text !~ E'0[2-9]\. ATVSLOC' AND text !~ E'1[0-9]\. ATVSLOC'
UNION
SELECT R.time, R.gk_x AS Y, R.gk_y AS X, 'AURSKAA' AS cell, R.rscp FROM romes_history_rscp_od_2005 R WHERE text  ~ 'AURSKAA' AND text !~ E'0[2-9]\. AURSKAA' AND text !~ E'1[0-9]\. AURSKAA'
UNION
SELECT R.time, R.gk_x AS Y, R.gk_y AS X, 'AURSKAB' AS cell, R.rscp FROM romes_history_rscp_od_2005 R WHERE text  ~ 'AURSKAB' AND text !~ E'0[2-9]\. AURSKAB' AND text !~ E'1[0-9]\. AURSKAB'
UNION
SELECT R.time, R.gk_x AS Y, R.gk_y AS X, 'AURSKAC' AS cell, R.rscp FROM romes_history_rscp_od_2005 R WHERE text  ~ 'AURSKAC' AND text !~ E'0[2-9]\. AURSKAC' AND text !~ E'1[0-9]\. AURSKAC'
UNION
SELECT R.time, R.gk_x AS Y, R.gk_y AS X, 'AVECNAA' AS cell, R.rscp FROM romes_history_rscp_od_2005 R WHERE text  ~ 'AVECNAA' AND text !~ E'0[2-9]\. AVECNAA' AND text !~ E'1[0-9]\. AVECNAA'
UNION
SELECT R.time, R.gk_x AS Y, R.gk_y AS X, 'AVECNAB' AS cell, R.rscp FROM romes_history_rscp_od_2005 R WHERE text  ~ 'AVECNAB' AND text !~ E'0[2-9]\. AVECNAB' AND text !~ E'1[0-9]\. AVECNAB'
UNION
SELECT R.time, R.gk_x AS Y, R.gk_y AS X, 'AVEROVA' AS cell, R.rscp FROM romes_history_rscp_od_2005 R WHERE text  ~ 'AVEROVA' AND text !~ E'0[2-9]\. AVEROVA' AND text !~ E'1[0-9]\. AVEROVA'
UNION
SELECT R.time, R.gk_x AS Y, R.gk_y AS X, 'AVEROVB' AS cell, R.rscp FROM romes_history_rscp_od_2005 R WHERE text  ~ 'AVEROVB' AND text !~ E'0[2-9]\. AVEROVB' AND text !~ E'1[0-9]\. AVEROVB'
UNION
SELECT R.time, R.gk_x AS Y, R.gk_y AS X, 'AVEROVC' AS cell, R.rscp FROM romes_history_rscp_od_2005 R WHERE text  ~ 'AVEROVC' AND text !~ E'0[2-9]\. AVEROVC' AND text !~ E'1[0-9]\. AVEROVC'
UNION
SELECT R.time, R.gk_x AS Y, R.gk_y AS X, 'AVILAA' AS cell, R.rscp FROM romes_history_rscp_od_2005 R WHERE text  ~ 'AVILAA' AND text !~ E'0[2-9]\. AVILAA' AND text !~ E'1[0-9]\. AVILAA'
UNION
SELECT R.time, R.gk_x AS Y, R.gk_y AS X, 'AVILAB' AS cell, R.rscp FROM romes_history_rscp_od_2005 R WHERE text  ~ 'AVILAB' AND text !~ E'0[2-9]\. AVILAB' AND text !~ E'1[0-9]\. AVILAB'
UNION
SELECT R.time, R.gk_x AS Y, R.gk_y AS X, 'AVILAC' AS cell, R.rscp FROM romes_history_rscp_od_2005 R WHERE text  ~ 'AVILAC' AND text !~ E'0[2-9]\. AVILAC' AND text !~ E'1[0-9]\. AVILAC'
UNION
SELECT R.time, R.gk_x AS Y, R.gk_y AS X, 'AVIZMAA' AS cell, R.rscp FROM romes_history_rscp_od_2005 R WHERE text  ~ 'AVIZMAA' AND text !~ E'0[2-9]\. AVIZMAA' AND text !~ E'1[0-9]\. AVIZMAA'
UNION
SELECT R.time, R.gk_x AS Y, R.gk_y AS X, 'AVIZMAB' AS cell, R.rscp FROM romes_history_rscp_od_2005 R WHERE text  ~ 'AVIZMAB' AND text !~ E'0[2-9]\. AVIZMAB' AND text !~ E'1[0-9]\. AVIZMAB'
UNION
SELECT R.time, R.gk_x AS Y, R.gk_y AS X, 'AVIZMAC' AS cell, R.rscp FROM romes_history_rscp_od_2005 R WHERE text  ~ 'AVIZMAC' AND text !~ E'0[2-9]\. AVIZMAC' AND text !~ E'1[0-9]\. AVIZMAC'
UNION
SELECT R.time, R.gk_x AS Y, R.gk_y AS X, 'AZAPUZA' AS cell, R.rscp FROM romes_history_rscp_od_2005 R WHERE text  ~ 'AZAPUZA' AND text !~ E'0[2-9]\. AZAPUZA' AND text !~ E'1[0-9]\. AZAPUZA'
UNION
SELECT R.time, R.gk_x AS Y, R.gk_y AS X, 'AZAPUZB' AS cell, R.rscp FROM romes_history_rscp_od_2005 R WHERE text  ~ 'AZAPUZB' AND text !~ E'0[2-9]\. AZAPUZB' AND text !~ E'1[0-9]\. AZAPUZB'
UNION
SELECT R.time, R.gk_x AS Y, R.gk_y AS X, 'AZAPUZC' AS cell, R.rscp FROM romes_history_rscp_od_2005 R WHERE text  ~ 'AZAPUZC' AND text !~ E'0[2-9]\. AZAPUZC' AND text !~ E'1[0-9]\. AZAPUZC'
