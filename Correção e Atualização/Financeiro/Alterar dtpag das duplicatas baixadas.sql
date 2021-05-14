--CONTA A RECEBER
SELECT P.ROWID,
       P.NUMTRANS,
       M.DTCOMPENSACAO,
       P.DTPAG,
       P.DTBAIXA,
       P.DTVENC,
       P.DTEMISSAO,
       P.CODCLI,
       P.*
  FROM PCPREST P
  INNER JOIN PCMOVCR M ON P.NUMTRANS = M.NUMTRANS
 WHERE P.CODFILIAL IN (1, 2, 7)
   AND M.DTCOMPENSACAO BETWEEN TO_DATE('01/04/2021', 'DD/MM/YYYY') AND TO_DATE('30/04/2021', 'DD/MM/YYYY')
   AND M.CODBANCO = 48
   ORDER BY P.DTPAG DESC
   ;
   
   --CONTAS A PAGAR
   SELECT L.ROWID,
       L.NUMTRANS,
       L.DTESTORNOBAIXA,
       M.DTCOMPENSACAO,
       L.DTPAGTO,
       L.CODFORNEC,
       L.*
  FROM PCLANC L
  INNER JOIN PCMOVCR M ON L.NUMTRANS = M.NUMTRANS
 WHERE L.CODFILIAL IN (1, 2, 7)
   AND M.DTCOMPENSACAO BETWEEN TO_DATE('01/04/2021', 'DD/MM/YYYY') AND TO_DATE('30/04/2021', 'DD/MM/YYYY')
   AND M.CODBANCO = 48
   ORDER BY L.DTPAGTO DESC
   ;