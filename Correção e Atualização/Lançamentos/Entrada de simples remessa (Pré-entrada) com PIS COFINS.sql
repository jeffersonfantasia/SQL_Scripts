-----------ALTERAR A BASE DO % DE CREDITO DE PIS COFINS---------
SELECT ROWID,
       E.VLBASEPISCOFINS,
       E.PERPIS,
       E.VLCREDPIS,
       E.PERCOFINS,
       E.VLCREDCOFINS,
       E.BASEICMS,
       E. *
  FROM PCMOVPREENT E
 WHERE NUMNOTA = 212009;
