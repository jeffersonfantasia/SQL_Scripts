/*ANALISE MOVIMENTACAO FECHAMENTO NA 410*/
SELECT T.CODFUNCCHECKOUT,
       T.NUMFECHAMENTOMOVCX,
       T.NUMCHECKOUT,
       T.NUMCAIXAFISCAL,
       T.CODFUNCFECHA,
       E.NOME_GUERRA AS NOME,
       T.ROTINAFECHA,
       (T.DTFECHA || ' ' || T.HORAFECHA || ':' || T.MINUTOFECHA) AS DTFECHA,
       T.DTBAIXA,
       T.*
  FROM PCPREST T
  LEFT JOIN PCEMPR E ON T.CODFUNCFECHA = E.MATRICULA
 WHERE CODCLI = 1
   AND T.NUMTRANSVENDA = 11224084;
/

/*ANALISE MOVIMENTACAO DO FECHAMENTO DO PDV*/
SELECT M.CODFILIAL,
       M.NUMFECHAMENTOMOVCX,
       M.NUMMOVIMENTOPDV,
       M.CODFUNCCX,
       E.NOME_GUERRA AS NOME,
       M.DTABERTURA,
       (M.DTFECHAMENTO || ' ' || M.HORAFECHAMENTO || ':' || M.MINUTOFECHAMENTO) AS DTFECHAMENTO,
       M.NUMCAIXA
  FROM PCFECHAMENTOMOVCX M
  LEFT JOIN PCEMPR E ON M.CODFUNCCX = E.MATRICULA
 WHERE NUMFECHAMENTOMOVCX = 126;
/
 
 /*ANALISE MOVIMENTACAO DO PDV*/
SELECT *
  FROM PCMOVIMENTOPDV
 WHERE NUMMOVIMENTOPDV = 71
   AND NUMCAIXA = 5;
/

/*ANALISE DA VENDA*/
SELECT S.DATAHORAEMISSAOSAT,
       S.*
  FROM PCNFSAID S
 WHERE S.NUMTRANSVENDA = 11224084;
/