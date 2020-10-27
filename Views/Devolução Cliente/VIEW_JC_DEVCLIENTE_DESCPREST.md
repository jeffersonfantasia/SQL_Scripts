### Para aplicação como desconto na duplicata dos cliente no momento da devolução:

	1. Pegar na PCPREST somente registros com CODCOB igual a DEVT ou DEVP e que sejam positivos, para não pegar valor negativo que representa o desdobramento.
	2. Desconsiderar registros que tenham sido cancelados.

```sql
DATA = DTPAG
```
