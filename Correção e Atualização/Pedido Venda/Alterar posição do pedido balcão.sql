-----------CONSULTAR POSI��O DO PEDIDO BALCAO ------------
SELECT POSICAO, C.* FROM PCPEDC C WHERE NUMPED = 27002224;
SELECT POSICAO, I.* FROM PCPEDI I WHERE NUMPED = 27002224;

-------ALTERAR POSICAO DO PEDIDO PARA 'L'------------
UPDATE PCPEDC SET POSICAO = 'L' WHERE POSICAO = 'M' AND NUMPED = 27002224;
UPDATE PCPEDI SET POSICAO = 'L' WHERE POSICAO = 'M' AND NUMPED = 27002224;
