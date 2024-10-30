public with sharing class SalesWinProdutos {

    @AuraEnabled
    public static void deleteItens(List<String> ids){
        List<QuoteLineItem> itens = new List<QuoteLineItem>();
        
        for(String id : ids){
            itens.add(new QuoteLineItem(Id=id));
        }
        
        delete itens;
    }
   

    @AuraEnabled
    public static List<PricebookEntry> searchProducts(String recordId ,String term){

        term = term.replace(' ', '%');

        String finalTerm = String.format('%{0}%', new List<String>{
                String.escapeSingleQuotes(term.trim())
            }
        );

        Quote quote = [
            SELECT 
                id, 
                Pricebook2Id from Quote 
                where id = :recordId limit 1
        ];

        String pricebookId = quote.Pricebook2Id;

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

    @AuraEnabled
    public static List<QuoteLineItem> getProducts(String recordId){
        
        List<QuoteLineItem> itens = [
            SELECT 
                Id,
                Product2.Name,
                UnitPrice,
                Quantity,
                TotalPrice
            FROM QuoteLineItem
            where QuoteId = :recordId
        ];

        return itens;
    }


}