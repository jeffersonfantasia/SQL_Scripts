Value := QueryPesquisa('select pcpedi.percipi from pcpedi where pcpedi.numped = (' + BDEPipeline1['NUMPED']  + ')');


Value :=  ConsultaSQL ('select NUMEROCOM from pcclient where codcli='+pdbEmissaoPC['FILIALCODCLI'])


Value := QueryPesquisa('select broker_pedido_317_icm.codicm from broker_pedido_317_icm where broker_pedido_317_icm.codprod = (' + BDEPipeline1['CODPROD'] + ')and broker_pedido_317_icm.numped = (' + BDEPipeline1['NUMPED'] +')');


Value := ConsultaSQL ('select (matricula || ''- '' || nome) funcionario from pcempr where matricula = (select nvl(CODFUNCFECHA, 0) from PCBONUSC where NUMBONUS = '+ epplnCabecalho1['NUMBONUS']+')')



IF pbdpplnMatricialLaser['TIPOFJ'] = 'J' THEN
IF ( (pbdpplnMatricialLaser['IEENT'] = 'ISENTA') OR (pbdpplnMatricialLaser['IEENT'] = 'ISENTO') )
THEN VALUE:= pbdpplnMatricialLaser['ALIQICMS1'];
     
IF pbdpplnMatricialLaser['TIPOFJ'] = 'F'
THEN VALUE:= pbdpplnMatricialLaser['ALIQICMS1'];
 
IF pbdpplnMatricialLaser['TIPOFJ'] = 'J' THEN
IF ( (pbdpplnMatricialLaser['IEENT'] <> 'ISENTA') OR (pbdpplnMatricialLaser['IEENT'] <> 'ISENTO') )
THEN VALUE:= pbdpplnMatricialLaser['ALIQICMS2'];
     
IF pbdpplnMatricialLaser['TIPOFJ'] = 'F' THEN
IF ( (pbdpplnMatricialLaser['IEENT'] <> 'ISENTA') OR (pbdpplnMatricialLaser['IEENT'] <> 'ISENTO') )
THEN VALUE:= pbdpplnMatricialLaser['ALIQICMS2'];


IF pdbEmissaoPC['TIPOBONIFIC'] = 'B' THEN
Variable9.VALUE := 'BONIFICADO' ;
END; 
