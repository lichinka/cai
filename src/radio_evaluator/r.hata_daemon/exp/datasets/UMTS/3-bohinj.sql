SELECT R.time, R.gk_x AS Y, R.gk_y AS X, 'KBOHBIB' AS cell, R.rscp FROM romes_history_rscp_od_2005 R WHERE text  ~ 'KBOHBIB' AND text !~ E'0[2-9]\. KBOHBIB' AND text !~ E'1[0-9]\. KBOHBIB'
UNION
SELECT R.time, R.gk_x AS Y, R.gk_y AS X, 'KBOHBIC' AS cell, R.rscp FROM romes_history_rscp_od_2005 R WHERE text  ~ 'KBOHBIC' AND text !~ E'0[2-9]\. KBOHBIC' AND text !~ E'1[0-9]\. KBOHBIC'
UNION
SELECT R.time, R.gk_x AS Y, R.gk_y AS X, 'KBOHBIA' AS cell, R.rscp FROM romes_history_rscp_od_2005 R WHERE text  ~ 'KBOHBIA' AND text !~ E'0[2-9]\. KBOHBIA' AND text !~ E'1[0-9]\. KBOHBIA'
UNION
SELECT R.time, R.gk_x AS Y, R.gk_y AS X, 'KRIBLA' AS cell, R.rscp FROM romes_history_rscp_od_2005 R WHERE text  ~ 'KRIBLA' AND text !~ E'0[2-9]\. KRIBLA' AND text !~ E'1[0-9]\. KRIBLA'
UNION
SELECT R.time, R.gk_x AS Y, R.gk_y AS X, 'KRIBLB' AS cell, R.rscp FROM romes_history_rscp_od_2005 R WHERE text  ~ 'KRIBLB' AND text !~ E'0[2-9]\. KRIBLB' AND text !~ E'1[0-9]\. KRIBLB'
UNION
SELECT R.time, R.gk_x AS Y, R.gk_y AS X, 'KRIBLC' AS cell, R.rscp FROM romes_history_rscp_od_2005 R WHERE text  ~ 'KRIBLC' AND text !~ E'0[2-9]\. KRIBLC' AND text !~ E'1[0-9]\. KRIBLC'
UNION
SELECT R.time, R.gk_x AS Y, R.gk_y AS X, 'KVOGELA' AS cell, R.rscp FROM romes_history_rscp_od_2005 R WHERE text  ~ 'KVOGELA' AND text !~ E'0[2-9]\. KVOGELA' AND text !~ E'1[0-9]\. KVOGELA'
UNION
SELECT R.time, R.gk_x AS Y, R.gk_y AS X, 'KVOGELB' AS cell, R.rscp FROM romes_history_rscp_od_2005 R WHERE text  ~ 'KVOGELB' AND text !~ E'0[2-9]\. KVOGELB' AND text !~ E'1[0-9]\. KVOGELB'
UNION
SELECT R.time, R.gk_x AS Y, R.gk_y AS X, 'KZLATA' AS cell, R.rscp FROM romes_history_rscp_od_2005 R WHERE text  ~ 'KZLATA' AND text !~ E'0[2-9]\. KZLATA' AND text !~ E'1[0-9]\. KZLATA'
UNION
SELECT R.time, R.gk_x AS Y, R.gk_y AS X, 'KZLATB' AS cell, R.rscp FROM romes_history_rscp_od_2005 R WHERE text  ~ 'KZLATB' AND text !~ E'0[2-9]\. KZLATB' AND text !~ E'1[0-9]\. KZLATB'
