-- 1� ANALISAR OS ITENS QUE FORAM GERADOS NO PEDIDO PARA VER MOVIMENTA��O NA PCMOV
-- ENCONTRAR COM O NUMNOTA GERADO COM STATUS 'B' NA FILIAL ERRADA QUE POSSUI ROTINALANC = 'ESJCB9802.EXE'
WITH PEDIDO AS
 (SELECT CODPROD FROM PCPEDI I WHERE I.NUMPED = &NUMPED) --39000489
SELECT M.DTMOV, 
       M.DTCANCEL,
			 M.NUMNOTA,
       M.CODCLI,
       (CASE WHEN M.CODOPER LIKE 'S%' THEN C.CLIENTE
				 ELSE (SELECT FORNECEDOR FROM PCFORNEC F WHERE F.CODFORNEC = M.CODCLI) END) CLIENTE,
       M.CODPROD,
       P.DESCRICAO,
       M.CODFILIAL,
       M.CODFILIALNF,
       M.STATUS,
       M.CODOPER,
       M.QT,
       M.QTESTANT,
       M.QTCONT,
       M.QTESTGERANT,
       M.NUMNOTA,
       M.ROTINALANC,
       M.MOVESTOQUEGERENCIAL,
       M.MOVESTOQUECONTABIL,
       M.CODUSUR,
       M.NUMCAR,
       M.*
  FROM PCMOV M
  JOIN PEDIDO T ON T.CODPROD = M.CODPROD
  JOIN PCPRODUT P ON P.CODPROD = M.CODPROD
  JOIN PCCLIENT C ON C.CODCLI = M.CODCLI
 WHERE M.DTMOV = TRUNC(SYSDATE)
   --AND M.CODFILIAL IN ('2', '5')
   AND M.DTCANCEL IS NULL
 ORDER BY M.NUMTRANSITEM;

--2� FAZER O UPDATE NA PCMOV DO CODFILIAL E CODFILIALNF NA NOTA STATUS 'B' ENCONTRADA
-- INFORMAR QUAL SER� A FILIAL CORRETA NO UPDATE
MERGE INTO PCMOV M
USING (SELECT NUMTRANSITEM,
              CODPROD,
              DESCRICAO,
              QT,
              CODOPER,
              CODFILIAL,
              CODFILIALNF,
              STATUS,
              ROTINALANC
         FROM PCMOV M
        WHERE M.ROTINALANC IN ( 'ESJCB9802.EXE', 'PLSQLDEV.EXE' )
          AND M.NUMNOTA = &NUMNOTA_GERENCIAL) X --469196
ON (M.NUMTRANSITEM = X.NUMTRANSITEM)
WHEN MATCHED THEN
  UPDATE SET CODFILIAL = &FILIAL_CORRETA, CODFILIALNF = &FILIAL_CORRETA;

--3� CORRIGIR OS ESTOQUES NA PCEST RETIRANDO DA FILIAL QUE ENTROU ERRADO
MERGE INTO PCEST E
USING (
  WITH PEDIDO AS
   (SELECT CODPROD, QT FROM PCPEDI I WHERE I.NUMPED = &NUMPED) --39000377
  SELECT E.CODFILIAL,
         E.CODPROD,
         P.DESCRICAO,
         E.QTESTGER,
         T.QT,
         (NVL(E.QTESTGER, 0) - T.QT) ESTOQUE_CORRIGIDO
    FROM PCEST E
    JOIN PEDIDO T ON T.CODPROD = E.CODPROD
    JOIN PCPRODUT P ON P.CODPROD = E.CODPROD
   WHERE E.CODFILIAL = &FILIAL_ERRADA
   ORDER BY E.CODPROD, E.CODFILIAL) X ON (E.CODFILIAL = X.CODFILIAL AND
                                         E.CODPROD = X.CODPROD) WHEN
   MATCHED THEN
    UPDATE SET E.QTESTGER = X.ESTOQUE_CORRIGIDO;

--4� CORRIGIR OS ESTOQUES NA PCEST ADICIONANDO NA FILIAL CORRETA
MERGE INTO PCEST E
USING (
  WITH PEDIDO AS
   (SELECT CODPROD, QT FROM PCPEDI I WHERE I.NUMPED = &NUMPED) --39000377
  SELECT E.CODFILIAL,
         E.CODPROD,
         P.DESCRICAO,
         E.QTESTGER,
         T.QT,
         (NVL(E.QTESTGER, 0) + T.QT) ESTOQUE_CORRIGIDO
    FROM PCEST E
    JOIN PEDIDO T ON T.CODPROD = E.CODPROD
    JOIN PCPRODUT P ON P.CODPROD = E.CODPROD
   WHERE E.CODFILIAL = &FILIAL_CORRETA
   ORDER BY E.CODPROD, E.CODFILIAL) X ON (E.CODFILIAL = X.CODFILIAL AND
                                         E.CODPROD = X.CODPROD) WHEN
   MATCHED THEN
    UPDATE SET E.QTESTGER = X.ESTOQUE_CORRIGIDO;

--5� CORRIGIR A FILIAL NA QUAL O PEDIDO FOI GERADO
MERGE INTO PCPEDC C
USING (SELECT NUMPED, CODFILIAL, CODFILIALNF
         FROM PCPEDC C
        WHERE C.NUMPED = &NUMPED) X
ON (C.NUMPED = X.NUMPED)
WHEN MATCHED THEN
  UPDATE
     SET C.CODFILIAL = &FILIAL_CORRETA, C.CODFILIALNF = &FILIAL_CORRETA;

--6� CORRIGIR A FILIAL NA QUAL OS ITENS DO PEDIDO FOI GERADO
MERGE INTO PCPEDI I
USING (SELECT I.NUMPED, I.CODPROD, I.CODFILIALRETIRA
         FROM PCPEDI I
        WHERE I.NUMPED = &NUMPED) X
ON (I.NUMPED = X.NUMPED AND I.CODPROD = X.CODPROD)
WHEN MATCHED THEN
  UPDATE SET I.CODFILIALRETIRA = &FILIAL_CORRETA;
