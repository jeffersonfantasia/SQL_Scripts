### Conciliação do adiantamento baixando duplicata
	1. Lançamentos que possuem preenchido o campo NUMTRANSVENDADESC significa que foi descontado em duplicata a receber.
	2. Pegar os adiantamentos da VIEW_JC_ADIANT_CLIENTE, assim teremos certeza que estaremos trabalhando com os valores que foram adiantados como numerários.
	3. Para chegarmos ao valor aplicado correto como desconto na duplicata a receber, temos que identificar qual foi o código (chave única) que foi usado dentro daquele NUMTRANS que gerou no adiantamento recebido, que é o lançamento que não possui DTESTORNO preenchido, e tem o DTDESCONTO preenchido.
	4. Tipo 'D'

**União com:**

### Baixa do adiantamento como receita
	1. Lançamentos que possuem preenchido o campo PCCREDCLI.NUMLANCBAIXA significa que foram baixados como receita.
	2. Pegar os adiantamentos da VIEW_JC_ADIANT_CLIENTE, assim teremos certeza que estaremos trabalhando com os valores que foram adiantados como numerários.
	3. Para chegarmos ao valor baixado como receita correto, temos que identificar qual foi o número do crédito que foi usado dentro daquele NUMTRANS que gerou no adiantamento recebido, que é o lançamento que possui NUMLANCBAIXA preenchido.
	4. Tipo 'R'

`DATA  = DTDESCONTO`
