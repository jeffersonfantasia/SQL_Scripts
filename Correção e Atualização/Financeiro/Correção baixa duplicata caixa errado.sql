--VERIFICAR BAIXA NA PCPREST INFORMANDO NUMTRANS
SELECT P.CODBANCO, P.* FROM PCPREST P WHERE P.NUMTRANS = &NUMTRANS;

--UPDATE NA PCPREST CORRIGINDO O CAIXA
UPDATE PCPREST SET CODBANCO = 85 WHERE NUMTRANS = &NUMTRANS;

--VERIFICAR LANCAMENTO NA PCMOVCR
SELECT * FROM PCMOVCR M WHERE M.NUMTRANS = &NUMTRANS;

--UPDATE NA PCMOVCR CORRIGINDO O CAIXA
UPDATE PCMOVCR SET CODBANCO = 85 WHERE NUMTRANS = &NUMTRANS;

--CORRIGIR CAIXA NA SANGRIA
SELECT V.ROWID, V.* FROM PCVALECX V WHERE V.DTLANC = TO_DATE('09/11/2023', 'DD/MM/YYYY');

--REALIZAR O RECALCULO DO SALDO DOS CAIXAS ENVOLVIDOS NA ROT 507
