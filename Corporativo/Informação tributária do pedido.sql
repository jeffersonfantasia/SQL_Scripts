WITH TRIBUTA AS (
    SELECT CODST,
           SITTRIBUT AS CST,
           SITTRIBUTPF AS CST_PF,
           SITTRIBUTBONIFIC AS CST_BONIF,
           SITTRIBUTTV7 AS CST_ENTFUT,
    /*ENTFUT*/
           SITTRIBUTTV8 AS CST_ENTREGA_ENTFUT,
    /*ENTFUT*/
           SITTRIBUTTV7ORDEM AS CST_CONTAORDEM,
    /*ENTFUT*/
           SITTRIBUTTV8ORDEM AS CST_ENTREGA_CONTAORDEM,
    /*ENTFUT*/
           CODFISCAL AS CFOP,
           CODFISCALINTER AS CFOP_INTER,
           CODFISCALPF AS CFOP_PF,
           CODFISCALINTERPF AS CFOP_PF_INTER,
           CODFISCALBONIFIC AS CFOP_BONIF,
           CODFISCALBONIFICINTER AS CFOP_BONIF_INTER,
           CODFISCALVENDAENTFUT AS CFOP_ENT_FUT,
     /*TV7 ENTFUT*/
           CODFISCALVENDAENTFUTINTER AS CFOP_ENT_FUT_INTER,
     /*TV7 ENTFUT*/
           CODFISCALSIMPENTFUT AS CFOP_ENTREGA_ENT_FUT,
     /*TV8 ENTFUT*/
           CODFISCALSIMPENTFUTINTER AS CFOP_ENTREGA_ENT_FUT_INTER,
     /*TV8 ENTFUT*/
           CODFISCALCONTAORDEM AS CFOP_CONTA_ORDEM,
     /*TV7 CONTAORDEM*/
           CODFISCALCONTAORDEMINTER AS CFOP_CONTA_ORDEM_INTER,
     /*TV7 CONTAORDEM*/
           CODFISCALCONTAORDEMSIMPENT AS CFOP_ENTREGA_CONTA_ORDEM,
     /*TV8 CONTAORDEM*/
           CODFISCALCONTAORDEMSIMPENTINTE AS CFOP_ENTREGA_CONTA_ORDEM_INTER
     /*TV8 CONTAORDEM*/
      FROM PCTRIBUT
)
SELECT C.CODCLI,
       T.CLIENTE,
       T.ESTCOB AS UF,
       T.CONSUMIDORFINAL AS CONS_FINAL,
       C.CONDVENDA,
       I.CODST AS CODTRIB,
       I.CODPROD,
       P.DESCRICAO AS PRODUTO,
       P.NBM AS NCM,
       L.ORIGEMMERTRIB AS ORIGEM,
       (
           CASE
               WHEN C.CONDVENDA = 5         THEN B.CST_BONIF
               WHEN C.CONDVENDA = 7
                  AND C.CONTAORDEM = 'N' THEN B.CST_ENTFUT
               WHEN C.CONDVENDA = 8
                  AND C.CONTAORDEM = 'N' THEN B.CST_ENTREGA_ENTFUT
               WHEN C.CONDVENDA = 7
                  AND C.CONTAORDEM = 'S' THEN B.CST_CONTAORDEM
               WHEN C.CONDVENDA = 8
                  AND C.CONTAORDEM = 'S' THEN B.CST_ENTREGA_CONTAORDEM
               WHEN T.CONSUMIDORFINAL = 'S' THEN CST_PF
               ELSE B.CST
           END
       ) AS CST,
       (
           CASE
               WHEN C.CONDVENDA = 5
                  AND T.ESTCOB = 'SP' THEN B.CFOP_BONIF
               WHEN C.CONDVENDA = 5
                  AND T.ESTCOB <> 'SP' THEN B.CFOP_BONIF_INTER
               WHEN C.CONDVENDA = 7
                  AND C.CONTAORDEM = 'N'
                  AND T.ESTCOB = 'SP' THEN B.CFOP_ENT_FUT
               WHEN C.CONDVENDA = 7
                  AND C.CONTAORDEM = 'N'
                  AND T.ESTCOB <> 'SP' THEN B.CFOP_ENT_FUT_INTER
               WHEN C.CONDVENDA = 8
                  AND C.CONTAORDEM = 'N'
                  AND T.ESTCOB = 'SP' THEN B.CFOP_ENTREGA_ENT_FUT
               WHEN C.CONDVENDA = 8
                  AND C.CONTAORDEM = 'N'
                  AND T.ESTCOB <> 'SP' THEN B.CFOP_ENTREGA_ENT_FUT_INTER
               WHEN C.CONDVENDA = 7
                  AND C.CONTAORDEM = 'S'
                  AND T.ESTCOB = 'SP' THEN B.CFOP_CONTA_ORDEM
               WHEN C.CONDVENDA = 7
                  AND C.CONTAORDEM = 'S'
                  AND T.ESTCOB <> 'SP' THEN B.CFOP_CONTA_ORDEM_INTER
               WHEN C.CONDVENDA = 8
                  AND C.CONTAORDEM = 'S'
                  AND T.ESTCOB = 'SP' THEN B.CFOP_ENTREGA_CONTA_ORDEM
               WHEN C.CONDVENDA = 8
                  AND C.CONTAORDEM = 'S'
                  AND T.ESTCOB <> 'SP' THEN B.CFOP_ENTREGA_CONTA_ORDEM_INTER
               WHEN C.CONDVENDA = 1
                  AND T.CONSUMIDORFINAL = 'S'
                  AND T.ESTCOB = 'SP' THEN B.CFOP_PF
               WHEN C.CONDVENDA = 1
                  AND T.CONSUMIDORFINAL = 'S'
                  AND T.ESTCOB <> 'SP' THEN B.CFOP_PF_INTER
               WHEN C.CONDVENDA = 1
                  AND T.CONSUMIDORFINAL = 'N'
                  AND T.ESTCOB = 'SP' THEN B.CFOP
               ELSE B.CFOP_INTER
           END
       ) AS CFOP,
       I.QT,
       ROUND ((I.PVENDA - I.ST), 4) AS PLIQ,
       I.ST AS VLST,
       I.PVENDA AS PBRUTO
  FROM PCPEDI I
 INNER JOIN PCPEDC C ON I.NUMPED = C.NUMPED
 INNER JOIN TRIBUTA B ON I.CODST = B.CODST
 INNER JOIN PCPRODFILIAL L ON I.CODPROD = L.CODPROD
  LEFT JOIN PCCLIENT T ON C.CODCLI = T.CODCLI
  LEFT JOIN PCPRODUT P ON I.CODPROD = P.CODPROD
 WHERE C.CODFILIAL = L.CODFILIAL
   AND I.NUMPED = 14008691;