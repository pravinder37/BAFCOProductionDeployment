@isTest
public class BAFCOSalesOrderControllerTest {
    @TestSetup
    static void setup() { 
        Account acc = new Account();
        acc.name = 'test';
        acc.branch__c ='Jeddah';
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
        insert enq;
        
        Route__c route = new Route__c();
        route.Opportunity_Enquiry__c = opty.id;
        route.Port_of_Destination__c = port.id;
        route.Port_of_loading__c =port.id;
        route.Commodity__c = comd.id;
        insert route;
        
        Route_Equipment__c rEquip = new Route_Equipment__c();
        rEquip.Route__c = route.id;
        rEquip.Equipment_Type__c = equip.id;
        rEquip.Length__c = 1;
        rEquip.Width__c =1; 
        rEquip.Height__c = 1;
        rEquip.CBM__c = 1;
        rEquip.Weight_Kgs__c =1;
        Insert rEquip;
        
        
        RMS__c rmsObj = new RMS__c();
        rmsObj.Name ='Test';
        rmsObj.Port_Of_Discharge__c = port.Id;
        rmsObj.Port_Of_Loading__c = port.Id;
        rmsObj.Commodity__c =comd.Id;
        rmsObj.Shipping_Line__c = shipLine.id;
        rmsObj.Equipment_Type__c = equip.id;
        rmsObj.Validity__c = System.today().addDays(5);
        insert rmsObj;
        
        Regular_Routing__c regObj = new Regular_Routing__c();
        regObj.Port_of_Destination__c = port.Id;
        regObj.Port_Of_Loading__c = port.Id;
        regObj.Account__c = acc.id;
        insert regObj;
        
        integer year =  Date.Today().Year();
        string s1=string.valueof(year).right(2);
        Integer Year1= Integer.valueof(s1);
        Quotation__c quoteObj = new Quotation__c();
        quoteObj.Name__c= 'Quote/'+Year1+'/'+1;
        quoteObj.Opportunity__c = opty.id;
        quoteObj.Account__c = acc.id;
        quoteObj.Customer_Name__c = 'test';
        Insert quoteObj;
        Airport__c airObj = new Airport__c();
        airObj.Name ='tes';
        insert airObj;
        Quotation_Item__c quoteItem = new Quotation_Item__c();
        quoteItem.RMS__c = rmsObj.id;
        quoteItem.Route__c = route.id;
        quoteItem.Quotation__c = quoteObj.Id;
        quoteItem.Equipment_Type__c = equip.id;
        quoteItem.Sea_freight__c =12;
        quoteItem.currencyISOCode = 'USD';
        quoteItem.Tab_View__c = '1x1x1| CBM : 1 | Weight : 1';
        quoteItem.Airport_of_Destination__c = airObj.id;
        quoteItem.Airport_of_Loading__c = airObj.id;
        Insert quoteItem;
        
    }
    testmethod static void getRouteItemTest(){
        String quoteID = [Select id from Quotation__c limit 1].Id;
        test.startTest();
        BAFCOSalesOrderController.getRouteItem(quoteID);        
        test.stopTest();
    }
    testmethod static void getQuoteLineItemTest(){
        String quoteID = [Select id from Quotation__c limit 1].Id;
        String routeID = getRouteId();
        test.startTest();
        BAFCOSalesOrderController.getQuoteLineItem(quoteID,routeID);        
        test.stopTest();
    }
    testmethod static void getQuoteLineItemTest01(){
        Quotation__c quote = [Select id from Quotation__c limit 1];
        quote.isAir__c = true;
        update quote;
        String routeID = getRouteId();
        test.startTest();
        BAFCOSalesOrderController.getQuoteLineItem(quote.id,routeID);        
        test.stopTest();
    }
    testmethod static void createOrderTest(){
        test.startTest();
        String dd = String.valueOF(System.today());
        List<BAFCOOrderCreationDto> dtoList = getOrderCreationDto();
        system.debug('dtoList '+dtoList);
        String accountId = getAccountId();
        
        List<BAFCOSalesOrderController.consigneeList> consigneeList = new  List<BAFCOSalesOrderController.consigneeList>();
        BAFCOSalesOrderController.consigneeList obj = new BAFCOSalesOrderController.consigneeList();
        obj.consigneeId = accountId;
        obj.consigneeName = 'test';
        consigneeList.add(obj);
        
        List<BAFCOSalesOrderController.shipperList> shipperList = new List<BAFCOSalesOrderController.shipperList>();
        BAFCOSalesOrderController.shipperList obj2 = new BAFCOSalesOrderController.shipperList();
        obj2.shipperId = accountId;
        obj2.shipperName = 'test';
        shipperList.add(obj2);
        
        BAFCOSalesOrderController.createOrder(dtoList,dd,'test','test2','test',consigneeList,shipperList,null);
        List<Order__c> orderList = [Select id from Order__c];
        Order_item__c item = [Select id from Order_item__c limit 1];
        delete item;
        test.stopTest();
    }
    static List<BAFCOOrderCreationDto> getOrderCreationDto(){
        List<BAFCOOrderCreationDto.value> valueList = new List<BAFCOOrderCreationDto.value>();        
        BAFCOOrderCreationDto.value valueObj = new BAFCOOrderCreationDto.value();
        valueObj.accountId = getAccountId();
        valueObj.baf = 0;
        valueObj.bayan = 0;
        //valueObj.bayanCancellation = 0;
        valueObj.quotationId = getQuoteId();
        valueObj.shipName = 'COSCO';
        valueObj.sellingTotal = 1100;
        valueObj.addAdditionalCharge = false;
        valueObj.checkBoxSelected = true;
        valueObj.addServiceCharge  = false;
        valueObj.addOriginCharge  = false;
        valueObj.addDestinCharge  = false;
        valueObj.addAdditionalCharge  = false;
        valueObj.addExWorksCharge  = false;
        valueObj.includeServiceCharge  = false;
        valueObj.includeOriginCharge  = false;
        valueObj.includeDestinCharge  = false;
        valueObj.includeAdditionalCharge  = false;
        valueObj.includeExWorksCharge  = false;
        valueList.add(valueObj);
        
        List<BAFCOOrderCreationDto.equipment> equipList = new List<BAFCOOrderCreationDto.equipment>();
        BAFCOOrderCreationDto.equipment equipObj = new BAFCOOrderCreationDto.equipment();
        equipObj.key = '20FT HC';
        equipObj.value = valueList;
        equipList.add(equipObj);
        
        List<BAFCOOrderCreationDto> dtoList = new List<BAFCOOrderCreationDto>();
        BAFCOOrderCreationDto dtoObj = new BAFCOOrderCreationDto();
        dtoObj.routeName = 'Test';
        dtoObj.routeId = getRouteId();
        dtoObj.equipment = equipList;
        dtoList.add(dtoObj);
        return dtoList;
    } 
    static string getRouteId(){
        return [Select id from Route__c limit 1].Id;
    }
    static string getAccountId(){
        return [Select id from Account limit 1].Id;
    }
    static string getQuoteId(){
        return [Select id from Quotation__c limit 1].Id;
    }
}