### Lançamentos das notas pagas em cartão e notas de comissão dos marketplaces:
	1. Filtrar a PCLANC somente lançamentos que tenham vinculo com a PCMOVCR e que tenham sido baixado no banco 40 ou 41 .
	2. Desconsiderar lançamentos oriundos da baixa de duplicatas, pois queremos apenas o lançamento das notas (valor positivo) e seus pagamentos (valor negativo).

**União com:**

### Lançamentos dos impostos das notas de comissão:
    1. Trazer os registros da view de impostos das notas de comissão dos marketplaces pois estas deverão de deduzidas no valor a ser baixado do contas a receber do cliente.
    2. Para tal, devemos filtrar a view de impostos e trazer os lançamentos nas contas 410104.
