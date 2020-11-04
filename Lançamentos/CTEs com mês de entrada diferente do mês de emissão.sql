-----------CONSULTA NA PCNFENT-----------------------
SELECT *
  FROM (SELECT E.CODFILIAL,
               E.ESPECIE,
               E.CODFORNEC,
               F.FORNECEDOR,
               E.NUMNOTA,
               E.NUMTRANSENT,
               E.DTEMISSAO,
               E.DTENT,
               TO_CHAR(DTEMISSAO, 'MM') MES_EMISSAO,
               TO_CHAR(DTENT, 'MM') MES_ENT
          FROM PCNFENT E, PCFORNEC F
         WHERE E.ESPECIE = 'CT'
           AND F.CODFORNEC = E.CODFORNEC
           AND E.DTEMISSAO >= TO_DATE('01/08/2018', 'DD/MM/YYYY')) m
 WHERE MES_EMISSAO <> MES_ENT
 ORDER BY DTENT DESC;


-----------CONSULTA NA PCNFBASENT-----------------------
SELECT *
  FROM (SELECT E.CODFILIALNF,
               E.ESPECIE,
               E.CODFORNEC,
               F.FORNECEDOR,
               E.NUMNOTA,
               E.NUMTRANSENT,
               E.DTEMISSAO,
               E.DTENTRADA,
               TO_CHAR(DTEMISSAO, 'MM') MES_EMISSAO,
               TO_CHAR(DTENTRADA, 'MM') MES_ENT
          FROM PCNFBASEENT E, PCFORNEC F
         WHERE E.ESPECIE = 'CT'
           AND F.CODFORNEC = E.CODFORNEC
           AND E.DTEMISSAO >= TO_DATE('01/08/2018', 'DD/MM/YYYY'))
 WHERE MES_EMISSAO <> MES_ENT
 ORDER BY DTENTRADA DESC;
