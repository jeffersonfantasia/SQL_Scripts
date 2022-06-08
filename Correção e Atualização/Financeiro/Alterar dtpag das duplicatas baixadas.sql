/*     TO_NUMBER (TO_CHAR (M.DTCOMPENSACAO, 'YYYY') || TO_CHAR (M.DTCOMPENSACAO, 'MM')) AS MES_DTCOMPENSACAO,
       TO_NUMBER (TO_CHAR (P.DTPAG, 'YYYY') || TO_CHAR (P.DTPAG, 'MM')) AS MES_DTPAG*/

--CONTA A RECEBER
SELECT --P.ROWID,
       P.CODFILIAL,
       P.NUMTRANS,
       M.DTCOMPENSACAO,
       P.DTPAG,
       P.DTBAIXA,
       P.DTVENC,
       P.DTEMISSAO,
       P.CODCLI,
       C.CLIENTE,
       M.CODBANCO, 
       B.NOME AS BANCO,
       P.VALOR,
       P.VPAGO
  FROM PCPREST P
  INNER JOIN PCMOVCR M ON P.NUMTRANS = M.NUMTRANS
  LEFT JOIN PCBANCO B ON M.CODBANCO = B.CODBANCO
  LEFT JOIN PCCLIENT C ON P.CODCLI = C.CODCLI
 WHERE TO_NUMBER (TO_CHAR (M.DTCOMPENSACAO, 'YYYY') || TO_CHAR (M.DTCOMPENSACAO, 'MM')) <> TO_NUMBER (TO_CHAR (P.DTPAG, 'YYYY') || TO_CHAR (P.DTPAG, 'MM'))
   AND M.CODBANCO IN (1,2,5,13,16,27,29,31,33,42,44,46,48,55)
   AND P.CODCLI NOT IN (25053)
   AND M.CODCOB = 'D'
   AND TO_NUMBER (TO_CHAR (P.DTPAG, 'YYYY') || TO_CHAR (P.DTPAG, 'MM')) > 202204
   ORDER BY P.DTPAG DESC
   ;

/*     TO_NUMBER (TO_CHAR (M.DTCOMPENSACAO, 'YYYY') || TO_CHAR (M.DTCOMPENSACAO, 'MM')) AS MES_DTCOMPENSACAO,
       TO_NUMBER (TO_CHAR (L.DTPAGTO, 'YYYY') || TO_CHAR (L.DTPAGTO, 'MM')) AS MES_DTPAGTO*/
       
   --CONTAS A PAGAR
   SELECT --L.ROWID,
       L.CODFILIAL,
       L.NUMTRANS,
       M.DTCOMPENSACAO,
       L.DTPAGTO,
       L.CODFORNEC,
       M.CODBANCO, 
       B.NOME AS BANCO, 
       L.CODCONTA,
       L.VALOR,
       L.VPAGO
  FROM PCLANC L
  INNER JOIN PCMOVCR M ON L.NUMTRANS = M.NUMTRANS
  LEFT JOIN PCBANCO B ON M.CODBANCO = B.CODBANCO
 WHERE TO_NUMBER (TO_CHAR (M.DTCOMPENSACAO, 'YYYY') || TO_CHAR (M.DTCOMPENSACAO, 'MM')) <> TO_NUMBER (TO_CHAR (L.DTPAGTO, 'YYYY') || TO_CHAR (L.DTPAGTO, 'MM'))
   AND M.CODBANCO IN (1,2,5,13,16,27,29,31,33,42,44,46,48,55)
   AND M.CODCOB = 'D'
   AND L.CODCONTA NOT IN (610101, 610102, 620103, 620108, 650101, 680101)
   AND TO_NUMBER (TO_CHAR (L.DTPAGTO, 'YYYY') || TO_CHAR (L.DTPAGTO, 'MM')) > 202109
   AND L.DTESTORNOBAIXA IS NULL
   --AND L.NUMTRANS = 266138
   ORDER BY L.DTPAGTO DESC
   ;