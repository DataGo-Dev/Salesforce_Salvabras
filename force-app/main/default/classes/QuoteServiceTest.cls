@isTest
public class QuoteServiceTest {
        
   @TestSetup
    static void makeData(){
        
        Account contaTest = new Account();
           contaTest.Name = 'Test Account';
              insert contaTest;
        
          Opportunity oppteste = new Opportunity();
              oppteste.Name = 'testOpportunity';
              oppteste.StageName = 'Finalizada';
              oppteste.CloseDate = Date.today();
              oppteste.AccountId = contaTest.id;   
                 insert oppteste;
               
           Quote cotacao = new Quote();
               cotacao.Name = 'Test Quote';
               cotacao.OpportunityId = oppteste.id ;
              insert cotacao;
               
     }
    
  @isTest   
    public static void testSave(){
    
        Quote cotacao = [SELECT Id FROM Quote LIMIT 1];
        
        Test.startTest();
        Id contentVersionId = QuoteService.savePdf(cotacao.Id, 'TestReport', 'Test Report');
   
        
         ContentVersion cv = [SELECT Id, Title, PathOnClient FROM ContentVersion WHERE Id = :contentVersionId LIMIT 1];
         System.assertEquals('Test Report - Test Account', cv.Title);
         System.assertEquals('Test Report - Test Account.pdf', cv.PathOnClient);
        
        ContentDocumentLink cdl = [SELECT Id, LinkedEntityId, ShareType FROM ContentDocumentLink WHERE LinkedEntityId = :cotacao.Id LIMIT 1];
        System.assertEquals('V', cdl.ShareType);
        
           Test.stopTest();
    }
    
   
}