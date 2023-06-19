--VERIFICAR VENDEDORES DA DEVOLU��O DIFERENTE DO DA VENDA NA PCMOV---
WITH VENDEDOR_DEVOLUCAO AS
 (SELECT DISTINCT M.NUMTRANSENT,
                  M.CODUSUR CODUSUR_DEV,
                  MAX(M.NUMTRANSDEV) OVER(PARTITION BY M.NUMTRANSENT, M.CODUSUR) NUMTRANSVENDA
    FROM PCMOV M
   WHERE NVL(M.NUMTRANSDEV, 0) > 0
     AND M.CODOPER = 'ED'
     AND M.DTCANCEL IS NULL),
VENDEDOR_VENDA AS
 (SELECT V.NUMTRANSENT,
         V.CODUSUR_DEV,
         S.CONDVENDA TIPO_VENDA,
         S.NUMTRANSVENDA,
         S.CODUSUR CODUSUR_VENDA
    FROM PCNFSAID S
    JOIN VENDEDOR_DEVOLUCAO V ON V.NUMTRANSVENDA = S.NUMTRANSVENDA
   WHERE V.CODUSUR_DEV <> S.CODUSUR)
SELECT M.CODFILIAL,
       M.DTMOV,
       M.CODFISCAL,
       M.NUMTRANSENT,
       V.NUMTRANSVENDA,
       V.TIPO_VENDA,
       M.NUMTRANSITEM,
       M.CODPROD,
       M.DESCRICAO,
       M.CODUSUR,
       V.CODUSUR_VENDA
  FROM PCMOV M
  JOIN VENDEDOR_VENDA V ON V.NUMTRANSENT = M.NUMTRANSENT
 WHERE M.CODUSUR <> V.CODUSUR_VENDA;
 
--VERIFICAR VENDEDORES DA DEVOLU��O DIFERENTE DO DA VENDA NA PCNFENT---
  WITH VENDEDOR_DEVOLUCAO AS
   (SELECT DISTINCT M.NUMTRANSENT,
                    E.CODUSURDEVOL CODUSUR_DEV,
                    S.CODUSUR,
                    MAX(M.NUMTRANSDEV) OVER(PARTITION BY M.NUMTRANSENT, M.CODUSUR) NUMTRANSVENDA
      FROM PCMOV M
      JOIN PCNFSAID S ON S.NUMTRANSVENDA = M.NUMTRANSDEV
      JOIN PCNFENT E ON E.NUMTRANSENT = M.NUMTRANSENT
     WHERE NVL(M.NUMTRANSDEV, 0) > 0
       AND M.CODOPER = 'ED'
       AND M.DTCANCEL IS NULL),
  VENDEDOR_VENDA AS
   (SELECT V.NUMTRANSENT,
           V.CODUSUR_DEV,
           S.CONDVENDA TIPO_VENDA,
           S.NUMTRANSVENDA,
           S.CODUSUR CODUSUR_VENDA
      FROM PCNFSAID S
      JOIN VENDEDOR_DEVOLUCAO V ON V.NUMTRANSVENDA = S.NUMTRANSVENDA
     WHERE V.CODUSUR_DEV <> S.CODUSUR)
  SELECT E.CODFILIAL,
         E.DTENT,
         E.TIPODESCARGA,
         E.NUMTRANSENT,
         V.NUMTRANSVENDA,
         V.TIPO_VENDA,
         E.CODUSURDEVOL,
         V.CODUSUR_VENDA
    FROM PCNFENT E
    JOIN VENDEDOR_VENDA V ON V.NUMTRANSENT = E.NUMTRANSENT
   WHERE E.CODUSURDEVOL <> V.CODUSUR_VENDA;
	 
-----------UPDATE PCMOV / MERGE -----------------
MERGE
  INTO PCMOV M
  USING (
  WITH VENDEDOR_DEVOLUCAO AS
   (SELECT DISTINCT M.NUMTRANSENT,
                    M.CODUSUR CODUSUR_DEV,
                    MAX(M.NUMTRANSDEV) OVER(PARTITION BY M.NUMTRANSENT, M.CODUSUR) NUMTRANSVENDA
      FROM PCMOV M
     WHERE NVL(M.NUMTRANSDEV, 0) > 0
       AND M.CODOPER = 'ED'
       AND M.DTCANCEL IS NULL),
  VENDEDOR_VENDA AS
   (SELECT V.NUMTRANSENT,
           V.CODUSUR_DEV,
           S.CONDVENDA TIPO_VENDA,
           S.NUMTRANSVENDA,
           S.CODUSUR CODUSUR_VENDA
      FROM PCNFSAID S
      JOIN VENDEDOR_DEVOLUCAO V ON V.NUMTRANSVENDA = S.NUMTRANSVENDA
     WHERE V.CODUSUR_DEV <> S.CODUSUR)
  SELECT M.NUMTRANSITEM, M.CODUSUR, V.CODUSUR_VENDA
    FROM PCMOV M
    JOIN VENDEDOR_VENDA V ON V.NUMTRANSENT = M.NUMTRANSENT
   WHERE M.CODUSUR <> V.CODUSUR_VENDA
   AND M.DTMOV >= TRUNC(SYSDATE) - 2   ) X ON (M.NUMTRANSITEM = X.NUMTRANSITEM) WHEN MATCHED THEN UPDATE SET M.CODUSUR = X.CODUSUR_VENDA;

------------------UPDATE PCNFENT / MERGE -----------------
MERGE
  INTO PCNFENT E
  USING (
  WITH VENDEDOR_DEVOLUCAO AS
   (SELECT DISTINCT M.NUMTRANSENT,
                    E.CODUSURDEVOL CODUSUR_DEV,
                    S.CODUSUR,
                    MAX(M.NUMTRANSDEV) OVER(PARTITION BY M.NUMTRANSENT, M.CODUSUR) NUMTRANSVENDA
      FROM PCMOV M
      JOIN PCNFSAID S ON S.NUMTRANSVENDA = M.NUMTRANSDEV
      JOIN PCNFENT E ON E.NUMTRANSENT = M.NUMTRANSENT
     WHERE NVL(M.NUMTRANSDEV, 0) > 0
       AND M.CODOPER = 'ED'
       AND M.DTCANCEL IS NULL),
  VENDEDOR_VENDA AS
   (SELECT V.NUMTRANSENT,
           V.CODUSUR_DEV,
           S.CONDVENDA TIPO_VENDA,
           S.NUMTRANSVENDA,
           S.CODUSUR CODUSUR_VENDA
      FROM PCNFSAID S
      JOIN VENDEDOR_DEVOLUCAO V ON V.NUMTRANSVENDA = S.NUMTRANSVENDA
     WHERE V.CODUSUR_DEV <> S.CODUSUR)
  SELECT E.NUMTRANSENT, E.CODUSURDEVOL, V.CODUSUR_VENDA
    FROM PCNFENT E
    JOIN VENDEDOR_VENDA V ON V.NUMTRANSENT = E.NUMTRANSENT
   WHERE E.CODUSURDEVOL <> V.CODUSUR_VENDA) X ON (E.NUMTRANSENT = X.NUMTRANSENT) WHEN MATCHED THEN UPDATE SET E.CODUSURDEVOL = X.CODUSUR_VENDA;

