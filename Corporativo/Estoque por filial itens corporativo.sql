SELECT *
  FROM (SELECT DISTINCT P.CODFAB,
               P.CODAUXILIAR AS CODBARRAS,
               P.CODPROD,
               P.DESCRICAO AS PRODUTO,
               COALESCE(P.FORMAESTERILIZACAO, M.MARCA) AS MARCA,
               P.NBM AS NCM,
               DECODE(P.IMPORTADO, 'S', 'SIM', 'N�O') AS IMPORTADO,
               E.CODFILIAL,
               (E.QTESTGER - E.QTBLOQUEADA - E.QTRESERV) AS QTDISP
          FROM PCPRODUT P
          LEFT JOIN PCMARCA M ON P.CODMARCA = M.CODMARCA
          LEFT JOIN PCPRODFILIAL F ON P.CODPROD = F.CODPROD
          LEFT JOIN PCEST E ON P.CODPROD = E.CODPROD
                           AND E.CODFILIAL IN (1, 2, 3, 4, 7)
         WHERE ((F.CODFILIAL = 6 AND F.ENVIARFORCAVENDAS = 'S') OR
               (F.CODFILIAL = 2 AND F.ENVIARFORCAVENDAS = 'S'))
           AND P.CODMARCA <> 225 --RETIRAR KITS
           AND P.OBS2 <> 'FL' --RETIRAR FORA DE LINHA
        )
PIVOT(SUM(QTDISP) AS QTDISP
   FOR CODFILIAL IN(1, 2, 3, 4, 7))
 ORDER BY MARCA
