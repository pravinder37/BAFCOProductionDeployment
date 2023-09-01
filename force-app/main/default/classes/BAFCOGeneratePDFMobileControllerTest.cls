@isTest
public class BAFCOGeneratePDFMobileControllerTest {
    @TestSetup
    static void setup() {
        account acc = new Account();
        acc.Branch__c = 'Jeddah';
        acc.Average_Credit_Days__c = 2;
        acc.Average_Margin__c =2;
        acc.Best_Margin__c = 1;
        acc.name = 'test';
        insert acc;
        
        Contact con = new contact();
        con.FirstNAme = 'test';
        con.LastName = 'test';
        con.Email = 'test@email.com';
        con.MobilePhone = '0000000';
        con.AccountId = acc.id;
        insert con;
        
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
        
    }
	 @isTest static void testController(){
        Quotation__c quoteObj = [Select id from Quotation__c limit 1];
        PageReference testPage = Page.BAFCOQuotePDFMobile; 
   		Test.setCurrentPage(testPage);
        testPage.getParameters().put('recordId', quoteObj.id);
        ApexPages.StandardController sc = new  ApexPages.StandardController(quoteObj); 
        BAFCOGeneratePDFMobileController ob = new BAFCOGeneratePDFMobileController(sc);
        ob.savePdf();
    }
}