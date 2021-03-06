/*ANALISE PEDIDOS DISTRIBUIÇÃO*/
SELECT S.CODGERENTE,
       G.NOMEGERENTE,
       COUNT (C.NUMPED) PED_FATURADO_HOJE,
       SUM (VLTOTAL) VALOR_FATURADO_HOJE,
       (
           SELECT COUNT (PCPEDC.NUMPED)
             FROM PCPEDC,
                  PCSUPERV,
                  PCGERENTE
            WHERE PCPEDC.CODSUPERVISOR = PCSUPERV.CODSUPERVISOR
              AND PCSUPERV.CODGERENTE = PCGERENTE.CODGERENTE
              AND PCGERENTE.CODGERENTE = S.CODGERENTE
              AND PCGERENTE.CODGERENTE IN (
               1, 8, 9, 10
           )
              AND PCPEDC.POSICAO IN (
               'B', 'P'
           )
       ) PED_PENDENTES,
       (
           SELECT SUM (PCPEDC.VLTOTAL)
             FROM PCPEDC,
                  PCSUPERV,
                  PCGERENTE
            WHERE PCPEDC.CODSUPERVISOR = PCSUPERV.CODSUPERVISOR
              AND PCSUPERV.CODGERENTE = PCGERENTE.CODGERENTE
              AND PCGERENTE.CODGERENTE = S.CODGERENTE
              AND PCGERENTE.CODGERENTE IN (
               1, 8, 9, 10
           )
              AND PCPEDC.POSICAO IN (
               'B', 'P'
           )
       ) VALOR_PENDENTE,
       (
           SELECT COUNT (PCPEDC.NUMPED)
             FROM PCPEDC,
                  PCSUPERV,
                  PCGERENTE
            WHERE PCPEDC.CODSUPERVISOR = PCSUPERV.CODSUPERVISOR
              AND PCSUPERV.CODGERENTE = PCGERENTE.CODGERENTE
              AND PCGERENTE.CODGERENTE = S.CODGERENTE
              AND PCGERENTE.CODGERENTE IN (
               1, 8, 9, 10
           )
              AND PCPEDC.POSICAO IN (
               'M'
           )
       ) PED_MONTADO,
       (
           SELECT NVL (SUM (PCPEDC.VLTOTAL), 0)
             FROM PCPEDC,
                  PCSUPERV,
                  PCGERENTE
            WHERE PCPEDC.CODSUPERVISOR = PCSUPERV.CODSUPERVISOR
              AND PCSUPERV.CODGERENTE = PCGERENTE.CODGERENTE
              AND PCGERENTE.CODGERENTE = S.CODGERENTE
              AND PCGERENTE.CODGERENTE IN (
               1, 8, 9, 10
           )
              AND PCPEDC.POSICAO IN (
               'M'
           )
       ) VALOR_MONTADO,
       (
           SELECT COUNT (PCPEDC.NUMPED)
             FROM PCPEDC,
                  PCSUPERV,
                  PCGERENTE
            WHERE PCPEDC.CODSUPERVISOR = PCSUPERV.CODSUPERVISOR
              AND PCSUPERV.CODGERENTE = PCGERENTE.CODGERENTE
              AND PCGERENTE.CODGERENTE = S.CODGERENTE
              AND PCGERENTE.CODGERENTE IN (
               1, 8, 9, 10
           )
              AND PCPEDC.POSICAO IN (
               'L'
           )
       ) PED_LIBERADO,
       (
           SELECT SUM (PCPEDC.VLTOTAL)
             FROM PCPEDC,
                  PCSUPERV,
                  PCGERENTE
            WHERE PCPEDC.CODSUPERVISOR = PCSUPERV.CODSUPERVISOR
              AND PCSUPERV.CODGERENTE = PCGERENTE.CODGERENTE
              AND PCGERENTE.CODGERENTE = S.CODGERENTE
              AND PCGERENTE.CODGERENTE IN (
               1, 8, 9, 10
           )
              AND PCPEDC.POSICAO IN (
               'L'
           )
       ) VALOR_LIBERADO
  FROM PCPEDC C,
       PCSUPERV S,
       PCGERENTE G
 WHERE C.CODSUPERVISOR = S.CODSUPERVISOR
   AND G.CODGERENTE = S.CODGERENTE
   AND S.CODGERENTE IN (
    1, 8, 9, 10
)
   AND C.POSICAO = 'F'
   AND DTFAT = TRUNC (SYSDATE)
 GROUP BY S.CODGERENTE,
          G.NOMEGERENTE,
          C.POSICAO;