/**********************************************************
Trazer clientes que são:
1. De vendedores que estão na VIEW DITO_VENDEDORES
2. Apenas clientes que sejam pessoa física (CPF com 11 digitos)
3. Que possuem email preenchido
4. Clientes que não estajam como excluidos
5. Que não possuem TESTE ou CONTATO no nome ou no EMAIL

Tratamento dos campos:
1. Trazer o NOME da JCCLIENTCLUB, caso nulo, trazer primeiro nome da PCCLIENT.CLIENTE
2. Trazer o SOBRENOME da JCCLIENTCLUB, caso nulo, trazer demais nomes da PCCLIENT.CLIENTE
3. Trazer o nome da cidade da tabela PCCIDADE pois na PCCLIENT.MUNICENT o nome esta cortado
**********************************************************/
WITH CEP_LOJAS AS
 (SELECT REGEXP_REPLACE(F.CEP, '[^0-9]', '') CEP_LOJA
    FROM PCFILIAL F
   WHERE INSTR(F.FANTASIA, 'LOJA') > 0),
CLIENTES AS
 (SELECT C.CODCLI CODIGO_CLIENTE,
         REGEXP_REPLACE(C.CGCENT, '[^0-9]', '') CPF_CNPJ,
         C.DTCADASTRO DATA_CADASTRO,
         NVL(C.DTULTALTER, C.DTCADASTRO) DATA_UPDATE,
         DECODE(C.TIPOFJ, 'J', 'Jurídica', 'F', 'Física', 'Física') TIPO_PESSOA,
         C.CLIENTE,
         (CASE
           WHEN INSTR(TRIM(C.CLIENTE), ' ') > 0 THEN
            UPPER(SUBSTR(TRIM(C.CLIENTE), 1, INSTR(TRIM(C.CLIENTE), ' ') - 1))
           ELSE
            UPPER(TRIM(C.CLIENTE))
         END) PRIMEIRO_NOME_PCCLIENT,
         CASE
           WHEN INSTR(TRIM(C.CLIENTE), ' ') > 0 THEN
            UPPER(TRIM(SUBSTR(TRIM(C.CLIENTE),
                              INSTR(TRIM(C.CLIENTE), ' ') + 1)))
           ELSE
            NULL
         END AS SOBRENOME_PCCLIENT,
         TRIM(B.NOME) NOME_JCCLIENTCLUB,
         TRIM(B.SOBRENOME) SOBRENOME_JCCLIENTCLUB,
         LOWER(C.EMAIL) EMAIL,
         REGEXP_REPLACE(C.TELENT, '[^0-9]', '') CELULAR,
         C.SEXO,
         B.DTNASCIMENTO,
         D.NOMECIDADE CIDADE,
         C.ESTENT ESTADO,
         REGEXP_REPLACE(C.CEPENT, '[^0-9]', '') CEP,
         C.DTEXCLUSAO,
         '' Qtd_Filhos_Netos,
         B.ONDECONHECEU Onde_Conheceu,
         '' Nome_Filho_1,
         '' Data_Nascimento_Filho_1,
         '' Genero_Filho_1,
         '' Nome_Filho_2,
         '' Data_Nascimento_Filho_2,
         '' Genero_Filho_2,
         '' Nome_Filho_3,
         '' Data_Nascimento_Filho_3,
         '' Genero_Filho_3,
         '' Nome_Filho_4,
         '' Data_Nascimento_Filho_4,
         '' Gênero_Filho_4,
         '' Nome_Filho_5,
         '' Data_Nascimento_Filho_5,
         '' Genero_Filho_5,
         '' Categoria_Cliente,
         (CASE
           WHEN (C.CODCLI = B.CODCLI) THEN
            'LOJA'
           ELSE
            'SITE'
         END) Origem_Cadastro,
         '' Pontuacao_Cliente,
         '' Retirou_Mimo_Mes_Atual,
         '' Retirou_Cinema_Mes_Atual,
         '' Retirou_Teatro_Mes_Atual,
         '' Retirou_Brinde_Mes_Atual , 
				 (SELECT COUNT(P.CODCLI) FROM PCPEDC P WHERE P.CODCLI = C.CODCLI) VENDAS,
				 EXTRACT (YEAR FROM C.DTCADASTRO) ANO
    FROM PCCLIENT C
    JOIN DITO_VENDEDORES V ON V.CODIGO_VENDEDOR = C.CODUSUR1
    LEFT JOIN JCCLIENTCLUB B ON B.CODCLI = C.CODCLI
    LEFT JOIN PCCIDADE D ON D.CODIBGE = C.CODMUNICIPIO
   WHERE DTEXCLUSAO IS NULL
     AND INSTR(UPPER(C.CLIENTE), 'TESTE') = 0
     AND INSTR(UPPER(C.EMAIL), 'TESTE') = 0
     AND INSTR(UPPER(C.CLIENTE), 'CONTATO') = 0
     AND INSTR(UPPER(C.EMAIL), 'CONTATO') = 0
     AND INSTR(UPPER(C.EMAIL), 'MKTP') = 0
     AND INSTR(UPPER(C.EMAIL), 'CT.VTEX') = 0
     AND INSTR(UPPER(C.EMAIL), 'MERCADOLIVRE') = 0
     AND INSTR(UPPER(C.EMAIL), 'SHOPEE.COM') = 0
     AND INSTR(UPPER(C.EMAIL), 'EMAIL.COM.BR') = 0
     AND INSTR(UPPER(C.EMAIL), 'WALMART') = 0
		 AND INSTR(UPPER(C.EMAIL), 'MARKETPLACE') = 0
		 AND INSTR(UPPER(C.EMAIL), 'BROKERDISTRIBUI') = 0
     AND INSTR(UPPER(C.EMAIL), 'NULL') = 0
     AND C.EMAIL IS NOT NULL),
RESULTADO AS
 (SELECT VENDAS,
         ANO,
         CODIGO_CLIENTE,
         CPF_CNPJ,
         DATA_CADASTRO,
         DATA_UPDATE,
         TIPO_PESSOA,
         NVL(NOME_JCCLIENTCLUB, PRIMEIRO_NOME_PCCLIENT) NOME,
         NVL(SOBRENOME_JCCLIENTCLUB, SOBRENOME_PCCLIENT) SOBRENOME,
         EMAIL,
         CELULAR,
         SEXO,
         LENGTH(CELULAR) TAMNHO_CEL,
         (CASE
           WHEN CEP IN (SELECT CEP_LOJA FROM CEP_LOJAS) THEN
            NULL
           ELSE
            CIDADE
         END) CIDADE,
         (CASE
           WHEN CEP IN (SELECT CEP_LOJA FROM CEP_LOJAS) THEN
            NULL
           ELSE
            ESTADO
         END) ESTADO,
         (CASE
           WHEN CEP IN (SELECT CEP_LOJA FROM CEP_LOJAS) THEN
            NULL
           ELSE
            CEP
         END) CEP,
         Origem_Cadastro,
         Onde_Conheceu,
         Qtd_Filhos_Netos,
         Nome_Filho_1,
         Data_Nascimento_Filho_1,
         Genero_Filho_1,
         Nome_Filho_2,
         Data_Nascimento_Filho_2,
         Genero_Filho_2,
         Nome_Filho_3,
         Data_Nascimento_Filho_3,
         Genero_Filho_3,
         Nome_Filho_4,
         Data_Nascimento_Filho_4,
         Gênero_Filho_4,
         Nome_Filho_5,
         Data_Nascimento_Filho_5,
         Genero_Filho_5,
         Categoria_Cliente,
         Pontuacao_Cliente,
         Retirou_Mimo_Mes_Atual,
         Retirou_Cinema_Mes_Atual,
         Retirou_Teatro_Mes_Atual,
         Retirou_Brinde_Mes_Atual
    FROM CLIENTES
   WHERE LENGTH(CPF_CNPJ) = 11)

--AND CODIGO_CLIENTE = 555392
--AND SOBRENOME_JCCLIENTCLUB IS NOT NULL

SELECT COUNT(*) OVER() total, C.*
  FROM RESULTADO C
	WHERE NOT(VENDAS = 0 AND ANO <= 2022)



--AND ROWNUM <= 5.000
;
;
/****************************************************************
SELECT * FROM JCCLUBCLIENTE WHERE CADASTRADO = 'N' AND CPF IS NOT NULL AND EMAIL IS NOT NULL;
SELECT * FROM JCCLUB;
SELECT J.* FROM JCCLIENTCLUB J;
 SELECT CODCLI, COUNT(*)  FROM JCCLIENTCLUB J GROUP BY CODCLI;



SELECT C.CODCLI CODIGO_CLIENTE,
       C.CGCENT CPF_CNPJ,
       LENGTH(C.CGCENT) TAMANHO,
       C.*
FROM PCCLIENT C
JOIN DITO_VENDEDORES V ON V.CODIGO_VENDEDOR = C.CODUSUR1
WHERE LENGTH(C.CGCENT) = 9
--LEFT JOIN JCCLIENTCLUB B ON B.CODCLI = C.CODCLI

;


SELECT * FROM PCCLIENT C WHERE C.CODCLI = 149623;


SELECT SOBRENOME, COUNT(codcli) FROM JCCLIENTCLUB GROUP BY SOBRENOME;

SELECT ROWID, j.* FROM JCCLIENTCLUB j WHERE CODCLI IN (
557070,
557086,
557108,
557138,
557143,
556791,
556836);


SELECT c.dtcadastro, B.SOBRENOME,
       C.*
  FROM PCCLIENT C
  LEFT JOIN JCCLIENTCLUB B ON C.CODCLI = B.CODCLI
 WHERE C.CODATV1 = 25
   AND c.dtcadastro IS NOT NULL
   AND INSTR(C.CLIENTE, 'CADASTRO') > 0
 ORDER BY c.dtcadastro DESC;
 
 **********/
