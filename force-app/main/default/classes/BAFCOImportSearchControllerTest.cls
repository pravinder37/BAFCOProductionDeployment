@isTest
public class BAFCOImportSearchControllerTest {
	@TestSetup
    static void setup() { 
        account acc = new Account(); 
        acc.Branch__c = 'Jeddah';
        acc.Average_Credit_Days__c = 2;
        acc.Average_Margin__c =2;
        acc.Best_Margin__c = 1;
        acc.name = 'test';
        insert acc;
        
        Agent__c agentObj = new Agent__c();
        agentObj.name =  'test';
        agentObj.Type__c = 'WACO';
        insert agentObj;
        
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
        
        integer year =  Date.Today().Year();
        string s1=string.valueof(year).right(2);
        Integer Year1= Integer.valueof(s1);
        Quotation__c quoteObj = new Quotation__c();
        quoteObj.Name__c= 'Quote/'+Year1+'/'+1;
        quoteObj.opportunity__c = opty.id;
        quoteObj.Customer_Name__c = 'test';
        quoteObj.Account__c = acc.id;
        Insert quoteObj;
        
        Quotation_Item__c quoteItem = new Quotation_Item__c();
        quoteItem.Quotation__c = quoteObj.Id;
        quoteItem.Sea_freight__c =12;
        Insert quoteItem;
        
        Order__c obj = new Order__c();
        obj.Account_Order__c = acc.id;
        obj.Quotation__c = quoteObj.id;
        insert obj;
        
        Order_item__c item = new Order_item__c();
        item.Order__c = obj.id;
        item.Agent__c = agentObj.id;
        insert item;
    }
    testmethod static void getImportItemTest(){
        String agentId = [Select id from Agent__c limit 1].id;
        String todaysDate = String.valueOf(System.today());
        test.startTest();
        BAFCOImportSearchController.getImportItem(agentId,null,null,null);
        test.stopTest();
    }
     testmethod static void updateQuoteItemTest(){
         Shipping_Line__c shipLine = new Shipping_Line__c();
         shipLine.name = 'tes';
         shipLine.BSLS_ID__c = '1212';
         insert shipLine;
        String itemId = [Select id from Order_item__c limit 1].id;
         Test.setMock(HttpCalloutMock.class, new BAFCOOrderCalloutMockTest());
        test.startTest();
        BAFCOImportSearchController.updateQuoteItem(10,10,itemId,shipLine.id,null);
        test.stopTest();
    }
    testmethod static void getImportItemOnLoad01(){
        test.startTest();
        BAFCOImportSearchController.getImportItemOnLoad();
        test.stopTest();
    }
    testMethod static void getOrderItemValue(){
        String itemId = [Select id from Order_item__c limit 1].id;
        test.startTest();
        BAFCOImportSearchController.getOrderItemValue(itemId);
        test.stopTest();
    }
    testMethod static void updateOrderItemValue(){
        String itemId = [Select id from Order_item__c limit 1].id;
        String quotationValidity = String.valueOf(System.today().addDays(7));
        Shipping_Line__c shipLine = new  Shipping_Line__c();
        shipLine.Name = 'ShipLine';
        shipLine.BSLS_ID__c = '12121';
        Insert shipLine;
        test.startTest();
        Test.setMock(HttpCalloutMock.class, new BAFCOOrderCalloutMockTest());
         BAFCOImportSearchController.updateOrderItemValue(10, 10, shipLine.id, quotationValidity, itemId);
        test.stopTest();
    }
    testmethod static void testDummy(){
        BAFCOImportSearchController.testDummy();
    }
}