public class BAFCOLeadDetailsController {
    @AuraEnabled
    public static BAFCOLeadDetailsDto getLeadDetails(String leadId) {
        system.debug('leadId '+leadId);
        BAFCOLeadDetailsDto leadDetailsDto = new BAFCOLeadDetailsDto();
        List<Account> accList = [Select id,Name,owner.name,CreatedDate,Business_Type__c,Modes__c From Account Where id =: leadId limit 1];
        List<contact> contactList = [Select Name,MobilePhone,Email from Contact where AccountId =: leadId order by createddate limit 1];
        if(accList.size() > 0){
            leadDetailsDto =  executeMapForAccountDetails(accList,contactList);
        }
        system.debug('leadDetailsDto '+leadDetailsDto);
        return leadDetailsDto;
    }
    public static BAFCOLeadDetailsDto executeMapForAccountDetails(List<Account> accList, List<Contact> contactList){
        BAFCOLeadDetailsDto leadDetailsDto = new BAFCOLeadDetailsDto();
        for(Account leadObj : accList){
            leadDetailsDto.leadName = leadObj.Name != null  ? leadObj.Name : '-';
            leadDetailsDto.owner = leadObj.Owner.Name != null ? leadObj.Owner.Name : '-';
            leadDetailsDto.createdDate =  leadObj.CreatedDate.format('dd-MMM-YYYY');
            
            leadDetailsDto.leadId = leadObj.Id;
            leadDetailsDto.businessType = leadObj.Business_Type__c != null ? leadObj.Business_Type__c : '';
            leadDetailsDto.modes = leadObj.Modes__c !=null ? leadObj.Modes__c : '-';
            if(contactList.size() > 0 ){
                leadDetailsDto.contactMobile = contactList[0].MobilePhone != null ? contactList[0].MobilePhone : '-';
                leadDetailsDto.contactEmail = contactList[0].Email != null ? contactList[0].Email : '-';
                leadDetailsDto.contactName = contactList[0].Name;
            }
            else{
                leadDetailsDto.contactMobile = '-';
                leadDetailsDto.contactEmail = '-';
            }
        }
        return leadDetailsDto;
    }
    @AuraEnabled(cacheable=true)
    public static List<Port__c> getPortRecords() {
        List<Port__c> portList = new List<Port__c>();
        portList = [Select id, Name from Port__c order by Name];
        return portList;
    }
    @AuraEnabled(cacheable=true)
    public static List<BAFCORMSDto> getRMSRecords(String loadingPort, String destinationPort, String validity){
        if(validity == null) validity ='';
        if(loadingPort == null ) loadingPort ='';
        if(destinationPort == null ) destinationPort ='';
        List<RMS__c> rmsList = new List<RMS__c>();
        List<BAFCORMSDto> rmsDtolist = new List<BAFCORMSDto>();
        String query = '';
        String todaysDate = String.valueOf(Date.today());
        string splittedString = todaysDate.split(' ')[0];
        Date todaysDate2 = system.today();
        Integer currentMonth = todaysDate2.month();
        Date tempStartDate = Date.newInstance(todaysDate2.year(), currentMonth, 1);
        integer noOfDays = Date.daysInMonth(todaysDate2.year(), currentMonth);        
        Date tempEndDate = Date.newInstance( todaysDate2.year(), currentMonth, noOfDays);
        String startDate = String.valueOf(todaysDate2);
        String endDate = String.valueOf(tempEndDate);
        if(loadingPort != '' && destinationPort == ''){
            if(validity == ''){
                query = 'Select Id,Rate_Type__c, Commodity__r.Name, Business_Type__c,Port_Of_Discharge__r.Name,Port_Of_Loading__r.Name,';
                query+='Port_Of_Discharge__c,Port_Of_Loading__c, Equipment_Type__r.Name, Sea_Freight__c, Validity__c,';
                query+='Agent__r.Name, Shipping_Line__r.Name,LastModifiedBy.Name, Name from RMS__c Where Validity__c <= '+endDate;
                query+=' AND Validity__c >= '+startDate;
                query+=' AND Port_Of_Loading__r.Name = \''+loadingPort+'\'';
                query+=' AND Customer_Name__c = null';
            }
            else if(validity != ''){
                query = 'Select Id,Rate_Type__c, Commodity__r.Name, Business_Type__c,Port_Of_Discharge__r.Name,Port_Of_Loading__r.Name,';
                query+='Port_Of_Discharge__c,Port_Of_Loading__c, Equipment_Type__r.Name, Sea_Freight__c, Validity__c,';
                query+='Agent__r.Name, Shipping_Line__r.Name,LastModifiedBy.Name, Name from RMS__c Where Validity__c >= '+todaysDate;
                query+=' AND Validity__c < = '+validity;
                query+=' AND Port_Of_Loading__r.Name = \''+loadingPort+'\'';
                query+=' AND Customer_Name__c = null';
            }
        }
        else if(loadingPort == '' && destinationPort != ''){
            if(validity == ''){
                query = 'Select Id,Rate_Type__c, Commodity__r.Name, Business_Type__c,Port_Of_Discharge__r.Name,Port_Of_Loading__r.Name,';
                query+='Port_Of_Discharge__c,Port_Of_Loading__c, Equipment_Type__r.Name, Sea_Freight__c, Validity__c,';
                query+='Agent__r.Name, Shipping_Line__r.Name,LastModifiedBy.Name, Name from RMS__c Where Validity__c <= '+endDate;
                query+=' AND Validity__c >= '+startDate;
                query+=' AND Port_Of_Discharge__r.Name = \''+destinationPort+'\'';
                query+=' AND Customer_Name__c = null';
            }
            else if(validity != ''){
                query = 'Select Id,Rate_Type__c, Commodity__r.Name, Business_Type__c,Port_Of_Discharge__r.Name,Port_Of_Loading__r.Name,';
                query+='Port_Of_Discharge__c,Port_Of_Loading__c, Equipment_Type__r.Name, Sea_Freight__c, Validity__c,';
                query+='Agent__r.Name, Shipping_Line__r.Name,LastModifiedBy.Name, Name from RMS__c Where Validity__c >= '+todaysDate;
                query+=' AND Validity__c < = '+validity;
                query+=' AND Port_Of_Discharge__r.Name = \''+destinationPort+'\'';     
                query+=' AND Customer_Name__c = null';
            }
        }
        else if(loadingPort != '' && destinationPort != ''){
            if(validity == ''){
                query = 'Select Id,Rate_Type__c, Commodity__r.Name, Business_Type__c,Port_Of_Discharge__r.Name,Port_Of_Loading__r.Name,';
                query+='Port_Of_Discharge__c,Port_Of_Loading__c, Equipment_Type__r.Name, Sea_Freight__c, Validity__c,';
                query+='Agent__r.Name, Shipping_Line__r.Name,LastModifiedBy.Name, Name from RMS__c Where Validity__c <= '+endDate;
                query+=' AND Validity__c >= '+startDate;
                query+=' AND Port_Of_Discharge__r.Name = \''+destinationPort+'\'';
                query+=' AND Port_Of_Loading__r.Name = \''+loadingPort+'\'';
                query+=' AND Customer_Name__c = null';
            }
            else if(validity != ''){
                query = 'Select Id,Rate_Type__c, Commodity__r.Name, Business_Type__c,Port_Of_Discharge__r.Name,Port_Of_Loading__r.Name,';
                query+='Port_Of_Discharge__c,Port_Of_Loading__c, Equipment_Type__r.Name, Sea_Freight__c, Validity__c,';
                query+='Agent__r.Name, Shipping_Line__r.Name,LastModifiedBy.Name, Name from RMS__c Where Validity__c >= '+todaysDate;
                query+=' AND Validity__c <= '+validity;
                query+=' AND Port_Of_Discharge__r.Name = \''+destinationPort+'\'';
                query+=' AND Port_Of_Loading__r.Name = \''+loadingPort+'\'';
                query+=' AND Customer_Name__c = null';
            }
        }
        else if(loadingPort == '' && destinationPort == ''){
            if(validity == ''){
                query = 'Select Id,Rate_Type__c, Commodity__r.Name, Business_Type__c,Port_Of_Discharge__r.Name,Port_Of_Loading__r.Name,';
                query+='Port_Of_Discharge__c,Port_Of_Loading__c, Equipment_Type__r.Name, Sea_Freight__c, Validity__c,';
                query+='Agent__r.Name, Shipping_Line__r.Name,LastModifiedBy.Name, Name from RMS__c Where Validity__c <= '+endDate;
                query+=' AND Validity__c >= '+startDate;
                query+=' AND Customer_Name__c = null';
            }
            else if(validity != ''){
                query = 'Select Id,Rate_Type__c, Commodity__r.Name, Business_Type__c,Port_Of_Discharge__r.Name,Port_Of_Loading__r.Name,';
                query+='Port_Of_Discharge__c,Port_Of_Loading__c, Equipment_Type__r.Name, Sea_Freight__c, Validity__c,';
                query+='Agent__r.Name, Shipping_Line__r.Name,LastModifiedBy.Name, Name from RMS__c Where Validity__c >= '+todaysDate;
                query+=' AND Validity__c < = '+validity;    
                query+=' AND Customer_Name__c = null';
            }
        }
        system.debug(query);
        rmsList=Database.query(query);
        /* rmsList = [Select Id, Commodity__r.Name, Business_Type__c,Port_Of_Discharge__r.Name,Port_Of_Loading__r.Name,
Port_Of_Discharge__c,Port_Of_Loading__c, 
Equipment_Type__r.Name, Sea_Freight__c, Validity__c, Agent__r.Name, Shipping_Line__r.Name,LastModifiedBy.Name, Name from RMS__c];*/
        if(rmsList.size()>0){
            for(RMS__c rmsObj : rmsList){
                BAFCORMSDto dto = new BAFCORMSDto();
                dto.shippingLineName = rmsObj.Shipping_Line__c !=null ? rmsObj.Shipping_Line__r.Name : '-';
                dto.equipmentName = rmsObj.Equipment_Type__r !=null ? rmsObj.Equipment_Type__r.Name : '-';
                dto.commodityName = rmsObj.Commodity__c !=null ? rmsObj.Commodity__r.Name : '-';
                dto.agentName = rmsObj.Agent__c !=null ? rmsObj.Agent__r.Name : '-';              
                dto.validity = rmsObj.Validity__c !=null ? (rmsObj.Validity__c.day()+'-'+ getMonthName(rmsObj.Validity__c.month()) +'-'+rmsObj.Validity__c.year()) : '-';
                dto.lastModifiedByName = rmsObj.LastModifiedBy.Name;
                dto.seaFreight = rmsObj.Sea_Freight__c != null ? rmsObj.Sea_Freight__c:0;
                dto.loadingPortId = rmsObj.Port_Of_Loading__c;
                dto.loadingDestinationId = rmsObj.Port_Of_Discharge__c;
                dto.loadingPortName = rmsObj.Port_Of_Loading__c != null ? rmsObj.Port_Of_Loading__r.Name :'-';
                dto.loadingDestinationName = rmsObj.Port_Of_Discharge__c != null ? rmsObj.Port_Of_Discharge__r.Name:'-';
                dto.rmsID = rmsObj.Id;
                dto.rateType = rmsObj.Rate_Type__c != null ? rmsObj.Rate_Type__c : '-';
                rmsDtolist.add(dto);
            }
        }
        system.debug('rmsDtolist '+rmsDtolist);
        return rmsDtolist;
    }
    public static string getMonthName(Integer n){
        switch on n {
            when 1 {
                return 'Jan';
            }
            when 2 {
                return 'Feb';
            }
            when 3 {
                return 'Mar';
            }
            when 4 {
                return 'Apr';
            }
            when 5 {
                return 'May';
            }
            when 6 {
                return 'Jun';
            }
            when 7 {
                return 'Jul';
            }
            when 8 {
                return 'Aug';
            }
            when 9 {
                return 'Sept';
            }
            when 10 {
                return 'Oct';
            }
            when 11 {
                return 'Nov';
            }
            when 12 {
                return 'Dec';
            }
        }
        return null;
    }
    @AuraEnabled
    public static BAFCORMSDto submitRMS(
        BAFCORMSDto rmsDetail,
        shippingLineChargesDTO shippingChargeDto,
        BAFCOIncoChargesDto incocharges,
        Boolean totalShippChanged,
        Boolean totalIncoChanged,
        Boolean destinTotalChanged,
        BAFCODestinationChargeDto destinCharges,
        List<selectedEquip> selectedEquip
    ){
        
        Id ExportRecordTypeId = Schema.SObjectType.RMS__c.getRecordTypeInfosByName()
            .get('Export')
            .getRecordTypeId();
        
        Id ImportRecordTypeId = Schema.SObjectType.RMS__c.getRecordTypeInfosByName()
            .get('Import')
            .getRecordTypeId();
        if(rmsDetail != null){
            for(selectedEquip obj : selectedEquip){
                RMS__c rmsobj = new RMS__c();
                rmsobj.Port_Of_Loading__c = rmsDetail.loadingPortId != '' ? rmsDetail.loadingPortId : null;
                rmsObj.Port_Of_Discharge__c = rmsDetail.loadingDestinationId != '' ? rmsDetail.loadingDestinationId : null;
                rmsObj.Commodity__c = rmsDetail.commodityName != '' ? rmsDetail.commodityName : null;
                rmsObj.Shipping_Line__c = rmsDetail.shippingLineId != '' ? rmsDetail.shippingLineId : null;
                //rmsObj.Equipment_Type__c = rmsDetail.equipmentId != '' ? rmsDetail.equipmentId : null;
                rmsObj.Rate_Type__c = rmsDetail.rateType != '' ? rmsDetail.rateType : null;
                rmsObj.Validity__c = rmsDetail.validity != '' ? DAte.valueOF(rmsDetail.validity) : null;
                //rmsObj.Sea_Freight__c = rmsDetail.seaFreight;
                
                List<SelectedEquip> rmsEquipList = rmsDetail.selectedEquip;
                for(SelectedEquip obj2 : rmsEquipList){
                    if(obj2.label == obj.label){
                        rmsObj.Sea_Freight__c = obj2.seaFreight;
                        rmsObj.Equipment_Type__c = obj2.value;
                    }
                }
                system.debug('rmsEquipList '+rmsEquipList);
                rmsObj.Business_Type__c = rmsDetail.businessType != '' ? rmsDetail.businessType : null;
                rmsObj.Agent__c = rmsDetail.agentName != '' ? rmsDetail.agentName : null;  
                rmsObj.All_in_Rate__c = rmsDetail.allInRate;
                rmsObj.FOB_All_In__c = rmsDetail.FOBAllIn;
                rmsObj.Ex_Works_All_In__c = rmsDetail.ExWorksIn;
                rmsObj.Customer_Name__c = rmsDetail.customerName != '' ? rmsDetail.customerName : null;
                rmsObj.Free_time__c = rmsDetail.FreeTime != null ? Decimal.valueOf(rmsDetail.FreeTime) : 0;
                rmsObj.Free_time_POD__c = rmsDetail.FreeTimePOD != null ? Decimal.valueOf(rmsDetail.FreeTimePOD) : 0;
                rmsObj.Remarks__c = rmsDetail.remarks;
                rmsobj.INCO_Term__c = rmsDetail.incoTermId != '' ? rmsDetail.incoTermId : null;
                rmsObj.Contract_Number__c = String.valueOf(rmsDetail.contractNumber);
                
                if(rmsDetail.businessType == 'Export') rmsObj.RecordTypeId = ExportRecordTypeId;
                else if(rmsDetail.businessType == 'Import')rmsObj.RecordTypeId = ImportRecordTypeId;
                insert rmsObj;
                
                Shipping_Line_Charge__c sLine = new Shipping_Line_Charge__c();
                if(!totalShippChanged){
                    sLine.BAF__c = shippingChargeDto.BAF;
                    sLine.Bunker_surcharge__c = shippingChargeDto.BunkerSurcharge;
                    sLine.CMC__c = shippingChargeDto.CMC;
                    sLine.DTHC__c = shippingChargeDto.DTHC;
                    sLine.EIC__c = shippingChargeDto.EIC;
                    sLine.ISPS__c = shippingChargeDto.ISPS;
                    sline.OTHC__c = shippingChargeDto.OTHC;            
                    sline.Seal_Charges__c = shippingChargeDto.sealCharges;
                    
                    sline.Carriage_Congestion_Surcharge__c = shippingChargeDto.carriageCongestionSurcharg;
                    sline.Carrier_Security_Fees__c = shippingChargeDto.carrierSecurityFees;
                    sline.Cleaning_Charges__c = shippingChargeDto.cleaningCharges;
                    sline.DG_Surcharge__c = shippingChargeDto.DGSurcharge;
                    sline.Inland_Fuel_Surcharge__c = shippingChargeDto.inlandFuelSurcharge;
                    sline.Inland_Handling_Fees__c = shippingChargeDto.inlandHandlingFees;
                    sline.Inland_haulage__c = shippingChargeDto.inlandhaulage;
                    sline.Low_Sulphur_Surcharge__c = shippingChargeDto.lowSulphurSurcharge;
                    sline.Operational_Recovery_Surcharge__c = shippingChargeDto.operationalRecoverySurcharge;
                    sline.Overweight_surcharge__c = shippingChargeDto.overweightsurcharge;
                    sline.War_Risk_Surcharge__c = shippingChargeDto.warRiskSurcharge;
                }
                sline.RMS__c = rmsObj.id;        
                sLine.Total__c = shippingChargeDto.Total;
                sLine.CurrencyIsoCode= shippingChargeDto.currencyCode;
                sLine.Offset_Value__c = shippingChargeDto.offSet;
                
                if(rmsObj.All_in_Rate__c == false && rmsObj.FOB_All_In__c == false && rmsObj.Ex_Works_All_In__c == false) Insert sLine;
                
                INCO_Charge__c iObj = new INCO_Charge__c();
                system.debug('incoCharges '+incocharges);
                if(!totalIncoChanged){
                    iObj.Bayan__c = incocharges.bayan;
                    iobj.Fasah_fee__c = incocharges.fasahFee;
                    iObj.Inspection__c = incocharges.inspection;
                    iObj.Lift_on_Lift_off__c = incocharges.liftOnLiftOff;
                    iObj.Origin_Customs_clearance__c = incocharges.originCustomsclearance;
                    iobj.Origin_Loading_Charges__c = incocharges.originLoadingCharges;
                    iObj.Port_Shuttling__c = incocharges.portShuttling;
                    iObj.Tabadul__c = incocharges.tabadul;
                    iObj.Xray__c = incocharges.xray;
                    iObj.Loading_Charges__c = incocharges.loadingCharge;
                    
                    iObj.BL_Fees__c = incoCharges.bLFees;
                    iObj.Export_Service_Fees__c = incoCharges.exportServiceFees;
                    iObj.Fuel_Surcharge__c = incoCharges.fuelSurcharge;
                    iObj.Insurance_Charges__c = incoCharges.insuranceCharges;
                    iObj.Lashing_Charges__c = incoCharges.lashingCharges;
                    iObj.Origin_Detention_Demurrage_Charges__c = incoCharges.originDetentionDemurrageCharges;
                    iObj.OTHC__c = incoCharges.OTHC;
                    iObj.Pickup_Charges__c = incoCharges.pickupCharges;
                    iObj.Reefer_Plugin_Charges__c = incoCharges.reeferPluginCharges;
                    iObj.Tarpaulin_Charges__c = incoCharges.tarpaulinCharges;
                    iObj.Truck_idling_Charges__c = incoCharges.truckidlingCharges;
                    iObj.VGM__c = incoCharges.vGM;
                }
                iObj.Total__c = incocharges.total;
                iObj.RMS__c = rmsObj.id;
                iObj.CurrencyIsoCode = incoCharges.currencyCode;
                iObj.Offset_Value__c = incoCharges.offSet;
                
                if(rmsObj.All_in_Rate__c == false && rmsObj.Ex_Works_All_In__c == false && rmsObj.FOB_All_In__c == false )  Insert iObj;
                Destination_Charges__c desti = new Destination_Charges__c();
                if(!destinTotalChanged){
                    desti.Bayan_Charges__c = destinCharges.bayanCharges;
                    desti.Custom_Clearance__c = destinCharges.customClearance;
                    desti.DO_charges__c = destinCharges.doCharges;
                    desti.DTHC__c = destinCharges.DTHC;
                    desti.Fasah_Charges__c = destinCharges.fasahCharges;
                    desti.Gate_pass_charges__c = destinCharges.gatePassCharges;
                    desti.LOLO_Charges__c = destinCharges.LOLOCharges;
                    desti.Transportation__c = destinCharges.transportation;
                }
                desti.Total__c = destinCharges.total;
                desti.CurrencyIsoCode = destinCharges.currencyCode;
                desti.RMS__c = rmsObj.id;
                desti.Offset_Value__c = destinCharges.offSet;
                insert desti;
            }
        }
        return rmsDetail;
    }
    @AuraEnabled 
    public static string insertAccountDetails(String accountName, String contName, String mobile, string contEmail){
        Id SHIPPER_RECORDTYPE_Id = Schema.SObjectType.Account.getRecordTypeInfosByName()
        .get('Shipper')
        .getRecordTypeId();
        Account acc = new Account();
        acc.RecordTypeId = SHIPPER_RECORDTYPE_Id;
        acc.Name= accountName;
        Insert acc;
        Contact cont = new Contact();
        cont.LastName = contName;
        cont.MobilePhone = mobile;
        cont.Email =contEmail;
        cont.AccountId = acc.id;
        insert cont;
        system.debug('cont '+cont);
        return acc.id;
    }
    @AuraEnabled 
    public static List<Route_Equipment__c> getRouteEquipmentDetails(String routeId){
        return [SELECT Volumetric_weight_Kgs__c,Route__r.Total_Volumetric_Weight__c,Weight_Kgs__c,CBM__c ,Route__r.Total_CBM__c,Route__r.Total_Gross_Weight_KGs__c,Id, Length__c, Width__c, Height__c, Units__c, UOM__c, Name FROM Route_Equipment__c where Route__c =: routeId];
    }
    @AuraEnabled 
    public static void updateRouteEquipmentDetails(List<Route_Equipment__c> routeEquipList, List<String> containerRemoveList,
                                                  Decimal totalCBMUpdate,Decimal totalGrossUpdate,Decimal totalVolumeWeightUpdate,String routeId){
        if(routeEquipList.size() > 0) {
            upsert routeEquipList;
            Route__c routeObj = new Route__c();
            routeObj.Total_CBM__c = totalCBMUpdate;
            routeObj.Total_Gross_Weight_KGs__c = totalGrossUpdate;
            routeObj.Total_Volumetric_Weight__c = totalVolumeWeightUpdate;
            routeObj.Id = routeId;
            update routeObj;
        }
        if(containerRemoveList.size() > 0) delete [Select id from Route_Equipment__c where id in : containerRemoveList];
    }
    @AuraEnabled 
    public static Quotation__c getQuoteDetail(String recordId){
        return [Select id,Quotation_Type__c from Quotation__c where id =: recordId limit 1];
    }
    public class selectedEquip{
        @auraEnabled public string label{get;set;}
        @auraEnabled public string value{get;set;}
        @AuraEnabled public Decimal seaFreight { get; set; }
    }
}