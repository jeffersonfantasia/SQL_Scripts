### Juros recebidos (Tipo J):
	1. Devemos pegar o valor descontado das duplicatas de cartão de débito e crédito e para tal, vamos usar como filtro os clientes cadastrados nas cobranças que sejam cartão e tenham como conta gerencial 620105.
	2. Valor do juros deverá ser somando ao valor de outras despesas. 
	3. DATA = DTPAG

**União com:**

### Títulos Estornados (Tipo E):
	1. Devemos pegar o valor original somente das cobranças ESTORNADAS
	2. DATA  = DTPAG
	3. Retirar baixa nos bancos de bonifiação, acerto de motorista e extravios de mercadoria

**União com:**

### Juros Estornados (Tipo EJ):
	1. Devemos pegar o valor de juros somente das cobranças ESTORNADAS
	2. DATA  = DTPAG
	3. Retirar baixa nos bancos de bonifiação, acerto de motorista e extravios de mercadoria

**União com:**

### Descontos concedidos (Tipo D):
	1. Devemos pegar o valor descontado das duplicatas de cartão de débito e crédito e para tal, devemos retirar as duplicatas de cartão e de marketplaces.
	2. DATA  = DTPAG

**União com:**

### Taxa de cartão (Tipo T):
	1. Devemos pegar o valor descontado das duplicatas de cartão de débito e crédito e para tal, vamos usar como filtro os clientes cadastrados nas cobranças que sejam cartão e tenham como conta gerencial 620105.
	2. DATA = DTPAG

**União com:**

### Recebíveis (Tipo B):
	1. Devemos pegar todas as duplicatas que foram pagas, ou seja, possuem PCPREST.NUMTRANS preenchido, e que não foram baixadas em bancos de bonificação, acerto motorista e extravio de mercadoria.
	2. As duplicatas com as cobranças de DESDOBRAMENTO, TROCO, BONIFICACAO, CHEQUE IRREGULAR, CANCELAMENTO, CONVÊNIO não devem fazer parte da relação.
	3. Verificar se o VPAGO é maior do que o VALOR na PCPREST, pois isso significa que foi pago com juros.
	4. Quando a cobrança for DESC, iremos pegar o VALORDESC ao invés do VALOR.
	5. Quando a cobrança for JUR, iremos pegar o VPAGO ao invés do VALOR.
	6. Porém se o valor pago for negativo, iremos zerar o valor, pois se ficou negativo significa que o desconto foi maior do que o valor da duplicata.  (correção bug sistema)
	7. Duplicatas com a cobrança JUR significa que o cliente pagou atrasado, e o sistema gerou JUR devido, logo quando o cliente faz o pagamento esse valor deve creditar a conta de juros e não mais a de cliente. 
	8. Quando o valor pago for maior do que o valor da duplicata, devemos fazer uma verificação se o juros for nulo ou desconto for zero, devemos pegar o valor pago, caso contrario apenas o valor para não trazer duplicidade no valor de juros.
	9. DATA = DTPAG

**União com:**

### Baixa como perda (Tipo P):
	1. Devemos pegar todas as duplicatas que foram pagas, ou seja, possuem PCPREST.NUMTRANS preenchido e com cobrança em PERD
	2. DATA = DTPAG
