-----------CONSULTAR POSI��O DO PEDIDO BALCAO ------------
SELECT POSICAO, C.* FROM PCPEDC C WHERE NUMPED = 14010175;
SELECT POSICAO, I.* FROM PCPEDI I WHERE NUMPED = 14010175;

-------ALTERAR POSICAO DO PEDIDO PARA 'L'------------
UPDATE PCPEDC SET POSICAO = 'L' WHERE POSICAO = 'B' AND NUMPED = 14010175;
UPDATE PCPEDI SET POSICAO = 'L' WHERE POSICAO = 'B' AND NUMPED = 14010175;
