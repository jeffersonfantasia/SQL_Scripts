/*DEVEMOS RECALCULAR O PIS COFINS E DEPOIS GERAR O LIVRO*/
SELECT E.CODFILIALNF,
       E.DTENTRADA,
       E.DTEMISSAO,
       E.NUMTRANSENT,
       E.VLPIS,
       E.VLCOFINS
  FROM PCNFBASEENT E
 WHERE E.CODFILIALNF IN (
    5, 6
)
   AND (E.VLPIS > 0
    OR E.VLCOFINS > 0);
/