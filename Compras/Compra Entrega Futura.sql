SELECT T.NUMTRANSENT,
       T.*
  FROM PCNFENT T
 WHERE CODFILIAL = 2
   AND NUMNOTA IN (
    209698, 210987
);
/
SELECT T.TIPODESCARGA,
       T.*
  FROM PCNFENT T
 WHERE NUMTRANSORIGEM = 91151
   AND ESPECIE = 'NF';
/
SELECT T.TIPODESCARGA,
       T.*
  FROM PCNFENT T
 WHERE NUMTRANSORIGEM = 96662
   AND ESPECIE = 'NF';
/
SELECT ROWID,
       T.NUMTRANSENT,
       T.OBS,
       T.NUMTRANSORIGEM,
       T.*
  FROM PCNFENT T
 WHERE TIPODESCARGA = 'R'
   AND ESPECIE = 'NF'
   AND CODFORNEC = 7561
 ORDER BY DTEMISSAO DESC;
/

/*DEVEMOS FAZER A INSER��O DO NUMTRANSENT DA NOTA M�E NO CAMPO NUMTRANSORIGEM DAS NOTAS DE REMESSA (NOTAS AONDE OS PRODUTOS FORAM TROCADOS), 
PARA MANTERMOS A RELA��O DE NOTAS FILHAS E ACOMPANHARMOS O VALOR TOTAL*/