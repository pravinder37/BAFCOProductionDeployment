@istest
public class BAFCOOrderItemTriggerHandlerTest {
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
        Date dt = System.today();
        Target__c targObj = new Target__c();
        targObj.Target_Month__c = dt;
        targObj.Target_Value_In_Teus__c = 3;
        targObj.Achieved_Value_In_Teus__c = 1;
        insert targObj;
        
        Port__c port2 = new Port__c();
        port2.City__c = 'Test1';
        port2.Name ='PortName1';
        port2.Sector__c = 'Africa';
        Insert port2;
        
        Regular_Routing__c regObj2 = new Regular_Routing__c();
        regObj2.Account__c=acc.id;
        regObj2.Port_of_Loading__c = port.id;
        regObj2.Port_of_Destination__c = port.id;
        insert regObj2;
        
        integer year =  Date.Today().Year();
        string s1=string.valueof(year).right(2);
        Integer Year1= Integer.valueof(s1);
        Quotation__c quoteObj = new Quotation__c();
        quoteObj.Name__c= 'Quote/'+Year1+'/'+1;
        quoteObj.Opportunity__c = opty.id;
        quoteObj.Account__c = acc.id;
        quoteObj.Customer_Name__c = 'test';
        Insert quoteObj;
        
        Order__c obj = new Order__c();
        obj.Account_Order__c = acc.id;
        obj.Quotation__c = quoteObj.id;
        insert obj;
        
    }
    
    testmethod static void testItemInsert(){
        BAFCOOrderItemTriggerHandler.dummyMethod();
        Order__c obj = [Select id from Order__c limit 1];
        Port__c port2 = [Select id from Port__c where Name ='PortName1' limit 1];                
        Order_item__c item2  = new Order_item__c();
        item2.Port_of_Discharge_Order__c = port2.id;
        item2.Port_of_Loading_Order__c =port2.id;
        item2.Order__c = obj.id;
        insert item2;
        delete item2;
    }
    testmethod static void testItemInsert2(){
        Order__c obj = [Select id from Order__c limit 1];
        Port__c port2 = [Select id from Port__c where Name <> 'PortName1' limit 1];                
        Order_item__c item2  = new Order_item__c();
        item2.Port_of_Discharge_Order__c = port2.id;
        item2.Port_of_Loading_Order__c =port2.id;
        item2.Order__c = obj.id;
        Port__c port = new Port__c();
        port.City__c = 'Test';
        port.Name ='PortName';
        port.Sector__c = 'Africa';
        Insert port;
        Order_item__c item3  = new Order_item__c();
        item3.Port_of_Discharge_Order__c = port.id;
        item3.Port_of_Loading_Order__c =port.id;
        item3.Order__c = obj.id;
        List<Order_item__c> itemList  = new List<Order_item__c>{item2,item3};
            insert itemList;
    }
    testMethod static void maintaineLookupChargesTest(){
        Order__c obj = [Select id from Order__c limit 1];
        Equipment_type__c equip = new Equipment_type__c();
        equip.BSLS_ID__c ='212';
        equip.Name ='121';
        equip.Teus__c = 1;
        insert equip;
        
        Order_item__c item  = new Order_item__c();
        item.Equipment_Type_Order__c = equip.id;
        item.Order__c = obj.id;
        item.BAF_Order__c =10;
        item.Bunker_surcharge_Order__c =10;
        item.Cleaning_charges_Order__c =10;
        item.CMC_Order__c =10;
        item.Carriage_Congestion_Surcharge__c =10;
        item.Carrier_Security_Fees__c =10;
        item.DG_Surcharge__c =10;
        item.DTHC_Order__c =10;
        item.EIC_Order__c =10;
        item.Inland_Fuel_Surcharge__c =10;
        item.Inland_Handling_Fees__c =10;
        item.Inland_haulage__c =10;
        item.ISPS_Order__c =10;
        item.Low_Sulphur_Surcharge__c =10;
        item.Operational_Recovery_Surcharge__c =10;
        item.OTHC_Order__c =10;
        item.Overweight_Overheight_surcharge__c =10;
        item.Seal_Charges_Order__c =10;
        item.War_Risk_Surcharge__c =10;
        item.Bayan_Order__c =10;
        item.BL_Fees__c =10;
        item.Origin_Customs_clearance_Order__c =10;
        item.Export_Service_Fees__c =10;
        item.Fasah_fee_Order__c =10;
        item.Inspection_Order__c =10;
        item.Insurance_charges_Order__c =10;
        item.Lift_on_Lift_off_Order__c =10;
        
        item.Origin_Loading_Charges_Order__c =10;
        item.Pickup_Charges__c =10;
        item.Reefer_cntr_plug_in_charges_Order__c =10;
        item.Tabadul_Order__c =10;
        item.Tarpauline_charge_Order__c =10;
        item.Truck_idling_charges_Order__c =10;
        item.VGM__c =10;
        item.Xray_Order__c =10;
        item.Lashing_Charges__c =10;
        item.Fuel_Surcharge__c =10;
        item.Bayan_Charges__c =10;
        item.Destination_Customs_Clearance_Order__c =10;
        item.DO_charges__c =10;
        item.Fasah_Charges__c =10;
        item.Gate_pass_charges__c =10;
        item.LOLO_Charges__c =10;
        item.Bayan_cancellation_charge_Order__c =10;
        item.Container_Lashing_Charges_Order__c =10;
        item.Container_movement_charges_Order__c =10;
        item.Free_time_certificate_charges_Order__c =10;
        item.Fumigation_Order__c =10;
        item.MCCFOOGC_Order__c =10;
        item.Miscellaneous_Order__c =10;
        item.MOT_fine_charges_Order__c =10;
        item.Non_Palletized_Surcharge_Order__c =10;
        item.Pest_control_Order__c =10;
        item.Re_palletization_Order__c =10;
        item.Reefer_PTI_charges_Order__c =10;
        item.Reefer_steam_wash_Order__c =10;
        item.Stuffing_Charges_Order__c =10;
        item.Vessel_certificate_charges_Order__c =10;
        item.Wrapping_packing_charges_Order__c =10;
        item.Alternate_depot_release_charges__c =10;
        item.Freight_Difference_FD__c =10;
        item.Carrier_container_repositioning_charges__c =10;
        item.Tank_Rental_Charges__c =10;
        item.Sweeping_Cleaning_Order__c  =10;
        item.Truck_Head_charges_Order__c =10;
        item.Container_stripping_Order__c = 10;
        item.Origin_Detention_Demurrage_Charges__c =10;
        item.Quantity__c =12;
        item.Total_Order__c = 12120;
        item.Buying_Rate__c =899;
       // item.Profit__c =100;//(Total_Order__c - Buying_Rate__c) * Teus__c
        //item.Teus__c =10;//Quantity__c * Equipment_Type_Order__r.Teus__c
        insert item;
        item.Origin_Detention_Demurrage_Charges__c =20;
        update item;
    }
}