CREATE OR REPLACE VIEW BROKER.DITO_BASE_MOV_PRODUTO AS

/**********************************************************
View criada para alimentar a DITO_TRANSACOES e DITO_PRODUTOS
1. Clientes com movicmentação sem cadastro na DITO_CLIENTES serão jogados para CODCLI = 1 CONSUMIDOR FINAL
2. Somente movimentação dos vendedores da DITO_VENDEDORES
3. Criado tabelas virtuais com os CFOPs de venda e devolução para filtrar as movimentações 
   e distinguir as operações
4. Assim conseguimos informar que as devoluções possuem quantidade negativa.
**********************************************************/

WITH CLIENTES_CONSUMIDOR_FINAL AS
  (SELECT C.CODCLI CODCLI_CONSUMIDOR_FINAL,
         REGEXP_REPLACE(C.CGCENT, '[^0-9]', '') CPF_CONSUMIDOR_FINAL
    FROM PCCLIENT C
   WHERE C.CODCLI = 1),

CFOP_VENDAS AS
 (SELECT F.CODFISCAL
    FROM PCCFO F
   WHERE F.CODFISCAL IN
         (5115, 6115, 5102, 5109, 5403, 5405, 6102, 6108, 6403, 5120, 6120)),

CFOP_DEVOLUCAO AS
 (SELECT F.CODFISCAL
    FROM PCCFO F
   WHERE F.CODFISCAL IN (1202, 1411, 2202, 2411)),

CFOP_TRANSACAO AS
 (SELECT CODFISCAL
    FROM CFOP_VENDAS
  UNION
  SELECT CODFISCAL
    FROM CFOP_DEVOLUCAO)

SELECT (CASE WHEN M.CODCLI = C.CODIGO_CLIENTE THEN C.CODIGO_CLIENTE ELSE (SELECT CODCLI_CONSUMIDOR_FINAL FROM CLIENTES_CONSUMIDOR_FINAL) END) CODIGO_CLIENTE,
       (CASE WHEN M.CODCLI = C.CODIGO_CLIENTE THEN C.CPF_CNPJ ELSE (SELECT CPF_CONSUMIDOR_FINAL FROM CLIENTES_CONSUMIDOR_FINAL) END) CPF_CNPJ,
       M.DTMOV DATA_COMPRA,
       NVL(M.NUMTRANSVENDA, M.NUMTRANSENT) ID_TRANSACAO,
       M.CODFILIAL ID_LOJA,
       M.CODUSUR CODIGO_VENDEDOR,
       V.NOME_VENDEDOR,
       M.CODPROD ID_PRODUTO,
       M.DESCRICAO NOME_PRODUTO,
       (CASE
         WHEN M.CODFISCAL IN (SELECT CODFISCAL FROM CFOP_DEVOLUCAO D) THEN
          M.QTCONT * -1
         ELSE
          M.QTCONT
       END) QUANTIDADE,
       ROUND(M.QTCONT * (M.PUNITCONT - NVL(M.ST, 0) - NVL(M.VLIPI, 0) - NVL(M.VLFRETE, 0)), 2) PRECO_PRODUTO,
       ROUND(M.QTCONT * (M.PUNITCONT - NVL(M.ST, 0) - NVL(M.VLIPI, 0) - NVL(M.VLFRETE, 0)), 2) VALOR_UNITARIO,
       ROUND(M.QTCONT * NVL(M.VLDESCONTO, 0), 2) TOTAL_DESCONTO,
       ROUND(M.QTCONT * NVL(M.VLFRETE, 0), 2) TOTAL_FRETE,
       (CASE
         WHEN M.CODFISCAL IN (SELECT CODFISCAL FROM CFOP_DEVOLUCAO D) THEN
          'Devolucao'
         ELSE
          'Compra'
       END) OPERACAO_PRODUTO
  FROM PCMOV M
  JOIN CFOP_TRANSACAO T ON T.CODFISCAL = M.CODFISCAL
  JOIN BROKER.DITO_VENDEDORES V ON V.CODIGO_VENDEDOR = M.CODUSUR
	JOIN PCFILIAL F ON F.CODIGO = M.CODFILIALNF
  LEFT JOIN BROKER.DITO_CLIENTES C ON C.CODIGO_CLIENTE = M.CODCLI
 WHERE M.DTCANCEL IS NULL
   AND F.NOMEREMETENTE = 'JC BROTHERS'
   AND M.DTMOV >= TO_DATE('01/01/2022', 'DD/MM/YYYY');
