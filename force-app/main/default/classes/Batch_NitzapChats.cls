global class Batch_NitzapChats implements Database.Batchable<sObject>, Database.AllowsCallouts, Database.Stateful {

    public class DataWrapperAuthResp {
        @AuraEnabled public String success { get; set; }
        @AuraEnabled public String sessionToken { get; set; }
    }

    public class DataWrapperChat {
        @AuraEnabled public String Id { get; set; }
        @AuraEnabled public String chat_id { get; set; }
        @AuraEnabled public String sessionid { get; set; }
        @AuraEnabled public String mywhatsid { get; set; }
        @AuraEnabled public String secondwhatsappid { get; set; }
        @AuraEnabled public String name { get; set; }
        @AuraEnabled public String sequence { get; set; }
        @AuraEnabled public Datetime dt_lastmessage { get; set; }
        @AuraEnabled public Datetime dt_second_last_message { get; set; }
        @AuraEnabled public String createddate { get; set; }
        @AuraEnabled public Integer version { get; set; }
    }

    global class Batch_NitzapChats_Exception extends Exception {}

    public List<DataWrapperChat> response = new List<DataWrapperChat>();

    public List<SObject> start(Database.BatchableContext BC) {
        nitzap20__NitzapConfigs__c nitzapConfigs = nitzap20__NitzapConfigs__c.getOrgDefaults();
        User usu;

        try {
            usu = [
                SELECT Id, Name, nitzap20__Secret__c, nitzap20__WhatsAppId__c
                FROM User
                WHERE nitzap20__WhatsAppId__c = :nitzapConfigs.nitzap20_Telefone_Autenticacao__c
                LIMIT 1
            ];
        } catch (Exception err) {
            throw new Batch_NitzapChats_Exception('É necessário configurar os dados da integração, em Usuário e Configurações Personalizadas!');
        }

        HttpRequest reqAuth = new HttpRequest();
        reqAuth.setEndpoint(nitzapConfigs.nitzap20__Url_Base__c + '/whatsapp/login');
        reqAuth.setMethod('POST');
        reqAuth.setHeader('content-type', 'application/json');
        reqAuth.setBody('{"username": "' + usu.nitzap20__WhatsAppId__c + '", "password": "' + usu.nitzap20__Secret__c + '"}');

        HTTPResponse resAuth = new Http().send(reqAuth);

        DataWrapperAuthResp authResponse = (DataWrapperAuthResp) JSON.deserialize(resAuth.getBody(), DataWrapperAuthResp.class);
        String authToken = authResponse.sessionToken;

        Datetime dtFrom = Datetime.now().addMinutes(-1440);

        HttpRequest req = new HttpRequest();
        req.setEndpoint(nitzapConfigs.nitzap20__Url_Base__c + '/whatsapp/get-chats-metadata');
        req.setMethod('POST');
        req.setHeader('Authorization', 'Bearer ' + authToken);
        req.setHeader('content-type', 'application/json');
        req.setBody('{"sequence":{"gte":"' + dtFrom.getTime() + '"},"dt_lastmessage":{"not":null},"NOT":{"secondwhatsappid":{"contains":"@g.us"}}}');

        HTTPResponse res = new Http().send(req);

        response = (List<DataWrapperChat>) JSON.deserialize(res.getBody(), List<DataWrapperChat>.class);

        Map<String, DataWrapperChat> mapResultsAPI = new Map<String, DataWrapperChat>();
        Set<String> chaves = new Set<String>();

        Timezone tz = Timezone.getTimeZone('America/Sao_Paulo');
        for (DataWrapperChat chat : response) {
            if (chat.secondwhatsappid != null && !chat.secondwhatsappid.contains('@g.')) {
                mapResultsAPI.put(chat.secondwhatsappid, chat);
                chaves.add(chat.secondwhatsappid.split('@').get(0).right(8));
            }
        }

        List<SObject> resultados = new List<SObject>();
        resultados.addAll([
            SELECT Id, Name, nitzap20__WhatsAppId__c, OwnerId FROM Contact WHERE FinWid__c IN :chaves
        ]);
        resultados.addAll([
            SELECT Id, Name, nitzap20__WhatsAppId__c, OwnerId FROM Lead WHERE FinWid__c IN :chaves AND IsConverted = FALSE
        ]);
        return resultados;
    }

    public void execute(Database.BatchableContext BC, List<SObject> registros) {
        Map<Id, SObject> recsToUpdate = new Map<Id, SObject>();

        for (SObject reg : registros) {
            String wid = '';
            if (reg.Id.getSObjectType() == Contact.SObjectType) {
                wid = ((Contact) reg).nitzap20__WhatsAppId__c;
            } else if (reg.Id.getSObjectType() == Lead.SObjectType) {
                wid = ((Lead) reg).nitzap20__WhatsAppId__c;
            } 

            for (DataWrapperChat chat : response) {
                String secondwhatsappid = chat.secondwhatsappid;
                if (String.isBlank(wid) || String.isBlank(secondwhatsappid)) continue;

                String secondwhatsappidsplit = secondwhatsappid.split('@').get(0);
                String contWithoutPlus = wid.replace('+', '');
                String secondWithoutPlus = secondwhatsappidsplit.replace('+', '');

                String biggerPhone = contWithoutPlus.length() >= secondWithoutPlus.length() ? contWithoutPlus : secondWithoutPlus;
                String smallerPhone = secondWithoutPlus.length() > contWithoutPlus.length() ? contWithoutPlus : secondWithoutPlus;

                String smallerPhoneEnd = smallerPhone.right(8);
                String smallerPhoneStart = smallerPhone.left(smallerPhone.length() - 8).replace('+', '');
                String smallerPhoneStart3 = smallerPhone.left(3);

                if (biggerPhone == smallerPhone || (
                    (smallerPhoneStart3.startsWith('+55') || smallerPhoneStart3.startsWith('55')) &&
                    biggerPhone.startsWith(smallerPhoneStart) &&
                    biggerPhone.endsWith(smallerPhoneEnd) &&
                    biggerPhone.left(biggerPhone.length() - 7).right(1) == '9'
                )) {
                    reg.put('nitzap20__DateTime_Last_Sent_Whatsapp__c', chat.dt_lastmessage);
                    recsToUpdate.put(reg.Id, reg);
                }
            }
        }

        if (!recsToUpdate.isEmpty()) {
            update recsToUpdate.values();

            Set<String> mywhatsIds = new Set<String>();
                for (DataWrapperChat chat : response) {
                    if (!String.isBlank(chat.mywhatsid)) {
                        mywhatsIds.add(chat.mywhatsid.split('@').get(0));
                        }
                    }
            
            Map<String, Id> mywhatsidToUserId = new Map<String, Id>();
                for (User u : [
                    SELECT Id, nitzap20__WhatsAppId__c
                    FROM User
                    WHERE nitzap20__WhatsAppId__c IN :mywhatsIds AND IsActive = TRUE AND nitzap20__WhatsAppId__c != NULL
                ]) {
                    mywhatsidToUserId.put(u.nitzap20__WhatsAppId__c, u.Id);
                }
            
            Map<String,Task> tasksToCreate = new Map<String,Task>();
            TimeZone tz = TimeZone.getTimeZone('America/Sao_Paulo');
            Datetime meiaNoiteHoje = Datetime.newInstance(Date.today(), Time.newInstance(0, 0, 0, 0)).addSeconds(tz.getOffset(Date.today()) / 1000);

            for (Id recId : recsToUpdate.keySet()) {
                SObject sObj = recsToUpdate.get(recId);
                String contactWhatsId = (String) sObj.get('nitzap20__WhatsAppId__c');
            
                for (DataWrapperChat chat : response) {
                    if (chat.secondwhatsappid != null && chat.secondwhatsappid.contains(contactWhatsId)) {
                        String chatMyWhatsId = chat.mywhatsid.split('@').get(0);
                        Id ownerId = mywhatsidToUserId.get(chatMyWhatsId);
            
                        Task taskRecord = new Task();
                            taskRecord.OwnerId = ownerId != null ? ownerId : UserInfo.getUserId(); 
                            taskRecord.ActivityDate = Date.today();
                            taskRecord.Status = 'Concluído';
                            taskRecord.Priority = 'Normal';
                            taskRecord.CurrencyIsoCode = 'BRL';
                            taskRecord.Subject = 'Conversa Whatsapp';
                            taskRecord.nitzap20__Date_Time_Start_Chat__c = meiaNoiteHoje;
                            taskRecord.WhoId = sObj.Id;
                        tasksToCreate.put(chat.chat_id, taskRecord);
                    }
                }
            }
            
            insert (tasksToCreate.values());
        }
    }
            
    global void finish(Database.BatchableContext BC) {
        System.debug('Batch finalizado!');
    }
}

// sf project deploy start --metadata ApexClass:Batch_NitzapChats --metadata ApexClass:Batch_NitzapChats_Test -l RunSpecifiedTests -t Batch_NitzapChats_Test -o Connection_Salvabras