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
        shipLine.Code__c = 'test';
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
        
        integer year =  Date.Today().Year();
        string s1=string.valueof(year).right(2);
        Integer Year1= Integer.valueof(s1);
        Quotation__c quoteObj = new Quotation__c();
        quoteObj.Name__c= 'Quote/'+Year1+'/'+1;
        quoteObj.opportunity__c = opty.id;
        quoteObj.Customer_Name__c = 'test';
        quoteObj.Account__c = acc.id;
        Insert quoteObj;
        
        Route__c route = new Route__c();
        route.Opportunity_Enquiry__c = opty.id;
        route.Port_of_Destination__c = portObj.id;
        route.Port_of_loading__c =portObj.id;
        route.Commodity__c = comd.id;
        insert route;
        
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
        for(Integer i = 1 ; i<=12 ; i++)
            BAFCOLeadDetailsController.getMonthName(i);
         BAFCOLeadDetailsController.getMonthName(null);
        test.stopTest();
    }
    testMethod static void getQuoteDetail(){
        BAFCOLeadDetailsController.getQuoteDetail([Select id from Quotation__c limit 1].id);
    }
    testMethod static void getRouteEquipmentDetailsTest(){
        BAFCOLeadDetailsController.getRouteEquipmentDetails([Select id from Route__c limit 1].id);
    }
    testMethod static void insertAccountDetails(){
        BAFCOLeadDetailsController.insertAccountDetails('accountName','contName','0000000','test@emial.com');
    }
}