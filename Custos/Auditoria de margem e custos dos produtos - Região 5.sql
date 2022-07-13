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
               ROUND((((NVL(T.PVENDA,0) - NVL(E.CUSTOPROXIMACOMPRA, 0) -
                     (NVL(T.PVENDA,0) * (B.CODICMTAB / 100))) /
                     (DECODE(NVL(T.PVENDA,0), 0, 1, NVL(T.PVENDA,0)))) * 100),
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
               CASE
                 WHEN B.CODICMTAB = 0 THEN
                  ROUND(L.PBRUTO, 4)
                 ELSE
                  ROUND((L.PBRUTO - L.PLIQUIDO) / (B.CODICMTAB / 100), 4)
               END AS PSUGERIDO,
               ROUND(NVL(T.PVENDA,0), 4) AS PVENDA
          FROM PCEST E
          JOIN PCPRODUT P ON P.CODPROD = E.CODPROD
          JOIN PCMARCA M ON M.CODMARCA = P.CODMARCA
          LEFT JOIN PCTABPR T ON T.CODPROD = E.CODPROD
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