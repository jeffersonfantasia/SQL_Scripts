    SELECT NUMINVENT,
           DATA,
           CODFILIAL,
           CODPROD,
           DESCRICAO,
           MARCA,
           QTCONTADO,
           QTESTGER,
           QTAVARIA,
           INVENTAVARIA,
           CUSTO,
           (QTCONTADO - QTESTGER) DIF,
           (
               CASE
                   WHEN (QTCONTADO - QTESTGER) > 0 THEN 'ENTRADA'
                   ELSE 'PERDA'
               END
           ) AS OPERACAO,
           ((QTCONTADO - QTESTGER) * CUSTO) AS VLOPERACAO
      FROM (
        SELECT I.NUMINVENT,
               I.DATA,
               I.CODFILIAL,
               I.CODPROD,
               P.DESCRICAO,
               M.MARCA,
               SUM (I.QT1) AS QTCONTADO,
               I.QTESTGER,
               SUM (I.QTAVARIA1) AS QTAVARIA,
               I.INVENTAVARIA,
               E.CUSTOCONT AS CUSTO
          FROM PCINVENTROT I
          LEFT JOIN PCPRODUT P ON I.CODPROD = P.CODPROD
          LEFT JOIN PCMARCA M ON P.CODMARCA = M.CODMARCA
          LEFT JOIN PCEST E ON I.CODPROD = E.CODPROD
           AND I.CODFILIAL = E.CODFILIAL
         WHERE I.NUMINVENT IN (1021, 1022)
         GROUP BY I.NUMINVENT,
                  I.DATA,
                  I.CODFILIAL,
                  I.CODPROD,
                  P.DESCRICAO,
                  M.MARCA,
                  I.QTESTGER,
                  I.INVENTAVARIA,
                  E.CUSTOCONT
    )
     WHERE QTCONTADO <> QTESTGER;
    /
