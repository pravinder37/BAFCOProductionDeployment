@isTest
public class BAFCOOrderCalloutControllerTest {
@TestSetup
    static void setup() { 
        Commodity__c comd = new Commodity__c();
        comd.Name = 'CommodityName';
        comd.DG_Class__c = 'test';
        insert comd;
        account acc = new Account();
        acc.Branch__c = 'Jeddah';
        acc.Average_Credit_Days__c = 2;
        acc.Average_Margin__c =2;
        acc.Best_Margin__c = 1;
        acc.name = 'test';
        insert acc;
        
        Contact con = new contact();
        con.FirstNAme = 'test';
        con.LastName = 'test';
        con.Email = 'test@email.com';
        con.MobilePhone = '0000000';
        con.AccountId = acc.id;
        insert con;
        
        Agent__c agentObj = new Agent__c();
        agentObj.name =  'test';
        agentObj.Type__c = 'Non-WACO';
        insert agentObj;
        
        Port__c port = new Port__c();
        port.City__c = 'Test';
        port.Name ='PortName';
        port.sector__c = 'Africa';
        
        insert port;
       
        
        opportunity opty = new Opportunity();
        opty.AccountId = acc.id;
        opty.StageName = 'Qualification';
        opty.CloseDate = system.today();
        opty.Name ='testopty';
        opty.Business_Type__c = 'Export';
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
        Insert quoteObj;
        
        
    }
    testmethod static void getOrderDataTest(){
        Test.setMock(HttpCalloutMock.class, new BAFCOOrderCalloutMockTest());
        Agent__c agentObj = new Agent__c();
        agentObj.name =  'test';
        agentObj.Type__c = 'Non-WACO';
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
        ConSobj.Order_Item__c = item.id;        
        insert ConSobj;
        
        Shipper__c shipperObj = new Shipper__c();
        shipperObj.Shipper__c = quote.Account__c;
        shipperObj.Order_Item__c = item.id;        
        insert shipperObj;
        test.startTest();
        RestRequest request = new RestRequest();
        Test.setMock(HttpCalloutMock.class, new BAFCOExchangeRateMockTest());
        request.requestUri ='/services/apexrest/getSFData/getOrderData';
        request.httpMethod = 'GET';
        RestContext.request = request;
        BAFCOOrderCalloutController.getOrderData();
        test.stopTest();
    }
}