CREATE OR REPLACE VIEW VIEW_JC_BASE_VENDAS_DISTRIBUICAO AS 

  WITH BASE_VENDA AS
   (SELECT L.ANO,
           L.NUM_TRIMESTRE_JC,
           C.CODCLIREDE,
           C.CLIENTEREDE,
           V.CODSUPERVISOR,
           V.SUPERVISOR,
           (CASE
             WHEN V.CODUSUR = 40 THEN
              53
             ELSE
              V.CODUSUR
           END) CODUSUR,
           (CASE
             WHEN V.CODUSUR = 40 THEN
              (SELECT V2.VENDEDOR FROM JEFFERSON.BI_SINC_VENDEDOR V2 WHERE V2.CODUSUR = 53)
             ELSE
              V.VENDEDOR
           END) VENDEDOR,
           (CASE
             WHEN M.MOVIMENTO = 'E' THEN
              M.VLCONTABIL * -1
             ELSE
              M.VLCONTABIL
           END) VLVENDA
      FROM JEFFERSON.BI_SINC_MOV_PRODUTO M
      LEFT JOIN JEFFERSON.BI_SINC_VENDEDOR V ON V.CODUSUR = M.CODUSUR
      LEFT JOIN JEFFERSON.BI_SINC_CLIENTE C ON C.CODCLI = M.CODCLI
      LEFT JOIN JEFFERSON.BI_SINC_CALENDARIO L ON L.DATA = M.DATA
     WHERE M.DATA >= TO_DATE('01/01/2023', 'DD/MM/YYYY')
       AND M.TIPOMOV IN ('SAIDA VENDA', 'ENTRADA DEVOLUCAO')
       AND V.CODGERENTE IN (1, 8, 9, 10)),
  
  VENDAS_AGG AS
   (SELECT ANO,
           NUM_TRIMESTRE_JC,
           CODCLIREDE,
           CLIENTEREDE,
           CODSUPERVISOR,
           SUPERVISOR,
           CODUSUR,
           VENDEDOR,
           SUM(VLVENDA) VENDA_TRI
      FROM BASE_VENDA
     GROUP BY ANO,
              NUM_TRIMESTRE_JC,
              CODCLIREDE,
              CLIENTEREDE,
              CODSUPERVISOR,
              SUPERVISOR,
              CODUSUR,
              VENDEDOR),
  
  VENDA_POR_ANO AS
   (SELECT ANO,
           NUM_TRIMESTRE_JC,
           CODCLIREDE,
           CLIENTEREDE,
           CODSUPERVISOR,
           SUPERVISOR,
           CODUSUR,
           VENDEDOR,
           VENDA_TRI,
           (SUM(VENDA_TRI) OVER(PARTITION BY ANO, CODCLIREDE ORDER BY ANO, CODCLIREDE)) VENDA_ANO
      FROM VENDAS_AGG)
  
  SELECT ANO,
         NUM_TRIMESTRE_JC,
         CODCLIREDE,
         CLIENTEREDE,
         CODSUPERVISOR,
         SUPERVISOR,
         CODUSUR,
         VENDEDOR,
         VENDA_ANO,
         (DENSE_RANK() OVER(PARTITION BY ANO ORDER BY VENDA_ANO DESC)) RANK_ANO,
         VENDA_TRI,
         (DENSE_RANK() OVER(PARTITION BY ANO, CODSUPERVISOR ORDER BY VENDA_ANO DESC)) RANK_GERENTE,
         (DENSE_RANK() OVER(PARTITION BY ANO, VENDEDOR ORDER BY VENDA_ANO DESC)) RANK_VENDEDOR
    FROM VENDA_POR_ANO
