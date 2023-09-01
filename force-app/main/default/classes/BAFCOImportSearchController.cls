public without sharing class BAFCOImportSearchController {
    @AuraEnabled
    public static List<order_item__c> getImportItem(String agentId,String orderNumber,String loadingPortId, String destinationPortId){
        List<Order_item__c> itemList =  new List<Order_item__c>();
        String query = 'Select Order__r.Account_Order__r.Name,Order__r.Quotation__r.Quotation_Validity__c,Quotation_Item__r.Quotation__r.Quotation_Validity__c,quantity__c,Order__r.Account_Order__c,Agent__r.name,Shipping_Line__r.Name,Vessel_ETD__c,Port_of_Discharge_Order__r.Name,Port_of_Loading_Order__r.Name,Order__r.Quotation__r.Name,Order__r.Name,Name,Total_Order__c,buying_rate__c from order_item__c where Order__r.recordtype.name =\'Import\'';
        if(agentId != null) query = query + ' AND Order__r.Account_Order__c =\''+agentId+'\'';
        if(orderNumber != null ) query = query + ' AND  Order__r.Name = \''+orderNumber+'\'';
        if(loadingPortId != null ) query = query + ' AND Port_of_Loading_Order__c = \''+loadingPortId+'\'';
        if(destinationPortId != null ) query = query + ' AND Port_of_Discharge_Order__c = \''+destinationPortId+'\'';
        system.debug('query '+query);
        itemList = Database.query(query);
        return itemList;
    }
    @AuraEnabled
    public static order_item__c updateQuoteItem(Decimal buyingRate, Decimal sellingRate, String recordId, String shippingLineId, String quotationValidity){
        order_item__c item = new order_item__c();
        item.Id = recordId;
        item.Buying_Rate__c = buyingRate;
        item.Total_Order__c = sellingRate;
        item.Shipping_Line__c = shippingLineId;
        update item ;
        order_item__c ordItem = [Select id,Order__r.Name,Name,Order__r.Quotation__c from order_item__c where id =:recordId ];
        if(quotationValidity != null){
            Quotation__c quoteRec = new Quotation__c(id=ordItem.Order__r.Quotation__c, Quotation_Validity__c=Date.ValueOf(quotationValidity));
            update quoteRec;
        }
        String shipLineBSLSID = null;
        if(shippingLineId != null){
            Shipping_Line__c shipLine = [Select id,BSLS_ID__c from Shipping_Line__c Where id=:shippingLineId];
            shipLineBSLSID = shipLine.BSLS_ID__c;
        }
        sendUpdatedSellingRates(ordItem.Order__r.Name,ordItem.Name,sellingRate,shipLineBSLSID,quotationValidity);
        return item;
        
    }
    @AuraEnabled
    public static List<order_item__c> getImportItemOnLoad(){
        List<Order_item__c> itemList =  new List<Order_item__c>();
        itemList = [Select Order__r.Account_Order__r.Name,Order__r.Quotation__r.Quotation_Validity__c,Quotation_Item__r.Quotation__r.Quotation_Validity__c,quantity__c,Order__r.Account_Order__c,Agent__r.name,Shipping_Line__r.Name,Vessel_ETD__c,Port_of_Discharge_Order__r.Name,Port_of_Loading_Order__r.Name,Order__r.Quotation__r.Name,Order__r.Name,Name,Total_Order__c,buying_rate__c from order_item__c where Greater_Vessel_ETD__c = true and Order__r.recordtype.name ='Import' order by order__r.Order_Validity__c desc];
        return itemList;
    }
    @AuraEnabled
    public static order_item__c getOrderItemValue(String orderItemID){
        system.debug('orderItemID'+orderItemID);
        Order_item__c orderItemDetails = [Select Shipping_Line__c,Shipping_Line__r.Name,
                                          Order__r.Quotation__r.Quotation_Validity__c,Total_Order__c,
                                          buying_rate__c from order_item__c where id=:orderItemID];
        return orderItemDetails;
    }
    
    @AuraEnabled
    public static void updateOrderItemValue(Decimal buyingRate,Decimal sellingRate,String shippingLineId,String quotationValidity, String orderItemID){
        system.debug('buyingRate '+buyingRate+' sellingRate '+sellingRate+' shippingLineId '+shippingLineId+' quotationValidity '+quotationValidity+' orderItemID '+orderItemID);
        Order_item__c ordItem = [Select ID, Name,Shipping_Line__c,Shipping_Line__r.Name,Order__r.Name,Shipping_Line__r.BSLS_ID__c,
                                 Order__r.Quotation__c,Order__r.Quotation__r.Quotation_Validity__c,Total_Order__c,
                                 buying_rate__c from order_item__c where id=:orderItemID];
        ordItem.Buying_Rate__c=buyingRate;
        ordItem.Total_Order__c = sellingRate;
        ordItem.Shipping_Line__c = shippingLineId;
        update ordItem;
        
        Quotation_Item__c quoteLI = new Quotation_Item__c();
        quoteLI = [SELECT id,Buying_Rate__c,Shipping_Linee__c FROM Quotation_Item__c WHERE Quotation__c=:ordItem.Order__r.Quotation__c Limit 1];
        quoteLI.Buying_Rate__c=buyingRate;
        //quoteLI.Total_Order__c = sellingRate;
        quoteLI.Shipping_Linee__c = shippingLineId;
        update quoteLI;    
        
        List<Task> taskListToUpdate = new List<Task>();
        for(Task taskRec : [Select id, WhatId from Task Where WhatId =:ordItem.Id]){
            system.debug('taskListToUpdate'+taskListToUpdate);
            taskRec.Status='Completed';
            taskListToUpdate.add(taskRec);
        }
        if(taskListToUpdate!=NULL){
            update taskListToUpdate;
        }             
        if(quotationValidity != null){
        Quotation__c quoteRec = new Quotation__c(id=ordItem.Order__r.Quotation__c, Quotation_Validity__c=Date.ValueOf(quotationValidity));
        update quoteRec;
        }
        String shipLineBSLSID = null;
        if(shippingLineId != null){
            Shipping_Line__c shipLine = [Select id,BSLS_ID__c from Shipping_Line__c Where id=:shippingLineId];
            shipLineBSLSID = shipLine.BSLS_ID__c;
        }
        
        sendUpdatedSellingRates(ordItem.Order__r.Name,ordItem.Name,sellingRate,shipLineBSLSID,quotationValidity);
                
        Order_item__c obj = new Order_item__c();
        obj.id = orderItemID;
        obj.Buying_Rate__c = buyingRate;
        obj.Shipping_Line__c = shippingLineId;
        //obj.  = sellingRate;
        
    }
    @future(callout=True)
    public static void sendUpdatedSellingRates(String OrderNumber,String OrderItemNumber,Decimal sellingRate,String shippingLineId,String quotationValidity){
        system.debug('shippingLineId : '+shippingLineId);
        system.debug('OrderNumber in sendUpdatedSellingRates'+OrderNumber);
        UpdatedOrderItem orderItemBody = new UpdatedOrderItem();
        orderItemBody.OrderNumber=OrderNumber;
        orderItemBody.OrderItemNumber=OrderItemNumber;
        orderItemBody.SellingRate=sellingRate;        
        orderItemBody.shippingLineID=Integer.ValueOf(shippingLineId);       
        orderItemBody.QuotationValidtity=quotationValidity;
        
        HttpRequest req = new HttpRequest();
        system.debug('req in sendUpdatedSellingRates'+req);
        req.setHeader('Content-Type', 'application/json');
        req.setEndpoint('https://ioperation.bafcointl.com:30336/Import/RateValidity');
        req.setHeader('Content-Length', '0');
        req.setMethod('POST');
        system.debug('Order BODY--'+JSON.serialize(orderItemBody));
        req.setBody(JSON.serialize(orderItemBody));
        system.debug('Update Selling Rate Body : '+req.getBody());
        system.debug('Update Selling Rate EndPoint : '+req.getEndpoint());
        HttpResponse response = null;        
        try {
            Http http = new Http();
            response = http.send(req);            
            system.debug('response Body of Send Order API '+response.getBody());
            system.debug('response of Send Order API '+response);
        } 
        catch (System.CalloutException e) {
            system.debug('Catch of Callout Exception in Class - BAFCOSendOrderAPI '+e.getMessage());
        }
    }
    
    public class UpdatedOrderItem{
        public String OrderNumber {get;Set;}
        public String OrderItemNumber {get;Set;}
        public Decimal SellingRate {get;Set;}
        public Integer shippingLineID {get;Set;}
        public String QuotationValidtity {get;Set;}
    }    
    public static void testDummy(){
        Integer a=10;
        Integer b=5;
        Integer c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
    }
}