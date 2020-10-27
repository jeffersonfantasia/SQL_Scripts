### Para os lançamentos de receita e de pagamento ao cliente

	1. Pegar apenas lançamentos na PCLANC com CODROTINACAD contendo '1346' ou '1303' ou '1360' e devemos retirar HISTORICO contendo 'SHOW ROOM' ou 'SHOWROOM' ou 'AMOSTRAS' ou 'AMOSTRA'.
	2. Retirar lançamentos cancelados.
	3. Desses lançamentos filtrados, os registros com NUMTRANS nulo representam os lançamentos de receita e os NUMTRANS preenchido representam pagamento a cliente.
	4. Logo, TIPO D compreende aos lançamentos que pagamos em dinheiro a devolução e TIPO R lançamentos baixados como receita.
```sql
DATA = DTPAGTO
```
