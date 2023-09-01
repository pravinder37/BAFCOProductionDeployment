@isTest
public class BAFCOMeetingControllerTest {
	@TestSetup
    static void setup() {
       Account acc = new Account();
        acc.Branch__c = 'Jeddah';
        acc.Average_Credit_Days__c = 2;
        acc.Average_Margin__c =2;
        acc.Best_Margin__c = 1;
        acc.name = 'test';
        insert acc;
        
        Lead ld = new Lead();
        ld.Business_Type__c = 'Import';
        ld.Company ='test';
        ld.LastName='name';
        insert ld;
    }
    testMethod static void submitMeetingsRecords(){
        Account acc = [Select id from Account limit 1];
         Enquiry__c enq = new Enquiry__c();
        enq.Name = 'Test';
        enq.Account__c = acc.id;
        enq.Business_Type__c = 'Export';
        insert enq;
        String validityDate = String.valueOf(System.today());
        String timed  = String.valueof(System.now().format('HH:mm'));
        String visitFor = 'Issues';
        test.startTest();
        String eventId = BAFCOMeetingController.submitMeetingsRecords(acc.id, 'test', validityDate, timed, visitFor);
        BAFCOMeetingController.getIntakeMeetingObj(eventId);
        BAFCOMeetingController.getMeetingsRecords(validityDate);
        BAFCOMeetingController.updateEventObject(eventId, enq.id, validityDate, timed,  'test', '28.65', '77.4',null);
        test.stopTest();
    }
    testMethod static void searchTest01(){
        String searchTerm='test';
        String myObject ='Account';
        String filter = 'test';
        test.startTest();
        try{
            BAFCOMeetingController.search(searchTerm, myObject, null,false);
            BAFCOMeetingController.search(null, myObject, null,false);
            BAFCOMeetingController.search(searchTerm, myObject, filter,false);
        }
        catch(Exception e){}
        test.stopTest();
    }
    testMethod static void searchTest012(){
        String searchTerm='test ( name )';
        String myObject ='Lead';
        String filter = 'test';
        test.startTest();
        try{
            BAFCOMeetingController.search(searchTerm, myObject, null,true);
            BAFCOMeetingController.search(null, myObject, null,true);
            BAFCOMeetingController.search(searchTerm, myObject, filter,true);
        }
        catch(Exception e){}
        test.stopTest();
    }
    testMethod static void searchTest0123(){
        String searchTerm='test ( name )';
        String myObject ='Account';
        String filter = 'test';
        test.startTest();
        try{
            BAFCOMeetingController.accountSearch(searchTerm, myObject, null);
            BAFCOMeetingController.accountSearch(null, myObject, null);
            BAFCOMeetingController.accountSearch(searchTerm, myObject, filter);
        }
        catch(Exception e){}
        test.stopTest();
    }
}