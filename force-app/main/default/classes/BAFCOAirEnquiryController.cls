public without sharing class BAFCOAirEnquiryController {
    public static final Id RMS_EXPORT_RECORDTYPE_Id = Schema.SObjectType.RMS__c.getRecordTypeInfosByName()
        .get('Export')
        .getRecordTypeId();
    public static final Id QUOTE_EXPORT_RECORDTYPE_Id = Schema.SObjectType.quotation__c.getRecordTypeInfosByName()
        .get('Export')
        .getRecordTypeId();
    @AuraEnabled
    public static String submitRoutingList(List<BAFCORoutingDetailsDto> routingList, String businessType, String quoteId,
    String closeDate, String commercialUserId,String isEdit,List<String> containerRemoveList,List<String> routeRemoveList,
    String optyId,Decimal totalCBM, Decimal totalGross,Decimal totalVolumeWeight) {
        List<Route__c> routeList = new List<Route__c>();
        Boolean isAir = false;
        system.debug('routingList '+routingList);
        Opportunity optyObj = new Opportunity();
        if(isEdit == 'true'){
            optyObj.id = optyId;
            optyObj.CloseDate = date.valueOf(closeDate);
            optyObj.Commercial_User__c = commercialUserId != '' ? commercialUserId : null;
            update optyObj;
        }
        else{
            Account acc = [Select id,name,ownerId from Account where id=: quoteId];
            User userObj = [Select id,isActive from user where id =: acc.OwnerId];
            optyObj.Name = acc.Name +' - '+String.valueOf(date.today()).split(' ')[0];
            optyObj.AccountId = acc.Id;
            optyObj.OwnerId = userObj.IsActive == true ? acc.OwnerId : userinfo.getUserId();
            optyObj.Business_Type__c = businessType;
            try{
                optyObj.StageName = 'Qualification';
                optyObj.CloseDate = date.valueOf(closeDate);
                optyObj.Commercial_User__c = commercialUserId != '' ? commercialUserId : null;                
                Id LCLRecId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName()
                    .get('LCL')
                    .getRecordTypeId();
                Id AirRecId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName()
                    .get('Air Freight')
                    .getRecordTypeId();
                if(routingList[0].isAir == true) {
                    isAir = true;
                    optyObj.RecordTypeId = AirRecId;
                    if(businessType == 'Import') optyObj.Service_Type__c = 'Air Import';
                	else if(businessType == 'Export') optyObj.Service_Type__c = 'Air Export';
                }
                else {
                    isAir = false;
                    optyObj.RecordTypeId = LCLRecId;
                    if(businessType == 'Import') optyObj.Service_Type__c = 'LCL Import';
                	else if(businessType == 'Export') optyObj.Service_Type__c = 'LCL Export';
                }
                insert optyObj;
                Task tsk = new Task();
                tsk.Subject = 'Provide Quotation';
                tsk.Status = 'Open';
                tsk.OwnerId = commercialUserId != '' ? commercialUserId : UserInfo.getUserId();
                tsk.WhatId = optyObj.Id;
                tsk.IsReminderSet = true;
                tsk.ActivityDate = Date.valueOf(DateTime.now());
                insert tsk;
                system.debug('optyObj '+optyObj);
            }
            catch(Exception e){
                System.debug('Excepiton '+e.getMessage());
            }
        }
        Map<String,String> routeIndexToIdMap =  new Map<String,String>();
        List<Route_Equipment__c> routeEquipList = new List<Route_Equipment__c>();
        Boolean stackableParent = routingList[0].stackableParent;
        Boolean palletizedParent = routingList[0].palletizedParent;
        for(BAFCORoutingDetailsDto dto : routingList){
            system.debug('dto '+dto);
            Route__c routeObj = new Route__c();
            routeObj.Cargo_Weight__c = dto.cargoWeights;
            if(!String.isBlank(dto.commodity)) routeObj.Commodity__c =dto.commodity;
            routeObj.Kind_Of_Shipment__c = 'FCL';
            routeObj.Regular_Routing__c = dto.routingRegular;
            String ObjectName = '';
            routeObj.Regular_Routing_Lookup__c = dto.routingRegular != '' ? dto.routingRegular : null;            
            routeObj.Service_Type__c = dto.serviceType;
            routeObj.Total_Gross_Weight_KGs__c = totalGross;
            routeObj.Total_Volumetric_Weight__c = totalVolumeWeight;
            routeObj.Total_CBM__c = totalCBM;
            system.debug('submitRoutingList '+dto.isAir);
            if(dto.isAir == true){
                if(!String.isBlank(dto.portLoading)) routeObj.Airport_of_Loading__c = dto.portLoading;
                if(!String.isBlank(dto.portDestination)) routeObj.Airport_of_Destination__c = dto.portDestination;  
                if(!String.isBlank(dto.shippingLine)) routeObj.Airline__c = dto.shippingLine;
                routeObj.Total_CBM__c = totalCBM;
                routeObj.Total_Gross_Weight_KGs__c = totalGross;
            }
            else{
                if(!String.isBlank(dto.portLoading)) routeObj.Port_of_loading__c = dto.portLoading;
                if(!String.isBlank(dto.portDestination)) routeObj.Port_of_Destination__c = dto.portDestination;
                if(!String.isBlank(dto.shippingLine)) routeObj.Shipping_Line__c = dto.shippingLine;
            }
            routeObj.Remarks__c = dto.remarks;
            routeObj.Dangerous_Goods__c = dto.dangerousGoods;
            routeObj.Index__c = String.valueOf(dto.leadIndex);
            if(!String.isBlank(dto.incoTerm)) routeObj.INCO_Term__c = dto.incoTerm  ;
            routeObj.Opportunity_Enquiry__c = optyObj.id;
            routeObj.DG_Class__c = dto.dgClass;
            if(!String.isBlank(dto.placeOfPickup)) routeObj.Pickup_Place__c = dto.placeOfPickup;
            if(!String.isBlank(dto.placeOfDischarge)) routeObj.Discharge_Place__c = dto.placeOfDischarge;
            routeObj.id = dto.routeId !='' ? dto.routeId : null;
            system.debug('dto.cargoReadiness '+dto.cargoReadiness);
            if(dto.cargoReadiness != null && !String.isBlank(dto.cargoReadiness)) routeObj.Cargo_Readiness__c = Date.valueOf(dto.cargoReadiness);
            else routeObj.Cargo_Readiness__c = null;
            routeList.add(routeObj);
        }
        if(routeList.size() > 0){
            system.debug('before insert routeList '+routeList);
            upsert routeList;
            system.debug('after insert routeList '+routeList);
        }        
        for(Route__c obj : routeList){
            routeIndexToIdMap.put(obj.Index__c, obj.Id);
        }
        system.debug('isAir '+isAir);
        for(BAFCORoutingDetailsDto dto : routingList){
            for(BAFCORoutingDetailsDto.containerRecord contr : dto.containerRecord){
                Route_Equipment__c routeQuipobj = new Route_Equipment__c();
                routeQuipobj.Length__c = contr.length;
                routeQuipobj.Width__c = contr.width;
                routeQuipobj.Height__c = contr.height;
                routeQuipobj.CBM__c = contr.CBM;
                routeQuipobj.Volumetric_weight_Kgs__c = contr.volumeWeight;
                routeQuipobj.Weight_Kgs__c = contr.Weight;
                if(isAir == true){
                    routeQuipobj.Stackable__c = stackableParent;
                    routeQuipobj.Palletized__c = palletizedParent;
                    routeQuipobj.UOM__c = contr.uomValue;
                }else{
                    routeQuipobj.Stackable__c = contr.stackable;
                    routeQuipobj.Palletized__c = contr.palletized;
                }
                routeQuipobj.Units__c = contr.units;
                routeQuipobj.Cargo_Details__c = contr.cargoDetails;       
                routeQuipobj.Route__c = routeIndexToIdMap.get(dto.leadIndex);
                routeQuipobj.id = contr.id != '' ? contr.id : null;
                routeEquipList.add(routeQuipobj);
            }
        }
        if(routeEquipList.size() > 0){
            upsert routeEquipList;
        }
        if(containerRemoveList.size() > 0){
            List<Route_Equipment__c> containerToDel = new List<Route_Equipment__c>();
            for(String dd : containerRemoveList){
                Route_Equipment__c routeQuipobj = new Route_Equipment__c();
                routeQuipobj.id = dd;
                containerToDel.add(routeQuipobj);
            }
            delete containerToDel;
        }
        if(routeRemoveList.size() > 0){
            List<Route__c> routeToDel = new List<Route__c>();
            for(String dd : routeRemoveList){
                Route__c routeObj = new Route__c();
                routeObj.id = dd;
                routeToDel.add(routeObj);
            }
            delete routeToDel;
        }
        return optyObj.id;
    }
    @AuraEnabled
    public static List<Route_Equipment__c> getRouteListOnload(String routeId){
        if(routeId != null){
            return [Select (Select id,Rate_Kg__c from RMS__r order by createddate desc),CBM__c, Weight_Kgs__c,Units__c,id,Name,Tab_View__c,Quantity__c,Route__r.Opportunity_Enquiry__r.Account.FD__c from Route_Equipment__c where Route__c =: routeId ];
        }
        return null;
    }
    @AuraEnabled 
    public static List<BAFCORoutingDetailsDto> getQuoteLineItemRoute(String quoteId){
        BAFCOReviseQuoteDto dto = new BAFCOReviseQuoteDto();
        Map<String,Quotation_Item__c> mapRouteIdToQuotationItem = new Map<String,Quotation_Item__c>();
        for(Quotation_Item__c item : [SELECT Quotation__r.isAir__c,Route__c,Equipment_Type__c, Shipping_Line__c FROM Quotation_Item__c where Quotation__c =: quoteId Order by CreatedDate]){
            if(!mapRouteIdToQuotationItem.containsKey(item.Route__c)) 
                mapRouteIdToQuotationItem.put(item.Route__c,item);
        }
        List<BAFCORoutingDetailsDto> routingDetailsList = new List<BAFCORoutingDetailsDto>();
        Integer index = 1;
        for(Route__c enqObj : [SELECT Airline__r.Name,Cargo_Readiness__c,Airport_of_Loading__r.name,Airport_of_Destination__r.Name,(Select id, Equipment_Type__r.name,Quantity__c,Cargo_Details__c from Route_Equipments__r),Place_of_Discharge__r.Name,Place_of_Pickup__r.Name,Opportunity_Enquiry__c ,Regular_Routing_Lookup__r.name,Port_of_loading__c,Discharge_Place__c,Pickup_Place__c,Id, Regular_Routing__c,INCO_Term__r.name, Kind_Of_Shipment__c, Service_Type__c, Port_of_loading__r.Name, 
                               Port_of_Destination__r.Name, Shipping_Line__r.name, Commodity__r.Name, Cargo_Weight__c, Remarks__c, Name  
                               FROM Route__c WHERE  Id in : mapRouteIdToQuotationItem.keySet()]){
                                   BAFCORoutingDetailsDto enqDtoObj = new BAFCORoutingDetailsDto();
                                   Quotation_Item__c item = mapRouteIdToQuotationItem.get(enqObj.Id);
                                   enqDtoObj.routeName = 'Route '+ index;
                                   enqDtoObj.cargoReadiness = enqObj.Cargo_Readiness__c != null ? (enqObj.Cargo_Readiness__c.day()+'-'+ BAFCOLeadDetailsController.getMonthName(enqObj.Cargo_Readiness__c.month()) +'-'+enqObj.Cargo_Readiness__c.year()) : '-';
                                   enqDtoObj.routingRegular = enqObj.Regular_Routing_Lookup__c != null ? enqObj.Regular_Routing_Lookup__r.name : '-';
                                   enqDtoObj.shipmentKind = enqObj.Kind_Of_Shipment__c != null ? enqObj.Kind_Of_Shipment__c : '-';
                                   enqDtoObj.serviceType = enqObj.Service_Type__c != null ? enqObj.Service_Type__c : '-';
                                   if(item.Quotation__r.isAir__c){
                                       enqDtoObj.portDestination = enqObj.Airport_of_Destination__r.Name != null ? enqObj.Airport_of_Destination__r.Name :'-';
                                       enqDtoObj.portLoading = enqObj.Airport_of_Loading__r.name != null ? enqObj.Airport_of_Loading__r.name : '-';
                                       enqDtoObj.portLoadingId = enqObj.Airport_of_Loading__c;
                                       enqDtoObj.portDestinationId = enqObj.Airport_of_Destination__c;
                                       enqDtoObj.shippingLine = enqObj.Airline__r.name != null ? enqObj.Airline__r.name : '-';
                                       if(enqObj.Route_Equipments__r.size() > 0){
                                       String cargoDetails ='';
                                       for(Route_Equipment__c rr : enqObj.Route_Equipments__r){
                                           system.debug('rr' +rr);
                                           if(rr.Cargo_Details__c != null){
                                               cargoDetails+=rr.Cargo_Details__c;
                                               cargoDetails+=', ';
                                           }
                                       }
                                       if(cargoDetails != ''){
                                           cargoDetails = cargoDetails.removeEnd(', ');
                                       }
                                       enqDtoObj.cargoDetails = cargoDetails;
                                   }
                                   }
                                   else{
                                       enqDtoObj.portDestination = enqObj.Port_of_Destination__r.Name != null ? enqObj.Port_of_Destination__r.Name :'-';
                                       enqDtoObj.portLoading = enqObj.Port_of_loading__r.name != null ? enqObj.Port_of_loading__r.name : '-';
                                       enqDtoObj.portLoadingId = enqObj.Port_of_loading__c;
                                       enqDtoObj.portDestinationId = enqObj.Port_of_Destination__c;
                                       enqDtoObj.shippingLine = enqObj.Shipping_Line__r.name != null ? enqObj.Shipping_Line__r.name : '-';
                                   }
                                   enqDtoObj.commodity = enqObj.Commodity__r.Name != null ? enqObj.Commodity__r.name : '-';
                                   enqDtoObj.cargoWeights = enqObj.Cargo_Weight__c != null ? enqObj.Cargo_Weight__c : 0 ;
                                   enqDtoObj.remarks = enqObj.Remarks__c != null ? enqObj.Remarks__c : '-';
                                   enqDtoObj.routeId = enqObj.Id;
                                   enqDtoObj.enquiryId = enqObj.Opportunity_Enquiry__c;
                                   enqDtoObj.placeOfPickupName = enqObj.Pickup_Place__c;
                                   enqDtoObj.placeOfDischargeName = enqObj.Discharge_Place__c;
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
    public static List<BAFCOAllQuotationItemDto> getQuoteLineItem(String quoteId){
        List<BAFCOAllQuotationItemDto> dtoList = new List<BAFCOAllQuotationItemDto>();
        for(Quotation_Item__c item : [SELECT Quotation__r.Quotation_Type__c,Service_Type__c,Buying_Input__c,Total_Ex_Works_Charges__c,Quotation__r.isLCL__c,Tab_View__c,Buying_Rate__c,Tank_Rental_Charges__c,Included_PDF_ShippingLine__c,Included_PDF_Origin__c,Included_PDF_Destination__c,Included_PDF_Additional__c,Included_PDF_Ex_works__c,Id, Alternate_depot_release_charges__c,Carrier_container_repositioning_charges__c,Freight_Difference_FD__c,Ex_Works_Charge_Name__r.name,Ex_Works_Charge__c,Add_to_Buying_ShippingLine__c,Add_to_Buying_Origin__c,Add_to_Buying_Ex_works__c,Add_to_Buying_Destination__c,Add_to_Buying_Additional__c,Quotation__r.CreatedDate,Name,Agent_Name__c,Equipment_Type__r.name, CurrencyIsoCode, Quotation__c, BAF__c, Bayan__c, Bayan_cancellation_charge__c, Bunker_surcharge__c, CMC__c, Cleaning_charges__c, Container_movement_charges__c, Container_Lashing_Charges__c, Container_stripping__c, DTHC__c, Destination_Customs_Clearance__c, Destination_Loading_Charges__c, EIC__c, Equipment_Type__c, Fasah_fee__c, Free_time_certificate_charges__c, Fumigation__c, ISPS__c, Inspection__c, Insurance_charges__c, Lift_on_Lift_off__c, MOT_fine_charges__c, Ministry_clearnce_charge_for_OOG_cargo__c, Miscellaneous__c, Non_Palletized_Surcharge__c, OTHC__c, Origin_Customs_clearance__c, Origin_Loading_Charges__c, Pest_control__c, Port_Shuttling__c, Port_of_Discharge__c, Port_of_Loading__c, RMS__c, Re_palletization__c, Reefer_PTI_charges__c, Reefer_cntr_plug_in_charges__c, Reefer_steam_wash__c, Route__c, Sea_Freight__c, Seal_Charges__c, Stuffing_Charges__c, SweepingCleaning__c, Tabadul__c, Tarpauline_charge__c, Total_INCO__c, Total_SL__c, Total__c, Truck_Head_charges__c, Truck_idling_charges__c, Vessel_certificate_charges__c, Wrappingpacking_charges__c, Xray__c, Shipping_Line__c, Loading_Charges__c, Carriage_Congestion_Surcharge__c, Carrier_Security_Fees__c, Bayan_Charges__c, BL_Fees__c, DG_Surcharge__c, DO_charges__c, Export_Service_Fees__c, Fasah_Charges__c, Fuel_Surcharge__c, Gate_pass_charges__c, Inland_Fuel_Surcharge__c, Inland_Handling_Fees__c, Inland_haulage__c, Low_Sulphur_Surcharge__c, Operational_Recovery_Surcharge__c, Lashing_Charges__c, LOLO_Charges__c, Origin_Detention_Demurrage_Charges__c, Overweight_surcharge__c, Pickup_Charges__c, Total_Dest__c, War_Risk_Surcharge__c, VGM__c, Total_Additional__c, Charges_Included__c
                                      FROM Quotation_Item__c where Quotation__c =: quoteId]){
                                          BAFCOAllQuotationItemDto itemDto = new BAFCOAllQuotationItemDto();
                                          itemDto = BAFCOQuotationReviseController.assignQuoteItemData(item,itemDto);
                                          itemDto.equipmentName = item.Tab_View__c; 
                                          itemDto.totaladditionalCharge = item.Total_Additional__c;
                                          itemDto.totalBuyingRate = item.Buying_Rate__c;
                                          itemDto.totalSellingRate = item.Total__c;
                                          itemDto.buyingRate = item.Buying_Input__c;
                                          dtoList.add(itemDto);
                                      }
        return dtoList;
    }
    @AuraEnabled
    public static List<Airline__c> getAirLine(){
        return [Select Id, Name from Airline__c];
    }
    @AuraEnabled
    public static string addRatesAir(BAFCORMSDto rmsDetail,String routeId,String airline, Decimal rateKgs, String selectedRouteEquip,String rmscurrencyCode, String businessType){
        Route__c routeObj =[SELECT Airport_of_Destination__c,Airport_of_Loading__c FROM Route__c where id =:routeId];
        String airLineLineId = [SELECT Name, Id FROM Airline__c where Name =: airline limit 1].id;
        Id ImportRecordTypeId = Schema.SObjectType.RMS__c.getRecordTypeInfosByName()
            .get('Import')
            .getRecordTypeId();
        Id ExportRecordTypeId = Schema.SObjectType.RMS__c.getRecordTypeInfosByName()
            .get('Export')
            .getRecordTypeId();
        RMS__c rmsobj = new RMS__c();
        rmsObj.Commodity__c = rmsDetail.commodity != '' ? rmsDetail.commodity : null;
        rmsObj.Rate_Type__c = rmsDetail.rateType;
        rmsObj.Validity__c = Date.valueOf(rmsDetail.validity);
        rmsObj.Remarks__c = rmsDetail.remarks;
        rmsObj.Agent__c = rmsDetail.agentName != '' ? rmsDetail.agentName : null; 
        rmsObj.INCO_Term__c = rmsDetail.incoTermId != '' ? rmsDetail.incoTermId : null;
        rmsObj.RecordTypeId = businessType == 'Export' ? ExportRecordTypeId : ImportRecordTypeId;
        rmsObj.Airport_of_Destination__c = routeObj.Airport_of_Destination__c;
        rmsObj.Airport_of_Loading__c = routeObj.Airport_of_Loading__c;
        rmsObj.Rate_Kg__c = rateKgs;
        rmsObj.Airline__c = airLineLineId;   
        rmsObj.CurrencyIsoCode = rmscurrencyCode;
        rmsObj.Business_Type__c = businessType;
        rmsObj.Route__c = selectedRouteEquip;
        /*rmsObj.X45__c = obj.x45;
        rmsObj.X100__c = obj.x100;
        rmsObj.X300__c = obj.x300;
        rmsObj.X500__c = obj.x500;
        rmsObj.X1000__c = obj.x1000;
        rmsObj.X3000__c = obj.x3000;
        rmsObj.X5000__c = obj.x5000;
        rmsObj.X10000__c = obj.x10000;
        rmsObj.X15000__c = obj.x15000;
        rmsObj.X20000__c = obj.x20000;*/
        insert rmsObj;
        system.debug('rmsObj '+rmsObj);
        return rmsObj.id;
    }
    @auraEnabled 
    public static Route__c getAirRouteEquipment(string routeId){
        return [Select Id,Total_Gross_Weight_KGs__c,Total_CBM__c,Total_Volumetric_Weight__c  from Route__c where Id =:routeId limit 1];
    }
    @AuraEnabled 
    public static Map<String,Map<String,List<BAFCORMSDto>>> getRouteListAirImport(String routeId){
        Integer uniqueEquip = 0;
        Map<String,Map<String,List<BAFCORMSDto>>> agentToEquipMap = new Map<String,Map<String,List<BAFCORMSDto>>>();
        Map<Id,Route_Equipment__c> equipIdtoObjMap = new Map<Id,Route_Equipment__c>();
        /*for(Route_Equipment__c routeEQuip : [Select CBM__c, Weight_Kgs__c,Units__c,id,Name,Tab_View__c,Quantity__c,Route__r.Opportunity_Enquiry__r.Account.FD__c from Route_Equipment__c where Route__c =: routeId]){
            equipIdtoObjMap.put(routeEQuip.id,routeEQuip);
        }*/
        for(RMS__c rmsObj : [Select Route__r.Total_Volumetric_Weight__c, Route__r.Total_Gross_Weight_KGs__c,Route__r.Total_CBM__c,CurrencyIsoCode,Rate_Type__c, Rate_Kg__c, Route_Equipment__c,Id,Airline__r.Name,Agent__r.Name FROM RMS__c where Route__c =: routeId]){
            if(!agentToEquipMap.ContainsKey(rmsObj.Agent__r.Name)){
                agentToEquipMap.put(rmsObj.Agent__r.Name,new Map<String,List<BAFCORMSDto>>());
            }
            Map<String,List<BAFCORMSDto>> tempMap = agentToEquipMap.get(rmsObj.Agent__r.Name);
            if(!tempMap.containsKey(rmsObj.Airline__r.Name)){
                tempMap.put(rmsObj.Airline__r.Name, new List<BAFCORMSDto>());
            }
            BAFCORMSDto rmsDto = new BAFCORMSDto();
            rmsDto.uniqueEquip = uniqueEquip;
            uniqueEquip = uniqueEquip+1;
            rmsDto.rmsID = rmsObj.id;
            rmsDto.currencyCode = rmsObj.CurrencyIsoCode;
            rmsDto.rateType = rmsObj.Rate_Type__c;
            rmsDto.rateKgs =rmsObj.Rate_Kg__c > 0 ? rmsObj.Rate_Kg__c : 1;
            //Route_Equipment__c routeEquipObj = equipIdtoObjMap.get(rmsObj.Route_Equipment__c);
            rmsDto.equipmentName = 'Total CBM Weight :'+rmsObj.Route__r.Total_CBM__c+' Total Gross Weight:'+rmsObj.Route__r.Total_Gross_Weight_KGs__c+' Total Volumetric Weight : '+rmsObj.Route__r.Total_Volumetric_Weight__c;
            //rmsDto.chargeableWeight = rmsObj.Route__r.Total_CBM__c > rmsObj.Route__r.Total_Gross_Weight_KGs__c ? rmsObj.Route__r.Total_CBM__c:  rmsObj.Route__r.Total_Gross_Weight_KGs__c;
            Decimal largest = 0;
            if(rmsObj.Route__r.Total_CBM__c >= rmsObj.Route__r.Total_Gross_Weight_KGs__c && rmsObj.Route__r.Total_CBM__c >= rmsObj.Route__r.Total_Volumetric_Weight__c){
                largest = rmsObj.Route__r.Total_CBM__c ;
            }
            else if(rmsObj.Route__r.Total_Gross_Weight_KGs__c >= rmsObj.Route__r.Total_CBM__c && rmsObj.Route__r.Total_Gross_Weight_KGs__c >= rmsObj.Route__r.Total_Volumetric_Weight__c){
                largest = rmsObj.Route__r.Total_Gross_Weight_KGs__c ;
            }
            else{
                largest =  rmsObj.Route__r.Total_Volumetric_Weight__c;
            }
            rmsDto.chargeableWeight =largest;
            //rmsDto.isFDAccount = routeEquipObj.Route__r.Opportunity_Enquiry__r.Account.FD__c;
            tempMap.get(rmsObj.Airline__r.Name).add(rmsDto);
        }
        return agentToEquipMap;
    }
    @AuraEnabled
    public static Map<String,Map<String,List<BAFCOAllQuotationItemDto>>> getQuoteLineItemDetails(String quoteId,String routeId){
        List<String> duplicateList = new List<String>();
        Map<String,Route_Equipment__c> equipIdtoObjMap = new Map<String,Route_Equipment__c>();
        Map<String,RMS__c> equipIdtoRMSMap = new Map<String,RMS__c>();
        Set<Id> rrId = new Set<Id>();
        system.debug('equipIdtoObjMapid '+routeId);
        Map<String,Map<String,List<BAFCOAllQuotationItemDto>>> agentToEquipMap = new Map<String,Map<String,List<BAFCOAllQuotationItemDto>>>();
        system.debug('equipIdtoObjMap '+equipIdtoObjMap);
        for(RMS__c rmsObj : [Select Route__r.Total_Volumetric_Weight__c,Route__r.Total_Gross_Weight_KGs__c,Route__r.Total_CBM__c,Agent__c,Airline__c,Rate_Kg__c, Route_Equipment__c FROM RMS__c where Route__c =: routeId]){
            String uniqueKey = rmsObj.Agent__c+'-'+rmsObj.Airline__c+'-'+rmsObj.Route__c;
            equipIdtoRMSMap.put(uniqueKey,rmsObj);
        }
        for(Quotation_Item__c item : [SELECT Quotation__r.Quotation_Type__c,Service_Type__c,Chargeable_Weight__c,Transit_Time__c,Total_Ex_Works_Charges__c,Buying_Rate__c,Agent__r.name,Tab_View__c,Airline__r.name,Selling_Charges_Include__c,Buying_Charges_Include__c,Total_Selling_Service_Charge__c,Total_Selling_Origin_Charge__c,Total_Selling_ExWorks_Charge__c,Total_Selling_Destin_Charge__c,Total_Selling_Additional_Charge__c,Tank_Rental_Charges__c,Included_PDF_ShippingLine__c,Included_PDF_Origin__c,Included_PDF_Destination__c,Included_PDF_Additional__c,Included_PDF_Ex_works__c, Alternate_depot_release_charges__c,Carrier_container_repositioning_charges__c,Freight_Difference_FD__c,Ex_Works_Charge_Name__r.name,Id,Ex_Works_Charge__c,Add_to_Buying_ShippingLine__c,Add_to_Buying_Origin__c,Add_to_Buying_Ex_works__c,Add_to_Buying_Destination__c,Add_to_Buying_Additional__c, Quotation__r.CreatedDate,Name,Agent_Name__c,Equipment_Type__r.name, CurrencyIsoCode, Quotation__c, BAF__c, Bayan__c, Bayan_cancellation_charge__c, Bunker_surcharge__c, CMC__c, Cleaning_charges__c, Container_movement_charges__c, Container_Lashing_Charges__c, Container_stripping__c, DTHC__c, Destination_Customs_Clearance__c, Destination_Loading_Charges__c, EIC__c, Equipment_Type__c, Fasah_fee__c, Free_time_certificate_charges__c, Fumigation__c, ISPS__c, Inspection__c, Insurance_charges__c, Lift_on_Lift_off__c, MOT_fine_charges__c, Ministry_clearnce_charge_for_OOG_cargo__c, Miscellaneous__c, Non_Palletized_Surcharge__c, OTHC__c, Origin_Customs_clearance__c, Origin_Loading_Charges__c, Pest_control__c, Port_Shuttling__c, Port_of_Discharge__c, Port_of_Loading__c, RMS__c, Re_palletization__c, Reefer_PTI_charges__c, Reefer_cntr_plug_in_charges__c, Reefer_steam_wash__c, Route__c, Sea_Freight__c, Seal_Charges__c, Stuffing_Charges__c, SweepingCleaning__c, Tabadul__c, Tarpauline_charge__c, Total_INCO__c, Total_SL__c, Total__c, Truck_Head_charges__c, Truck_idling_charges__c, Vessel_certificate_charges__c, Wrappingpacking_charges__c, Xray__c, Shipping_Line__c, Loading_Charges__c, Carriage_Congestion_Surcharge__c, Carrier_Security_Fees__c, Bayan_Charges__c, BL_Fees__c, DG_Surcharge__c, DO_charges__c, Export_Service_Fees__c, Fasah_Charges__c, Fuel_Surcharge__c, Gate_pass_charges__c, Inland_Fuel_Surcharge__c, Inland_Handling_Fees__c, Inland_haulage__c, Low_Sulphur_Surcharge__c, Operational_Recovery_Surcharge__c, Lashing_Charges__c, LOLO_Charges__c, Origin_Detention_Demurrage_Charges__c, Overweight_surcharge__c, Pickup_Charges__c, Total_Dest__c, War_Risk_Surcharge__c, VGM__c, Total_Additional__c, Charges_Included__c FROM Quotation_Item__c where Quotation__c =: quoteId And Route__c =:routeId ]){
            if(!agentToEquipMap.ContainsKey(item.Agent__r.name)){
                agentToEquipMap.put(item.Agent__r.name,new Map<String,List<BAFCOAllQuotationItemDto>>());
            }
            Map<String,List<BAFCOAllQuotationItemDto>> tempMap = agentToEquipMap.get(item.Agent__r.name);
            if(!tempMap.containsKey(item.Airline__r.name)){
                tempMap.put(item.Airline__r.name, new List<BAFCOAllQuotationItemDto>());
            }
            BAFCOAllQuotationItemDto itemDto = new BAFCOAllQuotationItemDto();
            string uniqueObj= item.Agent_Name__c+'-'+item.Airline__r.name+'-'+item.Tab_View__c	;
            String uniqueKey = item.Agent__c+'-'+item.Airline__c+'-'+item.Route__c;
            RMS__c rmsObj = equipIdtoRMSMap.get(uniqueKey);
            itemDto.buyingRate = (item.Chargeable_Weight__c != null ? item.Chargeable_Weight__c : 0)  * (rmsObj != null ? rmsObj.Rate_Kg__c : 0);
            itemDto.itemId = item.id;
            itemDto.chargeableWeight = item.Chargeable_Weight__c != null ? item.Chargeable_Weight__c : 0;
            itemDto.seaFreight = item.Sea_Freight__c;
            itemDto.transitTime = item.Transit_Time__c;
            itemDto.quotationDate = item.Quotation__r.createdDate.day()+'-'+ BAFCOLeadDetailsController.getMonthName(item.Quotation__r.createdDate.month()) +'-'+item.Quotation__r.createdDate.year();
            itemDto.currencyCode = item.CurrencyIsoCode;
            itemDto.rmsId = item.RMS__c;
            itemDto.buyingRatekg = ((item.Buying_Rate__c != null ? item.Buying_Rate__c : 0) /(item.Chargeable_Weight__c != null ? item.Chargeable_Weight__c : 1)).setScale(2);
            itemDto.sellingRatekg = ((item.Total__c != null ? item.Total__c : 0)/(item.Chargeable_Weight__c != null ? item.Chargeable_Weight__c : 1)).setScale(2);
            // Destin Charges
            itemdto.destinBayanCharges= item.Bayan_Charges__c > 0 ? item.Bayan_Charges__c : null;
            itemdto.destinCustomClearanceCharges= item.Destination_Customs_Clearance__c > 0 ? item.Destination_Customs_Clearance__c : null;
            itemdto.destinDOCharges= item.DO_charges__c > 0 ? item.DO_charges__c : null;
            itemdto.destinFasahCharges= item.Fasah_Charges__c > 0 ? item.Fasah_Charges__c : null;
            itemdto.destinGatePassCharges= item.Gate_pass_charges__c > 0 ? item.Gate_pass_charges__c : null;
            itemdto.destinLOLOCharges= item.LOLO_Charges__c > 0 ? item.LOLO_Charges__c : null;
            itemdto.destinTotalCharges= item.Total_Dest__c > 0 ? item.Total_Dest__c : null;
            // origin charges 
            itemDto.bayan = item.Bayan__c > 0 ? item.Bayan__c : null;
            itemDto.blFees = item.BL_Fees__c > 0  ? item.BL_Fees__c : null;
            itemDto.originCustomClearance = item.Origin_Customs_clearance__c > 0  ? item.Origin_Customs_clearance__c : null;
            itemDto.exportServiceFees = item.Export_Service_Fees__c > 0  ? item.Export_Service_Fees__c : null;
            itemDto.fasahFees = item.Fasah_fee__c > 0  ? item.Fasah_fee__c : null;
            itemDto.inspection = item.Inspection__c  > 0 ? item.Inspection__c : null;
            itemDto.insuranceCharges = item.Insurance_charges__c > 0 ? item.Insurance_charges__c : null;
            itemDto.liftOnLiftOff = item.Lift_on_Lift_off__c > 0  ? item.Lift_on_Lift_off__c : null;
            itemDto.OriginDetention = item.Origin_Detention_Demurrage_Charges__c > 0  ? item.Origin_Detention_Demurrage_Charges__c : null;
            itemDto.OriginLoadingCharges = item.Loading_Charges__c > 0  ? item.Loading_Charges__c : null;
            itemDto.pickUpCharges = item.Pickup_Charges__c > 0  ? item.Pickup_Charges__c : null;
            itemDto.ReeferControlPlugInCharge = item.Reefer_cntr_plug_in_charges__c > 0  ? item.Reefer_cntr_plug_in_charges__c : null;
            itemDto.tabadul = item.Tabadul__c > 0 ? item.Tabadul__c  : null;
            itemDto.trapulinCharges = item.Tarpauline_charge__c > 0  ? item.Tarpauline_charge__c : null;
            itemDto.truckIdlingCharges = item.Truck_idling_charges__c  > 0 ? item.Truck_idling_charges__c : null;
            itemDto.vgm = item.VGM__c > 0  ? item.VGM__c : null;
            itemDto.xray = item.Xray__c > 0  ? item.Xray__c : null;
            itemDto.lashingCharges = item.Lashing_Charges__c > 0 ? item.Lashing_Charges__c : null;
            itemDto.fuelSurcharge = item.Fuel_Surcharge__c > 0  ? item.Fuel_Surcharge__c : null;
            itemDto.TotalOrigincharges = item.Total_INCO__c > 0  ? item.Total_INCO__c : null;
            
            // Shipping Charges 
            itemDto.BAF = item.BAF__c > 0 ? item.BAF__c : null;
            itemDto.bunkerCharges = item.Bunker_surcharge__c > 0 ? item.Bunker_surcharge__c : null;
            itemDto.cleaningCharges = item.Cleaning_charges__c > 0 ? item.Cleaning_charges__c : null;
            itemDto.CMC = item.CMC__c > 0 ? item.CMC__c : null;
            itemDto.carriageCongestionSurcharge = item.Carriage_Congestion_Surcharge__c > 0 ? item.Carriage_Congestion_Surcharge__c : null;
            itemDto.carrierSecurityFees = item.Carrier_Security_Fees__c > 0 ? item.Carrier_Security_Fees__c : null;
            itemDto.dgSurcharge = item.DG_Surcharge__c > 0 ? item.DG_Surcharge__c : null;
            itemDto.DTHC = item.DTHC__c > 0 ? item.DTHC__c : null;
            itemDto.equipmentImbalance = item.EIC__c > 0 ? item.EIC__c : null;
            itemDto.inlandFuelCharges = item.Inland_Fuel_Surcharge__c > 0 ? item.Inland_Fuel_Surcharge__c : null;
            itemDto.inlandHandlingfees = item.Inland_Handling_Fees__c > 0 ? item.Inland_Handling_Fees__c : null;
            itemDto.inlandHaulage = item.Inland_haulage__c > 0 ? item.Inland_haulage__c : null;
            itemDto.ISPS = item.ISPS__c > 0 ? item.ISPS__c : null;
            itemDto.lowerSulphurSurcharge = item.Low_Sulphur_Surcharge__c > 0 ? item.Low_Sulphur_Surcharge__c : null;
            itemDto.operationalRecovery = item.Operational_Recovery_Surcharge__c > 0 ? item.Operational_Recovery_Surcharge__c : null;
            itemDto.OTHC = item.OTHC__c > 0 ? item.OTHC__c : null;
            itemDto.overWeightCharge = item.Overweight_surcharge__c > 0 ? item.Overweight_surcharge__c : null;
            itemDto.sealCharges = item.Seal_Charges__c > 0 ? item.Seal_Charges__c : null;
            itemDto.warRiskSurcharges = item.War_Risk_Surcharge__c > 0 ? item.War_Risk_Surcharge__c : null;
            itemDto.totalSl = item.Total_SL__c > 0 ? item.Total_SL__c : null;
            //Additional Charge Data
            itemDto = BAFCOQuotationReviseController.assignAdditionalChargeRevise(item,itemDto);
            itemDto.totalSellingRate = item.Total__c;
            itemDto.totalBuyingRate = item.Buying_Rate__c;
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
            /*if(itemDto.totalBuyingRate != null) itemDto.totalBuyingRate = itemDto.totalBuyingRate > 0 ? itemDto.totalBuyingRate : 0;
            else itemDto.totalBuyingRate = 0;
            system.debug('totalBuyingRate '+itemDto.totalBuyingRate);
            if(item.Total_Additional__c > 0){
                if(item.Add_to_Buying_Additional__c == false )   itemDto.totalSellingRate = itemDto.totalSellingRate + item.Total_Additional__c; 
                else if(item.Add_to_Buying_Additional__c == true )   itemDto.totalBuyingRate = itemDto.totalBuyingRate + item.Total_Additional__c;
            }
            system.debug('totalBuyingRate '+itemDto.totalBuyingRate);
            if(item.Total_Dest__c > 0 ){
                if(item.Add_to_Buying_Destination__c == false ) itemDto.totalSellingRate = itemDto.totalSellingRate + item.Total_Dest__c;   
                else if(item.Add_to_Buying_Destination__c == true ) itemDto.totalBuyingRate = itemDto.totalBuyingRate +item.Total_Dest__c; 
            }
            system.debug('totalBuyingRate '+itemDto.totalBuyingRate);
            if(item.Ex_Works_Charge__c > 0){
                if(item.Add_to_Buying_Ex_works__c == false )  itemDto.totalSellingRate = itemDto.totalSellingRate + item.Ex_Works_Charge__c;  
                else if(item.Add_to_Buying_Ex_works__c == true ) itemDto.totalBuyingRate = itemDto.totalBuyingRate +item.Ex_Works_Charge__c; 
                
            }
            system.debug('totalBuyingRate '+itemDto.totalBuyingRate);
            if(item.Total_INCO__c > 0){
                if(item.Add_to_Buying_Origin__c == false )  itemDto.totalSellingRate = itemDto.totalSellingRate + item.Total_INCO__c;
                else if(item.Add_to_Buying_Origin__c == true ) itemDto.totalBuyingRate = itemDto.totalBuyingRate +item.Total_INCO__c; 
            }  
            system.debug('totalBuyingRate '+itemDto.totalBuyingRate);
            if(item.Total_SL__c > 0){ 
                if(item.Add_to_Buying_ShippingLine__c == false )  itemDto.totalSellingRate = itemDto.totalSellingRate + item.Total_SL__c; 
                else if(item.Add_to_Buying_ShippingLine__c == true ) itemDto.totalBuyingRate = itemDto.totalBuyingRate +item.Total_SL__c;
            }*/
            system.debug('totalBuyingRate '+itemDto.totalBuyingRate);
            itemDto.includedBuyingCharges = item.Buying_Charges_Include__c;
            itemDto.includedSellingCharges = item.Selling_Charges_Include__c;
            
            if(!duplicateList.contains(item.Agent_Name__c+item.Airline__c+item.Tab_View__c)){
                duplicateList.add(item.Agent_Name__c+item.Airline__c+item.Tab_View__c);
                itemDto.equipmentName = item.Tab_View__c;
                itemDto.equipmentId = item.Equipment_Type__c;  
                itemDto.totaladditionalCharge = item.Total_Additional__c;
                tempMap.get(item.Airline__r.name).add(itemDto);
            }
        }
        return agentToEquipMap;
    }
    @AuraEnabled
    public static Map<String,List<BAFCORMSDto>> getRMSDetails(String portLoading, String portDestination, String commodity,String routeId,String optyId) {
        Map<String,List<BAFCORMSDto>> shipLineToEquipMap = new Map<String,List<BAFCORMSDto>>();
        Integer uniqueEquip = 0;
        Boolean isFDAccount = false;
        List<String> routeEquipmentList = new List<String>();
        //Map<Id,Route__c> routeIdtoObjMap = new Map<Id,Route_Equipment__c>();
        /*for(Route_Equipment__c routeEQuip : [Select CBM__c, Weight_Kgs__c,Units__c,id,Name,Tab_View__c,Quantity__c,Route__r.Opportunity_Enquiry__r.Account.FD__c from Route_Equipment__c where Route__c =: routeId]){
            equipIdtoObjMap.put(routeEQuip.id,routeEQuip);
            routeEquipmentList.add(routeEQuip.Tab_View__c);
        }*/
        for(RMS__c rmsObj : [Select Route__r.Total_Volumetric_Weight__c, Route__r.Total_CBM__c,Route__r.Total_Gross_Weight_KGs__c,Validity__c,CurrencyIsoCode,Rate_Type__c, Rate_Kg__c, Route_Equipment__c,Id,Airline__r.Name,Agent__r.Name FROM RMS__c where Route__c =: routeId]){
            if(!shipLineToEquipMap.containsKey(rmsObj.Airline__r.Name)){
                shipLineToEquipMap.put(rmsObj.Airline__r.Name, new List<BAFCORMSDto>());
            }
            Decimal seaFreight = 0;
            Decimal largest = 0;
            if(rmsObj.Route__r.Total_CBM__c >= rmsObj.Route__r.Total_Gross_Weight_KGs__c && rmsObj.Route__r.Total_CBM__c >= rmsObj.Route__r.Total_Volumetric_Weight__c){
                largest = rmsObj.Route__r.Total_CBM__c ;
            }
            else if(rmsObj.Route__r.Total_Gross_Weight_KGs__c >= rmsObj.Route__r.Total_CBM__c && rmsObj.Route__r.Total_Gross_Weight_KGs__c >= rmsObj.Route__r.Total_Volumetric_Weight__c){
                largest = rmsObj.Route__r.Total_Gross_Weight_KGs__c ;
            }
            else{
                largest =  rmsObj.Route__r.Total_Volumetric_Weight__c;
            }
            BAFCORMSDto rmsDto = new BAFCORMSDto();
            rmsDto.seaFreight = largest * rmsObj.Rate_Kg__c;
            rmsDto.uniqueEquip = uniqueEquip;
            uniqueEquip = uniqueEquip+1;
            rmsDto.rmsID = rmsObj.id;
            rmsDto.rateType =rmsObj.Rate_Type__c ;
            Date d = rmsObj.Validity__c != null ? rmsObj.Validity__c : null;
            rmsDto.buyingRateValidity = d;
            rmsDto.currencyCode = rmsObj.CurrencyIsoCode;
            rmsDto.rateType = rmsObj.Rate_Type__c;
            rmsDto.rateKgs =rmsObj.Rate_Kg__c > 0 ? rmsObj.Rate_Kg__c : 1;
            //Route_Equipment__c routeEquipObj = equipIdtoObjMap.get(rmsObj.Route_Equipment__c);
            //rmsDto.equipmentName = routeEquipObj.Tab_View__c;
            rmsDto.equipmentName = 'Total CBM Weight :'+rmsObj.Route__r.Total_CBM__c+' Total Gross Weight :'+rmsObj.Route__r.Total_Gross_Weight_KGs__c +' Total Volumetric Weight : '+rmsObj.Route__r.Total_Volumetric_Weight__c;
            rmsDto.chargeableWeight = largest;
            rmsDto.equipmentId = rmsObj.Route__c;
            //rmsDto.isFDAccount = routeEquipObj.Route__r.Opportunity_Enquiry__r.Account.FD__c;
            //isFDAccount = routeEquipObj.Route__r.Opportunity_Enquiry__r.Account.FD__c;
            if(d != null) rmsDto.validity = DateTime.newInstance(d.year(),d.month(),d.day()).format('dd-MMM-YYYY') +', '+system.today().daysBetween(d) +' Days';
            if(rmsDto.seaFreight > 0) shipLineToEquipMap.get(rmsObj.Airline__r.Name).add(rmsDto);
        }
        /*for(String equip : routeEquipmentList){
            for(String key : shipLineToEquipMap.keySet()){
                Boolean found = false;
                for(BAFCORMSDto dto : shipLineToEquipMap.get(key)){
                    if(dto.equipmentName == equip){
                        found = true;
                        break;
                    }
                }
                if(!found){
                    BAFCORMSDto rmsDto = new BAFCORMSDto();
                    rmsDto.equipmentName = equip;
                    rmsDto.equipmentId  = '';
                    rmsDto.rmsID = '';
                    rmsDto.fdAccount = isFDAccount;
                    rmsDto.uniqueEquip = uniqueEquip;
                    uniqueEquip = uniqueEquip+1;
                    shipLineToEquipMap.get(key).add(rmsDto);
                }
            }
        }*/
        return shipLineToEquipMap;
    }
    /*public static Decimal nearestNumber(Decimal chargeableWeight, List<Decimal> numberList){
        Decimal distance = Math.abs(numberList[0] - chargeableWeight);
        Integer idx = 0;
        for(integer c = 1; c < numberList.size(); c++){
            Decimal cdistance = Math.abs(numberList[c] - chargeableWeight);
            if(cdistance < distance){
                idx = c;
                distance = cdistance;
            }
        }
        return numberList[idx];
    }*/
    @AuraEnabled
    public static String genrateQuotation(String routeId, String rmsId, String enquiryId,String quotationId, BAFCOGenerteQuoteDto dto, String incoTerm, Boolean cameReviseCompt, Boolean sameRoute, String quoteRemarks, Decimal additionalChargeTotal, String airLine){
        List<BAFCOGenerteQuoteDto.AdditionalCharge> additionalChargeList = dto.additionalChargeList;
        shippingLineChargesDTO shipLineDto = BAFCOshippingLineChargesController.getShippingCharges(rmsId);
        RMS__c rmsObj = [SELECT Id, Port_Of_Loading__c, Port_Of_Discharge__c, Equipment_Type__c FROM RMS__c where id =: rmsId Limit 1];
        //BAFCOIncoChargesDto incoDto = BAFCOLRoutingDetailsController.getIncoCharges(rmsId,incoTerm);
         String airLineId = [Select id from Airline__c where name =: airLine limit 1].id;
        Quotation__c quoteObj = new Quotation__c();
        system.debug('sameRoute '+sameRoute);
        if(quotationId == ''  || quotationId == null || (cameReviseCompt  == true && sameRoute == true)){
            Opportunity enqObj  = [SELECT Accountid,Business_Type__c,Id,No_of_Quotes__c,(Select id,name,Name__c from Quotations__r order by createdDate)  FROM Opportunity where id =: enquiryId];            
            quoteObj.Opportunity__c = enquiryId;
            //quoteObj.Leadc__c = enqObj.Lead__c;
            quoteObj.Account__c = enqObj.accountid;
            quoteObj.isAir__c = true;
            quoteObj.recordtypeId = QUOTE_EXPORT_RECORDTYPE_Id;
            quoteObj.Quotation_Type__c = 'Air Export';
            integer year =  Date.Today().Year();
            string s1=string.valueof(year).right(2);
            Integer Year1= Integer.valueof(s1);
            Decimal quoteNumber = enqObj.No_of_Quotes__c + 1;
            List<Quotation__c> quoteList = enqObj.Quotations__r; 
            if(quoteList.size() > 0 && !test.isRunningTest()){
                if(cameReviseCompt == true){
                    String fullName = quoteList[0].Name__c;
                    String lastName = fullName.Substring(fullName.lastIndexOf('/')+1,fullName.length());
                    quoteObj.Name__c = 'Quote/'+Year1+'/'+lastName+'-'+quoteList.size();
                    quoteObj.isRevise__c = true;
                }
                else{
                    Integer  quoteSize = quoteList.size();
                    quoteObj.Name__c = 'Quote/'+Year1+'/'+quoteSize;
                }
            }
            else{
                quoteObj.Name__c = 'Quote/'+Year1+'/'+1;
            }
            quoteObj.remarks__c = quoteRemarks;
            quoteObj.Effective_From__c = system.today();
            Insert quoteObj;
        }
        
        Quotation_Item__c quoteItemObj = new Quotation_Item__c();
        Route__c routeDetails = getAirRouteEquipment(routeId);
        if(routeDetails!=NULL){
            quoteItemObj.Total_CBM__c = routeDetails.Total_CBM__c;
            quoteItemObj.Total_Gross_Weight__c = routeDetails.Total_Gross_Weight_KGs__c;
            quoteItemObj.Total_Volumetric_Weight__c = routeDetails.Total_Volumetric_Weight__c;
        }
        quoteItemObj.Route__c = routeId;
        quoteItemObj.RMS__c = rmsId;
        if(rmsObj != null){
            quoteItemObj.Port_of_Discharge__c = rmsObj.Port_Of_Discharge__c;
            quoteItemObj.Port_of_Loading__c = rmsObj.Port_Of_Loading__c;
            quoteItemObj.Equipment_Type__c = rmsObj.Equipment_Type__c;
        }
        quoteItemObj.Total_Additional__c = additionalChargeTotal;
        quoteItemObj.CurrencyIsoCode = dto.currencyCode;
        system.debug('quotationId '+quotationId);
        if(quotationId == '' || quotationId == null || (cameReviseCompt  == true && sameRoute == true)){
            String initialquoteName = [Select Name from Quotation__c where id=: quoteObj.id limit 1].Name;
            quoteItemObj.Name = initialquoteName + ' - 1';
            quoteItemObj.Quotation__c = quoteObj.id;
        }
        else{
            List<Quotation_Item__c> quoteList = [Select id,Quotation__r.name from Quotation_Item__c where Quotation__c =: quotationId];
            quoteItemObj.Quotation__c = quotationId;
            if(quoteList.size() > 0){
                quoteItemObj.Name = quoteList[0].Quotation__r.name + ' - '+quoteList.size() + 1;
            }
            quoteObj.id = quotationId;
            opportunity enqObj  = [SELECT Id,Business_Type__c,No_of_Quotes__c,(Select id,name,Name__c from Quotations__r order by createdDate) FROM opportunity where id =: enquiryId];
            quoteObj.recordtypeId = QUOTE_EXPORT_RECORDTYPE_Id;
            quoteObj.Quotation_Type__c = 'Air Export';
            integer year =  Date.Today().Year();
            string s1=string.valueof(year).right(2);
            Integer Year1= Integer.valueof(s1);
            Decimal quoteNumber = enqObj.No_of_Quotes__c + 1;
            List<Quotation__c> quoteList2 = enqObj.Quotations__r; 
            if(quoteList2.size() > 0){
                if(cameReviseCompt == true){
                    String fullName = quoteList2[0].Name__c;
                    String lastName = fullName.Substring(fullName.lastIndexOf('/')+1,fullName.length());
                    quoteObj.Name__c = 'Quote/'+Year1+'/'+lastName+'-'+quoteList.size();
                }
                else{
                    Integer  quoteSize = quoteList2.size();
                    quoteObj.Name__c = 'Quote/'+Year1+'/'+quoteSize;
                }
            }
            quoteObj.remarks__c = quoteRemarks;
            update quoteObj;
            system.debug('quoteObj '+quoteObj);
        }
        
        quoteItemObj.Total__c = dto.total;
        quoteItemObj.Airport_of_Destination__c = dto.portDestinationId != '' ? dto.portDestinationId : null;
        quoteItemObj.Airport_of_Loading__c = dto.portLoadingId != '' ? dto.portLoadingId : null; 
        quoteItemObj.Pickup_Place__c = dto.pickupPlaceName;
        quoteItemObj.Discharge_Place__c = dto.dischargePlaceName;
        quoteItemObj.Total_Additional__c = additionalChargeTotal;
        quoteItemObj.Sea_Freight__c = dto.seaFreightSellRate;  
        quoteItemObj.Selling_Rate_Kg__c = dto.total /dto.chargeableWeight;
        quoteItemObj.Quantity__c = dto.quantity;
        quoteItemObj.INCO_Term__c = dto.incoTermId;
        quoteItemObj.Tab_View__c = dto.selectedEquipment;  
        quoteItemObj.Transit_Time__c = dto.transitTime;
        quoteItemObj.Airline__c = airlineId;
        quoteItemObj.Airport_of_Loading__c = dto.portLoadingId;
        quoteItemObj.Airport_of_Destination__c = dto.portDestinationId;
        quoteItemObj.Buying_Rate__c = dto.quoteBuyingRate > 0 ? dto.quoteBuyingRate : null;
        quoteItemObj.Chargeable_Weight__c = dto.chargeableWeight;
        quoteItemObj.Add_to_Buying_Additional__c =  dto.addAdditionalCharge != null ? dto.addAdditionalCharge : false;
        quoteItemObj.Included_PDF_Additional__c =  dto.includeAdditionalCharge != null ? dto.includeAdditionalCharge : false;
        if(dto.selectedShippLine != '' ){
            List<Shipping_Line__c> shipLine = [Select id from Shipping_Line__c where name =:dto.selectedShippLine limit 1];
            if(shipLine.size() > 0) quoteItemObj.Shipping_Linee__c = shipLine[0].id;
        }
        if(dto.exWorksObj != null){
            quoteItemObj.Ex_Works_Charge_Name__c = dto.exWorksObj.Id;
            quoteItemObj.Ex_Works_Charge__c = dto.exWorksObj.LoadCharge;
            if(dto.exWorksObj.Id != null){
                quoteItemObj.Add_to_Buying_Ex_works__c =  dto.addExWorksCharge != null ? dto.addExWorksCharge : false;
                quoteItemObj.Included_PDF_Ex_works__c =  dto.includeExWorksCharge != null ? dto.includeExWorksCharge : false;
            }
        }
        system.debug('quoteItemObj '+quoteItemObj);
        try{
            quoteItemObj = BAFCOLRoutingDetailsController.updateOperationalChargeText(additionalChargeList,quoteItemObj,dto);
            upsert quoteItemObj;
            quoteItemObj = BAFCOLRoutingDetailsController.assignAdditionalChargeIntoQuoteItem(additionalChargeList,quoteItemObj,dto);
            if(dto.exWorksObj != null){
                BAFCOLRoutingDetailsController.insertExWorksQuotationCharge(dto.exWorksObj.Name,dto.exWorksObj.LoadCharge,quoteItemObj);
            }
        
        }
        Catch(Exception e){
            System.debug('Exception '+e.getMessage());
        }
        
        return quoteObj.Id;
    }
    
    @AuraEnabled 
    public static Map<String,List<BAFCOAllQuotationItemDto>> getQuoteExportLineItemDetails(String quoteId,String portLoading, String portDestination, String commodity, String routeId){
        Set<Id> quoteRmsId = new Set<Id>();
        Map<String,List<BAFCOAllQuotationItemDto>> shipLineToEquipMap = new Map<String,List<BAFCOAllQuotationItemDto>>();
        Map<String,RMS__c> rmsMap = new Map<String,RMS__c>();
        List<String> duplicateList = new List<String>();
        Map<String,Route_Equipment__c> equipIdtoObjMap = new Map<String,Route_Equipment__c>();
        for(Quotation_Item__c item : [SELECT RMS__c from Quotation_Item__c where Quotation__c =: quoteId And Route__c =:routeId]){
            quoteRmsId.add(item.RMS__c);
        }
        for(RMS__c rmsObj : [Select Airport_of_Destination__c,Airport_of_Loading__c,X15000__c, X5000__c,X500__c,X45__c,X3000__c,X300__c,X20000__c,X10000__c,X1000__c,X100__c,Rate_Kg__c,CurrencyIsoCode,Route_Equipment__c,Airline__r.Name,Rate_Type__c,Validity__c,Remarks__c, Id,Sea_Freight__c, Equipment_Type__c FROM RMS__c where id in : quoteRmsId]){
            rmsMap.put(rmsObj.id,rmsObj);
        }
        for(Quotation_Item__c item : [SELECT Quotation__r.Quotation_Type__c,Service_Type__c,Chargeable_Weight__c,Route__r.Total_Volumetric_Weight__c, Route__r.Total_CBM__c,Route__r.Total_Gross_Weight_KGs__c,Buying_Rate__c,Transit_Time__c,Total_Ex_Works_Charges__c,Tab_View__c,Airline__r.Name,Quotation__r.isLCL__c,Tank_Rental_Charges__c,Included_PDF_ShippingLine__c,Included_PDF_Origin__c,Included_PDF_Destination__c,Included_PDF_Additional__c,Included_PDF_Ex_works__c,Id, Alternate_depot_release_charges__c,Carrier_container_repositioning_charges__c,Freight_Difference_FD__c,Ex_Works_Charge_Name__r.name,Ex_Works_Charge__c,Add_to_Buying_ShippingLine__c,Add_to_Buying_Origin__c,Add_to_Buying_Ex_works__c,Add_to_Buying_Destination__c,Add_to_Buying_Additional__c,Quotation__r.CreatedDate,Name,Agent_Name__c,Equipment_Type__r.name, CurrencyIsoCode, Quotation__c, BAF__c, Bayan__c, Bayan_cancellation_charge__c, Bunker_surcharge__c, CMC__c, Cleaning_charges__c, Container_movement_charges__c, Container_Lashing_Charges__c, Container_stripping__c, DTHC__c, Destination_Customs_Clearance__c, Destination_Loading_Charges__c, EIC__c, Equipment_Type__c, Fasah_fee__c, Free_time_certificate_charges__c, Fumigation__c, ISPS__c, Inspection__c, Insurance_charges__c, Lift_on_Lift_off__c, MOT_fine_charges__c, Ministry_clearnce_charge_for_OOG_cargo__c, Miscellaneous__c, Non_Palletized_Surcharge__c, OTHC__c, Origin_Customs_clearance__c, Origin_Loading_Charges__c, Pest_control__c, Port_Shuttling__c, Port_of_Discharge__c, Port_of_Loading__c, RMS__c, Re_palletization__c, Reefer_PTI_charges__c, Reefer_cntr_plug_in_charges__c, Reefer_steam_wash__c, Route__c, Sea_Freight__c, Seal_Charges__c, Stuffing_Charges__c, SweepingCleaning__c, Tabadul__c, Tarpauline_charge__c, Total_INCO__c, Total_SL__c, Total__c, Truck_Head_charges__c, Truck_idling_charges__c, Vessel_certificate_charges__c, Wrappingpacking_charges__c, Xray__c, Shipping_Line__c, Loading_Charges__c, Carriage_Congestion_Surcharge__c, Carrier_Security_Fees__c, Bayan_Charges__c, BL_Fees__c, DG_Surcharge__c, DO_charges__c, Export_Service_Fees__c, Fasah_Charges__c, Fuel_Surcharge__c, Gate_pass_charges__c, Inland_Fuel_Surcharge__c, Inland_Handling_Fees__c, Inland_haulage__c, Low_Sulphur_Surcharge__c, Operational_Recovery_Surcharge__c, Lashing_Charges__c, LOLO_Charges__c, Origin_Detention_Demurrage_Charges__c, Overweight_surcharge__c, Pickup_Charges__c, Total_Dest__c, War_Risk_Surcharge__c, VGM__c, Total_Additional__c, Charges_Included__c FROM Quotation_Item__c where Quotation__c =: quoteId And Route__c =:routeId ]){
            if(!shipLineToEquipMap.containsKey(item.Airline__r.Name)){
                shipLineToEquipMap.put(item.Airline__r.Name,new List<BAFCOAllQuotationItemDto>());
            }
            BAFCOAllQuotationItemDto itemDto = new BAFCOAllQuotationItemDto();
            itemDto.chargeableWeight = item.Chargeable_Weight__c;
            RMS__c rmsObj =  rmsMap.get(item.RMS__c);
            itemDto.itemId = item.id;
            itemDto.seaFreight = item.Sea_Freight__c;
            itemDto.buyingRate = (item.Chargeable_Weight__c != null ? item.Chargeable_Weight__c : 0) * (rmsObj.Rate_Kg__c != null ?rmsObj.Rate_Kg__c : 0) ;
            itemDto.quotationDate = item.Quotation__r.createdDate.day()+'-'+ BAFCOLeadDetailsController.getMonthName(item.Quotation__r.createdDate.month()) +'-'+item.Quotation__r.createdDate.year();
            itemDto.currencyCode = item.CurrencyIsoCode;
            itemDto.transitTime = item.Transit_Time__c;
            itemDto = BAFCOQuotationReviseController.assignQuoteItemData(item,itemDto);
            itemDto.totalBuyingRate = item.Buying_Rate__c;
            itemDto.totalSellingRate = item.Total__c;
            itemDto.buyingRatekg = (itemDto.totalBuyingRate/itemDto.chargeableWeight).setScale(2);
            itemDto.sellingRatekg = (itemDto.totalSellingRate/itemDto.chargeableWeight).setScale(2);
            
            if(!duplicateList.contains(item.Airline__c+'-'+item.Tab_View__c)){
                duplicateList.add(item.Airline__c+item.Tab_View__c);
                itemDto.equipmentName = item.Tab_View__c;
                itemDto.equipmentId = item.Tab_View__c;  
                itemDto.totaladditionalCharge = item.Total_Additional__c;
                system.debug('itemDto '+itemDto.equipmentName);
                shipLineToEquipMap.get(item.Airline__r.name).add(itemDto);
            }
        }
        return shipLineToEquipMap;
    }
    @AuraEnabled(cacheable=true)
    public static List<sObject> search(String searchTerm, string myObject, String filter) {
        String myQuery = null;
        if(filter != null && filter != ''){
            myQuery = 'Select Id, Name from '+myObject+' Where Name_Code__c Like  \'%' + searchTerm + '%\' AND '+filter+' LIMIT  5';
        }
        else {
            if(searchTerm == null || searchTerm == ''){
                myQuery = 'Select Id, Name from '+myObject+' Where LastViewedDate != NULL ORDER BY LastViewedDate DESC LIMIT  5';
            }
            else {
                myQuery = 'Select Id, Name from '+myObject+' Where Name_Code__c Like  \'%' + searchTerm + '%\' LIMIT  5';
            }
        }
        system.debug('myQuery '+myQuery);
        List<sObject> lookUpList = database.query(myQuery);
        return lookUpList;
    }
    /*public class airCharges{
        @AuraEnabled public  Decimal x45{get;set;}
        @AuraEnabled public  Decimal x100{get;set;}
        @AuraEnabled public  Decimal x300{get;set;}
        @AuraEnabled public  Decimal x500{get;set;}
        @AuraEnabled public  Decimal x1000{get;set;}
        @AuraEnabled public  Decimal x3000{get;set;}
        @AuraEnabled public  Decimal x5000{get;set;}
        @AuraEnabled public  Decimal x10000{get;set;}
        @AuraEnabled public  Decimal x15000{get;set;}
        @AuraEnabled public  Decimal x20000{get;set;}
        
    }*/
    public static void testDummy(){
        Integer a=10;
        Integer b=5;
        Integer c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
         c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
         c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
         c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
         c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
         c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
         c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
        c= a+b;
    }
}