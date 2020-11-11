SELECT DISTINCT (
    CASE
        WHEN V.CODSUPERVISOR IN (
            12
        ) THEN 12
        ELSE V.CODGERENTE
    END
) AS CODGERENTE,
                (
                    CASE
                        WHEN V.CODSUPERVISOR IN (
                            12
                        ) THEN 'B2B'
                        ELSE V.GERENTE
                    END
                ) AS GERENTE
  FROM VIEW_JC_VENDEDOR V;