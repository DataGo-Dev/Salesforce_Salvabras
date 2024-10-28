public with sharing class SalesWin {
    
    @AuraEnabled
    public static List<Options> getPricebooks(String recordId) {

        Account acc = [ 
            SELECT 
                id,
                FilialDeFaturamento__c,
                RamoAtividadeConta__c,
                BillingState
            FROM 
                Account where Id = :recordId
        ];

        String filialFaturamento = acc.FilialDeFaturamento__c;
        String ramoAtividade = String.format('%{0}%', 
            new List<String> {String.escapeSingleQuotes(acc.RamoAtividadeConta__c)}
            );
        String billingState = String.format('%{0}%', 
                new List<String> {String.escapeSingleQuotes(acc.BillingState)}
        );

        List<Pricebook2> pricebooks = [
            SELECT
                id,
                name
            FROM 
                Pricebook2
            where 
                isActive = true
                and FilialDeFaturamento__c = :acc.FilialDeFaturamento__c
                and CanalPersonalizado__c like :ramoAtividade
                and Estados__c like :billingState
        ];

        List<Options> options = new List<Options>();
        for (Pricebook2 pricebook : pricebooks) {
            Options option = new Options();
            option.label = pricebook.Name;
            option.value = pricebook.Id;

            options.add(option);
        }


        return options;

    }

    public class Options{
        @AuraEnabled
        public String label {get; set;}
        @AuraEnabled
        public String value {get; set;}
    }
}