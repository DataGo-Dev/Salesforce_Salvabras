public with sharing class SalesWinProdutos {
    public static String imgNotFound = 'https://i.ibb.co/yRSYRpX/no-image-icon-23485.png'; //https://ibb.co/7z4RzQX

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
                UnitPrice,
                Product2Id,
                Product2.DisplayUrl
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


        for(PricebookEntry o : prods){
            if(o.product2.DisplayUrl == null){
                o.product2.DisplayUrl = imgNotFound;
            }
        }

        return prods;


    }

    @AuraEnabled
    public static Map<String,Object> getProductInfos(String productId){

        Controle_Produto__c conPro = Controle_Produto__c.getOrgDefaults();

        Product2 pro = [
            Select Id, MinimumQuantity__c, Name
            from product2 where Id = :productId limit 1
        ];


        Map<String,Object> obj = new Map<String,Object>();
        obj.put('controleProduto', conPro);
        obj.put('produto', pro);
        return obj;
    }

    @AuraEnabled
    public static List<QuoteLineItem> getProducts(String recordId){
        
        List<QuoteLineItem> itens = [
            SELECT 
                Id,
                Product2.Name,
                UnitPrice,
                Quantity,
                TotalPrice,
                Product2.DisplayUrl
            FROM QuoteLineItem
            where QuoteId = :recordId
        ];

        for(QuoteLineItem o : itens){
            if(o.product2.DisplayUrl == null){
                o.product2.DisplayUrl = imgNotFound;
            }
        }


        return itens;
    }


}