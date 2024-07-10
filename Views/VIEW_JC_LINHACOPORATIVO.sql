CREATE OR REPLACE VIEW VIEW_JC_LINHACORPORATIVO AS 
WITH CUSTO_FILIAL_SN AS
 (SELECT CODPROD,
         PLIQCOMPRA AS PRECOLIQ_SN,
         PBRUTO AS PRECOBRUTO_SN,
         PLIQUIDO AS CUSTOLIQUIDO_SN,
         (PERPIS + PERCOFINS) AS PISCOFINS_SN,
         PERIPI AS IPI_SN,
         PERCICM AS ICMS_SN
    FROM VIEW_JC_CUSTOLIQ_CORP
   WHERE CODFILIAL = 6),
PRECO_LUCROREAL AS
 (SELECT CODPROD,
         PVENDA AS PRECOVENDA_LC,
         ROUND(MARGEMPRECIFICACAO, 2) / 100 AS MARGEM_LC
    FROM VW_PRECIFICACAO
   WHERE (NUMREGIAO = 2 AND CODFILIAL = 3)),
PRECO_SIMPLES AS
 (SELECT CODPROD,
         PVENDA AS PRECOVENDA_SN,
         ROUND(MARGEMPRECIFICACAO, 2) / 100 AS MARGEM_SN
    FROM VW_PRECIFICACAO
   WHERE (NUMREGIAO = 6 AND CODFILIAL = 6)),
TRIBUT_VENDA_LC AS
 (SELECT B.CODPROD,
         T.CODICM / 100 AS ICMSVENDA_LC,
         (P.PERCPIS + P.PERCCOFINS) / 100 AS PISCOFINSVENDA_LC,
         T.CODICMTAB / 100 AS CMV_LC
    FROM PCTABTRIB B
    LEFT JOIN PCTRIBUT T ON B.CODST = T.CODST
    LEFT JOIN PCTRIBPISCOFINS P ON B.CODTRIBPISCOFINS = P.CODTRIBPISCOFINS
   WHERE B.CODFILIALNF = '3'
     AND B.UFDESTINO = 'SP'),
TRIBUT_VENDA_SN AS
 (SELECT B.CODPROD,
         B.UFDESTINO,
         T.CODICM / 100 AS ICMSVENDA_SN,
         (P.PERCPIS + P.PERCCOFINS) / 100 AS PISCOFINSVENDA_SN,
         T.CODICMTAB / 100 AS CMV_SN
    FROM PCTABTRIB B
    LEFT JOIN PCTRIBUT T ON B.CODST = T.CODST
    LEFT JOIN PCTRIBPISCOFINS P ON B.CODTRIBPISCOFINS = P.CODTRIBPISCOFINS
   WHERE B.CODFILIALNF = '6'
     AND B.UFDESTINO = 'SP'),
TRIBUT_ST_ESTADOS AS
 (SELECT B.CODPROD,
         B.UFDESTINO AS UF,
         (NVL(T.ALIQICMS1, 0) - NVL(T.ALIQICMS2, 0)) / 100 AS PERCDIFALIQ
    FROM PCTABTRIB B
    LEFT JOIN PCTRIBUT T ON B.CODST = T.CODST
    LEFT JOIN PCTRIBPISCOFINS P ON B.CODTRIBPISCOFINS = P.CODTRIBPISCOFINS
   WHERE B.CODFILIALNF = '6'
     AND B.UFDESTINO <> 'SP')
SELECT *
  FROM (SELECT DISTINCT P.CODFAB,
               P.CODAUXILIAR AS CODBARRAS,
               P.CODPROD,
               UPPER(W.IDADECORPORATIVO) AS FAIXA_SITE,
               P.DESCRICAO AS PRODUTO,
               UPPER(W.GENEROCORPORATIVO) AS GENERO_SITE,
               COALESCE(P.FORMAESTERILIZACAO, M.MARCA) AS MARCA,
               P.NBM AS NCM,
               DECODE(P.IMPORTADO, 'S', 'SIM', 'NÃO') AS IMPORTADO,
               F3.PLIQCOMPRA AS PRECOLIQ_LC,
               F3.PBRUTO AS PRECOBRUTO_LC,
               L3.PRECOVENDA_LC,
               L3.MARGEM_LC,
               S6.PRECOVENDA_SN,
               S6.MARGEM_SN,
               F3.PLIQUIDO AS CUSTOLIQUIDO_LC,
               (F3.PERPIS + F3.PERCOFINS) AS PISCOFINS_LC,
               F3.PERIPI AS IPI_LC,
               F3.PERCICM AS ICMS_LC,
               F3.PERCICMRED AS REDUCAOICMS_LC,
               F3.PERCIVA AS IVA_LC,
               F3.PERCALIQEXT AS ICMSEXTERNO_LC,
               F3.PERCALIQINT AS ICMSINTERNO_LC,
               ROUND(F3.REDBASEALIQEXT, 4) AS REDBASEST_LC,
               ROUND(F3.PERCALIQSTRED, 2) AS ALIQREDST_LC,
               VLC.ICMSVENDA_LC,
               VLC.PISCOFINSVENDA_LC,
               VLC.CMV_LC,
               SN.PRECOLIQ_SN,
               SN.PRECOBRUTO_SN,
               SN.CUSTOLIQUIDO_SN,
               DECODE(F.GERAICMSLIVROFISCAL, 'N', 'SIM', 'NÃO') AS ST_SP,
               ST.UF,
               ST.PERCDIFALIQ
          FROM PCPRODUT P
          LEFT JOIN PCMARCA M ON P.CODMARCA = M.CODMARCA
          LEFT JOIN PCPRODFILIAL F ON P.CODPROD = F.CODPROD
          LEFT JOIN VIEW_JC_CUSTOLIQ_240 F3 ON P.CODPROD = F3.CODPROD
                                           AND F3.CODFILIAL = '3'
          LEFT JOIN PRECO_LUCROREAL L3 ON P.CODPROD = L3.CODPROD
          LEFT JOIN PRECO_SIMPLES S6 ON P.CODPROD = S6.CODPROD
          LEFT JOIN CUSTO_FILIAL_SN SN ON P.CODPROD = SN.CODPROD
          LEFT JOIN ESTPRODUTOWEB W ON P.CODPROD = W.CODPROD
          LEFT JOIN TRIBUT_VENDA_LC VLC ON P.CODPROD = VLC.CODPROD
          LEFT JOIN TRIBUT_VENDA_SN VSN ON P.CODPROD = VSN.CODPROD
          LEFT JOIN TRIBUT_ST_ESTADOS ST ON P.CODPROD = ST.CODPROD
         WHERE (F.CODFILIAL = 6 AND F.ENVIARFORCAVENDAS = 'S')
           AND P.CODMARCA <> 225 --RETIRAR KITS
        )
PIVOT (SUM(PERCDIFALIQ) FOR UF IN('AC',
                             'AL',
                             'AM',
                             'AP',
                             'BA',
                             'CE',
                             'DF',
                             'ES',
                             'GO',
                             'MA',
                             'MG',
                             'MS',
                             'MT',
                             'PA',
                             'PB',
                             'PE',
                             'PI',
                             'PR',
                             'RJ',
                             'RN',
                             'RO',
                             'RR',
                             'RS',
                             'SC',
                             'SE',
                             'TO'))
 ORDER BY MARCA, PRECOVENDA_SN;
 /
