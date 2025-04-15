@IsTest
public with sharing class Batch_NitzapChats_Test {

    class MockHttpResponseGenerator implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            res.setStatusCode(200);

            if (req.getEndpoint().contains('/whatsapp/login')) {
                res.setBody('{"success":true,"sessionToken":"fake_token_123"}');
            } else if (req.getEndpoint().contains('/whatsapp/get-chats-metadata')) {
                res.setBody(
                    '[{' +
                    '"chat_id":"5527999970208_5527997019622",' +
                    '"sessionid":"fake_session_id",' +
                    '"mywhatsid":"5527999970208@s.whatsapp.net",' +
                    '"secondwhatsappid":"5527997019622@s.whatsapp.net",' +
                    '"name":"João",' +
                    '"sequence":"1739824278835",' +
                    '"dt_lastmessage":"2025-02-17T17:31:18.000Z",' +
                    '"dt_second_last_message":"2025-02-17T17:31:18.000Z",' +
                    '"createddate":"2025-02-07T17:21:39.373Z",' +
                    '"version":345' +
                    '}]'
                );
            }

            return res;
        }
    }

    @IsTest
    public static void makeData() {
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());

        String rtId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Cliente').getRecordTypeId();

        User user = new User();
        user.Username = 'teste.integration@sandbox.com.br';
        user.LastName = 'Usuário de Teste';
        user.Alias = 'teste';
        user.Email = 'teste.integration@sandbox.com.br';
        user.TimeZoneSidKey = 'America/Sao_Paulo';
        user.LocaleSidKey = 'pt_BR';
        user.LanguageLocaleKey = 'pt_BR';
        user.EmailEncodingKey = 'ISO-8859-1';
        user.ProfileId = '00ei0000000lsf8AAA';
        user.nitzap20__Secret__c = 'segredoFake123';
        user.nitzap20__WhatsAppId__c = '5511998818223';
        insert user;

        nitzap20__NitzapConfigs__c config = new nitzap20__NitzapConfigs__c();
        config.Name = 'Default Config';
        config.nitzap20_Telefone_Autenticacao__c = '5511998818223';
        config.nitzap20__Url_Base__c = 'https://salvabras.nitzap.com';
        insert config;

        Account acc = new Account();
        acc.Name = 'TESTE LTDA';
        acc.NomeFantasia__c = 'TESTE LTDA';
        acc.Documento__c = '16.557.984/0001-46';
        acc.StatusCadastro__c = 'Finalizado';
        acc.quantidade_de_lojas__c = '1';
        // acc.PerfilConta__c = 'Arquiteto';
        acc.RecordTypeId = rtId;
        acc.AccountSource = 'SemOrigem';
        acc.sub_origem_conta__c = 'SemSubOrigem';
        acc.StatusConta__c = 'Ativo';
        // acc.MotivoInativo__c = 'Análise de crédito recusada';
        insert acc;

        Contact ctt = new Contact();
        ctt.LastName = 'Ctt 1';
        ctt.AccountId = acc.Id;
        ctt.Email = 'teste@gmail.com';
        ctt.Phone = '5527997019622';
        ctt.nitzap20__WhatsAppId__c = '5527997019622';
        insert ctt;

        Test.startTest();
            Batch_NitzapChats batch = new Batch_NitzapChats();
            Database.executeBatch(batch, 1);
        Test.stopTest();

        // Valida campo atualizado
        Contact result = [SELECT nitzap20__DateTime_Last_Sent_Whatsapp__c FROM Contact WHERE Id = :ctt.Id];
        System.assertNotEquals(null, result.nitzap20__DateTime_Last_Sent_Whatsapp__c, 'Contato deve ter data atualizada');

        List<Task> tarefas = [SELECT Id, Subject, WhoId FROM Task WHERE WhoId = :ctt.Id];
        System.assertEquals(1, tarefas.size(), 'Deveria existir uma tarefa');
        System.assertEquals('Conversa Whatsapp', tarefas[0].Subject);
    }
}