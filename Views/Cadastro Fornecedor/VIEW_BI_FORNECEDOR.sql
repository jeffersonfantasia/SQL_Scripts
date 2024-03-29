CREATE OR REPLACE VIEW VIEW_BI_FORNECEDOR AS
    SELECT F.CODFORNEC,
           F.FORNECEDOR,
           COALESCE (F.DTCADASTRO, TO_DATE ('04/02/2014', 'DD/MM/YYYY')) AS DTCADASTROFORNEC,
           F.DTULTALTER AS DTULTALTERFORNEC
      FROM PCFORNEC F
     WHERE F.DTEXCLUSAO IS NULL
       AND EXISTS (
        SELECT L.CODFORNEC
          FROM PCLANC L
         WHERE L.CODFORNEC = F.CODFORNEC
           AND L.TIPOPARCEIRO = 'F'
    )
        OR EXISTS (
        SELECT P.CODFORNEC
          FROM PCPRODUT P
         WHERE P.CODFORNEC = F.CODFORNEC
    );
/