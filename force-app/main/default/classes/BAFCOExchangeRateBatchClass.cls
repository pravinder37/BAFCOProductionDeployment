global without sharing class BAFCOExchangeRateBatchClass implements Database.Batchable<sObject>, Database.AllowsCallouts {
    global Database.QueryLocator start(Database.BatchableContext BC){
        String query = 'SELECT Id,Currency_Code__c,Exchange_Rate__c FROM Exchange_Rate__c';       
        return Database.getQueryLocator(query);
    }
    global void execute(Database.BatchableContext BC, List<Exchange_Rate__c> scope){
        Map<String,Id> currencyCodeToIdMAP = new Map<String,Id>();
        List<Exchange_Rate__c> rateList = new List<Exchange_Rate__c>();
        String currencyCodeString = '';
        for(Exchange_Rate__c exObj : scope){
            if(exObj.Currency_Code__c != null){
                currencyCodeToIdMAP.put(exObj.Currency_Code__c,exObj.Id);
                currencyCodeString +=exObj.Currency_Code__c+',';
            }
        }
        if(currencyCodeToIdMAP.size() > 0){
            Map<String,Id> stdCurrencyCodeToIdMAP = new Map<String,Id>();
            List<CurrencyType> stdCurrencyList = new List<CurrencyType>();
            for(CurrencyType currencyObj : [SELECT Id, IsoCode, ConversionRate FROM CurrencyType where IsoCode In:currencyCodeToIdMAP.keyset()]){
                stdCurrencyCodeToIdMAP.put(currencyObj.IsoCode,currencyObj.Id);
            }
            system.debug('stdCurrencyCodeToIdMAP '+stdCurrencyCodeToIdMAP);
            String apiKey = System.Label.Exchange_Rate_Api_Key;
            String endPoint = 'https://api.apilayer.com/exchangerates_data/latest?symbols='+currencyCodeString+'&base=USD&apikey='+apiKey;
            HttpRequest request = new HttpRequest();
            request.setEndpoint(endPoint);
            request.setMethod('GET');
            request.setTimeout(2 * 60 * 1000);
            try {
                Http http = new Http();
                HttpResponse response = http.send(request);
                system.debug('response '+response);
                if (response.getStatusCode() == 200) {
                    system.debug('body '+response.getBody());
                    String jsonResponse = response.getBody();
                    JSONParser parser = JSON.createParser(jsonResponse);
                    while(parser.nextToken()!= null) {
                        if(parser.getCurrentToken() == JSONToken.FIELD_NAME) {
                            parser.nextValue();
                            for(String currencyCode : currencyCodeToIdMAP.keySet()){
                                if(parser.getCurrentName() == currencyCode) {
                                    String currencyRate = '';
                                    if(parser.getText() != null) currencyRate  = parser.getText();
                                    Exchange_Rate__c exObj = new Exchange_Rate__c();
                                    exObj.Id = currencyCodeToIdMAP.get(currencyCode);
                                    exObj.Exchange_Rate__c = Decimal.valueOf(currencyRate);
                                    rateList.add(exObj);                                    
                                }
                            }
                        }
                    }
                }
            }
            catch(Exception e){
                system.debug('Exception e'+e);
            }
            if(rateList.size() > 0) update rateList;           
        }
    }
    global void finish(Database.BatchableContext BC) {   
        system.enqueueJob(new BAFCOCurrencyTypeQueuable());
    }
}