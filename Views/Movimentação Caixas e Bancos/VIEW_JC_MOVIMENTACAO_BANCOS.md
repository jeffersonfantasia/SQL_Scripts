### Lançamentos gerais de movimentação entre bancos e caixas:
	1. Devemos segregar os lançamentos de débitos dos lançamentos de crédito para que possamos colocá-los um único registro.
	2. Pegaremos somente lançamentos que não foram estornados, com a cobrança em DINHEIRO e lançados pelas rotinas 632 e 643.
	3. Desconsiderar lançamentos nos bancos de BONIFICAÇÃO  e ACERTO MOTORISTA.
	4. Desconsiderar lançamento com NUMTRANS = 116436, pois se trata do ajuste entre investimentos VIP DI e TRUST DI em junho 2019.
	5. Tipo 'G'

**União com:**

### Lançamentos de pagamento de empréstimo de terceiros
	1. Devemos criar tabela virtual transformando todas as filiais dos bancos com filiais (1,2,7,99) em 1, mantendo as demais.
	2. Depois iremos criar 2 novas tabelas virtuais, uma para o banco crédito outra para o banco débito fazendo o vínculo com a primeira tabela.
	3. Com isso conseguimos filtrar a tabela base para trazer apenas lançamentos que sejam de empresas diferentes.
	4. Tipo 'EC'.

**União com:**

### Lançamentos de recebimento de empréstimo de terceiros
	1. Devemos criar tabela virtual transformando todas as filiais dos bancos com filiais (1,2,7,99) em 1, mantendo as demais.
	2. Depois iremos criar 2 novas tabelas virtuais, uma para o banco crédito outra para o banco débito fazendo o vínculo com a primeira tabela.
	3. Com isso conseguimos filtrar a tabela base para trazer apenas lançamentos que sejam de empresas diferentes.
	4. Tipo 'EB'.

