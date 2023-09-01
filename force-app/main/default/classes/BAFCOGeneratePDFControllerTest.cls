@isTest
public class BAFCOGeneratePDFControllerTest {
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
        
        Agent__c agentObj = new Agent__c();
        agentObj.name =  'test';
        insert agentObj;
        
        place__c  placeObj = new place__c();
        placeObj.Name = 'test';
        insert placeObj;
        
        Port__c port = new Port__c();
        port.City__c = 'Test';
        port.Name ='PortName';
        port.sector__c = 'Africa';
        
        insert port;
        
        Commodity__c comd = new Commodity__c();
        comd.Name = 'CommodityName';
        comd.DG_Class__c = 'test';
        insert comd;
        
        Shipping_Line__c shipLine = new  Shipping_Line__c();
        shipLine.Name = 'ShipLine';
        shipLine.BSLS_ID__c = 'test';
        Insert shipLine;
        
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
        
        Quotation__c quoteObj2 = new Quotation__c();
        quoteObj2.Name__c= 'Quote/'+Year1+'/'+1;
        quoteObj2.opportunity__c = opty.id;
        quoteObj2.Customer_Name__c = 'test';
        quoteObj2.Account__c = acc.id;
        quoteObj2.Inclusions__c = 'Test Data ;;test data ;';
        quoteObj2.Exclusions__c = 'Test Data ;;test data ;';
        quoteObj2.Effective_From__c = system.today();
        quoteObj2.isAir__c = true;
        Insert quoteObj2;
        
        List<Equipment_Type__c> equipList = new List<Equipment_Type__c>();
        Equipment_Type__c equip = new Equipment_Type__c();
        equip.Name='20DC';
        equip.BSLS_ID__c = 'test';
        equipList.add(equip);
        
        Route__c route = new Route__c();
        route.opportunity_enquiry__c = opty.id;
        route.Port_of_Destination__c = port.id;
        route.Port_of_loading__c =port.id;
        route.Commodity__c = comd.id;
        route.Place_of_Discharge__c = placeObj.id;
        route.Place_of_Pickup__c = placeObj.id;
        insert route;
        
        
        
        Equipment_Type__c equip2 = new Equipment_Type__c();
        equip2.Name='40HC';
        equip2.BSLS_ID__c = 'test 2';
        equipList.add(equip2);
        
        insert equipList;
        
        
        
        
        RMS__c rmsObj = new RMS__c();
        rmsObj.Name ='Test';
        rmsObj.Port_Of_Discharge__c = port.Id;
        rmsObj.Port_Of_Loading__c = port.Id;
        rmsObj.Commodity__c =comd.Id;
        rmsObj.Shipping_Line__c = shipLine.id;
        rmsObj.Equipment_Type__c = equip.id;
        rmsObj.Validity__c = System.today().addDays(5);
        
        insert rmsObj;
        
        
        List<Quotation_Item__c> itemList = new List<Quotation_Item__c>();
        Quotation_Item__c quoteItem = new Quotation_Item__c();
        quoteItem.RMS__c = rmsObj.id;
        quoteItem.Route__c = route.id;
        quoteItem.Quotation__c = quoteObj.Id;
        quoteItem.Equipment_Type__c = equip.id;
        quoteItem.Sea_Freight__c = 100;
        itemList.add(quoteItem);
        
        Quotation_Item__c quoteItem1 = new Quotation_Item__c();
        quoteItem1.RMS__c = rmsObj.id;
        quoteItem1.Route__c = route.id;
        quoteItem1.Quotation__c = quoteObj.Id;
        quoteItem1.Equipment_Type__c = equip2.id;
        quoteItem1.Sea_Freight__c = 100;
        itemList.add(quoteItem1);
        
        Quotation_Item__c quoteItem2 = new Quotation_Item__c();
        quoteItem2.RMS__c = rmsObj.id;
        quoteItem2.Route__c = route.id;
        quoteItem2.Quotation__c = quoteObj2.Id;
        quoteItem2.Equipment_Type__c = equip2.id;
        quoteItem2.Sea_Freight__c = 100;
        itemList.add(quoteItem2);
        
        insert itemList;
        
    }
    @isTest static void testController(){
        Quotation__c quoteObj = [Select id from Quotation__c limit 1];
         PageReference testPage = Page.BAFCOGeneratePdf; 
   		Test.setCurrentPage(testPage);
        testPage.getParameters().put('showShippLine', 'true');
        testPage.getParameters().put('showCharges', 'true');
        testPage.getParameters().put('recordId', quoteObj.id);
        ApexPages.StandardController sc = new  ApexPages.StandardController(quoteObj); 
        BAFCOGeneratePDFController cls = new BAFCOGeneratePDFController(sc); 
        cls.getQuoteData();
    }
    @isTest static void testController01(){
        Quotation__c quoteObj = [Select id from Quotation__c where isAir__c = true limit 1];
         PageReference testPage = Page.BAFCOGeneratePdf; 
   		Test.setCurrentPage(testPage);
        testPage.getParameters().put('showShippLine', 'true');
        testPage.getParameters().put('showCharges', 'true');
        testPage.getParameters().put('recordId', quoteObj.id);
        ApexPages.StandardController sc = new  ApexPages.StandardController(quoteObj); 
        BAFCOGeneratePDFController cls = new BAFCOGeneratePDFController(sc); 
        cls.getQuoteData();
    }
}