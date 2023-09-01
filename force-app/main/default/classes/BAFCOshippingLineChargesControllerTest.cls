@isTest
public class BAFCOshippingLineChargesControllerTest {
	 @TestSetup
    static void setup() {
        Port__c port = new Port__c();
        port.City__c = 'Test';
        port.Sector__c='Africa';
        Insert port;
        Equipment_Type__c equip = new Equipment_Type__c();
        equip.Name='EquipName';
        equip.BSLS_ID__c = 'test';
        Insert equip;
        
        RMS__c rmsObj = new RMS__c();
        rmsObj.Name ='Test';
        rmsObj.Port_Of_Discharge__c = port.Id;
        rmsObj.Port_Of_Loading__c = port.Id;
        rmsObj.Equipment_Type__c = equip.id;
        insert rmsObj;
        
        Shipping_Line_Charge__c shipLine = new Shipping_Line_Charge__c();
        shipLine.BAF__c =12 ;
        shipLine.RMS__c = rmsObj.id;
        insert shipLine;
        Destination_Charges__c destiobj = new Destination_Charges__c();
        destiObj.Bayan_Charges__c = 1;
        destiObj.RMS__c = rmsObj.id;
        insert destiObj;
        INCO_Charge__c inco = new INCO_Charge__c();
        inco.Bayan__c = 12;
        inco.RMS__c  = rmsObj.id;
        insert inco;
    }
    testMethod static void getShippingChargesTest(){
        String rmsRecordId = [Select id from RMS__c limit 1].Id;
        test.startTest();
        try{
            BAFCOshippingLineChargesController.getRMSDetail(rmsRecordId);
            BAFCOshippingLineChargesController.getRMSDetail(null);
        }
        catch(Exception e){
            system.debug('getShippingChargesTest '+e);
        }
        test.stopTest();
    }
    testMethod static void getIncoChargesTest(){
        String rmsRecordId = [Select id from RMS__c limit 1].Id;
        test.startTest();
        try{
            BAFCOshippingLineChargesController.getIncoCharges(rmsRecordId);
        }
        catch(Exception e){
            system.debug('getIncoCharges '+e);
        }
        test.stopTest();
    }
    
}