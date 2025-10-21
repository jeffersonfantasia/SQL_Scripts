SELECT P.DATA,
       TO_CHAR (P.DATA, 'DD') DIA,
       DECODE (TO_CHAR (P.DATA, 'D'), 1, 'DOMINGO', 2, 'SEGUNDA',
               3, 'TERÇA', 4, 'QUARTA', 5,
               'QUINTA', 6, 'SEXTA', 7, 'SÁBADO') AS DIASEMANA,
       DIAFINANCEIRO FILIAL_1,
       (
           SELECT DIAFINANCEIRO
             FROM PCDIASUTEIS
            WHERE DATA = P.DATA
              AND CODFILIAL = 11
       ) FILIAL_11,
       (
           SELECT DIAFINANCEIRO
             FROM PCDIASUTEIS
            WHERE DATA = P.DATA
              AND CODFILIAL = 12
       ) FILIAL_12,
       (
           SELECT DIAFINANCEIRO
             FROM PCDIASUTEIS
            WHERE DATA = P.DATA
              AND CODFILIAL = 13
       ) FILIAL_13
  FROM PCDIASUTEIS P
 WHERE P.DATA BETWEEN TRUNC (SYSDATE) AND TRUNC (SYSDATE) + 30
   AND P.CODFILIAL = 1
 ORDER BY P.DATA;
