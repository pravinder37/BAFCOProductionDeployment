@istest
public class BAFCOQuoteCopyContentControllerTest {
@TestSetup
    static void setup() { 
       
        Account acc = new Account();
        acc.name = 'test';
        acc.Branch__c = 'Jeddah';
        insert acc;
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
        Enquiry__c enq = new Enquiry__c();
        enq.Name = 'Test';
        insert enq;
        
        Port__c port = new Port__c();
        port.City__c = 'Test';
        port.Name ='PortName';
        port.Sector__c = 'Africa';
        Insert port;
        
        Commodity__c comd = new Commodity__c();
        comd.Name = 'CommodityName';
        comd.DG_Class__c = 'test';
        insert comd;
        
        Shipping_Line__c shipLine = new  Shipping_Line__c();
        shipLine.Name = 'ShipLine';
        shipLine.BSLS_ID__c = 'test';
        Insert shipLine;
        
        Equipment_Type__c equip = new Equipment_Type__c();
        equip.Name='EquipName';
        equip.BSLS_ID__c = 'test';
        Insert equip;
        RMS__c rmsObj = new RMS__c();
        rmsObj.Name ='Test';
        rmsObj.Port_Of_Discharge__c = port.Id;
        rmsObj.Port_Of_Loading__c = port.Id;
        rmsObj.Commodity__c =comd.Id;
        rmsObj.Shipping_Line__c = shipLine.id;
        rmsObj.Equipment_Type__c = equip.id;
        rmsObj.Validity__c = System.today().addDays(5);
        rmsObj.Sea_Freight__c = 1000;
        insert rmsObj;
        
        Route__c route = new Route__c();
        //route.Enquiry__c = enq.id;
        route.Port_of_Destination__c = port.id;
        route.Port_of_loading__c =port.id;
        route.Commodity__c = comd.id;
        route.Opportunity_Enquiry__c = opty.id;
        insert route;
        integer year =  Date.Today().Year();
        string s1=string.valueof(year).right(2);
        Integer Year1= Integer.valueof(s1);
        Quotation__c quoteObj = new Quotation__c();
        quoteObj.Name__c= 'Quote/'+Year1+'/'+1;
        quoteObj.Opportunity__c = opty.id;
        quoteObj.Account__c = acc.id; 
        quoteObj.Inclusions__c = 'testData ;; testdata;';
        quoteObj.Exclusions__c = 'testData ;; testdata;';
        quoteObj.Terms_and_Conditions__c = 'testData ;; testdata;';
        Insert quoteObj;
        
        Loading_Charge__c exWorks= new Loading_Charge__c();
        exWorks.Name  = 'tes';
        exWorks.Loading_Charge__c = 100;
        exWorks.Port_of_Loading__c = port.id;
        exWorks.Direction__c = 'One Way';
        exWorks.Pickup_Place__c = 'test';
        insert exWorks;
        List<Quotation_Item__c> quoteItemList = new List<Quotation_Item__c>();
      
        Quotation_Item__c quoteItem1 = new Quotation_Item__c();
        quoteItem1.RMS__c = rmsObj.id;
        quoteItem1.Route__c = route.id;
        quoteItem1.Quotation__c = quoteObj.Id;
        quoteItem1.Equipment_Type__c = equip.id;
        quoteItem1.Sea_Freight__c = 100;
        quoteItemList.add(quoteItem1);
        Insert quoteItemList;
    }
    testMethod static void getQuoteDataOnLoadTest(){
        Quotation__c Quoteobj  = [Select id from Quotation__c limit 1];
        BAFCOQuoteCopyContentController.getQuoteDataOnLoad(Quoteobj.id);
        
        Id QUOTE_IMPORT_RECORDTYPE_Id = Schema.SObjectType.quotation__c.getRecordTypeInfosByName()
        .get('Import')
        .getRecordTypeId();
        
        Quoteobj.RecordTypeId = QUOTE_IMPORT_RECORDTYPE_Id;
        update quoteObj;
        
        BAFCOQuoteCopyContentController.getQuoteDataOnLoad(Quoteobj.id);
    }
    testMethod static void sendEmailTest(){
        Quotation__c Quoteobj  = [Select id from Quotation__c limit 1];
        BAFCOQuoteCopyContentController.sendEmail('toSend@email.com', 'toCCSend@email.com', 'toBCCSend@email.com', 'subject', 'body',Quoteobj.id);
    }
  
}