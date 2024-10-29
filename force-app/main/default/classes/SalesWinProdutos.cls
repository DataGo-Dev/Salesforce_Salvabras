public with sharing class SalesWinProdutos {
   

    @AuraEnabled
    public static List<PricebookEntry> searchProducts(String recordId ,String term){

        term = term.replace(' ', '%');

        String finalTerm = String.format('%{0}%', new List<String>{
                String.escapeSingleQuotes(term.trim())
            }
        );

        Opportunity opp = [
            SELECT 
                id, 
                Pricebook2Id from Opportunity 
                where id = :recordId limit 1
        ];

        String pricebookId = opp.Pricebook2Id;

        List<PricebookEntry> prods = [
            SELECT 
                Id, 
                Name,
                ProductCode,
                UnitPrice
            From 
                PricebookEntry
            where 
                (
                    Name like :finalTerm or 
                    ProductCode like :finalTerm
                )
                and IsActive = true
                and Pricebook2Id = :pricebookId
            limit 100
        ];

        return prods;


    }


}