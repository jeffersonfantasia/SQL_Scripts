--RODAR A 507 FILIAL 3 PARAMETRO 14 REGIAO 5
--DEPOIS RODAR 552 PARAMETRO 1 REGIAO 5

/*
----------CALCULO DE MARGEM------------
PrecoVenda = (PrecoCompra - CustoLiq) / CMV;
PercCustoLiq =   (CustoLiq/PrecoVenda);
Margem =  1 - (PercCustoLiq + CMV);
*/

SELECT *
  FROM (SELECT E.CODFILIAL,
               E.CODPROD,
               P.DESCRICAO,
               P.IMPORTADO,
               P.CODFORNEC,
               P.CODMARCA,
               M.MARCA,
               T.NUMREGIAO,
               R.REGIAO,
               ROUND(T.MARGEM, 4) MIDEAL,
               ROUND((((T.PVENDA - NVL(E.CUSTOPROXIMACOMPRA, 0) -
                     (T.PVENDA * (B.CODICMTAB / 100))) /
                     (DECODE(T.PVENDA, 0, 1, T.PVENDA))) * 100),
                     2) MPRECO,
               CASE
                 WHEN (B.CODICMTAB = 0 OR (L.PBRUTO - L.PLIQUIDO) = 0) THEN
                  0
                 ELSE
                  ROUND((1 -
                        (( --% CUSTO LIQUIDO
                         L.PLIQUIDO --CUSTO LIQUIDO
                         / ((L.PBRUTO - L.PLIQUIDO) / (B.CODICMTAB / 100)) --PRECO DE VENDA
                        ) + (B.CODICMTAB / 100)) --%CMV
                        ),
                        4)
               END AS MSUGERIDA,
               ROUND(L.PBRUTO, 4) PBRUTO,
               ROUND(NVL(E.CUSTOPROXIMACOMPRA, 0), 4) CUSTOPROXCOMPRA,
               ROUND(L.PLIQUIDO, 4) AS CUSTOLIQAPLIC,
               B.CODICMTAB,
               B.CODST,
               CASE
                 WHEN B.CODICMTAB = 0 THEN
                  ROUND(L.PBRUTO, 4)
                 ELSE
                  ROUND((L.PBRUTO - L.PLIQUIDO) / (B.CODICMTAB / 100), 4)
               END AS PSUGERIDO,
               ROUND(T.PVENDA, 4) AS PVENDA
          FROM PCEST E
          JOIN PCPRODUT P ON P.CODPROD = E.CODPROD
          JOIN PCMARCA M ON M.CODMARCA = P.CODMARCA
          JOIN PCTABPR T ON T.CODPROD = E.CODPROD
          JOIN PCREGIAO R ON R.NUMREGIAO = T.NUMREGIAO
          JOIN PCTABTRIB I ON I.UFDESTINO = R.UF
                          AND I.CODFILIALNF = E.CODFILIAL
                          AND I.CODPROD = E.CODPROD
          JOIN PCTRIBUT B ON B.CODST = I.CODST
          JOIN VIEW_JC_CUSTOLIQ_240 L ON L.CODPROD = E.CODPROD
                                     AND L.CODFILIAL = E.CODFILIAL
         WHERE E.CODFILIAL = '7'
           AND T.NUMREGIAO = 5
           AND P.DTEXCLUSAO IS NULL
           AND P.CODMARCA <> 255 --KITS
           AND L.PBRUTO > 0
           AND L.PLIQUIDO > 0 --AND P.CODPROD = 814410
        )
 WHERE PSUGERIDO <> PVENDA
 ORDER BY CODMARCA;



--RODAR A 507 FILIAL 3 PARAMETRO 14 REGIAO 5
--DEPOIS RODAR 552 PARAMETRO 1 REGIAO 5
SELECT *
  FROM (SELECT P.CODFILIAL,
               P.CODPROD,
               P.DESCRICAO,
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
               ROUND(NVL(E.CUSTOPROXIMACOMPRA,0), 4) CUSTOPROXCOMPRA,
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
         JOIN PCEST E ON P.CODPROD = E.CODPROD
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
