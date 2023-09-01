public class BAFCOshippingLineChargesController {
    @auraEnabled
    public static shippingLineChargesDTO getShippingCharges(String rmsRecordId){
        system.debug('rmsRecordId'+rmsRecordId);
        shippingLineChargesDTO slcDTO = new shippingLineChargesDTO();
        for(Shipping_Line_Charge__c slc : [SELECT Id, Name, CurrencyIsoCode , RMS__c, Bunker_surcharge__c, BAF__c, ISPS__c, OTHC__c, 
                                           Seal_Charges__c, CMC__c, EIC__c, DTHC__c,
                                           Carriage_Congestion_Surcharge__c,Carrier_Security_Fees__c,Cleaning_Charges__c,
                                           DG_Surcharge__c,Inland_Fuel_Surcharge__c,Inland_Handling_Fees__c,Inland_haulage__c,
                                           Low_Sulphur_Surcharge__c,Operational_Recovery_Surcharge__c,Overweight_surcharge__c,
                                           War_Risk_Surcharge__c,Total__c 
                                           FROM Shipping_Line_Charge__c WHERE RMS__c=:rmsRecordId]){
            
            slcDTO.BunkerSurcharge = slc.Bunker_surcharge__c != null ? slc.Bunker_surcharge__c : 0; 
            slcDTO.BAF = slc.BAF__c != null ? slc.BAF__c : 0; 
            slcDTO.ISPS = slc.ISPS__c != null ? slc.ISPS__c : 0; 
            slcDTO.OTHC = slc.OTHC__c != null ? slc.OTHC__c : 0; 
            slcDTO.sealCharges = slc.Seal_Charges__c != null ? slc.Seal_Charges__c : 0; 
            slcDTO.CMC = slc.CMC__c != null ? slc.CMC__c : 0; 
            slcDTO.EIC = slc.EIC__c != null ? slc.EIC__c : 0; 
            slcDTO.DTHC = slc.DTHC__c != null ? slc.DTHC__c : 0; 
            slcDTO.Total = slc.Total__c != null ? slc.Total__c : 0; 
            slcDto.currencyCode = slc.CurrencyIsoCode != null ? slc.CurrencyIsoCode : 'USD';
                                               
            slcDTO.carriageCongestionSurcharg = slc.Carriage_Congestion_Surcharge__c != null ? slc.Carriage_Congestion_Surcharge__c : 0; 
            slcDTO.carrierSecurityFees = slc.Carrier_Security_Fees__c != null ? slc.Carrier_Security_Fees__c : 0; 
            slcDTO.cleaningCharges = slc.Cleaning_Charges__c != null ? slc.Cleaning_Charges__c : 0; 
            slcDTO.DGSurcharge = slc.DG_Surcharge__c != null ? slc.DG_Surcharge__c : 0; 
            slcDTO.inlandFuelSurcharge = slc.Inland_Fuel_Surcharge__c != null ? slc.Inland_Fuel_Surcharge__c : 0; 
            slcDTO.inlandHandlingFees = slc.Inland_Handling_Fees__c != null ? slc.Inland_Handling_Fees__c : 0; 
            slcDTO.inlandhaulage = slc.Inland_haulage__c != null ? slc.Inland_haulage__c : 0; 
            slcDTO.lowSulphurSurcharge = slc.Low_Sulphur_Surcharge__c != null ? slc.Low_Sulphur_Surcharge__c : 0; 
            slcDTO.operationalRecoverySurcharge = slc.Operational_Recovery_Surcharge__c != null ? slc.Operational_Recovery_Surcharge__c : 0; 
            slcDTO.overweightsurcharge = slc.Overweight_surcharge__c != null ? slc.Overweight_surcharge__c : 0;
            slcDTO.warRiskSurcharge = slc.War_Risk_Surcharge__c != null ? slc.War_Risk_Surcharge__c : 0;
            slcDTO.shipLineName = slc.name;
        }
        return slcDTO;
    }
    @auraEnabled
    public static BAFCOIncoChargesDto getIncoCharges(String rmsRecordId){
        BAFCOIncoChargesDto incoDto = new BAFCOIncoChargesDto();
        for(INCO_Charge__c iObj : [SELECT Loading_Charges__c , CurrencyIsoCode ,Inspection__c, Origin_Customs_clearance__c, Fasah_fee__c, Lift_on_Lift_off__c, Tabadul__c, Xray__c, 
                                      Port_Shuttling__c, Bayan__c, RMS__c,RMS__r.Sea_Freight__c,RMS__r.Name, INCO_Term__c,Origin_Loading_Charges__c,
                                   	  BL_Fees__c,Export_Service_Fees__c,Fuel_Surcharge__c,Insurance_Charges__c,
                                      Lashing_Charges__c,Origin_Detention_Demurrage_Charges__c,OTHC__c,Pickup_Charges__c,
                                      Reefer_Plugin_Charges__c,Truck_idling_Charges__c,Tarpaulin_Charges__c,VGM__c,
                                      Total__c, Id FROM INCO_Charge__c where RMS__c =: rmsRecordId limit 1]){
             incoDto.bayan = iObj.Bayan__c!= null ? iObj.Bayan__c : 0;
             incoDto.fasahFee = iObj.Fasah_fee__c!= null ? iObj.Fasah_fee__c : 0;
             incoDto.inspection = iObj.Inspection__c!= null ? iObj.Inspection__c : 0;
             incoDto.liftOnLiftOff = iObj.Lift_on_Lift_off__c!= null ? iObj.Lift_on_Lift_off__c : 0;
             incoDto.originCustomsclearance = iObj.Origin_Customs_clearance__c!= null ? iObj.Origin_Customs_clearance__c : 0;
             incoDto.originLoadingCharges = iObj.Origin_Loading_Charges__c!= null ? iObj.Origin_Loading_Charges__c : 0;
             incoDto.portShuttling = iObj.Port_Shuttling__c!= null ? iObj.Port_Shuttling__c : 0;
             incoDto.tabadul = iObj.Tabadul__c!= null ? iObj.Tabadul__c : 0;
             incoDto.total = iObj.Total__c!= null ? iObj.Total__c : 0;
             incoDto.xray = iObj.Xray__c!= null ? iObj.Xray__c : 0;
             //incoDto.seaFreight = iObj.RMS__r.Sea_Freight__c;
             incoDto.loadingCharge = iObj.Loading_Charges__c!= null ? iObj.Loading_Charges__c : 0;
             incoDto.rmsId = iObj.RMS__c;
             //incoDto.rmsName = iObj.RMS__r.Name;
                                          
             incoDto.bLFees = iObj.BL_Fees__c != null ? iObj.BL_Fees__c : 0;
             incoDto.exportServiceFees = iObj.Export_Service_Fees__c != null ? iObj.Export_Service_Fees__c : 0;
             incoDto.fuelSurcharge = iObj.Fuel_Surcharge__c != null ? iObj.Fuel_Surcharge__c : 0;
             incoDto.insuranceCharges = iObj.Insurance_Charges__c != null ? iObj.Insurance_Charges__c : 0;
             incoDto.lashingCharges = iObj.Lashing_Charges__c != null ? iObj.Lashing_Charges__c : 0;
             incoDto.originDetentionDemurrageCharges = iObj.Origin_Detention_Demurrage_Charges__c != null ? iObj.Origin_Detention_Demurrage_Charges__c : 0;
             incoDto.OTHC = iObj.OTHC__c != null ? iObj.OTHC__c : 0;
             incoDto.pickupCharges = iObj.Pickup_Charges__c != null ? iObj.Pickup_Charges__c : 0;
             incoDto.reeferPluginCharges = iObj.Reefer_Plugin_Charges__c != null ? iObj.Reefer_Plugin_Charges__c : 0;
             incoDto.tarpaulinCharges = iObj.Tarpaulin_Charges__c != null ? iObj.Tarpaulin_Charges__c : 0;
             incoDto.truckidlingCharges = iObj.Truck_idling_Charges__c != null ? iObj.Truck_idling_Charges__c : 0;
             incoDto.vGM = iObj.VGM__c != null ? iObj.VGM__c : 0;
             incoDto.currencyCode =  iObj.CurrencyIsoCode != null ? iObj.CurrencyIsoCode : 'USD';
           
        }
        return incoDto;
    }
    @auraEnabled
    public static BAFCODestinationChargeDto getDestintionCharges(String rmsRecordId){
        BAFCODestinationChargeDto dto = new BAFCODestinationChargeDto();
        List<Destination_Charges__c> destinChargeList = [SELECT LOLO_Charges__c,CurrencyIsoCode , DTHC__c, Gate_pass_charges__c, DO_charges__c, Custom_Clearance__c, Transportation__c, Fasah_Charges__c, Bayan_Charges__c, Total__c FROM Destination_Charges__c where RMS__c =: rmsRecordId limit 1];
        if(destinChargeList.size() > 0 ){
            Destination_Charges__c destinObj = destinChargeList[0];
            dto.bayanCharges = destinObj.Bayan_Charges__c !=null ? destinObj.Bayan_Charges__c : 0;
            dto.customClearance = destinObj.Custom_Clearance__c !=null ? destinObj.Custom_Clearance__c : 0;
            dto.doCharges = destinObj.DO_charges__c !=null ? destinObj.DO_charges__c : 0;
            dto.DTHC = destinObj.DTHC__c !=null ? destinObj.DTHC__c : 0;
            dto.fasahCharges = destinObj.Fasah_Charges__c !=null ? destinObj.Fasah_Charges__c : 0;
            dto.gatePassCharges = destinObj.Gate_pass_charges__c !=null ? destinObj.Gate_pass_charges__c : 0;
            dto.LOLOCharges = destinObj.LOLO_Charges__c !=null ? destinObj.LOLO_Charges__c : 0;
            dto.total = destinObj.Total__c !=null ? destinObj.Total__c : 0;
            dto.transportation = destinObj.Transportation__c !=null ? destinObj.Transportation__c : 0;
            dto.currencyCode =  destinObj.CurrencyIsoCode != null ? destinObj.CurrencyIsoCode : 'USD';
        }
        return dto;
    }
    @auraEnabled
    public static RmsDetails getRMSDetail(String rmsRecordId){
        RmsDetails rmsDto = new RmsDetails();
        if(rmsRecordId != null){
            RMS__c rmsObj = getRmsData(rmsRecordId);
            rmsDto.destinationCharge = getDestintionCharges(rmsRecordId);
            rmsDto.originCharge = getIncoCharges(rmsRecordId);
            rmsDto.shipCharges = getShippingCharges(rmsRecordId);
            rmsDto.seaFreight =rmsObj.Sea_Freight__c;
            rmsDto.rmsName =rmsObj.Name;
            rmsDto.shippingLineName = rmsObj.Shipping_Line__r.name;
            rmsDto.airLine = rmsobj.Airline__r.Name;
            rmsDto.rateKg = rmsObj.Rate_Kg__c ;
        }
        return rmsDto;
    }
    @auraEnabled
    public static RMS__c getRmsData(String rmsRecordId){
        if(rmsRecordId != null){
            return [Select Rate_Kg__c,Airline__r.Name,id,name,Sea_Freight__c,Shipping_Line__r.Name from RMS__c where id =: rmsRecordId];
        }
        return null;
    }
    public class RmsDetails{
        @AuraEnabled
        public BAFCODestinationChargeDto destinationCharge{get;set;}
        @AuraEnabled
        public BAFCOIncoChargesDto originCharge{get;set;}
        @AuraEnabled
        public shippingLineChargesDTO shipCharges{get;set;}
        @AuraEnabled 
        public decimal seaFreight{get;set;}
        @AuraEnabled 
        public String rmsName{get;set;}
        @AuraEnabled 
        public String shippingLineName{get;set;}
        @AuraEnabled 
        public String airLine{get;set;}
        @AuraEnabled 
        public decimal rateKg{get;set;}
        
    }
}