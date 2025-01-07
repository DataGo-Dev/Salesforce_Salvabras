public with sharing class QuoteService {
    @AuraEnabled
    public static Id savePdf(String recordId, String reportName , String report) {

            Quote quote = [
                SELECT id, Name , Account.Name
                FROM Quote
                WHERE Id =: recordId
                LIMIT 1
            ];
          
            PageReference pdfinho = new PageReference('/apex/' + reportName);
            pdfinho.getParameters().put('Id', recordId);
            Blob pagePdf = System.Test.isRunningTest() ? Blob.valueOf('test') : pdfinho.getContent();

            String title = report + ' - ' + quote.Account.Name;
            ContentVersion cv = new ContentVersion();
                cv.ContentLocation = 'S';
                cv.VersionData = pagePdf;
                cv.Title = title;
                cv.PathOnClient = title+'.pdf';
            insert cv;

            ContentDocumentLink cdl = new ContentDocumentLink();
                cdl.ContentDocumentId = [
                    SELECT Id, ContentDocumentId 
                    FROM ContentVersion 
                    WHERE Id =: cv.Id
                ].ContentDocumentId;
                cdl.LinkedEntityId = recordId;
                cdl.ShareType = 'V';
            insert cdl;

            return cv.Id;

    }
}