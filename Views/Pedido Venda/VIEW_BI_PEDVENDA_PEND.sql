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
                      AND C.CODCOB = 'ANTE' THEN 1 --'ANTECIPADO'
                   WHEN I.POSICAO = 'L' THEN 2 --'LIBERADO'
                   WHEN I.POSICAO = 'M' THEN 3 --'LOGÍSTICA'
                   WHEN TRIM (C.OBS) LIKE '%FATURAR%' THEN 4 --'DATA PROGRAMADA'
                   WHEN I.POSICAO = 'P' THEN 5 --'PENDENTE'
                   WHEN (I.POSICAO = 'B'
                      AND M.TIPO = 'F') THEN 6 --'BLOQUEADO FINANCEIRO'
                   WHEN (I.POSICAO = 'B'
                      AND M.TIPO = 'C') THEN 7 --'BLOQUEADO COMERCIAL'
                   ELSE 99
               END
           ) AS CODMOTIVOPENDENTE,
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
        5, 8, 10
    );
/