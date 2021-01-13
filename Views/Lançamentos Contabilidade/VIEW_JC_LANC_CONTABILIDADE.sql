CREATE OR REPLACE VIEW VIEW_JC_LANC_CONTABILIDADE AS
    SELECT L.CODFILIAL,
           L.RECNUM,
           L.VALOR,
           L.DTCOMPETENCIA,
           L.DTEMISSAO,
           L.CODCONTA,
           C.GRUPOCONTA,
           L.CODFORNEC,
           C.CONTACONTABIL AS CONTADEBITO,
       /*F.FORNECEDOR,*/
           L.TIPOPARCEIRO,
           L.NUMNOTA,
           L.HISTORICO
      FROM PCLANC L
      LEFT JOIN PCCONTA C ON L.CODCONTA = C.CODCONTA
      LEFT JOIN PCFORNEC F ON L.CODFORNEC = F.CODFORNEC
      LEFT JOIN VIEW_JC_LANC_ADIANTAMENTOFOR AF ON L.RECNUM = AF.RECNUM
      LEFT JOIN VIEW_JC_IMPOSTO_NFSE I ON L.RECNUM = I.RECNUM
     WHERE L.INDICE NOT IN (
        'B'
    )
     /*LANÇAMENTOS ORIUNDOS DA MOVIMETAÇÃO DE ESTOQUE E CUSTO*/
       AND L.DTCANCEL IS NULL
     /*NAO CONSIDERAR LANCAMENTOS CANCELADOS*/
       AND L.DTESTORNOBAIXA IS NULL
     /*NAO CONSIDERAR LANCAMENTOS ESTORNADOS*/
       AND NVL (L.CODROTINABAIXA, 0) NOT IN (
        737, 1207, 1502, 1503, 9806
    )
     /*NAO CONSIDERAR LANCAMENTOS ORIGINADOS DA BAIXA DE DUPLICATA PARA NÃO DUPLICAR*/
       AND C.GRUPOCONTA NOT IN (
        100, 101, 140, 200, 510, 610, 650, 680, 810, 820
    )
     /*NAO CONSIDERAR LANCAMENTOS DESSES GRUPOS*/
       AND L.CODCONTA NOT IN (
        300101, 300102, 565102, 590101, 620101, 620103, 620107
    )
     /*NAO CONSIDERAR LANCAMENTO DESSAS CONTAS*/
       AND NOT (C.GRUPOCONTA = 515
       AND L.CODCONTA NOT IN (
        515106, 515107, 515112, 515113
    ))
     /*RETIRAR CONTAS DE ENCARGOS*/
       AND L.NUMNOTA NOT IN (
        0
    )
     /*DESCONSIDERAR LANÇAMENTOS SEM NUMERO DE NOTA*/
       AND L.TIPOPARCEIRO = 'F'
     /*SOMENTE LANCAMENTOS EM FORNECEDORES*/
       AND L.VALOR > 0
     /*DESCONSIDERAR O LANCAMENTO DE CONTRAPARTIDA DOS MKT E CARTAO*/
       AND L.TIPOLANC = 'C'
     /*SOMENTE LANCAMENTOS CONFIRMADOS*/
 /*FILTROS NAS VIEW RELACIONADAS--*/
       AND AF.RECNUM IS NULL
     /*RETIRAR LANÇAMENTOS DE ADIANTAMENTO AO FORNECEDOR*/
       AND I.RECNUM IS NULL;
     /*RETIRAR LANÇAMENTOS DE IMPOSTOS DE NOTAS DE SERVICOS E FUNCIONARIOS*/
     
/*   AND L.DTEMISSAO BETWEEN '01-DEC-2020' AND '31-DEC-2020'
;/*/