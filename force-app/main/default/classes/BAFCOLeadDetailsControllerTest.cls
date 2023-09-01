@isTest
public class BAFCOLeadDetailsControllerTest {
    @TestSetup
    static void setup() {
        Lead__c ld = new Lead__c();
        ld.Business_Type__c = 'Import';
        insert ld;
        
        Lead__c ld1 = new Lead__c();
        ld1.Business_Type__c = 'Export';
        insert ld1;
        Account acc= new Account();
        acc.Branch__c= 'Jeddah';
        acc.Name= 'test';
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
        Contact cont = new Contact();
        cont.FirstName='First Name';
        cont.LastName = 'Last name';
        cont.Leadc__c = ld.Id;
        cont.AccountId = acc.id;
        insert cont;
        Port__c portObj = new Port__c();
        portObj.Name = 'test';
        portObj.Sector__c = 'Africa';
        insert portObj;
        
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
        rmsObj.Port_Of_Discharge__c = portObj.Id;
        rmsObj.Port_Of_Loading__c = portObj.Id;
        rmsObj.Commodity__c =comd.Id;
        rmsObj.Shipping_Line__c = shipLine.id;
        rmsObj.Equipment_Type__c = equip.id;
        rmsObj.Validity__c = System.today().addDays(15);
        insert rmsObj;
        
    }
    testmethod static void getLeadDetailsTest01(){
        Id leadId = [Select id from Lead__c where Business_Type__c = 'Import' limit 1].Id;
        test.startTest();
        try{
            BAFCOLeadDetailsController.getLeadDetails(leadId);
        }
        Catch(Exception e){
            System.debug('BAFCOLeadDetailsControllerTest.getLeadDetailsTest01 exception '+e);
        }
        test.stopTest();
    }
    testmethod static void getLeadDetailsTest02(){
        Id leadId = [Select id from Lead__c where Business_Type__c = 'Export' limit 1].Id;
        test.startTest();
        try{
            BAFCOLeadDetailsController.getLeadDetails(leadId);
        }
        Catch(Exception e){
            System.debug('BAFCOLeadDetailsControllerTest.getLeadDetailsTest02 exception '+e);
        }
        test.stopTest();
    }
    testmethod static void getLeadDetailsTest03(){
        Id accId = [Select id from Account  limit 1].Id;
        test.startTest();
        BAFCOLeadDetailsController.getLeadDetails(accId);
        test.stopTest();
    }
    testmethod static void getPortRecordsTest(){
        test.startTest();
        BAFCOLeadDetailsController.getPortRecords();
        test.stopTest();
    }
    testmethod static void getRMSRecordsTest01(){
        string loadingPort = '';
        string destinationPort = '';
        string validity = '';
        test.startTest();
        BAFCOLeadDetailsController.getRMSRecords(loadingPort,destinationPort,validity);
        validity = String.valueOf(System.today());
        BAFCOLeadDetailsController.getRMSRecords(loadingPort,destinationPort,validity);
        test.stopTest();
    }
    testmethod static void getRMSRecordsTest02(){
        string loadingPort = '';
        string destinationPort = '';
        Port__c portObj = [Select id from Port__c limit 1]; 
        loadingPort = portObj.id;
        string validity = '';
        test.startTest();
        BAFCOLeadDetailsController.getRMSRecords(loadingPort,destinationPort,validity);
        validity = String.valueOf(System.today());
        BAFCOLeadDetailsController.getRMSRecords(loadingPort,destinationPort,validity);
        test.stopTest();
    }
    testmethod static void getRMSRecordsTest03(){
        string loadingPort = '';
        string destinationPort = '';
        Port__c portObj = [Select id from Port__c limit 1]; 
        destinationPort = portObj.id;
        string validity = '';
        test.startTest();
        BAFCOLeadDetailsController.getRMSRecords(loadingPort,destinationPort,validity);
        validity = String.valueOf(System.today());
        BAFCOLeadDetailsController.getRMSRecords(loadingPort,destinationPort,validity);
        test.stopTest();
    }
    testmethod static void getRMSRecordsTest04(){        
        Port__c portObj = [Select id from Port__c limit 1]; 
        string loadingPort = portObj.id;
        string destinationPort = portObj.id;
        string validity = '';
        test.startTest();
        BAFCOLeadDetailsController.getRMSRecords(loadingPort,destinationPort,validity);
        validity = String.valueOf(System.today());
        BAFCOLeadDetailsController.getRMSRecords(loadingPort,destinationPort,validity);
        test.stopTest();
    }
    testmethod static void submitRMSTest(){
        Port__c portObj = [Select id from Port__c limit 1]; 
        Equipment_Type__c equip = [Select id from Equipment_Type__c limit 1]; 
        List<BAFCOLeadDetailsController.selectedEquip> selectedEquip = new List<BAFCOLeadDetailsController.selectedEquip>();
        BAFCOLeadDetailsController.selectedEquip obj1 = new BAFCOLeadDetailsController.selectedEquip();
        Equipment_Type__c equipmenent = [Select id from Equipment_Type__c limit 1];
        obj1.label = 'EquipName';
        obj1.value = equipmenent.id;
        obj1.seaFreight = 10;
        selectedEquip.add(obj1);
        BAFCORMSDto rmsDetail = new BAFCORMSDto();
        rmsDetail.validity= String.valueOf(system.today());
        rmsDetail.seaFreight= 100;
        rmsDetail.businessType= 'Export';
        rmsDetail.allInRate = false;
        rmsDetail.FOBAllIn = false;
        rmsDetail.ExWorksIn = false;
        rmsDetail.loadingPortId = portObj.id;
        rmsDetail.loadingDestinationId = portObj.id;
        rmsDetail.equipmentId = equip.id;
        rmsDetail.selectedEquip = selectedEquip;
        shippingLineChargesDTO shippingChargeDto = new shippingLineChargesDTO();
        BAFCOIncoChargesDto incocharges = new BAFCOIncoChargesDto();
        BAFCODestinationChargeDto destinCharges = new BAFCODestinationChargeDto();
        
        test.startTest();
        BAFCOLeadDetailsController.submitRMS(rmsDetail, shippingChargeDto, incocharges, false, false, false, destinCharges,selectedEquip);
        rmsDetail.businessType= 'Import';
        BAFCOLeadDetailsController.submitRMS(rmsDetail, shippingChargeDto, incocharges, false, false, false, destinCharges,selectedEquip);
        test.stopTest();
    }
    testMethod static void getMonthName(){
        test.startTest(); 
        BAFCOLeadDetailsController.getMonthName(1);
        BAFCOLeadDetailsController.getMonthName(2);
        BAFCOLeadDetailsController.getMonthName(3);
        BAFCOLeadDetailsController.getMonthName(4);
        BAFCOLeadDetailsController.getMonthName(5);
        BAFCOLeadDetailsController.getMonthName(6);
        BAFCOLeadDetailsController.getMonthName(7);
        BAFCOLeadDetailsController.getMonthName(8);
        BAFCOLeadDetailsController.getMonthName(9);
        BAFCOLeadDetailsController.getMonthName(10);
        BAFCOLeadDetailsController.getMonthName(11);
        BAFCOLeadDetailsController.getMonthName(12);
         BAFCOLeadDetailsController.getMonthName(null);
        test.stopTest();
    }
}