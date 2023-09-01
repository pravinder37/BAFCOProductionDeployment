@isTest
public class BAFCOEditOpportunityControllerTest {
    @TestSetup
    static void setup() {   
        List<Port__c> portList = new List<Port__c>();
        Port__c port = new Port__c(); 
        port.City__c = 'Test';
        port.Name ='PortName';
        port.sector__c = 'Africa';
        portList.add(port);
        
        Port__c port2 = new Port__c();
        port2.City__c = 'Test 2';
        port2.Name ='PortName 2';
        port2.sector__c = 'Africa';
        portList.add(port2);
        
        insert portList;
        
        List<Commodity__c> comodityLis = new List<Commodity__c>();
        Commodity__c comd = new Commodity__c();
        comd.Name = 'CommodityName';
        comd.DG_Class__c = 'test';
        comodityLis.add(comd);
        Commodity__c comd2 = new Commodity__c();
        comd2.Name = 'FAK';
        comd2.DG_Class__c = 'test2';
        comodityLis.add(comd2);
        insert comodityLis;
        
        Account acc = new Account();
        acc.Branch__c = 'Jeddah';
        acc.Average_Credit_Days__c = 2;
        acc.Average_Margin__c =2;
        acc.Best_Margin__c = 1;
        acc.name = 'test';
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
        
        
        
        place__c  placeObj = new place__c();
        placeObj.Name = 'test';
        insert placeObj;
        
        INCO_Term__c incoTerm = new INCO_Term__c();
        incoTerm.Name = 'IncoTerm';
        insert incoTerm;
        
        Route__c route = new Route__c();
        route.opportunity_enquiry__c = opty.id;
        route.Port_of_Destination__c = port.id;
        route.Port_of_loading__c =port.id;
        route.Commodity__c = comd.id;
        route.Place_of_Discharge__c = placeObj.id;
        route.Place_of_Pickup__c = placeObj.id;
        route.INCO_Term__c = incoTerm.id;
        insert route;
        
        Route_Equipment__c rEquip = new Route_Equipment__c();
        rEquip.Route__c = route.id;
        rEquip.Quantity__c = 2;
        Insert rEquip;
        
    }
    testMethod Static void getAccountIdTest(){
        BAFCOEditOpportunityController.getAccountId([Select id from Opportunity limit 1].id);
    }
    testMethod Static void getEditOptyDetailTest(){
        BAFCOEditOpportunityController.getEditOptyDetail([Select id from Opportunity limit 1].id);
    }
    /*testMethod Static void getEditOptyDetailTest01(){
       Id opportunityAirFreight = Schema.SObjectType.opportunity.getRecordTypeInfosByName()
        .get('Air Freight')
        .getRecordTypeId();
        Account acc = [Select id from Account limit 1];
        opportunity opty2 = new Opportunity();
        opty2.AccountId = acc.id;
        opty2.StageName = 'Qualification';
        opty2.CloseDate = system.today();
        opty2.Name ='testopty******';
        opty2.RecordTypeId = opportunityAirFreight;
        opty2.Business_Type__c = 'Export';
        insert opty2;
        
        Task tsk1 = new Task();
        tsk1.Subject = 'Provide Quotation';
        tsk1.Status = 'Open';
        tsk1.OwnerId = UserInfo.getUserId();
        tsk1.WhatId = opty2.Id;
        tsk1.IsReminderSet = true;
        tsk1.ActivityDate = Date.valueOf(DateTime.now());
        insert tsk1;
        Airport__c airObj = new Airport__c();
        airObj.Name = 'test';
        insert airObj;
        
         Shipping_Line__c shipLine = new  Shipping_Line__c();
        shipLine.Name = 'ShipLine';
        shipLine.BSLS_ID__c = 'test';
        Insert shipLine;
            
        Route__c route1 = new Route__c();
        route1.opportunity_enquiry__c = opty2.id;
        route1.Airport_of_Destination__c = airObj.id;
        route1.Airport_of_Loading__c = airObj.id;
        route1.Shipping_Line__c = shipLine.id;
        insert route1;
        
        BAFCOEditOpportunityController.getEditOptyDetail(opty2.id);
    }*/
    testmethod static void dummy(){
        BAFCOEditOpportunityController.testDummy();
    }
}