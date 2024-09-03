SELECT C.DATA,
       C.NUMPED,
       C.POSICAO,
       C.CONDVENDA,
       C.CONTAORDEM,
       C.CODFILIAL,
       I.CODFILIALRETIRA,
       C.CODCLI,
       T.CLIENTE,
       C.CODCOB,
       C.CODEMITENTE,
       I.CODPROD,
       P.DESCRICAO,
       I.QT
  FROM PCPEDC C
  JOIN PCPEDI I ON I.NUMPED = C.NUMPED
  JOIN PCCLIENT T ON C.CODCLI = T.CODCLI
  JOIN PCPRODUT P ON P.CODPROD = I.CODPROD
 WHERE C.POSICAO  <> 'C'
   AND C.CONDVENDA = 7
   AND C.CODFILIAL <> I.CODFILIALRETIRA
   AND C.DATA > TO_DATE('01/06/2022', 'DD/MM/YYYY');
	 
	 SELECT ROWID, I.CODFILIALRETIRA, I.* FROM PCPEDI I WHERE I.NUMPED = 14211669;
