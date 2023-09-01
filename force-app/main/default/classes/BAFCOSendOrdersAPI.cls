public class BAFCOSendOrdersAPI {
    @Future(callout=true)
    public static void sendOrderData(List<ID> orderIDList) {
        List<Order__c> orderList = [Select Id,Order__c.Integration__c, Operations_Executive__r.BSLS_ID__c,Account_Order__r.BSLS_ID__c,Account_Order__r.name,Account_Order__r.Branch1__c,
                                    Account_Order__r.Owner.BSLS_ID__c,Account_Order__r.BillingAddress,Name,Quotation__r.Name,Quotation__c,
                                    Quotation__r.Quotation_Validity__c,Order_Validity__c,(Select Order__r.Opportunity_Order__r.Commercial_User__r.BSLS_ID__c,Order__r.Opportunity_Order__r.Commercial_User__r.Name,Total_Order__c,Quantity__c,id,Order__r.Name,Name,Route_Order__r.Kind_Of_Shipment__c,Route_Order__r.Service_Type__c,
                                    Shipping_Line__r.BSLS_ID__c,Pickup_Place__c,Discharge_Place__c,Port_of_Loading_Order__r.BSLS_ID__c,Port_of_Discharge_Order__r.BSLS_ID__c,
                                    Place_of_Pickup__r.BSLS_ID__c,Place_of_Discharge__r.BSLS_ID__c,Equipment_Type_Order__r.BSLS_ID__c,Agent__r.Name,Agent__r.BSLS_ID__c from Order_Items__r)  
                                    from Order__c where ID IN: orderIDList];
        String returnResult = '';
        List<OrderList> orderDtoList = new List<OrderList>();
        if(orderList.size() >0){
            Set<Id> orderItemIds = new Set<Id>();
            Map<Id,List<Consignee__c>> itemIdToConsigneeId = new Map<Id,List<Consignee__c>>();
            Map<Id,List<Order_Charges__c>> itemIdToOrderChargeId = new Map<Id,List<Order_Charges__c>>();
            Map<Id,List<Shipper__c>> itemIdToShipperId = new Map<Id,List<Shipper__c>>();
            Map<Id,String> accountOwnerMap = new Map<Id,String>();
            for(Order__c ordrObj : orderList){ 
                if(ordrObj.Order_Items__r.size() > 0){
                    for(Order_Item__c item : ordrObj.Order_Items__r){
                        orderItemIds.add(item.id);
                    }
                }
            }
            for(Order__c ordRec : [Select id,Account_Order__r.Owner.BSLS_ID__c from Order__c Where ID IN : orderIDList]){
                accountOwnerMap.put(ordRec.ID,ordRec.Account_Order__r.Owner.BSLS_ID__c);
            }
            for(Consignee__c conObj : [Select id,Consignee__r.BSLS_ID__c,Order_Item__c,Consignee__r.Name,Consignee__r.Branch1__c,Consignee__r.Owner.BSLS_ID__c,Consignee__r.Owner.name,Consignee__r.BillingAddress from Consignee__c where Order_Item__c in : orderItemIds]){
                if(!itemIdToConsigneeId.containskey(conObj.Order_Item__c)){
                    itemIdToConsigneeId.put(conObj.Order_Item__c,new List<Consignee__c>());
                }
                itemIdToConsigneeId.get(conobj.Order_Item__c).add(conObj);
            }
            
            for(Order_Charges__c chargeObj : [Select id,Buying_Rate__c,CurrencyIsoCode,Charge_Name__r.BSLS_ID__c,Charge_Name__r.Name,Charge_Type__c,Charge_Value__c,Name,Charge_Name__c,Order_Item__c from Order_Charges__c where Order_Item__c in : orderItemIds]){
                if(!itemIdToOrderChargeId.containskey(chargeObj.Order_Item__c)){
                    itemIdToOrderChargeId.put(chargeObj.Order_Item__c,new List<Order_Charges__c>());
                }
                itemIdToOrderChargeId.get(chargeObj.Order_Item__c).add(chargeObj);
            }
            
            for(Shipper__c shipObj : [Select id,Shipper__r.BSLS_ID__c,Shipper__r.Name,Shipper__r.Branch1__c,Order_Item__c,Shipper__r.Owner.BSLS_ID__c,Shipper__r.Owner.name,Shipper__r.BillingAddress from Shipper__c where Order_Item__c in : orderItemIds ]){
                if(!itemIdToShipperId.containskey(shipObj.Order_Item__c)){
                    itemIdToShipperId.put(shipObj.Order_Item__c,new List<Shipper__c>());
                }
                itemIdToShipperId.get(shipObj.Order_Item__c).add(shipObj);
            }
            for(Order__c ordrObj : orderList){
                if(ordrObj.Integration__c){
                    OrderList dto = new OrderList();
                    if(ordrObj.Account_Order__c != null){
                        AccountObj accObj = new AccountObj();
                        accobj.AccountName = ordrObj.Account_Order__r.Name;
                        accobj.Branch = ordrObj.Account_Order__r.Branch1__c;
                        accobj.AccountOwner = accountOwnerMap.get(ordrObj.ID);
                        accobj.BillingAddress = String.valueOf(ordrObj.Account_Order__r.BillingAddress);
                        accobj.SFID = ordrObj.Account_Order__c;
                        accobj.BSLSID = ordrObj.Account_Order__r.BSLS_ID__c;
                        dto.AccountObj = accobj;
                    }
                    OrderObj orderDto = new OrderObj();
                    orderDto.OrderNumber = ordrObj.Name;
                    orderDto.QuotationNumber = ordrObj.Quotation__r.Name;
                    orderDto.QuotationValidity = ordrObj.Quotation__r.Quotation_Validity__c;
                    orderDto.OrderValidity = ordrObj.Order_Validity__c;
                    orderDto.OrderSFID = ordrObj.Id;
                    orderDto.QuotationSFID = ordrObj.Quotation__c;                 
                    if(ordrObj.Order_Items__r.size() > 0){
                        List<Order_Item__c> orderItemList = ordrObj.Order_Items__r;
                        List<OrderItemList> orderItemDtoList = new List<OrderItemList>();
                        for(Order_Item__c item : orderItemList){
                            OrderItemList itemDto = new OrderItemList();
                            itemDto.OrderNumber = item.Order__r.Name ;
                            itemDto.OrderItemNumber = item.Name ;
                            itemDto.opsExecutive = ordrObj.Operations_Executive__r.BSLS_ID__c ;
                            switch on item.Route_Order__r.Kind_Of_Shipment__c {
                                when 'FCL' {
                                    itemDto.shipmentType = 1 ;
                                }
                                when else {
                                    itemDto.shipmentType = 2 ;
                                }
                            }
                            switch on item.Route_Order__r.Service_Type__c {
                                when 'P2P' {
                                    itemDto.serviceType = 1 ;
                                }
                                when 'P2D' {
                                    itemDto.serviceType = 2 ;
                                }
                                when 'D2P' {
                                    itemDto.serviceType = 3 ;
                                }
                                when else {
                                    itemDto.serviceType = 4 ;
                                }
                            }
                            //itemDto.serviceType =  '';     //Not Mapped
                            //itemDto.shipmentType = '' ;    //Not Mapped
                            itemDto.shippingline = item.Shipping_Line__r.BSLS_ID__c ;
                            itemDto.portOfLoading = item.Port_of_Loading_Order__r.BSLS_ID__c ;
                            itemDto.portOfDestination = item.Port_of_Discharge_Order__r.BSLS_ID__c ;
                            itemDto.placeOfPickup = item.Pickup_Place__c ;
                            itemDto.placeOfDischarge = item.Discharge_Place__c ;
                            itemDto.equipmentType = item.Equipment_Type_Order__r.BSLS_ID__c ;
                            itemDto.quantity = String.valueOf(item.Quantity__c);
                            itemDto.SellingRate = String.valueOf(item.Total_Order__c);
                            if(item.Order__r.Opportunity_Order__r.Commercial_User__r.BSLS_ID__c!=NULL){
                            itemDto.CommercialUser = Integer.ValueOf(item.Order__r.Opportunity_Order__r.Commercial_User__r.BSLS_ID__c);
                            }
                            if(item.Agent__c != null){
                                Agent agentObj = new Agent();
                                agentObj.AgentName = item.Agent__r.Name;
                                agentObj.SFID = item.Agent__c;
                                agentObj.BSLSID = item.Agent__r.BSLS_ID__c;
                                itemDto.Agent = agentObj;
                            }
                            if(itemIdToConsigneeId.size() > 0 && itemIdToConsigneeId.containsKey(item.id)){
                                List<Consignee> consigneeDtoList = new List<Consignee>();
                                for(Consignee__c consObj : itemIdToConsigneeId.get(item.id)){
                                    Consignee dtoObj = new Consignee();
                                    dtoObj.AccountName = consObj.Consignee__r.Name;
                                    dtoObj.Branch  = consObj.Consignee__r.Branch1__c;
                                    dtoObj.AccountOwner  = consObj.Consignee__r.Owner.BSLS_ID__c;
                                    dtoObj.BillingAddress  = String.valueOf(consObj.Consignee__r.BillingAddress);
                                    dtoObj.SFID  = consObj.id;
                                    dtoObj.BSLSID  = consObj.Consignee__r.BSLS_ID__c;
                                    consigneeDtoList.add(dtoObj);
                                }
                                itemDto.Consignee = consigneeDtoList;
                            }
                            if(itemIdToShipperId.size() > 0 && itemIdToShipperId.containsKey(item.id)){
                                List<Shipper> shipperDtoList = new List<Shipper>();
                                for(Shipper__c shipObj : itemIdToShipperId.get(item.Id)){
                                    Shipper dtoObj = new Shipper();
                                    dtoObj.AccountName = shipObj.Shipper__r.Name;
                                    dtoObj.Branch  = shipObj.Shipper__r.Branch1__c;
                                    dtoObj.AccountOwner  = shipObj.Shipper__r.Owner.BSLS_ID__c;
                                    dtoObj.BillingAddress  = String.valueOf(shipObj.Shipper__r.BillingAddress);
                                    dtoObj.SFID  = shipObj.id;
                                    dtoObj.BSLSID  = shipObj.Shipper__r.BSLS_ID__c;
                                    shipperDtoList.add(dtoObj);
                                }
                                itemDto.Shipper = shipperDtoList;
                            }
                            if(itemIdToOrderChargeId.size() > 0 && itemIdToOrderChargeId.containsKey(item.id)){
                                List<Charges> ChargeDTOList = new List<Charges>();
                                for(Order_Charges__c chargeObj : itemIdToOrderChargeId.get(item.Id)){
                                    Charges dtoObj = new Charges();
                                    dtoObj.SFID = chargeObj.id; 
                                    dtoObj.BBMSID  = chargeObj.Charge_Name__r.BSLS_ID__c;
                                    dtoObj.ChargeName  = chargeObj.Charge_Name__r.Name;
                                    dtoObj.ChargeValue  = String.ValueOf(chargeObj.Charge_Value__c);
                                    dtoObj.CurrencyType  = chargeObj.CurrencyIsoCode;
                                    dtoObj.ChargeType  = chargeObj.Charge_Type__c;
                                    ChargeDTOList.add(dtoObj);
                                }
                                itemDto.Charges = ChargeDTOList;
                            }
                            orderItemDtoList.add(itemDto);
                        }
                        orderDto.orderItemList = orderItemDtoList;
                    }
                    dto.OrderObj = orderDto;
                    orderDtoList.add(dto);
                    system.debug('orderDtoList'+orderDtoList);
                }
            }
        }
        OrderDetails dtoObj = new OrderDetails();
        dtoObj.OrderList = orderDtoList;
        for(OrderList orderRec: orderDtoList){
            doCallOut(orderRec);            
        }       
        //return dtoObj;        
    }
    
    public static void doCallOut(OrderList orderRecord) {
        HttpRequest req = new HttpRequest();
        req.setHeader('Content-Type', 'application/json');
        req.setEndpoint('https://bsls.bafcointl.com:52293/Import/Orders');
        req.setHeader('Content-Length', '0');
        req.setMethod('POST');
        system.debug('Order BODY--'+JSON.serialize(orderRecord));
        req.setBody(JSON.serialize(orderRecord));
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
        if(response!=NULL){
            List<Order_Item__c> orderItemList = new List<Order_Item__c>();
            String decodedJson ='';
            if(!test.isRunningTest() ) decodedJson = (String)JSON.deserialize(response.getBody(), String.class);
            if (response.getStatusCode() == 200) {
                ResponseData respWrapper = null;
                if(test.isRunningTest() ) respWrapper = (ResponseData) JSON.deserialize(response.getBody(), ResponseData.class);
                else if(! test.isRunningTest()) respWrapper = (ResponseData) JSON.deserialize(decodedJson, ResponseData.class);
                system.debug('respWrapper'+respWrapper);
                String OrderNumber = respWrapper.SFOrderNumber;
                String SORO = respWrapper.SORO;
                for(Order_Item__c OrdItem:[SELECT BSLS_ID__c, Id, Order__r.Name FROM Order_Item__c Where Order__r.Name=:OrderNumber]){
                    OrdItem.BSLS_ID__c=decimal.valueOf(SORO);
                    orderItemList.add(OrdItem);
                }
                if(orderItemList!=NULL){
                    database.update(orderItemList);
                }
                
                String statusCode = String.valueOf(response.getStatusCode());
                system.debug('Body of Response: ' + response.getBody());
                
                /*if(String.isNotBlank(decodedJson)) {
                    system.debug('responseBody '+decodedJson);
                }*/
            }
        }
        else{            
            system.debug('Body of Response When Response is NULL:');
        }        
    }
    
    public class OrderDetails{
        @AuraEnabled public List<OrderList> OrderList {get;Set;}
    }
    public class OrderList{
        @AuraEnabled public AccountObj  AccountObj{get;set;}
        @AuraEnabled public OrderObj  OrderObj{get;set;}
    }
    public class AccountObj{
        @AuraEnabled public String AccountName {get;Set;}
        @AuraEnabled public String Branch {get;Set;}
        @AuraEnabled public String AccountOwner {get;Set;}
        @AuraEnabled public String BillingAddress {get;Set;}
        @AuraEnabled public String SFID {get;Set;}
        @AuraEnabled public String BSLSID {get;Set;}
    }
    public class OrderObj{
        @AuraEnabled public String OrderNumber {get;Set;}
        @AuraEnabled public String QuotationNumber {get;Set;}
        @AuraEnabled public Date QuotationValidity {get;Set;}
        @AuraEnabled public Date OrderValidity {get;Set;}
        @AuraEnabled public String OrderSFID {get;Set;}
        @AuraEnabled public String QuotationSFID {get;Set;}
        @AuraEnabled public List<OrderItemList> orderItemList {get;Set;}
    }
    public class OrderItemList{
        @AuraEnabled public String OrderNumber {get;Set;}
        @AuraEnabled public String OrderItemNumber {get;Set;}
        @AuraEnabled public String opsExecutive {get;Set;}
        @AuraEnabled public String shippingline {get;Set;}
        @AuraEnabled public String portOfLoading {get;Set;}
        @AuraEnabled public String portOfDestination {get;Set;}
        @AuraEnabled public String placeOfPickup {get;Set;}
        @AuraEnabled public String placeOfDischarge {get;Set;}
        @AuraEnabled public String equipmentType {get;Set;}
        @AuraEnabled public Integer serviceType {get;Set;}
        @AuraEnabled public Integer shipmentType {get;Set;}
        @AuraEnabled public Agent Agent {get;Set;}
        @AuraEnabled public List<Charges> Charges {get;Set;}
        @AuraEnabled public List<Consignee> Consignee {get;Set;}
        @AuraEnabled public List<Shipper> Shipper {get;Set;}
        @AuraEnabled public String quantity {get;Set;}
        @AuraEnabled public String SellingRate {get;Set;}
        @AuraEnabled public Integer CommercialUser {get;Set;}
    }
    public class Agent{
        @AuraEnabled public String AgentName {get;Set;}
        @AuraEnabled public String SFID {get;Set;}
        @AuraEnabled public String BSLSID {get;Set;}
    }
    public class Consignee{
        @AuraEnabled public String AccountName {get;Set;}
        @AuraEnabled public String Branch {get;Set;}
        @AuraEnabled public String AccountOwner {get;Set;}
        @AuraEnabled public String BillingAddress {get;Set;}
        @AuraEnabled public String SFID {get;Set;}
        @AuraEnabled public String BSLSID {get;Set;}
    }
    public class Charges{
        @AuraEnabled public String SFID {get;Set;}
        @AuraEnabled public String BBMSID {get;Set;}        
        @AuraEnabled public String ChargeName {get;Set;}
        @AuraEnabled public String ChargeValue {get;Set;}
        @AuraEnabled public String CurrencyType {get;Set;}
        @AuraEnabled public String ChargeType {get;Set;}
    }
    public class Shipper{
        @AuraEnabled public String AccountName {get;Set;}
        @AuraEnabled public String Branch {get;Set;}
        @AuraEnabled public String AccountOwner {get;Set;}
        @AuraEnabled public String BillingAddress {get;Set;}
        @AuraEnabled public String SFID {get;Set;}
        @AuraEnabled public String BSLSID {get;Set;}
    }
    
    public class ResponseData{
        @AuraEnabled public String SFOrderNumber {get;Set;}
        @AuraEnabled public String SORO {get;Set;}
    }
}