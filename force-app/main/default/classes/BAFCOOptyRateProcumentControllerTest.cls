@isTest
public class BAFCOOptyRateProcumentControllerTest {
    @TestSetup
    static void setup() {
        Port__c port2 = new Port__c();
        port2.City__c = 'Test 2';
        port2.Name ='PortName 2';
        port2.sector__c = 'Africa';
        insert port2;
        
        Commodity__c comd = new Commodity__c();
        comd.Name = 'CommodityName';
        comd.DG_Class__c = 'test';
        insert comd;
        
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
        opty.Service_Type__c = 'Sea Export';
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
        
        Route__c route1 = new Route__c();
        route1.opportunity_enquiry__c = opty.id;
        route1.Port_of_Destination__c = port2.id;
        route1.Port_of_loading__c =port2.id;
        route1.Commodity__c = comd.id;
        route1.Place_of_Discharge__c = placeObj.id;
        route1.Place_of_Pickup__c = placeObj.id;
        insert route1;
        
        Equipment_Type__c equip = new Equipment_Type__c();
        equip.Name='EquipName';
        equip.BSLS_ID__c = 'test';
        Insert equip;
        
        Route_Equipment__c rEquip = new Route_Equipment__c();
        rEquip.Route__c = route1.id;
        rEquip.Equipment_Type__c = equip.id;
        Insert rEquip;
        
    }
    testMethod static void getRouteRouteDetails(){
        test.startTest();
        BAFCOOptyRateProcumentController.getRouteRouteDetails([Select id from opportunity limit 1].id);
        test.stopTest();
    }
}