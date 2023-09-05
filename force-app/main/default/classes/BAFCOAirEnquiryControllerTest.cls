@isTest
public class BAFCOAirEnquiryControllerTest {
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
        
        Airline__c obj = new Airline__c();
        obj.Name ='test';
        insert obj;
        
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
        
        Shipping_Line__c shipLine = new  Shipping_Line__c();
        shipLine.Name = 'ShipLine';
        shipLine.BSLS_ID__c = 'test';
        shipLine.Code__c = 'test';
        Insert shipLine;
        
        Equipment_Type__c equip = new Equipment_Type__c();
        equip.Name='EquipName';
        equip.BSLS_ID__c = 'test';
        Insert equip;
        
        Agent__c agentObj = new Agent__c();
        agentObj.Name ='tets';
        agentObj.Type__c = 'WACO';
        insert agentObj;
        
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
        
        Contact cont = new Contact();
        cont.AccountId = acc.id;
        cont.LastName = 'test';
        cont.MobilePhone = '0000000000';
        cont.Email = 'test@email.com';
        insert cont;
        
        AirPort__c airPort = new airPort__c();
        airPort.Name ='Airport';
        insert airPort;
        
        Enquiry__c enq = new Enquiry__c();
        enq.Name = 'Test';
        insert enq;
        
        Route__c route = new Route__c();
        route.Opportunity_Enquiry__c = opty.id;
        route.Port_of_Destination__c = port.id;
        route.Port_of_loading__c =port.id;
        route.Airport_of_Destination__c = airPort.id;
        route.Airport_of_Loading__c = airPort.id;
        route.Commodity__c = comd.id;
        route.Total_CBM__c = 10;
        route.Total_Gross_Weight_KGs__c =10;
        route.Total_Volumetric_Weight__c = 10;
        insert route;
        
        Route_Equipment__c rEquip = new Route_Equipment__c();
        rEquip.Route__c = route.id;
        rEquip.CBM__c = 100;
        rEquip.Weight_Kgs__c =100;
        rEquip.Units__c = 100;
        Insert rEquip;
        
        System.debug('Tab Vide : '+ [Select Tab_View__c from Route_Equipment__c]);
        
        Loading_Charge__c exWorks= new Loading_Charge__c();
        exWorks.Name  = 'tes';
        exWorks.Loading_Charge__c = 100;
        exWorks.Port_of_Loading__c = port.id;
        exWorks.Direction__c = 'One Way';
        exWorks.Pickup_Place__c ='test';
        insert exWorks;
        
        
        Id RMS_EXPORT_RECORDTYPE_Id = Schema.SObjectType.RMS__c.getRecordTypeInfosByName()
            .get('Export')
            .getRecordTypeId();
        
        RMS__c rmsObj = new RMS__c();
        rmsObj.Name ='Test';
        rmsObj.Port_Of_Discharge__c = port.Id;
        rmsObj.Port_Of_Loading__c = port.Id;
        rmsObj.Commodity__c =comd.Id;
        rmsObj.Shipping_Line__c = shipLine.id;
        rmsObj.Equipment_Type__c = equip.id;
        rmsObj.Validity__c = System.today().addDays(5);
        rmsObj.Sea_Freight__c = 1000;
        rmsObj.Airline__c = obj.id;
        rmsObj.Rate_Kg__c = 10;
        rmsObj.Agent__c =agentObj.id;
        rmsObj.Airport_of_Destination__c = airPort.id;
        rmsObj.Airport_of_Loading__c = airPort.id;
        rmsObj.RecordTypeId  = RMS_EXPORT_RECORDTYPE_Id;
        rmsObj.Route__c = route.id;
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
        quoteObj.Account__c = acc.id;
        quoteObj.Customer_Name__c = 'test';
        Insert quoteObj;
        
        Quotation_Item__c quoteItem = new Quotation_Item__c();
        quoteItem.RMS__c = rmsObj.id;
        quoteItem.Route__c = route.id;
        quoteItem.Quotation__c = quoteObj.Id;
        quoteItem.Equipment_Type__c = equip.id;
        quoteItem.Origin_Loading_Charges__c = 10;
        quoteItem.Tab_View__c = 'CBM : 100 | Weight : 100 | Units : 100';
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
        quoteItem.Airline__c = obj.id;
        quoteItem.Agent__c =agentObj.id;
        quoteItem.Tank_Rental_Charges__c = 10;
        quoteItem.Total_Ex_Works_Charges__c = 10;
        quoteItem.Buying_Rate__c= 10;
        quoteItem.Chargeable_Weight__c =10;
        Insert quoteItem;
        
    }
    testMethod static void submitRoutingListTest(){
        List<BAFCORoutingDetailsDto> bafcoList = new List<BAFCORoutingDetailsDto>();
        BAFCORoutingDetailsDto.containerRecord contRecord = new  BAFCORoutingDetailsDto.containerRecord();
        contRecord.stackable = true;
        contRecord.palletized = true;
        List<BAFCORoutingDetailsDto.containerRecord> contList = new List<BAFCORoutingDetailsDto.containerRecord>();
        contList.add(contRecord);
        BAFCORoutingDetailsDto dto = new BAFCORoutingDetailsDto();
        dto.dgClass = 'Class 1';
        dto.dangerousGoods = true;
        dto.leadIndex = '0';
        dto.containerRecord = contList;
        dto.isAir = true;
        bafcoList.add(dto);
        String closeDate = string.valueOf(system.today());
        String quoteId = [Select id from Account limit 1].Id;
        List<String> emptylist = new List<String>();
        try{
        String optyId = BAFCOAirEnquiryController.submitRoutingList(bafcoList, 'Export', quoteId, closeDate, '', '', emptylist, emptylist, '');
        String routeEquipId = [Select id from Route_Equipment__c limit 1].Id;
        List<String> routeToDelete = new List<String>();
        routeToDelete.add(routeEquipId);
        String containerEquipId = [Select id from Route__c limit 1].id;
        List<String> routeToDelete2 = new List<String>();
        routeToDelete2.add(containerEquipId);
        String optyId2 = BAFCOAirEnquiryController.submitRoutingList(bafcoList, 'Export', quoteId, closeDate, '', 'true', routeToDelete, routeToDelete2, optyId);
        }
        catch(exception e){}
        
    }
    testMethod static void submitRoutingListTest01(){
        List<BAFCORoutingDetailsDto> bafcoList = new List<BAFCORoutingDetailsDto>();
        BAFCORoutingDetailsDto.containerRecord contRecord = new  BAFCORoutingDetailsDto.containerRecord();
        contRecord.stackable = true;
        contRecord.palletized = true;
        List<BAFCORoutingDetailsDto.containerRecord> contList = new List<BAFCORoutingDetailsDto.containerRecord>();
        contList.add(contRecord);
        BAFCORoutingDetailsDto dto = new BAFCORoutingDetailsDto();
        dto.dgClass = 'Class 1';
        dto.dangerousGoods = true;
        dto.leadIndex = '0';
        dto.containerRecord = contList;
        bafcoList.add(dto);
        String closeDate = string.valueOf(system.today());
        String quoteId = [Select id from Account limit 1].Id;
        List<String> emptylist = new List<String>();
        try{
        String optyId = BAFCOAirEnquiryController.submitRoutingList(bafcoList, 'Export', quoteId, closeDate, '', '', emptylist, emptylist, '');
        String routeId= [Select id from Route__c limit 1].id;
        BAFCOAirEnquiryController.getRouteListOnload(routeId);
        }
        catch(exception e){}
    }
    static testmethod void getQuoteLineItemRouteTest(){
        string quoteId = [Select id from Quotation__c limit 1].id;
        test.startTest();
        BAFCOAirEnquiryController.getQuoteLineItemRoute(quoteId);
        test.stopTest();
    }
    static testmethod void getQuoteLineItemTest(){
        string quoteId = [Select id from Quotation__c limit 1].id;
        test.startTest();
        BAFCOAirEnquiryController.getQuoteLineItem(quoteId);
        test.stopTest();
    }
    static testmethod void getAirLineTest(){
        BAFCOAirEnquiryController.getAirLine();
    }
    static testmethod void addRatesAir(){
        String routeId = [Select id from Route__c limit 1].Id;
        BAFCORMSDto rmsDetail = new BAFCORMSDto();
        rmsDetail.validity = '2022-07-22';
        rmsDetail.allInRate = false;
        rmsDetail.FOBAllIn = false;
        rmsDetail.ExWorksIn = false;
        test.startTest();
        BAFCOAirEnquiryController.addRatesAir(rmsDetail, routeId, 'test', 10, null, 'USD', 'Export');
        test.stopTest();
    }
    static testmethod void getAirRouteEquipment(){
        String routeId = [Select id from Route__c limit 1].Id;
        test.startTest();
        BAFCOAirEnquiryController.getAirRouteEquipment(routeId);
        BAFCOAirEnquiryController.getRouteListAirImport(routeId);
        test.stopTest();
    }
    static testmethod void getQuoteLineItemDetails(){
        String routeId = [Select id from Route__c limit 1].Id;
        string quoteId = [Select id from Quotation__c limit 1].id;
        test.startTest();
        BAFCOAirEnquiryController.getQuoteLineItemDetails(quoteId,routeId);
        test.stopTest();
    }
    static testmethod void getRMSDetails(){
        String routeId = [Select id from Route__c limit 1].id;
        String optyId = [Select id from opportunity limit 1].id;
        test.startTest();
        BAFCOAirEnquiryController.getRMSDetails('Airport', 'Airport', 'commodity', routeId, optyId);
        test.stopTest();
    }
    static testmethod void genrateQuotation(){
        String routeId = [Select id from Route__c limit 1].id;
        String rmsId = [Select id from RMS__c limit 1].id;
        String optyId = [Select id from opportunity limit 1].id;
        String quotationId = [Select id from Quotation__c limit 1].Id;
        BAFCOGenerteQuoteDto dto1 = new BAFCOGenerteQuoteDto();
        dto1.isAir = true;
        dto1.seaFreightSellRate = 121;
        dto1.total = 121;
        dto1.chargeableWeight = 10;
        test.startTest();
        BAFCOAirEnquiryController.genrateQuotation(routeId, rmsId, optyId, quotationId, dto1, 'incoTerm', false, false, 'quoteRemarks', 10, 'test');
        test.stopTest();
    }
    /*static testmethod void genrateQuotation01(){
        String routeId = [Select id from Route__c limit 1].id;
        String rmsId = [Select id from RMS__c limit 1].id;
        String optyId = [Select id from opportunity limit 1].id;
        BAFCOGenerteQuoteDto dto1 = new BAFCOGenerteQuoteDto();
        dto1.isAir = true;
        dto1.seaFreightSellRate = 121;
        dto1.total = 121;
        test.startTest();
        BAFCOAirEnquiryController.genrateQuotation(routeId, rmsId, optyId, null, dto1, 'incoTerm', true, true, 'quoteRemarks', 10, 'test');
        test.stopTest();
    }*/
    static testmethod void getQuoteExportLineItemDetails(){
        String quotationId = [Select id from Quotation__c limit 1].Id;
        String routeId = [Select id from Route__c limit 1].id;
        test.startTest();
        BAFCOAirEnquiryController.getQuoteExportLineItemDetails(quotationId, 'Airport', 'Airport', 'commodity', routeId);
        test.stopTest();
    }
   static testmethod void getRouteListOnload(){
        test.startTest();
        String routeId = [Select id from Route__c limit 1].id;
        BAFCOAirEnquiryController.getRouteListOnload(routeId);        
        test.stopTest();
    }
    testMethod static void searchTest01(){
        String searchTerm='PortName';
        String myObject ='Account';
        String filter = 'test';
        test.startTest();
        try{
            BAFCOAirEnquiryController.search(searchTerm, myObject, null);
            BAFCOAirEnquiryController.search(null, myObject, null);
            BAFCOAirEnquiryController.search(searchTerm, myObject, filter);
        }
        catch(Exception e){}
        test.stopTest();
    }
}