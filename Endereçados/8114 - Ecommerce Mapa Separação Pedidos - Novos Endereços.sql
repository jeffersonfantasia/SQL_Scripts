WITH ENDERECAMENTO AS --TABELAS DE ENDERE�OS
 (SELECT A.FILIAL_ID AS CODFILIAL,
         A.CODIGO    AS DEP,
         B.CODIGO    AS RUA,
         C.DESCRICAO AS LADO,
         D.CODIGO    AS PREDIO,
         E.CODIGO    AS NIVEL,
         F.CODIGO    AS APTO,
         F.ID        AS APTO_ID,
         F.AEREO
    FROM JCENDAPTO F
   INNER JOIN JCENDDEPOSITO A
      ON F.DEPOSITO_ID = A.ID
   INNER JOIN JCENDRUA B
      ON F.RUA_ID = B.ID
   INNER JOIN JCENDLADO C
      ON F.LADO_ID = C.ID
   INNER JOIN JCENDPREDIO D
      ON F.PREDIO_ID = D.ID
   INNER JOIN JCENDNIVEL E
      ON F.NIVEL_ID = E.ID
   WHERE F.ATIVO = 'S' AND B.CODIGO <> 99),
PRODUTO_POR_LOCAL AS --PRODUTOS COM ESTOQUE ENDERECADOS COM AS INFORMA��ES DOS SEUS ENDERE�OS ATIVOS
 (SELECT G.APTO_ID,
         E.AEREO,
         E.CODFILIAL,
         E.DEP,
         E.RUA,
         E.LADO,
         E.PREDIO,
         E.NIVEL,
         E.APTO,
         G.PROD_ID   AS CODPROD,
         G.QTD       AS QT_ENDERECADO
    FROM JCENDESTOQUE G
    LEFT JOIN ENDERECAMENTO E
      ON G.APTO_ID = E.APTO_ID
  -- WHERE G.PROD_ID = 809075 AND E.CODFILIAL = 7
  ),
VERIFICA_ESTOQUE_PEGA AS --VERIFICA SE EXISTE ESTOQUE NO PICKING
 (SELECT L.CODFILIAL,
         L.AEREO,
         L.CODPROD,
         (CASE
           WHEN SUM(L.QT_ENDERECADO) > 0 THEN
            'S'
           ELSE
            'N'
         END) AS ESTOQUE_PIKING
    FROM PRODUTO_POR_LOCAL L
   WHERE L.AEREO = 'N'
   GROUP BY L.CODFILIAL, L.AEREO, L.CODPROD),
AGRUPADO_AEREO AS --ANALISE SE VAI PEGAR ESTOQUE DO AEREO OU PICKING
 (SELECT L.CODFILIAL,
         L.AEREO,
         L.CODPROD,
         SUM(L.QT_ENDERECADO) AS QT_TOTAL,
         NVL(E.ESTOQUE_PIKING, 'N') AS ESTOQUE_PIKING,
         (CASE
           WHEN (L.AEREO = 'N' AND E.ESTOQUE_PIKING = 'S') THEN
            'S'
           WHEN (L.AEREO = 'N' AND E.ESTOQUE_PIKING = 'N') THEN
            'N'
           WHEN (L.AEREO = 'S' AND SUM(L.QT_ENDERECADO) > 0 AND
                NVL(E.ESTOQUE_PIKING, 'N') = 'N') THEN
            'S'
           ELSE
            'N'
         END) AS PEGAR_ESTOQUE
    FROM PRODUTO_POR_LOCAL L
    LEFT JOIN VERIFICA_ESTOQUE_PEGA E
      ON L.CODPROD = E.CODPROD
     AND L.CODFILIAL = E.CODFILIAL
   GROUP BY L.CODFILIAL, L.CODPROD, L.AEREO, E.ESTOQUE_PIKING
  HAVING SUM(L.QT_ENDERECADO) > 0),
MENOR_ESTOQUE AS --VERIFICA QUAL O MENOR ESTOQUE DENTRO OS ENDERE�OS PARA PEGAR O ESTOQUE  
 (SELECT L.CODFILIAL,
         L.AEREO,
         L.CODPROD,
         MIN(L.QT_ENDERECADO) MENOR_QT_ENDERECADO
    FROM PRODUTO_POR_LOCAL L
    LEFT JOIN AGRUPADO_AEREO A
      ON L.CODFILIAL = A.CODFILIAL
     AND L.CODPROD = A.CODPROD
     AND L.AEREO = A.AEREO
   WHERE A.PEGAR_ESTOQUE = 'S'
   GROUP BY L.CODFILIAL, L.CODPROD, L.AEREO),
MENOR_APTOID AS --VERIFICA QUAL A MENOR RUA DO MENOR ESTOQUE DENTRO OS ENDERE�OS PARA PEGAR O ESTOQUE    
 (SELECT L.CODFILIAL,
         L.AEREO,
         L.CODPROD,
         M.MENOR_QT_ENDERECADO,
         MIN(L.APTO_ID) AS MENOR_APTO_ID
    FROM PRODUTO_POR_LOCAL L
   INNER JOIN MENOR_ESTOQUE M
      ON L.CODFILIAL = M.CODFILIAL
     AND L.CODPROD = M.CODPROD
     AND L.AEREO = M.AEREO
     AND L.QT_ENDERECADO = M.MENOR_QT_ENDERECADO
   GROUP BY L.CODFILIAL, L.CODPROD, L.AEREO, M.MENOR_QT_ENDERECADO),
ENDERECO_PEGA AS --ENDERECO PARA PEGA
 (SELECT L.APTO_ID,
         L.AEREO,
         L.CODFILIAL,
         L.DEP,
         L.RUA,
         L.LADO,
         L.PREDIO,
         L.NIVEL,
         L.APTO,
         L.CODPROD,
         L.QT_ENDERECADO
    FROM PRODUTO_POR_LOCAL L
   INNER JOIN MENOR_APTOID A
      ON L.APTO_ID = A.MENOR_APTO_ID
     AND L.CODPROD = A.CODPROD
     AND L.CODFILIAL = A.CODFILIAL)
SELECT CODFILIALPEDIDO,
       CODFILIAL,
       APTO_ID,
       AEREO,
       DEP,
       RUA,
       LADO,
       PREDIO,
       NIVEL,
       APTO,
       QT_ENDERECADO,
       DATATIME,
       OBSENTREGA4,
       FORMAENTREGA,
       PRIORIDADE_ENTREGA,
       NUMPED,
       NUMPEDRCA,
       CODFILIALRETIRA,
       CODPROD,
       CODFAB,
       DESCRICAO,
       ESEMBALAGEMPRESENTE,
       CODAUXILIAR,
      /* MODULO,
       RUA,
       NUMERO,
       APTO,*/
       EMBALAGEM,
       UNIDADE,
       QTUNITCX,
       UNIDADEMASTER,
       NUMCAR,
       POSICAO,
       CODCLI,
       CLIENTE,
       MUNICENT,
       ESTENT,
       BAIRROENT,
       TELENT,
       CEPENT,
       CGCENT,
       IEENT,
       FANTASIA,
       ENDERENT,
       NUMEROENT,
       NUMPEDCLI,
       NUMNOTA,
       CODFILIALNF,
       QT,
      -- QT_SOMA,
       QTPEDIDA,
       TOTPESO,
       TOTVOLUME,
       PESOBRUTO,
       VOLUME,
       OBSENTREGA1,
       OBSENTREGA2,
       OBSENTREGA3,
       QTESTGER,
       NUMVOLUME,
       DESTINO,
       CONTADOR
  FROM (SELECT PCPEDC.CODFILIAL CODFILIALPEDIDO,
               NVL(PCPEDI.CODFILIALRETIRA, PCPEDC.CODFILIAL) CODFILIAL,
               TO_DATE(TO_CHAR(PCPEDC.DATA, 'DD/MM/YYYY') || ' ' ||
                       PCPEDC.HORA || ':' || PCPEDC.MINUTO || ':00',
                       'DD/MM/YYYY HH24:MI:SS') DATATIME,
               PCPEDCTEMP.OBSENTREGA4,
               E.APTO_ID,
       E.AEREO,
       E.DEP,
       E.RUA,
       E.LADO,
       E.PREDIO,
       E.NIVEL,
       E.APTO,
       E.QT_ENDERECADO,
               PCPEDCTEMP.FORMAENTREGA,
               NVL(PCPEDC.TIPOPRIORIDADEENTREGA, 'N') PRIORIDADE_ENTREGA,
               PCPEDC.NUMPED,
               PCPEDC.NUMPEDRCA,
               PCPEDI.CODFILIALRETIRA,
               PCPEDI.QT,
               PCPRODUT.CODPROD,
               PCPRODUT.CODFAB,
               PCPRODUT.DESCRICAO,
               PCPEDI.ESEMBALAGEMPRESENTE,
               NVL(PCPEDI.CODAUXILIAR, NVL(PCPRODUT.CODAUXILIAR, 0)) CODAUXILIAR,
               /*MAX((CASE
                     WHEN NVL(PCCONSUM.UTILIZAENDPORFILIAL, 'N') = 'S' THEN
                      (SELECT PCEST.MODULO
                         FROM PCEST
                        WHERE PCEST.CODPROD = PCPEDI.CODPROD
                          AND PCEST.CODFILIAL =
                              NVL(PCPEDI.CODFILIALRETIRA, PCPEDC.CODFILIAL))
                     ELSE
                      PCPRODUT.MODULO
                   END)) MODULO,
               MAX((CASE
                     WHEN NVL(PCCONSUM.UTILIZAENDPORFILIAL, 'N') = 'S' THEN
                      (SELECT PCEST.RUA
                         FROM PCEST
                        WHERE PCEST.CODPROD = PCPEDI.CODPROD
                          AND PCEST.CODFILIAL =
                              NVL(PCPEDI.CODFILIALRETIRA, PCPEDC.CODFILIAL))
                     ELSE
                      PCPRODUT.RUA
                   END)) RUA,
               MAX((CASE
                     WHEN NVL(PCCONSUM.UTILIZAENDPORFILIAL, 'N') = 'S' THEN
                      (SELECT PCEST.NUMERO
                         FROM PCEST
                        WHERE PCEST.CODPROD = PCPEDI.CODPROD
                          AND PCEST.CODFILIAL =
                              NVL(PCPEDI.CODFILIALRETIRA, PCPEDC.CODFILIAL))
                     ELSE
                      PCPRODUT.NUMERO
                   END)) NUMERO,
               MAX((CASE
                     WHEN NVL(PCCONSUM.UTILIZAENDPORFILIAL, 'N') = 'S' THEN
                      (SELECT PCEST.APTO
                         FROM PCEST
                        WHERE PCEST.CODPROD = PCPEDI.CODPROD
                          AND PCEST.CODFILIAL =
                              NVL(PCPEDI.CODFILIALRETIRA, PCPEDC.CODFILIAL))
                     ELSE
                      PCPRODUT.APTO
                   END)) APTO,*/
               MAX((CASE
                     WHEN (NVL(PCFILIAL.UTILIZAVENDAPOREMBALAGEM,
                               NVL(PCCONSUM.UTILIZAVENDAPOREMBALAGEM, 'N')) = 'S') THEN
                      (SELECT PCEMBALAGEM.EMBALAGEM
                         FROM PCEMBALAGEM
                        WHERE PCEMBALAGEM.CODPROD = PCPEDI.CODPROD
                          AND PCEMBALAGEM.CODFILIAL =
                              NVL(PCPEDI.CODFILIALRETIRA, PCPEDC.CODFILIAL)
                          AND PCEMBALAGEM.CODAUXILIAR =
                              NVL(PCPEDI.CODAUXILIAR, PCPRODUT.CODAUXILIAR))
                     ELSE
                      PCPRODUT.EMBALAGEM
                   END)) EMBALAGEM,
               MAX((CASE
                     WHEN (NVL(PCFILIAL.UTILIZAVENDAPOREMBALAGEM,
                               NVL(PCCONSUM.UTILIZAVENDAPOREMBALAGEM, 'N')) = 'S') THEN
                      (SELECT PCEMBALAGEM.UNIDADE
                         FROM PCEMBALAGEM
                        WHERE PCEMBALAGEM.CODPROD = PCPEDI.CODPROD
                          AND PCEMBALAGEM.CODFILIAL =
                              NVL(PCPEDI.CODFILIALRETIRA, PCPEDC.CODFILIAL)
                          AND PCEMBALAGEM.CODAUXILIAR =
                              NVL(PCPEDI.CODAUXILIAR, PCPRODUT.CODAUXILIAR))
                     ELSE
                      PCPRODUT.UNIDADE
                   END)) UNIDADE,
               NVL(PCPEDI.QTUNITCX, NVL(PCPRODUT.QTUNITCX, 1)) QTUNITCX,
               PCPRODUT.UNIDADEMASTER,
               PCPEDI.NUMCAR,
               PCPEDC.POSICAO,
               PCPEDC.CODCLI,
               (CASE
                 WHEN PCPEDC.CODCLI IN (1, 2) THEN
                  PCVENDACONSUM.CLIENTE || ' - ' || '(CONSUMIDOR FINAL)'
                 ELSE
                  PCCLIENT.CLIENTE
               END) CLIENTE,
               /*(CASE
                 WHEN PCPEDC.CODCLI IN (1, 2) THEN
                  PCVENDACONSUM.ENDERENT
                 ELSE
                  PCCLIENT.ENDERENT
               END) ENDERENT,     */
               (CASE
                 WHEN PCPEDC.CODCLI IN (1, 2) THEN
                  PCVENDACONSUM.MUNICENT
                 ELSE
                  PCCLIENT.MUNICENT
               END) MUNICENT,
               (CASE
                 WHEN PCPEDC.CODCLI IN (1, 2) THEN
                  PCVENDACONSUM.ESTENT
                 ELSE
                  PCCLIENT.ESTENT
               END) ESTENT,
               (CASE
                 WHEN PCPEDC.CODCLI IN (1, 2) THEN
                  PCVENDACONSUM.BAIRROENT
                 ELSE
                  PCCLIENT.BAIRROENT
               END) BAIRROENT,
               (CASE
                 WHEN PCPEDC.CODCLI IN (1, 2) THEN
                  PCVENDACONSUM.TELENT
                 ELSE
                  PCCLIENT.TELENT
               END) TELENT,
               (CASE
                 WHEN PCPEDC.CODCLI IN (1, 2) THEN
                  PCVENDACONSUM.CEPENT
                 ELSE
                  PCCLIENT.CEPENT
               END) CEPENT,
               (CASE
                 WHEN PCPEDC.CODCLI IN (1, 2) THEN
                  PCVENDACONSUM.CGCENT
                 ELSE
                  PCCLIENT.CGCENT
               END) CGCENT,
               (CASE
                 WHEN PCPEDC.CODCLI IN (1, 2) THEN
                  PCVENDACONSUM.IEENT
                 ELSE
                  PCCLIENT.IEENT
               END) IEENT,
               PCCLIENT.FANTASIA,
               PCCLIENT_REC.ENDERENT,
               PCCLIENT.NUMEROENT,
               PCPEDC.NUMPEDCLI,
               MAX((SELECT NUMNOTA
                     FROM PCNFSAID
                    WHERE NUMTRANSVENDA = PCPEDC.NUMTRANSVENDA
                      AND ROWNUM = 1)) AS NUMNOTA,
               PCPEDC.CODFILIALNF,
               SUM(NVL(PCPEDI.QT, 0)) QT_SOMA,
               (CASE
                 WHEN (MAX(NVL(PCFILIAL.UTILIZAVENDAPOREMBALAGEM,
                               NVL(PCCONSUM.UTILIZAVENDAPOREMBALAGEM, 'N'))) = 'S') THEN
                  (SUM(PCPEDI.QT) /
                  MAX(DECODE(NVL(PCPEDI.QTUNITEMB, 0),
                              0,
                              1,
                              PCPEDI.QTUNITEMB)))
                 ELSE
                  SUM(PCPEDI.QT)
               END) QTPEDIDA,
               (CASE
                 WHEN (MAX(NVL(PCFILIAL.UTILIZAVENDAPOREMBALAGEM,
                               NVL(PCCONSUM.UTILIZAVENDAPOREMBALAGEM, 'N'))) = 'S') THEN
                  ((SUM(PCPEDI.QT) /
                  MAX(DECODE(NVL(PCPEDI.QTUNITEMB, 0),
                               0,
                               1,
                               PCPEDI.QTUNITEMB))) *
                  MAX((SELECT NVL(PESOBRUTO, 0)
                         FROM PCEMBALAGEM
                        WHERE CODPROD = PCPEDI.CODPROD
                          AND CODAUXILIAR = PCPEDI.CODAUXILIAR
                          AND CODFILIAL =
                              NVL(PCPEDI.CODFILIALRETIRA, PCPEDC.CODFILIAL))))
                 ELSE
                  (SUM(PCPEDI.QT) * MAX(NVL(PCPRODUT.PESOBRUTO, 0)))
               END) TOTPESO,
               (SUM(NVL(PCPEDI.QT, 0)) * MAX(NVL(PCPRODUT.VOLUME, 0))) TOTVOLUME,
               
               MAX((CASE
                     WHEN (NVL(PCFILIAL.UTILIZAVENDAPOREMBALAGEM,
                               NVL(PCCONSUM.UTILIZAVENDAPOREMBALAGEM, 'N')) = 'S') THEN
                      (SELECT PCEMBALAGEM.PESOBRUTO
                         FROM PCEMBALAGEM
                        WHERE PCEMBALAGEM.CODPROD = PCPEDI.CODPROD
                          AND PCEMBALAGEM.CODFILIAL =
                              NVL(PCPEDI.CODFILIALRETIRA, PCPEDC.CODFILIAL)
                          AND PCEMBALAGEM.CODAUXILIAR =
                              NVL(PCPEDI.CODAUXILIAR, PCPRODUT.CODAUXILIAR))
                     ELSE
                      PCPRODUT.PESOBRUTO
                   END)) PESOBRUTO,
               PCPRODUT.VOLUME,
               PCPEDC.OBSENTREGA1,
               PCPEDC.OBSENTREGA2,
               PCPEDC.OBSENTREGA3,
               MAX((SELECT QTESTGER
                     FROM PCEST
                    WHERE CODFILIAL =
                          NVL(PCPEDI.CODFILIALRETIRA, PCPEDC.CODFILIAL)
                      AND CODPROD = PCPEDI.CODPROD)) QTESTGER,
               PCPEDC.NUMVOLUME,
               PCCARREG.DESTINO,
/*ALTERA��O JEFF 07.12.2018  
               DENSE_RANK() OVER(ORDER BY PCPEDC.NUMPEDRCA) CONTADOR */
               DENSE_RANK() OVER(ORDER BY PCPEDC.NUMPED) CONTADOR
          FROM PCPEDC,
               PCPEDCTEMP,
               PCPEDI,
               PCPRODUT,
               PCDISTRIB,
               PCDEPTO,
               PCCLIENT,
               PCCLIENT      PCCLIENT_REC,
               PCPLPAG,
               PCCOB,
               PCUSUARI,
               PCEMPR,
               PCPRACA,
               PCROTAEXP,
               PCFORNEC,
               PCFORNEC      TRANSP,
               PCCARREG,
               PCCONSUM,
               PCFILIAL,
               PCVENDACONSUM,
               ENDERECO_PEGA E
         WHERE PCPEDC.POSICAO = 'L'
           AND PCPEDC.CODSUPERVISOR IN (7, 8)
            AND PCPEDI.CODPROD = E.CODPROD(+)
   AND PCPEDI.CODFILIALRETIRA = E.CODFILIAL(+)
           AND PCPEDC.NUMPED IN (:NUMPED)
           AND PCPEDCTEMP.OBSENTREGA4 IN (:OBSENTREGA4)
           AND REPLACE(PCPEDCTEMP.FORMAENTREGA, ' -', '') IN (:FORMAENTREGA)
              -- AND PCPEDC.DATA BETWEEN :DATA1 AND :DATA2
           AND TO_DATE (TO_CHAR(PCPEDC.DATA,'DD/MM/YYYY') ||' '||PCPEDC.HORA ||':'||PCPEDC.MINUTO||':00', 'DD/MM/YYYY HH24:MI:SS') >= TO_DATE((:DATATIME),'DD/MM/YYYY HH24:MI:SS')
           AND PCPRODUT.CODSEC = (:SECAO)
          AND ((NVL(PCPEDC.TIPOPRIORIDADEENTREGA, 'N') = :TIPOPRIORIDADEENTREGA) OR 
     (CASE WHEN :TIPOPRIORIDADEENTREGA = 'N'  THEN 'B' ELSE :TIPOPRIORIDADEENTREGA END = NVL(PCPEDC.TIPOPRIORIDADEENTREGA, 'N')) OR 
   (CASE WHEN :TIPOPRIORIDADEENTREGA = 'N'  THEN 'M' ELSE :TIPOPRIORIDADEENTREGA END = NVL(PCPEDC.TIPOPRIORIDADEENTREGA, 'N'))
  )
          -- AND NVL(PCPEDC.TIPOPRIORIDADEENTREGA, 'N') = :TIPOPRIORIDADEENTREGA
          -- AND ((NVL(PCPEDC.TIPOPRIORIDADEENTREGA, 'N') = :TIPOPRIORIDADEENTREGA) OR (CASE WHEN :TIPOPRIORIDADEENTREGA = 'N'  THEN 'B' ELSE :TIPOPRIORIDADEENTREGA END =NVL(PCPEDC.TIPOPRIORIDADEENTREGA, 'N')))
           AND PCPEDC.NUMPED = PCPEDI.NUMPED
           AND PCPEDC.NUMPED = PCPEDCTEMP.NUMPED(+)
           AND PCCARREG.NUMCAR = PCPEDC.NUMCAR
           AND PCPEDI.CODPROD = PCPRODUT.CODPROD
           AND PCPEDC.CODCLI = PCCLIENT.CODCLI
           AND PCPEDC.CODCLIRECEBEDOR = PCCLIENT_REC.CODCLI(+)
           AND PCPEDC.CODPLPAG = PCPLPAG.CODPLPAG
           AND PCPEDC.CODPRACA = PCPRACA.CODPRACA
           AND PCPRACA.ROTA = PCROTAEXP.CODROTA
           AND PCPEDC.CODEMITENTE = PCEMPR.MATRICULA(+)
           AND PCPEDC.CODCOB = PCCOB.CODCOB
           AND PCPEDC.CODUSUR = PCUSUARI.CODUSUR
           AND PCPEDC.CODFILIAL = PCFILIAL.CODIGO
           AND PCPEDC.CONDVENDA NOT IN (4)
           AND PCPEDI.QT > 0
           AND PCPRODUT.CODFORNEC = PCFORNEC.CODFORNEC
           AND PCPRODUT.CODEPTO = PCDEPTO.CODEPTO
           AND PCPEDC.CODDISTRIB = PCDISTRIB.CODDISTRIB(+)
           AND ((PCDISTRIB.TIPOMAPASEQ IS NULL) OR
               (PCDISTRIB.TIPOMAPASEQ = 'R'))
           AND PCPEDC.NUMPED = PCVENDACONSUM.NUMPED(+)
           AND CASE
                 WHEN :EMITIUMAPA <> 'T' THEN
                  NVL(PCPEDC.EMITIUMAPA, 'N')
                 ELSE
                  '1'
               END = CASE
                 WHEN :EMITIUMAPA <> 'T' THEN
                  :EMITIUMAPA
                 ELSE
                  '1'
               END
           /*AND CASE
                 WHEN :TIPOPRIORIDADEENTREGA <> 'A' THEN
                  NVL(PCPEDC.TIPOPRIORIDADEENTREGA, 'N')
                 ELSE
                  'A'
               END  = CASE
                 WHEN :TIPOPRIORIDADEENTREGA <> 'A' THEN
                  :TIPOPRIORIDADEENTREGA
                 ELSE
                  '1'
               END */   
         GROUP BY PCPEDC.CODFILIAL,
         E.APTO_ID,
          E.AEREO,
          E.DEP,
          E.RUA,
          E.LADO,
          E.PREDIO,
          E.NIVEL,
          E.APTO,
          E.QT_ENDERECADO,
                  TO_DATE(TO_CHAR(PCPEDC.DATA, 'DD/MM/YYYY') || ' ' ||
                          PCPEDC.HORA || ':' || PCPEDC.MINUTO || ':00',
                          'DD/MM/YYYY HH24:MI:SS'),
                  PCPEDCTEMP.OBSENTREGA4,
                  PCPEDCTEMP.FORMAENTREGA,
                  NVL(PCPEDC.TIPOPRIORIDADEENTREGA,'N'),
                  NVL(PCPEDI.CODAUXILIAR, NVL(PCPRODUT.CODAUXILIAR, 0)),
                  PCPRODUT.CODPROD,
                  PCPRODUT.CODFAB,
                  PCPRODUT.DESCRICAO,
                  PCPEDI.ESEMBALAGEMPRESENTE,
                  PCPEDI.QT,
                  PCPRODUT.UNIDADEMASTER,
                  NVL(PCPEDI.QTUNITCX, NVL(PCPRODUT.QTUNITCX, 1)),
                  PCPEDI.NUMCAR,
                  PCPEDC.NUMPED,
                  PCPEDC.NUMPEDRCA,
                  PCPEDI.CODFILIALRETIRA,
                  PCPEDC.POSICAO,
                  PCPEDC.CODCLI,
                  (CASE
                    WHEN PCPEDC.CODCLI IN (1, 2) THEN
                     PCVENDACONSUM.CLIENTE || ' - ' || '(CONSUMIDOR FINAL)'
                    ELSE
                     PCCLIENT.CLIENTE
                  END),
                  (CASE
                    WHEN PCPEDC.CODCLI IN (1, 2) THEN
                     PCVENDACONSUM.ENDERENT
                    ELSE
                     PCCLIENT.ENDERENT
                  END),
                  (CASE
                    WHEN PCPEDC.CODCLI IN (1, 2) THEN
                     PCVENDACONSUM.MUNICENT
                    ELSE
                     PCCLIENT.MUNICENT
                  END),
                  (CASE
                    WHEN PCPEDC.CODCLI IN (1, 2) THEN
                     PCVENDACONSUM.ESTENT
                    ELSE
                     PCCLIENT.ESTENT
                  END),
                  (CASE
                    WHEN PCPEDC.CODCLI IN (1, 2) THEN
                     PCVENDACONSUM.BAIRROENT
                    ELSE
                     PCCLIENT.BAIRROENT
                  END),
                  (CASE
                    WHEN PCPEDC.CODCLI IN (1, 2) THEN
                     PCVENDACONSUM.TELENT
                    ELSE
                     PCCLIENT.TELENT
                  END),
                  (CASE
                    WHEN PCPEDC.CODCLI IN (1, 2) THEN
                     PCVENDACONSUM.CEPENT
                    ELSE
                     PCCLIENT.CEPENT
                  END),
                  (CASE
                    WHEN PCPEDC.CODCLI IN (1, 2) THEN
                     PCVENDACONSUM.CGCENT
                    ELSE
                     PCCLIENT.CGCENT
                  END),
                  (CASE
                    WHEN PCPEDC.CODCLI IN (1, 2) THEN
                     PCVENDACONSUM.IEENT
                    ELSE
                     PCCLIENT.IEENT
                  END),
                  PCCLIENT.FANTASIA,
                  PCPEDC.CODCLIRECEBEDOR,
                  PCCLIENT_REC.CLIENTE,
                  PCCLIENT_REC.ENDERENT,
                  PCCLIENT_REC.MUNICENT,
                  PCCLIENT_REC.ESTENT,
                  PCCLIENT_REC.BAIRROENT,
                  PCCLIENT_REC.CEPENT,
                  PCCLIENT_REC.TELENT,
                  PCCLIENT_REC.CGCENT,
                  PCCLIENT_REC.FANTASIA,
                  PCCLIENT_REC.NUMSEQ,
                  PCCLIENT_REC.IEENT,
                  PCCLIENT.COMPLEMENTOENT,
                  PCCLIENT.NUMEROENT,
                  PCPEDC.CODEMITENTE,
                  PCEMPR.NOME,
                  PCPEDC.CODPLPAG,
                  PCPLPAG.DESCRICAO,
                  PCPLPAG.NUMDIAS,
                  PCPEDC.CODCOB,
                  PCCOB.COBRANCA,
                  PCPEDC.NUMPEDCLI,
                  PCPEDC.CODUSUR,
                  PCUSUARI.NOME,
                  PCPEDC.CODPRACA,
                  PCPRACA.PRACA,
                  PCPRACA.NUMREGIAO,
                  NVL(PCPEDI.CODFILIALRETIRA, PCPEDC.CODFILIAL),
                  PCPEDC.CODFILIALNF,
                  PCPEDI.QTPECAS,
                  PCPEDI.QTCX,
                  PCPRODUT.VOLUME,
                  PCPRODUT.CODSEC,
                  PCUSUARI.NOME,
                  PCPEDC.OBS,
                  PCPEDC.OBS1,
                  PCPEDC.OBS2,
                  PCPEDC.OBSENTREGA1,
                  PCPEDC.OBSENTREGA2,
                  PCPEDC.OBSENTREGA3,
                  PCPEDC.NUMVOLUME,
                  PCFORNEC.FANTASIA,
                  PCCARREG.DESTINO,
                  PCCARREG.NUMVIASMAPA,
                  PCPRODUT.NUMORIGINAL,
                  PCPRODUT.PESOVARIAVEL,
                  PCPRODUT.MULTIPLO
        /* ORDER BY NUMPEDRCA,CODFILIALRETIRA,MODULO, RUA, NUMERO, APTO ) --ALTERA��O JEFF 05.12.2018 */       
        /* ORDER BY CODFILIALRETIRA, MODULO, RUA, NUMERO, APTO )        --ALTERA��O JEFF 06.12.2018 */
  /*ALTERA��O JEFF 07.12.2018
         ORDER BY NUMPEDRCA, CODFILIALRETIRA, MODULO, RUA, NUMERO, APTO) */
           ORDER BY NUMPED, E.DEP,
          E.RUA,
          E.LADO,
          E.PREDIO,
          E.NIVEL,
          E.APTO,)     
 WHERE 1 = 1
    AND CONTADOR <= :CONTADOR