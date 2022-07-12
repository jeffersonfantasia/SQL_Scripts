SELECT M.DATA,
       M.CODBANCO,
       L.NUMNOTA,
       CASE
         WHEN M.CODCOB = 'D' THEN 'DINHEIRO'
         ELSE M.CODCOB
       END MOEDA,
       CASE
         WHEN M.TIPO = 'C' THEN M.VALOR
         ELSE M.VALOR * - 1
       END VALOR,
       M.TIPO,
       M.HISTORICO,
       (M.CODFUNC || ' - ' || (SELECT NOME_GUERRA
                                 FROM PCEMPR E
                                WHERE E.MATRICULA = M.CODFUNC
                              )) FUNC_LANC
  FROM PCMOVCR M
  LEFT JOIN PCLANC L ON M.NUMTRANS = L.NUMTRANS
 WHERE M.CODBANCO = 41
   AND M.DTESTORNO IS NULL
   AND M.CONCILIACAO IS NULL
   AND L.CODCONTA NOT IN (
  610103
)
 ORDER BY L.NUMNOTA,
          M.TIPO,
          L.HISTORICO;