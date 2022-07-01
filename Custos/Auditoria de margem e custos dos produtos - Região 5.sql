--RODAR A 507 FILIAL 3 PARAMETRO 14 REGIAO 5
--DEPOIS RODAR 552 PARAMETRO 1 REGIAO 5
SELECT *
  FROM (SELECT P.CODFILIAL,
               P.CODPROD,
               P.DESCRICAO,
              -- (SELECT SUM(QTEST) FROM PCEST WHERE CODPROD = E.CODPROD) QT,
               T.IMPORTADO,
               P.CODFORNEC,
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
         JOIN PCPRODUT T ON P.CODPROD = T.CODPROD
         JOIN PCMARCA M ON T.CODMARCA = M.CODMARCA
         JOIN VIEW_JC_CUSTOLIQ_240 L ON P.CODPROD = L.CODPROD
                                          AND P.CODFILIAL = L.CODFILIAL
          LEFT JOIN PCEST E ON T.CODPROD = E.CODPROD
                           AND P.CODFILIAL = E.CODFILIAL
         
         WHERE P.CODFILIAL = '7'
           AND P.NUMREGIAO = 5 
           AND T.DTEXCLUSAO IS NULL
           AND T.CODMARCA <> 255 --KITS
           AND L.PBRUTO > 0
           AND L.PLIQUIDO > 0 --AND P.CODPROD = 801134
         ORDER BY T.CODMARCA)
 WHERE PSUGERIDO <> PVENDA;
/

/*
----------CALCULO DE MARGEM------------
PrecoVenda = (PrecoCompra - CustoLiq) / CMV;
PercCustoLiq =   (CustoLiq/PrecoVenda);
Margem =  1 - (PercCustoLiq + CMV);
*/
