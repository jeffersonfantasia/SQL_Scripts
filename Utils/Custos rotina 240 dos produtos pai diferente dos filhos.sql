SELECT *
  FROM (
    SELECT F.CODFILIAL,
           (
               SELECT CODPRODMASTER
                 FROM PCPRODUT
                WHERE CODPROD = F.CODPROD
           ) CODMASTER,
           (
               SELECT DESCRICAO
                 FROM PCPRODUT
                WHERE CODPROD = P.CODPRODMASTER
           ) PRODUTO_MASTER,
      /* (SELECT CODFORNEC FROM PCPRODUT WHERE CODPROD = P.CODPRODMASTER) CODFORNEC_MASTER,*/
           (
               SELECT ROUND (CUSTOREP, 2)
                 FROM PCPRODFILIAL
                WHERE CODPROD = P.CODPRODMASTER
                  AND CODFILIAL = F.CODFILIAL
           ) CUSTOREP_MASTER,
           (
               SELECT PERCDESC1
                 FROM PCPRODFILIAL
                WHERE CODPROD = P.CODPRODMASTER
                  AND CODFILIAL = F.CODFILIAL
           ) PERCDESC1_MASTER,
           (
               SELECT PERCDESC2
                 FROM PCPRODFILIAL
                WHERE CODPROD = P.CODPRODMASTER
                  AND CODFILIAL = F.CODFILIAL
           ) PERCDESC2_MASTER,
           (
               SELECT PERCDESC3
                 FROM PCPRODFILIAL
                WHERE CODPROD = P.CODPRODMASTER
                  AND CODFILIAL = F.CODFILIAL
           ) PERCDESC3_MASTER,
           (
               SELECT PERCDESC4
                 FROM PCPRODFILIAL
                WHERE CODPROD = P.CODPRODMASTER
                  AND CODFILIAL = F.CODFILIAL
           ) PERCDESC4_MASTER,
           (
               SELECT PERCDESC
                 FROM PCPRODFILIAL
                WHERE CODPROD = P.CODPRODMASTER
                  AND CODFILIAL = F.CODFILIAL
           ) PERCDESC_MASTER,
           (
               SELECT ROUND (CUSTOPROXIMACOMPRA, 2)
                 FROM PCEST
                WHERE CODPROD = P.CODPRODMASTER
                  AND CODFILIAL = F.CODFILIAL
           ) PROXIMACOMPRA_MASTER,
           F.CODPROD,
           P.DESCRICAO PRODUTO_FILHO,
     /*  P.CODFORNEC,*/
           F.CUSTOREPTAB,
           F.PERCDESC1TAB,
           F.PERCDESC2TAB,
           F.PERCDESC3TAB,
           F.PERCDESC4TAB,
           F.PERCDESC,
           ROUND (E.CUSTOPROXIMACOMPRA, 2) CUSTOPROXIMACOMPRA
      FROM PCPRODFILIAL F,
           PCPRODUT P,
           PCEST E
     WHERE F.CODPROD = P.CODPROD
       AND E.CODPROD = P.CODPROD
       AND E.CODFILIAL = F.CODFILIAL
       AND P.DTEXCLUSAO IS NULL
       AND F.CODFILIAL IN (
        1, 2, 3, 4, 7, 8
    )
)
 WHERE (PERCDESC <> PERCDESC_MASTER
    OR ABS (CUSTOPROXIMACOMPRA - PROXIMACOMPRA_MASTER) > 0.01)
 ORDER BY CODMASTER,
          CODFILIAL;
SELECT *
  FROM (
    SELECT F.CODFILIAL,
           (
               SELECT CODPRODMASTER
                 FROM PCPRODUT
                WHERE CODPROD = F.CODPROD
           ) CODMASTER,
           (
               SELECT DESCRICAO
                 FROM PCPRODUT
                WHERE CODPROD = P.CODPRODMASTER
           ) PRODUTO_MASTER,
           (
               SELECT CUSTOREP
                 FROM PCPRODFILIAL
                WHERE CODPROD = P.CODPRODMASTER
                  AND CODFILIAL = F.CODFILIAL
           ) CREP_MASTER,
           (
               SELECT ROUND (CUSTOREP, 2)
                 FROM PCPRODFILIAL
                WHERE CODPROD = P.CODPRODMASTER
                  AND CODFILIAL = F.CODFILIAL
           ) CUSTOREP_MASTER,
           (
               SELECT PERCDESC
                 FROM PCPRODFILIAL
                WHERE CODPROD = P.CODPRODMASTER
                  AND CODFILIAL = F.CODFILIAL
           ) PERCDESC_MASTER,
           (
               SELECT ROUND (CUSTOPROXIMACOMPRA, 2)
                 FROM PCEST
                WHERE CODPROD = P.CODPRODMASTER
                  AND CODFILIAL = F.CODFILIAL
           ) PROXIMACOMPRA_MASTER,
           (
               SELECT DTULTATUPCOMPRA
                 FROM PCPRODFILIAL
                WHERE CODPROD = P.CODPRODMASTER
                  AND CODFILIAL = F.CODFILIAL
           ) DTULTATUPCOMPRA_MASTER,
           (
               SELECT CODUSUULTALTCOM
                 FROM PCPRODFILIAL
                WHERE CODPROD = P.CODPRODMASTER
                  AND CODFILIAL = F.CODFILIAL
           ) CODFUNC_MASTER,
           F.CODPROD,
           P.DESCRICAO PRODUTO_FILHO,
           F.CUSTOREPTAB,
           F.PERCDESC,
           ROUND (E.CUSTOPROXIMACOMPRA, 2) CUSTOPROXIMACOMPRA,
           F.DTULTATUPCOMPRA,
           F.CODUSUULTALTCOM AS CODFUNC
      FROM PCPRODFILIAL F,
           PCPRODUT P,
           PCEST E
     WHERE F.CODPROD = P.CODPROD
       AND E.CODPROD = P.CODPROD
       AND E.CODFILIAL = F.CODFILIAL
       AND P.DTEXCLUSAO IS NULL
       AND F.CODFILIAL IN (
        1, 2, 3, 4, 7
    )
)
 WHERE (PERCDESC <> PERCDESC_MASTER
    OR ABS (CUSTOPROXIMACOMPRA - PROXIMACOMPRA_MASTER) > 0.01)
 ORDER BY CODMASTER,
          CODFILIAL;
SELECT CODMASTER,
       PRODUTO_MASTER,
       CUSTOREP_MASTER,
       PERCDESC_MASTER,
       PROXIMACOMPRA_MASTER,
       DTULTATUPCOMPRA_MASTER,
       CODFUNC_MASTER
  FROM (
    SELECT F.CODFILIAL,
           (
               SELECT CODPRODMASTER
                 FROM PCPRODUT
                WHERE CODPROD = F.CODPROD
           ) CODMASTER,
           (
               SELECT DESCRICAO
                 FROM PCPRODUT
                WHERE CODPROD = P.CODPRODMASTER
           ) PRODUTO_MASTER,
           (
               SELECT ROUND (CUSTOREP, 2)
                 FROM PCPRODFILIAL
                WHERE CODPROD = P.CODPRODMASTER
                  AND CODFILIAL = F.CODFILIAL
           ) CUSTOREP_MASTER,
           (
               SELECT PERCDESC
                 FROM PCPRODFILIAL
                WHERE CODPROD = P.CODPRODMASTER
                  AND CODFILIAL = F.CODFILIAL
           ) PERCDESC_MASTER,
           (
               SELECT ROUND (CUSTOPROXIMACOMPRA, 2)
                 FROM PCEST
                WHERE CODPROD = P.CODPRODMASTER
                  AND CODFILIAL = F.CODFILIAL
           ) PROXIMACOMPRA_MASTER,
           (
               SELECT DTULTATUPCOMPRA
                 FROM PCPRODFILIAL
                WHERE CODPROD = P.CODPRODMASTER
                  AND CODFILIAL = F.CODFILIAL
           ) DTULTATUPCOMPRA_MASTER,
           (
               SELECT CODUSUULTALTCOM
                 FROM PCPRODFILIAL
                WHERE CODPROD = P.CODPRODMASTER
                  AND CODFILIAL = F.CODFILIAL
           ) CODFUNC_MASTER,
           F.CODPROD,
           P.DESCRICAO PRODUTO_FILHO,
           F.CUSTOREPTAB,
           F.PERCDESC,
           ROUND (E.CUSTOPROXIMACOMPRA, 2) CUSTOPROXIMACOMPRA,
           F.DTULTATUPCOMPRA,
           F.CODUSUULTALTCOM AS CODFUNC
      FROM PCPRODFILIAL F,
           PCPRODUT P,
           PCEST E
     WHERE F.CODPROD = P.CODPROD
       AND E.CODPROD = P.CODPROD
       AND E.CODFILIAL = F.CODFILIAL
       AND P.DTEXCLUSAO IS NULL
       AND F.CODFILIAL IN (
        1, 2, 3, 4, 7, 8
    )
)
 WHERE (PERCDESC <> PERCDESC_MASTER
    OR ABS (CUSTOPROXIMACOMPRA - PROXIMACOMPRA_MASTER) > 0.01)
 GROUP BY CODMASTER,
          PRODUTO_MASTER,
          CUSTOREP_MASTER,
          PERCDESC_MASTER,
          PROXIMACOMPRA_MASTER,
          DTULTATUPCOMPRA_MASTER,
          CODFUNC_MASTER
 ORDER BY CODMASTER;