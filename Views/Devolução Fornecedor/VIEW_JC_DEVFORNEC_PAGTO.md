***Contas contábeis amarradas nos bancos de bonificação e acerto motorista - se essas contas mudarem precisa ser atualizado o script!***

### Intruções iniciais
	1. Na PCMOVCRFOR precisamos pegar apenas lançamentos NUMTRANSENTDEVFORNEC preenchido, porém retirando tanto o lançamento inicial como o lançamento de cancelamento (DTPAGO preenchido).
	2. Através desse filtro, devemos encontrar os lançamentos de baixa dessa verba, para através dos PCMOVCRFOR.NUMLANC conseguirmos filtrar as aplicações dessas devoluções como desconto em duplicatas a pagar.
	3. Através desse filtro, devemos encontrar os lançamentos de baixa dessa verba, para através dos PCMOVCRFOR.NUMTRANSEST conseguirmos filtrar as aplicações dessas devoluções como recebimento em dinheiro.
	4. Através desse filtro, devemos encontrar os lançamentos de baixa dessa verba, para através do PCMOVCRFOR.NUMLANC igual a zero, conseguirmos filtrar recebimentos dessas devoluções em mercadorias, seja bonificada ou entrada de simples remessa, porém contabilmente, iremos baixar como prejuízo.

### Baixas em dinheiro

	1. Com isso conseguimos filtrar a PCLANC somente aonde o NUMTRANS forem iguais aos PCMOVCRFOR.NUMTRANSEST.
	2. Para os lançamentos baixados no caixa de bonificação estes irão debitar a conta 725 - Prejuízos com Clientes.
	3. TIPO = D
	4. DATA = DTCOMPENSACAO, porém ainda não estiver preenchida será DTCOMPETENCIA
	
**União com**
	
### Baixas em duplicatas a pagar:

	1. Com isso conseguimos filtrar a PCLANC somente aonde o RECNUM forem iguais aos PCMOVCRFOR.NUMLANC .
	2. Retirar RECNUM igual a zero para não trazer as verbas baixadas com NF bonificação ou entrada de simples remessa.
	3. TIPO = F
	4. DATA = DTPAGTO

**União com**
	
### Baixas na conta prejuízo:

	1. Com isso conseguimos filtrar somente aonde NUMLANC for nulo ou igual a zero
	2. TIPO = P
	3. DATA = DTPAGO

**União com**

### Baixas em duplicatas a pagar na rotina de devolução:

	1. Retirar todos os lançamentos da PCLANC que o VALORDEV foi composto por verbas geradas.
	2. A partir desse resultado, buscar somente os lançamentos que trazem o NUMNOTADEV preenchido, pois com isso já são excluídos os lançamentos com a baixa estornada.
	3. Filtrar somente lançamentos pagos.
	4. TIPO = F
	5. DATA = DTPAGTO
	
