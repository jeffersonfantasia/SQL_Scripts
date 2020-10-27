### Instruções iniciais:

	1. Buscar na PCLANC apenas registros que tenham sido gerado como a contrapartida da inclusão da duplicata de forma manual, ou seja, lançamentos  com CODROTINABAIXA igual a 1206.
	2. Trazer na consulta o código contábil no cadastro do cliente para utilizarmos no ETL do Power Query, informando a conta correta dos clientes cartão / marketplaces.

```sql
DATA = DTPAGTO
```
