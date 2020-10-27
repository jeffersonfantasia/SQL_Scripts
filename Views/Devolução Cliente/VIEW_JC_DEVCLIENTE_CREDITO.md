### Baixa como desconto no contas a receber e como receita

	1. Pegar na PCCRECLI somente créditos gerados com NUMTRANSENTDEVCLI preenchido, representando crédito gerado através de devolução de cliente.
	2. Desse filtro pegar somente lançamentos com NUMTRANSVENDADESC preenchidos (baixa contas a receber) ou NUMLANCBAIXA preenchido (baixa como receita)
	3. Para tal precisamos excluir o lançamento inicial e o que foi desdobrado pela rotina 1400, pois acaba mantendo o campo NUMTRANSVENDADESC preenchido e não queremos valor dobrado. Assim devemos desconsiderá-los.
	4. Buscar a informação do maior CFOP na PCMOV para que possamos retirar os registros de créditos gerados/baixados oriundos de retorno de demonstração de mercadoria, através do NUMTRANSENT.
	5. TIPO C para baixa em clientes e TIPO R para baixa como receita
  
```sql
DATA =  DTDESCONTO
```
	
*União com:*

### Baixa como devolução em dinheiro ao cliente

	1. Pegar na PCCRECLI somente créditos gerados com NUMTRANSENTDEVCLI preenchido, representando crédito gerado através de devolução de cliente.
	2. Desse filtro pegar somente lançamentos com NUMTRANSBAIXA, que significa que movimentaram bancos.
	3. Puxar na PCMOVCR o banco movimentado, pois lançamentos antigos não tem esse registro na PCCRECLI.CODMOVIMENTO preenchido, e posteriormente puxar o código contábil do banco na PCBANCO.
	4. Nos bancos de bonificação e acerto de motorista foi colocado como código contábil 837 - Outras receitas operacionais
	5. Para tal precisamos excluir o lançamento inicial e o que foi desdobrado pela rotina 1400, pois acaba mantendo o campo NUMTRANSVENDADESC preenchido e não queremos valor dobrado. Assim devemos desconsiderá-los.
	6. Buscar a informação do maior CFOP na PCMOV para que possamos retirar os registros de créditos gerados/baixados oriundos de retorno de demonstração de mercadoria, através do NUMTRANSENT. 
	7. TIPO D para devolução em dinheiro ao cliente
	
```sql
DATA = DTDESCONTO
```
