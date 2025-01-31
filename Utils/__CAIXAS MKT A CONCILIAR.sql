--CAIXAS MKT A CONCILIAR
SELECT DISTINCT M.DATA,
                M.CODBANCO,
                B.NOME BANCO,
                M.DTCOMPENSACAO,
                M.TIPO,
                SUM(M.VALOR) OVER (PARTITION BY M.CODBANCO, M.DATA, M.TIPO) VALOR
  FROM PCMOVCR M
  JOIN PCBANCO B ON B.CODBANCO = M.CODBANCO
 WHERE (B.CODBACEN = 'MARKETPLACE' OR (B.CODBANCO = 12 AND M.TIPO = 'C'))
   AND M.DTCONCIL IS NULL
   AND M.CODCOB = 'D'
 ORDER BY M.DATA DESC;

--VERIFICAR DATA DE PAGAMENTO DO TITULO DIFERENTE DA DATA COMPENSAÇÃO
WITH MOVIMENTACAO AS
 (SELECT M.CODROTINALANC,
         M.NUMTRANS,
         M.DTCOMPENSACAO
    FROM PCMOVCR M
   WHERE M.DATA >= TRUNC(SYSDATE) - &DIAS
     AND M.CODBANCO = &CODBANCO)
SELECT P.CODCLI,
       P.NUMTRANSVENDA,
       P.DUPLIC,
       P.PREST,
       P.CODCOB,
       P.DTPAG,
       P.VPAGO,
       P.VALORDESC,
       P.VALOR,
       M.DTCOMPENSACAO,
       M.CODROTINALANC
  FROM PCPREST P
  JOIN MOVIMENTACAO M ON P.NUMTRANS = M.NUMTRANS
 WHERE M.CODROTINALANC IN (1209, 1207, 9876, 1503, 6201)
   AND P.DTPAG <> M.DTCOMPENSACAO;

--UPDATE DTPAG TITULO
MERGE INTO PCPREST P
USING (
  WITH MOVIMENTACAO AS
   (SELECT M.CODROTINALANC,
           M.NUMTRANS,
           M.DTCOMPENSACAO
      FROM PCMOVCR M
     WHERE M.DATA >= TRUNC(SYSDATE) - &DIAS
       AND M.CODBANCO = &CODBANCO)
  SELECT P.NUMTRANSVENDA,
         P.PREST,
         P.DTPAG,
         M.DTCOMPENSACAO
    FROM PCPREST P
    JOIN MOVIMENTACAO M ON P.NUMTRANS = M.NUMTRANS
   WHERE M.CODROTINALANC IN (1209, 1207, 9876, 1503, 6201)
     AND P.DTPAG <> M.DTCOMPENSACAO) X ON (X.NUMTRANSVENDA = P.NUMTRANSVENDA AND X.PREST = P.PREST) WHEN MATCHED THEN
    UPDATE SET P.DTPAG = X.DTCOMPENSACAO;

--VERIFICAR DATA DE PAGAMENTO DO LANÇAMENTO DIFERENTE DA DATA COMPENSAÇÃO
WITH MOVIMENTACAO AS
 (SELECT M.CODROTINALANC,
         M.NUMTRANS,
         M.DTCOMPENSACAO
    FROM PCMOVCR M
   WHERE M.ESTORNO = 'N'
     AND M.DATA >= TRUNC(SYSDATE) - &DIAS
     AND M.CODBANCO = &CODBANCO)
SELECT L.CODFORNEC,
       L.HISTORICO,
       L.CODCONTA,
       L.DTPAGTO,
       M.DTCOMPENSACAO,
       M.CODROTINALANC
  FROM PCLANC L
  JOIN MOVIMENTACAO M ON L.NUMTRANS = M.NUMTRANS
 WHERE M.CODROTINALANC IN (631)
   AND L.DTPAGTO <> M.DTCOMPENSACAO;

--UPDATE DTPAGTO DA PCLANC
MERGE INTO PCLANC L
USING (
  WITH MOVIMENTACAO AS
   (SELECT M.CODROTINALANC,
           M.NUMTRANS,
           M.DTCOMPENSACAO
      FROM PCMOVCR M
     WHERE M.ESTORNO = 'N'
       AND M.DATA >= TRUNC(SYSDATE) - &DIAS
       AND M.CODBANCO = &CODBANCO)
  SELECT L.RECNUM,
         L.DTPAGTO,
         M.DTCOMPENSACAO
    FROM PCLANC L
    JOIN MOVIMENTACAO M ON L.NUMTRANS = M.NUMTRANS
   WHERE M.CODROTINALANC IN (631)
     AND L.DTPAGTO <> M.DTCOMPENSACAO) X ON (X.RECNUM = L.RECNUM) WHEN MATCHED THEN
    UPDATE SET L.DTPAGTO = X.DTCOMPENSACAO;
