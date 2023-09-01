public without sharing  class BAFCOLRoutingDetailsController {
    public static final Id RMS_EXPORT_RECORDTYPE_Id = Schema.SObjectType.RMS__c.getRecordTypeInfosByName()
        .get('Export')
        .getRecordTypeId();
    public static final Id RMS_IMPORT_RECORDTYPE_Id = Schema.SObjectType.RMS__c.getRecordTypeInfosByName()
        .get('Import')
        .getRecordTypeId();
    public static final Id ENQUIRY_EXPORT_RECORDTYPE_Id = Schema.SObjectType.Enquiry__c.getRecordTypeInfosByName()
        .get('Export')
        .getRecordTypeId();
    public static final Id ENQUIRY_IMPORT_RECORDTYPE_Id = Schema.SObjectType.Enquiry__c.getRecordTypeInfosByName()
        .get('Import')
        .getRecordTypeId();
    public static final Id QUOTE_EXPORT_RECORDTYPE_Id = Schema.SObjectType.quotation__c.getRecordTypeInfosByName()
        .get('Export')
        .getRecordTypeId();
    public static final Id QUOTE_IMPORT_RECORDTYPE_Id = Schema.SObjectType.quotation__c.getRecordTypeInfosByName()
        .get('Import')
        .getRecordTypeId();
    @AuraEnabled
    public static List<BAFCORoutingDetailsDto> getEnqueryDetails(String enquiryID) {
        List<BAFCORoutingDetailsDto> routingDetailsList = new List<BAFCORoutingDetailsDto>();
        List<Id> LOPIds = new List<Id>();
        List<Id> DOPIds = new List<Id>();
        Map<String,List<Route_Profit_Margin__c>> routeProfitMap = new Map<String,List<Route_Profit_Margin__c>>();
        Integer index = 1;
        List<Route__c> routeList = [SELECT Cargo_Readiness__c,Airport_of_Loading__r.name,Airport_of_Destination__r.name,Opportunity_Enquiry__r.Recordtype.Name, (Select id,Equipment_Type__r.name,Quantity__c,Cargo_Details__c from Route_Equipments__r), Place_of_Discharge__r.Name,Place_of_Pickup__r.Name,Opportunity_Enquiry__r.Account.Name,Regular_Routing_Lookup__r.name,Port_of_loading__c,Pickup_Place__c,Discharge_Place__c,Id, Regular_Routing__c,INCO_Term__r.name, Kind_Of_Shipment__c, Service_Type__c, Port_of_loading__r.Name, 
                                    Port_of_Destination__r.Name, Shipping_Line__r.name, Commodity__r.Name, Cargo_Weight__c, Remarks__c,
                                    Name,Opportunity_Enquiry__r.Business_Type__c,Opportunity_Enquiry__r.Account.FD__c,Opportunity_Enquiry__r.Account.Average_Credit_Days__c,Opportunity_Enquiry__r.Account.Best_Margin__c,Opportunity_Enquiry__r.Account.Average_Margin__c /*Enquiry__r.Account__r.Average_Margin__c,Enquiry__r.Account__r.Best_Margin__c,Enquiry__r.Account__r.Average_Credit_Days__c,Enquiry__r.Business_Type__c*/  
                                    FROM Route__c WHERE Opportunity_Enquiry__c=:enquiryID];
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
            enqDtoObj.routingRegular = enqObj.Regular_Routing_Lookup__c != null ? enqObj.Regular_Routing_Lookup__r.Name : '-';
            enqDtoObj.shipmentKind = enqObj.Kind_Of_Shipment__c != null ? enqObj.Kind_Of_Shipment__c : '-';
            enqDtoObj.serviceType = enqObj.Service_Type__c != null ? enqObj.Service_Type__c : '-';
            if(enqObj.Opportunity_Enquiry__r.Recordtype.Name == 'Air Freight'){
                enqDtoObj.isAir = true;
                enqDtoObj.portDestination = enqObj.Airport_of_Destination__r.Name != null ? enqObj.Airport_of_Destination__r.Name :'-';
                enqDtoObj.portLoading = enqObj.Airport_of_Loading__r.name != null ? enqObj.Airport_of_Loading__r.name : '-';
                enqDtoObj.portLoadingId =enqObj.Airport_of_Loading__c != null ? enqObj.Airport_of_Loading__c : null;
                enqDtoObj.portDestinationId = enqObj.Airport_of_Destination__c != null ? enqObj.Airport_of_Destination__c : null;
            }
            else{
                enqDtoObj.isAir = false;
                enqDtoObj.portDestination = enqObj.Port_of_Destination__r.Name != null ? enqObj.Port_of_Destination__r.Name :'-';
                enqDtoObj.portLoading = enqObj.Port_of_loading__r.name != null ? enqObj.Port_of_loading__r.name : '-';
                enqDtoObj.portLoadingId =enqObj.Port_of_loading__c != null ? enqObj.Port_of_loading__c : null;
                enqDtoObj.portDestinationId = enqObj.Port_of_Destination__c != null ? enqObj.Port_of_Destination__c : null;
            }
            enqDtoObj.commodity = enqObj.Commodity__r.Name != null ? enqObj.Commodity__r.name : '-';
            enqDtoObj.cargoWeights = enqObj.Cargo_Weight__c != null ? enqObj.Cargo_Weight__c : 0 ;
            enqDtoObj.cargoReadiness = enqObj.Cargo_Readiness__c != null ? (enqObj.Cargo_Readiness__c.day()+'-'+ BAFCOLeadDetailsController.getMonthName(enqObj.Cargo_Readiness__c.month()) +'-'+enqObj.Cargo_Readiness__c.year()) : '-';
            enqDtoObj.remarks = enqObj.Remarks__c != null ? enqObj.Remarks__c : '-';
            enqDtoObj.routeId = enqObj.Id;
            enqDtoObj.shippingLine = enqObj.Shipping_Line__r.name != null ? enqObj.Shipping_Line__r.name : '-';
            enqDtoObj.incoTerm = enqObj.INCO_Term__r.name != null ? enqObj.INCO_Term__r.name : '-'; 
            enqDtoObj.incoTermId = enqObj.INCO_Term__c != null ? enqObj.INCO_Term__c : null; 
            enqDtoObj.leadId =  enqObj.Opportunity_Enquiry__r.AccountId != null ? enqObj.Opportunity_Enquiry__r.AccountId :  '' ;
            enqDtoObj.acctName = enqObj.Opportunity_Enquiry__r.AccountId != null ? enqObj.Opportunity_Enquiry__r.Account.Name :  '' ;
            enqDtoObj.accountAvgMargin = enqObj.Opportunity_Enquiry__r.Account.Average_Margin__c != null ? (enqObj.Opportunity_Enquiry__r.Account.Average_Margin__c).setScale(2) : 0 ;
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
            //enqDtoObj.accountBestMargin = enqObj.Opportunity_Enquiry__r.Account.Best_Margin__c !=null ? (enqObj.Opportunity_Enquiry__r.Account.Best_Margin__c).setScale(2) : 0;
            //enqDtoObj.accountAvgCreditDays = enqObj.Opportunity_Enquiry__r.Account.Average_Credit_Days__c != null ? (enqObj.Opportunity_Enquiry__r.Account.Average_Credit_Days__c).setScale(2) : 0 ;
            enqDtoObj.placeOfPickupName = enqObj.Pickup_Place__c;
            enqDtoObj.placeOfDischargeName = enqObj.Discharge_Place__c;
            enqDtoObj.businessType = enqObj.Opportunity_Enquiry__r.Business_Type__c !=  null ? enqObj.Opportunity_Enquiry__r.Business_Type__c : '-';
            if(enqObj.Route_Equipments__r.size() > 0){
                String equipmentType ='';
                String cargoDetails = '';
                for(Route_Equipment__c rr : enqObj.Route_Equipments__r){
                    if(rr.Equipment_Type__c != null){
                        equipmentType+=rr.Equipment_Type__r.Name+' - '+ rr.Quantity__c;
                        equipmentType+=', ';
                    }
                    if(rr.Cargo_Details__c != null){
                        cargoDetails+=rr.Cargo_Details__c;
                        cargoDetails+=', ';
                    }
                    
                }
                if(equipmentType != ''){
                    equipmentType = equipmentType.removeEnd(', ');
                }
                if(cargoDetails != ''){
                    cargoDetails = cargoDetails.removeEnd(', ');
                }
                enqDtoObj.equipmentType = equipmentType;
                enqDtoObj.cargoDetails = cargoDetails;
            }
            index++;
            routingDetailsList.add(enqDtoObj);
        }
        return routingDetailsList;
    }
    @AuraEnabled
    public static Map<String,List<BAFCORMSDto>> getRMSDetails(String portLoading, String portDestination, String commodity,String routeId,String enquiryId) {
        Map<String,List<BAFCORMSDto>> shipLineToEquipMap = new Map<String,List<BAFCORMSDto>>();
        List<String> routeEquipmentList = new List<String>();
        List<String> rmsEquipmentList = new List<String>();
        Map<String,Decimal> routeEquipmentoquantityMap = new Map<String,Decimal>();
        Map<String,String>  quoteItemToIdMap = new Map<String,String>();
        String QuoteId = '';
        Date todaysDate = System.today();
        Boolean isFDAccount = false;
        Integer uniqueEquip = 0;
        String accountId = null;
        for(Route_Equipment__c routeEquip : [Select Equipment_Type__r.name,Quantity__c  FROM Route_Equipment__c WHERE Route__c=:routeId]){
            routeEquipmentList.add(routeEquip.Equipment_Type__r.name);
            routeEquipmentoquantityMap.put(routeEquip.Equipment_Type__r.name,routeEquip.Quantity__c);
        }
        system.debug('routeEquipmentList '+routeEquipmentList);
        system.debug('routeEquipmentoquantityMap '+routeEquipmentoquantityMap);
        for(RMS__c rmsObj : [Select Equipment_Type__r.Name,Equipment_Type__c  FROM RMS__c WHERE Port_Of_Loading__r.Name =: portLoading 
                             AND Port_Of_Discharge__r.Name =: portDestination
                             AND Validity__c >=: todaysDate AND recordtypeId =: RMS_EXPORT_RECORDTYPE_Id]){
                                 rmsEquipmentList.add(rmsObj.Equipment_Type__c) ; 
                             }
        system.debug('rmsEquipmentList '+rmsEquipmentList);
        // to get Previously generated Quote
        List<Quotation__c> quoteList = [SELECT Id FROM Quotation__c where Opportunity__c  =: enquiryId limit 1];
        if(quoteList.size() > 0) QuoteId = quoteList[0].Id;
        
        Opportunity opty = [Select id,Account.Fd__c from Opportunity where id =: enquiryId limit 1];
        if(opty.Account.Fd__c == true) isFDAccount = true;
        if(opty.AccountId != null) accountId = opty.AccountId;
        
        
        // to getquoteItemItem so as to update on Generate quoteItem
        if(!String.isBlank(QuoteId)){
            for(Quotation_Item__c item : [Select Equipment_Type__r.name,Shipping_Line__c,id from Quotation_Item__c  where Quotation__c =: QuoteId
                                          AND Equipment_Type__r.name != null AND Shipping_Line__c != null ]){
                                              String key = item.Shipping_Line__c+'-'+item.Equipment_Type__r.name;
                                              quoteItemToIdMap.put(key,item.Id);
                                          }
        }
        if(rmsEquipmentList.size() > 0){
            for(Route_Equipment__c routeEquip : [Select Equipment_Type__r.name,Quantity__c  FROM Route_Equipment__c WHERE Route__c=:routeId and id in : rmsEquipmentList]){
                routeEquipmentoquantityMap.put(routeEquip.Equipment_Type__r.name,routeEquip.Quantity__c);
            }        
        }
        system.debug('routeEquipmentoquantityMap '+routeEquipmentoquantityMap);
        for(RMS__c rmsObj : [Select CurrencyIsoCode,Rate_Type__c,Validity__c,Remarks__c, Id,Sea_Freight__c, Equipment_Type__c,Shipping_Line__c,Shipping_Line__r.Name,Equipment_Type__r.name  
                             FROM RMS__c WHERE Port_Of_Loading__r.Name =: portLoading 
                             AND Port_Of_Discharge__r.Name =: portDestination
                             AND Shipping_Line__r.Name != null
                             AND Equipment_Type__r.name != null
                             AND Validity__c >=: todaysDate
                             AND recordtypeId =: RMS_EXPORT_RECORDTYPE_Id
                             AND Equipment_Type__r.name in: routeEquipmentList
                             AND (Customer_Name__c =: accountId OR Customer_Name__c = null)
                             order by Equipment_Type__r.name
                            ]){
                                if(!shipLineToEquipMap.containsKey(rmsObj.Shipping_Line__r.Name)){
                                    shipLineToEquipMap.put(rmsObj.Shipping_Line__r.Name, new List<BAFCORMSDto>());
                                }
                                BAFCORMSDto rmsDto = new BAFCORMSDto();                                
                                if(routeEquipmentoquantityMap.containsKey(rmsObj.Equipment_Type__r.name)){
                                    rmsDto.quantity = routeEquipmentoquantityMap.get(rmsObj.Equipment_Type__r.name);
                                }
                                system.debug(rmsObj.Equipment_Type__r.name+'_'+rmsObj.Shipping_Line__r.name);
                                system.debug(rmsObj.Equipment_Type__c+'_'+rmsObj.Shipping_Line__c);
                                rmsDto.equipmentName = rmsObj.Equipment_Type__r.name;
                                rmsDto.equipmentId = rmsObj.Equipment_Type__c;
                                rmsDto.uniqueEquip = uniqueEquip;
                                rmsDto.currencyCode = rmsObj.CurrencyIsoCode;
                                uniqueEquip = uniqueEquip+1;
                                rmsDto.seaFreight = rmsObj.Sea_Freight__c ; 
                                rmsDto.rmsID = rmsObj.id;
                                rmsDto.rateType =rmsObj.Rate_Type__c ;
                                rmsDto.rmsRemarks = rmsObj.Remarks__c;
                                rmsDto.quotationId = QuoteId;
                                rmsDto.fdAccount = isFDAccount;
                                String key = rmsObj.Shipping_Line__r.Name+'-'+rmsObj.Equipment_Type__r.name;
                                if(quoteItemToIdMap.containsKey(key)){
                                    //rmsDto.quotationItemId = quoteItemToIdMap.get(key);  
                                }
                                Date d = rmsObj.Validity__c != null ? rmsObj.Validity__c : null;
                                rmsDto.buyingRateValidity = d;
                                if(d != null)
                                    rmsDto.validity = DateTime.newInstance(d.year(),d.month(),d.day()).format('dd-MMM-YYYY') +', '+system.today().daysBetween(d) +' Days';
                                shipLineToEquipMap.get(rmsObj.Shipping_Line__r.Name).add(rmsDto);
                            }
        for(String equip : routeEquipmentList){
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
        }
        return shipLineToEquipMap;
    }
    @AuraEnabled(cacheable=true)
    public static List<sObject> search(String searchTerm, string myObject, String filter) {
        String myQuery = null;
        if(filter != null && filter != ''){
            myQuery = 'Select Id, Name from '+myObject+' Where Name Like  \'%' + searchTerm + '%\' AND '+filter+' LIMIT  5';
        }
        else {
            if(searchTerm == null || searchTerm == ''){
                myQuery = 'Select Id, Name from '+myObject+' Where LastViewedDate != NULL ORDER BY LastViewedDate DESC LIMIT  5';
            }
            else {
                myQuery = 'Select Id, Name from '+myObject+' Where Name Like  \'%' + searchTerm + '%\' LIMIT  5';
            }
        }
        system.debug('myQuery '+myQuery);
        List<sObject> lookUpList = database.query(myQuery);
        return lookUpList;
    }
    @AuraEnabled
    public static String submitRoutingList(List<BAFCORoutingDetailsDto> routingList, String businessType, String quoteId,String closeDate, String commercialUserId,String isEdit,List<String> containerRemoveList,List<String> routeRemoveList, String optyId) {
        List<Route__c> routeList = new List<Route__c>();
        String incoTermSelected = '';
        Boolean has20ISOContainer = false;
        if(routingList.size() > 0){
            incoTermSelected = routingList[0].incoTermName;
            List<Id> containerId = new List<Id>();
            for(BAFCORoutingDetailsDto dto : routingList){
                for(BAFCORoutingDetailsDto.containerRecord contr : dto.containerRecord){
                    if(contr.containerTypeName == '20ISO') has20ISOContainer = true;
                }
            }
        }
        system.debug('incoTermSelected '+incoTermSelected);
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
            optyObj.AccountId = acc.Id ;
            optyObj.OwnerId = userObj.IsActive == true ? acc.OwnerId : userinfo.getUserId();
            optyObj.Business_Type__c = businessType;
            try{
                optyObj.StageName = 'Qualification';
                optyObj.CloseDate = date.valueOf(closeDate);
                optyObj.Commercial_User__c = commercialUserId != '' ? commercialUserId : null;
                if(incoTermSelected == 'Clearance and Delivery' || incoTermSelected == 'Local Operation') {
                    Id LocalOperationRecId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName()
                        .get('Local Operation')
                        .getRecordTypeId();
                    optyObj.RecordTypeId = LocalOperationRecId;
                    if(businessType == 'Import') optyObj.Service_Type__c = 'Local Operation Import';
                    else if(businessType == 'Export') optyObj.Service_Type__c = 'Local Operation Export';
                }
                else{
                    Id FCLRecId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName()
                        .get('FCL')
                        .getRecordTypeId();
                    optyObj.RecordTypeId = FCLRecId;
                    if(businessType == 'Import') {
                        if(has20ISOContainer == true) optyObj.Service_Type__c = 'ISO Import';
                        else optyObj.Service_Type__c = 'Sea Import';
                    }
                    else if(businessType == 'Export') {
                        if(has20ISOContainer == true) optyObj.Service_Type__c = 'ISO Export';
                        else optyObj.Service_Type__c = 'Sea Export';
                    }
                }
                try{
                    insert optyObj; 
                }
                catch(exception e){
                    system.debug('exception '+e);
                }
                
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
        for(BAFCORoutingDetailsDto dto : routingList){
            Route__c routeObj = new Route__c();
            routeObj.Cargo_Weight__c = dto.cargoWeights;
            if(!String.isBlank(dto.commodity)) routeObj.Commodity__c =dto.commodity;
            routeObj.Kind_Of_Shipment__c = 'FCL';
            routeObj.Regular_Routing__c = dto.routingRegular;
            String ObjectName = '';
            routeObj.Regular_Routing_Lookup__c = dto.routingRegular != '' ? dto.routingRegular : null;
            if(!String.isBlank(dto.shippingLine)) routeObj.Shipping_Line__c = dto.shippingLine;
            routeObj.Service_Type__c = dto.serviceType;
            if(!String.isBlank(dto.portLoading)) routeObj.Port_of_loading__c = dto.portLoading;
            if(!String.isBlank(dto.portDestination)) routeObj.Port_of_Destination__c = dto.portDestination;
            routeObj.Remarks__c = dto.remarks;
            routeObj.Dangerous_Goods__c = dto.dangerousGoods;
            routeObj.Index__c = String.valueOf(dto.leadIndex);
            if(!String.isBlank(dto.incoTerm)) routeObj.INCO_Term__c = dto.incoTerm  ;
            routeObj.Opportunity_Enquiry__c = optyObj.id;
            routeObj.DG_Class__c = dto.dgClass;
            if(!String.isBlank(dto.placeOfPickup)) routeObj.Pickup_Place__c = dto.placeOfPickup;
            if(!String.isBlank(dto.placeOfDischarge)) routeObj.Discharge_Place__c = dto.placeOfDischarge;
            if(dto.cargoReadiness != null && !String.isBlank(dto.cargoReadiness)) routeObj.Cargo_Readiness__c = Date.valueOf(dto.cargoReadiness);
            else routeObj.Cargo_Readiness__c = null;
            routeObj.id = dto.routeId !='' ? dto.routeId : null;
            routeList.add(routeObj);
        }
        if(routeList.size() > 0){
            upsert routeList;
        }        
        for(Route__c obj : routeList){
            routeIndexToIdMap.put(obj.Index__c, obj.Id);
        }
        for(BAFCORoutingDetailsDto dto : routingList){
            for(BAFCORoutingDetailsDto.containerRecord contr : dto.containerRecord){
                Route_Equipment__c routeQuipobj = new Route_Equipment__c();
                if(!String.isBlank(contr.containerType)) routeQuipobj.Equipment_Type__c = contr.containerType;
                routeQuipobj.Quantity__c = contr.quantity;
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
    public static BAFCOIncoChargesDto getIncoCharges(String rmsId, String incoTerm){
        BAFCOIncoChargesDto incoChargeDto = new BAFCOIncoChargesDto();
        if(rmsId != '' && incoTerm != ''){
            for(INCO_Charge__c obj : [Select Loading_Charges__c,Total__c,Bayan__c,/*Destination_Customs_Clearance__c,Destination_Loading_Charges__c,*/Fasah_fee__c,Inspection__c,
                                      Lift_on_Lift_off__c,Origin_Customs_clearance__c,Origin_Loading_Charges__c,Port_Shuttling__c,
                                      Tabadul__c,Xray__c
                                      FROM INCO_Charge__c WHERE RMS__c =: rmsId AND INCO_Term__r.Name =: incoTerm]){
                                          system.debug(obj.Bayan__c == null);
                                          if((obj.Bayan__c == null || obj.Bayan__c < 1) 
                                             && (obj.Fasah_fee__c == null || obj.Fasah_fee__c < 1)
                                             && (obj.Inspection__c == null || obj.Inspection__c < 1)
                                             && (obj.Lift_on_Lift_off__c == null || obj.Lift_on_Lift_off__c < 1)
                                             && (obj.Origin_Customs_clearance__c == null || obj.Origin_Customs_clearance__c < 1 )
                                             && (obj.Origin_Loading_Charges__c == null || obj.Origin_Loading_Charges__c < 1)
                                             && (obj.Port_Shuttling__c == null || obj.Port_Shuttling__c < 1)
                                             && (obj.Tabadul__c == null || obj.Tabadul__c < 1)
                                             && (obj.Xray__c == null || obj.Xray__c < 1)
                                             && (obj.Loading_Charges__c == null || obj.Loading_Charges__c < 1)
                                            ){
                                                incoChargeDto.total = obj.Total__c;
                                            }
                                          else{
                                              incoChargeDto.bayan = obj.Bayan__c;
                                              incoChargeDto.fasahFee = obj.Fasah_fee__c;
                                              incoChargeDto.inspection = obj.Inspection__c;
                                              incoChargeDto.liftOnLiftOff = obj.Lift_on_Lift_off__c;
                                              incoChargeDto.originCustomsclearance = obj.Origin_Customs_clearance__c;
                                              incoChargeDto.originLoadingCharges = obj.Origin_Loading_Charges__c;
                                              incoChargeDto.portShuttling = obj.Port_Shuttling__c;
                                              incoChargeDto.tabadul = obj.Tabadul__c;
                                              incoChargeDto.xray = obj.Xray__c;
                                              incoChargeDto.total = obj.Total__c;
                                              incoChargeDto.loadingCharge = obj.Loading_Charges__c;
                                          }
                                      }
            
        }
        return incoChargeDto;
    }
    @AuraEnabled(cacheable=true)
    public static List<SObJectResult> getAdditionalCharges(String value){
        List<SObJectResult> sObjectResultList = new List<SObJectResult>();
        String newSearchText = '%'+value+'%';
        list<Additional_Charge__c> additionalChargeList = [SELECT Name, Id FROM Additional_Charge__c Where Name Like :newSearchText ];
        for(Additional_Charge__c so : additionalChargeList) {
            sObjectResultList.add(new SObjectResult(so.name, so.Id));
        }
        return sObjectResultList;
    }
    @AuraEnabled
    public static String genrateQuotation(String routeId, String rmsId, String enquiryId,String quotationId, BAFCOGenerteQuoteDto dto, String incoTerm, Boolean cameReviseCompt, Boolean sameRoute, String quoteRemarks, Decimal additionalChargeTotal){
        List<BAFCOGenerteQuoteDto.AdditionalCharge> additionalChargeList = dto.additionalChargeList;
        shippingLineChargesDTO shipLineDto = BAFCOshippingLineChargesController.getShippingCharges(rmsId);
        RMS__c rmsObj = [SELECT Id, Port_Of_Loading__c, Port_Of_Discharge__c, Equipment_Type__c FROM RMS__c where id =: rmsId Limit 1];
        BAFCOIncoChargesDto incoDto = getIncoCharges(rmsId,incoTerm);
        Quotation__c quoteObj = new Quotation__c();
        system.debug('sameRoute '+sameRoute);
        if(quotationId == ''  || quotationId == null || (cameReviseCompt  == true && sameRoute == true)){
            Opportunity enqObj  = [SELECT Accountid,Business_Type__c,Service_Type__c,Id,No_of_Quotes__c,(Select id,name,Name__c from Quotations__r order by createdDate)  FROM Opportunity where id =: enquiryId];            
            quoteObj.Opportunity__c = enquiryId;
            //quoteObj.Leadc__c = enqObj.Lead__c;
            quoteObj.Account__c = enqObj.accountid;
            if(enqObj.Business_Type__c == 'Export') {
                quoteObj.recordtypeId = QUOTE_EXPORT_RECORDTYPE_Id;
            }
            else if(enqObj.Business_Type__c == 'Import') {
                quoteObj.recordtypeId = QUOTE_IMPORT_RECORDTYPE_Id;
            }
            quoteObj.Quotation_Type__c = enqObj.Service_Type__c;
            integer year =  Date.Today().Year();
            string s1=string.valueof(year).right(2);
            Integer Year1= Integer.valueof(s1);
            Decimal quoteNumber = enqObj.No_of_Quotes__c + 1;
            List<Quotation__c> quoteList = enqObj.Quotations__r; 
            if(quoteList.size() > 0){
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
            if(enqObj.Business_Type__c == 'Export') {
                quoteObj.recordtypeId = QUOTE_EXPORT_RECORDTYPE_Id;
                quoteObj.Quotation_Type__c = 'Sea Export';
            }
            else if(enqObj.Business_Type__c == 'Import') {
                quoteObj.recordtypeId = QUOTE_IMPORT_RECORDTYPE_Id;
                quoteObj.Quotation_Type__c = 'Sea Import';
            }
            
            integer year =  Date.Today().Year();
            string s1=string.valueof(year).right(2);
            Integer Year1= Integer.valueof(s1);
            Decimal quoteNumber = enqObj.No_of_Quotes__c + 1;
            List<Quotation__c> quoteList2 = enqObj.Quotations__r;
            if(test.isRunningTest()){
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
            }
            
            quoteObj.remarks__c = quoteRemarks;
            update quoteObj;
            system.debug('quoteObj '+quoteObj);
        }
        
        quoteItemObj.Total__c = dto.total;
        quoteItemObj.Pickup_Place__c = dto.pickupPlaceName;
        quoteItemObj.Discharge_Place__c = dto.dischargePlaceName;
        quoteItemObj.Total_Additional__c = additionalChargeTotal;
        quoteItemObj.Sea_Freight__c = dto.seaFreightSellRate;  
        quoteItemObj.Quantity__c = dto.quantity;
        quoteItemObj.INCO_Term__c = dto.incoTermId;
        quoteItemObj.Buying_Rate__c = dto.quoteBuyingRate > 0 ? dto.quoteBuyingRate : null;
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
        try{
            quoteItemObj = updateOperationalChargeText(additionalChargeList,quoteItemObj,dto);
            upsert quoteItemObj;
            system.debug('quoteItemObj '+quoteItemObj);
            quoteItemObj = assignAdditionalChargeIntoQuoteItem(additionalChargeList,quoteItemObj,dto);
            if(dto.exWorksObj != null){
                insertExWorksQuotationCharge(dto.exWorksObj.Name,dto.exWorksObj.LoadCharge,quoteItemObj);
            }
            
        }
        Catch(Exception e){
            System.debug('Exception '+e.getMessage());
        }
        
        return quoteObj.Id;
    }
    public static Quotation_item__c updateOperationalChargeText(List<BAFCOGenerteQuoteDto.AdditionalCharge> additionalChargeList,Quotation_item__c quoteItemObj,BAFCOGenerteQuoteDto dto){
        String OperationalChargesbuying = '';
        String OperationalChargeSelling = '';
        for(BAFCOGenerteQuoteDto.AdditionalCharge dto2 : additionalChargeList){
            if(quoteItemObj.Add_to_Buying_Additional__c == true ){
                String nn = dto2.name + ' : '+dto2.value+' '+dto.currencyCode;
                OperationalChargesbuying = OperationalChargesbuying + nn + '\n ';
            }
            else {
                String nn = dto2.name + ' : '+dto2.value+' '+dto.currencyCode;
                OperationalChargeSelling = OperationalChargeSelling + nn + '\n ';
            }
        }
        if(dto.exWorksObj != null && dto.exWorksObj.Name != null){
            if(dto.addExWorksCharge == true ){
                String nn = dto.exWorksObj.Name + ' : '+dto.exWorksObj.LoadCharge+' '+dto.currencyCode;
                OperationalChargesbuying = OperationalChargesbuying + nn + '\n ';
            }
            else{
                String nn = dto.exWorksObj.Name + ' : '+dto.exWorksObj.LoadCharge+' '+dto.currencyCode;
                OperationalChargeSelling = OperationalChargeSelling + nn + '\n ';
            }
        }
        quoteItemObj.Operational_Charges_Buying__c = OperationalChargesbuying;
        quoteItemObj.Operational_Charges_Selling__c = OperationalChargeSelling;
        return quoteItemObj;
    }
    public static void insertExWorksQuotationCharge(String exWorksName,Decimal value, Quotation_item__c quoteItemObj){
        Quotation_Charges__c newObj = new Quotation_Charges__c();
        newObj.Quotation_Item__c = quoteItemObj.id;
        if(quoteItemObj.Add_to_Buying_Ex_works__c == true )newObj.Buying_Rate__c = value;
        else newObj.Charge_Value__c = value;
        newObj.Charge_Name_text__c = exWorksName;
        newObj.isExWorks__c = true;
        Insert newObj;
    }
    public static Quotation_item__c assignAdditionalChargeIntoQuoteItem(List<BAFCOGenerteQuoteDto.AdditionalCharge> additionalChargeList, Quotation_item__c quoteItemObj,BAFCOGenerteQuoteDto dto){
        Map<String,id> additionalChargeMap = new Map<String,id>();
        String OperationalChargesbuying = '';
        String OperationalChargeSelling = '';
        for(Additional_Charge__c addnObj :  [Select id, name from Additional_Charge__c]){
            additionalChargeMap.put(addnObj.name,addnObj.id);
        }
        List<Quotation_Charges__c> chargeList = new List<Quotation_Charges__c>();
        for(BAFCOGenerteQuoteDto.AdditionalCharge dto2 : additionalChargeList){
            Quotation_Charges__c newObj = new Quotation_Charges__c();
            newObj.Quotation_Item__c = quoteItemObj.id;
            if(quoteItemObj.Add_to_Buying_Additional__c == true ){
                newObj.Buying_Rate__c = dto2.value;
                String nn = dto2.name + ' : '+dto2.value +' '+dto.currencyCode;
                OperationalChargesbuying = OperationalChargesbuying + nn + '\n ';
            }
            else {
                newObj.Charge_Value__c = dto2.value;
                String nn = dto2.name + ' : '+dto2.value+' ' +dto.currencyCode;
                OperationalChargeSelling = OperationalChargeSelling + nn + '\n ';
            }
            newObj.isAdditional_Charge__c = true;
            if(additionalChargeMap.containsKey(dto2.name)){
                newObj.Charge_Name__c = additionalChargeMap.get(dto2.name);
                newObj.Charge_Name_text__c = dto2.name;
            }
            chargeList.add(newObj);
        }
        if(chargeList.size() > 0) insert chargeList;
        return quoteItemObj;
        
    }
    @AuraEnabled
    public static string addRates(
        BAFCORMSDto rmsDetail,
        String routeId,
        shippingLineChargesDTO shippingChargeDto,
        BAFCOIncoChargesDto incocharges,
        Boolean totalShippChanged,
        Boolean totalIncoChanged,
        String equipmentType,
        String shippingLine,
        String leadId,
        Boolean destinTotalChanged,
        BAFCODestinationChargeDto destinCharges,
        List<BAFCOLeadDetailsController.selectedEquip> selectedEquip,
        String rmscurrencyCode
    ){
        
        Route__c routeObj =[SELECT INCO_Term__c ,Id, Port_of_Destination__c, Port_of_loading__c, Shipping_Line__c, Commodity__c FROM Route__c where id =:routeId];
        
        //String equipId = [SELECT Max_Weight__c, Name, Id FROM Equipment_Type__c where Name =: equipmentType].id;
        String shippingLineId = [SELECT Name, Id FROM Shipping_Line__c where Name =: shippingLine limit 1].id;
        String businesstype = [SELECT Id, Business_Type__c FROM Account where id =: leadId limit 1].Business_Type__c;
        system.debug('incocharges '+incocharges);
        Id ExportRecordTypeId = Schema.SObjectType.RMS__c.getRecordTypeInfosByName()
            .get('Export')
            .getRecordTypeId();
        
        Id ImportRecordTypeId = Schema.SObjectType.RMS__c.getRecordTypeInfosByName()
            .get('Import')
            .getRecordTypeId();
        for(BAFCOLeadDetailsController.selectedEquip obj : selectedEquip){
            RMS__c rmsobj = new RMS__c();
            rmsobj.Port_Of_Loading__c = routeObj.Port_of_loading__c;
            rmsObj.Port_Of_Discharge__c = routeObj.Port_of_Destination__c;
            //rmsObj.Commodity__c = routeObj.Commodity__c;
            rmsObj.Commodity__c = rmsDetail.commodity != '' ? rmsDetail.commodity : null;
            rmsObj.Shipping_Line__c = shippingLineId;
            rmsObj.Rate_Type__c = rmsDetail.rateType;
            rmsObj.Validity__c = Date.valueOf(rmsDetail.validity);
            //rmsObj.Sea_Freight__c = rmsDetail.seaFreight;
            rmsObj.Business_Type__c = businesstype;
            rmsObj.CurrencyIsoCode = rmscurrencyCode;
            //rmsObj.Equipment_Type__c = equipId;
            List<BAFCOLeadDetailsController.SelectedEquip> rmsEquipList = rmsDetail.selectedEquip;
            system.debug('rmsEquipList '+rmsEquipList);
            for(BAFCOLeadDetailsController.SelectedEquip obj2 : rmsEquipList){
                if(obj2.label == obj.label){
                    rmsObj.Sea_Freight__c = obj2.seaFreight;
                    rmsObj.Equipment_Type__c = obj2.value;
                }
            }    
            rmsObj.Business_Type__c = rmsDetail.businessType;
            rmsObj.All_in_Rate__c = rmsDetail.allInRate;
            rmsObj.FOB_All_In__c = rmsDetail.FOBAllIn;
            rmsObj.Ex_Works_All_In__c = rmsDetail.ExWorksIn;
            rmsObj.Free_time__c = rmsDetail.FreeTime != null ? Decimal.valueOf(rmsDetail.FreeTime) : 0;
            rmsObj.Free_time_POD__c = rmsDetail.FreeTimePOD != null ? Decimal.valueOf(rmsDetail.FreeTimePOD) : 0;
            rmsObj.Remarks__c = rmsDetail.remarks;
            rmsObj.Agent__c = rmsDetail.agentName != '' ? rmsDetail.agentName : null; 
            rmsObj.INCO_Term__c = rmsDetail.incoTermId != '' ? rmsDetail.incoTermId : null;
            rmsObj.Customer_Name__c = rmsDetail.customerId != '' ? rmsDetail.customerId : null;
            if(rmsObj.Business_Type__c == 'Export') rmsObj.RecordTypeId = ExportRecordTypeId;
            else if(rmsObj.Business_Type__c == 'Import')rmsObj.RecordTypeId = ImportRecordTypeId;
            
            Insert rmsObj;
            
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
            if(!totalIncoChanged){
                iObj.Bayan__c = incoCharges.bayan;
                iobj.Fasah_fee__c = incoCharges.fasahFee;
                iObj.Inspection__c = incoCharges.inspection;
                iObj.Lift_on_Lift_off__c = incoCharges.liftOnLiftOff;
                iObj.Origin_Customs_clearance__c = incoCharges.originCustomsclearance;
                iobj.Origin_Loading_Charges__c = incoCharges.originLoadingCharges;
                iObj.Port_Shuttling__c = incoCharges.portShuttling;
                iObj.Tabadul__c = incoCharges.tabadul;
                iObj.Xray__c = incoCharges.xray;
                iObj.Loading_Charges__c = incoCharges.loadingCharge;
                if(!String.isBlank(incoCharges.loadingChargeId)) iObj.Loading_Charge_Name__c = incoCharges.loadingChargeId;
                
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
            iObj.Total__c = incoCharges.total;
            iObj.RMS__c = rmsObj.id;        
            iObj.INCO_Term__c = routeObj.INCO_Term__c;
            iObj.CurrencyIsoCode = incoCharges.currencyCode;
            iObj.Offset_Value__c = incoCharges.offSet;
            
            if(rmsObj.All_in_Rate__c == false && rmsObj.Ex_Works_All_In__c == false && rmsObj.FOB_All_In__c == false)  Insert iObj;
            system.debug(iObj);
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
            List<Rate_Procurement__c> procumentList  = new  List<Rate_Procurement__c>();
            if(rmsObj.RecordTypeId == ExportRecordTypeId){
                procumentList = [Select id from Rate_Procurement__c where 
                                 Port_of_Loading__c =:rmsobj.Port_Of_Loading__c AND 
                                 Port_of_Discharge__c =:rmsObj.Port_Of_Discharge__c AND 
                                 Shipping_Line__c =: rmsObj.Shipping_Line__c AND 
                                 Equipment_Type__c =: rmsObj.Equipment_Type__c limit 1];
            }
            else if(rmsObj.RecordTypeId == ImportRecordTypeId){
                procumentList = [Select id from Rate_Procurement__c where 
                                 Port_of_Loading__c =:rmsobj.Port_Of_Loading__c AND 
                                 Port_of_Discharge__c =:rmsObj.Port_Of_Discharge__c AND 
                                 Shipping_Line__c =: rmsObj.Shipping_Line__c AND 
                                 Agent__c =:rmsObj.Agent__c AND 
                                 Equipment_Type__c =: rmsObj.Equipment_Type__c limit 1];
            }
            system.debug('procumentList '+procumentList);
            system.debug('rmsObj '+rmsObj);
            if(procumentList.size() > 0){
                Id ReceivedRecordtypeId = Schema.SObjectType.Rate_Procurement__c.getRecordTypeInfosByName()
                    .get('Received')
                    .getRecordTypeId();
                Rate_Procurement__c proobj = procumentList[0];
                proobj.RMS__c = rmsObj.id;
                proobj.RecordTypeId = ReceivedRecordtypeId;
                update proobj;
            }
        }
        return null;
    }
    @AuraEnabled
    public static List<Shipping_Line__c> getShipline(){
        return [Select Id, Name from Shipping_Line__c];
    }
    @AuraEnabled
    public static List<Route_Equipment__c> getRouteEquipType( String routeId){
        return [Select Id, Equipment_Type__r.name,Quantity__c from Route_Equipment__c where Route__c =:routeId ];
    }
    @AuraEnabled
    public static List<template__c> getTemplatesData(){
        return [SELECT Field4_Value__c, Field10_Value__c, Field1_Name__c, Field7_Value__c, Field3_Name__c, Field5_Value__c, Field8_Value__c, Field2_Name__c, Field2_Value__c, Field6_Value__c, Field4_Name__c, Field10_Name__c, Field9_Value__c, Field9_Name__c, Field5_Name__c, Field1_Value__c, Field3_Value__c, Field8_Name__c, Field6_Name__c, Field7_Name__c, Name, Id FROM template__c];
    }
    @AuraEnabled
    public static void submitTemplatesData(template__c templateObj){
        if(templateObj != null){
            insert templateObj;
        }
    }
    @AuraEnabled
    public static List<Loading_Charge__c>  getLoadingCharges(String pickupPlace, String portLoading, String directionValue){
        List<Loading_Charge__c>  loadingChargeList = new List<Loading_Charge__c>();
        if(!String.isBlank(pickupPlace) && !String.isBlank(portLoading) && !String.isBlank(directionValue)){
            loadingChargeList = [SELECT Id, Loading_Charge__c FROM Loading_Charge__c
                                 WHERE Direction__c =: directionValue AND Port_of_Loading__c =: portLoading limit 1];
        }
        return loadingChargeList;
    }
    @AuraEnabled
    public static void updateValidityDate( String quoteId, string validityDate){
        Quotation__c quoteObj = new Quotation__c();
        system.debug('validityDate '+validityDate);
        quoteObj.Id = quoteId;
        if(validityDate != null) quoteObj.Quotation_Validity__c = date.valueOf(validityDate);
        update quoteObj;
    }
    @AuraEnabled
    public static List<Exchange_Rate__c> getExchangeRate(){
        return [SELECT Id, Currency_Code__c, Exchange_Rate__c, Offset_Value__c, Final_Rate__c FROM Exchange_Rate__c];
    }
    @AuraEnabled
    public static Regular_Routing__c getRegularRouteData(String rgID){
        if(rgID != null){
            return [Select Kind_of_Shipment__c,Dangerous_Goods__c,DG_Class__c,Commodity__c,Commodity__r.Name,id, name,Service_Type__c,
                    INCO_Term__c,INCO_Term__r.Name,Port_of_Loading__c,Port_of_Loading__r.Name,Port_of_Destination__c,
                    Port_of_Destination__r.Name,Pickup_Place__c,Discharge_Place__c,
                    Shipping_Line__c,Shipping_Line__r.Name from Regular_Routing__c where id=:rgID];
        }
        return null;
    }
    @AuraEnabled
    public static List<Regular_Routing__c> getAllRegularRoute(String AccountId){
        return [Select id,Name from Regular_Routing__c where Account__c =: AccountId ];
    }
    @AuraEnabled
    public static Rate_Procurement__c createRateProcument(String portLoading,String commodity,String shippingLine,String portDischarge,decimal quantity,String enquiryId,String routeId,String agentName){
        String PortOfDischargeId = [Select id ,name from Port__c where name =:portDischarge limit 1].Id;
        String portLoadingId = [Select id ,name from Port__c where name =:portLoading limit 1].Id;
        system.debug('agentName '+agentName);
        system.debug('shippingLine '+shippingLine);
        Rate_Procurement__c procuObj = new Rate_Procurement__c();
        Id PENDING = Schema.SObjectType.Rate_Procurement__c.getRecordTypeInfosByName()
            .get('Pending')
            .getRecordTypeId();
        List<Route_Equipment__c> routeEquipMentList = getRouteEquipType(routeId);
        if(routeEquipMentList.size() > 0){
            String equipmentName = routeEquipMentList[0].Equipment_Type__r.name;
            String equipId = [Select Id from Equipment_Type__c where name =:equipmentName Limit 1].Id;
            procuObj.Equipment_Type__c = equipId;
        }
        procuObj.Port_of_Loading__c = portLoadingId;
        procuObj.Port_of_Discharge__c = PortOfDischargeId;
        procuObj.Quantity__c = quantity;
        procuObj.Shipping_Line__c = shippingLine != '' ? shippingLine : null;
        procuObj.Opportunity__c = enquiryId;
        procuObj.Agent__c = agentName != '' ?  agentName : null;
        procuObj.RecordTypeId = PENDING;
        insert procuObj;
        Task tsk = new Task();
        tsk.Subject = 'Follow up with Shipping Line for Rate Request';
        tsk.Status = 'Open';
        tsk.OwnerId = UserInfo.getUserId();
        tsk.WhatId = procuObj.Id;
        tsk.IsReminderSet = true;
        tsk.ActivityDate = Date.valueOf(DateTime.now().addDays(1));
        insert tsk;
        
        return procuObj;        
    }
    @auraenabled
    public static opportunity getOptyBusinessType(string optyId){
        return [Select id,Business_Type__c,RecordType.Name from opportunity where id =: optyId ];
    }
    @auraenabled
    public static List<Opportunity> getCommercialUserOnLoad(string AccountId){
        List<Opportunity> optyList = new List<Opportunity>();
        if(AccountId !=null){
            optyList = [Select Commercial_User__r.Name from Opportunity where AccountId =: AccountId AND Commercial_User__c <> null order by createddate desc];
        }
        return optyList;
    }
    @auraenabled
    public static RmsDefaultValue getDefualtValueForRMS(){
        String userId = userInfo.getUserId();
        RmsDefaultValue dto = new RmsDefaultValue();
        User userObj = [SELECT Id, Name, Handling__c, Branch__c FROM User where id =: userId];
        List<Commodity__c> commodityList = [select id,name from Commodity__c where name ='FAK'];
        List<INCO_Term__c> incoTermList = [select id,name from INCO_Term__c where name ='Ocean Freight'];
        List<INCO_Term__c> incoTermList2 = [select id,name from INCO_Term__c where name ='Air freight'];
        if(commodityList.size()>0){
            dto.commodityId = commodityList[0].Id;
            dto.commodityName = commodityList[0].Name;
        }
        if(incoTermList.size()>0){
            dto.incoTermId = incoTermList[0].Id;
            dto.incoTermName = incoTermList[0].Name;
        }
        if(incoTermList2.size() > 0 ){
            dto.airincoTermName = incoTermList2[0].Name;
            dto.airIncoId= incoTermList2[0].Id;
        }
        dto.businessType = userObj.Handling__c != null ? userObj.Handling__c : '';
        if(userObj.Branch__c != null){
            List<Port__c> portList = new List<Port__c>();
            if(userObj.Branch__c == 'Riyadh') portList = [Select id, name from Port__c where name = 'Jeddah' limit 1];
            else portList = [Select id, name from Port__c where name =: userObj.Branch__c limit 1];            
            if(portList.size() > 0){
                dto.polId = portList[0].id;
                dto.polName = portList[0].Name;
            }
        }
        dto.equipmentList = [Select id, name from Equipment_Type__c limit 50];
        return dto;
    }
    @auraenabled
    public static RmsDefaultValue getDefualtValueForEnquiry(){
        RmsDefaultValue dto = new RmsDefaultValue();
        List<Commodity__c> commodityList = [select id,name from Commodity__c where name ='FAK'];
        List<INCO_Term__c> incoTermList = [select id,name from INCO_Term__c where name ='CFR'];
        if(commodityList.size()>0){
            dto.commodityId = commodityList[0].Id;
            dto.commodityName = commodityList[0].Name;
        }
        if(incoTermList.size()>0){
            dto.incoTermId = incoTermList[0].Id;
            dto.incoTermName = incoTermList[0].Name;
        }
        return dto;
    }
    @auraenabled
    public static RmsDefaultValue getDefaultImportAddRate(String routeId){
        RmsDefaultValue dto = new RmsDefaultValue();
        if(routeId != null){
            Route__c routeObj = [Select INCO_Term__r.Name,id from Route__c where id=:routeId];
            dto.incoTermId = routeObj.INCO_Term__c;
            dto.incoTermName =routeObj.INCO_Term__r.Name;
        }
        return dto;
    }
    @AuraEnabled
    public static List<Loading_Charge__c> getExWorksOnLoad(){
        List<Loading_Charge__c> exWorksList = new List<Loading_Charge__c>();
        exWorksList = [Select Id,Name,Port_of_Loading__r.Name,Pickup_Place__c,Loading_Charge__c from Loading_Charge__c];
        if(exWorksList.size() > 0 ) return exWorksList;
        else return null;
    }
    @AuraEnabled
    public static void addRouteEquipment(List<BAFCORoutingDetailsDto.containerRecord> containerList,List<String> toDeleteRecord,String routeId){
        if(toDeleteRecord.size() > 0){
            List<Route_Equipment__c> toDelete = new List<Route_Equipment__c>();
            for(String dd : toDeleteRecord){
                Route_Equipment__c routeQuipobj = new Route_Equipment__c();
                routeQuipobj.id = dd;
                toDelete.add(routeQuipobj);
            }
            delete toDelete ;
        }
        List<Route_Equipment__c> routeEquipmentList = new List<Route_Equipment__c>();
        for(BAFCORoutingDetailsDto.containerRecord cont : containerList){
            Route_Equipment__c routeQuipobj = new Route_Equipment__c();
            routeQuipobj.Equipment_Type__c = cont.containerType;
            routeQuipobj.Quantity__c = cont.quantity;
            if(cont.id != ''){
                routeQuipobj.Id = cont.id;
            }
            else{
                routeQuipobj.Route__c = routeId;
            }
            routeEquipmentList.add(routeQuipobj);
        }
        upsert routeEquipmentList;
    }
    @AuraEnabled
    public static RmsDefaultValue copyExistingRMS(String rmsId){
        RmsDefaultValue dto = new RmsDefaultValue();
        Rms__c rmsObj = new Rms__c();
        if(rmsId != null){
            rmsObj = [Select Agent__r.name,FOB_All_In__c,id,Port_Of_Discharge__r.name,Port_Of_Loading__r.name,Commodity__r.name,Shipping_Line__r.name,
                      INCO_Term__r.name,Equipment_Type__r.name,Rate_Type__c,Validity__c,Sea_Freight__c,Business_Type__c,
                      Free_time_POD__c,Free_time__c,Customer_Name__r.name,All_in_Rate__c,Ex_Works_All_In__c,
                      (Select id,BAF__c,Bunker_surcharge__c,CMC__c,DTHC__c,EIC__c,ISPS__c,OTHC__c,Seal_Charges__c,
                       Carriage_Congestion_Surcharge__c,Carrier_Security_Fees__c,Cleaning_Charges__c,DG_Surcharge__c,
                       Inland_Fuel_Surcharge__c,Inland_Handling_Fees__c,Inland_haulage__c,Low_Sulphur_Surcharge__c,
                       Operational_Recovery_Surcharge__c,Overweight_surcharge__c,War_Risk_Surcharge__c,Total__c,
                       CurrencyIsoCode,Offset_Value__c from Shipping_Line_Charges__r),
                      (Select id,Bayan__c,Fasah_fee__c,Inspection__c,Lift_on_Lift_off__c,Origin_Customs_clearance__c,
                       Origin_Loading_Charges__c,Port_Shuttling__c,Tabadul__c,Xray__c,Loading_Charges__c,BL_Fees__c,
                       Export_Service_Fees__c,Fuel_Surcharge__c,Insurance_Charges__c,Lashing_Charges__c,
                       Origin_Detention_Demurrage_Charges__c,OTHC__c,Pickup_Charges__c,Reefer_Plugin_Charges__c,
                       Tarpaulin_Charges__c,Truck_idling_Charges__c,VGM__c,Total__c,CurrencyIsoCode,Offset_Value__c 
                       from INCO_Charges__r),
                      (Select id,Bayan_Charges__c,Custom_Clearance__c,DO_charges__c,DTHC__c,Fasah_Charges__c,Gate_pass_charges__c,
                       LOLO_Charges__c,Transportation__c,Total__c,CurrencyIsoCode,Offset_Value__c from Clearance_and_Delivery__r)
                      FOB_All_In__c from Rms__c where id =: rmsId];
            dto.rmsObj = rmsObj;
            if(rmsObj.INCO_Charges__r.size() >0){
                INCO_Charge__c obj = rmsObj.INCO_Charges__r[0];
                if((obj.Bayan__c == null || obj.Bayan__c < 1) 
                   && (obj.Fasah_fee__c == null || obj.Fasah_fee__c < 1)
                   && (obj.Inspection__c == null || obj.Inspection__c < 1)
                   && (obj.Lift_on_Lift_off__c == null || obj.Lift_on_Lift_off__c < 1)
                   && (obj.Origin_Customs_clearance__c == null || obj.Origin_Customs_clearance__c < 1 )
                   && (obj.Origin_Loading_Charges__c == null || obj.Origin_Loading_Charges__c < 1)
                   && (obj.Port_Shuttling__c == null || obj.Port_Shuttling__c < 1)
                   && (obj.Tabadul__c == null || obj.Tabadul__c < 1)
                   && (obj.Xray__c == null || obj.Xray__c < 1)
                   && (obj.Loading_Charges__c == null || obj.Loading_Charges__c < 1)
                   && (obj.Total__c > 0)
                  ){
                      dto.incoChargeTotalChange = true;
                  }
                else{
                    dto.incoChargeTotalChange = false;
                }
            }
            if(rmsObj.Clearance_and_Delivery__r.size() > 0){
                Destination_Charges__c destin  = rmsObj.Clearance_and_Delivery__r[0];
                if((destin.Bayan_Charges__c == null || destin.Bayan_Charges__c < 1) 
                   && (destin.Bayan_Charges__c == null || destin.Bayan_Charges__c < 1) 
                   && (destin.Custom_Clearance__c == null || destin.Custom_Clearance__c < 1) 
                   && (destin.DO_charges__c == null || destin.DO_charges__c < 1) 
                   && (destin.Fasah_Charges__c == null || destin.Fasah_Charges__c < 1) 
                   && (destin.Gate_pass_charges__c == null || destin.Gate_pass_charges__c < 1) 
                   && (destin.LOLO_Charges__c == null || destin.LOLO_Charges__c < 1) 
                   && (destin.Transportation__c == null || destin.Transportation__c < 1) 
                   && (destin.Total__c > 0)) {
                       dto.destinTotalChanged = true;
                   }
                else{
                    dto.destinTotalChanged = false;
                }
            }
            if(rmsObj.Shipping_Line_Charges__r.size() > 0){
                Shipping_Line_Charge__c shippObj = rmsObj.Shipping_Line_Charges__r[0];
                if((shippObj.BAF__c == null || shippobj.BAF__c < 1)
                   && (shippObj.BAF__c == null || shippobj.BAF__c < 1)
                   && (shippObj.Bunker_surcharge__c == null || shippobj.Bunker_surcharge__c < 1)
                   && (shippObj.DTHC__c == null || shippobj.DTHC__c < 1)
                   && (shippObj.EIC__c == null || shippobj.EIC__c < 1)
                   && (shippObj.ISPS__c == null || shippobj.ISPS__c < 1)
                   && (shippObj.OTHC__c == null || shippobj.OTHC__c < 1)
                   && (shippObj.Seal_Charges__c == null || shippobj.Seal_Charges__c < 1)
                   && (shippObj.Carriage_Congestion_Surcharge__c == null || shippobj.Carriage_Congestion_Surcharge__c < 1)
                   && (shippObj.Carrier_Security_Fees__c == null || shippobj.Carrier_Security_Fees__c < 1)
                   && (shippObj.Cleaning_Charges__c == null || shippobj.Cleaning_Charges__c < 1)
                   && (shippObj.DG_Surcharge__c == null || shippobj.DG_Surcharge__c < 1)
                   && (shippObj.Inland_Handling_Fees__c == null || shippobj.Inland_Handling_Fees__c < 1)
                   && (shippObj.Inland_Fuel_Surcharge__c == null || shippobj.Inland_Fuel_Surcharge__c < 1)
                   && (shippObj.Inland_haulage__c == null || shippobj.Inland_haulage__c < 1)
                   && (shippObj.Low_Sulphur_Surcharge__c == null || shippobj.Low_Sulphur_Surcharge__c < 1)
                   && (shippObj.Operational_Recovery_Surcharge__c == null || shippobj.Operational_Recovery_Surcharge__c < 1)
                   && (shippObj.Overweight_surcharge__c == null || shippobj.Overweight_surcharge__c < 1)
                   && (shippObj.War_Risk_Surcharge__c == null || shippobj.War_Risk_Surcharge__c < 1)
                   && (shippObj.Total__c > 0)
                  ){
                      dto.shippTotalChanged = true;
                  }
                else {dto.shippTotalChanged = false;
                     }
            }
            dto.equipmentList = [Select id, name from Equipment_Type__c limit 50];
        }
        return dto;
    }
    public class SObjectResult {
        @AuraEnabled
        public String recName;
        @AuraEnabled
        public Id recId;
        
        public SObJectResult(String recNameTemp, Id recIdTemp) {
            recName = recNameTemp;
            recId = recIdTemp;
        }
    }
    public class RmsDefaultValue {
        RmsDefaultValue(){
            equipmentList = new List<Equipment_Type__c>();
        }
        @AuraEnabled public String incoTermId{get;set;}
        @AuraEnabled public RMS__c rmsObj{get;set;}
        @AuraEnabled public String incoTermName{get;set;}
        @AuraEnabled public String commodityId{get;set;}
        @AuraEnabled public String commodityName{get;set;}
        @AuraEnabled public String businessType{get;set;}
        @AuraEnabled public String polId{get;set;}
        @AuraEnabled public String polName{get;set;}
        @AuraEnabled public Boolean incoChargeTotalChange{get;set;}
        @AuraEnabled public Boolean destinTotalChanged{get;set;}
        @AuraEnabled public Boolean shippTotalChanged{get;set;}
        @AuraEnabled public List<Equipment_Type__c> equipmentList{get;set;}
        @AuraEnabled public String airincoTermName{get;set;}
        @AuraEnabled public String airIncoId{get;set;}
    }
}