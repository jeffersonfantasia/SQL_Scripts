----CORRIGIR CODBANCO
SELECT ROWID, M.CODBANCO, M.* FROM PCMOVCR M WHERE M.NUMTRANS IN (549978);
/
----CORRIGIR CODBANCO
SELECT ROWID, T.CODBANCO, T.* FROM PCPREST T WHERE T.NUMTRANS IN (549978);
/

UPDATE PCPREST SET CODBANCO = 83 WHERE NUMTRANS = 549978 AND CODBANCO = 86;

/*RODAR ATUALIZACAO DO CAIXA NA 507*/
