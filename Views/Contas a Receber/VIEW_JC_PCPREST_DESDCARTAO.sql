CREATE OR REPLACE VIEW VIEW_JC_PCPREST_DESDCARTAO AS
WITH PREST_AGRUPADA AS
 (SELECT NUMTRANSVENDA, MAX(DTCANCEL) MAXDTCANCEL
    FROM PCPREST
   GROUP BY NUMTRANSVENDA
  HAVING MAX(DTCANCEL) IS NULL), --ASSIM CONSEGUIREMOS RETIRAR DESDOBRAMENTO QUE TIVERAM SUA VENDA CANCELADA APOS O DESDOBRAMENTO
PCCLIENT_CONTABIL AS
 (SELECT B.CODCOB, C.CODCONTAB
    FROM PCCOB B
   INNER JOIN PCCLIENT C
      ON C.CODCLI = B.CODCLICC
   WHERE B.CARTAO = 'S'), --PARA TERMOS A INFORMACAO DO CODCONTAB DOS CARTOES/ MKT NA TABELA PCCLIENT
CLIENTE_MKTPLACE AS
 (SELECT CODCLICC
    FROM PCCOB
   WHERE CARTAO = 'S') --INFORMACOES DOS CODCLI DOS MARKETPLACES E CARTOES PARA DEPOIS DESCONSIDERARMOS ESSAS DUPLICATAS DESDOBRADAS
SELECT T.CODFILIAL,
       T.CODCOBORIG,
       T.CODCOB,
       L.CODCONTAB,
       T.DTEMISSAO AS DATA,
       T.NUMTRANSVENDA,
       SUM(T.VALOR) AS VALOR,
       ('NF ' || T.DUPLIC || ' - ' || C.CLIENTE) AS HISTORICO --PARA TRAZERMOS A INFORMA��O DO CLIENTE DA VENDA ORIGINAL
  FROM PCPREST T
 INNER JOIN PREST_AGRUPADA G
    ON T.NUMTRANSVENDA = G.NUMTRANSVENDA
 INNER JOIN PCCLIENT_CONTABIL L
    ON T.CODCOBORIG = L.CODCOB
  LEFT JOIN PCCLIENT C
    ON T.CODCLI = C.CODCLI
  LEFT JOIN CLIENTE_MKTPLACE K
    ON T.CODCLI = K.CODCLICC
 WHERE T.NUMTRANS IS NULL
   AND T.DTDESD IS NOT NULL
   AND T.DTPAG IS NOT NULL
   AND T.VALORESTORNO IS NULL
   AND T.DTESTORNO IS NULL
   AND K.CODCLICC IS NULL -- N�O CONSIDERAR DUPLICATAS J� DESDOBRADAS PARA O CART�O/MRT QUE TENHAM SOFRIDO NOVO DESDOBRAMENTO
 GROUP BY T.CODFILIAL,
          T.DUPLIC,
          T.CODCOBORIG,
          T.CODCOB,
          C.CLIENTE,
          L.CODCONTAB,
          T.DTEMISSAO,
          T.NUMTRANSVENDA
--PARA QUE O VALOR DAS PARCELAS SEJA AGRUPADO NA FORMA DE SOMA, DANDO O MESMO VALOR DA NOTA FATURADA SE N�O HOUVER USO DO CREDITO NA VENDA
;