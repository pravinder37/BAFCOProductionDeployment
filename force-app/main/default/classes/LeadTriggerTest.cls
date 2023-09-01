@isTest
public class LeadTriggerTest {
    @TestSetup
    static void setup() {
        Lead leadObj = new Lead();
        leadObj.Business_Type__c ='Export';
        leadObj.LastName = 'test';
        leadObj.Company = 'tet';
        Insert leadObj;
    }
    testmethod static void leadCoversion(){
        Lead leadObj = [Select id from lead limit 1];
        Database.LeadConvert lc = new database.LeadConvert();
        lc.setLeadId(leadObj.id);
        lc.setDoNotCreateOpportunity( true );  
		lc.setConvertedStatus( 'Qualified' );  
		Database.LeadConvertResult lcr = Database.convertLead(lc, false);  
        system.debug('lcr' +lcr);
		  
    }
}