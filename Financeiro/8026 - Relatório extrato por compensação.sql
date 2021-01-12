/*SUBSTITUIR BANCO, DATAINICIAL E DATAFINAL*/
SELECT M.NUMTRANS "NumTrans",
       M.DTCONCIL "DtConcil",
       M.DTCOMPENSACAO "Dt.Compensação",
       M.DATA "Data",
       M.CODBANCO || '-' || M.CODCOB "Caixa/Banco/Moeda",
       M.NUMCARR "NumDoc",
       M.HISTORICO "Historico",
       M.HISTORICO2 "Historico2",
       M.TIPO "Tipo",
       M.VALOR "Valor",
       M.NUMLANC "NumLanc",
       M.CONCILIACAO "Conciliação",
       M.CODBANCO "CodBanco",
       M.CODCOB "CodMoeda",
       M.VLSALDOCONCIL "SaldoTemporarioCalc",
       DECODE (M.TIPO, 'C', 0, M.VALOR) "EntradasCalc",
       DECODE (M.TIPO, 'C', - M.VALOR, 0) "SaidasCalc",
       (
           SELECT X.NOME
             FROM PCBANCO X
            WHERE X.CODBANCO = M.CODBANCO
       ) "Banco",
       (
           SELECT X.MOEDA
             FROM PCMOEDA X
            WHERE X.CODMOEDA = M.CODCOB
       ) "Moeda",
       (
           SELECT X.NOME
             FROM PCEMPR X
            WHERE X.MATRICULA = (NVL (M.CODFUNCCONCIL, NVL (CODFUNCESTORNOCONCIL, M.CODFUNC)))
       ) "FuncConcil",
       SI.SALDO SALDOINICIAL
  FROM PCMOVCR M,
       (
           SELECT NVL (ENTRADAS.ENTRADAS, 0) ENTRADAS,
                  NVL (SAIDAS.SAIDAS, 0) SAIDAS,
                  (NVL (ENTRADAS.ENTRADAS, 0) + NVL (SAIDAS.SAIDAS, 0)) SALDO
             FROM (
               SELECT SUM (M.VALOR) ENTRADAS
                 FROM PCMOVCR M
                WHERE M.TIPO <> 'C'
                  AND M.DTCOMPENSACAO < TO_DATE ('31/12/2020', 'DD/MM/YYYY')
                  AND M.CONCILIACAO = 'OK'
                  AND M.CODBANCO = 1
                  AND M.CODCOB IN (
                   'D'
               )
           ) ENTRADAS,
                  (
                      SELECT (SUM (M.VALOR) * - 1) SAIDAS
                        FROM PCMOVCR M
                       WHERE M.TIPO = 'C'
                         AND M.DTCOMPENSACAO < TO_DATE ('31/12/2020', 'DD/MM/YYYY')
                         AND M.CONCILIACAO = 'OK'
                         AND M.CODBANCO = 1
                         AND M.CODCOB IN (
                          'D'
                      )
                  ) SAIDAS
       ) SI
 WHERE M.CONCILIACAO = 'OK'
   AND TRUNC (M.DTCOMPENSACAO) >= TO_DATE ('31/12/2020', 'DD/MM/YYYY')
   AND TRUNC (M.DTCOMPENSACAO) <= TO_DATE ('31/12/2020', 'DD/MM/YYYY')
   AND M.CODBANCO = 1
   AND M.CODCOB IN (
    'D'
)
 ORDER BY M.DTCOMPENSACAO,
          M.DTCONCIL;
/