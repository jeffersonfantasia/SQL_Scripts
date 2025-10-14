---ALTERAÇÃO NA PCLANC
SELECT DISTINCT M.DATA,
                L.DTCOMPETENCIA,
                M.CODBANCO,
                MIN(L.CODFORNEC) OVER(PARTITION BY NUMNOTA) CODFORNECPRINC,
                L.CODFORNEC,
                (SELECT F.FORNECEDOR
                   FROM PCFORNEC F
                  WHERE F.CODFORNEC = L.CODFORNEC) FORNECEDOR,
                L.NUMNOTA,
                M.NUMCARR, l.codconta,
                (CASE
                  WHEN (L.NUMNOTA = M.NUMCARR) THEN
                   'OK'
                  ELSE
                   'NOT OK'
                END) VERNOTA,
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
								L.VALOR,
                M.TIPO,
                M.HISTORICO HISTORICO_PCMOVCR, M.HISTORICO2,
                L.HISTORICO,
                (CASE
                  WHEN (L.HISTORICO = M.HISTORICO) THEN
                   'OK'
                  ELSE
                   'NOT OK'
                END) VERHISTORICO,
                (M.CODFUNC || ' - ' ||
                (SELECT NOME_GUERRA
                    FROM PCEMPR E
                   WHERE E.MATRICULA = M.CODFUNC)) FUNC_LANC,
                L.rowid
  FROM PCLANC L
  JOIN PCMOVCR M ON M.NUMTRANS = L.NUMTRANS
 WHERE M.CODBANCO = 41
   AND M.DTESTORNO IS NULL
   AND M.CONCILIACAO IS NULL
   AND L.CODCONTA NOT IN (4005)
	 --AND L.NUMNOTA IN (62146, 7987)
 ORDER BY L.NUMNOTA, M.TIPO, M.HISTORICO;

---ALTERAÇÃO NA PCMOVCR
SELECT DISTINCT M.DATA,
                L.DTCOMPETENCIA,
                M.CODBANCO,
                MIN(L.CODFORNEC) OVER(PARTITION BY NUMNOTA) CODFORNECPRINC,
                L.CODFORNEC,
                (SELECT F.FORNECEDOR
                   FROM PCFORNEC F
                  WHERE F.CODFORNEC = L.CODFORNEC) FORNECEDOR,
                L.NUMNOTA,
                M.NUMCARR,
                (CASE
                  WHEN (L.NUMNOTA = M.NUMCARR) THEN
                   'OK'
                  ELSE
                   'NOT OK'
                END) VERNOTA,
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
								M.VALOR,
                M.TIPO,
                M.HISTORICO, m.historico2,
                L.HISTORICO HISTORICO_PCLANC,
                (CASE
                  WHEN (L.HISTORICO = M.HISTORICO) THEN
                   'OK'
                  ELSE
                   'NOT OK'
                END) VERHISTORICO,
                (M.CODFUNC || ' - ' ||
                (SELECT NOME_GUERRA
                    FROM PCEMPR E
                   WHERE E.MATRICULA = M.CODFUNC)) FUNC_LANC,
                M.rowid
  FROM PCMOVCR M
  JOIN PCLANC L ON M.NUMTRANS = L.NUMTRANS
 WHERE M.CODBANCO = 41
   AND M.DTESTORNO IS NULL
   AND M.CONCILIACAO IS NULL
   AND L.CODCONTA NOT IN (4005)
	 --AND L.NUMNOTA IN (7987)
 ORDER BY L.NUMNOTA, M.TIPO, M.HISTORICO;
 
 
 ---ALTERAÇÃO NA PCLANC JA CONCILIADO
SELECT DISTINCT M.DATA,
                L.DTCOMPETENCIA,
                M.CODBANCO, L.RECNUM,
								L.CODCONTA,
                MIN(L.CODFORNEC) OVER(PARTITION BY NUMNOTA) CODFORNECPRINC,
                L.CODFORNEC,
                (SELECT F.FORNECEDOR
                   FROM PCFORNEC F
                  WHERE F.CODFORNEC = L.CODFORNEC) FORNECEDOR,
                L.NUMNOTA,
                M.NUMCARR,
                (CASE
                  WHEN (L.NUMNOTA = M.NUMCARR) THEN
                   'OK'
                  ELSE
                   'NOT OK'
                END) VERNOTA,
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
                M.HISTORICO HISTORICO_PCMOVCR,
                L.HISTORICO,
                (CASE
                  WHEN (L.HISTORICO = M.HISTORICO) THEN
                   'OK'
                  ELSE
                   'NOT OK'
                END) VERHISTORICO,
                (M.CODFUNC || ' - ' ||
                (SELECT NOME_GUERRA
                    FROM PCEMPR E
                   WHERE E.MATRICULA = M.CODFUNC)) FUNC_LANC,
                L.rowid
  FROM PCLANC L
  JOIN PCMOVCR M ON M.NUMTRANS = L.NUMTRANS
 WHERE M.CODBANCO = 41
	 AND L.NUMNOTA = 202506
 ORDER BY L.NUMNOTA, M.TIPO, M.HISTORICO;
