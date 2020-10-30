SELECT *
  FROM (
    SELECT M.DTMOV,
           M.NUMNOTA,
           P.CODFORNEC,
           F.FORNECEDOR,
           M.CODPROD,
           P.DESCRICAO,
           M.QT,
           M.PUNIT,
           M.CUSTOFIN CMV,
           ROUND (((M.PUNIT - M.CUSTOFIN) / M.PUNIT * 100), 2) PERC_LUCRO,
           M.CODICMTAB,
           M.PTABELA,
           M.PERCDESC,
           M.VLDESCONTO
      FROM PCMOV M,
           PCPRODUT P,
           PCFORNEC F
     WHERE M.CODPROD = P.CODPROD
       AND P.CODFORNEC = F.CODFORNEC
       AND M.CODUSUR = 45
       AND M.DTMOV BETWEEN TO_DATE ('01/09/2018', 'DD/MM/YYYY') AND TO_DATE ('20/09/2018', 'DD/MM/YYYY')
       AND M.CODPROD IN (
        796554, 796349, 798091, 804443, 798377, 803149, 803671, 799792, 803077
    )
)
 ORDER BY PERC_LUCRO,
          FORNECEDOR,
          CODPROD,
          DTMOV DESC;
/