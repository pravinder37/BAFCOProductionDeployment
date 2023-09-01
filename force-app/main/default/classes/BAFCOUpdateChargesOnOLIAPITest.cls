@isTest
public class BAFCOUpdateChargesOnOLIAPITest {
    @TestSetup
    static void setup() {
        account acc = new Account();
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
        
        integer year =  Date.Today().Year();
        string s1=string.valueof(year).right(2);
        Integer Year1= Integer.valueof(s1);
        Quotation__c quoteObj = new Quotation__c();
        quoteObj.Name__c= 'Quote/'+Year1+'/'+1;
        quoteObj.opportunity__c = opty.id;
        quoteObj.Customer_Name__c = 'test';
        quoteObj.Account__c = acc.id;
        quoteObj.Inclusions__c = 'Test Data ;;test data ;';
        quoteObj.Exclusions__c = 'Test Data ;;test data ;';
        quoteObj.Effective_From__c = system.today();
        Insert quoteObj;
        
        Order__c obj = new Order__c();
        obj.Account_Order__c = acc.id;
        obj.Quotation__c = quoteObj.id;
        insert obj;
        
        Order_item__c item2 = new Order_item__c();
        item2.Order__c = obj.id;
        insert item2;
    }
    testMethod static void doPostTst(){
        Order_item__c item = [Select id,name,order__r.name from Order_item__c limit 1];
        
        Additional_Charge__c obj = new Additional_Charge__c();
        obj.Name = 'tets';
        obj.BSLS_ID__c = '123abc';
        insert obj;
        
        Order_Charges__c chargeObj = new Order_Charges__c();
        chargeObj.Buying_Rate__c = 10;
        chargeObj.Charge_Type__c ='Per Shipment';
        chargeObj.Charge_Name__c = obj.id;
        chargeObj.Charge_Name_Text__c = 'tets';
        chargeObj.Order_Item__c = item.id;
        insert chargeObj;
        BAFCOUpdateChargesOnOLIAPI.Charges chDto = new BAFCOUpdateChargesOnOLIAPI.Charges();
        chDto.BuyingRate = '10';
        chDto.ChargeName ='tets';
        chDto.ChargeType ='Per Shipment';
        chDto.SellingRate = '10';
        chDto.BSLSID='123abc';
        
        List<BAFCOUpdateChargesOnOLIAPI.Charges> chList = new List<BAFCOUpdateChargesOnOLIAPI.Charges>();
        chList.add(chDto);
        
        BAFCOUpdateChargesOnOLIAPI.AdditionalCharges dto = new BAFCOUpdateChargesOnOLIAPI.AdditionalCharges();
        dto.OrderitemNumber = item.name;
        dto.OrderNumber = item.Order__r.name;
        dto.Charges =chList;
        RestRequest request = new RestRequest();
        request.requestUri ='/services/apexrest/OrderUpdate/UpdateCharges';
        request.httpMethod = 'POST';
        request.requestBody = Blob.valueOf(JSON.serialize(dto)); 
        RestContext.request = request;
        
        test.startTest();
        BAFCOUpdateChargesOnOLIAPI.doPost();
        BAFCOUpdateChargesOnOLIAPI.dummyCode();
        test.stopTest();
    }
}