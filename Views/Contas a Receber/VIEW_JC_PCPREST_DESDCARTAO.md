### Intruções iniciais

    1. Devemos pegar as duplicatas apenas com códigos de cobranças que são oriundas de vendas de cartão ou site/marketplaces que sofreram desdobramentos, portanto DTPAG preenchido, que não foram baixadas em nenhum banco, e não tiveram seu desdobramento estornado.
    2. Devemos retirar duplicatas que foram canceladas, tomando cuidado que o desdobramento pode ocorrer primeiro do que o cancelamento, logo deve ser analisado o DTCANCEL de todas as duplicatas para aquele mesmo NUMTRANSVENDA, e pegar aquelas que não possuem cancelamento.
    3. A partir do código da cobrança conseguimos trazer o código contábil cadastrado na PCCLIENT.CODCONTAB, através do relacionamento com PCCLIENT.CODCLI = PCCOB.CODCLICC, com cobranças CARTÃO = 'S'.
    4. A partir do código do cliente vinculado nas cobranças dos cartões e marketplaces, conseguimos desconsiderar os lançamentos que foram desdobrados posteriormente já estando desdobrado no cliente de cartão / marketplaces.

```sql
DATA = DTEMISSAO
```
