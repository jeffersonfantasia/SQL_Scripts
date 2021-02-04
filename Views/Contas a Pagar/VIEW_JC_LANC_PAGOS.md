### Relação de lançamentos base pagos
	1. Devemos filtrar os lançamentos da PCLANC excluindo:
		○ INDICE = 'B' - que são lançamentos oriundos das rotinas de estoque (1124, 1147, 1181, 1103).
		○ DTCANCEL preenchido, não considerando lançamentos cancelados.
		○ DTESTORNOBAIXA preenchido, não considerando lançamentos estornados.
		○ Lançamentos de contrapartida para baixa das vendas convênio de funcionários (CODCONTA 100027).
		○ Lançamentos oriundos da baixa de duplicatas a receber, como taxa de cartão, descontos concedidos, baixa como perda, juros recebidos, ou seja, CODROTINABAIXA NOT IN (1207, 1502, 1503, 9806).
	2. Devemos buscar apenas lançamentos com NUMTRANS preenchido e a partir da junção com a PCMOVCR, excluir lançamentos:
		○ Que tenham sido realizados nos bancos de bonificação, acerto do motorista e extravio de mercadoria.
		○ Que tenham sido estornados (DTESTORNO preenchido).
		○ Que tenham sido lançados pela rotina 1209 (Rotina de estorno).

**União com**

### Desconto financeiros obtidos:
	1. Com relação aos descontos financeiros obtidos, temos que buscar os lançamentos de impostos HISTORICO2 IN ('ISS', 'CSRF', 'IRRF', 'INSS') que tenham desconto ou juros, para termos o RECNUM e com isso desconsiderar esses registros da relação de lançamentos de desconto financeiro obtidos.
	2. Com relação aos descontos financeiros obtidos, temos que buscar os lançamentos de nas contas gerenciais que os lançamentos não passam pelo fornecedor, que tenham desconto ou juros, para termos o RECNUM e com isso desconsiderar esses registros da relação de lançamentos de desconto financeiro obtidos.
	3. Assim conseguiremos ter uma relação "limpa" dos descontos obtidos válidos.
	4. Inclusão da coluna TIPO = 'D'

**União com**

### Desconto financeiros INTEGRALMENTE obtidos:
	1. Quando é obtivo desconto de 100% sobre o valor da nota, este não gera resgitro de NUMTRANS, e por isso não estava aparecendo no relatório.
	2. Logo, devemos trazer somente registros que possuem desconto, que foram pagos e que não foram cancelados e nem estornados.
	3. Inclusão da coluna TIPO = 'D'

**União com**

### Juros pagos a fornecedor:
	1. Com relação aos juros pagos, temos que buscar os lançamentos de impostos HISTORICO2 IN ('ISS', 'CSRF', 'IRRF', 'INSS') que tenham desconto ou juros, para termos o RECNUM e com isso desconsiderar esses registros da relação de lançamentos de juros pagos.
	2. Assim conseguiremos ter uma relação "limpa" dos juros pagos válidos.
	3. Inclusão da coluna TIPO = 'J'

**União com**

### Demais lançamentos filtrados na PCLANC
	1. Tendo como base os lançamentos pagos acima, continuaremos filtrando:
	2. Lançamentos na conta 37 e feitos pela rotina 631, pois se trata de lançamentos de ajuste.
	3. Desconsiderar lançamentos de impostos de notas de serviço e sob funcionários, pois esses lançamentos serão incluídos através de UNION.
	4. Devemos fazer relacionamento com as VIEW de adiantamento ao fornecedor e baixa do adiantamento para retirar esses registros da consulta e assim não trazer duplicação.
	5. Criação de uma tabela virtual trazendo todos os lançamentos que sofreram desconto financeiro ou pagamento de juros para que tenhamos o RECNUMBAIXA dos lançamentos de desconto e juros e com isso desconsiderar da relação, e evitando a duplicidade.
	6. Sobre o valor pago, se ele for maior do que valor pago borderô, devemos considerar o valor pago borderô, retirando os juros para que não haja duplicidade.
	7. Desconsiderar os registros com valor igual a zero, pois estes receberam 100% de desconto ou foi abatido da devolução ao fornecedor.
	8. Inclusão da coluna TIPO, quando o TIPOPARCEIRO for igual a fornecedor, então TIPO = 'F' se não for fornecedor será TIPO = 'O'.

**União com**

### Impostos de notas de serviço e funcionários
	1. Devemos pegar apenas os lançamentos pagos da View criada (VIEW_JC_IMPOSTO_NFSE) para relacionar a despesa na conta correta no Power Query.
	2. Se o existir valor pago borderô, pegar esse valor caso contrario pegar valor pago, isso pois fizemos o tratamento para retirar os descontos e juros desses lançamentos.
	3. Inclusão da coluna TIPO = 'I'.

**União com**

### Pagamento das notas de comissão dos Maketplaces
	1. Pegar da view criada (VIEW_JC_CARTAO_MKT) somente lançamentos de pagamento das notas (valor negativo no caixa 40), lançamentos de impostos e lançamentos da assinatura da amazon e gateway da pagar.me, pois não possuem contrapartida.
	2. Coluna TIPO oriunda da VIEW, aonde 'MK' representa o valor total da nota e 'MI' o valor do impostos retido.

**União com**

### Pagamento com cartão de crédito de notas de serviço
	1. Pegar da view criada (VIEW_JC_CARTAO_MKT) somente lançamentos do caixa 41 e com valor pago negativo, que representam os pagamentos das parcelas.
	2. Adicionar no filtro lançamentos com valor pago positivo e que tenham sido feito no tipo parceiro "Outros", pois assim teremos lançamento direto contra a conta despesa.
	3. Inclusão da coluna TIPO = 'C'

**União com**

### Lançamentos entre empresas para movimentar conta gerencial / empréstimo
	1. Criar tabela virtual transformando todas as filiais dos bancos com filiais (1,2,7,99) em 1, mantendo as demais.
	2. Criar tabela virtual transformando todas as filiais dos bancos com filiais  (1,2,7) em 1, mantendo as demais.
	3. Buscar apenas lançamentos aonde as filais das empresas dos bancos sejam diferente das filiais das empresas dos lançamentos
	4. Inclusão da coluna TIPO = 'EC'

**União com**

### Lançamentos entre empresas para movimentar empréstimo / banco
	1. Criar tabela virtual transformando todas as filiais dos bancos com filiais (1,2,7,99) em 1, mantendo as demais.
	2. Criar tabela virtual transformando todas as filiais dos bancos com filiais  (1,2,7) em 1, mantendo as demais.
	3. Buscar apenas lançamentos aonde as filais das empresas dos bancos sejam diferente das filiais das empresas dos lançamentos
	4. Inclusão da coluna TIPO = 'EB'

**União com**

### Lançamentos dos alugueis das máquinas de cartão
	1. Selecionar todos os lançamentos da conta 620105, respeitando os filtros da tabela virtual PCLANC_BASE.
	2. Buscar o código contábil do fornecedor ou do cliente, dependendo do tipo de parceiro.
	3. Inclusão da coluna TIPO = 'A'

**União com**

### Lançamentos no caixa dos mútuos
	1. Selecionar todos os lançamentos da dos bancos 14 e 15.
	2. Desconsiderar lançamentos de aporte e pagamento
	3. Inclusão da coluna TIPO = 'MT'

**União com**

### Lançamentos de verbas avulsas recebidas como dinheiro
	1. Selecionar todos os lançamentos baixados na rotina 1803, excluídos lançamentos de verbas oriundas de devolução ao fornecedor (VIEW_JC_DEVFORNEC_PAGTO)
	2. Além de desconsiderar lançamentos cancelados ou estornados, desconsiderar lançamentos baixados nos caixas de bonificação, acerto motorista e extravio de mercadoria.
	3. Inclusão da coluna TIPO = 'V'

