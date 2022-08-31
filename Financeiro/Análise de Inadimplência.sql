WITH VENDEDORES AS
 (SELECT U.CODUSUR, U.USURDIRFV AS VENDEDOR, V.CODGERENTE
    FROM PCUSUARI U
    LEFT JOIN PCSUPERV V ON V.CODSUPERVISOR = U.CODSUPERVISOR
    LEFT JOIN PCGERENTE G ON V.CODGERENTE = G.CODGERENTE
   WHERE V.CODGERENTE IN (1, 8, 9, 10)),
CLIENTES AS
 (SELECT C.CODCLI,
         (CASE
           WHEN C.CODREDE IS NULL THEN
            ('C' || C.CODCLI)
           ELSE
            ('R' || C.CODREDE)
         END) AS CODCLIREDE,
         (CASE
           WHEN C.CODREDE IS NULL THEN
            ('C' || C.CODCLI || ' - ' || C.CLIENTE)
           ELSE
            ('R' || C.CODREDE || ' - ' ||
            (SELECT UPPER(R.DESCRICAO)
                FROM PCREDECLIENTE R
               WHERE C.CODREDE = R.CODREDE))
         END) AS CLIENTE_REDE,
         (C.CODCLI || ' - ' || C.CLIENTE) CLIENTE,
         C.BLOQUEIODEFINITIVO AS BLOQ_DEFINITIVO,
         C.CODUSUR1 CODUSUR,
         V.VENDEDOR
    FROM PCCLIENT C
   INNER JOIN VENDEDORES V ON C.CODUSUR1 = V.CODUSUR),
DIAS_UTEIS AS
 (SELECT D.DATA,
         D.DIAFINANCEIRO,
         (SELECT MIN(D2.DATA) DATA
            FROM PCDIASUTEIS D2
           WHERE D2.DIAFINANCEIRO = 'S'
             AND D.DATA <= D2.DATA
             AND D2.CODFILIAL = D.CODFILIAL) AS DTVENC_UTIL
    FROM PCDIASUTEIS D
   WHERE D.CODFILIAL = '1'),
TITULOS_ABERTO AS
 (SELECT DISTINCT C.CODCLIREDE,
                  SUM(NVL(T.VALOR, 0) - NVL(T.VALORDESC, 0) + NVL(T.TXPERM, 0)) OVER(PARTITION BY C.CODCLIREDE) VL_A_VENCER
    FROM PCPREST T
   INNER JOIN CLIENTES C ON T.CODCLI = C.CODCLI
   INNER JOIN DIAS_UTEIS D ON T.DTVENC = D.DATA
   WHERE T.CODFILIAL = '2'
     AND T.DTPAG IS NULL
     AND D.DTVENC_UTIL >= TRUNC(SYSDATE)),
TITULOS_VENCIDOS AS
 (SELECT DISTINCT C.CODCLIREDE,
                  SUM(NVL(T.VALOR, 0) - NVL(T.VALORDESC, 0) + NVL(T.TXPERM, 0)) OVER(PARTITION BY C.CODCLIREDE) VLVENC_TOTAL
    FROM PCPREST T
   INNER JOIN CLIENTES C ON T.CODCLI = C.CODCLI
   INNER JOIN DIAS_UTEIS D ON T.DTVENC = D.DATA
   WHERE T.CODFILIAL = '2'
     AND T.DTPAG IS NULL
     AND D.DTVENC_UTIL < TRUNC(SYSDATE)),
MAIOR_DATA_OCORRENCIA AS
 (SELECT L.NUMTRANSVENDA, L.PREST, MAX(L.DATA) MAX_DATA
    FROM PCLOGCOBMAG L
   GROUP BY L.NUMTRANSVENDA, L.PREST),
MAIOR_VL_DESPESAS_OCORRENCIA AS
 (SELECT L.NUMTRANSVENDA,
         L.PREST,
         T.MAX_DATA,
         MAX(L.VLDESPESAS) MAX_DESPESAS
    FROM PCLOGCOBMAG L
    JOIN MAIOR_DATA_OCORRENCIA T ON L.NUMTRANSVENDA = T.NUMTRANSVENDA
                                AND L.PREST = T.PREST
                                AND L.DATA = T.MAX_DATA
   GROUP BY L.NUMTRANSVENDA, L.PREST, T.MAX_DATA),
OCORRENCIAS AS
 (SELECT L.NUMTRANSVENDA, L.PREST, L.DATA, L.CODOCORRENCIA, B.OCORRENCIA
    FROM PCLOGCOBMAG L
    JOIN MAIOR_VL_DESPESAS_OCORRENCIA T ON L.NUMTRANSVENDA = T.NUMTRANSVENDA
                                       AND L.PREST = T.PREST
                                       AND L.DATA = T.MAX_DATA
                                       AND L.VLDESPESAS = T.MAX_DESPESAS
    JOIN PCOCORBC B ON L.CODOCORRENCIA = B.CODOCORRENCIA
                   AND L.CODBANCO = B.NUMBANCO),
COBRANCA_MAIS_RECENTE AS
 (SELECT DISTINCT MAX(B.NUMREGCOB) OVER (PARTITION BY I.NUMTRANSVENDA, I.PREST) NUMREGCOB_MAX,
          CASE WHEN B.CODSTATUSCOB IS NULL THEN MIN(B.CODSTATUSCOB) OVER (PARTITION BY I.NUMTRANSVENDA, I.PREST)
            ELSE LAST_VALUE(B.CODSTATUSCOB) IGNORE NULLS OVER (PARTITION BY I.NUMTRANSVENDA, I.PREST ORDER BY B.DATA) END CODSTATUSCOB,
          I.NUMTRANSVENDA, 
          I.PREST
    FROM PCHISTCOB B
   INNER JOIN PCHISTCOBI I ON B.NUMREGCOB = I.NUMREGCOB),
COBRANCAS AS
 (SELECT DISTINCT B.DATA DATAHORA,
         (CASE
           WHEN B.TIPOCONTATO = 'T' THEN
            'TELEFONE'
           WHEN B.TIPOCONTATO = 'C' THEN
            'CARTA'
           WHEN B.TIPOCONTATO = 'E' THEN
            'EMAIL'
           WHEN B.TIPOCONTATO = 'P' THEN
            'PESSOALMENTE'
           WHEN B.TIPOCONTATO = 'F' THEN
            'FAX'
           WHEN B.TIPOCONTATO = 'R' THEN
            'COBRAN�A TERCEIRA'
           WHEN B.TIPOCONTATO = 'J' THEN
            'COBRAN�A JUDICIAL'
         END) TIPOCONTATO,
         I.NUMTRANSVENDA,
         I.PREST,
         I.ATRASO,
         M.CODSTATUSCOB,
         COALESCE(B.OBS3, C.STATUSCOB, B.OBS2, B.OBS1) OBSERVACAO
    FROM PCHISTCOB B
   INNER JOIN COBRANCA_MAIS_RECENTE M ON B.NUMREGCOB = M.NUMREGCOB_MAX
   INNER JOIN PCHISTCOBI I ON B.NUMREGCOB = I.NUMREGCOB
                          AND I.NUMTRANSVENDA = M.NUMTRANSVENDA
                          AND I.PREST = M.PREST
    LEFT JOIN PCSTATUSCOBCLI C ON I.CODSTATUSCOB = C.CODSTATUSCOB)
SELECT *
  FROM (SELECT C.CLIENTE_REDE,
               C.CLIENTE,
               DECODE(C.BLOQ_DEFINITIVO, 'S', 'SIM', 'NAO') BLOQ_DEFINITIVO,
               C.CODUSUR,
               C.VENDEDOR,
               (P.DUPLIC || '-' || P.PREST) DUPLICATA,
               P.DTEMISSAO,
               D.DTVENC_UTIL DTVENC,
               P.CODCOB, 
               B.CODSTATUSCOB,
               (NVL(P.VALOR, 0) - NVL(P.VALORDESC, 0) + NVL(P.TXPERM, 0)) AS VALOR,
               (TRUNC(SYSDATE) - D.DTVENC_UTIL + 1) DIAS_VENCIDO,
               (CASE
                 WHEN (TRUNC(SYSDATE) - D.DTVENC_UTIL + 1) > 720 AND
                      P.CODCOB = 'JUR' AND (B.CODSTATUSCOB NOT IN ( 41,42,43)) THEN
                  13
                 WHEN B.CODSTATUSCOB = 42 THEN
                  11
                 WHEN B.CODSTATUSCOB = 41 THEN
                  10
                 WHEN B.CODSTATUSCOB = 43 THEN
                  9
                 WHEN (TRUNC(SYSDATE) - D.DTVENC_UTIL + 1) > 720 THEN
                  12
                 WHEN O.CODOCORRENCIA = '21' THEN
                  3
                 WHEN (TRUNC(SYSDATE) - D.DTVENC_UTIL + 1) > 75 AND
                      P.CODCOB <> 'JUR' THEN
                  8
                 WHEN (TRUNC(SYSDATE) - D.DTVENC_UTIL + 1) > 45 AND
                      P.CODCOB <> 'JUR' THEN
                  7
                 WHEN O.CODOCORRENCIA = '32' THEN
                  6
                 WHEN NVL(P.PROTESTO, 'N') = 'S' AND O.CODOCORRENCIA <> '32' AND
                      P.CODCOB <> 'JUR' THEN
                  5
                 WHEN NVL(P.CARTORIO, 'N') = 'S' AND O.CODOCORRENCIA <> '32' AND
                      P.CODCOB <> 'JUR' THEN
                  4
                 WHEN (TRUNC(SYSDATE) - D.DTVENC_UTIL + 1) > 5 AND
                      P.CODCOB = 'BK' THEN
                  2
                 WHEN (((TRUNC(SYSDATE) - D.DTVENC_UTIL + 1) > 0 OR
                      P.CODCOB = 'C')) AND P.CODCOB <> 'JUR' THEN
                  1
                 ELSE
                  99
               END) CODSTATUS,
               (CASE
                 WHEN (TRUNC(SYSDATE) - D.DTVENC_UTIL + 1) > 720 AND
                      P.CODCOB = 'JUR' AND (B.CODSTATUSCOB NOT IN ( 41,42,43)) THEN
                  '13-BAIXAR JUROS PENDENTE E BLOQUEAR DEFINITIVO CLIENTE'
                 WHEN B.CODSTATUSCOB = 42 THEN
                  '11-TITULO COM O JUR�DICO'
                 WHEN B.CODSTATUSCOB = 41 THEN
                  '10-TITULO ENVIADO PARA COBRAN�A EXTERNA'
                 WHEN B.CODSTATUSCOB = 43 THEN
                  '09-TITULO NEGOCIADO COM DATA PARA RECEBIMENTO'
                 WHEN (TRUNC(SYSDATE) - D.DTVENC_UTIL + 1) > 720 THEN
                  '12-VERIFICAR BAIXA COMO PERDA E BLOQUEAR DEFINITIVO CLIENTE'
                 WHEN O.CODOCORRENCIA = '21' THEN
                  '03-NEGOCIAR COM CLIENTE - TIT. NAO PROTESTADO'
                 WHEN (TRUNC(SYSDATE) - D.DTVENC_UTIL + 1) > 75 AND
                      P.CODCOB <> 'JUR' THEN
                  '08-VERIFICAR ENVIO AREA JURIDICA'
                 WHEN (TRUNC(SYSDATE) - D.DTVENC_UTIL + 1) > 45 AND
                      P.CODCOB <> 'JUR' THEN
                  '07-VERIFICAR ENVIO PARA COBRAN�A EXTERNA'
                 WHEN O.CODOCORRENCIA = '32' AND P.CODCOB <> 'JUR' THEN
                  '06-NEGOCIAR COM CLIENTE APOS PROTESTO'
                 WHEN NVL(P.PROTESTO, 'N') = 'S' AND O.CODOCORRENCIA <> '32' AND
                      P.CODCOB <> 'JUR' THEN
                  '05-TITULO PROTESTADO'
                 WHEN NVL(P.CARTORIO, 'N') = 'S' AND O.CODOCORRENCIA <> '32' AND
                      P.CODCOB <> 'JUR' THEN
                  '04-TITULO EM CART�RIO'
                 WHEN (TRUNC(SYSDATE) - D.DTVENC_UTIL + 1) > 5 AND
                      P.CODCOB = 'BK' THEN
                  '02-PRESTES A ENTRAR EM CARTORIO'
                 WHEN (((TRUNC(SYSDATE) - D.DTVENC_UTIL + 1) > 0 OR
                      P.CODCOB = 'C')) AND P.CODCOB <> 'JUR' THEN
                  '01-ENTRAR EM CONTATO COM CLIENTE'
                 ELSE
                  '99-FALTA PARAMETRIZAR'
               END) STATUS,
               DECODE(NVL(P.CARTORIO, 'N'), 'N', 'NAO', 'SIM') CARTORIO,
               DECODE(NVL(P.PROTESTO, 'N'), 'N', 'NAO', 'SIM') PROTESTO,
               B.DATAHORA,
               COALESCE(P.OBSTITULO, B.OBSERVACAO) OBSERVACAO,
               B.ATRASO,
               B.TIPOCONTATO,
               (O.CODOCORRENCIA || '-' || O.OCORRENCIA) OCORRENCIA,
               V.VLVENC_TOTAL,
               NVL(A.VL_A_VENCER, 0) VL_A_VENCER
          FROM PCPREST P
         INNER JOIN DIAS_UTEIS D ON P.DTVENC = D.DATA
         INNER JOIN CLIENTES C ON P.CODCLI = C.CODCLI
         INNER JOIN TITULOS_VENCIDOS V ON C.CODCLIREDE = V.CODCLIREDE
          LEFT JOIN TITULOS_ABERTO A ON A.CODCLIREDE = V.CODCLIREDE
          LEFT JOIN OCORRENCIAS O ON P.NUMTRANSVENDA = O.NUMTRANSVENDA
                                 AND P.PREST = O.PREST
          LEFT JOIN COBRANCAS B ON P.NUMTRANSVENDA = B.NUMTRANSVENDA
                               AND P.PREST = B.PREST
         WHERE P.DTPAG IS NULL
           AND (TRUNC(SYSDATE) - D.DTVENC_UTIL) > 0)
--WHERE  CODSTATUS IN  ([CODSTATUS])      
 ORDER BY CODSTATUS, DTVENC DESC, CLIENTE_REDE;
