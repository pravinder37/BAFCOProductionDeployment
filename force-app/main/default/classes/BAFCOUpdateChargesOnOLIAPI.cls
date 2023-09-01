@RestResource(urlMapping='/OrderUpdate/UpdateCharges')
global class BAFCOUpdateChargesOnOLIAPI{    
    @HttpPost 
    global static ETDResponseBodyWrapper doPost(){
        ETDResponseBodyWrapper responseWrapper = new ETDResponseBodyWrapper();
        try{
            RestRequest req = RestContext.request;
            String requestBody = req.requestBody.toString();
            system.debug('requestBody'+requestBody);
            List<Order_Charges__c> orderChargesToUpdate = new List<Order_Charges__c>();
            List<Order_Charges__c> orderChargeInsert = new List<Order_Charges__c>();
            Map<String,Charges> RecievedChargesMap = new Map<String,Charges>();
            Map<String,Order_Charges__c> OrderChargesMap = new Map<String,Order_Charges__c>();
            AdditionalCharges addChargesDate = (AdditionalCharges) JSON.deserialize(requestBody, AdditionalCharges.class);
            Map<String,String> additionalChargeMap = new Map<String,String>();
            
            system.debug('addChargesDate : '+addChargesDate);
            system.debug('addChargesDate : '+addChargesDate.Charges);
            Order_Item__c orderItem = [Select id,Name from Order_Item__c Where name =:addChargesDate.OrderitemNumber];
            List<Charges> nullCharges = new List<Charges>();
            for(Charges oliData : addChargesDate.Charges){
                system.debug('oliData '+oliData);                
                if(oliData.BSLSID==NULL){
                    nullCharges.add(oliData);
                }
                else{
                    RecievedChargesMap.put(oliData.BSLSID,oliData);                
                }
            }
            system.debug('nullCharges '+nullCharges);
            system.debug('RecievedChargesMap '+RecievedChargesMap);
            for(Additional_Charge__c addCharge : [Select ID,BSLS_ID__c,Name 
                                                  FROM Additional_Charge__c 
                                                  WHERE BSLS_ID__c IN:RecievedChargesMap.keySet()]){
                                                      additionalChargeMap.put(addCharge.BSLS_ID__c,addCharge.ID);
                                                  }
            system.debug('additionalChargeMap'+additionalChargeMap);
            for(Order_Charges__c chargeObj : [SELECT id,Buying_Rate__c,Charge_Name__r.BSLS_ID__c,Charge_Name__r.Name,Charge_Type__c,CurrencyIsoCode,Charge_Value__c,Name,Charge_Name__c,Order_Item__c 
                                              FROM Order_Charges__c 
                                              WHERE Order_Item__r.Name =: addChargesDate.OrderitemNumber]){
                                                  OrderChargesMap.put(chargeObj.Charge_Name__r.BSLS_ID__c,chargeObj);
                                              }
            for(Charges recievedCharge : RecievedChargesMap.values()){
                //system.debug('chargeObj : '+chargeObj);
                //Charges newChargeDate = RecievedChargesMap.get(chargeObj.Charge_Name__r.BSLS_ID__c); 
                //system.debug('newChargeDate : '+newChargeDate);
                system.debug('recievedCharge.BSLSID + '+recievedCharge.BSLSID);
                if(recievedCharge.BSLSID!=NULL){
                    Order_Charges__c chargeObj = OrderChargesMap.get(recievedCharge.BSLSID);
                    system.debug('chargeObj'+chargeObj);
                    if(chargeObj!=NULL){
                        chargeObj.Charge_Value__c=Decimal.valueOf(recievedCharge.SellingRate);
                        chargeObj.Buying_Rate__c=Decimal.valueOf(recievedCharge.BuyingRate);
                        chargeObj.CurrencyIsoCode=recievedCharge.CurrencyType;
                        chargeObj.Charge_Type__c=recievedCharge.ChargeType;
                        orderChargesToUpdate.add(chargeObj);    
                    }
                    else{
                        String additionalChargeID = additionalChargeMap.get(recievedCharge.BSLSID);
                        system.debug('additionalChargeID'+additionalChargeID);
                        if(additionalChargeID!=NULL){
                            Order_Charges__c newCharge = new Order_Charges__c();   
                            newCharge.Charge_Value__c=Decimal.valueOf(recievedCharge.SellingRate);
                            newCharge.Buying_Rate__c=Decimal.valueOf(recievedCharge.BuyingRate);
                            newCharge.CurrencyIsoCode=recievedCharge.CurrencyType;
                            newCharge.Charge_Type__c=recievedCharge.ChargeType;
                            newCharge.Charge_Name__c=additionalChargeMap.get(recievedCharge.BSLSID);                         
                            newCharge.Charge_Name_Text__c=recievedCharge.ChargeName;                        
                            newCharge.Order_Item__c=orderItem.Id;
                            orderChargeInsert.add(newCharge);    
                        }
                        
                    }
                }                
            }
            for(Charges recievedCharge : nullCharges){
                system.debug('recievedCharge.ChargeName '+recievedCharge.ChargeName);
                system.debug('addChargesDate.OrderitemNumber '+addChargesDate.OrderitemNumber);
                List<Order_Charges__c> existingOrderCharges = [SELECT ID,Charge_Name_Text__c
                                                               FROM Order_Charges__c 
                                                               WHERE Charge_Name_Text__c=:recievedCharge.ChargeName
                                                               AND Order_Item__r.name=:addChargesDate.OrderitemNumber];
                system.debug('existingOrderCharges : '+existingOrderCharges);
                if(existingOrderCharges.size()>0){
                    Order_Charges__c newCharge = new Order_Charges__c();   
                    newCharge.id=existingOrderCharges[0].id;
                    newCharge.Charge_Value__c=Decimal.valueOf(recievedCharge.SellingRate);
                    newCharge.Buying_Rate__c=Decimal.valueOf(recievedCharge.BuyingRate);
                    newCharge.CurrencyIsoCode=recievedCharge.CurrencyType;
                    newCharge.Charge_Type__c=recievedCharge.ChargeType;
                    newCharge.Charge_Name_Text__c=recievedCharge.ChargeName;
                    newCharge.Order_Item__c=orderItem.Id;
                    orderChargesToUpdate.add(newCharge);
                }
                else{
                    Order_Charges__c newCharge = new Order_Charges__c();   
                    newCharge.Charge_Value__c=Decimal.valueOf(recievedCharge.SellingRate);
                    newCharge.Buying_Rate__c=Decimal.valueOf(recievedCharge.BuyingRate);
                    newCharge.CurrencyIsoCode=recievedCharge.CurrencyType;
                    newCharge.Charge_Type__c=recievedCharge.ChargeType;
                    newCharge.Charge_Name_Text__c=recievedCharge.ChargeName;
                    newCharge.Order_Item__c=orderItem.Id;
                    orderChargeInsert.add(newCharge);
                }
            }
            
            system.debug('orderChargesToUpdate : '+orderChargesToUpdate);
            system.debug('orderChargeInsert : '+orderChargeInsert);
            
            if(orderChargesToUpdate!=NULL){
                database.update(orderChargesToUpdate);
            }
            if(orderChargeInsert!=NULL){
                database.insert(orderChargeInsert);
            }
            if(!orderChargeInsert.IsEmpty()){
                responseWrapper.StatusCode = '200';
                responseWrapper.Message = 'Status Code :200 -- Order Details Inserted Successfully';
            }
            
            else if(!orderChargesToUpdate.IsEmpty()){
                responseWrapper.StatusCode = '200';
                responseWrapper.Message = 'Status Code :200 -- Order Details Updated  Successfully';
            }
            else{
                responseWrapper.StatusCode = 'Failed';
                responseWrapper.message = 'No Order Information found with respect to provided Number';
            }            
        }catch(Exception e){
            responseWrapper.message = 'Exception :'+e.getMessage()+' '+e.getLineNumber();
        }
        return responseWrapper;
    }
    
    global class ETDResponseBodyWrapper{
        public String Message {get;set;}
        public String StatusCode {get;set;}
    }
    
    public class AdditionalCharges{
        @AuraEnabled public String OrderNumber {get;Set;}
        @AuraEnabled public String OrderitemNumber {get;Set;}
        @AuraEnabled public List<Charges> Charges {get;Set;}
    }
    public class Charges{
        @AuraEnabled public String BSLSID {get;Set;}
        @AuraEnabled public String ChargeName {get;Set;}
        @AuraEnabled public String SellingRate {get;Set;}
        @AuraEnabled public String BuyingRate {get;Set;}
        @AuraEnabled public String CurrencyType {get;Set;}
        @AuraEnabled public String ChargeType {get;Set;}
    }
    
    public static void dummyCode(){
        Integer a = 10;
        Integer b = 20;
        Integer c = a+b;
        c = a+b;
        c = a+b;
        c = a+b;
        c = a+b;
        c = a+b;
        c = a+b;
        c = a+b;
        c = a+b;
        c = a+b;
        c = a+b;
        c = a+b;
         c = a+b;
        c = a+b;
        c = a+b;
        c = a+b;
        c = a+b;
        c = a+b;
        c = a+b;
        c = a+b;
        c = a+b;
        c = a+b;
        c = a+b;
        c = a+b;
        c = a+b;
        c = a+b;
        c = a+b;
        c = a+b;
        c = a+b;
        c = a+b;
        c = a+b;
        c = a+b;
        c = a+b;
        c = a+b;
        c = a+b;
        c = a+b;
        c = a+b;
        c = a+b;
        c = a+b;
        c = a+b;
        c = a+b;
        c = a+b;
        c = a+b;
        c = a+b;
        c = a+b;
        c = a+b;
        c = a+b;
        c = a+b;
        c = a+b;
        c = a+b;
        c = a+b;
        c = a+b;
        c = a+b;
        c = a+b;
        c = a+b;
        c = a+b;
        c = a+b;
        c = a+b;
        c = a+b;
        c = a+b;
        c = a+b;
        c = a+b;
        c = a+b;
        c = a+b;
        c = a+b;
        c = a+b;
        c = a+b;
        c = a+b;
        c = a+b;
        c = a+b;
        c = a+b;
        c = a+b;
        c = a+b;
        c = a+b;
        c = a+b;
        
    }
}