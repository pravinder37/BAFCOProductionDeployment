@isTest
public class BAFCOQuotationReviseControllerTest {
@TestSetup
    static void setup() { 
        Lead__c ld = new Lead__c();
        ld.Business_Type__c = 'Import';
        insert ld;
        
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
        
        Contact cont = new Contact();
        cont.AccountId = acc.id;
        cont.LastName = 'test';
        cont.MobilePhone = '0000000000';
        cont.Email = 'test@email.com';
        cont.Leadc__c = ld.Id;
        insert cont;
        
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
        
        Enquiry__c enq = new Enquiry__c();
        enq.Name = 'Test';
        enq.Lead__c = ld.id;
        insert enq;
        
        Route__c route = new Route__c();
        route.Opportunity_Enquiry__c = opty.id;
        route.Port_of_Destination__c = port.id;
        route.Port_of_loading__c =port.id;
        route.Commodity__c = comd.id;
        insert route;
        
        Route_Equipment__c rEquip = new Route_Equipment__c();
        rEquip.Route__c = route.id;
        Insert rEquip;
        
        Loading_Charge__c exWorks= new Loading_Charge__c();
        exWorks.Name  = 'tes';
        exWorks.Loading_Charge__c = 100;
        exWorks.Port_of_Loading__c = port.id;
        exWorks.Direction__c = 'One Way';
        exWorks.Pickup_Place__c = 'test';
        insert exWorks;
        
        
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
        INCO_Charge__c incharge = new INCO_Charge__c();
        incharge.RMS__c = rmsObj.Id;
        incharge.Origin_Loading_Charges__c = 10;
        incharge.Bayan__c = 10;
        //incharge.Destination_Customs_Clearance__c = 10;
        //incharge.Destination_Loading_Charges__c = 10;
        incharge.Xray__c = 10;
        incharge.Total__c = 10;
        incharge.Tabadul__c = 10;
        incharge.Port_Shuttling__c = 10;
        incharge.Origin_Customs_clearance__c = 10;
        incharge.Loading_Charges__c = 10;
        incharge.Lift_on_Lift_off__c = 10;
        incharge.Inspection__c = 10;
        incharge.Fasah_fee__c = 10;
        insert incharge;
        Shipping_Line_Charge__c scCharge = new Shipping_Line_Charge__c();
        scCharge.Total__c = 1;
        scCharge.RMS__c = rmsObj.Id;
        Insert scCharge;
        Destination_Charges__c DestiCharge = new Destination_Charges__c();
        DestiCharge.Total__c = 1;
        DestiCharge.RMS__c = rmsObj.Id;
        Insert DestiCharge;
        
        integer year =  Date.Today().Year();
        string s1=string.valueof(year).right(2);
        Integer Year1= Integer.valueof(s1);
        Quotation__c quoteObj = new Quotation__c();
        quoteObj.Name__c= 'Quote/'+Year1+'/'+1;
        quoteObj.Opportunity__c = opty.id;
        quoteObj.Leadc__c = ld.id;
        quoteObj.Account__c = acc.id;
        quoteObj.Customer_Name__c = 'test';
        Insert quoteObj;
        
        Quotation_Item__c quoteItem = new Quotation_Item__c();
        quoteItem.RMS__c = rmsObj.id;
        quoteItem.Route__c = route.id;
        quoteItem.Quotation__c = quoteObj.Id;
        quoteItem.Equipment_Type__c = equip.id;
        quoteItem.Origin_Loading_Charges__c = 10;
        quoteItem.Bayan__c = 10;
        quoteItem.Destination_Customs_Clearance__c = 10;
        quoteItem.Destination_Loading_Charges__c = 10;
        quoteItem.Xray__c = 10;
        quoteItem.Total__c = 10;
        quoteItem.Tabadul__c = 10;
        quoteItem.Port_Shuttling__c = 10;
        quoteItem.Origin_Customs_clearance__c = 10;
        quoteItem.Loading_Charges__c = 10;
        quoteItem.Lift_on_Lift_off__c = 10;
        quoteItem.Inspection__c = 10;
        quoteItem.Fasah_fee__c = 10;
        quoteItem.Total_SL__c = 100;      
        quoteItem.Bayan_cancellation_charge__c = 10;
        quoteItem.Cleaning_charges__c =10;
        //quoteItem.Container_Lashing_Charges__c = 10;        
        quoteItem.Container_movement_charges__c = 10;        
        quoteItem.Container_stripping__c = 10;        
        quoteItem.Free_time_certificate_charges__c = 10;        
        quoteItem.Fumigation__c = 10;        
        quoteItem.Insurance_charges__c = 10;        
        quoteItem.Ministry_clearnce_charge_for_OOG_cargo__c = 10;        
        quoteItem.Miscellaneous__c = 10;        
        quoteItem.MOT_fine_charges__c = 10;        
        quoteItem.Non_Palletized_Surcharge__c = 10;        
        quoteItem.Pest_control__c = 10;        
        quoteItem.Re_palletization__c = 10;
        quoteItem.Reefer_cntr_plug_in_charges__c = 10;        
        quoteItem.Reefer_PTI_charges__c = 10;        
        quoteItem.Reefer_steam_wash__c = 10;        
        quoteItem.Stuffing_Charges__c = 10;        
        quoteItem.SweepingCleaning__c = 10;        
        quoteItem.Truck_Head_charges__c = 10;        
        quoteItem.Truck_idling_charges__c = 10;        
        quoteItem.Vessel_certificate_charges__c = 10;        
        quoteItem.Wrappingpacking_charges__c = 10;
        quoteItem.Sea_Freight__c = 1;
        quoteItem.Freight_Difference_FD__c = 12;
        quoteItem.Carrier_container_repositioning_charges__c = 10;
        quoteItem.Alternate_depot_release_charges__c = 120;
        quoteItem.Ex_Works_Charge_Name__c = exWorks.id;
        quoteItem.Ex_Works_Charge__c =10;
        quoteItem.Total_Additional__c = 10;
        quoteItem.Total_Dest__c = 10;
        quoteItem.Total_INCO__c = 10;
        quoteItem.Total_SL__c = 10;
        Insert quoteItem;
        
    }
    static testmethod void getquoteDetailsTest(){
        string quoteId = getQuoteId();
        test.startTest();
        BAFCOQuotationReviseController.getquoteDetails(quoteId);
        test.stopTest();
    }
    static testmethod void getquoteListTest(){
        string quoteId = getQuoteId();
        test.startTest();
        BAFCOQuotationReviseController.getquoteList(quoteId);
        test.stopTest();
    }
    static testmethod void getQuoteLineItemRouteTest(){
        string quoteId = getQuoteId();
        test.startTest();
        BAFCOQuotationReviseController.getQuoteLineItemRoute(quoteId);
        test.stopTest();
    }
    static testmethod void getQuoteLineItemDetailsTest(){
        string quoteId = getQuoteId();
        string routeId = getrouteId();
        test.startTest();
        BAFCOQuotationReviseController.getQuoteLineItemDetails(quoteId,'PortName','PortName','Test',routeId);
        test.stopTest();
    }
    public static string getQuoteId(){
        return [Select id from Quotation__c limit 1].Id;
    }
    static string getrouteId(){
        return [Select id from Route__c limit 1].Id;
    }
}