Romaneio expedição ecommerce

SELECT *
  FROM (SELECT F.CODIGO || ' - ' || F.RAZAOSOCIAL AS FILIAL,
               C.CODFORNECFRETE AS CODTRANSP,
               FO.FORNECEDOR AS DESCRICAO,
               R.NOME FUNCIONARIO,
               TO_DATE(TO_CHAR(C.DTFAT, 'DD/MM/YYYY') || ' ' || C.HORAFAT || ':' ||
                       C.MINUTOFAT || ':00',
                       'DD/MM/YYYY HH24:MI:SS') DTHORAFAT,
               C.NUMPEDRCA,
               C.NUMNOTA,
               C.NUMVOLUME VOLPEDIDO,
               C.CODCLI,
               CLI.CLIENTE
          FROM PCPEDC C, PCCLIENT CLI, PCFILIAL F, PCFORNEC FO, PCEMPR R
         WHERE C.CODCLI = CLI.CODCLI
           AND C.CODFILIAL = F.CODIGO
           AND FO.CODFORNEC = C.CODFORNECFRETE
           AND C.CODSUPERVISOR IN (7, 8)
           AND C.CODFILIAL = '7'
           AND R.MATRICULA = C.CODFUNCCONF
        -- AND C.NUMNOTA BETWEEN:NFINICIAL and :NFFINAL     
         GROUP BY F.CODIGO || ' - ' || F.RAZAOSOCIAL,
                  C.CODFORNECFRETE,
                  FO.FORNECEDOR,
                  R.NOME,
                  C.NUMPEDRCA,
                  C.NUMNOTA,
                  C.NUMVOLUME,
                  C.CODCLI,
                  CLI.CLIENTE,
                  C.DTFAT,
                  C.HORAFAT,
                  C.MINUTOFAT)
 WHERE DTHORAFAT BETWEEN
       TO_DATE('26/01/2019 09:00:00', 'DD/MM/YYYY HH24:MI:SS') AND
       TO_DATE('26/04/2019 17:00:00', 'DD/MM/YYYY HH24:MI:SS')
   AND CODTRANSP IN (9518)
 ORDER BY DTHORAFAT
Romaneio expedição ecommerce

SELECT *
  FROM (SELECT F.CODIGO || ' - ' || F.RAZAOSOCIAL AS FILIAL,
               C.CODFORNECFRETE AS CODTRANSP,
               FO.FORNECEDOR AS DESCRICAO,
               R.NOME FUNCIONARIO,
               TO_DATE(TO_CHAR(C.DTFAT, 'DD/MM/YYYY') || ' ' || C.HORAFAT || ':' ||
                       C.MINUTOFAT || ':00',
                       'DD/MM/YYYY HH24:MI:SS') DTHORAFAT,
               C.NUMPEDRCA,
               C.NUMNOTA,
               C.NUMVOLUME VOLPEDIDO,
               C.CODCLI,
               CLI.CLIENTE
          FROM PCPEDC C, PCCLIENT CLI, PCFILIAL F, PCFORNEC FO, PCEMPR R
         WHERE C.CODCLI = CLI.CODCLI
           AND C.CODFILIAL = F.CODIGO
           AND FO.CODFORNEC = C.CODFORNECFRETE
           AND C.CODSUPERVISOR IN (7, 8)
           AND C.CODFILIAL = '7'
           AND R.MATRICULA = C.CODFUNCCONF
        -- AND C.NUMNOTA BETWEEN:NFINICIAL and :NFFINAL     
         GROUP BY F.CODIGO || ' - ' || F.RAZAOSOCIAL,
                  C.CODFORNECFRETE,
                  FO.FORNECEDOR,
                  R.NOME,
                  C.NUMPEDRCA,
                  C.NUMNOTA,
                  C.NUMVOLUME,
                  C.CODCLI,
                  CLI.CLIENTE,
                  C.DTFAT,
                  C.HORAFAT,
                  C.MINUTOFAT)
 WHERE DTHORAFAT BETWEEN
       TO_DATE('26/01/2019 09:00:00', 'DD/MM/YYYY HH24:MI:SS') AND
       TO_DATE('26/04/2019 17:00:00', 'DD/MM/YYYY HH24:MI:SS')
   AND CODTRANSP IN (9518)
 ORDER BY DTHORAFAT;