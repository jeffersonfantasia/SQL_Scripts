SELECT M.ROWID,
       M.VLBASEPISCOFINSBKP,
       M.VLCREDPISBKP,
       M.VLCREDCOFINSBKP,
       P.VLBASEPISCOFINS AS VLBASEPISCOFINS,
       P.VLCREDPIS,
       P.VLCREDCOFINS,
       M.*
  FROM PCMOVCOMPLE M
 INNER JOIN PCMOV P ON M.NUMTRANSITEM = P.NUMTRANSITEM
 WHERE P.NUMTRANSENT IN (
    415014, 415028, 414962
)
   AND P.CODPROD IN (
    796237, 796236, 810477, 807249, 807248
);
/