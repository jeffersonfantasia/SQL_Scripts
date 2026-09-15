-- =====================================================================
-- PROPOSTA de correcao — JEFFERSON.VIEW_JC_CTES
-- Escrita em 2026-09-10. NAO APLICADA. Ver views/README.md antes de rodar.
--
-- Mudancas (a unica com efeito no resultado e o CODCLI do avulso — ver README):
--   1. CODCLI do CT-e avulso passa de 10 (numero magico) para NULL, e os 4
--      CASE passam a testar TIPO = 'CT'. Decisao do Jeff em 2026-09-10: o
--      banco deixa de inventar um cliente. O unico consumidor que dependia
--      do 10 e a planilha analise-de-fretes.xlsx (dimensao Clientes com um
--      cliente 10 'CTE COMPLEMENTAR' inserido a mao); ela foi ajustada no
--      mesmo dia para preencher o 10 por conta propria, dentro do Power
--      Query — o placeholder mora onde e definido. Aplicar a view SEM a
--      planilha ajustada joga o frete avulso em '(em branco)'.
--   2. Toda janela OVER(PARTITION BY NUMTRANSACAO) passa a particionar por
--      (TIPO, NUMTRANSACAO). NUMTRANSVENDA e NUMTRANSENT colidem em 60.062
--      numeros; hoje nenhum CT-e cai nos dois lados, mas a particao antiga
--      somaria o frete de uma venda com o de uma devolucao se caisse.
-- O rateio (VLCTE) nao muda: medido por NUMTRANSENT, ele ja gera exatamente
-- as linhas da ponte em 20.313 de 20.313 CT-e desde 2025.
-- =====================================================================
CREATE OR REPLACE VIEW JEFFERSON.VIEW_JC_CTES AS
WITH FRETES AS
 (SELECT E.CODFILIAL,
         E.DTEMISSAO DTCTE,
         (CASE
           WHEN S.NUMTRANSVENDA IS NOT NULL THEN
            'S'
           WHEN E2.NUMTRANSENT IS NOT NULL THEN
            'E'
           ELSE
            'CT'
         END) TIPO,
         E.NUMNOTA NUMNOTA_CTE,
         E.CODFORNEC,
         T.FORNECEDOR TRANSPORTADORA,
         COALESCE(S.NUMTRANSVENDA, E2.NUMTRANSENT, 0) NUMTRANSACAO,
         COALESCE(S.CODCLI, E2.CODFORNEC) CODCLI,
         ROUND((E.VLTOTAL / COUNT(E.NUMTRANSENT) OVER(PARTITION BY E.NUMTRANSENT)), 2) VLCTE
    FROM PCNFENT E
    JOIN PCFORNEC T ON T.CODFORNEC = E.CODFORNEC
    LEFT JOIN PCCONHECIMENTOFRETEI F ON F.NUMTRANSCONHEC = E.NUMTRANSENT
    LEFT JOIN PCNFSAID S ON S.CHAVENFE = F.CHAVENFE
    LEFT JOIN PCNFENT E2 ON E2.CHAVENFE = F.CHAVENFE
   WHERE E.ESPECIE = 'CT'
     AND E.DTCANCEL IS NULL)

SELECT CODFILIAL,
       CASE
         WHEN TIPO = 'CT' THEN
          DTCTE
         ELSE
          MIN(DTCTE) OVER(PARTITION BY TIPO, NUMTRANSACAO)
       END DATA,
       TIPO,
       NUMNOTA_CTE,
       CODFORNEC,
       CASE
         WHEN TIPO = 'CT' THEN
          TRANSPORTADORA
         ELSE
          MIN(TRANSPORTADORA) OVER(PARTITION BY TIPO, NUMTRANSACAO)
       END TRANSPORTADORA,
       NUMTRANSACAO,
       CODCLI,
       VLCTE,
       CASE
         WHEN TIPO = 'CT' THEN
          1
         ELSE
          COUNT(NUMTRANSACAO) OVER(PARTITION BY TIPO, NUMTRANSACAO)
       END QTCTESNOTA,
       CASE
         WHEN TIPO = 'CT' THEN
          VLCTE
         ELSE
          SUM(VLCTE) OVER(PARTITION BY TIPO, NUMTRANSACAO)
       END VLTOTALFRETE
  FROM FRETES
;
