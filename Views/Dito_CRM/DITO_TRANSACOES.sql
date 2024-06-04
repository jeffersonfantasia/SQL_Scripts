CREATE OR REPLACE VIEW BROKER.DITO_TRANSACOES AS
/**********************************************************
Tratamento dos campos:
1. Quando for devolu��o devemos trazer o valor total negativo
2. Se a movimenta��o pertencer alguma loja dever� ser considerada OFFLINE
   caso contr�rio ONLINE
3. Se a cobran�a possui desdobramento, trazer a descric�o da cobran�a desdobrada
   caso contario, trazer a descricao da propria cobran�a
**********************************************************/

WITH BASE_MOV_PROD_CONSOLIDADA AS
 (SELECT M.ID_TRANSACAO,
         M.OPERACAO_PRODUTO,
         MAX(M.CODIGO_CLIENTE) CODIGO_CLIENTE,
         MAX(M.CPF_CNPJ) CPF_CNPJ,
         MAX(M.DATA_COMPRA) DATA_COMPRA,
         MAX(M.ID_LOJA) ID_LOJA,
         MAX(M.CODIGO_VENDEDOR) CODIGO_VENDEDOR,
         MAX(M.NOME_VENDEDOR) NOME_VENDEDOR,
         (CASE
           WHEN M.OPERACAO_PRODUTO = 'Devolucao' THEN
            SUM(M.PRECO_PRODUTO) * -1
           ELSE
            SUM(M.PRECO_PRODUTO)
         END) TOTAL,
         COUNT(M.ID_PRODUTO) QUANTIDADE_PRODUTO,
         SUM(M.TOTAL_DESCONTO) TOTAL_DESCONTO,
         SUM(M.TOTAL_FRETE) TOTAL_FRETE
    FROM BROKER.DITO_BASE_MOV_PRODUTO M
   GROUP BY M.ID_TRANSACAO,
            M.OPERACAO_PRODUTO),

FILIAIS AS
 (SELECT F.CODIGO,
         F.FANTASIA
    FROM PCFILIAL F),

COBRANCAS AS
 (SELECT B.CODCOB,
         NVL(B.CODCOBCC, B.CODCOB) CODPAG
    FROM PCCOB B),

PAGAMENTO AS
 (SELECT C.CODCOB,
         C.CODPAG,
         INITCAP(B.COBRANCA) METODO_PAGAMENTO
    FROM COBRANCAS C
    JOIN PCCOB B ON B.CODCOB = C.CODPAG)

SELECT M.CODIGO_CLIENTE,
       M.CPF_CNPJ,
       M.DATA_COMPRA,
       M.ID_TRANSACAO,
       INITCAP(F.FANTASIA) NOME_LOJA,
       M.ID_LOJA,
       INITCAP(M.NOME_VENDEDOR) NOME_VENDEDOR,
       M.CODIGO_VENDEDOR,
       P.METODO_PAGAMENTO,
       M.TOTAL,
       (CASE
         WHEN M.ID_LOJA IN
              (SELECT F1.CODIGO
                 FROM PCFILIAL F1
                WHERE INSTR(F1.FANTASIA, 'LOJA') > 0) THEN
          'OFFLINE'
         ELSE
          'ONLINE'
       END) TIPO_LOJA,
       M.QUANTIDADE_PRODUTO,
       M.TOTAL_DESCONTO,
       M.TOTAL_FRETE,
       '' CUPOM,
       'Pr�pria' CLASSIFICACAO_LOJA
  FROM BASE_MOV_PROD_CONSOLIDADA M
  LEFT JOIN PCFILIAL F ON F.CODIGO = M.ID_LOJA
  LEFT JOIN PCNFSAID S ON S.NUMTRANSVENDA = M.ID_TRANSACAO
                      AND M.OPERACAO_PRODUTO = 'Compra'
  LEFT JOIN PAGAMENTO P ON P.CODCOB = S.CODCOB
