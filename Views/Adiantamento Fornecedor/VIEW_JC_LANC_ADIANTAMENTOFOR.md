### Orientações:
  
     1. Devemos pegar apenas lançamentos que tenham o ADIANTAMENTO = 'S' na PCLANC.
     2. Lançamentos que movimentam bancos na PCMOVCR.
     3. Desconsiderar lançamentos cancelados e estornados.
     4. Desconsiderar bancos de bonificação, acerto motorista e extravio de mercadoria.

```sql
DATA =  DTPAGTO
```
