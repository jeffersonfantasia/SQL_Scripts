SELECT I.NUMINVENT,
       I.DATA,
       I.CODFILIAL,
       I.CODPROD,
       P.DESCRICAO,
       M.MARCA,
       I.QT1,
       I.QTESTGER,
       I.QTAVARIA1,
       I.INVENTAVARIA,
       I.DATACONT1,
       I.CUSTO,
       (I.QT1 - I.QTESTGER) DIF,
       (
           CASE
               WHEN (I.QT1 - I.QTESTGER) > 0 THEN 'ENTRADA'
               ELSE 'PERDA'
           END
       ) AS OPERACAO,
       ((I.QT1 - I.QTESTGER) * I.CUSTO) AS VLOPERACAO
  FROM PCINVENTROT I
  LEFT JOIN PCPRODUT P ON I.CODPROD = P.CODPROD
  LEFT JOIN PCMARCA M ON P.CODMARCA = M.CODMARCA
 WHERE NUMINVENT = 1005
   AND QT1 <> QTESTGER;