@isTest
public class BAFCOGenerateOrderPDFControllerTest {
    @TestSetup
    static void setup() {
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
        quoteObj.Inclusions__c = 'Test Data ;;test data ;';
        quoteObj.Exclusions__c = 'Test Data ;;test data ;';
        quoteObj.Effective_From__c = system.today();
        Insert quoteObj;

    }
    @isTest static void testController(){
        test.startTest();
        
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
        Quotation__c quoteObj = [Select id,Account__c from Quotation__c limit 1];
        Order__c obj = new Order__c();
        obj.Account_Order__c = quoteObj.Account__c;
        obj.Quotation__c = quoteObj.id;
        insert obj;
        
        
        Agent__c agentObj = new Agent__c();
        agentObj.name =  'test';
        agentObj.Type__c = 'Non-WACO';
        insert agentObj;
        
        Port__c port = new Port__c();
        port.City__c = 'Test';
        port.Name ='PortName';
        port.sector__c = 'Africa';
        
        insert port;
        
        List<Order_item__c> orderItemList = new List<Order_item__c>();
        Order_item__c item = new Order_item__c();
        item.Order__c = obj.id;
        item.Agent__c = agentObj.id;
        item.Port_of_Discharge_Order__c = port.id;
        item.Port_of_Loading_Order__c = port.id;
        item.Equipment_Type_Order__c = equip.id;
        item.Quantity__c =1;
        item.Buying_Rate__c= 3;
        item.Total_Order__c =2;
        orderItemList.add(item);
        
        Order_item__c item2 = new Order_item__c();
        item2.Order__c = obj.id;
        item2.Agent__c = agentObj.id;
        item2.Port_of_Discharge_Order__c = port.id;
        item2.Port_of_Loading_Order__c = port.id;
        item2.Equipment_Type_Order__c = equip2.id;
        item.Quantity__c =1;
        item.Buying_Rate__c =3;
        item.Total_Order__c =2;
        orderItemList.add(item2);
        
        insert orderItemList;
        PageReference testPage = Page.BAFCOOrderPDFPage; 
        Test.setCurrentPage(testPage);
        testPage.getParameters().put('showShippLine', 'true');
        testPage.getParameters().put('showCharges', 'true');
        testPage.getParameters().put('recordId', obj.id);
        ApexPages.StandardController sc = new  ApexPages.StandardController(obj); 
        BAFCOGenerateOrderPDFController ob = new BAFCOGenerateOrderPDFController(sc);
        ob.getQuoteData();
        test.stopTest();
    }
    @isTest static void testController01(){
        test.startTest();
        Port__c port = new Port__c();
        port.City__c = 'Test';
        port.Name ='PortName';
        port.sector__c = 'Africa';
        
        insert port;
        
        Agent__c agentObj = new Agent__c();
        agentObj.name =  'test';
        agentObj.Type__c = 'Non-WACO';
        insert agentObj;
        
        Equipment_Type__c equip2 = new Equipment_Type__c();
        equip2.Name='40HC';
        equip2.BSLS_ID__c = 'test 2';
        insert equip2;
        
        Quotation__c quoteObj = [Select id,Account__c from Quotation__c limit 1];
        Order__c obj2 = new Order__c();
        obj2.Account_Order__c = quoteObj.Account__c;
        obj2.Quotation__c = quoteObj.id;
        obj2.isAir__c = true;
        insert obj2;
        
        Order_item__c item3 = new Order_item__c();
        item3.Order__c = obj2.id;
        item3.Agent__c = agentObj.id;
        item3.Port_of_Discharge_Order__c = port.id;
        item3.Port_of_Loading_Order__c = port.id;
        item3.Equipment_Type_Order__c = equip2.id;
        item3.Quantity__c =1;
        item3.Total_Order__c =2;
        item3.Buying_Rate__c= 3;
        insert item3;
        
        PageReference testPage = Page.BAFCOOrderPDFPage; 
        Test.setCurrentPage(testPage);
        testPage.getParameters().put('showShippLine', 'true');
        testPage.getParameters().put('showCharges', 'true');
        testPage.getParameters().put('recordId', obj2.id);
        ApexPages.StandardController sc = new  ApexPages.StandardController(obj2); 
        BAFCOGenerateOrderPDFController ob = new BAFCOGenerateOrderPDFController(sc);
        ob.getQuoteData();
        test.stopTest();
    }
}