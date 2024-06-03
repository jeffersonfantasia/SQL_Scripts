/**********************************************************
Trazer vendas que s�o:
1. 
2. 
3. 
4. 
5. 
6. 
7. 

Tratamento dos campos:
1. 
2. 
3. 
4. 
5. 

CODIGO_CLIENTE,
CPF_CNPJ,
DATA_COMPRA,
ID_TRANSACAO,
NOME_LOJA,
ID_LOJA,
NOME_VENDEDOR,
CODIGO_VENDEDOR,
METODO_PAGAMENTO,
TOTAL,
TIPO_LOJA,
QUANTIDADE_PRODUTOS,
TOTAL_DESCONTO,
TOTAL_FRETE,
CUPOM,
CLASSIFICACAO_LOJA

**********************************************************/

WITH CLIENTES_MAIS_CONSUMIDOR_FINAL AS
 (SELECT C.CODIGO_CLIENTE,
         C.CPF_CNPJ
    FROM BROKER.DITO_CLIENTES C
  UNION
  SELECT C.CODCLI CODIGO_CLIENTE,
         REGEXP_REPLACE(C.CGCENT, '[^0-9]', '') CPF_CNPJ
    FROM PCCLIENT C
   WHERE C.CODCLI = 1),

TRANSACAO_VENDA AS
 (SELECT DISTINCT M.NUMTRANSVENDA
    FROM PCMOV M
   WHERE M.DTCANCEL IS NULL
     AND M.DTMOV >= TO_DATE('01/01/2022', 'DD/MM/YYYY')
     AND M.CODFISCAL IN
         (5115, 6115, 5102, 5109, 5403, 5405, 6102, 6108, 6403, 5120, 6120)),

TRANSACAO_DEVOLUCAO AS
 (SELECT DISTINCT M.NUMTRANSENT
    FROM PCMOV M
   WHERE M.DTCANCEL IS NULL
     AND M.DTMOV >= TO_DATE('01/01/2022', 'DD/MM/YYYY')
     AND M.CODFISCAL IN (1202, 1411, 2202, 2411))

SELECT C.CODIGO_CLIENTE, C.CPF_CNPJ, S.VLTOTAL
FROM PCNFSAID S
  JOIN CLIENTES_MAIS_CONSUMIDOR_FINAL C ON C.CODIGO_CLIENTE = S.CODCLI
	JOIN TRANSACAO_VENDA M ON M.NUMTRANSVENDA = S.NUMTRANSVENDA
