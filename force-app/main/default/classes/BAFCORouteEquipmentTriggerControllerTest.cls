@isTest
public class BAFCORouteEquipmentTriggerControllerTest {
    testmethod static void insertRouteProcumnetExport(){
        Port__c port = new Port__c();
        port.City__c = 'Test 2';
        port.Name ='PortName 2';
        port.sector__c = 'Africa';
        insert port;
        
        place__c  placeObj = new place__c();
        placeObj.Name = 'test';
        insert placeObj;
        
        Commodity__c comd = new Commodity__c();
        comd.Name = 'CommodityName';
        comd.DG_Class__c = 'test';
        insert comd;
        
        Equipment_Type__c equip = new Equipment_Type__c();
        equip.Name='EquipName';
        equip.BSLS_ID__c = 'test';
        Insert equip;
        
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
        
        Shipping_Line__c shipLine = new  Shipping_Line__c();
        shipLine.Name = 'ShipLine';
        shipLine.BSLS_ID__c = 'test';
        Insert shipLine;
        
        Route__c route1 = new Route__c();
        route1.opportunity_enquiry__c = opty.id;
        route1.Port_of_Destination__c = port.id;
        route1.Port_of_loading__c =port.id;
        route1.Commodity__c = comd.id;
        route1.Place_of_Discharge__c = placeObj.id;
        route1.Place_of_Pickup__c = placeObj.id;
        route1.Shipping_Line__c = shipLine.id;
        Insert route1;
        
        Rate_Procurement__c proc = new Rate_Procurement__c();
        proc.Port_of_Discharge__c = port.id;
        proc.Port_of_Loading__c = port.id;
        proc.Shipping_Line__c = shipLine.id;
        proc.Equipment_Type__c = equip.id;
        insert proc;
        
        List<Rms__c> rmsList =new List<Rms__c>();
        
        Id RMS_IMPORT_RECORDTYPE_Id = Schema.SObjectType.RMS__c.getRecordTypeInfosByName()
        .get('Import')
        .getRecordTypeId();
        Rms__c rmsobj1 = new Rms__c();
        rmsobj1.Port_Of_Discharge__c = port.id;
        rmsobj1.Port_Of_Loading__c = port.id;
        rmsobj1.Shipping_Line__c = shipLine.id;
        rmsobj1.Equipment_Type__c = equip.id;
        rmsObj1.RecordTypeId = RMS_IMPORT_RECORDTYPE_Id;
       rmsList.add(rmsObj1);
        insert rmsList;
        
        Route_Equipment__c rEquip = new Route_Equipment__c();
        rEquip.Route__c = route1.id;
        rEquip.Equipment_Type__c = equip.id;
        Insert rEquip;
    }
    testmethod static void insertRouteProcumnetExport01(){
        Port__c port = new Port__c();
        port.City__c = 'Test 2';
        port.Name ='PortName 2';
        port.sector__c = 'Africa';
        insert port;
        
        place__c  placeObj = new place__c();
        placeObj.Name = 'test';
        insert placeObj;
        
        Commodity__c comd = new Commodity__c();
        comd.Name = 'CommodityName';
        comd.DG_Class__c = 'test';
        insert comd;
        
        Equipment_Type__c equip = new Equipment_Type__c();
        equip.Name='EquipName';
        equip.BSLS_ID__c = 'test';
        Insert equip;
        
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
        
        Shipping_Line__c shipLine = new  Shipping_Line__c();
        shipLine.Name = 'ShipLine';
        shipLine.BSLS_ID__c = 'test';
        Insert shipLine;
        
        Route__c route1 = new Route__c();
        route1.opportunity_enquiry__c = opty.id;
        route1.Port_of_Destination__c = port.id;
        route1.Port_of_loading__c =port.id;
        route1.Commodity__c = comd.id;
        route1.Place_of_Discharge__c = placeObj.id;
        route1.Place_of_Pickup__c = placeObj.id;
        route1.Shipping_Line__c = shipLine.id;
        Insert route1;
        
        Rate_Procurement__c proc = new Rate_Procurement__c();
        proc.Port_of_Discharge__c = port.id;
        proc.Port_of_Loading__c = port.id;
        proc.Shipping_Line__c = shipLine.id;
        proc.Equipment_Type__c = equip.id;
        insert proc;
        
        List<Rms__c> rmsList =new List<Rms__c>();
        Id RMS_EXPORT_RECORDTYPE_Id = Schema.SObjectType.RMS__c.getRecordTypeInfosByName()
        .get('Export')
        .getRecordTypeId();
        Rms__c rmsobj = new Rms__c();
        rmsObj.Port_Of_Discharge__c = port.id;
        rmsObj.Port_Of_Loading__c = port.id;
        rmsObj.Shipping_Line__c = shipLine.id;
        rmsobj.Equipment_Type__c = equip.id;
        rmsObj.RecordTypeId = RMS_EXPORT_RECORDTYPE_Id;
        rmsList.add(rmsObj);
       
        insert rmsList;
        
        Route_Equipment__c rEquip = new Route_Equipment__c();
        rEquip.Route__c = route1.id;
        rEquip.Equipment_Type__c = equip.id;
        Insert rEquip;
    }
}