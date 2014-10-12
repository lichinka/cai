--
-- BOHINJ: 403000, 122000 - 423000, 136000
--
--SELECT C.name
--  FROM network.cell C 
--  JOIN network.site S 
--    ON C.id_site = S.id_site
--   AND S.name IN ('KBOHBI', 'KCESNJ', 'KHOP', 'KORLOV', 'KPOKL', 'KRIBL', 'KVOGEL')
--ORDER BY C.name;

--
-- LJUBLJANA: 455000, 97000 - 470000, 110000
--
SELECT C.name
  FROM network.cell C 
  JOIN network.site S 
    ON C.id_site = S.id_site
   AND S.name IN ('ABEZI', 'ABEZIT', 'ABIZOV', 'ABOKAL', 'ABRDO', 'ABROD', 'ABTC', 'ABTCMI', 
          'ACERNE', 'ACHEMO', 'ACRGMA', 'ACRNUC', 'ADELO', 'ADNEVN', 'ADOLGI', 'ADRAV', 
          'AEJATA', 'AELNA', 'AELOK', 'AFORD', 'AFRANK', 'AFUZIN', 'AGAMGD', 'AGEOPL', 'AGPG', 
          'AGRAD', 'AGRAM', 'AGRIC', 'AGURS', 'AGZ', 'AHLEV', 'AIJS', 'AIMKO', 'AJELSA', 'AJEZA', 
          'AJEZKZ', 'AJOZEF', 'AKASEL', 'AKODEL', 'AKOLEZ', 'AKOLIN', 'AKONEX', 'AKOSEG', 
          'AKOSET', 'AKOSEZ', 'AKOSME', 'AKOTNI', 'AKOVIN', 'AKOZAR', 'ALITIJ', 'ALIVAD', 
          'ALMLEK', 'ALPP', 'AMHOTE', 'AMOBI', 'AMOSTE', 'AMURGL', 'AMZS', 'ANADGO', 'ANAMA', 
          'ANTENA', 'AOBI', 'APETER', 'APLAMA', 'APODUT', 'APOLCE', 'APOPTV', 'APOVSE', 
          'APROGA', 'APRZAC', 'ARAK', 'ARAKTK', 'ARESEV', 'AROZNA', 'ASAVLJ', 'ASAZU', 'ASEME', 
          'ASISKP', 'ASKZ', 'ASKZK', 'ASLOM', 'ASMAR', 'ASMARG', 'ASMART', 'ASMELT', 'ASOSTR', 
          'ASPAR', 'ASTARA', 'ASTEG', 'ASTEP', 'ASTRAL', 'ATABOR', 'ATACGD', 'ATEGR', 'ATIVO', 
          'ATOMAC', 'ATOPLA', 'ATOPNI', 'ATOTRA', 'ATRNOV', 'ATRUB', 'ATUNEL', 'ATVSLO', 'AURSKA', 
          'AVARNO', 'AVECNA', 'AVEGAS', 'AVELAN', 'AVEROV', 'AVEVCE', 'AVIC', 'AVICTK', 'AVILA', 
          'AVIZMA', 'AVLADA', 'AVRHO', 'AVRHOV', 'AZADOB', 'AZALOG', 'AZAPUZ', 'AZELEZ', 'AZIMA', 
          'AZITO', 'LBRESZ', 'LDOBRO', 'LDRAG', 'LPODG', 'LTRZIN', 'LTRZV')
ORDER BY C.name;
   

--
-- LJUTOMER: 582000, 152000 - 597000, 165000 
--
--SELECT C.name
--  FROM network.cell C
--  JOIN network.site S
--    ON C.id_site = S.id_site
--   AND S.name IN ('SBAKOV', 'SBANOV', 'SBELTI', 'SKRIZE', 'SLJUT', 'SLJUTK')
--ORDER BY C.name;

