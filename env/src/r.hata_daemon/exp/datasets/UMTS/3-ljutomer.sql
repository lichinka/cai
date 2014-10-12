SELECT R.time, R.gk_x AS Y, R.gk_y AS X, 'SBANOVA' AS cell, R.rscp FROM romes_history_rscp_od_2005 R WHERE text  ~ 'SBANOVA' AND text !~ E'0[2-9]\. SBANOVA' AND text !~ E'1[0-9]\. SBANOVA'
UNION
SELECT R.time, R.gk_x AS Y, R.gk_y AS X, 'SBANOVB' AS cell, R.rscp FROM romes_history_rscp_od_2005 R WHERE text  ~ 'SBANOVB' AND text !~ E'0[2-9]\. SBANOVB' AND text !~ E'1[0-9]\. SBANOVB'
UNION
SELECT R.time, R.gk_x AS Y, R.gk_y AS X, 'SBANOVC' AS cell, R.rscp FROM romes_history_rscp_od_2005 R WHERE text  ~ 'SBANOVC' AND text !~ E'0[2-9]\. SBANOVC' AND text !~ E'1[0-9]\. SBANOVC'
UNION
SELECT R.time, R.gk_x AS Y, R.gk_y AS X, 'SBELTIA' AS cell, R.rscp FROM romes_history_rscp_od_2005 R WHERE text  ~ 'SBELTIA' AND text !~ E'0[2-9]\. SBELTIA' AND text !~ E'1[0-9]\. SBELTIA'
UNION
SELECT R.time, R.gk_x AS Y, R.gk_y AS X, 'SBELTIB' AS cell, R.rscp FROM romes_history_rscp_od_2005 R WHERE text  ~ 'SBELTIB' AND text !~ E'0[2-9]\. SBELTIB' AND text !~ E'1[0-9]\. SBELTIB'
UNION
SELECT R.time, R.gk_x AS Y, R.gk_y AS X, 'SBELTIC' AS cell, R.rscp FROM romes_history_rscp_od_2005 R WHERE text  ~ 'SBELTIC' AND text !~ E'0[2-9]\. SBELTIC' AND text !~ E'1[0-9]\. SBELTIC'
UNION
SELECT R.time, R.gk_x AS Y, R.gk_y AS X, 'SLJUTKA' AS cell, R.rscp FROM romes_history_rscp_od_2005 R WHERE text  ~ 'SLJUTKA' AND text !~ E'0[2-9]\. SLJUTKA' AND text !~ E'1[0-9]\. SLJUTKA'
UNION
SELECT R.time, R.gk_x AS Y, R.gk_y AS X, 'SLJUTKB' AS cell, R.rscp FROM romes_history_rscp_od_2005 R WHERE text  ~ 'SLJUTKB' AND text !~ E'0[2-9]\. SLJUTKB' AND text !~ E'1[0-9]\. SLJUTKB'
