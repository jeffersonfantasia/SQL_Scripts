SELECT M.ROWID,
       M.VLBASEPISCOFINSBKP,
       M.VLCREDPISBKP,
       M.VLCREDCOFINSBKP,
       P.VLBASEPISCOFINS,
       P.VLCREDPIS,
       P.VLCREDCOFINS,
       M.*
  FROM PCMOVCOMPLE M
 INNER JOIN PCMOV P ON M.NUMTRANSITEM = P.NUMTRANSITEM
 WHERE P.NUMTRANSENT IN (1775451)
   AND P.CODPROD IN (814167);

