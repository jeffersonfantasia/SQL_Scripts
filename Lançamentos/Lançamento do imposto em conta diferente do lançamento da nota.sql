WITH LANC_IMPOSTOS AS
 (SELECT L.RECNUMPRINC, L.RECNUM AS RECNUM_IMPOSTO, L.CODCONTA
    FROM PCLANC L
   WHERE L.DTCANCEL IS NULL --NAO CONSIDERAR LANCAMENTOS CANCELADOS
     AND L.DTESTORNOBAIXA IS NULL --NAO CONSIDERAR LANCAMENTOS ESTORNADOS
     AND L.DTDESD IS NULL --NAO CONSIDERAR OS LANÇAMENTOS GERADOS DE UM DESDOBRAMENTO
     AND L.VALOR > 0 --PARA DESCONSIDERAR O LANCAMENTO NEGATIVO GERADO PELO DESDOBRE
     AND L.NUMNOTA <> 0
     AND L.HISTORICO2 IN
         (TRIM('ISS'), TRIM('CSRF'), TRIM('IRRF'), TRIM('INSS')) --SOMENTE LANÇAMENTOS DE IMPOSTOS
  ),
LANC_PRINCIPAIS AS
 (SELECT I.RECNUM_IMPOSTO, L.RECNUM
    FROM PCLANC L
   INNER JOIN LANC_IMPOSTOS I
      ON L.RECNUM = I.RECNUMPRINC
    LEFT JOIN PCCONTA C
      ON L.CODCONTA = C.CODCONTA
   WHERE L.CODCONTA <> I.CODCONTA
     AND C.GRUPOCONTA NOT IN (510, 515))
SELECT L.CODFILIAL, L.RECNUM, L.DTLANC, L.CODCONTA, L.CODFORNEC, F.FORNECEDOR, L.NUMNOTA, L.HISTORICO2
  FROM PCLANC L
 LEFT JOIN LANC_PRINCIPAIS P
    ON L.RECNUM = P.RECNUM
 LEFT JOIN LANC_PRINCIPAIS V
    ON L.RECNUM = V.RECNUM_IMPOSTO 
 LEFT JOIN PCFORNEC F
    ON L.CODFORNEC = F.CODFORNEC     
 WHERE (L.RECNUM = P.RECNUM OR L.RECNUM = V.RECNUM_IMPOSTO)
 ORDER BY L.RECNUM;
WITH LANC_IMPOSTOS AS
 (SELECT L.RECNUMPRINC, L.RECNUM AS RECNUM_IMPOSTO, L.CODCONTA
    FROM PCLANC L
   WHERE L.DTCANCEL IS NULL --NAO CONSIDERAR LANCAMENTOS CANCELADOS
     AND L.DTESTORNOBAIXA IS NULL --NAO CONSIDERAR LANCAMENTOS ESTORNADOS
     AND L.DTDESD IS NULL --NAO CONSIDERAR OS LANÇAMENTOS GERADOS DE UM DESDOBRAMENTO
     AND L.VALOR > 0 --PARA DESCONSIDERAR O LANCAMENTO NEGATIVO GERADO PELO DESDOBRE
     AND L.NUMNOTA <> 0
     AND L.HISTORICO2 IN
         (TRIM('ISS'), TRIM('CSRF'), TRIM('IRRF'), TRIM('INSS')) --SOMENTE LANÇAMENTOS DE IMPOSTOS
  ),
LANC_PRINCIPAIS AS
 (SELECT I.RECNUM_IMPOSTO, L.RECNUM
    FROM PCLANC L
   INNER JOIN LANC_IMPOSTOS I
      ON L.RECNUM = I.RECNUMPRINC
    LEFT JOIN PCCONTA C
      ON L.CODCONTA = C.CODCONTA
   WHERE L.CODCONTA <> I.CODCONTA
     AND C.GRUPOCONTA NOT IN (510, 515))
SELECT L.CODFILIAL, L.RECNUM, L.DTLANC, L.CODCONTA, L.CODFORNEC, F.FORNECEDOR, L.NUMNOTA, L.HISTORICO2
  FROM PCLANC L
 LEFT JOIN LANC_PRINCIPAIS P
    ON L.RECNUM = P.RECNUM
 LEFT JOIN LANC_PRINCIPAIS V
    ON L.RECNUM = V.RECNUM_IMPOSTO 
 LEFT JOIN PCFORNEC F
    ON L.CODFORNEC = F.CODFORNEC     
 WHERE (L.RECNUM = P.RECNUM OR L.RECNUM = V.RECNUM_IMPOSTO)
 ORDER BY L.RECNUM;
