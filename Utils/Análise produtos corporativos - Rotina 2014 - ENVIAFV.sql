/*Análise produtos corporativos - Rotina 2014 - ENVIAFV--*/
SELECT B.CODFILIAL, B.CODPROD, P.DESCRICAO, B.ENVIAFV ENVIAFV_2014
  FROM PCEMBALAGEM B, PCPRODUT P
 WHERE B.CODPROD = P.CODPROD
   AND P.CODAUXILIAR = B.CODAUXILIAR
   AND B.CODFILIAL IN ('2', '5', '6')
   AND B.ENVIAFV = 'N'
   AND EXISTS (SELECT CODPROD
          FROM PCPRODFILIAL
         WHERE CODFILIAL = '6'
           AND ENVIARFORCAVENDAS = 'S'
           AND CODPROD = B.CODPROD)
 ORDER BY B.CODPROD, B.CODFILIAL;
/
/*UPDATE*/
UPDATE PCEMBALAGEM SET ENVIAFV = 'S' WHERE ENVIAFV = 'N' AND CODFILIAL IN ('2', '5', '6') AND EXISTS(
  SELECT CODPROD
    FROM PCPRODFILIAL B
   WHERE B.CODFILIAL = '6'
     AND B.ENVIARFORCAVENDAS = 'S'
     AND B.CODPROD = PCEMBALAGEM.CODPROD) AND CODAUXILIAR = (SELECT MIN(CODAUXILIAR)
                                                               FROM PCPRODUT
                                                              WHERE CODAUXILIAR =
                                                                    PCEMBALAGEM.CODAUXILIAR);
/
--PRODUTOS PARA O ECOMMERCE
  SELECT COUNT(*)
    FROM PCEMBALAGEM B
   WHERE B.UNIDADE = 'UN'
     AND B.ENVIAFV = 'N'
     AND B.CODFILIAL IN ('7');
/
--UPDATE
UPDATE PCEMBALAGEM B SET B.ENVIAFV = 'S' WHERE B.UNIDADE = 'UN' AND B.ENVIAFV = 'N' AND B.CODFILIAL IN('7');
/
/*ANALISE DOS QUE NAO SÃO PARA ENVIAR PARA FORCA DE VENDAS */
  SELECT B.CODFILIAL, B.CODPROD, P.DESCRICAO, B.ENVIAFV ENVIAFV_2014
    FROM PCEMBALAGEM B, PCPRODUT P, PCFORNEC F
   WHERE B.CODPROD = P.CODPROD
     AND P.CODAUXILIAR = B.CODAUXILIAR
     AND P.CODFORNEC = F.CODFORNEC
     AND (B.CODFILIAL IN ('5', '6') OR
         (B.CODFILIAL = '2' AND F.CODFORNECPRINC <> 2))
     AND B.ENVIAFV = 'S'
     AND EXISTS (SELECT CODPROD
            FROM PCPRODFILIAL
           WHERE CODFILIAL = '6'
             AND ENVIARFORCAVENDAS = 'N'
             AND CODPROD = B.CODPROD)
   ORDER BY B.CODPROD, B.CODFILIAL;
/
/*UPDATE*/
UPDATE PCEMBALAGEM
   SET ENVIAFV = 'N'
 WHERE ENVIAFV = 'S'
   AND CODFILIAL IN ('5', '6')
   AND EXISTS (SELECT CODPROD
          FROM PCPRODFILIAL B
         WHERE B.CODFILIAL = '6'
           AND B.ENVIARFORCAVENDAS = 'N'
           AND B.CODPROD = PCEMBALAGEM.CODPROD)
   AND CODAUXILIAR =
       (SELECT MIN(CODAUXILIAR)
          FROM PCPRODUT
         WHERE CODAUXILIAR = PCEMBALAGEM.CODAUXILIAR);
				 
UPDATE PCEMBALAGEM
   SET ENVIAFV = 'N'
 WHERE ENVIAFV = 'S'
   AND CODFILIAL IN ('2')
   AND CODPROD = (SELECT CODPROD
                    FROM PCPRODUT P, PCFORNEC F
                   WHERE P.CODFORNEC = F.CODFORNEC
                     AND F.CODFORNECPRINC <> 2
                     AND P.CODPROD = PCEMBALAGEM.CODPROD)
   AND EXISTS (SELECT CODPROD
          FROM PCPRODFILIAL B
         WHERE B.CODFILIAL = '6'
           AND B.ENVIARFORCAVENDAS = 'N'
           AND B.CODPROD = PCEMBALAGEM.CODPROD)
   AND CODAUXILIAR =
       (SELECT MIN(CODAUXILIAR)
          FROM PCPRODUT
         WHERE CODAUXILIAR = PCEMBALAGEM.CODAUXILIAR);
/
  SELECT *
    FROM PCPRODFILIAL
   WHERE CODFILIAL = '6'
     AND ENVIARFORCAVENDAS = 'S'
     AND CODPROD IN (808614,
                     814883,
                     815279,
                     814884,
                     815280,
                     808612,
                     808615,
                     813847,
                     808613);
/ UPDATE PCPRODFILIAL SET ENVIARFORCAVENDAS = 'N' WHERE CODFILIAL = '6' AND CODPROD IN(808614,
                                                                                       814883,
                                                                                       815279,
                                                                                       814884,
                                                                                       815280,
                                                                                       808612,
                                                                                       808615,
                                                                                       813847,
                                                                                       808613) /
