### Instruções iniciais:
    1. Filtrar a PCLANC somente lançamentos que tenham o HISTORICO2 preenchido com ('ISS', 'CSRF', 'IRRF', 'INSS') .
    2. Como estamos desconsiderando os descontos e juros desses lançamentos de impostos, devemos colocar uma condição aonde o VALOR do lançamento seja alterado para o VPAGOBORDERO, ou VPAGO na ausência de borderô.
    3. Inclusão da coluna GRUPOCONTA para usarmos como parâmetro de decisão para seleção da conta contábil correta.
    4. Inclusão da coluna IMPOSTO trazendo qual impostos refere-se o lançamento, já fazendo o tratamento de adicionar um "F" na frente para sinalizar que esse imposto é de funcionário.
