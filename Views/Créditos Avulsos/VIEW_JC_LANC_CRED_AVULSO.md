### Lançamentos de créditos avulsos
	1. Quando um crédito é gerado como conta gerencial o campo PCCRECLI.NUMERARIO é igual a "N" e PCCRECLI.NUMLANC diferente de vazio.
	2. Nesse momento é gerado um lançamento de despesa financeira na PCLANC, aonde PCLANC.RECNUM é igual a PCCRECLI.NUMLANC.
	3. Devemos pegar apenas VALOR > 0, pois assim evitamos os registros de desdobramentos (VALOR < 0 ) do lançamento inicial.
	4. Os valores negativos do desdobramento possuem o mesmo PCCRECLI.NUMLANC do que o lançamento positivo inicial
	5. Devemos retirar lançamentos nas contas PCCRECLI.CODMOVIMENTO igual a 37 e 620108, pois são lançamentos de ajuste e taxa de boleto, respectivamente. A taxa é cobrada contabilmente através da nota fiscal de serviço dos marketplaces.
	6. Inclusão de coluna TIPO = 'L' para caracterizar lançamento.
	7. DATA = DTLANC

**União com:**

### Estorno dos lançamentos de crédito avulso
	1. Devemos pegar o NUMLANC do lançamento original e com isso conseguir identificar todos os NUMCRED que pode ter sido gerado.
	2. Através desses NUMCRED, conseguimos pegar o lançamento que tem o campo NUMLANCBAIXA preenchido.
	3. Vale lembrar que nesse momento é gerado uma receita financeira na PCLANC, aonde PCLANC.RECNUM é igual a PCCRECLI.NUMLANCBAIXA.
	4. Inclusão de coluna TIPO = 'E' para caracterizar lançamento de estorno.
	5. DATA = DTDESCONTO

**União com:**

### Baixa de créditos avulsos em duplicatas
	1. Devemos pegar o NUMLANC do lançamento original e com isso conseguir identificar todos os NUMCRED que pode ter sido gerado.
	2. Através do NUMCRED, conseguimos pegar os PCCRECLI.CODIGO com lançamentos com  NUMTRANSVENDADESC preenchido.
	3. Os créditos manuais que foram usados como desconto possuem o NUMTRANSVENDADESC preenchido.
	4. Inclusão de coluna TIPO = 'D' para caracterizar lançamento de desconto.
	5. DATA = DTDESCONTO

**União com:**

### Baixa de créditos avulsos devolvendo em dinheiro:
	1. Devemos pegar o NUMLANC do lançamento original e com isso conseguir identificar todos os NUMCRED que pode ter sido gerado.
	2. Através desses NUMCRED, conseguimos pegar o lançamento que tem o campo NUMTRANSBAIXA preenchido.
	3. Inclusão de coluna TIPO = 'M' para caracterizar lançamento no movimento em numerário.
	4. DATA = DTDESCONTO

***Tanto na baixa em duplicata de cliente como em dinheiro o lançamento deve ser duplicado para dar baixa no credito avulso gerado e posteriormente aplicar como desconto financeiro, seja em cliente ou bancos. Esse lançamentos possuem TIPO = 'B' de baixa.***

