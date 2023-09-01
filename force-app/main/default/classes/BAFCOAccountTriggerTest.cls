@isTest
private class BAFCOAccountTriggerTest {
    static testMethod void validateAccountBeforeInsert() {
        Account acc = new Account();
        acc.Name = 'TestAccount';
        
        
        Lead ld = new Lead();
        ld.LastName = 'Test Lead';
        ld.Company = 'TestAccount';
        ld.Status='New';
        
        Test.startTest();
        Insert ld;
        Insert acc;        
        Test.stopTest();
    }
}