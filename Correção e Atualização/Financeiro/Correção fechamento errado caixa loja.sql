----CORRIGIR CODBANCO
SELECT ROWID, M.CODBANCO, M.* FROM PCMOVCR M WHERE M.NUMTRANS IN (523455);
/
----CORRIGIR CODBANCO
SELECT ROWID, T.CODBANCO, T.* FROM PCPREST T WHERE T.NUMTRANS IN (523455);
/

UPDATE PCPREST SET CODBANCO = 66 WHERE NUMTRANS = 318249 AND CODBANCO = 65;

/*RODAR ATUALIZACAO DO CAIXA NA 507*/
