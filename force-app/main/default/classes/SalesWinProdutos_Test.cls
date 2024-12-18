@isTest
public with sharing class SalesWinProdutos_Test {
    
    @TestSetup
    static void makeData(){

        FilialFaturamento__c filialfaturamento = new FilialFaturamento__c();
            filialfaturamento.name = 'FILIAL OSASCO';
            filialfaturamento.cep__c = '06230110';
            filialfaturamento.cnpj__c = '16557984000146';
            filialfaturamento.codigoerp__c = '01';
            filialfaturamento.codigoempresaerp__c = '0101';
            filialfaturamento.codigofilialerp__c = '01';
            filialfaturamento.uf__c = 'SP';
        insert filialfaturamento;


        Pricebook2 pricebook2 = new Pricebook2();
            pricebook2.name = 'Rede Varejo e Atacado - FOB - SC';
            pricebook2.isactive = true;
            pricebook2.canal_venda_catalogo__c = 'Varejo rede;Home center;Atacadista';
            pricebook2.empresa__c = 'Salvabras';
            pricebook2.icms_simples__c = '12%';
            pricebook2.estado_catalogo__c = 'SC';
            pricebook2.codigoexclusivomercos__c = '3072741';
            pricebook2.statusintegracaomercos__c = 'Pendente';
            pricebook2.filialdefaturamento__c = filialfaturamento.Id;
            pricebook2.tipodefrete__c = 'FOB';
        insert pricebook2;

        Product2 product2_produtodistribuicao = new Product2();
            product2_produtodistribuicao.RecordTypeId = Schema.SObjectType.Product2.getRecordTypeInfosByDeveloperName().get('ProdutoDistribuicao').getRecordTypeId();
            product2_produtodistribuicao.name = 'Salva Metais 0,10m x 75m';
            product2_produtodistribuicao.productcode = 'P00022';
            product2_produtodistribuicao.description = 'Proteção para metais e maçanetas';
            product2_produtodistribuicao.isactive = true;
            product2_produtodistribuicao.family = 'Proteção para metais';
            product2_produtodistribuicao.displayurl = 'https://salvabras.com.br/arquivos-produtos/salva-metais-produto.jpg';
            product2_produtodistribuicao.altura__c = 0.21;
            product2_produtodistribuicao.largura__c = 0.055;
            product2_produtodistribuicao.comprimento__c = 0.055;
            product2_produtodistribuicao.ncm__c = 39201099;
            product2_produtodistribuicao.peso_kg__c = 0.20;
            product2_produtodistribuicao.calculo_ipi__c = 0.000000;
            product2_produtodistribuicao.embalagem_master__c = 'Caixa';
            product2_produtodistribuicao.tipo_de_produto__c = 'Salva metal';
            product2_produtodistribuicao.metragem__c = 1.00;
            product2_produtodistribuicao.codigoerp__c = 'P00022';
            product2_produtodistribuicao.statusintegracaomercos__c = 'Não necessário';
            product2_produtodistribuicao.filialdefaturamento__c = filialfaturamento.id;
            product2_produtodistribuicao.minimumquantity__c = 10;
        insert product2_produtodistribuicao;

        


        PricebookEntry pricebookentryPadrao = new PricebookEntry();
            pricebookentryPadrao.pricebook2id = Test.getStandardPricebookId();
            pricebookentryPadrao.product2id = product2_produtodistribuicao.Id;
            pricebookentryPadrao.unitprice = 0.00;
            pricebookentryPadrao.isactive = true;
            pricebookentryPadrao.usestandardprice = false;
            pricebookentryPadrao.fretedelista__c = 0.01;
        insert pricebookentryPadrao;


        PricebookEntry pricebookentry = new PricebookEntry();
            pricebookentry.pricebook2id = pricebook2.id;
            pricebookentry.product2id = product2_produtodistribuicao.Id;
            pricebookentry.unitprice = 0.00;
            pricebookentry.isactive = true;
            pricebookentry.usestandardprice = false;
            pricebookentry.fretedelista__c = 0.01;
        insert pricebookentry;

        Account account_vendedor = new Account();
            account_vendedor.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Vendedor').getRecordTypeId();
            account_vendedor.name = 'SALVABRAS SOLUCOES EM PROTECAO LTDA';
            account_vendedor.billingstreet = 'R ANHANGUERA, 425 , S/N, PIRATININGA';
            account_vendedor.billingcity = 'OSASCO';
            account_vendedor.billingstate = 'SP';
            account_vendedor.billingpostalcode = '06230110';
            account_vendedor.billingcountry = 'Brasil';
            account_vendedor.billinglatitude = -23.519941300000000;
            account_vendedor.billinglongitude = -46.794076300000000;
            account_vendedor.shippingstreet = 'R ANHANGUERA, 425 , S/N, PIRATININGA';
            account_vendedor.shippingcity = 'OSASCO';
            account_vendedor.shippingstate = 'SP';
            account_vendedor.shippingpostalcode = '06230110';
            account_vendedor.shippingcountry = 'Brasil';
            account_vendedor.shippinglatitude = -23.519941300000000;
            account_vendedor.shippinglongitude = -46.794076300000000;
            account_vendedor.phone = '+55 (55) 55113-2882';
            account_vendedor.buscacepconta__c = 'ativo_busca_cep_conta';
            account_vendedor.quantidade_de_lojas__c = '1';
            account_vendedor.status_conta_off__c = 'Cliente';
            account_vendedor.activecamp__activecampaign_id__c = '33920';
            account_vendedor.bairro__c = 'PIRATININGA';
            account_vendedor.complemento__c = 'S/N';
            account_vendedor.activecamp__activecampaign_sync_status__c = 'Waiting For Next Sync';
            account_vendedor.activecamp__last_synced__c = DateTime.valueOf('2022-05-07 19:03:00');
            account_vendedor.loja_conta__c = '01';
            account_vendedor.tipo_pessoa_conta__c = 'J - Juridica';
            account_vendedor.pais_conta__c = '105';
            account_vendedor.bairrocobranca__c = 'PIRATININGA';
            account_vendedor.capitalsocial__c = 1000000.00;
            account_vendedor.codigoerpvendedor__c = 'V00001';
            account_vendedor.pais_bacen_conta__c = '01058';
            account_vendedor.codigoempresa__c = '01';
            account_vendedor.codigofilial__c = '01';
            account_vendedor.codigomunicipiocobranca__c = '3534401';
            account_vendedor.codigomunicipio__c = '3534401';
            account_vendedor.codigo_emitente__c = 'XXX';
            account_vendedor.comissao__c = 1.00;
            account_vendedor.complementocobranca__c = 'S/N';
            account_vendedor.contribuinte__c = false;
            account_vendedor.dataaberturaempresa__c = Date.valueOf('2012-07-04 00:00:00');
            account_vendedor.documento__c = '16.557.984/0001-46';
            account_vendedor.email__c = 'financeiro@salvabras.com.br';
            account_vendedor.naoconsultarcepcorreio__c = true;
            account_vendedor.naturezaintegracao__c = '206-2 - Sociedade Empresária Limitada';
            account_vendedor.nomeempresarial__c = 'SALVABRAS SOLUCOES EM PROTECAO LTDA';
            account_vendedor.nomefantasia__c = 'SALVABRAS';
            account_vendedor.numerocobranca__c = '425';
            account_vendedor.numeroentrega__c = '425';
            account_vendedor.optantesimplesnacional__c = false;
            account_vendedor.pagonabaixa__c = 0;
            account_vendedor.porte__c = 'ME';
            account_vendedor.siglanaturezajuridica__c = 'ltda';
            account_vendedor.situacaoespecial__c = '********';
            account_vendedor.situacao__c = 'ATIVA';
            account_vendedor.statusconta__c = 'Ativo';
            account_vendedor.statusintegracao__c = 'Executado com sucesso';
            account_vendedor.tentativasintegracao__c = 3;
            account_vendedor.tipovendedor__c = 'Interno';
            account_vendedor.foi_convertido__c = false;
            account_vendedor.foiatualizado__c = false;
            account_vendedor.atualizoucodigoprotheus__c = false;
            account_vendedor.phcciclofinalmoda1__c = '030 dias';
            account_vendedor.itemduplicado__c = true;
            account_vendedor.phcciclofinalmoda2__c = '030 dias';
            account_vendedor.phcciclo1__c = 0.00;
            account_vendedor.situacaoaprovacao__c = 'Pendente';
            account_vendedor.phcciclo2__c = 0.00;
            account_vendedor.phcciclo3__c = 0.00;
            account_vendedor.phcciclo4__c = 0.00;
            account_vendedor.phcciclo5__c = 0.00;
            account_vendedor.portfoliohealthcontrol__c = 'Inativo';
            account_vendedor.ultimaatualizacaophc__c = DateTime.valueOf('2022-05-07 17:57:31');
            account_vendedor.ultimaatualizacaosegmentacaophc__c = DateTime.valueOf('2022-05-07 18:58:27');
            account_vendedor.statusintegracaomercos__c = 'Pendente';
            account_vendedor.cliente_com_display__c = false;
            account_vendedor.documentosemformatacao__c = '16557984000146';
            account_vendedor.bloquearusuario__c = false;
        insert account_vendedor;


        Account account_cliente = new Account();
            account_cliente.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Cliente').getRecordTypeId();
            account_cliente.name = 'JOAO ALVES MOREIRA FILHO';
            account_cliente.billingstreet = 'R PREF JOAO O DE ARAUJO, 966 , S/N, CENTRO';
            account_cliente.billingcity = 'Garopaba';
            account_cliente.billingstate = 'SC';
            account_cliente.billingpostalcode = '88495-000';
            account_cliente.billingcountry = 'Brasil';
            account_cliente.shippingstreet = 'R PREF JOAO O DE ARAUJO, 966 , S/N, CENTRO';
            account_cliente.shippingcity = 'Garopaba';
            account_cliente.shippingstate = 'SC';
            account_cliente.shippingpostalcode = '88495000';
            account_cliente.shippingcountry = 'Brasil';
            account_cliente.phone = '+55 (48) 3254-3231';
            account_cliente.accountsource = 'IndicacaoRepresentante';
            account_cliente.buscacepconta__c = 'ativo_busca_cep_conta';
            account_cliente.quantidade_de_lojas__c = '3';
            account_cliente.sub_origem_conta__c = 'Sem Sub Origem';
            account_cliente.bairro__c = 'CENTRO';
            account_cliente.complemento__c = '********';
            account_cliente.loja_conta__c = '01';
            account_cliente.tipo_pessoa_conta__c = 'J - Juridica';
            account_cliente.pais_conta__c = '105';
            account_cliente.bairrocobranca__c = 'CENTRO';
            account_cliente.capitalsocial__c = 0.00;
            account_cliente.pais_bacen_conta__c = '01058';
            account_cliente.codigoerp__c = 'C15520';
            account_cliente.codigoempresa__c = '01';
            account_cliente.codigofilial__c = '01';
            account_cliente.codigomunicipiocobranca__c = '4205704';
            account_cliente.codigomunicipio__c = '4205704';
            account_cliente.codigo_emitente__c = 'XXX';
            account_cliente.comissao__c = 0.00;
            account_cliente.complementocobranca__c = 'S/N';
            account_cliente.contribuinte__c = true;
            account_cliente.dataaberturaempresa__c = Date.valueOf('1990-06-04 00:00:00');
            account_cliente.datainicioatividade__c = '01-06-1990';
            account_cliente.documento__c = '81.865.396/0001-31';
            account_cliente.email__c = 'teste@teste.com';
            account_cliente.eventosfuturossimei__c = 'Não Existem';
            account_cliente.eventosfuturossimplesnacional__c = 'Não Existem';
            account_cliente.inscricaoestadual__c = '252059662';
            account_cliente.naoconsultarcepcorreio__c = true;
            account_cliente.naturezaintegracao__c = '213-5 - Empresário (Individual)';
            account_cliente.nomeempresarial__c = 'Joao alves moreira filho';
            account_cliente.nomefantasia__c = 'Joao alves moreira filho';
            account_cliente.numerocobranca__c = '966';
            account_cliente.numeroentrega__c = '966';
            account_cliente.optantesimplesnacional__c = true;
            account_cliente.pagonabaixa__c = 0;
            account_cliente.perfilconta__c = 'LojaMatConstrucao';
            account_cliente.porte__c = 'EPP';
            account_cliente.ramoatividadeconta__c = '000002';
            account_cliente.representante__c = account_vendedor.id;
            account_cliente.siglanaturezajuridica__c = 'não informado';
            account_cliente.situacasimplesnacional__c = 'Optante pelo Simples Nacional desde 01/01/2024';
            account_cliente.situacaocnpj__c = 'ATIVO';
            account_cliente.situacaoespecial__c = '********';
            account_cliente.situacaoinscricaoestadual__c = 'ATIVO';
            account_cliente.situacaosimeianteriror__c = 'Não Existem';
            account_cliente.situacaosimei__c = 'NÃO enquadrado no SIMEI';
            account_cliente.situacaosimplesnacionalanterior__c = '01/07/2007|31/12/2023|Excluída por Ato Administrativo praticado pelo ente GAROPABA-SC';
            account_cliente.situacao__c = 'ATIVA';
            account_cliente.statuscadastro__c = 'Finalizado';
            account_cliente.statusconta__c = 'Ativo';
            account_cliente.statusintegracao__c = 'Executado com sucesso';
            account_cliente.tentativasintegracao__c = 1;
            account_cliente.tipovendedor__c = 'Parceiro';
            account_cliente.foi_convertido__c = true;
            account_cliente.datafinalizacao__c = Date.valueOf('2024-09-29 00:00:00');
            account_cliente.foiatualizado__c = false;
            account_cliente.atualizoucodigoprotheus__c = false;
            account_cliente.itemduplicado__c = false;
            account_cliente.situacaoaprovacao__c = 'Aprovado';
            account_cliente.datahoraatualizacaofinalizado__c = DateTime.valueOf('2024-07-31 18:32:04');
            account_cliente.statusintegracaomercostransportadora__c = 'Não necessário';
            account_cliente.tentativasintegracaomercos__c = 1;
            account_cliente.codigoexclusivomercos__c = '46296108';
            account_cliente.statusintegracaomercos__c = 'Pendente';
            account_cliente.cliente_com_display__c = false;
            account_cliente.filialdefaturamento__c = filialfaturamento.id;
            account_cliente.bloquearusuario__c = false;
        insert account_cliente;
        

        Opportunity opportunity = new Opportunity();
            opportunity.accountid = account_cliente.Id;
            opportunity.name = '069103 | JOAO ALVES MOREIRA FILHO';
            opportunity.stagename = 'Orçamento';
            // opportunity.probability = '10';
            opportunity.closedate = Date.valueOf('2024-11-22 00:00:00');
            opportunity.forecastcategoryname = 'Funil';
            opportunity.pricebook2id = pricebook2.id;
            opportunity.n_mero_do_pedido__c = '000000';
            opportunity.oppultimosmeses__c = false;
        insert opportunity;

        Contact contact = new Contact();
            contact.accountid = account_cliente.id;
            contact.lastname = 'João';
            contact.salutation = 'Sr.';
            contact.mailingstreet = 'R PREF JOAO O DE ARAUJO, 966 , S/N, CENTRO';
            contact.mailingcity = 'Garopaba';
            contact.mailingstate = 'SC';
            contact.mailingpostalcode = '88495000';
            contact.mailingcountry = 'Brasil';
            contact.phone = '+55 (48) 3254-3231';
            contact.email = 'joaodastintas@hotmail.com';
            contact.title = 'Comprador';
            contact.leadsource = 'IndicacaoRepresentante';
            contact.et4ae5__hasoptedoutofmobile__c = false;
            contact.et4ae5__mobile_country_code__c = 'US';
        insert contact;

        CondicaoPagamento__c condicaopagamento = new CondicaoPagamento__c();
            condicaopagamento.name = 'Dinheiro';
            condicaopagamento.codigoerp__c = '12';
            condicaopagamento.formapagamento__c = 'BO';
            condicaopagamento.numeroparcelas__c = 0;
            condicaopagamento.pagamentoantecipado__c = false;
            condicaopagamento.categoriadepagamento__c = 'Até 35 dias';
            condicaopagamento.statusintegracaomercos__c = 'Pendente';
        insert condicaopagamento;

        Quote quote = new Quote();
            quote.name = 'V2 - 069103 | JOAO ALVES MOREIRA FILHO';
            quote.opportunityid = opportunity.Id;
            quote.pricebook2id = pricebook2.id;
            quote.contactid = contact.id;
            quote.status = 'Rascunho';
            quote.billingstreet = 'R PREF JOAO O DE ARAUJO, 966 , S/N, CENTRO';
            quote.billingcity = 'Garopaba';
            quote.billingstate = 'SC';
            quote.billingpostalcode = '88495-000';
            quote.billingcountry = 'Brasil';
            quote.shippingstreet = 'R PREF JOAO O DE ARAUJO, 966 , S/N, CENTRO';
            quote.shippingcity = 'Garopaba';
            quote.shippingstate = 'SC';
            quote.shippingpostalcode = '88495000';
            quote.shippingcountry = 'Brasil';
            quote.billingname = 'JOAO ALVES MOREIRA FILHO';
            quote.shippingname = 'JOAO ALVES MOREIRA FILHO';
            quote.cancreatequotelineitems = false;
            quote.condi_o_pagamento__c = 'avista';
            quote.tipo_de_frete__c = 'FOB';
            quote.statusintegracao__c = 'Executado com erro';
            quote.condicaopagamento__c = condicaopagamento.id;
            quote.comiss_o_representante__c = true;
            quote.frete_grande_sp__c = true;
            quote.cota_o_salvabras__c = true;
            quote.tentativasintegracao__c = 2;
            quote.dataentrega__c = Date.valueOf('2024-12-11 00:00:00');
            quote.anteciparpedido__c = 'Não';
            quote.tipoentrega__c = 'Padrão';
            quote.tipoagendado__c = 'NaoPrecisaAgendar';
            quote.tipoprogramado__c = 'Padrão';
        insert quote;
        
    }

    @isTest
    static void getProdutosAleloByOppIdTest(){
        Opportunity opp = [SELECT Id FROM Opportunity LIMIT 1];
        Product2 prod = [SELECT Id FROM Product2 LIMIT 1];

        String recordId = opp.Id;
        String prodId = prod.Id;

        Test.startTest();
            SalesWinProdutos.searchProducts(recordId, '');
            SalesWinProdutos.getProductInfos(prodId);
        Test.stopTest();
    
    }
}