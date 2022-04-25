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
              AND CODFILIAL = 2
       ) FILIAL_2,
       (
           SELECT DIAFINANCEIRO
             FROM PCDIASUTEIS
            WHERE DATA = P.DATA
              AND CODFILIAL = 5
       ) FILIAL_5,
       (
           SELECT DIAFINANCEIRO
             FROM PCDIASUTEIS
            WHERE DATA = P.DATA
              AND CODFILIAL = 6
       ) FILIAL_6,
       (
           SELECT DIAFINANCEIRO
             FROM PCDIASUTEIS
            WHERE DATA = P.DATA
              AND CODFILIAL = 7
       ) FILIAL_7,
       (
           SELECT DIAFINANCEIRO
             FROM PCDIASUTEIS
            WHERE DATA = P.DATA
              AND CODFILIAL = 8
       ) FILIAL_8,
              (
           SELECT DIAFINANCEIRO
             FROM PCDIASUTEIS
            WHERE DATA = P.DATA
              AND CODFILIAL = 9
       ) FILIAL_9,
              (
           SELECT DIAFINANCEIRO
             FROM PCDIASUTEIS
            WHERE DATA = P.DATA
              AND CODFILIAL = 10
       ) FILIAL_10
  FROM PCDIASUTEIS P
 WHERE P.DATA BETWEEN TRUNC (SYSDATE) AND TRUNC (SYSDATE) + 30
   AND P.CODFILIAL = 1
 ORDER BY P.DATA;