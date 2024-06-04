CREATE OR REPLACE VIEW BROKER.DITO_CLIENTES AS
/**********************************************************
Trazer clientes que são:
1. De vendedores que estão na VIEW DITO_VENDEDORES
2. Apenas clientes que sejam pessoa física (CPF com 11 digitos)
3. Que possuem email preenchido
4. Clientes que não estajam como excluidos
5. Que não possuem TESTE ou CONTATO no nome ou no EMAIL
6. Para clientes que nunca compraram trazer somente os cadastrados em 2022 para frente
7. Para os clientes que compraram trazer apenas os que tem compra de 2022 para frente

Tratamento dos campos:
1. Trazer o NOME da JCCLIENTCLUB, caso nulo, trazer primeiro nome da PCCLIENT.CLIENTE
2. Trazer o SOBRENOME da JCCLIENTCLUB, caso nulo, trazer demais nomes da PCCLIENT.CLIENTE
3. Trazer o nome da cidade da tabela PCCIDADE pois na PCCLIENT.MUNICENT o nome esta cortado
4. Para clientes cadastrados nas lojas, trazer CIDADE, UF, CEP nulos
5. Para tarzer a origem do cadastro é feito um check na tabela JCCLIENTCLUB, se houve 
   registro do cliente, será LOJA senão SITE
**********************************************************/
WITH CEP_LOJAS AS
 (SELECT REGEXP_REPLACE(F.CEP, '[^0-9]', '') CEP_LOJA
    FROM PCFILIAL F
   WHERE INSTR(F.FANTASIA, 'LOJA') > 0),

CLIENTES_FILTRADOS AS
 (SELECT C.CODCLI CODIGO_CLIENTE,
         REGEXP_REPLACE(C.CGCENT, '[^0-9]', '') CPF_CNPJ,
         C.DTCADASTRO DATA_CADASTRO,
         NVL(C.DTULTALTER, C.DTCADASTRO) DATA_UPDATE,
         DECODE(C.TIPOFJ, 'J', 'Jurídica', 'F', 'Física', 'Física') TIPO_PESSOA,
         C.CLIENTE,
         (CASE WHEN INSTR(TRIM(C.CLIENTE), ' ') > 0
            THEN UPPER(SUBSTR(TRIM(C.CLIENTE), 1, INSTR(TRIM(C.CLIENTE), ' ') - 1))
            ELSE UPPER(TRIM(C.CLIENTE))
         END) PRIMEIRO_NOME_PCCLIENT,
         (CASE WHEN INSTR(TRIM(C.CLIENTE), ' ') > 0
            THEN UPPER(TRIM(SUBSTR(TRIM(C.CLIENTE),INSTR(TRIM(C.CLIENTE), ' ') + 1)))
            ELSE NULL
         END) SOBRENOME_PCCLIENT,
         TRIM(B.NOME) NOME_JCCLIENTCLUB,
         TRIM(B.SOBRENOME) SOBRENOME_JCCLIENTCLUB,
         LOWER(C.EMAIL) EMAIL,
         REGEXP_REPLACE(C.TELENT, '[^0-9]', '') CELULAR,
         C.SEXO,
         B.DTNASCIMENTO,
         D.NOMECIDADE CIDADE,
         C.ESTENT ESTADO,
         REGEXP_REPLACE(C.CEPENT, '[^0-9]', '') CEP,
         (CASE WHEN (C.CODCLI = B.CODCLI)
            THEN 'LOJA'
            ELSE 'SITE'
         END) ORIGEM_CADASTRO,
         B.ONDECONHECEU ONDE_CONHECEU,
         (SELECT COUNT(P.CODCLI) FROM PCPEDC P WHERE P.CODCLI = C.CODCLI) VENDAS,
         EXTRACT(YEAR FROM (SELECT MAX(DATA) FROM PCPEDC P WHERE P.CODCLI = C.CODCLI)) ANO_ULTVENDA,
         EXTRACT(YEAR FROM C.DTCADASTRO) ANO_CADASTRO
    FROM PCCLIENT C
    JOIN DITO_VENDEDORES V ON V.CODIGO_VENDEDOR = C.CODUSUR1
    LEFT JOIN JCCLIENTCLUB B ON B.CODCLI = C.CODCLI
    LEFT JOIN PCCIDADE D ON D.CODIBGE = C.CODMUNICIPIO
   WHERE DTEXCLUSAO IS NULL
     AND INSTR(UPPER(C.CLIENTE), 'TESTE') = 0
     AND INSTR(UPPER(C.EMAIL), 'TESTE') = 0
     AND INSTR(UPPER(C.CLIENTE), 'CONTATO') = 0
     AND INSTR(UPPER(C.EMAIL), 'MKTP') = 0
     AND INSTR(UPPER(C.EMAIL), 'CT.VTEX') = 0
     AND INSTR(UPPER(C.EMAIL), 'MERCADOLIVRE') = 0
     AND INSTR(UPPER(C.EMAIL), 'SHOPEE.COM') = 0
     AND INSTR(UPPER(C.EMAIL), 'EMAIL.COM.BR') = 0
     AND INSTR(UPPER(C.EMAIL), 'WALMART') = 0
     AND INSTR(UPPER(C.EMAIL), 'MARKETPLACE') = 0
     AND INSTR(UPPER(C.EMAIL), 'BROKERDISTRIBUI') = 0
     AND INSTR(UPPER(C.EMAIL), 'INTEGRACOMMERCE') = 0
     AND INSTR(UPPER(C.EMAIL), 'NULL') = 0
     AND C.EMAIL IS NOT NULL),

CLIENTES_TRATADOS AS
 (SELECT VENDAS,
         ANO_CADASTRO,
         ANO_ULTVENDA,
         CODIGO_CLIENTE,
         CPF_CNPJ,
         DATA_CADASTRO,
         DATA_UPDATE,
         TIPO_PESSOA,
         INITCAP(NVL(NOME_JCCLIENTCLUB, PRIMEIRO_NOME_PCCLIENT)) NOME,
         INITCAP(NVL(SOBRENOME_JCCLIENTCLUB, SOBRENOME_PCCLIENT)) SOBRENOME,
         EMAIL,
         CELULAR,
         SEXO,
         DTNASCIMENTO,
         LENGTH(CELULAR) TAMNHO_CEL,
         (CASE WHEN CEP IN (SELECT CEP_LOJA FROM CEP_LOJAS)
            THEN NULL
            ELSE CIDADE
         END) CIDADE,
         (CASE WHEN CEP IN (SELECT CEP_LOJA FROM CEP_LOJAS)
            THEN NULL
            ELSE ESTADO
         END) ESTADO,
         (CASE WHEN CEP IN (SELECT CEP_LOJA FROM CEP_LOJAS)
            THEN NULL
            ELSE CEP
         END) CEP,
         ORIGEM_CADASTRO,
         ONDE_CONHECEU
    FROM CLIENTES_FILTRADOS)

SELECT CODIGO_CLIENTE,
       CPF_CNPJ,
       DATA_CADASTRO,
       DATA_UPDATE,
       TIPO_PESSOA,
       NOME,
       SOBRENOME,
       EMAIL,
       CELULAR,
       SEXO,
       DTNASCIMENTO,
       CIDADE,
       ESTADO,
       CEP,
       ORIGEM_CADASTRO,
       ONDE_CONHECEU,
       '' QTD_FILHOS_NETOS,
       '' NOME_FILHO_1,
       '' DATA_NASCIMENTO_FILHO_1,
       '' GENERO_FILHO_1,
       '' NOME_FILHO_2,
       '' DATA_NASCIMENTO_FILHO_2,
       '' GENERO_FILHO_2,
       '' NOME_FILHO_3,
       '' DATA_NASCIMENTO_FILHO_3,
       '' GENERO_FILHO_3,
       '' NOME_FILHO_4,
       '' DATA_NASCIMENTO_FILHO_4,
       '' GÊNERO_FILHO_4,
       '' NOME_FILHO_5,
       '' DATA_NASCIMENTO_FILHO_5,
       '' GENERO_FILHO_5,
       '' CATEGORIA_CLIENTE,
       '' PONTUACAO_CLIENTE,
       '' RETIROU_MIMO_MES_ATUAL,
       '' RETIROU_CINEMA_MES_ATUAL,
       '' RETIROU_TEATRO_MES_ATUAL,
       '' RETIROU_BRINDE_MES_ATUAL
  FROM CLIENTES_TRATADOS C
 WHERE LENGTH(CPF_CNPJ) = 11
   AND NOT(VENDAS = 0 AND ANO_CADASTRO <= 2022)
   AND NOT(VENDAS > 0 AND ANO_ULTVENDA <= 2022);
