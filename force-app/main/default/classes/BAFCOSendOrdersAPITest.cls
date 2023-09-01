@istest
public class BAFCOSendOrdersAPITest {
    @TestSetup
    static void setup() {
        Commodity__c comd = new Commodity__c();
        comd.Name = 'CommodityName';
        comd.DG_Class__c = 'test';
        insert comd;
        Decimal accInt = Math.random();
        account acc = new Account();
        acc.Branch__c = 'Jeddah';
        acc.Average_Credit_Days__c = 2;
        acc.Average_Margin__c =2;
        acc.Best_Margin__c = 1;
        acc.name = 'test'+accInt;
        insert acc;
        
         Port__c port = new Port__c();
        port.City__c = 'Test';
        port.Name ='PortName';
        port.sector__c = 'Africa';
        
        insert port;
        
        Contact con = new contact();
        con.FirstNAme = 'test';
        con.LastName = 'test';
        con.Email = 'test@email.com';
        con.MobilePhone = '0000000';
        con.AccountId = acc.id;
        insert con;
        
        
        
        opportunity opty = new Opportunity();
        opty.AccountId = acc.id;
        opty.StageName = 'Qualification';
        opty.CloseDate = system.today();
        opty.Name ='testopty';
        opty.Business_Type__c = 'Export';
        //opty.Commercial_User__c = userInfo.getUserId();
        insert opty;
        
        Task tsk = new Task();
        tsk.Subject = 'Provide Quotation';
        tsk.Status = 'Open';
        tsk.OwnerId = UserInfo.getUserId();
        tsk.WhatId = opty.Id;
        tsk.IsReminderSet = true;
        tsk.ActivityDate = Date.valueOf(DateTime.now());
        insert tsk;
        
        Route__c route = new Route__c();
        route.opportunity_enquiry__c = opty.id;
        route.Port_of_Destination__c = port.id;
        route.Port_of_loading__c =port.id;
        route.Commodity__c = comd.id;
        route.Service_Type__c ='P2P';
        route.Kind_Of_Shipment__c = 'FCL';
        insert route;
        
        integer year =  Date.Today().Year();
        string s1=string.valueof(year).right(2);
        Integer Year1= Integer.valueof(s1);
        Quotation__c quoteObj = new Quotation__c();
        quoteObj.Name__c= 'Quote/'+Year1+'/'+1;
        quoteObj.opportunity__c = opty.id;
        quoteObj.Customer_Name__c = 'test';
        quoteObj.Account__c = acc.id;
        quoteObj.Inclusions__c = 'Test Data ;;test data ;';
        quoteObj.Exclusions__c = 'Test Data ;;test data ;';
        quoteObj.Effective_From__c = system.today();
        quoteObj.Quotation_Validity__c = system.today()-50;
        Insert quoteObj;
        
    }
    testmethod static void getOrderTest(){
        //List<Order__c> orderList = [Select Operations_Executive__r.BSLS_ID__c, (Select Agent__r.BSLS_ID__c,Agent__r.Name,Agent__c, Equipment_Type_Order__r.BSLS_ID__c, Place_of_Discharge__r.BSLS_ID__c,Place_of_Pickup__r.BSLS_ID__c,Port_of_Discharge_Order__r.BSLS_ID__c,Port_of_Loading_Order__r.BSLS_ID__c,Shipping_Line__r.BSLS_ID__c, Route_Order__r.Service_Type__c,Route_Order__r.Kind_Of_Shipment__c,Name,id,Order__r.Name from Order_Items__r),Order_Validity__c,Quotation__r.Quotation_Validity__c,Quotation__r.Name, Name,Account_Order__r.BSLS_ID__c,Account_Order__r.BillingAddress, id,Account_Order__c,Account_Order__r.Name,Account_Order__r.Branch__c,Account_Order__r.Owner.Name from Order__c ];
        Quotation__c quoteObj = [Select id,Account__c,Opportunity__c from Quotation__c limit 1];
        Order__c orderObj = new Order__c();
        orderObj.Account_Order__c = quoteObj.Account__c;
        orderObj.Quotation__c = quoteObj.id;
        orderObj.Opportunity_Order__c= quoteObj.Opportunity__c;
        orderObj.Integration__c = true;
        insert orderObj;
        Order_item__c item = new Order_item__c();
        item.Order__c = orderObj.id;
        item.Quantity__c =1;
        item.Buying_Rate__c= 3;
        item.Total_Order__c =2;
		insert  item;
        Additional_Charge__c addin = new Additional_Charge__c();
        addin.name ='test';
        insert addin;
        Order_Charges__c orderCharge = new Order_Charges__c();
        orderCharge.Buying_Rate__c = 1;
        orderCharge.Charge_Name__c = addin.id;
        orderCharge.Order_Item__c = item.id;
        insert orderCharge;
        
        Consignee__c consignee = new Consignee__c();
        consignee.Consignee__c = quoteObj.Account__c;
        consignee.Order_Item__c = item.id;
        insert consignee;
        
        Shipper__c shipper = new Shipper__c();
        shipper.Shipper__c = quoteObj.Account__c;
        shipper.Order_Item__c = item.id;
        insert shipper;
        List<Id> orderIds = new List<Id>{orderObj.id};
        /*for(Order__c orderOb : orderList){
            orderIds.add(orderOb.Id);
        }*/
        test.startTest();
        Test.setMock(HttpCalloutMock.class, new BAFCOExchangeRateMockTest());
        BAFCOSendOrdersAPI.sendOrderData(orderIds);
        test.stopTest();
    }
    testmethod static void postOrderTest(){
        Test.setMock(HttpCalloutMock.class, new BAFCOOrderCalloutMockTest());
        Agent__c agentObj = new Agent__c();
        agentObj.name =  'test';
        insert agentObj;
        
        Port__c port = new Port__c();
        port.City__c = 'Test';
        port.Name ='PortName';
        port.sector__c = 'Africa';
        
        insert port;
         Id IMPORT_RECORDTYPE_Id = Schema.SObjectType.Order__c.getRecordTypeInfosByName()
        .get('Import')
        .getRecordTypeId();
        Quotation__c quote = [Select id,Account__c from Quotation__c limit 1];
        Order__c obj = new Order__c();
        obj.Account_Order__c = quote.Account__c;
        obj.Quotation__c = quote.id;
        obj.RecordtypeId = IMPORT_RECORDTYPE_Id;
        obj.Integration__c = true;
        insert obj;
        
        List<Equipment_Type__c> equipList = new List<Equipment_Type__c>();
        Equipment_Type__c equip = new Equipment_Type__c();
        equip.Name='20DC';
        equip.BSLS_ID__c = 'test';
        equipList.add(equip);
        
        Equipment_Type__c equip2 = new Equipment_Type__c();
        equip2.Name='40HC';
        equip2.BSLS_ID__c = 'test 2';
        equipList.add(equip2);
        
        insert equipList;
        Route__c route = [Select id from Route__c limit 1];
        List<Order_item__c> orderItemList = new List<Order_item__c>();
        Order_item__c item = new Order_item__c();
        item.Order__c = obj.id;
        item.Agent__c = agentObj.id;
        item.Port_of_Discharge_Order__c = port.id;
        item.Port_of_Loading_Order__c = port.id;
        item.Equipment_Type_Order__c = equip.id;
        item.Route_Order__c = route.id;
       	orderItemList.add(item);
        
        Order_item__c item2 = new Order_item__c();
        item2.Order__c = obj.id;
        item2.Agent__c = agentObj.id;
        item2.Port_of_Discharge_Order__c = port.id;
        item2.Port_of_Loading_Order__c = port.id;
        item2.Equipment_Type_Order__c = equip2.id;
        
       	orderItemList.add(item2);
        insert orderItemList;
        
        Consignee__c ConSobj = new Consignee__c();
        ConSobj.Consignee__c = quote.Account__c;
        //ConSobj.Name = 'test';
        ConSobj.Order_Item__c = item.id;        
        insert ConSobj;
        
        Shipper__c shipperObj = new Shipper__c();
        shipperObj.Shipper__c = quote.Account__c;
       // shipperObj.Name = 'test';
        shipperObj.Order_Item__c = item.id;        
        insert shipperObj;
        test.startTest();
        //Test.setMock(HttpCalloutMock.class, new BAFCOExchangeRateMockTest());
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        BAFCOUpdatETDOnOrderAPI.ETDRequestBodyWrapper dto = new BAFCOUpdatETDOnOrderAPI.ETDRequestBodyWrapper();
        Order__c orderObj = [Select id , name from Order__c limit 1];
        dto.OrderNumber =orderObj.Name;
        dto.VesselETD = system.today();
        String s = JSON.serialize(dto);
        req.requestURI = '/OrderUpdate/UpdateETDValue/*';  
        req.requestBody = Blob.valueof(s);
        RestContext.request = req;
        RestContext.response= res;
        BAFCOUpdatETDOnOrderAPI.doPost();
        test.stopTest();
    }
   /* testmethod static void postOrderTest2(){
        test.startTest();
        Test.setMock(HttpCalloutMock.class, new BAFCOExchangeRateMockTest());
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        BAFCOUpdatETDOnOrderAPI.ETDRequestBodyWrapper dto = new BAFCOUpdatETDOnOrderAPI.ETDRequestBodyWrapper();
        
        dto.OrderNumber = 'test';
        dto.VesselETD = system.today();
        String s = JSON.serialize(dto);
        req.requestURI = '/OrderUpdate/UpdateETDValue/*';  
        req.requestBody = Blob.valueof(s);
        RestContext.request = req;
        RestContext.response= res;
        BAFCOUpdatETDOnOrderAPI.doPost();
        test.stopTest();
    }*/
   
}