WITH PCMOVCR_CREDITO AS
 (SELECT M.DTCOMPENSACAO AS DATA_CRED,
         M.NUMTRANS,
         M.NUMSEQ AS NUMSEQ_CRED,
         M.CODBANCO AS CODBANCOCRED,
         B.NOME AS BANCOCRED,
         M.CODCOB,
         M.CODFUNCCONCIL FUNC_CRED,
         M.VALOR
    FROM PCMOVCR M
    LEFT JOIN PCBANCO B ON M.CODBANCO = B.CODBANCO
   WHERE M.DTESTORNO IS NULL
     AND M.ESTORNO <> 'S'
        /*NAO TRAZER MOVIMENTACOES ESTORNADAS*/
     AND M.CODCOB = 'D'
        /*SOMENTE TRANSACOES COM DINHERO*/
     AND M.TIPO = 'C'
        /*NESSE PRIMEIRO MOMENTO TRAZER LAN�AMENTOS DE CREDITO*/
     AND M.CODROTINALANC IN (632, 643)
        /*LANCAMENTOS SOMENTE COM MOVIMENTACAO ENTRE CAIXAS*/
     AND M.CODBANCO NOT IN (17, 20, 35, 50, 52, 53, 54)
  /*RETIRAR CAIXAS MKT POIS OS TITULOS S�O BAIXADOS POSTERIORMENTE*/
  ),
PCMOVCR_DEBITO AS
 (SELECT M.DTCOMPENSACAO AS DATA_DEB,
         M.NUMTRANS,
         M.NUMSEQ AS NUMSEQ_DEB,
         B.CODFILIAL AS CODFILIALDEB,
         M.CODBANCO AS CODBANCODEB,
         B.NOME AS BANCODEB,
         M.CODCOB,
         M.CODFUNCCONCIL FUNC_DEB,
         M.VALOR
    FROM PCMOVCR M
    LEFT JOIN PCBANCO B ON M.CODBANCO = B.CODBANCO
   WHERE M.DTESTORNO IS NULL
     AND M.ESTORNO <> 'S'
        /*NAO TRAZER MOVIMENTACOES ESTORNADAS*/
     AND M.CODCOB = 'D'
        /*SOMENTE TRANSACOES COM DINHERO*/
     AND M.TIPO = 'D'
        /*NESSE PRIMEIRO MOMENTO TRAZER LAN�AMENTOS DE DEBITO*/
     AND M.CODROTINALANC IN (632, 643)
        /*LANCAMENTOS SOMENTE COM MOVIMENTACAO ENTRE CAIXAS*/
     AND M.CODBANCO NOT IN (17, 20, 35, 50, 52, 53, 54)
  /*BANCOS DE BONIFICACAO E ACERTO MOTORISTA E EXTRAVIO DE MERCADORIA*/
  )
SELECT C.DATA_CRED,
       D.DATA_DEB,
       C.NUMTRANS,
       C.NUMSEQ_CRED,
       D.NUMSEQ_DEB,
       D.CODBANCODEB,
       D.BANCODEB,
       C.CODBANCOCRED,
       C.BANCOCRED,
       D.FUNC_DEB,
       C.FUNC_CRED,
       C.CODCOB,
       C.VALOR
  FROM PCMOVCR_CREDITO C
 INNER JOIN PCMOVCR_DEBITO D ON C.NUMTRANS = D.NUMTRANS
 WHERE D.DATA_DEB <> C.DATA_CRED;
/
