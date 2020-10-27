CREATE OR REPLACE VIEW VIEW_JC_LANC_INCL_DUPLIC AS
SELECT L.CODFILIAL,
       L.RECNUM,
       L.VPAGO,
       (CASE
         WHEN L.VPAGO < 0 THEN
          NVL(L.VPAGO, 0) * -1
         ELSE
          L.VPAGO
       END) AS VALOR, --TRANSFORMAR OS VALORES NEGATIVOS PARA ARQUIVO CONTABILIDADE
       C.CODCONTAB,
       L.DTPAGTO AS DATA,
       ('INCL.MANUAL DUP. NF ' || L.NUMNOTA || '-' || L.DUPLIC || ' - ' ||
       C.CLIENTE) AS HISTORICO
  FROM PCLANC L
  LEFT JOIN PCCLIENT C
    ON L.CODFORNEC = C.CODCLI
 WHERE L.CODROTINABAIXA IN (1206) --ROTINA QUE FAZ A INCLUSAO MANUAL DE DUPLICATAS
;