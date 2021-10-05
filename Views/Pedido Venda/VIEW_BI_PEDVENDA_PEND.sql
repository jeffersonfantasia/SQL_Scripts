CREATE OR REPLACE VIEW VIEW_BI_PEDVENDAPEND AS
    WITH MAXCODIGOBLOQUEIO AS (
        SELECT MAX (CODIGO) CODIGO_MAX,
               NUMPED
          FROM PCBLOQUEIOSPEDIDO B
         GROUP BY NUMPED
    ), MOTIVOBLOQUEIO AS (
        SELECT B.NUMPED,
               B.TIPO,
               B.MOTIVO
          FROM PCBLOQUEIOSPEDIDO B
         INNER JOIN MAXCODIGOBLOQUEIO M ON B.CODIGO = M.CODIGO_MAX
           AND B.NUMPED = M.NUMPED
    )
    SELECT CAST (C.CODFILIAL AS NUMBER) AS CODFILIAL,
           CAST (NVL (I.CODFILIALRETIRA, C.CODFILIAL) AS NUMBER) AS CODFILIALRETIRA,
           (
               CASE
                   WHEN I.CODUSUR = 14 THEN COALESCE (P.DT_LIMITE, I.DATA)
                   ELSE I.DATA
               END
           ) AS DATA,
           I.NUMPED,
           I.CODPROD,
           I.QT,
           I.PVENDA AS VLPROD,
           (I.QT * I.PVENDA) AS VLTOTPROD,
           I.CODUSUR,
           I.POSICAO,
           M.TIPO AS TIPOBLOQUEIO,
           M.MOTIVO AS MOTIVOBLOQUEIO,
           TRIM (C.OBS) AS OBSPEDIDO,
           (
               CASE
                   WHEN I.POSICAO = 'L'
                      AND C.CODCOB = 'ANTE' THEN 'ANTECIPADO'
                   WHEN I.POSICAO = 'L' THEN 'LIBERADO'
                   WHEN I.POSICAO = 'M' THEN 'LOGÍSTICA'
                   WHEN TRIM (C.OBS) LIKE '%FATURAR%' THEN 'DATA PROGRAMADA'
                   WHEN I.POSICAO = 'P' THEN 'PENDENTE'
                   WHEN (I.POSICAO = 'B'
                      AND M.TIPO = 'F') THEN 'BLOQUEADO FINANCEIRO'
                   WHEN (I.POSICAO = 'B'
                      AND M.TIPO = 'C') THEN 'BLOQUEADO COMERCIAL'
                   ELSE 'VERIFICAR'
               END
           ) AS MOTIVOPENDENTE,
           C.CONDVENDA,
           I.CODCLI
      FROM PCPEDI I
      LEFT JOIN PCPEDC C ON I.NUMPED = C.NUMPED
      LEFT JOIN MOTIVOBLOQUEIO M ON I.NUMPED = M.NUMPED
      LEFT JOIN JCPRIORIDADESEPARACAO P ON C.NUMPED = P.NUMPED
     WHERE I.POSICAO NOT IN (
        'C', 'F'
    )
       AND C.CONDVENDA NOT IN (
        8, 10
    );
/