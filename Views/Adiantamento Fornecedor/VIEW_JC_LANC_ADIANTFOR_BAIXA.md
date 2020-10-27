### Orientações:

      1. Devemos pegar apenas lançamentos que tenham o RECNUMPAGTO da PCLANCADIANTFORNEC igual ao RECNUM da PCLANC, pois assim houve conciliação do adiantamento com a nota.
      2. Lançamentos que não movimentam bancos na PCMOVCR.
      3. Desconsiderar lançamentos cancelados e estornados.
```slq
DATA = DTPAGTO
```
