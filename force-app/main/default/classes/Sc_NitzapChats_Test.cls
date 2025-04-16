@isTest
public class Sc_NitzapChats_Test {

    public class NitzapHttpMock implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');

            if (req.getEndpoint().contains('/login')) {
                res.setBody('{"success": "true", "sessionToken": "fake_token"}');
            } else if (req.getEndpoint().contains('/get-chats-metadata')) {
                res.setBody('[{"secondwhatsappid": "5511999999999@c.us", "dt_lastmessage": "2023-01-01T22:00:00.000Z"}]');
            }

            res.setStatusCode(201);
            return res;
        }
    }

    @isTest
    static void testSchedulerExecution() {
        Test.setMock(HttpCalloutMock.class, new NitzapHttpMock());

        Sc_NitzapChats sc = new Sc_NitzapChats();

        Test.startTest();
        String jobId = System.schedule('Test_NitzapChats_Job', '0 0 22 * * ?', sc);
        Test.stopTest();

        CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, NextFireTime 
                          FROM CronTrigger 
                          WHERE Id = :jobId];

        System.assertEquals('0 0 22 * * ?', ct.CronExpression);
    }
}

// String cronExp = '0 0 22 * * ?'; // todos os dias às 22:00
// String jobName = 'NitzapChats_Diario_22h';

// System.schedule(jobName, cronExp, new Sc_NitzapChats());