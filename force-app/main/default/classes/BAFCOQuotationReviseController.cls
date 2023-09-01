public class BAFCOQuotationReviseController {
    public static final Id QUOTE_EXPORT_RECORDTYPE_Id = Schema.SObjectType.quotation__c.getRecordTypeInfosByName()
        .get('Export')
        .getRecordTypeId();
    @AuraEnabled
    public static BAFCOReviseQuoteDto getquoteDetails(String quoteId){
        Quotation__c quoteObj = [SELECT CurrencyIsoCode,isAir__c,Name__c,isLCL__c,Opportunity__c,Opportunity__r.Account.Average_margin__c,
                                 Opportunity__r.Account.Best_Margin__c,Opportunity__r.Account.Average_credit_days__c,
                                 Opportunity__r.Business_Type__c, Opportunity__r.Account.Modes__c,Opportunity__r.AccountId,
                                 Opportunity__r.Account.Name, 
                                 Name,Recordtype.name, Id FROM Quotation__c where id =: quoteId];        
        BAFCOReviseQuoteDto dto = new BAFCOReviseQuoteDto();
        dto.currencyString = quoteObj.CurrencyIsoCode;
        dto.quoteNumber = quoteObj.Name__c;
        dto.isLCL = quoteObj.isLCL__c;
        dto.isAir = quoteObj.isAir__c;
        dto.enquiryId = quoteObj.Opportunity__c;
        dto.company = quoteObj.Opportunity__r.Account.Name;
        dto.companyId = quoteObj.Opportunity__r.AccountId;
        dto.accountAvgMargin = quoteObj.Opportunity__r.Account.Average_margin__c != null ? (quoteObj.Opportunity__r.Account.Average_margin__c).setScale(2) : 0;
        dto.accountBestMargin = quoteObj.Opportunity__r.Account.Best_Margin__c != null ? (quoteObj.Opportunity__r.Account.Best_Margin__c).setScale(2):0;
        dto.accountAvgCreditDays = quoteObj.Opportunity__r.Account.Average_credit_days__c != null ? (quoteObj.Opportunity__r.Account.Average_credit_days__c).setScale(2):0;
        dto.businessType = quoteObj.Opportunity__r.Business_Type__c;
        dto.mode = quoteObj.Opportunity__r.Account.Modes__c;
        dto.recordTypeName = quoteObj.RecordType.name;
        system.debug('dto  *********** '+quoteObj.Opportunity__r.AccountId);
        if(quoteObj.Opportunity__r.AccountId != null){
            dto.leadId = quoteObj.Opportunity__r.AccountId;
            List<contact> contactList = [Select MobilePhone,Email from Contact where AccountId =: quoteObj.Opportunity__r.AccountId order by createddate limit 1];
            if(contactList.size() > 0){
                dto.contactMobile = contactList[0].MobilePhone != null ? contactList[0].MobilePhone : '-';
                dto.contactEmail = contactList[0].Email != null ? contactList[0].Email : '-';
            }
            else{
                dto.contactMobile =  '-';
                dto.contactEmail =  '-';
            }
        }
        else{
            dto.contactMobile =  '-';
            dto.contactEmail =  '-';
        }
        // getting quoteItem 
        Map<String, List<Quotation_Item__c>> routetoItemMap = new Map<String, List<Quotation_Item__c>>();
        for(Quotation_Item__c item : [SELECT Total__c,Route__r.Inco_term__r.name, Route__r.name, Name, Id, Shipping_Line__c,Equipment_Type__r.name  FROM Quotation_Item__c where Quotation__c =: quoteId]){
            if(!routetoItemMap.containskey(item.Route__r.name)){
                routetoItemMap.put(item.Route__r.name, new list<Quotation_Item__c>());
            }
            routetoItemMap.get(item.Route__r.name).add(item);
            dto.incoTerm = item.Route__r.Inco_term__r.name;
        }
        dto.routetoItemMap = routetoItemMap;
        system.debug('dto '+dto);
        return dto;
    }
    @AuraEnabled
    public static List<Quotation__c> getquoteList(String quoteId){
        Quotation__c quoteObj = [Select id, opportunity__c,Opportunity__r.business_Type__c from Quotation__c where Id =: quoteId limit 1];
        List<Quotation__c> quoteList =  [Select Id,Name__c,Recordtype.name from Quotation__c where opportunity__c =: quoteObj.opportunity__c and recordtype.name = :quoteObj.Opportunity__r.business_Type__c order by CreatedDate desc];
        
        return quoteList;
    }
    @AuraEnabled 
    public static List<BAFCORoutingDetailsDto> getQuoteLineItemRoute(String quoteId){
        BAFCOReviseQuoteDto dto = new BAFCOReviseQuoteDto();
        List<Id> LOPIds = new List<Id>();
        List<Id> DOPIds = new List<Id>();
        Map<String,List<Route_Profit_Margin__c>> routeProfitMap = new Map<String,List<Route_Profit_Margin__c>>();
        Map<String,Quotation_Item__c> mapRouteIdToQuotationItem = new Map<String,Quotation_Item__c>();
        for(Quotation_Item__c item : [SELECT Route__c,Equipment_Type__c, Shipping_Line__c FROM Quotation_Item__c where Quotation__c =: quoteId Order by CreatedDate]){
            if(!mapRouteIdToQuotationItem.containsKey(item.Route__c)) 
                mapRouteIdToQuotationItem.put(item.Route__c,item);
        }
        List<BAFCORoutingDetailsDto> routingDetailsList = new List<BAFCORoutingDetailsDto>();
        Integer index = 1;
        List<Route__c> routeList = [SELECT Opportunity_Enquiry__r.Account.Average_Margin__c,Opportunity_Enquiry__r.AccountId,(Select id, Equipment_Type__r.name,Quantity__c from Route_Equipments__r),Place_of_Discharge__r.Name,Place_of_Pickup__r.Name,Opportunity_Enquiry__c ,Regular_Routing_Lookup__r.name,Port_of_loading__c,Discharge_Place__c,Pickup_Place__c,Id, Regular_Routing__c,INCO_Term__r.name, Kind_Of_Shipment__c, Service_Type__c, Port_of_loading__r.Name, 
                               Port_of_Destination__r.Name, Shipping_Line__r.name, Commodity__r.Name, Cargo_Weight__c, Remarks__c,Cargo_Readiness__c, Name  
                               FROM Route__c WHERE  Id in : mapRouteIdToQuotationItem.keySet()];
		for(Route__c enqObj : routeList){
            LOPIds.add(enqObj.Port_of_loading__c);
            DOPIds.add(enqObj.Port_of_Destination__c);
        }    
        for(Route_Profit_Margin__c routeProfit : [SELECT Customer__c,Recordtype.name,id,Port_of_Discharge__c,Port_of_Loading__c,Margin__c from Route_Profit_Margin__c where
                                                  Port_of_Loading__c in : LOPIds and Port_of_Discharge__c in : DOPIds]){
                                                      String uniqueKey = routeProfit.Port_of_Loading__c+'-'+routeProfit.Port_of_Discharge__c;
                                                      if(!routeProfitMap.containsKey(uniqueKey))
                                                          routeProfitMap.put(uniqueKey,new List<Route_Profit_Margin__c>());
                                                      routeProfitMap.get(uniqueKey).add(routeProfit);
                                                  }
        for(Route__c enqObj : routeList){
            BAFCORoutingDetailsDto enqDtoObj = new BAFCORoutingDetailsDto();
            enqDtoObj.routeName = 'Route '+ index;
            enqDtoObj.routingRegular = enqObj.Regular_Routing_Lookup__c != null ? enqObj.Regular_Routing_Lookup__r.name : '-';
            enqDtoObj.shipmentKind = enqObj.Kind_Of_Shipment__c != null ? enqObj.Kind_Of_Shipment__c : '-';
            enqDtoObj.serviceType = enqObj.Service_Type__c != null ? enqObj.Service_Type__c : '-';
            enqDtoObj.portDestination = enqObj.Port_of_Destination__r.Name != null ? enqObj.Port_of_Destination__r.Name :'-';
            enqDtoObj.portLoading = enqObj.Port_of_loading__r.name != null ? enqObj.Port_of_loading__r.name : '-';
            enqDtoObj.portLoadingId = enqObj.Port_of_loading__c;
            enqDtoObj.portDestinationId = enqObj.Port_of_Destination__c;
            String uniqueKey = enqObj.Port_of_loading__c+'-'+enqObj.Port_of_Destination__c;
            if(routeProfitMap.containsKey(uniqueKey)){
                List<Route_Profit_Margin__c> routeProfitList = routeProfitMap.get(uniqueKey);
                for(Integer i = 0 ; i<routeProfitList.size();i++){
                    if(routeProfitList[i].Recordtype.Name == 'Customer Port Pair' && routeProfitList[i].Customer__c == enqObj.Opportunity_Enquiry__r.AccountId && routeProfitList[i].Port_of_Loading__c == enqObj.Port_of_loading__c  && routeProfitList[i].Port_of_Discharge__c == enqObj.Port_of_Destination__c){
                        enqDtoObj.routeCustomerAvgMargin = routeProfitList[i].Margin__c > 0 ? (routeProfitList[i].Margin__c).setScale(2) : 0;
                    }
                    if(routeProfitList[i].Recordtype.Name == 'Port Pair' && routeProfitList[i].Port_of_Loading__c == enqObj.Port_of_loading__c && routeProfitList[i].Port_of_Discharge__c == enqObj.Port_of_Destination__c){
                        enqDtoObj.routeAvgMargin = routeProfitList[i].Margin__c > 0 ? (routeProfitList[i].Margin__c).setScale(2) : 0;
                    }
                }
            }
            enqDtoObj.accountAvgMargin = enqObj.Opportunity_Enquiry__r.Account.Average_Margin__c != null ? (enqObj.Opportunity_Enquiry__r.Account.Average_Margin__c).setScale(2) : 0 ;
            enqDtoObj.commodity = enqObj.Commodity__r.Name != null ? enqObj.Commodity__r.name : '-';
            enqDtoObj.cargoWeights = enqObj.Cargo_Weight__c != null ? enqObj.Cargo_Weight__c : 0 ;
            enqDtoObj.remarks = enqObj.Remarks__c != null ? enqObj.Remarks__c : '-';
            enqDtoObj.routeId = enqObj.Id;
            enqDtoObj.shippingLine = enqObj.Shipping_Line__r.name != null ? enqObj.Shipping_Line__r.name : '-';
            enqDtoObj.enquiryId = enqObj.Opportunity_Enquiry__c;
            enqDtoObj.placeOfPickupName = enqObj.Pickup_Place__c;
            enqDtoObj.placeOfDischargeName = enqObj.Discharge_Place__c;
            enqDtoObj.cargoReadiness = enqObj.Cargo_Readiness__c != null ? (enqObj.Cargo_Readiness__c.day()+'-'+ BAFCOLeadDetailsController.getMonthName(enqObj.Cargo_Readiness__c.month()) +'-'+enqObj.Cargo_Readiness__c.year()) : '-';
            if(enqObj.Route_Equipments__r.size() > 0){
                String equipmentType ='';
                for(Route_Equipment__c rr : enqObj.Route_Equipments__r){
                    if(rr.Equipment_Type__c != null){
                        equipmentType+=rr.Equipment_Type__r.Name+' - '+ rr.Quantity__c;
                        equipmentType+=', ';
                    }
                }
                if(equipmentType != ''){
                    equipmentType = equipmentType.removeEnd(', ');
                }
                enqDtoObj.equipmentType = equipmentType;
            }
            index++;
            routingDetailsList.add(enqDtoObj);
        }
        return routingDetailsList;
    }
    @AuraEnabled 
    public static Map<String,List<BAFCOAllQuotationItemDto>> getQuoteLineItemDetails(String quoteId,String portLoading, String portDestination, String commodity, String routeId){
        Map<String,List<BAFCOAllQuotationItemDto>> shipLineToEquipMap = new Map<String,List<BAFCOAllQuotationItemDto>>();
        Map<String,RMS__c> rmsObjectToSeaFreightMap = new Map<String,RMS__c>();
        Map<String,INCO_Charge__c> rmsIdToIncoMap = new Map<String,INCO_Charge__c>();
        Decimal buyingTotal = 0;
        Decimal incoTotal = 0;
        List<Id> rmsIds = new List<Id>();
        List<String> duplicateList = new List<String>();
        Set<Id> quoteRmsId = new Set<Id>();
        for(Quotation_Item__c item : [SELECT RMS__c from Quotation_Item__c where Quotation__c =: quoteId And Route__c =:routeId]){
            quoteRmsId.add(item.RMS__c);
        }
        for(RMS__c rmsObj : [Select Validity__c,Id,Sea_Freight__c, Shipping_Line__r.Name,Equipment_Type__r.name FROM RMS__c WHERE Port_Of_Loading__r.Name =: portLoading 
                             AND Port_Of_Discharge__r.Name =: portDestination
                             AND Shipping_Line__r.Name != null
                             AND Equipment_Type__r.name != null
                             AND Id in:quoteRmsId]
           ){
               if(rmsObj.Shipping_Line__r.Name != null && rmsObj.Equipment_Type__r.name != null){
                   String uniqueObj = rmsObj.Shipping_Line__r.Name+'-'+rmsObj.Equipment_Type__r.name;
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
        for(Quotation_Item__c item : [SELECT Quotation__r.Quotation_Type__c,Service_Type__c,Buying_Rate__c,Total_Ex_Works_Charges__c,Quotation__r.isLCL__c,Tank_Rental_Charges__c,Included_PDF_ShippingLine__c,Included_PDF_Origin__c,Included_PDF_Destination__c,Included_PDF_Additional__c,Included_PDF_Ex_works__c,Id, Alternate_depot_release_charges__c,Carrier_container_repositioning_charges__c,Freight_Difference_FD__c,Ex_Works_Charge_Name__r.name,Ex_Works_Charge__c,Add_to_Buying_ShippingLine__c,Add_to_Buying_Origin__c,Add_to_Buying_Ex_works__c,Add_to_Buying_Destination__c,Add_to_Buying_Additional__c,Quotation__r.CreatedDate,Name,Agent_Name__c,Equipment_Type__r.name, CurrencyIsoCode, Quotation__c, BAF__c, Bayan__c, Bayan_cancellation_charge__c, Bunker_surcharge__c, CMC__c, Cleaning_charges__c, Container_movement_charges__c, Container_Lashing_Charges__c, Container_stripping__c, DTHC__c, Destination_Customs_Clearance__c, Destination_Loading_Charges__c, EIC__c, Equipment_Type__c, Fasah_fee__c, Free_time_certificate_charges__c, Fumigation__c, ISPS__c, Inspection__c, Insurance_charges__c, Lift_on_Lift_off__c, MOT_fine_charges__c, Ministry_clearnce_charge_for_OOG_cargo__c, Miscellaneous__c, Non_Palletized_Surcharge__c, OTHC__c, Origin_Customs_clearance__c, Origin_Loading_Charges__c, Pest_control__c, Port_Shuttling__c, Port_of_Discharge__c, Port_of_Loading__c, RMS__c, Re_palletization__c, Reefer_PTI_charges__c, Reefer_cntr_plug_in_charges__c, Reefer_steam_wash__c, Route__c, Sea_Freight__c, Seal_Charges__c, Stuffing_Charges__c, SweepingCleaning__c, Tabadul__c, Tarpauline_charge__c, Total_INCO__c, Total_SL__c, Total__c, Truck_Head_charges__c, Truck_idling_charges__c, Vessel_certificate_charges__c, Wrappingpacking_charges__c, Xray__c, Shipping_Line__c, Loading_Charges__c, Carriage_Congestion_Surcharge__c, Carrier_Security_Fees__c, Bayan_Charges__c, BL_Fees__c, DG_Surcharge__c, DO_charges__c, Export_Service_Fees__c, Fasah_Charges__c, Fuel_Surcharge__c, Gate_pass_charges__c, Inland_Fuel_Surcharge__c, Inland_Handling_Fees__c, Inland_haulage__c, Low_Sulphur_Surcharge__c, Operational_Recovery_Surcharge__c, Lashing_Charges__c, LOLO_Charges__c, Origin_Detention_Demurrage_Charges__c, Overweight_surcharge__c, Pickup_Charges__c, Total_Dest__c, War_Risk_Surcharge__c, VGM__c, Total_Additional__c, Charges_Included__c
                                      FROM Quotation_Item__c where Quotation__c =: quoteId And Route__c =:routeId ]){
            if(!shipLineToEquipMap.containsKey(item.Shipping_Line__c)){
                shipLineToEquipMap.put(item.Shipping_Line__c,new List<BAFCOAllQuotationItemDto>());
            }
            BAFCOAllQuotationItemDto itemDto = new BAFCOAllQuotationItemDto();
            string uniqueObj= item.Shipping_Line__c+'-'+item.Equipment_Type__r.name;
            if(rmsObjectToSeaFreightMap.containsKey(uniqueObj)){  
                itemDto.validity = String.valueof(rmsObjectToSeaFreightMap.get(uniqueObj).Validity__c);
                itemDto.rmsId = rmsObjectToSeaFreightMap.get(uniqueObj).Id;
                itemDto.buyingRate = (rmsObjectToSeaFreightMap.get(uniqueObj).Sea_Freight__c > 0 ? rmsObjectToSeaFreightMap.get(uniqueObj).Sea_Freight__c : 0);   
                itemDto.totalBuyingRate = item.Buying_Rate__c;
                itemDto.totalSellingRate = item.Total__c;
                itemDto = assignQuoteItemData(item,itemDto);
            } 
            if(!duplicateList.contains(item.Shipping_Line__c+item.Equipment_Type__r.name)){
               duplicateList.add(item.Shipping_Line__c+item.Equipment_Type__r.name);
               itemDto.equipmentName = item.Equipment_Type__r.name;
               itemDto.equipmentId = item.Equipment_Type__c;  
               itemDto.totaladditionalCharge = item.Total_Additional__c;
               shipLineToEquipMap.get(item.Shipping_Line__c).add(itemDto);
            }
        }
        return shipLineToEquipMap;
    }
    public static BAFCOAllQuotationItemDto assignQuoteItemData(Quotation_Item__c item,BAFCOAllQuotationItemDto itemDto){
        itemDto.currencyCode = item.CurrencyIsoCode;
        itemDto.seaFreight = item.Sea_Freight__c;
        itemDto.quotationDate = item.Quotation__r.createdDate.day()+'-'+ BAFCOLeadDetailsController.getMonthName(item.Quotation__r.createdDate.month()) +'-'+item.Quotation__r.createdDate.year();
		itemDto = assignAdditionalChargeRevise(item,itemDto);
        //itemDto.totalSellingRate = item.Sea_Freight__c;
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
        return itemDto;
    }
    public static BAFCOAllQuotationItemDto assignAdditionalChargeRevise(Quotation_Item__c item,BAFCOAllQuotationItemDto itemDto){
        List<BAFCOAllQuotationItemDto.additionalChargeList> additionalChargeList = new List<BAFCOAllQuotationItemDto.additionalChargeList>();
        for(Quotation_Charges__c  quoteCharge : [Select Charge_Value__c,Charge_Name__r.name,Buying_Rate__c  FROM Quotation_Charges__c where Quotation_Item__c =:item.id and isAdditional_Charge__c = true]){
            BAFCOAllQuotationItemDto.additionalChargeList obj = new BAFCOAllQuotationItemDto.additionalChargeList();
            obj.Name = quoteCharge.Charge_Name__r.name;
            system.debug('item.Service_Type__c  '+item.Service_Type__c );
            if(item.Quotation__r.Quotation_Type__c == 'Sea Import'){
                obj.value = quoteCharge.Charge_Value__c;
            	obj.buyingCharge = quoteCharge.Buying_Rate__c;
                
            }
            else{
                if(item.Add_to_Buying_Additional__c == true )obj.value = quoteCharge.Buying_Rate__c;
            	else obj.value = quoteCharge.Charge_Value__c;
            }
            //obj.buyingCharge = quoteCharge.Buying_Rate__c;
            system.debug('obj'+obj);
            additionalChargeList.add(obj);
        }
        if(additionalChargeList.size() > 0){
            itemDto.additionalChargeList = additionalChargeList;
        }
        return itemDto;
    }
}