SELECT E.CODFILIAL,
       E.CODPROD,
       P.DESCRICAO,
       E.QTESTGER,
       E.QTBLOQUEADA,
       E.QTINDENIZ,
       E.MOTIVOBLOQESTOQUE
  FROM PCPRODUT P,
       PCFORNEC F,
       PCEST E
 WHERE P.CODPROD = E.CODPROD
   AND P.CODFORNEC = F.CODFORNEC
   AND F.CODFORNECPRINC IN (
    2, 305
)
   AND E.CODFILIAL = 7
   AND E.QTINDENIZ > 0
 ORDER BY E.CODPROD;
/