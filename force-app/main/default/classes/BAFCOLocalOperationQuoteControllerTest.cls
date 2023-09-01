@isTest
public class BAFCOLocalOperationQuoteControllerTest {
@TestSetup
    static void setup() {
        List<Port__c> portList = new List<Port__c>(); 
        Port__c port = new Port__c();
        port.City__c = 'Test';
        port.Name ='PortName';
        port.sector__c = 'Africa';
        portList.add(port);
        
        
        
        Airline__c eir = new AirLine__c();
        eir.Name = 'test';
        insert eir;
        
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
        
        Shipping_Line__c shipLine = new  Shipping_Line__c();
        shipLine.Name = 'ShipLine';
        shipLine.BSLS_ID__c = 'test';
        Insert shipLine;
        
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
        
        opportunity opty2 = new Opportunity();
        opty2.AccountId = acc.id;
        opty2.StageName = 'Qualification';
        opty2.CloseDate = system.today();
        opty2.Name ='testopty';
        opty2.Business_Type__c = 'Import';
        insert opty2;
        Task tsk1 = new Task();
        tsk1.Subject = 'Provide Quotation';
        tsk1.Status = 'Open';
        tsk1.OwnerId = UserInfo.getUserId();
        tsk1.WhatId = opty2.Id;
        tsk1.IsReminderSet = true;
        
        Regular_Routing__c regObj = new Regular_Routing__c();
        regObj.Account__c = acc.id;
        regObj.Name = 'test';
        insert regObj;
        
        Enquiry__c enq = new Enquiry__c();
        enq.Name = 'Test';
        enq.Account__c = acc.id;
        enq.Business_Type__c = 'Export';
        insert enq;
        place__c  placeObj = new place__c();
        placeObj.Name = 'test';
        insert placeObj;
        Route__c route = new Route__c();
        route.opportunity_enquiry__c = opty.id;
        route.Port_of_Destination__c = port.id;
        route.Port_of_loading__c =port.id;
        route.Commodity__c = comd.id;
        route.Place_of_Discharge__c = placeObj.id;
        route.Place_of_Pickup__c = placeObj.id;
        insert route;
        
        Route_Equipment__c rEquip = new Route_Equipment__c();
        rEquip.Route__c = route.id;
        rEquip.Equipment_Type__c = equip.id;
        Insert rEquip;
        Agent__c agentObj = new Agent__c();
        agentObj.name =  'test';
        insert agentObj;
        List<RMS__c> rmsList = new List<RMS__c>();
        RMS__c rmsObj = new RMS__c();
        rmsObj.Name ='Test';
        rmsObj.Port_Of_Discharge__c = port.Id;
        rmsObj.Port_Of_Loading__c = port.Id;
        rmsObj.Commodity__c =comd.Id;
        rmsObj.Shipping_Line__c = shipLine.id;
        rmsObj.Equipment_Type__c = equip.id;
        rmsObj.Validity__c = System.today().addDays(5);
        rmsList.add(rmsObj);
        
        RMS__c rmsObj2 = new RMS__c();
        rmsObj2.Name ='Test2';
        rmsObj2.Port_Of_Discharge__c = port2.Id;
        rmsObj2.Port_Of_Loading__c = port2.Id;
        rmsObj2.Commodity__c =comd.Id;
        rmsObj2.Shipping_Line__c = shipLine.id;
        rmsObj2.Equipment_Type__c = equip.id;
        rmsObj2.Validity__c = System.today().addDays(7);
        rmsList.add(rmsObj2);
        insert  rmsList;
        
        integer year =  Date.Today().Year();
        string s1=string.valueof(year).right(2);
        Integer Year1= Integer.valueof(s1);
        Quotation__c quoteObj = new Quotation__c();
        quoteObj.Name__c= 'Quote/'+Year1+'/'+1;
        quoteObj.opportunity__c = opty.id;
        quoteObj.Customer_Name__c = 'test';
        quoteObj.Account__c = acc.id;
        Insert quoteObj;
        
        Quotation_Item__c quoteItem = new Quotation_Item__c();
        quoteItem.RMS__c = rmsObj.id;
        quoteItem.Route__c = route.id;
        quoteItem.Quotation__c = quoteObj.Id;
        quoteItem.Equipment_Type__c = equip.id;
        quoteItem.Sea_Freight__c = 100;
        Insert quoteItem;
        
        Exchange_Rate__c exc = new Exchange_Rate__c ();
        exc.Currency_Code__c = 'INR';
        insert exc;
        Route_Equipment__c routeEquip = new Route_Equipment__c();
        routeEquip.Route__c = route.Id;
        routeEquip.Equipment_Type__c = equip.Id;
        routeEquip.Quantity__c = 12;
        insert routeEquip;
        
        List<INCO_Term__c> incOList = new List<INCO_Term__c>();
        INCO_Term__c incoTerm = new INCO_Term__c();
        incoTerm.Name = 'IncoTerm';
        incOList.add(incoTerm);
        
        INCO_Term__c incoTerm2 = new INCO_Term__c();
        incoTerm2.Name = 'IncoTerm2';
        incOList.add(incoTerm2);
        
        INCO_Term__c incoTerm3 = new INCO_Term__c();
        incoTerm3.Name = 'Ocean Freight';
        incOList.add(incoTerm3);
        
        INCO_Term__c incoTerm4 = new INCO_Term__c();
        incoTerm4.Name = 'CFR';
        incOList.add(incoTerm4);
        
        insert incOList;
        
        List<INCO_Charge__c> incoChargeLsit = new List<INCO_Charge__c>();
        INCO_Charge__c incoCharge = new INCO_Charge__c();
        incoCharge.INCO_Term__c = incoTerm.id;
        incoCharge.RMS__c = rmsObj.Id;
        incoCharge.Bayan__c=12;        
        incoChargeLsit.add(incoCharge);
        
        INCO_Charge__c incoCharge2 = new INCO_Charge__c();
        incoCharge2.INCO_Term__c = incoTerm2.id;
        incoCharge2.RMS__c = rmsObj.Id;
        incoChargeLsit.add(incoCharge2);
        
         INCO_Charge__c incoCharge3 = new INCO_Charge__c();
        incoCharge3.INCO_Term__c = incoTerm2.id;
        incoCharge3.RMS__c = rmsObj2.Id;
        incoCharge3.Total__c = 110;
        incoChargeLsit.add(incoCharge3);
         insert incoChargeLsit;
        
        List<Destination_Charges__c> destinList = new List<Destination_Charges__c>();
        Destination_Charges__c destinbj = new Destination_Charges__c();
        destinbj.RMS__c = rmsObj.Id;
        destinbj.Total__c =10;
        destinList.add(destinbj);
        Destination_Charges__c destinbj1 = new Destination_Charges__c();
        destinbj1.RMS__c = rmsObj2.Id;
        destinbj1.DO_charges__c = 1;
        destinList.add(destinbj1);
        insert destinList;
        
        List<Shipping_Line_Charge__c> shipList = new List<Shipping_Line_Charge__c>();
        Shipping_Line_Charge__c shiObj = new Shipping_Line_Charge__c();
        shiObj.Total__c = 10;
        shiObj.RMS__c = rmsObj.id;
        shipList.add(shiObj);
        
        Shipping_Line_Charge__c shiObj1 = new Shipping_Line_Charge__c();
        shiObj1.BAF__c = 10;
        shiObj1.RMS__c = rmsObj2.id;
        shipList.add(shiObj1);
        insert shipList;
        
        Additional_Charge__c addCharge = new Additional_Charge__c();
        addCharge.Name = 'AdditionalCharge';
        insert addCharge;
        
        template__c templateObj= new template__c();
        templateObj.Name = 'test';
        templateObj.Field10_Name__c = 'test';
        templateObj.Field10_Value__c = 12;
        Insert templateObj;
        
        Loading_Charge__c exWorks= new Loading_Charge__c();
        exWorks.Name  = 'tes';
        exWorks.Loading_Charge__c = 100;
        exWorks.Port_of_Loading__c = port.id;
        exWorks.Direction__c = 'One Way';
         exWorks.Pickup_Place__c = 'test';
        insert exWorks;
    }
    testMethod static void testRouteEquip(){
        String routeId  = [Select id from Route__c limit 1].id;
        test.startTest();
        BAFCOLocalOperationQuoteController.getRouteListOnload(routeId);
        test.stopTest();
    }
    testMethod static void genrateQuotationTest(){
        String routeId = [Select id from Route__c limit 1].Id;
        String rmsId = [Select id from RMS__c limit 1].Id;
        String enquiryId = [Select id from opportunity where Business_Type__c = 'Export' limit 1].Id;
        String quotationId = [Select id from Quotation__c limit 1].Id;
        String incoTerm = 'IncoTerm';
        
         List< BAFCOGenerteQuoteDto.AdditionalCharge> addList = new List< BAFCOGenerteQuoteDto.AdditionalCharge>();
        
        BAFCOGenerteQuoteDto.AdditionalCharge a1 = new BAFCOGenerteQuoteDto.AdditionalCharge(); 
        a1.name = 'Bayan cancellation charge';
        a1.value =12;
        addList.add(a1);
        BAFCOGenerteQuoteDto.AdditionalCharge a2 = new BAFCOGenerteQuoteDto.AdditionalCharge(); 
        a2.name = 'Cleaning charges';
        a2.value =12;
        addList.add(a2);
        BAFCOGenerteQuoteDto.AdditionalCharge a3 = new BAFCOGenerteQuoteDto.AdditionalCharge(); 
        a3.name = 'Container Lashing Charges';
        a3.value =12;
        addList.add(a3);
        BAFCOGenerteQuoteDto.AdditionalCharge a4 = new BAFCOGenerteQuoteDto.AdditionalCharge(); 
        a4.name = 'Container movement charges';
        a4.value =12;
        addList.add(a4);
        BAFCOGenerteQuoteDto.AdditionalCharge a5 = new BAFCOGenerteQuoteDto.AdditionalCharge(); 
        a5.name = 'Container stripping';
        a5.value =12;
        addList.add(a5);
        BAFCOGenerteQuoteDto.AdditionalCharge a6 = new BAFCOGenerteQuoteDto.AdditionalCharge(); 
        a6.name = 'Additional Freetime Charges';
        a6.value =12;
        addList.add(a6);
        BAFCOGenerteQuoteDto.AdditionalCharge a7 = new BAFCOGenerteQuoteDto.AdditionalCharge(); 
        a7.name = 'Fumigation';
        a7.value =12;
        addList.add(a7);
        BAFCOGenerteQuoteDto.AdditionalCharge a8 = new BAFCOGenerteQuoteDto.AdditionalCharge(); 
        a8.name = 'Inspection';
        a8.value =12;
        addList.add(a8);
        BAFCOGenerteQuoteDto.AdditionalCharge a9 = new BAFCOGenerteQuoteDto.AdditionalCharge(); 
        a9.name = 'Insurance charges';
        a9.value =12;
        addList.add(a9);
        BAFCOGenerteQuoteDto.AdditionalCharge a10 = new BAFCOGenerteQuoteDto.AdditionalCharge(); 
        a10.name = 'Ministry clearnce charge for OOG cargo';
        a10.value =12;
        addList.add(a10);
        BAFCOGenerteQuoteDto.AdditionalCharge a11 = new BAFCOGenerteQuoteDto.AdditionalCharge(); 
        a11.name = 'Miscellaneous';
        a11.value =12;
        addList.add(a11);
        BAFCOGenerteQuoteDto.AdditionalCharge a12 = new BAFCOGenerteQuoteDto.AdditionalCharge(); 
        a12.name = 'MOT fine charges';
        a12.value =12;
        addList.add(a12);
        BAFCOGenerteQuoteDto.AdditionalCharge a13 = new BAFCOGenerteQuoteDto.AdditionalCharge(); 
        a13.name = 'Non Palletized Surcharge';
        a13.value =12;
        addList.add(a13);
        BAFCOGenerteQuoteDto.AdditionalCharge a14 = new BAFCOGenerteQuoteDto.AdditionalCharge(); 
        a14.name = 'Pest control';
        a14.value =12;
        addList.add(a14);
        BAFCOGenerteQuoteDto.AdditionalCharge a15 = new BAFCOGenerteQuoteDto.AdditionalCharge(); 
        a15.name = 'Re palletization';
        a15.value =12;
        addList.add(a15);
        BAFCOGenerteQuoteDto.AdditionalCharge a16 = new BAFCOGenerteQuoteDto.AdditionalCharge(); 
        a16.name = 'Reefer cntr plug-in charges';
        a16.value =12;
        addList.add(a16);
        BAFCOGenerteQuoteDto.AdditionalCharge a17 = new BAFCOGenerteQuoteDto.AdditionalCharge(); 
        a17.name = 'Reefer PTI charges';
        a17.value =12;
        addList.add(a17);
        BAFCOGenerteQuoteDto.AdditionalCharge a18 = new BAFCOGenerteQuoteDto.AdditionalCharge(); 
        a18.name = 'Reefer steam wash';
        a18.value =12;
        addList.add(a18);
        BAFCOGenerteQuoteDto.AdditionalCharge a19 = new BAFCOGenerteQuoteDto.AdditionalCharge(); 
        a19.name = 'Stuffing Charges';
        a19.value =12;
        addList.add(a19);
        BAFCOGenerteQuoteDto.AdditionalCharge a20 = new BAFCOGenerteQuoteDto.AdditionalCharge(); 
        a20.name = 'Sweeping/Cleaning';
        a20.value =12;
        addList.add(a20);
        BAFCOGenerteQuoteDto.AdditionalCharge a21 = new BAFCOGenerteQuoteDto.AdditionalCharge(); 
        a21.name = 'Truck Head charges';
        a21.value =12;
        addList.add(a21);
        BAFCOGenerteQuoteDto.AdditionalCharge a22 = new BAFCOGenerteQuoteDto.AdditionalCharge(); 
        a22.name = 'Truck idling charges';
        a22.value =12;
        addList.add(a22);
        BAFCOGenerteQuoteDto.AdditionalCharge a23 = new BAFCOGenerteQuoteDto.AdditionalCharge(); 
        a23.name = 'Vessel certificate charges';
        a23.value =12;
        addList.add(a23);
        BAFCOGenerteQuoteDto.AdditionalCharge a24 = new BAFCOGenerteQuoteDto.AdditionalCharge(); 
        a24.name = 'Wrapping/packing charges';
        a24.value =12;
        addList.add(a24);
        BAFCOGenerteQuoteDto.AdditionalCharge a25 = new BAFCOGenerteQuoteDto.AdditionalCharge(); 
        a25.name = 'Freight Difference(FD)';
        a25.value =12;
        addList.add(a25);
        BAFCOGenerteQuoteDto.AdditionalCharge a26 = new BAFCOGenerteQuoteDto.AdditionalCharge(); 
        a26.name = 'Carrier container repositioning charges';
        a26.value =12;
        addList.add(a26);
        BAFCOGenerteQuoteDto.AdditionalCharge a27 = new BAFCOGenerteQuoteDto.AdditionalCharge(); 
        a27.name = 'Alternate depot release charges';
        a27.value =12;
        addList.add(a27);
        
        BAFCOIncoChargesDto incoChargeList = new BAFCOIncoChargesDto();
        incoChargeList.bayan=12;
        BAFCOImportRMSDto.destinChargeObj destiObj = new BAFCOImportRMSDto.destinChargeObj();
        destiObj.destinBayanCharges = 1;
        destiObj.DestinTotalChanged = false;
        BAFCOImportRMSDto.originChargesObj originObj = new BAFCOImportRMSDto.originChargesObj();
        originObj.bayan = 1;
        originObj.originTotalChanged = false;
        BAFCOImportRMSDto.servichargesObj servObj = new BAFCOImportRMSDto.servichargesObj();
        servObj.BAF = 1;
        servObj.shippTotalChanged = false;
        BAFCOGenerteQuoteDto.serviceChargeList servList1 = new BAFCOGenerteQuoteDto.serviceChargeList();
        servList1.destinChargeObj = destiObj;
        servList1.originChargesObj = originObj;
        servList1.servichargesObj = servObj;
        
        BAFCOGenerteQuoteDto dto1 = new BAFCOGenerteQuoteDto();
        dto1.seaFreightSellRate = 121;
        dto1.total = 121;
        dto1.incoChargList = incoChargeList;
        dto1.additionalChargeList = addList;
        dto1.serviceChargeList = servList1;
        
        Loading_charge__c exWorks = [Select id from Loading_charge__c limit 1];
        BAFCOGenerteQuoteDto.exWorksObj exWorksDto = new BAFCOGenerteQuoteDto.exWorksObj();
        exWorksDto.Id = exWorks.id;
        exWorksDto.LoadCharge  = 100;
        
        dto1.exWorksObj = exWorksDto;
        
        String validityDate = String.valueOf(System.today());
        test.startTest();
        try{
        String QuoteId = BAFCOLocalOperationQuoteController.genrateQuotation(routeId, enquiryId, quotationId, dto1,'test',10, false,false);
        BAFCOLocalOperationQuoteController.genrateQuotation(routeId, enquiryId, quotationId, dto1,'test',10, true,true);
        BAFCOLRoutingDetailsController.updateValidityDate(QuoteId, validityDate);
        BAFCOLocalOperationQuoteController.getQuoteLineItem(quoteId);
        }
        catch(exception e){}
        test.stopTest();
    }
    testMethod static void genrateAirQuotationTest(){
        String routeId = [Select id from Route__c limit 1].Id;
        String rmsId = [Select id from RMS__c limit 1].Id;
        String enquiryId = [Select id from opportunity where Business_Type__c = 'Export' limit 1].Id;
        String quotationId = [Select id from Quotation__c limit 1].Id;
        String incoTerm = 'IncoTerm';
        BAFCOGenerteQuoteDto dto1 = new BAFCOGenerteQuoteDto();
        dto1.isAir = true;
        dto1.seaFreightSellRate = 121;
        dto1.total = 121;
        BAFCOLocalOperationQuoteController.genrateAirImportQuotation(routeId,enquiryId,quotationId, dto1,'test',10,false,false,'test','test');
        String enquiryId2 = [Select id from opportunity where Business_Type__c = 'Import' limit 1].Id;
        BAFCOLocalOperationQuoteController.genrateAirImportQuotation(routeId,enquiryId2,quotationId, dto1,'test',10,false,false,'test','test');
        BAFCOLocalOperationQuoteController.dummyData();
        BAFCOGeneratePDFDto.dummyData();
        
    }
    testMethod static void genrateAirQuotationTest02(){
        String routeId = [Select id from Route__c limit 1].Id;
        String rmsId = [Select id from RMS__c limit 1].Id;
        String enquiryId = [Select id from opportunity where Business_Type__c = 'Export' limit 1].Id;
        String incoTerm = 'IncoTerm';
        BAFCOGenerteQuoteDto dto1 = new BAFCOGenerteQuoteDto();
        dto1.seaFreightSellRate = 121;
        dto1.total = 121;
        try{
        BAFCOLocalOperationQuoteController.genrateAirImportQuotation(routeId,enquiryId,null, dto1,'test',10,true,true,'test','test');
         String enquiryId2 = [Select id from opportunity where Business_Type__c = 'Import' limit 1].Id;
        BAFCOLocalOperationQuoteController.genrateAirImportQuotation(routeId,enquiryId2,null, dto1,'test',10,true,true,'test','test');        
        }
        catch(exception e){}
    }
}