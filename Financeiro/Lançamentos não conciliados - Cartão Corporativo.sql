SELECT DISTINCT M.DATA,
                M.CODBANCO,
								MIN(L.CODFORNEC) OVER (PARTITION BY NUMNOTA) CODFORNECPRINC,
								L.CODFORNEC,
								(SELECT F.FORNECEDOR FROM PCFORNEC F WHERE F.CODFORNEC = L.CODFORNEC) FORNECEDOR,
                L.NUMNOTA,
                M.NUMCARR,
								(CASE WHEN (L.NUMNOTA = M.NUMCARR) THEN 'OK' ELSE 'NOT OK' END) VERNOTA,
                CASE
                  WHEN M.CODCOB = 'D' THEN
                   'DINHEIRO'
                  ELSE
                   M.CODCOB
                END MOEDA,
                CASE
                  WHEN M.TIPO = 'C' THEN
                   M.VALOR
                  ELSE
                   M.VALOR * -1
                END VALOR,
                M.TIPO,
                M.HISTORICO,
                L.HISTORICO,
								(CASE WHEN (L.HISTORICO = M.HISTORICO) THEN 'OK' ELSE 'NOT OK' END) VERHISTORICO,
                (M.CODFUNC || ' - ' ||
                (SELECT NOME_GUERRA
                    FROM PCEMPR E
                   WHERE E.MATRICULA = M.CODFUNC)) FUNC_LANC
 --,M.rowid
 ,L.rowid
  --FROM PCMOVCR M
  --JOIN PCLANC L ON M.NUMTRANS = L.NUMTRANS
FROM PCLANC L 
JOIN PCMOVCR M ON M.NUMTRANS = L.NUMTRANS
 WHERE M.CODBANCO = 41
   AND M.DTESTORNO IS NULL
   --AND M.CONCILIACAO IS NULL
	 AND L.NUMNOTA IN (1183022)
   AND L.CODCONTA NOT IN (610103)
 ORDER BY L.NUMNOTA, M.TIPO, M.HISTORICO;
