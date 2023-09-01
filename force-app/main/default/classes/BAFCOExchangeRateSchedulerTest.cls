@isTest
public class BAFCOExchangeRateSchedulerTest {
	public static testMethod void testschedule() {
        Exchange_Rate__c exObj = new Exchange_Rate__c();
        exObj.Currency_Code__c = 'INR';
        exObj.Name = 'Indian Rupees';
        Insert exObj;
		Test.StartTest();
        Test.setMock(HttpCalloutMock.class, new BAFCOExchangeRateMockTest());
		BAFCOExchangeRateScheduler testsche = new BAFCOExchangeRateScheduler();
		String sch = '0 0 23 * * ?';
		system.schedule('Test status Check', sch, testsche );
		Test.stopTest();
	}
    public static testmethod void excpetionCase(){
        Exchange_Rate__c exObj = new Exchange_Rate__c();
        exObj.Currency_Code__c = 'INR';
        exObj.Name = 'Indian Rupees';
        Insert exObj;
        Test.StartTest();
        Test.setMock(HttpCalloutMock.class, new BAFCOExchangeRateMockTest());
		BAFCOExchangeRateScheduler testsche = new BAFCOExchangeRateScheduler();
		String sch = '0 0 23 * * ?';
        try{
		system.schedule('Test status Check', sch, testsche );
        }
        catch(exception e){}
		Test.stopTest();
    }
}