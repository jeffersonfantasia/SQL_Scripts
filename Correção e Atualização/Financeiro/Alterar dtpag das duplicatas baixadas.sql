SELECT ROWID,
       NUMTRANS,
       P.DTPAG,
       P.DTBAIXA,
       P.DTVENC,
       P.DTEMISSAO,
       P.CODCLI,
       P.*
  FROM PCPREST P
 WHERE CODFILIAL = 6
   AND NUMTRANS IN (86705)
   AND CODCLI IN (8781, 8798, 9617, 8784, 6140, 9597)
   AND DTPAG = TO_DATE('01/01/2019', 'DD/MM/YYYY');