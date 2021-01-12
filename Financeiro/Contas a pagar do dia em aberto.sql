SELECT L.CODFILIAL,
       L.RECNUM,
       L.CODCONTA,
       T.CONTA,
       L.TIPOPARCEIRO AS TIPO,
       L.CODFORNEC,
       (
           CASE TIPOPARCEIRO
               WHEN 'C'   THEN (
                   SELECT C.CLIENTE
                     FROM PCCLIENT C
                    WHERE C.CODCLI = L.CODFORNEC
               )
               WHEN 'F'   THEN (
                   SELECT F.FORNECEDOR
                     FROM PCFORNEC F
                    WHERE F.CODFORNEC = L.CODFORNEC
               )
               ELSE NULL
           END
       ) AS CLIENTE_FORNECEDOR,
       L.NUMNOTA,
       L.VALOR,
       L.DTVENC,
       L.NUMBORDERO,
       L.DTBORDER
  FROM PCLANC L
  LEFT JOIN PCCONTA T ON L.CODCONTA = T.CODCONTA
 WHERE L.DTCANCEL IS NULL
   AND L.DTPAGTO IS NULL
   AND L.TIPOLANC = 'C'
   AND L.DTVENC <= TRUNC (SYSDATE)
   AND L.CODROTINACAD NOT IN (
    'Integradora.Servico.exe'
)
 ORDER BY L.CODFILIAL,
          L.CODCONTA DESC;
/