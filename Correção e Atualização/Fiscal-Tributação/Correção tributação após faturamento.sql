/*CORRIGIR O CODST PARA A TRIBUTAÇÃO CORRETA E DEPOIS MANDAR APORVAR A NOTA.*/
/*CORRIGIR ICMS E O VALOR*/
SELECT ROWID,
       B.CODST,
       B.*
  FROM PCMOVPREFAT B
 WHERE NUMTRANSVENDA = 10770381;
/

/*CORRIGIR CODST E CODCICMTAB*/
SELECT ROWID,
       CODST,
       PERCICM,
       CODICMTAB,
       NUMPED,
       PCMOV.*
  FROM PCMOV
 WHERE NUMTRANSVENDA = 10770381;
/

/*CORRIGIR CODST E CODCICMTAB*/
SELECT ROWID,
       CODST,
       CODICMTAB,
       PCPEDI.*
  FROM PCPEDI
 WHERE NUMPED = 4100007418;
/