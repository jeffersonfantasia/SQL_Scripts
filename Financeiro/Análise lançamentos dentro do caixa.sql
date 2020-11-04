SELECT M.NUMTRANS "NUMTRANS",
       M.DTCONCIL "DTCONCIL",
       M.DTCOMPENSACAO "DT.COMPENSAÇÃO",
       M.DATA "DATA",
       C.DTCOMPETENCIA,
       C.RECNUM,
       C.CODCONTA "CODCONTA",
       T.CONTA "CONTA",
       M.VALOR "VALOR",
       M.HISTORICO "HISTORICO",
       M.HISTORICO2 "HISTORICO2",
       M.CODBANCO || '-' || M.CODCOB "CAIXA/BANCO/MOEDA",
       M.NUMCARR "NUMDOC",
       M.TIPO "TIPO",      
       M.NUMLANC "NUMLANC",
       M.CONCILIACAO "CONCILIAÇÃO",
       M.CODBANCO "CODBANCO",
       M.CODCOB "CODMOEDA",
       M.VLSALDOCONCIL "SALDOTEMPORARIOCALC",
       DECODE(M.TIPO, 'C', 0, M.VALOR) "ENTRADASCALC",
       DECODE(M.TIPO, 'C', -M.VALOR, 0) "SAIDASCALC",
       (SELECT X.NOME FROM PCBANCO X WHERE X.CODBANCO = M.CODBANCO) "BANCO",
       (SELECT X.MOEDA FROM PCMOEDA X WHERE X.CODMOEDA = M.CODCOB) "MOEDA",
       (SELECT X.NOME
          FROM PCEMPR X
         WHERE X.MATRICULA =
               (NVL(M.CODFUNCCONCIL, NVL(CODFUNCESTORNOCONCIL, M.CODFUNC)))) "FUNCCONCIL",
       SI.SALDO SALDOINICIAL
  FROM PCMOVCR M,
       PCLANC C,
       PCCONTA T,
       (SELECT NVL(ENTRADAS.ENTRADAS, 0) ENTRADAS,
               NVL(SAIDAS.SAIDAS, 0) SAIDAS,
               (NVL(ENTRADAS.ENTRADAS, 0) + NVL(SAIDAS.SAIDAS, 0)) SALDO
          FROM (SELECT SUM(M.VALOR) ENTRADAS
                  FROM PCMOVCR M
                 WHERE M.TIPO <> 'C'
                   AND M.DTCOMPENSACAO < TO_DATE('01/09/2018', 'DD/MM/YYYY')
                   AND M.CONCILIACAO = 'OK'
                   AND M.CODBANCO = 31
                   AND M.CODCOB IN ('D')) ENTRADAS,
               (SELECT (SUM(M.VALOR) * -1)  SAIDAS
                  FROM PCMOVCR M
                 WHERE M.TIPO = 'C'
                   AND M.DTCOMPENSACAO < TO_DATE('01/09/2018', 'DD/MM/YYYY')
                   AND M.CONCILIACAO = 'OK'
                   AND M.CODBANCO = 31
                   AND M.CODCOB IN ('D')) SAIDAS) SI
 WHERE C.NUMTRANS = M.NUMTRANS
   AND C.CODCONTA = T.CODCONTA
   AND C.CODCONTA = 650101
   AND M.CONCILIACAO = 'OK'
   AND TRUNC(M.DTCOMPENSACAO) >= TO_DATE('01/09/2018', 'DD/MM/YYYY')
   AND TRUNC(M.DTCOMPENSACAO) <= TO_DATE('30/09/2018', 'DD/MM/YYYY')
   AND M.CODBANCO = 31
   AND M.CODCOB IN ('D')
 ORDER BY C.RECNUM, M.DTCOMPENSACAO, M.DTCONCIL;