public class BAFCOImportQuotationReviseController {
    public static final Id QUOTE_IMPORT_RECORDTYPE_Id = Schema.SObjectType.quotation__c.getRecordTypeInfosByName()
        .get('Import')
        .getRecordTypeId();
    @AuraEnabled
    public static List<Quotation__c> getquoteList(String quoteId){
        Quotation__c quoteObj = [Select id,opportunity__c from Quotation__c where Id =: quoteId limit 1];
        List<Quotation__c> quoteList =  [Select Id,Name__c,Recordtype.name from Quotation__c where opportunity__c =: quoteObj.opportunity__c and recordtypeid = :QUOTE_IMPORT_RECORDTYPE_Id order by CreatedDate desc];
        
        return quoteList;
    }
    @AuraEnabled 
    public static Map<String,Map<String,List<BAFCOAllQuotationItemDto>>> getQuoteLineItemDetails(String quoteId,String portLoading, String portDestination, String commodity, String routeId){
        Set<Id> quoteRmsId = new Set<Id>();
        List<Id> rmsIds = new List<Id>();
        Decimal buyingTotal = 0;
        Map<String,INCO_Charge__c> rmsIdToIncoMap = new Map<String,INCO_Charge__c>();
        Map<String,Shipping_Line_Charge__c> rmsIdToShipLineMap = new Map<String,Shipping_Line_Charge__c>();
        Map<String,Destination_Charges__c> rmsIdToDestinMap = new Map<String,Destination_Charges__c>();
        Map<String,Map<String,List<BAFCOAllQuotationItemDto>>> agentToEquipMap = new Map<String,Map<String,List<BAFCOAllQuotationItemDto>>>();
        Map<String,RMS__c> rmsObjectToSeaFreightMap = new Map<String,RMS__c>();
        List<String> duplicateList = new List<String>();
        for(Quotation_Item__c item : [SELECT RMS__c from Quotation_Item__c where Quotation__c =: quoteId And Route__c =:routeId]){
            quoteRmsId.add(item.RMS__c);
        }
        for(RMS__c rmsObj : [Select Agent__r.name,Validity__c,Id,Sea_Freight__c, Shipping_Line__r.Name,Equipment_Type__r.name FROM RMS__c WHERE Port_Of_Loading__r.Name =: portLoading 
                             AND Port_Of_Discharge__r.Name =: portDestination
                             AND Shipping_Line__r.Name != null
                             AND Equipment_Type__r.name != null
                             AND Id in:quoteRmsId]
           ){
               if(rmsObj.Shipping_Line__r.Name != null && rmsObj.Equipment_Type__r.name != null){
                   String uniqueObj = rmsObj.Agent__r.Name+'-'+rmsObj.Shipping_Line__r.Name+'-'+rmsObj.Equipment_Type__r.name;
                   rmsObjectToSeaFreightMap.put(uniqueObj,rmsObj);
               }
               rmsIds.add(rmsObj.id);
           }
        for(INCO_Charge__c incoObj : [SELECT Total__c, Id FROM INCO_Charge__c where RMS__c In: rmsIds]){
            if(incoObj.Total__c > 0) buyingTotal = incoObj.Total__c + buyingTotal;
        }
        for(Shipping_Line_Charge__c slc : [SELECT Total__c FROM Shipping_Line_Charge__c WHERE RMS__c In : rmsIds]){                                               
            if(slc.Total__c > 0 ) buyingTotal = buyingTotal + slc.Total__c;
            
        }
        for(Destination_Charges__c destinObj :  [SELECT Total__c FROM Destination_Charges__c where RMS__c =: rmsIds]){
            if(destinObj.Total__c > 0 ) buyingTotal = buyingTotal + destinObj.Total__c;
        }
        system.debug('buyingTotal '+buyingTotal);
        for(Quotation_Item__c item : [SELECT Quotation__r.Quotation_Type__c,Service_Type__c,Buying_Rate__c, Selling_Charges_Include__c,Buying_Charges_Include__c,Total_Selling_Service_Charge__c,Total_Selling_Origin_Charge__c,Total_Selling_ExWorks_Charge__c,Total_Selling_Destin_Charge__c,Total_Selling_Additional_Charge__c,Tank_Rental_Charges__c,Included_PDF_ShippingLine__c,Included_PDF_Origin__c,Included_PDF_Destination__c,Included_PDF_Additional__c,Included_PDF_Ex_works__c, Alternate_depot_release_charges__c,Carrier_container_repositioning_charges__c,Freight_Difference_FD__c,Ex_Works_Charge_Name__r.name,Id,Ex_Works_Charge__c,Add_to_Buying_ShippingLine__c,Add_to_Buying_Origin__c,Add_to_Buying_Ex_works__c,Add_to_Buying_Destination__c,Add_to_Buying_Additional__c, Quotation__r.CreatedDate,Name,Agent_Name__c,Equipment_Type__r.name, CurrencyIsoCode, Quotation__c, BAF__c, Bayan__c, Bayan_cancellation_charge__c, Bunker_surcharge__c, CMC__c, Cleaning_charges__c, Container_movement_charges__c, Container_Lashing_Charges__c, Container_stripping__c, DTHC__c, Destination_Customs_Clearance__c, Destination_Loading_Charges__c, EIC__c, Equipment_Type__c, Fasah_fee__c, Free_time_certificate_charges__c, Fumigation__c, ISPS__c, Inspection__c, Insurance_charges__c, Lift_on_Lift_off__c, MOT_fine_charges__c, Ministry_clearnce_charge_for_OOG_cargo__c, Miscellaneous__c, Non_Palletized_Surcharge__c, OTHC__c, Origin_Customs_clearance__c, Origin_Loading_Charges__c, Pest_control__c, Port_Shuttling__c, Port_of_Discharge__c, Port_of_Loading__c, RMS__c, Re_palletization__c, Reefer_PTI_charges__c, Reefer_cntr_plug_in_charges__c, Reefer_steam_wash__c, Route__c, Sea_Freight__c, Seal_Charges__c, Stuffing_Charges__c, SweepingCleaning__c, Tabadul__c, Tarpauline_charge__c, Total_INCO__c, Total_SL__c, Total__c, Truck_Head_charges__c, Truck_idling_charges__c, Vessel_certificate_charges__c, Wrappingpacking_charges__c, Xray__c, Shipping_Line__c, Loading_Charges__c, Carriage_Congestion_Surcharge__c, Carrier_Security_Fees__c, Bayan_Charges__c, BL_Fees__c, DG_Surcharge__c, DO_charges__c, Export_Service_Fees__c, Fasah_Charges__c, Fuel_Surcharge__c, Gate_pass_charges__c, Inland_Fuel_Surcharge__c, Inland_Handling_Fees__c, Inland_haulage__c, Low_Sulphur_Surcharge__c, Operational_Recovery_Surcharge__c, Lashing_Charges__c, LOLO_Charges__c, Origin_Detention_Demurrage_Charges__c, Overweight_surcharge__c, Pickup_Charges__c, Total_Dest__c, War_Risk_Surcharge__c, VGM__c, Total_Additional__c, Charges_Included__c FROM Quotation_Item__c where Quotation__c =: quoteId And Route__c =:routeId ]){
            if(!agentToEquipMap.ContainsKey(item.Agent_Name__c)){
                agentToEquipMap.put(item.Agent_Name__c,new Map<String,List<BAFCOAllQuotationItemDto>>());
            }
            Map<String,List<BAFCOAllQuotationItemDto>> tempMap = agentToEquipMap.get(item.Agent_Name__c);
            if(!tempMap.containsKey(item.Shipping_Line__c)){
                tempMap.put(item.Shipping_Line__c, new List<BAFCOAllQuotationItemDto>());
            }
            BAFCOAllQuotationItemDto itemDto = new BAFCOAllQuotationItemDto();
            string uniqueObj= item.Agent_Name__c+'-'+item.Shipping_Line__c+'-'+item.Equipment_Type__r.name;
            if(rmsObjectToSeaFreightMap.containsKey(uniqueObj)){
                itemDto.itemId = item.id;
                itemDto.seaFreight = item.Sea_Freight__c;
                //itemDto.totalBuyingRate = buyingTotal;
                itemDto.validity = String.valueof(rmsObjectToSeaFreightMap.get(uniqueObj).Validity__c);
                itemDto.quotationDate = item.Quotation__r.createdDate.day()+'-'+ BAFCOLeadDetailsController.getMonthName(item.Quotation__r.createdDate.month()) +'-'+item.Quotation__r.createdDate.year();
                itemDto.rmsId = rmsObjectToSeaFreightMap.get(uniqueObj).Id;
                system.debug('* '+itemDto.totalBuyingRate);
                itemDto.totalBuyingRate = item.Buying_Rate__c;
                itemDto.totalSellingRate = item.Total__c;
                system.debug('** '+itemDto.totalBuyingRate);
                itemDto.currencyCode = item.CurrencyIsoCode;
                itemDto.buyingRate = rmsObjectToSeaFreightMap.get(uniqueObj).Sea_Freight__c > 0 ? rmsObjectToSeaFreightMap.get(uniqueObj).Sea_Freight__c : 0;
                //Additional Charge Data
                //List<BAFCOAllQuotationItemDto.additionalChargeList> additionalChargeList = new List<BAFCOAllQuotationItemDto.additionalChargeList>();
               	itemDto = BAFCOQuotationReviseController.assignAdditionalChargeRevise(item,itemDto);
            }
            itemDto.totalSellingRate = item.Sea_Freight__c;
            if(item.Ex_Works_Charge_Name__c != null && item.Ex_Works_Charge__c > 0){
                 itemDto.exWorksCharge =  item.Ex_Works_Charge_Name__r.NAme;
                 itemDto.LoadCharge = item.Ex_Works_Charge__c;
            }  
            itemDto.addServiceCharge = item.Add_to_Buying_ShippingLine__c ;
            itemDto.addOriginCharge = item.Add_to_Buying_Origin__c ;
            itemDto.addDestinCharge = item.Add_to_Buying_Destination__c ;
            itemDto.addAdditionalCharge = item.Add_to_Buying_Additional__c ;
            itemDto.addExWorksCharge = item.Add_to_Buying_Ex_works__c ;
            itemDto.includeServiceCharge = item.Included_PDF_ShippingLine__c ;
            itemDto.includeOriginCharge = item.Included_PDF_Origin__c ;
            itemDto.includeDestinCharge = item.Included_PDF_Destination__c ;
            itemDto.includeAdditionalCharge = item.Included_PDF_Additional__c ;
            itemDto.includeExWorksCharge = item.Included_PDF_Ex_works__c ;
            
            if(item.Total_Selling_Additional_Charge__c > 0 )  itemDto.totalSellingRate = itemDto.totalSellingRate + item.Total_Selling_Additional_Charge__c;
            if(item.Total_Selling_Destin_Charge__c > 0 )  itemDto.totalSellingRate = itemDto.totalSellingRate + item.Total_Selling_Destin_Charge__c;
            if(item.Total_Selling_ExWorks_Charge__c > 0 )  itemDto.totalSellingRate = itemDto.totalSellingRate + item.Total_Selling_ExWorks_Charge__c;
            if(item.Total_Selling_Origin_Charge__c > 0 )  itemDto.totalSellingRate = itemDto.totalSellingRate + item.Total_Selling_Origin_Charge__c;
            if(item.Total_Selling_Service_Charge__c > 0 )  itemDto.totalSellingRate = itemDto.totalSellingRate + item.Total_Selling_Service_Charge__c;
            
            itemDto.includedBuyingCharges = item.Buying_Charges_Include__c;
            itemDto.includedSellingCharges = item.Selling_Charges_Include__c;
            
            if(!duplicateList.contains(item.Agent_Name__c+item.Shipping_Line__c+item.Equipment_Type__r.name)){
                duplicateList.add(item.Agent_Name__c+item.Shipping_Line__c+item.Equipment_Type__r.name);
                itemDto.equipmentName = item.Equipment_Type__r.name;
                itemDto.equipmentId = item.Equipment_Type__c;  
                itemDto.totaladditionalCharge = item.Total_Additional__c;
                tempMap.get(item.Shipping_Line__c).add(itemDto);
            }
        }
        return agentToEquipMap;
    }
}