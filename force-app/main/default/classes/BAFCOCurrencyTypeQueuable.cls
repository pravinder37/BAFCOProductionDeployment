public class BAFCOCurrencyTypeQueuable implements Queueable, Database.AllowsCallouts{
    public void execute(QueueableContext context) {
        List<CurrencyType> stdCurrencyList = new List<CurrencyType>();
        Map<String,Decimal> currencyCodeToRateMap = new Map<String,Decimal>();
        Map<String,String> currencyCodeIdToCodeMap = new Map<String,String>();
        for(Exchange_Rate__c obj : [SELECT Id,Currency_Code__c,Exchange_Rate__c FROM Exchange_Rate__c]){
            currencyCodeToRateMap.put(obj.Currency_Code__c,obj.Exchange_Rate__c);            
        }
        for(CurrencyType currencyObj : [SELECT Id, IsoCode, ConversionRate FROM CurrencyType where IsoCode In:currencyCodeToRateMap.keyset()]){
            CurrencyType newCurrencyObj = new CurrencyType();
            newCurrencyObj.Id = currencyObj.Id;
            newCurrencyObj.ConversionRate = currencyCodeToRateMap.get(currencyObj.IsoCode);
            stdCurrencyList.add(newCurrencyObj);
            currencyCodeIdToCodeMap.put(currencyObj.id,currencyObj.IsoCode);
        }
        system.debug('stdCurrencyList' +stdCurrencyList);
        for(CurrencyType curnObj : stdCurrencyList){
            String isoCode = currencyCodeIdToCodeMap.get(curnObj.Id);
            String setBodyString = '{ "IsoCode" : '+'"'+isoCode+'", "DecimalPlaces" : 2, "ConversionRate" : '+curnObj.ConversionRate+', "IsActive" : "true" }';
            system.debug('setBodyString' +setBodyString);
            Http h = new Http();
            HttpRequest req = new HttpRequest();
            req.setEndpoint(URL.getSalesforceBaseUrl().toExternalForm() + '/services/data/v28.0/sobjects/CurrencyType/');
            req.setMethod('POST');
            req.setBody(setBodyString);
            req.setHeader('Authorization', 'OAuth ' + UserInfo.getSessionId());
            req.setHeader('Content-Type', 'application/json');
            HttpResponse res = h.send(req);
            system.debug('response currency type '+res);
            
        }
    }
}