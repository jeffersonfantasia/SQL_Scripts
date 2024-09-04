SELECT JSON_ARRAYAGG(
           JSON_OBJECT(
               'id' VALUE A.CODCLI,
               'nome' VALUE A.CLIENTE,
               'endereco' VALUE JSON_OBJECT(
                   'rua' VALUE A.ENDERENT,
                   'bairro' VALUE A.BAIRROENT
               )
           )
       ) AS JSONRESULT
FROM PCCLIENT A
WHERE A.CODCLI IN (1, 2);
