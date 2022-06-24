WITH VENDEDORES AS
 (SELECT U.CODUSUR, U.USURDIRFV AS VENDEDOR, V.CODGERENTE
    FROM PCUSUARI U
    LEFT JOIN PCSUPERV V ON V.CODSUPERVISOR = U.CODSUPERVISOR
    LEFT JOIN PCGERENTE G ON V.CODGERENTE = G.CODGERENTE),
CLIENTES AS
 (SELECT C.CODCLI,
         (CASE
           WHEN R.DESCRICAO IS NULL THEN
            ('C' || C.CODCLI)
           ELSE
            ('R' || C.CODREDE)
         END) AS CODCLIREDE,
         (CASE
           WHEN R.DESCRICAO IS NULL THEN
            ('C' || C.CODCLI || ' - ' || C.CLIENTE)
           ELSE
            ('R' || C.CODREDE || ' - ' || UPPER(R.DESCRICAO))
         END) AS CLIENTE_REDE,
         (C.CODCLI || ' - ' || C.CLIENTE) CLIENTE,
         C.BLOQUEIODEFINITIVO AS BLOQ_DEFINITIVO,
         C.CODUSUR1 CODUSUR,
         V.VENDEDOR
    FROM PCCLIENT C
    LEFT JOIN PCREDECLIENTE R ON C.CODREDE = R.CODREDE
   INNER JOIN VENDEDORES V ON C.CODUSUR1 = V.CODUSUR
   WHERE V.CODGERENTE IN (1, 8, 9, 10)),
DIAS_UTEIS AS
 (SELECT D.DATA,
         D.DIAFINANCEIRO,
         (SELECT MIN(D2.DATA) DATA
            FROM PCDIASUTEIS D2
           WHERE D2.DIAFINANCEIRO = 'S'
             AND D.DATA <= D2.DATA
             AND D2.CODFILIAL = D.CODFILIAL) AS DTVENC_UTIL
    FROM PCDIASUTEIS D
   WHERE CODFILIAL = 1),
TITULOS AS
 (SELECT C.CODCLIREDE,
         T.DTPAG,
         T.DTVENC,
         D.DTVENC_UTIL,
         T.VALOR,
         T.NUMTRANSVENDA,
         T.PREST,
         T.CODCOB
    FROM PCPREST T
   INNER JOIN CLIENTES C ON T.CODCLI = C.CODCLI
   INNER JOIN DIAS_UTEIS D ON T.DTVENC = D.DATA
   WHERE T.CODFILIAL = 2),
TITULOS_ABERTO AS
 (SELECT T.CODCLIREDE, SUM(T.VALOR) VL_A_VENCER
    FROM TITULOS T
   WHERE T.DTPAG IS NULL
     AND T.DTVENC_UTIL >= TRUNC(SYSDATE)
   GROUP BY T.CODCLIREDE),
TITULOS_VENCIDOS AS
 (SELECT T.CODCLIREDE, SUM(T.VALOR) VLVENC_TOTAL
    FROM TITULOS T
   WHERE T.DTPAG IS NULL
     AND T.DTVENC_UTIL < TRUNC(SYSDATE)
   GROUP BY T.CODCLIREDE),
MAIOR_OCORRENCIA AS
 (SELECT T.NUMTRANSVENDA,
         T.PREST,
         MAX(L.DATA) DATA_MAIOR,
         MAX(B.CODOCORRENCIA) CODOCORRENCIA_MAX
    FROM TITULOS T
   INNER JOIN PCLOGCOBMAG L ON T.NUMTRANSVENDA = L.NUMTRANSVENDA
                           AND T.PREST = L.PREST
   INNER JOIN PCOCORBC B ON L.CODOCORRENCIA = B.CODOCORRENCIA
                        AND L.CODBANCO = B.NUMBANCO
   GROUP BY T.NUMTRANSVENDA, T.PREST),
OCORRENCIAS AS
 (SELECT DISTINCT M.NUMTRANSVENDA, M.PREST, L.CODOCORRENCIA, B.OCORRENCIA
    FROM MAIOR_OCORRENCIA M
   INNER JOIN PCLOGCOBMAG L ON M.NUMTRANSVENDA = L.NUMTRANSVENDA
                           AND M.PREST = L.PREST
                           AND M.DATA_MAIOR = L.DATA
                           AND M.CODOCORRENCIA_MAX = L.CODOCORRENCIA
   INNER JOIN PCOCORBC B ON L.CODOCORRENCIA = B.CODOCORRENCIA
                        AND L.CODBANCO = B.NUMBANCO),
COBRANCA_MAIS_RECENTE AS
 (SELECT MAX(B.NUMREGCOB) NUMREGCOB_MAX, I.NUMTRANSVENDA, I.PREST
    FROM PCHISTCOB B
   INNER JOIN PCHISTCOBI I ON B.NUMREGCOB = I.NUMREGCOB
   GROUP BY I.NUMTRANSVENDA, I.PREST),
COBRANCAS AS
 (SELECT B.DATA DATAHORA,
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
         I.CODSTATUSCOB,
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
               (NVL(P.VALOR, 0) - NVL(P.VALORDESC, 0)) AS VALOR,
               (TRUNC(SYSDATE) - D.DTVENC_UTIL) DIAS_VENCIDO,
               (CASE
                 WHEN (TRUNC(SYSDATE) - D.DTVENC_UTIL) > 720 AND
                      P.CODCOB = 'JUR' THEN
                  13
                 WHEN B.CODSTATUSCOB = 42 THEN
                  11
                 WHEN B.CODSTATUSCOB = 41 THEN
                  10
                 WHEN B.CODSTATUSCOB = 43 THEN
                  9
                 WHEN (TRUNC(SYSDATE) - D.DTVENC_UTIL) > 720 THEN
                  12
                 WHEN (TRUNC(SYSDATE) - D.DTVENC_UTIL) > 75 THEN
                  8
                 WHEN (TRUNC(SYSDATE) - D.DTVENC_UTIL) > 45 THEN
                  7
                 WHEN O.CODOCORRENCIA = '32' THEN
                  6
                 WHEN NVL(P.PROTESTO, 'N') = 'S' AND O.CODOCORRENCIA != '32' THEN
                  5
                 WHEN NVL(P.CARTORIO, 'N') = 'S' AND O.CODOCORRENCIA != '32' THEN
                  4
                 WHEN O.CODOCORRENCIA = '21' THEN
                  3
                 WHEN (TRUNC(SYSDATE) - D.DTVENC_UTIL) > 5 AND
                      P.CODCOB = 'BK' THEN
                  2
                 WHEN ((TRUNC(SYSDATE) - D.DTVENC_UTIL) > 0 OR P.CODCOB = 'C') THEN
                  1
                 ELSE
                  99
               END) CODSTATUS,
               (CASE
                 WHEN (TRUNC(SYSDATE) - D.DTVENC_UTIL) > 720 AND
                      P.CODCOB = 'JUR' THEN
                  '13-BAIXAR JUROS PENDENTE E BLOQUEAR DEFINITIVO CLIENTE'
                 WHEN B.CODSTATUSCOB = 42 THEN
                  '11-TITULO COM O JUR�DICO'
                 WHEN B.CODSTATUSCOB = 41 THEN
                  '10-TITULO ENVIADO PARA COBRAN�A EXTERNA'
                 WHEN B.CODSTATUSCOB = 43 THEN
                  '09-TITULO NEGOCIADO COM DATA PARA RECEBIMENTO'
                 WHEN (TRUNC(SYSDATE) - D.DTVENC_UTIL) > 720 THEN
                  '12-VERIFICAR BAIXA COMO PERDA E BLOQUEAR DEFINITIVO CLIENTE'
                 WHEN (TRUNC(SYSDATE) - D.DTVENC_UTIL) > 75 THEN
                  '08-VERIFICAR ENVIO AREA JURIDICA'
                 WHEN (TRUNC(SYSDATE) - D.DTVENC_UTIL) > 45 THEN
                  '07-VERIFICAR ENVIO PARA COBRAN�A EXTERNA'
                 WHEN O.CODOCORRENCIA = '32' THEN
                  '06-NEGOCIAR COM CLIENTE APOS PROTESTO'
                 WHEN NVL(P.PROTESTO, 'N') = 'S' AND O.CODOCORRENCIA != '32' THEN
                  '05-TITULO PROTESTADO'
                 WHEN NVL(P.CARTORIO, 'N') = 'S' AND O.CODOCORRENCIA != '32' THEN
                  '04-TITULO EM CART�RIO'
                 WHEN O.CODOCORRENCIA = '21' THEN
                  '03-NEGOCIAR COM CLIENTE - TIT. NAO PROTESTADO'
                 WHEN (TRUNC(SYSDATE) - D.DTVENC_UTIL) > 5 AND
                      P.CODCOB = 'BK' THEN
                  '02-PRESTES A ENTRAR EM CARTORIO'
                 WHEN ((TRUNC(SYSDATE) - D.DTVENC_UTIL) > 0 OR P.CODCOB = 'C') THEN
                  '01-ENTRAR EM CONTATO COM CLIENTE'
                 ELSE
                  '99-FALTA PARAMETRIZAR'
               END) STATUS,
               DECODE(NVL(P.CARTORIO, 'N'), 'N', 'NAO', 'SIM') CARTORIO,
               DECODE(NVL(P.PROTESTO, 'N'), 'N', 'NAO', 'SIM') PROTESTO,
               B.DATAHORA,
               B.OBSERVACAO,
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
           AND D.DTVENC_UTIL < TRUNC(SYSDATE)
           AND (TRUNC(SYSDATE) - D.DTVENC_UTIL) > 0)
 ORDER BY CODSTATUS, CLIENTE_REDE, DTVENC;
