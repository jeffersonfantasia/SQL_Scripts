### Para os lançamentos valor pago positivo (Adiantamento cliente)
	1. Devemos pegar apenas lançamentos que tenham NUMERARIO = 'S' na PCCRECLI pois movimentam bancos.
	2. Lançamentos com NUMTRANSBAIXA nulo, pois assim não iremos pegar lançamentos devolvidos.
	3. Lançamentos com valores pagos maiores que zero, para não considerar desdobramentos do adiantamento inicial.
	4. Lançamentos que movimentam bancos na PCMOVCR.
	5. Desconsiderar lançamentos cancelados e estornados na PCMOVCR.
	6. Desconsiderar bancos de bonificação, acerto motorista e extravio de mercadoria.
  `DATA = DTLANC`



**União com:**

### Para os lançamentos valor pago positivo (Devolução do adiantamento ao cliente)
	1. Devemos pegar apenas lançamentos que tenham NUMERARIO = 'S' na PCCRECLI pois movimentam bancos.
	2. Lançamentos com NUMTRANS nulo, pois assim não iremos pegar os lançamentos iniciais de adiantamento.
	3. Lançamentos que movimentam bancos na PCMOVCR.
	4. Desconsiderar lançamentos cancelados e estornados PCMOVCR.
	5. Desconsiderar bancos de bonificação, acerto motorista e extravio de mercadoria.
  `DATA = DTCOMPENSACAO`

