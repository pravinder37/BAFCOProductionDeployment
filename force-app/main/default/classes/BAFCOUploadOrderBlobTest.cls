@isTest
public class BAFCOUploadOrderBlobTest {
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
        

    }
    testMethod static void getOrderBlob(){
        String orderId = [Select id From order__c limit 1].id;
        test.startTest();
        RestRequest request = new RestRequest();
        request.requestUri ='/services/apexrest/getOrderBlob/'+orderId;
        request.httpMethod = 'GET';
        RestContext.request = request;
        BAFCOUploadOrderBlob.getOrderBlob();
        test.stopTest();
    }
    testMethod Static void formDataMethodsCoverage(){
        Blob bb = Blob.valueOf('test');
        test.startTest();
        FormData.GetContentType();        
        FormData.writeFileBody('key',bb,'fileName');
        FormData.makeBlob('test');
        FormData.EndingType enum1 = FormData.EndingType.Cr;
        FormData.WriteBoundary(enum1);
        FormData.EndingType enum2 = FormData.EndingType.None;
        FormData.WriteBoundary(enum2);
        formData.WriteBoundary();
        FormData.WriteBodyParameter('key', 'value');
        FormData.append('key', 'value');
        FormData.makeBlobWithFile('key', bb, 'filename', 'otherParamsEncoded');
        test.stopTest();
            
    }
}