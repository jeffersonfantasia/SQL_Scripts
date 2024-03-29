WITH VALOR_ABERTO_FORNECEDOR AS
 (SELECT L.CODFILIAL,
         L.CODFORNEC,
         SUM(NVL(L.VALOR, 0) + NVL(L.TXPERM, 0) +
             NVL(L.VLVARIACAOCAMBIAL, 0) - NVL(L.VALORDEV, 0) -
             NVL(L.DESCONTOFIN, 0)) VALOR_ABERTO
    FROM PCLANC L
   WHERE L.DTPAGTO IS NULL
     AND L.TIPOLANC = 'C'
     AND L.TIPOPARCEIRO = 'F'
   GROUP BY L.CODFILIAL, L.CODFORNEC)

SELECT *
  FROM (SELECT L.CODFILIAL,
               L.RECNUM,
               L.DTLANC,
               L.CODCONTA,
               L.CODFORNEC,
               F.FORNECEDOR,
               L.HISTORICO,
               COALESCE(L.VPAGOBORDERO, L.VPAGO) VALOR,
               NVL(L.VLRUTILIZADOADIANTFORNEC, 0) VLUTILIZADO,
               ((NVL(L.VALOR, 0) + NVL(L.TXPERM, 0) +
               NVL(L.VLVARIACAOCAMBIAL, 0) - NVL(L.VALORDEV, 0) -
               NVL(L.DESCONTOFIN, 0)) - NVL(L.VLRUTILIZADOADIANTFORNEC, 0)) VLSALDO,
               NVL(A.VALOR_ABERTO, 0) VALOR_ABERTO
          FROM PCLANC L
          JOIN PCFORNEC F ON F.CODFORNEC = L.CODFORNEC
          LEFT JOIN VALOR_ABERTO_FORNECEDOR A ON A.CODFORNEC = L.CODFORNEC
                                             AND A.CODFILIAL = L.CODFILIAL
         WHERE L.CODCONTA IN (200133, 200139)
           AND L.DTLANC > '01-01-2022'
           AND L.TIPOPARCEIRO = 'F'
           AND NVL(L.CODROTINABAIXA, 0) <> 737
           AND L.DTESTORNOBAIXA IS NULL
           AND L.DTPAGTO IS NOT NULL
         ORDER BY L.CODFILIAL, L.CODFORNEC)
 WHERE VLSALDO > 0
   AND VALOR_ABERTO > 0;