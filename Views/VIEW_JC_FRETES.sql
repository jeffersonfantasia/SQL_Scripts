-- =====================================================================
-- PROPOSTA de correcao — JEFFERSON.VIEW_JC_FRETES
-- Escrita em 2026-09-10. NAO APLICADA. Ver views/README.md antes de rodar.
--
-- Mudancas:
--   1. O FULL JOIN casa por (NUMTRANSACAO, tipo de transacao), nao so pelo
--      numero. E o defeito real: em todo o historico, 26 linhas de CT-e de
--      ENTRADA colados em nota de VENDA por colisao de numeracao. Na janela
--      atual (2026) sao zero — por sorte, nao por desenho.
--   2. 'CTE COMPLEMENTAR' e decidido por F.TIPO = 'CT', nao por CODCLI = 10.
--   3. A data deixa de ser fixa ('01/01/2026'). Passa a ser 1 de janeiro do
--      ano anterior, que anda sozinha: hoje cobre 2025 e 2026; em 2027 cobre
--      2026 e 2027. Ver README para a alternativa sem filtro nenhum.
--   4. Coluna nova TIPOTRANS na saida, para quem juntar esta view com outra.
--      Vai por ULTIMO na projecao: as 13 colunas atuais mantem posicao, entao
--      SELECT * e importacao posicional continuam lendo o mesmo (Orion r1, A).
--   6. CODUSUR de linha sem nota (CT-e avulso, nota cancelada) passa de 99
--      para 999. Medido em 2026-09-10: 99 E UM VENDEDOR REAL ('OUTROS LOJA'
--      em BI_SINC_VENDEDOR; 'DAIANE ALVES DA SILVA' em PCUSUARI). Hoje 39
--      avulsos e 165 canceladas do ano sao atribuidos a ela. 999 nao existe
--      em nenhum dos dois cadastros e e o placeholder que a planilha
--      analise-de-fretes.xlsx ja insere ('CTE COMPLEMENTAR'). Unica mudanca
--      desta proposta que altera valor em linha existente, alem do CODCLI.
--   5. O DISTINCT da CTE FRETE passa a incluir TIPO. Efeito: duas linhas iguais
--      nos campos antigos mas com TIPO 'E' e 'S' deixam de colapsar numa so.
--      E o comportamento correto (sao transacoes diferentes); medido em
--      2026-09-10 — ver README, "Evidencia".
-- Depende das duas outras propostas (TIPOTRANS em MOVNOTAS, TIPO na CTE).
-- Aplicar nesta ordem: MOVNOTAS_FRETE, CTES, FRETES.
-- =====================================================================
CREATE OR REPLACE VIEW JEFFERSON.VIEW_JC_FRETES AS
WITH FRETE AS
   (SELECT DISTINCT DATA,
                    CODFILIAL,
                    TRANSPORTADORA,
                    NUMTRANSACAO,
                    CODCLI,
                    TIPO,
                    QTCTESNOTA,
                    VLTOTALFRETE
      FROM VIEW_JC_CTES V)

  SELECT COALESCE(M.CODFILIAL, F.CODFILIAL) CODFILIAL,
         COALESCE(M.DATA, F.DATA) DATA,
         COALESCE(M.NUMTRANSACAO, F.NUMTRANSACAO) NUMTRANSACAO,
         COALESCE(M.CODCLI, F.CODCLI) CODCLI,
         NVL(M.CODUSUR, 999) CODUSUR,
         NVL(M.TIPOFAT, 0) TIPOFAT,
         NVL(M.TIPOPESO, 0) TIPOPESO,
         CASE
           WHEN F.TIPO = 'CT' THEN
            'CTE COMPLEMENTAR'
           WHEN M.VLTOTAL IS NULL THEN
            'NOTAS CANCELADAS'
           ELSE
            M.TIPO
         END TIPO,
         NVL(M.PESO, 0) PESO,
         COALESCE(F.TRANSPORTADORA, M.TRANSPORTADORA, 'SEM TRANSPORTADORA') TRANSPORTADORA,
         NVL(F.QTCTESNOTA, 0) QTCTES,
         NVL(M.VLTOTAL, 0) VLNOTA,
         NVL(F.VLTOTALFRETE, 0) VLFRETE,
         COALESCE(M.TIPOTRANS, F.TIPO) TIPOTRANS
    FROM VIEW_JC_MOVNOTAS_FRETE M
    FULL JOIN FRETE F ON F.NUMTRANSACAO = M.NUMTRANSACAO
                     AND F.TIPO = M.TIPOTRANS
   WHERE COALESCE(M.DATA, F.DATA) >= ADD_MONTHS(TRUNC(SYSDATE, 'YYYY'), -12)
;
