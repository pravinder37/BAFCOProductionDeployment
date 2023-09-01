@istest
public class BAFCORouteTriggerTest {
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
        
        Port__c port = new Port__c();
        port.City__c = 'Test';
        port.Name ='PortName';
        port.Sector__c = 'Africa';
        Insert port;
        
        Commodity__c comd = new Commodity__c();
        comd.Name = 'CommodityName';
        comd.DG_Class__c = 'test';
        insert comd;
        List<Route__c> routeList = new List<Route__c>();
        Route__c route = new Route__c();
        route.Port_of_Destination__c = port.id;
        route.Port_of_loading__c =port.id;
        route.Commodity__c = comd.id;
        route.Opportunity_Enquiry__c = opty.id;
        routeList.add(route);
        
        Route__c route2 = new Route__c();
        route2.Port_of_Destination__c = port.id;
        route2.Port_of_loading__c =port.id;
        route2.Commodity__c = comd.id;
        route2.Opportunity_Enquiry__c = opty.id;
        routeList.add(route2);
        
        insert routeList;
    }
    testMethod static void routeAfterEditTest(){
        Port__c port = new Port__c();
        port.City__c = 'Test';
        port.Name ='PortName';
        port.Sector__c = 'Africa';
        Insert port;
        
        Route__c routeObj = [Select id from Route__c limit 1];
        routeObj.Port_of_loading__c = port.id;
        update routeObj;
    }
    testMethod static void routeBeforeDeleteTest(){
        Route__c routeObj = [Select id from Route__c limit 1];
        delete routeObj;
    }
}