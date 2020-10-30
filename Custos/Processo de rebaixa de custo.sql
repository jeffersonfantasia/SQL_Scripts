/*------------ENCONTRANDO OS CODPROD DOS PRODUTOS----------------*/
SELECT CODFAB,
       CODPROD,
       DESCRICAO
  FROM PCPRODUT
 WHERE CODFAB IN (
    '1001005700027', '1001005700026', '1001005700025', '1201602000136', '1201602000183', '1201602000170', '1201602900127', '1201602900137'
);
/

/*----------------------------ESTOQUE E CUSTO NAS FILIAL 1,2,7----------------*/
SELECT T.CODPROD,
       T.QTESTGER,
       T.VALORULTENT,
       T.CUSTOFIN,
       (
           SELECT QTESTGER
             FROM PCEST
            WHERE CODPROD = T.CODPROD
              AND CODFILIAL = 2
       ) QT_2,
       (
           SELECT VALORULTENT
             FROM PCEST
            WHERE CODPROD = T.CODPROD
              AND CODFILIAL = 2
       ) VLULT_2,
       (
           SELECT CUSTOFIN
             FROM PCEST
            WHERE CODPROD = T.CODPROD
              AND CODFILIAL = 2
       ) CUSTO_2,
       (
           SELECT QTESTGER
             FROM PCEST
            WHERE CODPROD = T.CODPROD
              AND CODFILIAL = 7
       ) QT_7,
       (
           SELECT VALORULTENT
             FROM PCEST
            WHERE CODPROD = T.CODPROD
              AND CODFILIAL = 7
       ) VLULT_7,
       (
           SELECT CUSTOFIN
             FROM PCEST
            WHERE CODPROD = T.CODPROD
              AND CODFILIAL = 7
       ) CUSTO_7
  FROM PCEST T
 WHERE T.CODFILIAL = 1
   AND T.CODPROD IN (
    803135, 803134, 803133, 803132, 801919, 804032, 806620
);
/


/*-----------------------ESTOQUE DE TODAS AS FILIAIS-------------------------------------*/



/*-----------------------------------ANÁLISE DE PEÇAS VENDIDAS POR REDE DE CLIENTES OU CLIENTES----------------------------------*/
SELECT *
  FROM (
    SELECT M.CODPROD,
     /*C.CODREDE, */
           S.CODCLI,
           QT
      FROM PCMOV M,
           PCNFSAID S,
           PCCLIENT C
     WHERE M.NUMTRANSVENDA = S.NUMTRANSVENDA
       AND C.CODCLI = S.CODCLI
       AND S.CONDVENDA = 1
       AND S.DTSAIDA > TO_DATE ('01/01/2019', 'DD/MM/YYYY')
       AND M.CODPROD IN (
        803135, 803134, 803133, 803132, 802852, 804032, 806620
    )
) PIVOT (
    SUM (QT)
        /* FOR CODREDE IN (272, 254, 459, 285, 248, 384, 457, 455, 249, 300, 474, 599, 445, 583, 314, 584, 250, 588, 554, 429, 471, 415)*/
    FOR CODCLI
    IN (7354, 410, 386, 388, 4358, 7644, 8645, 7831)
)
 ORDER BY CODPROD
/