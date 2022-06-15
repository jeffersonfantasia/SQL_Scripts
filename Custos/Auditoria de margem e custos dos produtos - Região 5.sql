SELECT *
  FROM (SELECT P.CODFILIAL,
               P.CODPROD,
               P.DESCRICAO,
               T.IMPORTADO,
               T.CODMARCA,
               M.MARCA,
               P.NUMREGIAO,
               P.REGIAO,
               ROUND(P.MARGEM, 4) AS MIDEAL,
               ROUND(P.MARGEMPRECIFICACAO, 4) AS MPRECO,
               CASE
                 WHEN P.CODICMTAB = 0 THEN
                  0
                 ELSE
                  ROUND((1 -
                        (( --% CUSTO LIQUIDO
                         L.PLIQUIDO --CUSTO LIQUIDO
                         / ((L.PBRUTO - L.PLIQUIDO) / (P.CODICMTAB / 100)) --PRECO DE VENDA
                        ) + (P.CODICMTAB / 100)) --%CMV
                        ),
                        4)
               END AS MSUGERIDA,
               ROUND(L.PBRUTO, 4) PBRUTO,
               ROUND(E.CUSTOPROXIMACOMPRA, 4) CUSTOPROXCOMPRA,
               ROUND(L.PLIQUIDO, 4) AS CUSTOLIQAPLIC,
               P.CODICMTAB,
               CASE
                 WHEN P.CODICMTAB = 0 THEN
                  ROUND(L.PBRUTO, 4)
                 ELSE
                  ROUND((L.PBRUTO - L.PLIQUIDO) / (P.CODICMTAB / 100), 4)
               END AS PSUGERIDO,
               ROUND(P.PVENDA, 4) AS PVENDA
          FROM VW_PRECIFICACAO P
         INNER JOIN PCPRODUT T ON P.CODPROD = T.CODPROD
         INNER JOIN VIEW_JC_CUSTOLIQ_240 L ON P.CODPROD = L.CODPROD
                                          AND P.CODFILIAL = L.CODFILIAL
          LEFT JOIN PCEST E ON T.CODPROD = E.CODPROD
                           AND P.CODFILIAL = E.CODFILIAL
          LEFT JOIN PCMARCA M ON T.CODMARCA = M.CODMARCA
         WHERE P.CODFILIAL IN (7)
           AND P.NUMREGIAO IN (5)
           AND T.DTEXCLUSAO IS NULL
           AND T.CODMARCA != 255 --KITS
           AND L.PBRUTO > 0
           AND L.PLIQUIDO > 0
         ORDER BY T.CODMARCA)
 WHERE MIDEAL <> MSUGERIDA
    OR PSUGERIDO <> PVENDA;
/

/*
----------CALCULO DE MARGEM------------
PrecoVenda = (PrecoCompra - CustoLiq) / CMV;
PercCustoLiq =   (CustoLiq/PrecoVenda);
Margem =  1 - (PercCustoLiq + CMV);
*/
