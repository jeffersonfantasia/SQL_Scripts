CREATE OR REPLACE VIEW VIEW_JC_ITEM_NOTAFISCAL AS
    SELECT CASE
        WHEN (N.TIPODESCARGA IN (
            '6', '8', 'C', 'T'
        )) THEN 'D'
      -- Notas de Devolu��o

        WHEN N.TIPODESCARGA IN (
            'N', 'F', 'I'
        ) THEN 'I'
      -- Notas de Importa��o

        ELSE 'NC'
     -- Notas Normais ou Complementares com itens

    END TIPOPROCESSO,
           NVL (N.CODFILIALNF, N.CODFILIAL) CODFILIAL,
           M.NUMTRANSENT NUMTRANSACAO,
           M.NUMNOTA,
           M.DTMOV DATA,
           M.DTCANCEL,
           NVL (M.CALCCREDIPI, 'N') CALCCREDIPI,
           NVL (M.GERAICMSLIVROFISCAL, 'S') GERAICMSLIVROFISCAL,
           N.TIPODESCARGA TIPONOTA,
           M.CODPROD,
           NVL (M.DESCRICAO, P.DESCRICAO) DSCPRODUTO,
           M.CODINTERNO,
           NVL (M.NBM, P.NBM) NCM,
           P.NATUREZAPRODUTO,
           M.NUMLOTE,
           M.NUMSEQ,
           M.QTCONT,
           (
               CASE
                   WHEN N.TIPODESCARGA IN (
                       '6', '8', 'C', 'T'
                   ) THEN M.CUSTOFINEST
                   ELSE M.CUSTOFIN
               END
           ) AS CUSTOFINEST,
           M.QTCONT * DECODE (NVL (P.FATORCONVTRIB, 0), 0, 1, P.FATORCONVTRIB) QTCONT_FATORCONVTRIB,
           CASE
               WHEN (N.TIPODESCARGA IN (
                   '6', '8', 'C', 'T'
               )) THEN ROUND (M.QTCONT * (M.PUNITCONT + NVL (M.VLFRETE, 0) + NVL (M.VLOUTROS, 0)), 2)
               WHEN N.TIPODESCARGA IN (
                   'N', 'F', 'I'
               ) THEN (M.QTCONT * M.PUNITCONT)
               ELSE M.QTCONT * (M.PUNITCONT + NVL (M.VLIPI, 0) + NVL (M.ST, 0) + NVL (M.VLFRETE, 0) + NVL (M.VLOUTRASDESP, 0) - NVL
               (M.VLDESCONTO, 0) - NVL (M.VLSUFRAMA, 0))
           END VLCONTABIL,
           M.PUNITCONT,
           M.PTABELA,
           CASE
               WHEN (N.TIPODESCARGA IN (
                   '6', '8', 'C', 'T'
               )) THEN DECODE (NVL (P.FATORCONVTRIB, 0), 0, P.UNIDADE, NVL (P.UNIDADETRIB, P.UNIDADE))
               ELSE DECODE (NVL (P.FATORCONVTRIB, 0), 0, (
                   CASE
                       WHEN (P.UNIDADE <> P.UNIDADEMASTER)
                          AND (P.QTUNITCX > 1) THEN DECODE ((
                           SELECT MAX (TIPOEMBALAGEMPEDIDO)
                             FROM PCPEDIDO
                            WHERE NUMPED = M.NUMPED
                       ), 'M', P.UNIDADEMASTER, P.UNIDADE)
                       ELSE P.UNIDADE
                   END
               ), NVL (P.UNIDADETRIB, P.UNIDADE))
           END UNIDADE_MOV,
           P.UNIDADE,
           P.EMBALAGEM,
           CASE
               WHEN (N.TIPODESCARGA IN (
                   '6', '8', 'C', 'T'
               )) THEN DECODE (NVL (P.FATORCONVTRIB, 0), 0, 1, P.FATORCONVTRIB)
               ELSE DECODE (NVL (P.FATORCONVTRIB, 0), 0,
                            CASE
                                WHEN (P.UNIDADE <> P.UNIDADEMASTER)
                                   AND (P.QTUNITCX > 1) THEN DECODE ((
                                    SELECT MAX (TIPOEMBALAGEMPEDIDO)
                                      FROM PCPEDIDO
                                     WHERE NUMPED = M.NUMPED
                                ), 'M', P.QTUNITCX, 1)
                                ELSE 1
                            END, P.FATORCONVTRIB)
           END QTUNITCX_FATORCONVTRIB,
           CASE
               WHEN (N.TIPODESCARGA IN (
                   '6', '8', 'C', 'T'
               )) THEN ROUND (M.QTCONT * (M.PUNITCONT + DECODE (NVL (N.VLDESCONTO, 0), 0, 0, DECODE (NVL (PARAMFILIAL.OBTERCOMOVARCHAR2
               ('PRECOUTILIZADONFE', NVL (N.CODFILIALNF, N.CODFILIAL)), 'B'), 'B', 0, NVL (M.VLDESCONTO, 0))) - NVL (M.VLFRETE, 0
               ) - NVL (M.VLOUTRASDESP, 0) - NVL (M.VLIPI, 0) - NVL (M.ST, 0)), 2)
               WHEN N.TIPODESCARGA IN (
                   'N', 'F', 'I'
               ) THEN M.QTCONT * (M.PUNITCONT + NVL (M.VLDESCONTO, 0) - NVL (M.VLFRETE, 0) - NVL (M.VLOUTRASDESP, 0) - NVL (M.ST,
               0))
               ELSE M.QTCONT * M.PUNITCONT
           END VLPRODUTO,
           CASE
               WHEN (N.TIPODESCARGA IN (
                   '6', '8', 'C', 'T'
               )) THEN ROUND (M.QTCONT * DECODE (NVL (N.VLDESCONTO, 0), 0, 0, DECODE (NVL (PARAMFILIAL.OBTERCOMOVARCHAR2 ('PRECOUTILIZADONFE'
               , NVL (N.CODFILIALNF, N.CODFILIAL)), 'B'), 'B', 0, NVL (M.VLDESCONTO, 0))), 2)
               ELSE (M.QTCONT * NVL (M.VLDESCONTO, 0))
           END VLDESCONTO,
           M.SITTRIBUT,
           M.IMPORTADO,
           PF.ORIGMERCTRIB,
           M.CODFISCAL,
           CASE
               WHEN N.TIPODESCARGA IN (
                   '6', '8', 'C', 'T'
               ) THEN ROUND (M.QTCONT * (NVL (M.BASEICMS, 0) + NVL (MC.VLBASEFRETE, 0) + NVL (MC.VLBASEOUTROS, 0)), 2)
               ELSE ROUND (M.QTCONT * NVL (M.BASEICMS, 0), 2)
           END VLBASEICMS,
           NVL (M.PERCICM, 0) PERCICM,
           CASE
               WHEN N.TIPODESCARGA IN (
                   '6', '8', 'C', 'T'
               ) THEN ROUND (M.QTCONT * (NVL (M.BASEICMS, 0) + NVL (MC.VLBASEFRETE, 0) + NVL (MC.VLBASEOUTROS, 0)) * NVL (M.PERCICM
               , 0) / 100, 2)
               ELSE M.QTCONT * NVL (MC.VLICMS, (NVL (M.BASEICMS, 0) * NVL (M.PERCICM, 0) / 100))
           END VLICMS,
           M.QTCONT * NVL (M.BASEICST, 0) VLBASEICMSST,
           M.ALIQICMS1 ALIQICMS_INTERNA,
           M.ALIQICMS2 ALIQICMS_EXTERNA,
           M.QTCONT * NVL (M.ST, 0) VLST,
           M.QTCONT * NVL (M.VLDESPADICIONAL, 0) VLSTGUIA,
           MC.CODSITTRIBIPI CODIPI,
           ROUND (M.QTCONT * NVL (M.VLBASEIPI, 0), 2) VLBASEIPI,
           NVL (M.PERCIPI, 0) PERCIPI,
           ROUND (M.QTCONT * NVL (M.VLIPI, 0), 2) VLIPI,
           SUBSTR (TRIM (P.CLASSIFICFISCAL), 1, 2) CLASSIFICFISCAL,
           NVL (M.PERCBASERED, 0) PERCBASERED,
           DECODE (MC.USAPISCOFINSLIT, 'S', NVL (MC.QTLITRAGEM, P.LITRAGEM), 0) QTLITRAGEM,
           M.CODSITTRIBPISCOFINS CST_PISCOFINS,
           ROUND (DECODE (DECODE (MC.USAPISCOFINSLIT, 'S', NVL (MC.QTLITRAGEM, P.LITRAGEM), 0), 0, M.QTCONT * NVL (M.VLBASEPISCOFINS
           , 0), M.QTCONT * NVL (MC.QTLITRAGEM, P.LITRAGEM) * DECODE (NVL (M.VLCREDPIS, 0), 0, 0, 1)), 2) VLBASEPISCOFINS,
           ROUND (DECODE (DECODE (MC.USAPISCOFINSLIT, 'S', NVL (MC.QTLITRAGEM, P.LITRAGEM), 0), 0, M.QTCONT * NVL (M.VLBASEPISCOFINS
           , 0), M.QTCONT * NVL (MC.QTLITRAGEM, P.LITRAGEM) * DECODE (NVL (M.VLCREDPIS, 0), 0, 0, 1)), 2) VLBASECOFINS,
           DECODE (NVL (DECODE (MC.USAPISCOFINSLIT, 'S', NVL (MC.QTLITRAGEM, P.LITRAGEM), 0), 0), 0, M.PERPIS, M.VLCREDPIS) PERPIS
           ,
           DECODE (NVL (DECODE (MC.USAPISCOFINSLIT, 'S', NVL (MC.QTLITRAGEM, P.LITRAGEM), 0), 0), 0, M.PERCOFINS, M.VLCREDCOFINS)
           PERCOFINS,
           ROUND (DECODE (DECODE (MC.USAPISCOFINSLIT, 'S', NVL (MC.QTLITRAGEM, P.LITRAGEM), 0), 0, M.QTCONT * NVL (M.VLCREDPIS, 0
           ), M.QTCONT * NVL (MC.QTLITRAGEM, P.LITRAGEM) * NVL (M.VLCREDPIS, 0)), 2) VLPIS,
           ROUND (DECODE (DECODE (MC.USAPISCOFINSLIT, 'S', NVL (MC.QTLITRAGEM, P.LITRAGEM), 0), 0, M.QTCONT * NVL (M.VLCREDCOFINS
           , 0), M.QTCONT * NVL (MC.QTLITRAGEM, P.LITRAGEM) * NVL (M.VLCREDCOFINS, 0)), 2) VLCOFINS,
           MC.EXTIPI,
           M.CODOPER,
           0 VLISENTAS_CF,
           0 VLNAOTRIB_CF,
           0 VLST_CF,
           NULL TIPOMOVBEM,
           P.CODGENEROFISCAL CODGENERO,
           MC.PERCMVAORIG VLAGREGADOMVA,
           (M.QTCONT * NVL (M.VLFRETE, 0)) VLFRETE,
           (M.QTCONT * NVL (M.VLOUTRASDESP, 0)) VLOUTRASDESP,
           (ROUND (NVL (M.QTCONT, 0) * NVL (MC.VLICMSPARTREM, 0), 2) + ROUND (NVL (M.QTCONT, 0) * NVL (MC.VLICMSPARTDEST, 0), 2) +
           ROUND (NVL (M.QTCONT, 0) * NVL (MC.VLFCPPART, 0), 2)) VLICMSPARTILHA,
           M.CODUSUR,
           N.CODFORNEC AS CODFORCLI,
           'E' AS TIPOMOV
      FROM PCNFENT N,
           PCMOV M,
           PCPRODUT P,
           PCFILIAL F,
           PCMOVCOMPLE MC,
           PCPRODFILIAL PF
     WHERE PF.CODPROD (+) = M.CODPROD
       AND PF.CODFILIAL (+) = NVL (M.CODFILIALNF, M.CODFILIAL)
       AND M.NUMTRANSENT = N.NUMTRANSENT
       AND M.NUMNOTA = N.NUMNOTA
       AND N.ESPECIE IN (
        'NF', 'NC'
    )
       AND MC.NUMTRANSITEM (+) = M.NUMTRANSITEM
       AND F.CODIGO = NVL (N.CODFILIALNF, N.CODFILIAL)
       AND P.CODPROD = M.CODPROD
       AND M.STATUS IN (
        'A', 'AB'
    )
       AND M.QTCONT > 0
       AND (M.PUNITCONT > 0
        OR N.TIPODESCARGA = 'G')
-----------------------------------------------------------------------------------

    UNION ALL
-----------------------------------------------------------------------------------

-- TIPO 'E' = Entrada - TIPOMOV 'C' = CIAP => NFs com Entradas de CIAP

    SELECT 'C' TIPOPROCESSO,
           NVL (N.CODFILIALNF, N.CODFILIAL) CODFILIAL,
           M.NUMTRANSENT NUMTRANSACAO,
           M.NUMNOTA,
           M.DTMOV DATA,
           M.DTCANCEL,
           DECODE (NVL (M.VLIPI, 0), 0, 'N', 'S') CALCCREDIPI,
           NVL (M.GERAICMSLIVROFISCAL, 'S') GERAICMSLIVROFISCAL,
           N.TIPODESCARGA TIPONOTA,
           M.CODPROD,
           TRIM (P.DESCRICAO) || ' - ' || TRIM (M.DESCCOMPLEMENTAR) DSCPRODUTO,
           NULL CODINTERNO,
           P.CODNCM NCM,
           NULL NATUREZAPRODUTO,
           NULL NUMLOTE,
           1 NUMSEQ,
           M.QTCONT,
           0 CUSTOFINEST,
           0 QTCONT_FATORCONVTRIB,
           (M.VLITEM) VLCONTABIL,
           (M.VLITEM / M.QTCONT) PUNITCONT,
           (M.VLITEM / M.QTCONT) PTABELA,
           'UN' UNIDADE_MOV,
           'UN' UNIDADE,
           P.EMBALAGEM,
           1 QTUNITCX_FATORCONVTRIB,
           (M.VLITEM - (ROUND (DECODE (NVL (M.GRAVADOUNITARIO, 'N'), 'S', M.QTCONT, 1) * (NVL (M.VLIPI, 0) + DECODE (N.AGREGASTVLMERC
           , 'S', 0, NVL (M.VLST, 0)) + NVL (M.VLFRETE, 0)), 2))) VLPRODUTO,
           ROUND (DECODE (NVL (M.GRAVADOUNITARIO, 'N'), 'S', M.QTCONT, 1) * NVL (M.VLDESCONTO, 0), 2) VLDESCONTO,
           NVL (M.SITTRIBUT, '90') SITTRIBUT,
           NULL IMPORTADO,
           NULL ORIGMERCTRIB,
           M.CODFISCAL,
           0 VLBASEICMS,
           0 PERCICM,
           0 VLICMS,
           0 VLBASEICMSST,
           0 ALIQICMS_INTERNA,
           0 ALIQICMS_EXTERNA,
           0 VLST,
           0 VLSTGUIA,
           NULL CODIPI,
           0 VLBASEIPI,
           0 PERCIPI,
           0 VLIPI,
           NULL CLASSIFICFISCAL,
           0 PERCBASERED,
           0 QTLITRAGEM,
           M.CODSITTRIBPISCOFINS CST_PISCOFINS,
           ROUND (DECODE (NVL (M.GRAVADOUNITARIO, 'N'), 'S', M.QTCONT, 1) * M.VLBASEPISCOFINS, 2) VLBASEPISCOFINS,
           ROUND (DECODE (NVL (M.GRAVADOUNITARIO, 'N'), 'S', M.QTCONT, 1) * M.VLBASEPISCOFINS, 2) VLBASECOFINS,
           M.PERPIS,
           M.PERCOFINS,
           ROUND (DECODE (NVL (M.GRAVADOUNITARIO, 'N'), 'S', M.QTCONT, 1) * M.VLPIS, 2) VLPIS,
           ROUND (DECODE (NVL (M.GRAVADOUNITARIO, 'N'), 'S', M.QTCONT, 1) * M.VLCOFINS, 2) VLCOFINS,
           '999' EXTIPI,
           M.CODOPER,
           0 VLISENTAS_CF,
           0 VLNAOTRIB_CF,
           0 VLST_CF,
           NVL (M.TIPOMERC, P.TIPOMERC) TIPOMOVBEM,
           P.CODGENPROCONIMO CODGENERO,
           0 VLAGREGADOMVA,
           ROUND (DECODE (NVL (M.GRAVADOUNITARIO, 'N'), 'S', M.QTCONT, 1) * NVL (M.VLFRETE, 0), 2) VLFRETE,
           ROUND (DECODE (NVL (M.GRAVADOUNITARIO, 'N'), 'S', M.QTCONT, 1) * NVL (M.VLOUTRASDESP, 0), 2) VLOUTRASDESP,
           0 VLICMSPARTILHA,
           0 CODUSUR,
           N.CODFORNEC AS CODFORCLI,
           'E' AS TIPOMOV
      FROM PCNFENT N,
           PCMOVCIAP M,
           PCPRODCIAP P
     WHERE N.NUMTRANSENT = M.NUMTRANSENT
       AND P.CODPROD = M.CODPROD
       AND N.ESPECIE = 'NF'
       AND N.TIPODESCARGA NOT IN (
        '6', '7', '8', 'T'
    )
       AND M.QTCONT > 0
       AND N.VLTOTAL > 0
       AND NVL (NVL (M.TIPOMERC, P.TIPOMERC), 'X') <> 'FR'
       AND N.ESPECIE = 'NF'
       AND NVL (N.MODELO, 'X') <> '22'
-----------------------------------------------------------------------------------

    UNION ALL
-----------------------------------------------------------------------------------

-- TIPO 'E' = Entrada - TIPOMOV 'IC' = Item Complementar => NFs com Entradas Complementar

    SELECT 'IC' TIPOPROCESSO,
           NVL (N.CODFILIALNF, N.CODFILIAL) CODFILIAL,
           L.NUMTRANSENT NUMTRANSACAO,
           L.NUMNOTA,
           N.DTENT DATA,
           NULL DTCANCEL,
           DECODE (SUM (NVL (L.VLIPI, 0)), 0, 'N', 'S') CALCCREDIPI,
           'S' GERAICMSLIVROFISCAL,
           N.TIPODESCARGA TIPONOTA,
           99999999 CODPROD,
           'ITEM COMPLEMENTAR' DSCPRODUTO,
           NULL CODINTERNO,
           NULL NCM,
           NULL NATUREZAPRODUTO,
           NULL NUMLOTE,
           1 NUMSEQ,
           1 QTCONT,
           0 CUSTOFINEST,
           1 QTCONT_FATORCONVTRIB,
           SUM (L.VLDESDOBRADO) VLCONTABIL,
           SUM (GREATEST (L.VLDESDOBRADO - NVL (L.VLST, 0) - NVL (L.VLIPI, 0), 0)) PUNITCONT,
           0 PTABELA,
           'UN' UNIDADE_MOV,
           'UN' UNIDADE,
           'UNIDADE' EMBALAGEM,
           1 QTUNITCX_FATORCONVTRIB,
           SUM (GREATEST (L.VLDESDOBRADO - NVL (L.VLST, 0) - NVL (L.VLIPI, 0), 0)) VLPRODUTO,
           N.VLDESCONTO / GREATEST (NVL ((
               SELECT COUNT (1)
                 FROM PCNFBASEENT
                WHERE NUMTRANSENT = L.NUMTRANSENT
                  AND NUMNOTA = L.NUMNOTA
           ), 1), 1) VLDESCONTO,
           NVL (L.SITTRIBUT, '90') SITTRIBUT,
           'N' IMPORTADO,
           NULL ORIGMERCTRIB,
           L.CODFISCAL,
           SUM (L.VLBASE) VLBASEICMS,
           L.PERCICM,
           SUM (L.VLICMS) VLICMS,
           SUM (L.BASEST) VLBASEICMSST,
           0 ALIQICMS_INTERNA,
           0 ALIQICMS_EXTERNA,
           SUM (L.VLST) VLST,
           SUM (NVL (L.VLSTFORANF, 0)) VLSTGUIA,
           NULL CODIPI,
           SUM (L.VLBASEIPI) VLBASEIPI,
           L.PERCIPI,
           SUM (L.VLIPI) VLIPI,
           NULL CLASSIFICFISCAL,
           0 PERCBASERED,
           0 QTLITRAGEM,
           NVL ((
               SELECT MAX (PC.CODTRIBPISCOFINS)
                 FROM PCNFENTPISCOFINS PC, PCNFBASE B
                WHERE PC.NUMTRANSENT = B.NUMTRANSENT
                  AND PC.NUMTRANSPISCOFINS = B.NUMTRANSPISCOFINS
                  AND B.NUMTRANSENT = N.NUMTRANSENT
                  AND B.CODCONT = N.CODCONT
                  AND B.CODFISCAL = L.CODFISCAL
           ), N.CODTRIBPISCOFINS) CST_PISCOFINS,
           NVL ((
               SELECT SUM (NVL (PC.VLBASEPIS, 0))
                 FROM PCNFENTPISCOFINS PC, PCNFBASE B
                WHERE PC.NUMTRANSENT = B.NUMTRANSENT
                  AND PC.NUMTRANSPISCOFINS = B.NUMTRANSPISCOFINS
                  AND B.NUMTRANSENT = N.NUMTRANSENT
                  AND B.CODCONT = N.CODCONT
                  AND B.CODFISCAL = L.CODFISCAL
           ), (N.VLBASEPIS / GREATEST (NVL ((
               SELECT COUNT (1)
                 FROM PCNFBASEENT
                WHERE NUMTRANSENT = L.NUMTRANSENT
                  AND NUMNOTA = L.NUMNOTA
           ), 1), 1))) VLBASEPISCOFINS,
           NVL ((
               SELECT SUM (NVL (PC.VLBASECOFINS, 0))
                 FROM PCNFENTPISCOFINS PC, PCNFBASE B
                WHERE PC.NUMTRANSENT = B.NUMTRANSENT
                  AND PC.NUMTRANSPISCOFINS = B.NUMTRANSPISCOFINS
                  AND B.NUMTRANSENT = N.NUMTRANSENT
                  AND B.CODCONT = N.CODCONT
                  AND B.CODFISCAL = L.CODFISCAL
           ), (N.VLBASECOFINS / GREATEST (NVL ((
               SELECT COUNT (1)
                 FROM PCNFBASEENT
                WHERE NUMTRANSENT = L.NUMTRANSENT
                  AND NUMNOTA = L.NUMNOTA
           ), 1), 1))) VLBASECOFINS,
           NVL ((
               SELECT MAX (PC.PERPIS)
                 FROM PCNFENTPISCOFINS PC, PCNFBASE B
                WHERE PC.NUMTRANSENT = B.NUMTRANSENT
                  AND PC.NUMTRANSPISCOFINS = B.NUMTRANSPISCOFINS
                  AND B.NUMTRANSENT = N.NUMTRANSENT
                  AND B.CODCONT = N.CODCONT
                  AND B.CODFISCAL = L.CODFISCAL
           ), N.PERPIS) PERPIS,
           NVL ((
               SELECT MAX (PC.PERCOFINS)
                 FROM PCNFENTPISCOFINS PC, PCNFBASE B
                WHERE PC.NUMTRANSENT = B.NUMTRANSENT
                  AND PC.NUMTRANSPISCOFINS = B.NUMTRANSPISCOFINS
                  AND B.NUMTRANSENT = N.NUMTRANSENT
                  AND B.CODCONT = N.CODCONT
                  AND B.CODFISCAL = L.CODFISCAL
           ), N.PERCOFINS) PERCOFINS,
           NVL ((
               SELECT SUM (NVL (PC.VLPIS, 0))
                 FROM PCNFENTPISCOFINS PC, PCNFBASE B
                WHERE PC.NUMTRANSENT = B.NUMTRANSENT
                  AND PC.NUMTRANSPISCOFINS = B.NUMTRANSPISCOFINS
                  AND B.NUMTRANSENT = N.NUMTRANSENT
                  AND B.CODCONT = N.CODCONT
                  AND B.CODFISCAL = L.CODFISCAL
           ), (N.VLPIS / GREATEST (NVL ((
               SELECT COUNT (1)
                 FROM PCNFBASEENT
                WHERE NUMTRANSENT = L.NUMTRANSENT
                  AND NUMNOTA = L.NUMNOTA
           ), 1), 1))) VLPIS,
           NVL ((
               SELECT SUM (NVL (PC.VLCOFINS, 0))
                 FROM PCNFENTPISCOFINS PC, PCNFBASE B
                WHERE PC.NUMTRANSENT = B.NUMTRANSENT
                  AND PC.NUMTRANSPISCOFINS = B.NUMTRANSPISCOFINS
                  AND B.NUMTRANSENT = N.NUMTRANSENT
                  AND B.CODCONT = N.CODCONT
                  AND B.CODFISCAL = L.CODFISCAL
           ), (N.VLCOFINS / GREATEST (NVL ((
               SELECT COUNT (1)
                 FROM PCNFBASEENT
                WHERE NUMTRANSENT = L.NUMTRANSENT
                  AND NUMNOTA = L.NUMNOTA
           ), 1), 1))) VLCOFINS,
           '999' EXTIPI,
           'XX' CODOPER,
           0 VLISENTAS_CF,
           0 VLNAOTRIB_CF,
           0 VLST_CF,
           NULL TIPOMOVBEM,
           NULL CODGENERO,
           0 VLAGREGADOMVA,
           SUM (NVL (L.VLFRETE, 0)) VLFRETE,
           SUM (NVL (L.VLOUTRASDESP, 0)) VLOUTRASDESP,
           0 VLICMSPARTILHA,
           0 CODUSUR,
           N.CODFORNEC AS CODFORCLI,
           'E' AS TIPOMOV
      FROM PCNFBASEENT L,
           PCNFENT N
     WHERE L.NUMTRANSENT = N.NUMTRANSENT
       AND L.NUMNOTA = N.NUMNOTA
       AND (L.VLTOTAL > 0
        OR L.VLBASE > 0
        OR L.VLICMS > 0
        OR L.VLOUTRAS > 0
        OR L.VLISENTAS > 0)
       AND NOT EXISTS (
        SELECT CODPROD
          FROM PCMOV
         WHERE NUMTRANSENT = L.NUMTRANSENT
           AND NUMNOTA = L.NUMNOTA
           AND ROWNUM = 1
    )
       AND NOT EXISTS (
        SELECT CODPROD
          FROM PCMOVCIAP
         WHERE NUMTRANSENT = L.NUMTRANSENT
    )
     GROUP BY N.TIPODESCARGA,
              NVL (N.CODFILIALNF, N.CODFILIAL),
              N.NUMTRANSENT,
              L.NUMTRANSENT,
              L.NUMNOTA,
              N.DTENT,
              N.CODCONT,
              N.VLDESCONTO,
              NVL (L.SITTRIBUT, '90'),
              L.CODFISCAL,
              L.PERCICM,
              L.PERCIPI,
              N.CODTRIBPISCOFINS,
              N.VLBASEPIS,
              N.VLBASECOFINS,
              N.PERPIS,
              N.PERCOFINS,
              N.VLPIS,
              N.VLCOFINS,
              N.CODFORNEC
-----------------------------------------------------------------------------------

------------------------------- SA�DAS --------------------------------------------

-----------------------------------------------------------------------------------

    UNION ALL
-----------------------------------------------------------------------------------

-- TIPOPROCESSO 'N' = Normal => NFs com Saidas Normais

-- TIPOPROCESSO 'D' = Devolu��o de Compras => NFs com Sa�das de Devolu��o

    SELECT CASE
        WHEN (NVL (M.CODOPER, 'X') <> 'SD') THEN 'N'
        ELSE 'D'
    END TIPOPROCESSO,
           NVL (M.CODFILIALNF, M.CODFILIAL) CODFILIAL,
           M.NUMTRANSVENDA NUMTRANSACAO,
           M.NUMNOTA,
           M.DTMOV DATA,
           M.DTCANCEL,
           NVL (M.CALCCREDIPI, 'N') CALCCREDIPI,
           NVL (M.GERAICMSLIVROFISCAL, 'S') GERAICMSLIVROFISCAL,
           DECODE (NVL (M.CODOPER, 'X'), 'SD', 'D', 'N') TIPONOTA,
           M.CODPROD,
           NVL (M.DESCRICAO, P.DESCRICAO) DSCPRODUTO,
           M.CODINTERNO,
           NVL (M.NBM, P.NBM) NCM,
           P.NATUREZAPRODUTO,
           M.NUMLOTE,
           M.NUMSEQ,
           M.QTCONT,
           M.CUSTOFINEST,
           M.QTCONT * DECODE (NVL (P.FATORCONVTRIB, 0), 0, 1, P.FATORCONVTRIB) QTCONT_FATORCONVTRIB,
           CASE
               WHEN (NVL (M.CODOPER, 'X') <> 'SD') THEN ROUND (M.QTCONT * (M.PUNITCONT + NVL (M.VLFRETE, 0) + NVL (M.VLOUTROS, 0)
               ), 2)
               WHEN (M.PUNITCONT <> M.PTABELA AND M.VLOUTRASDESP > 0) THEN ROUND (M.QTCONT * (M.PTABELA + NVL (M.VLOUTRASDESP, 0)), 2)
               ELSE ROUND (M.QTCONT * (M.PUNITCONT + NVL (M.VLOUTRASDESP, 0)), 2)
           END VLCONTABIL,
           M.PUNITCONT,
           M.PTABELA,
           CASE
               WHEN (NVL (M.CODOPER, 'X') <> 'SD') THEN DECODE (NVL (P.FATORCONVTRIB, 0), 0, P.UNIDADE, NVL (P.UNIDADETRIB, P.UNIDADE
               ))
               ELSE DECODE (NVL (P.FATORCONVTRIB, 0), 0, (
                   CASE
                       WHEN (P.UNIDADE <> P.UNIDADEMASTER)
                          AND (P.QTUNITCX > 1) THEN DECODE ((
                           SELECT MAX (NVL (NUMTAB, 0))
                             FROM PCNFSAID
                            WHERE NUMTRANSVENDA = M.NUMTRANSVENDA
                              AND NUMNOTA = M.NUMNOTA
                       ), 0, P.UNIDADE, P.UNIDADEMASTER)
                       ELSE P.UNIDADE
                   END
               ), NVL (P.UNIDADETRIB, P.UNIDADE))
           END UNIDADE_MOV,
           P.UNIDADE,
           P.EMBALAGEM,
           CASE
               WHEN (NVL (M.CODOPER, 'X') <> 'SD') THEN DECODE (NVL (P.FATORCONVTRIB, 0), 0, 1, P.FATORCONVTRIB)
               ELSE DECODE (NVL (P.FATORCONVTRIB, 0), 0,
                            CASE
                                WHEN (P.UNIDADE <> P.UNIDADEMASTER)
                                   AND (P.QTUNITCX > 1) THEN DECODE ((
                                    SELECT MAX (NVL (NUMTAB, 0))
                                      FROM PCNFSAID
                                     WHERE NUMTRANSVENDA = M.NUMTRANSVENDA
                                       AND NUMNOTA = M.NUMNOTA
                                ), 0, 1, P.QTUNITCX)
                                ELSE 1
                            END, P.FATORCONVTRIB)
           END QTUNITCX_FATORCONVTRIB,
           CASE
               WHEN (NVL (M.CODOPER, 'X') <> 'SDF') THEN ROUND ((M.QTCONT * DECODE (MC.BONIFIC, 'S', NVL (M.PBONIFIC, 0), M.PUNITCONT
               + DECODE (NVL (PARAMFILIAL.OBTERCOMOVARCHAR2 ('PRECOUTILIZADONFE', NVL (M.CODFILIALNF, M.CODFILIAL)), 'B'), 'B', NVL
               (M.VLDESCONTO, 0), 0) - NVL (M.ST, 0) - NVL (M.VLIPI, 0))), 2)
               ELSE ROUND (M.QTCONT * (M.PUNITCONT + NVL (M.VLDESCONTO, 0) - NVL (M.ST, 0) - NVL (M.VLIPI, 0) - DECODE (NVL (M.CODOPER
               , 'X'), 'SD', NVL (M.VLFRETE, 0), 0)), 2)
           END VLPRODUTO,
           CASE
               WHEN (NVL (M.CODOPER, 'X') <> 'SD') THEN ROUND (DECODE (NVL (PARAMFILIAL.OBTERCOMOVARCHAR2 ('PRECOUTILIZADONFE', NVL
               (M.CODFILIALNF, M.CODFILIAL)), 'B'), 'B', (M.QTCONT * NVL (M.VLDESCONTO, 0)), 0), 2)
               ELSE ROUND (M.QTCONT * NVL (M.VLDESCONTO, 0), 2)
           END VLDESCONTO,
           M.SITTRIBUT,
           M.IMPORTADO,
           PF.ORIGMERCTRIB,
           M.CODFISCAL,
       --ALTERADO JEFF 16.10.2019 POIS NAO TRAZ O VALOR DE FRETE NA BASE

       --ROUND(M.QTCONT * M.BASEICMS, 2) VLBASEICMS,

           ROUND (M.QTCONT * (NVL (M.BASEICMS, 0) + NVL (MC.VLBASEFRETE, 0) + NVL (MC.VLBASEOUTROS, 0)), 2) VLBASEICMS,
           NVL (M.PERCICM, 0) PERCICM,
       --ALTERADO JEFF 16.10.2019 POIS NAO TRAZ O VALOR DE FRETE NA BASE

       --ROUND(NVL(M.QTCONT * MC.VLICMS, ROUND(M.QTCONT * NVL(M.BASEICMS, 0) * NVL(M.PERCICM, 0) / 100, 2)), 2) VLICMS, 

           ROUND (NVL (M.QTCONT * MC.VLICMS, ROUND (M.QTCONT * (NVL (M.BASEICMS, 0) + NVL (MC.VLBASEFRETE, 0) + NVL (MC.VLBASEOUTROS
           , 0)) * NVL (M.PERCICM, 0) / 100, 2)), 2) VLICMS,
           ROUND (M.QTCONT * NVL (M.BASEICST, 0), 2) VLBASEICMSST,
           T.ALIQICMS1 ALIQICMS_INTERNA,
           T.ALIQICMS2 ALIQICMS_EXTERNA,
           ROUND (M.QTCONT * NVL (M.ST, 0), 2) VLST,
           ROUND (M.QTCONT * NVL (M.VLDESPADICIONAL, 0), 2) VLSTGUIA,
           MC.CODSITTRIBIPI CODIPI,
           ROUND (M.QTCONT * NVL (M.VLBASEIPI, 0), 2) VLBASEIPI,
           NVL (M.PERCIPI, 0) PERCIPI,
           ROUND (M.QTCONT * NVL (M.VLIPI, 0), 2) VLIPI,
           SUBSTR (TRIM (P.CLASSIFICFISCAL), 1, 2) CLASSIFICFISCAL,
           NVL (M.PERCBASERED, 0) PERCBASERED,
           DECODE (MC.USAPISCOFINSLIT, 'S', NVL (MC.QTLITRAGEM, P.LITRAGEM), 0) QTLITRAGEM,
           M.CODSITTRIBPISCOFINS CST_PISCOFINS,
           ROUND (DECODE (DECODE (MC.USAPISCOFINSLIT, 'S', NVL (MC.QTLITRAGEM, P.LITRAGEM), 0), 0, M.QTCONT * NVL (M.VLBASEPISCOFINS
           , 0), M.QTCONT * NVL (MC.QTLITRAGEM, P.LITRAGEM) * DECODE (NVL (M.VLPIS, 0), 0, 0, 1)), 2) VLBASEPISCOFINS,
           ROUND (DECODE (DECODE (MC.USAPISCOFINSLIT, 'S', NVL (MC.QTLITRAGEM, P.LITRAGEM), 0), 0, M.QTCONT * NVL (M.VLBASEPISCOFINS
           , 0), M.QTCONT * NVL (MC.QTLITRAGEM, P.LITRAGEM) * DECODE (NVL (M.VLPIS, 0), 0, 0, 1)), 2) VLBASECOFINS,
           DECODE (NVL (DECODE (MC.USAPISCOFINSLIT, 'S', NVL (MC.QTLITRAGEM, P.LITRAGEM), 0), 0), 0, M.PERPIS, M.VLPIS) PERPIS,
           DECODE (NVL (DECODE (MC.USAPISCOFINSLIT, 'S', NVL (MC.QTLITRAGEM, P.LITRAGEM), 0), 0), 0, M.PERCOFINS, M.VLCOFINS) PERCOFINS
           ,
           ROUND (DECODE (DECODE (MC.USAPISCOFINSLIT, 'S', NVL (MC.QTLITRAGEM, P.LITRAGEM), 0), 0, M.QTCONT * NVL (M.VLPIS, 0), M
           .QTCONT * NVL (MC.QTLITRAGEM, P.LITRAGEM) * NVL (M.VLPIS, 0)), 2) VLPIS,
           ROUND (DECODE (DECODE (MC.USAPISCOFINSLIT, 'S', NVL (MC.QTLITRAGEM, P.LITRAGEM), 0), 0, M.QTCONT * NVL (M.VLCOFINS, 0)
           , M.QTCONT * NVL (MC.QTLITRAGEM, P.LITRAGEM) * NVL (M.VLCOFINS, 0)), 2) VLCOFINS,
           MC.EXTIPI,
           M.CODOPER,
           ROUND (DECODE (SUBSTR (M.CODECF, 1, 1), 'I', M.QTCONT * (M.PUNITCONT - NVL (M.BASEICMS, 0)), 0), 2) VLISENTAS_CF,
           ROUND (DECODE (SUBSTR (M.CODECF, 1, 1), 'N', M.QTCONT * (M.PUNITCONT - NVL (M.BASEICMS, 0)), 0), 2) VLNAOTRIB_CF,
           ROUND (DECODE (SUBSTR (M.CODECF, 1, 1), 'F', M.QTCONT * (M.PUNITCONT - NVL (M.BASEICMS, 0)), 0), 2) VLST_CF,
           NULL TIPOMOVBEM,
           P.CODGENEROFISCAL CODGENERO,
           MC.PERCMVAORIG VLAGREGADOMVA,
           ROUND (M.QTCONT * NVL (M.VLFRETE, 0), 2) VLFRETE,
           ROUND (M.QTCONT * NVL (M.VLOUTRASDESP, 0), 2) VLOUTRASDESP,
           (ROUND (NVL (M.QTCONT, 0) * NVL (MC.VLICMSPARTREM, 0), 2) + ROUND (NVL (M.QTCONT, 0) * NVL (MC.VLICMSPARTDEST, 0), 2) +
           ROUND (NVL (M.QTCONT, 0) * NVL (MC.VLFCPPART, 0), 2)) VLICMSPARTILHA,
           M.CODUSUR,
           N.CODCLI AS CODFORCLI,
           'S' AS TIPOMOV
      FROM PCMOV M,
           PCPRODUT P,
           PCTRIBUT T,
           PCMOVCOMPLE MC,
           PCPRODFILIAL PF,
           PCNFSAID N
     WHERE PF.CODPROD (+) = M.CODPROD
       AND PF.CODFILIAL (+) = NVL (M.CODFILIALNF, M.CODFILIAL)
       AND MC.NUMTRANSITEM (+) = M.NUMTRANSITEM
       AND N.NUMTRANSVENDA (+) = M.NUMTRANSVENDA
       AND P.CODPROD = M.CODPROD
       AND M.CODST = T.CODST (+)
       AND M.QTCONT > 0
       AND M.STATUS IN (
        'A', 'AB'
    )
       AND DECODE (NVL (MC.BONIFIC, 'X'), 'S', M.PBONIFIC, M.PUNITCONT) > 0
-----------------------------------------------------------------------------------

    UNION ALL
-----------------------------------------------------------------------------------

-- TIPOPROCESSO 'C' = CIAP => NFs com Sa�das de CIAP

    SELECT 'C' TIPOPROCESSO,
           M.CODFILIAL,
           M.NUMTRANSVENDA NUMTRANSACAO,
           M.NUMNOTA,
           M.DTMOV DATA,
           M.DTCANCEL,
           'N' CALCCREDIPI,
           NVL (M.GERAICMSLIVROFISCAL, 'S') GERAICMSLIVROFISCAL,
           DECODE (NVL (M.CODOPER, 'X'), 'SD', 'D', 'C') TIPONOTA,
           M.CODPROD,
           TRIM (P.DESCRICAO) || ' - ' || TRIM (M.DESCCOMPLEMENTAR) DSCPRODUTO,
           NULL CODINTERNO,
           P.CODNCM NCM,
           NULL NATUREZAPRODUTO,
           NULL NUMLOTE,
           1 NUMSEQ,
           M.QTCONT,
           0 CUSTOFINEST,
           0 QTCONT_FATORCONVTRIB,
           (M.VLITEM) VLCONTABIL,
           DECODE (M.QTCONT, 0, M.VLITEM, (M.VLITEM / M.QTCONT)) PUNITCONT,
           DECODE (M.QTCONT, 0, M.VLITEM, (M.VLITEM / M.QTCONT)) PTABELA,
           'UN' UNIDADE_MOV,
           'UN' UNIDADE,
           P.EMBALAGEM,
           1 QTUNITCX_FATORCONVTRIB,
           M.VLITEM VLPRODUTO,
           ROUND (DECODE (NVL (M.GRAVADOUNITARIO, 'N'), 'S', M.QTCONT, 1) * NVL (M.VLDESCONTO, 0), 2) VLDESCONTO,
           NVL (M.SITTRIBUT, '90') SITTRIBUT,
           NULL IMPORTADO,
           NULL ORIGMERCTRIB,
           M.CODFISCAL,
           0 VLBASEICMS,
           0 PERCICM,
           0 VLICMS,
           0 VLBASEICMSST,
           0 ALIQICMS_INTERNA,
           0 ALIQICMS_EXTERNA,
           0 VLST,
           0 VLSTGUIA,
           NULL CODIPI,
           0 VLBASEIPI,
           0 PERCIPI,
           0 VLIPI,
           NULL CLASSIFICFISCAL,
           0 PERCBASERED,
           0 QTLITRAGEM,
           M.CODSITTRIBPISCOFINS CST_PISCOFINS,
           ROUND (DECODE (NVL (M.GRAVADOUNITARIO, 'N'), 'S', M.QTCONT, 1) * M.VLBASEPISCOFINS, 2) VLBASEPISCOFINS,
           ROUND (DECODE (NVL (M.GRAVADOUNITARIO, 'N'), 'S', M.QTCONT, 1) * M.VLBASEPISCOFINS, 2) VLBASECOFINS,
           M.PERPIS,
           M.PERCOFINS,
           ROUND (DECODE (NVL (M.GRAVADOUNITARIO, 'N'), 'S', M.QTCONT, 1) * M.VLPIS, 2) VLPIS,
           ROUND (DECODE (NVL (M.GRAVADOUNITARIO, 'N'), 'S', M.QTCONT, 1) * M.VLCOFINS, 2) VLCOFINS,
           '999' EXTIPI,
           'ZZ' CODOPER,
           0 VLISENTAS_CF,
           0 VLNAOTRIB_CF,
           0 VLST_CF,
           NVL (M.TIPOMERC, P.TIPOMERC) TIPOMOVBEM,
           P.CODGENPROCONIMO CODGENERO,
           0 VLAGREGADOMVA,
           ROUND (DECODE (NVL (M.GRAVADOUNITARIO, 'N'), 'S', M.QTCONT, 1) * NVL (M.VLFRETE, 0), 2) VLFRETE,
           ROUND (DECODE (NVL (M.GRAVADOUNITARIO, 'N'), 'S', M.QTCONT, 1) * NVL (M.VLOUTRASDESP, 0), 2) VLOUTRASDESP,
           0 VLICMSPARTILHA,
           0 CODUSUR,
           0 CODFORCLI,
           'S' AS TIPOMOV
      FROM PCMOVCIAP M,
           PCPRODCIAP P
     WHERE P.CODPROD = M.CODPROD
       AND (M.VLITEM > 0
        OR M.BASEICMS > 0
        OR M.VLICMS > 0
        OR M.VLFRETE > 0
        OR M.VLOUTRASDESP > 0)
       AND NOT EXISTS (
        SELECT CODPROD
          FROM PCMOV
         WHERE NUMTRANSVENDA = M.NUMTRANSVENDA
           AND NUMNOTA = M.NUMNOTA
           AND ROWNUM = 1
    )
-----------------------------------------------------------------------------------

    UNION ALL
-----------------------------------------------------------------------------------

-- TIPOPROCESSO 'IC' = Item Complementar => NFs com Sa�das Complementar

    SELECT 'IC' TIPOPROCESSO,
           NVL (N.CODFILIALNF, N.CODFILIAL) CODFILIAL,
           L.NUMTRANSVENDA NUMTRANSACAO,
           L.NUMNOTA,
           N.DTSAIDA DATA,
           NULL DTCANCEL,
           DECODE (SUM (L.VLIPI), 0, 'N', 'S') CALCCREDIPI,
           'S' GERAICMSLIVROFISCAL,
           NVL (N.TIPOVENDA, 'X') TIPONOTA,
           99999999 CODPROD,
           'ITEM COMPLEMENTAR' DESCRICAO,
           NULL CODINTERNO,
           '' NBM,
           '' NATUREZAPRODUTO,
           '' NUMLOTE,
           1 NUMSEQ,
           1 QTCONT,
           0 CUSTOFINEST,
           0 QTCONT_FATORCONVTRIB,
           SUM (L.VLDESDOBRADO) VLCONTABIL,
           SUM (L.VLDESDOBRADO) PUNITCONT,
           0 PTABELA,
           'UN' UNIDADE_MOV,
           'UN' UNIDADE,
           'UNIDADE' EMBALAGEM,
           1 QTUNITCX_FATORCONVTRIB,
           SUM (GREATEST (L.VLDESDOBRADO - NVL (L.VLST, 0) - NVL (L.VLIPI, 0), 0)) VLPRODUTO,
           0 VLDESCONTO,
           NVL (SITTRIBUT, '90') SITTRIBUT,
           'N' IMPORTADO,
           NULL ORIGMERCTRIB,
           L.CODFISCAL,
           SUM (L.VLBASE) VLBASEICMS,
           L.PERCICM,
           SUM (L.VLICMS) VLICMS,
           SUM (L.BASEST) VLBASEICMSST,
           0 ALIQICMS_INTERNA,
           0 ALIQICMS_EXTERNA,
           SUM (L.VLST) VLST,
           SUM (NVL (L.VLSTFORANF, 0)) VLSTGUIA,
           NULL CODIPI,
           SUM (L.VLBASEIPI) VLBASEIPI,
           L.PERCIPI,
           SUM (L.VLIPI) VLIPI,
           ' ' CLASSIFICFISCAL,
           0 PERCBASERED,
           0 QTLITRAGEM,
           N.CODSITTRIBPISCOFINS CST_PISCOFINS,
           N.VLBASEPISCOFINS,
           N.VLBASEPISCOFINS VLBASECOFINS,
           N.PERPIS,
           N.PERCOFINS,
           N.VLPIS,
           N.VLCOFINS,
           '999' EXTIPI,
           'ZZ' CODOPER,
           0 VLISENTAS_CF,
           0 VLNAOTRIB_CF,
           0 VLST_CF,
           NULL TIPOMOVBEM,
           NULL CODGENERO,
           0 VLAGREGADOMVA,
           SUM (NVL (L.VLFRETE, 0)) VLFRETE,
           SUM (NVL (L.VLOUTRASDESP, 0)) VLOUTRASDESP,
           0 VLICMSPARTILHA,
           0 CODUSUR,
           N.CODCLI AS CODFORCLI,
           'S' AS TIPOMOV
      FROM PCNFBASESAID L,
           PCNFSAID N
     WHERE L.NUMTRANSVENDA = N.NUMTRANSVENDA
       AND L.NUMNOTA = N.NUMNOTA
       AND (L.VLTOTAL > 0
        OR L.VLBASE > 0
        OR L.VLICMS > 0
        OR L.VLOUTRAS > 0
        OR L.VLISENTAS > 0)
       AND NOT EXISTS (
        SELECT CODPROD
          FROM PCMOV
         WHERE NUMTRANSVENDA = N.NUMTRANSVENDA
           AND NUMNOTA = N.NUMNOTA
           AND ROWNUM = 1
    )
       AND NOT EXISTS (
        SELECT CODPROD
          FROM PCMOVCIAP
         WHERE NUMTRANSVENDA = N.NUMTRANSVENDA
           AND NUMNOTA = N.NUMNOTA
    )
     GROUP BY L.NUMTRANSVENDA,
              L.NUMNOTA,
              NVL (N.CODFILIALNF, N.CODFILIAL),
              N.ESPECIE,
              N.SERIE,
              N.SUBSERIE,
              N.DTENTREGA,
              N.DTSAIDA,
              NVL (N.TIPOVENDA, 'X'),
              NVL (N.CODFILIALNF, N.CODFILIAL),
              NVL (SITTRIBUT, '90'),
              L.CODFISCAL,
              L.PERCICM,
              L.PERCIPI,
              N.CODSITTRIBPISCOFINS,
              N.VLBASEPISCOFINS,
              N.PERPIS,
              N.PERCOFINS,
              N.VLPIS,
              N.VLCOFINS,
              N.CODCLI;