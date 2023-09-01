public class BAFCOSalesOrderController {
    public static final Id ORDER_EXPORT_RECORDTYPE_Id = Schema.SObjectType.Order__c.getRecordTypeInfosByName()
        .get('Export')
        .getRecordTypeId();
    public static final Id ORDER_IMPORT_RECORDTYPE_Id = Schema.SObjectType.Order__c.getRecordTypeInfosByName()
        .get('Import')
        .getRecordTypeId();
    public static final Id QUOTE_EXPORT_RECORDTYPE_Id = Schema.SObjectType.Quotation__c.getRecordTypeInfosByName()
        .get('Export')
        .getRecordTypeId();
    public static final Id QUOTE_IMPORT_RECORDTYPE_Id = Schema.SObjectType.Quotation__c.getRecordTypeInfosByName()
        .get('Import')
        .getRecordTypeId();
    @AuraEnabled
    public static Map<String,Route__c> getRouteItem(String quoteId){
        Map<String,Route__c> mapRouteNameToItem = new Map<String,Route__c>();
        Map<String,String> mapRouteIdToName = new Map<String,String>();
        Set<Id> routeId = new Set<Id>();
        Integer Index = 1;
        for(Quotation_Item__c item : [Select Route__c from Quotation_Item__c where Quotation__c =: quoteId]){
            routeId.add(item.Route__c);
        }
        if(routeId.size()>0){
            for(Route__c routeObj : [SELECT Airline__r.name,Airport_of_Loading__r.Name,Airport_of_Destination__r.Name,(Select Cargo_Details__c FROM Route_Equipments__r ),Opportunity_Enquiry__r.RecordType.Name,Cargo_Readiness__c,Opportunity_Enquiry__c ,Port_of_loading__c,/*Place_of_Discharge__c,Place_of_Pickup__c*/Discharge_Place__c,Pickup_Place__c,Id, Regular_Routing__c,INCO_Term__r.name, Kind_Of_Shipment__c, Service_Type__c, Port_of_loading__r.Name, 
                                     Port_of_Destination__r.Name, Shipping_Line__r.name, Commodity__r.Name, Cargo_Weight__c, Remarks__c, Name  
                                     FROM Route__c WHERE  Id in : routeId]){
                                         if(!mapRouteIdToName.containsKey(routeObj.Id)){
                                             mapRouteIdToName.put(routeObj.Id,'Route '+Index++);
                                         }
                                         if(!mapRouteNameToItem.containsKey(mapRouteIdToName.get(routeObj.Id))){
                                             mapRouteNameToItem.put(mapRouteIdToName.get(routeObj.Id),routeObj);
                                         }
                                     }
        }
        return mapRouteNameToItem;
    }
    @AuraEnabled
    public static Map<String,List<EquipData>> getQuoteLineItem(String quoteId,String routeId){
        Map<String,List<EquipData>> equipLineToShipData = new Map<String,List<EquipData>>();
        Map<String,Decimal> mapequipNameToQty = new Map<String,Decimal>();
        Map<String,Decimal> mapDimensionToQty = new Map<String,Decimal>();
        for(Route_Equipment__c re : [Select Tab_View__c,quantity__c, Equipment_Type__r.name from Route_Equipment__c where route__c =:routeId ]){
            system.debug('re '+re);
            mapequipNameToQty.put(re.Equipment_Type__r.name,re.Quantity__c);
            mapDimensionToQty.put(re.Tab_View__c,re.Quantity__c);
        }
        system.debug('mapequipNameToQty '+mapequipNameToQty);
        system.debug('mapDimensionToQty '+mapequipNameToQty);
        Integer index = 1;
        for(Quotation_Item__c item : [Select Operational_Charges_Selling__c,Operational_Charges_Buying__c,Chargeable_Weight__c,CurrencyIsoCode,Selling_Rate_Kg__c,Airline__r.name,RMS__r.Free_time_POD__c, (Select id,Charge_Name__c,Charge_Value__c from Quotation_Charges__r where isAdditional_Charge__c = true), Selling_Charges_Include__c,Quotation__r.Quotation_type__c,Charges_Included__c,Airport_of_Loading__c,Airport_of_Destination__c,Quotation__r.isAir__c,Quotation__r.isLCL__c,Tab_View__c,INCO_Term__c,Tank_Rental_Charges__c,Agent__c,Id,Shipping_Linee__c,Buying_Rate__c,Alternate_depot_release_charges__c,Freight_Difference_FD__c,Carrier_container_repositioning_charges__c,Ex_Works_Charge__c,Ex_Works_Charge_Name__c,Included_PDF_Ex_works__c,Included_PDF_Additional__c,Included_PDF_Destination__c,Included_PDF_Origin__c,Included_PDF_ShippingLine__c,Add_to_Buying_Ex_works__c,Add_to_Buying_Additional__c,Add_to_Buying_Destination__c,Add_to_Buying_Origin__c,Add_to_Buying_ShippingLine__c,BAF__c,Bayan__c,Bayan_cancellation_charge__c,Bunker_surcharge__c,Cleaning_charges__c,
                                      CMC__c,Container_movement_charges__c,Container_stripping__c,
                                      Destination_Customs_Clearance__c,Destination_Loading_Charges__c,DTHC__c,EIC__c,Equipment_Type__c,
                                      Fasah_fee__c,Quotation__r.Remarks__c,Free_time_certificate_charges__c,Fumigation__c,Inspection__c,Insurance_charges__c,
                                      ISPS__c,Lift_on_Lift_off__c,Loading_Charges__c,Ministry_clearnce_charge_for_OOG_cargo__c,
                                      Miscellaneous__c,Non_Palletized_Surcharge__c,Origin_Customs_clearance__c,
                                      Origin_Loading_Charges__c,OTHC__c,Pest_control__c,Port_of_Discharge__c,Port_of_Loading__c,
                                      Port_Shuttling__c,Re_palletization__c,Reefer_cntr_plug_in_charges__c,Reefer_PTI_charges__c,
                                      Reefer_steam_wash__c,RMS__c,Route__c,Sea_Freight__c,Seal_Charges__c,Stuffing_Charges__c,
                                      SweepingCleaning__c,Tabadul__c,Tarpauline_charge__c,Total_INCO__c,Total_SL__c,Truck_Head_charges__c,
                                      Truck_idling_charges__c,Vessel_certificate_charges__c,Wrappingpacking_charges__c,Xray__c,Quotation__r.RecordtypeId,
                                      Quotation__r.Leadc__c,Quotation__r.Opportunity__c,Quotation__r.Account__c,Total__c,Agent_Name__c,
                                      Remarks_SL_Charges__c,Remarks_Origin_Charges__c,Remarks_Destination_Charges__c,Remarks_Additional_Charges__c,Total_Additional__c,War_Risk_Surcharge__c,VGM__c,Total_Dest__c,Pickup_Charges__c,Overweight_surcharge__c,Origin_Detention_Demurrage_Charges__c,Lashing_Charges__c,Operational_Recovery_Surcharge__c,Low_Sulphur_Surcharge__c,Inland_haulage__c,Inland_Handling_Fees__c,Inland_Fuel_Surcharge__c,Gate_pass_charges__c,Fuel_Surcharge__c,Fasah_Charges__c,Export_Service_Fees__c,DG_Surcharge__c,Carriage_Congestion_Surcharge__c,BL_Fees__c,Bayan_Charges__c,
                                      Container_Lashing_Charges__c,DO_charges__c,LOLO_Charges__c,Carrier_Security_Fees__c,
                                      Shipping_Line__c,Equipment_Type__r.Name,Pickup_Place__c,Discharge_Place__c   
                                      from Quotation_Item__c 
                                      where Quotation__c =: quoteId 
                                      And Route__c =:routeId]){
                                          system.debug('item.Tab_View__c '+item.Tab_View__c);
                                         if(item.Quotation__r.isLCL__c == true){
                                              if(mapDimensionToQty.containsKey(item.Tab_View__c)){
                                                  if(!equipLineToShipData.containsKey(item.Tab_View__c)){
                                                      equipLineToShipData.put(item.Tab_View__c,new List<EquipData>());
                                                  }
                                                  EquipData dto = new EquipData();
                                                  //dto.Qty = mapDimensionToQty.get(item.Tab_View__c);
                                                  if(item.Quotation__r.isLCL__c == true) dto.isLCL = true;                                                  
                                                  else if(item.Quotation__r.isAir__c == true) dto.isAir = true;
                                                  
                                                  dto.shipName = '';
                                                  dto = assignquoteItemToDto(dto,item);
                                                  if(item.Total__c > 0) equipLineToShipData.get(item.Tab_View__c).add(dto);
                                              }
                                          }
                                          else if(item.Quotation__r.isAir__c == true){
                                              if(!equipLineToShipData.containsKey(item.Tab_View__c)){
                                                  equipLineToShipData.put(item.Tab_View__c,new List<EquipData>());
                                              }
                                              EquipData dto = new EquipData();
                                              //dto.Qty = mapDimensionToQty.get(item.Tab_View__c);
                                              dto.isAir = true;
                                              dto.shipName = item.Airline__r.name ;
                                              dto.airLineId = item.Airline__c;
                                                  dto = assignquoteItemToDto(dto,item);
                                              if(item.Total__c > 0) equipLineToShipData.get(item.Tab_View__c).add(dto);
                                          }
                                          else{
                                              if(item.Equipment_Type__c != null){
                                                  if(mapequipNameToQty.containsKey(item.Equipment_Type__r.Name)){
                                                      String equipName = item.Equipment_Type__r.Name;
                                                      if(!equipLineToShipData.containsKey(equipName)){
                                                          equipLineToShipData.put(equipName,new List<EquipData>());
                                                      }
                                                      EquipData dto = new EquipData();
                                                      system.debug('here '+mapequipNameToQty.get(item.Equipment_Type__r.Name));
                                                      //dto.Qty = mapequipNameToQty.get(item.Equipment_Type__r.Name);
                                                      dto.isLCL = false;
                                                      system.debug(' dto.Qty '+ dto.Qty);
                                                      if(item.Shipping_Line__c != null){
                                                          dto.shipName = item.Shipping_Line__c+( item.Agent_Name__c != null ? (' - '+item.Agent_Name__c) : '');
                                                      }
                                                      else{
                                                          dto.shipName = '';
                                                      }
                                                      dto = assignquoteItemToDto(dto,item);
                                                      if(item.Total__c > 0) equipLineToShipData.get(equipName).add(dto);
                                                  }
                                              }
                                          }
                                      }
        return equipLineToShipData;
    }
    private static EquipData assignquoteItemToDto(EquipData dto,Quotation_Item__c item){
        dto.quoteRemark = item.Quotation__r.Remarks__c;
        dto.operationalChargeBuying = item.Operational_Charges_Buying__c;
        dto.operationalChargeSelling = item.Operational_Charges_Selling__c;
        dto.chargeableWeight = item.Chargeable_Weight__c;
        dto.currencyCode = item.CurrencyIsoCode;
        dto.sellingRateKg = item.Selling_Rate_Kg__c;
        dto.sellingChargesIncluded = item.Selling_Charges_Include__c;
        dto.quotationType = item.Quotation__r.Quotation_Type__c;
        dto.sellingRate = item.Total__c;
        dto.chargesIncluded = item.Charges_Included__c;
        dto.checkBoxSelected = false;
        dto.accountId = item.Quotation__r.Account__c;
        dto.enquiryId = item.Quotation__r.Opportunity__c;
        dto.leadId = item.Quotation__r.Leadc__c;
        dto.quotationId = item.Quotation__c;
        dto.equipmentType =item.Equipment_Type__c ;
        dto.rmsID =item.RMS__c;
        dto.routeID=item.Route__c;
        dto.baf = item.BAF__c != null ? item.BAF__c : 0;
        dto.bayan =item.Bayan__c != null ? item.Bayan__c : 0;
        dto.bunkerSurcharge = item.Bunker_surcharge__c != null ? item.Bunker_surcharge__c : 0;
        dto.cleaningCharges = item.Cleaning_charges__c != null ? item.Cleaning_charges__c : 0;
        dto.containerMaintenance = item.CMC__c != null ? item.CMC__c : 0;
        dto.destinationCustomClearnace = item.Destination_Customs_Clearance__c != null ? item.Destination_Customs_Clearance__c : 0;
        dto.destinationLoading = item.Destination_Loading_Charges__c != null ? item.Destination_Loading_Charges__c : 0;
        dto.dthc =item.DTHC__c != null ? item.DTHC__c : 0;
        dto.eic =item.EIC__c != null ? item.EIC__c : 0;                
        dto.fasahFee =item.Fasah_fee__c != null ? item.Fasah_fee__c : 0;
        dto.inspection =item.Inspection__c != null ? item.Inspection__c : 0;
        dto.insurance =item.Insurance_charges__c != null ? item.Insurance_charges__c : 0;
        dto.isps =item.ISPS__c != null ? item.ISPS__c : 0;
        dto.liftOnOff =item.Lift_on_Lift_off__c != null ? item.Lift_on_Lift_off__c : 0;
        dto.loadingCharges =item.Loading_Charges__c != null ? item.Loading_Charges__c : 0;
        dto.originCustomClearance =item.Origin_Customs_clearance__c != null ? item.Origin_Customs_clearance__c : 0;
        dto.originloadingCharges =item.Origin_Loading_Charges__c != null ? item.Origin_Loading_Charges__c : 0;
        dto.othc =item.OTHC__c != null ? item.OTHC__c : 0;
        if(item.Quotation__r.isAir__c == true){
            dto.postOfDischarge =item.Airport_of_Destination__c ;
        	dto.postOfLoading =item.Airport_of_Loading__c ;
        }
        else{
            dto.postOfDischarge =item.Port_of_Discharge__c ;
            dto.postOfLoading =item.Port_of_Loading__c ;
        }
        dto.portShuttling =item.Port_Shuttling__c != null ? item.Port_Shuttling__c : 0;
        dto.seaFreight=item.Sea_Freight__c != null ? item.Sea_Freight__c : 0;
        dto.sealCharges=item.Seal_Charges__c != null ? item.Seal_Charges__c : 0;
        dto.tabadul=item.Tabadul__c != null ? item.Tabadul__c : 0;
        dto.tarapulin=item.Tarpauline_charge__c != null ? item.Tarpauline_charge__c : 0;
        dto.totalInco=item.Total_INCO__c != null ? item.Total_INCO__c : 0;
        dto.totalSL=item.Total_SL__c != null ? item.Total_SL__c : 0;
        dto.truckIdealing=item.Truck_idling_charges__c != null ? item.Truck_idling_charges__c : 0;
        dto.xRay=item.Xray__c != null ? item.Xray__c : 0;
        dto.recordtypeId = item.Quotation__r.RecordtypeId;
         
        //Added field
        dto.bayanCharges = item.Bayan_Charges__c != null ? item.Bayan_Charges__c : 0;
        dto.blFees = item.BL_Fees__c != null ? item.BL_Fees__c : 0;
        dto.carriageCongestionSurcharge = item.Carriage_Congestion_Surcharge__c != null ? item.Carriage_Congestion_Surcharge__c : 0;
        dto.dgSurcharge = item.DG_Surcharge__c != null ? item.DG_Surcharge__c : 0;
        dto.exportServiceFees = item.Export_Service_Fees__c != null ? item.Export_Service_Fees__c : 0;
        dto.fasahCharges = item.Fasah_Charges__c != null ? item.Fasah_Charges__c : 0;
        dto.fuelSurcharges = item.Fuel_Surcharge__c != null ? item.Fuel_Surcharge__c : 0;
        dto.gatePassCharges = item.Gate_pass_charges__c != null ? item.Gate_pass_charges__c : 0;
        dto.inlandFuelSurcharges = item.Inland_Fuel_Surcharge__c != null ? item.Inland_Fuel_Surcharge__c : 0;
        dto.inlandHandlingFees = item.Inland_Handling_Fees__c != null ? item.Inland_Handling_Fees__c : 0;
        dto.inlandHaulage = item.Inland_haulage__c != null ? item.Inland_haulage__c : 0;
        dto.lowSulpherSurcharge = item.Low_Sulphur_Surcharge__c != null ? item.Low_Sulphur_Surcharge__c : 0;
        dto.operationalRecoverySurcharge = item.Operational_Recovery_Surcharge__c != null ? item.Operational_Recovery_Surcharge__c : 0;
        dto.lashingCharges = item.Lashing_Charges__c != null ? item.Lashing_Charges__c : 0;
        dto.originDetentionCharges = item.Origin_Detention_Demurrage_Charges__c != null ? item.Origin_Detention_Demurrage_Charges__c : 0;
        dto.overWeightSurcharge = item.Overweight_surcharge__c != null ? item.Overweight_surcharge__c : 0;
        dto.pickupCharges = item.Pickup_Charges__c != null ? item.Pickup_Charges__c : 0;
        dto.totalDestination = item.Total_Dest__c != null ? item.Total_Dest__c : 0;
        dto.vgm = item.VGM__c != null ? item.VGM__c : 0;
        dto.warRiskCharges = item.War_Risk_Surcharge__c != null ? item.War_Risk_Surcharge__c : 0;
        dto.totalAdditional = item.Total_Additional__c != null ? item.Total_Additional__c : 0;
        dto.remarksAdditionalCharges = item.Remarks_Additional_Charges__c != null ? item.Remarks_Additional_Charges__c : '';
        dto.remarksDesinationCharges = item.Remarks_Destination_Charges__c != null ? item.Remarks_Destination_Charges__c : '';
        dto.remarksoriginCharges = item.Remarks_Origin_Charges__c != null ? item.Remarks_Origin_Charges__c : '';
        dto.remarksSLCharges = item.Remarks_SL_Charges__c != null ? item.Remarks_SL_Charges__c : '';
        dto.dOcharges = item.DO_charges__c != null ? item.DO_charges__c : 0;
        dto.lOLOCharges = item.LOLO_Charges__c != null ? item.LOLO_Charges__c : 0;
        dto.carrierSecurityFees = item.Carrier_Security_Fees__c != null ? item.Carrier_Security_Fees__c : 0;
        dto.pickupPlace = item.Pickup_Place__c;
        dto.dischargePlace = item.Discharge_Place__c;
        
        dto.addServiceCharge = item.Add_to_Buying_ShippingLine__c;
        dto.addOriginCharge = item.Add_to_Buying_Origin__c;
        dto.addDestinCharge = item.Add_to_Buying_Destination__c;
        dto.addAdditionalCharge = item.Add_to_Buying_Additional__c;
        dto.addExWorksCharge = item.Add_to_Buying_Ex_works__c;
        dto.includeServiceCharge = item.Included_PDF_ShippingLine__c;
        dto.includeOriginCharge = item.Included_PDF_Origin__c;
        dto.includeDestinCharge = item.Included_PDF_Destination__c;
        dto.includeAdditionalCharge = item.Included_PDF_Additional__c;
        dto.includeExWorksCharge = item.Included_PDF_Ex_works__c;
        dto.exWorksId = item.Ex_Works_Charge_Name__c;
        dto.exWorksCharge = item.Ex_Works_Charge__c;
        dto.orderBuyingRate = item.Buying_Rate__c > 0 ? item.Buying_Rate__c : 0;
        dto.shippLine = item.Shipping_Linee__c;
        dto.quoteItemId = item.id;
        dto.incoTermId = item.INCO_Term__c;
        dto.agentId = item.Agent__c;
        dto.containerLashing = item.Container_Lashing_Charges__c;
        return dto;
    }
    @AuraEnabled
    public static Order__c createOrder(List<BAFCOOrderCreationDto> orderCreationList, String validityDate, String custRefNumber, String bookRefNumber, String bbmsJobNumber, List<consigneeList> consigneeList, List<shipperList> shipperList, String OperationExec){
        Map<String,List<BAFCOOrderCreationDto.value>> routeIdToValueMap = new Map<String,List<BAFCOOrderCreationDto.value>>();
        Map<String,String> orderIdToOrderData = new  Map<String,String>();
        List<Order_Item__c> orderItemList = new  List<Order_Item__c>();
        List<Id> quoteItemId = new List<Id>(); 
        list<Order__c> orderList = new List<Order__c>();
        if(orderCreationList.size() > 0){
            for(BAFCOOrderCreationDto dto : orderCreationList){
                for(BAFCOOrderCreationDto.equipment item  : dto.equipment){
                    for(BAFCOOrderCreationDto.value vv : item.value){
                        if(!routeIdToValueMap.containsKey(vv.routeID+'-'+vv.shippLine)){
                            routeIdToValueMap.put(vv.routeID+'-'+vv.shippLine,new List<BAFCOOrderCreationDto.value>());
                        }
                        routeIdToValueMap.get(vv.routeID+'-'+vv.shippLine).add(vv);
                    }
                }                
            }
        }
        for(String key : routeIdToValueMap.keySet()){
            List<BAFCOOrderCreationDto.value> valueList = routeIdToValueMap.get(key);
            if(valueList.size() > 0){
                BAFCOOrderCreationDto.value orderData =valueList[0];
                Order__c orderObj = new Order__c();
                //orderObj.CurrencyIsoCode = orderData.currencyCode;
                orderObj.Account_Order__c = orderData.accountId;
                orderObj.Opportunity_Order__c = orderData.enquiryId;
                orderObj.Leadc_Order__c = orderData.leadId;
                orderObj.Quotation__c = orderData.quotationId;
                orderObj.Order_Validity__c = date.valueOf(validityDate);
                orderObj.recordtypeId = orderData.recordtypeId == QUOTE_EXPORT_RECORDTYPE_Id ? ORDER_EXPORT_RECORDTYPE_Id : ORDER_IMPORT_RECORDTYPE_Id;
                orderObj.Customer_Reference_Number__c = custRefNumber;
                orderObj.Booking_Reference_Number__c = bookRefNumber;
                orderObj.BBMS_Job_Number__c  = bbmsJobNumber;
                orderObj.Order_Item_Link__c = key;
                orderObj.isLCL__c = orderData.isLCL == true ? true : false;
                orderObj.isAir__c = orderData.isAir == true ? true : false;
                orderObj.Order_Type__c = orderData.quotationType;
                orderObj.Operations_Executive__c = OperationExec;
                orderObj.Remarks__c = orderData.quoteRemark;
                orderList.add(orderObj);
            }
        }
        if(orderList.size() > 0){
            insert orderList;
            for(Order__c ord : orderList){
                orderIdToOrderData.put(ord.Order_Item_Link__c,ord.Id);
            }
            for(BAFCOOrderCreationDto routeDto : orderCreationList){
                if(routeDto.equipment.size()>0){
                    for(BAFCOOrderCreationDto.equipment equipData : routeDto.equipment){
                        for(BAFCOOrderCreationDto.value orderDto : equipData.value){
                            Order_Item__c orderItem =  new Order_Item__c();
                            if(orderDto.isLCL == true || orderDto.isAir == true) orderItem.Tab_View__c = orderDto.tabView;
                            orderItem.BAF_Order__c = orderDto.baf;
                            orderItem.CurrencyIsoCode = orderDto.currencyCode;
                            orderItem.POD_freetime__c = orderDto.PODFreeTime;
                            orderItem.Selling_Rate_Kg__c = orderDto.sellingRateKg;
                            orderItem.Bayan_Order__c = orderDto.bayan;
                            orderItem.Bunker_surcharge_Order__c = orderDto.bunkerSurcharge;
                            orderItem.Cleaning_charges_Order__c = orderDto.cleaningCharges;
                            orderItem.CMC_Order__c = orderDto.containerMaintenance;
                            orderItem.Destination_Customs_Clearance_Order__c  =orderDto.destinationCustomClearnace;
                            orderItem.Destination_Loading_Charges_Order__c = orderDto.destinationLoading;
                            orderItem.Container_Lashing_Charges_Order__c = orderDto.containerLashing;
                            orderItem.DTHC_Order__c = orderDto.dthc;
                            orderItem.EIC_Order__c = orderDto.eic;
                            orderItem.Route__c = orderDto.routeID;
                            orderITem.Equipment_Type_Order__c = orderDto.equipmentType;
                            orderItem.Fasah_fee_Order__c = orderDto.fasahFee;
                            orderItem.Inspection_Order__c = orderDto.inspection;
                            orderItem.Insurance_charges_Order__c = orderDto.insurance;
                            orderItem.ISPS_Order__c = orderDto.isps;
                            orderItem.Lift_on_Lift_off_Order__c = orderDto.liftOnOff;
                            orderItem.Loading_Charges_Order__c = orderDto.loadingCharges;
                            orderItem.Order__c = orderIdToOrderData.get(orderDto.routeID+'-'+orderDto.shippLine);
                            orderItem.Origin_Customs_clearance_Order__c=orderDto.originCustomClearance;
                            orderItem.Origin_Loading_Charges_Order__c = orderDto.originloadingCharges;
                            orderItem.OTHC_Order__c = orderDto.othc;
                            orderItem.Agent_Profit_Share__c = orderDto.agentShare;
                            if(orderDto.isAir == true){
                                Quotation_Item__c quoteItem = [Select id,Total_CBM__c,Total_Gross_Weight__c,Total_Volumetric_Weight__c from Quotation_Item__c Where id=:orderDto.quoteItemId Limit 1];
                                orderItem.Total_CBM__c = quoteItem.Total_CBM__c;
                                orderItem.Total_Volumetric_Weight__c = quoteItem.Total_Volumetric_Weight__c;
                                orderItem.Total_Gross_Weight__c = quoteItem.Total_Gross_Weight__c;
                                orderItem.Airport_of_Destination__c = orderDto.postOfDischarge;
                                orderItem.Airport_of_Loading__c = orderDto.postOfLoading;
                            }
                            else{
                                orderItem.Port_of_Discharge_Order__c = orderDto.postOfDischarge;
                                orderItem.Port_of_Loading_Order__c = orderDto.postOfLoading;
                            }
                            orderitem.Airline__c = orderDto.airLineId;
                            orderitem.Port_Shuttling_Order__c = orderDto.portShuttling;
                            orderItem.Reefer_cntr_plug_in_charges_Order__c = orderDto.refeerCentr;
                            orderItem.RMS_Order__c = orderDto.rmsID;
                            orderItem.Route_Order__c = orderDto.routeID;
                            orderItem.Sea_Freight_Order__c = orderDto.seaFreight;
                            orderItem.Seal_Charges_Order__c = orderDto.sealCharges;
                            orderItem.Tabadul_Order__c = orderDto.tabadul;
                            orderItem.Tarpauline_charge_Order__c = orderDto.tarapulin;
                            orderItem.Total_INCO_Order__c = orderDto.totalInco;
                            orderItem.Total_Order__c = orderDto.sellingRate;
                            orderItem.Total_SL_Order__c = orderDto.totalSL;
                            orderItem.Truck_idling_charges_Order__c = orderDto.truckIdealing;
                            orderItem.Xray_Order__c = orderDto.xRay;
                            orderItem.Quantity__c = orderDto.Qty;
                            
                            orderItem.Bayan_Charges__c = orderDto.bayanCharges;
                            orderItem.BL_Fees__c = orderDto.blFees;
                            orderItem.Carriage_Congestion_Surcharge__c = orderDto.carriageCongestionSurcharge;
                            orderItem.DG_Surcharge__c = orderDto.dgSurcharge;
                            orderItem.Export_Service_Fees__c = orderDto.exportServiceFees;
                            orderItem.Fasah_Charges__c = orderDto.fasahCharges;
                            orderItem.Fuel_Surcharge__c = orderDto.fuelSurcharges;
                            orderItem.Gate_pass_charges__c = orderDto.gatePassCharges;
                            orderItem.Inland_Fuel_Surcharge__c = orderDto.inlandFuelSurcharges;
                            orderItem.Inland_Handling_Fees__c = orderDto.inlandHandlingFees;
                            orderItem.Inland_haulage__c = orderDto.inlandHaulage;
                            orderItem.Low_Sulphur_Surcharge__c = orderDto.lowSulpherSurcharge;
                            orderItem.Operational_Recovery_Surcharge__c = orderDto.operationalRecoverySurcharge;
                            orderItem.Lashing_Charges__c = orderDto.lashingCharges;
                            orderItem.Origin_Detention_Demurrage_Charges__c = orderDto.originDetentionCharges;
                            orderItem.Overweight_Overheight_surcharge__c = orderDto.overWeightSurcharge;
                            orderItem.Pickup_Charges__c = orderDto.pickupCharges;
                            orderItem.Total_Destination_c__c = orderDto.totalDestination;
                            orderItem.VGM__c = orderDto.vgm;
                            orderItem.War_Risk_Surcharge__c = orderDto.warRiskCharges;
                            orderItem.Total_Additional__c = orderDto.totalAdditional;
                            orderItem.Remarks_Additional_Charges__c = orderDto.remarksAdditionalCharges;
                            orderItem.Remarks_Destination_Charges__c = orderDto.remarksDesinationCharges;
                            orderItem.Remarks_Origin_Charges__c = orderDto.remarksoriginCharges;
                            orderItem.Remarks_SL_Charges__c = orderDto.remarksSLCharges;
                            orderitem.DO_charges__c = orderDto.dOcharges;
                            orderitem.LOLO_Charges__c = orderDto.lOLOCharges;
                            orderitem.Carrier_Security_Fees__c = orderDto.carrierSecurityFees;
                            orderitem.Pickup_Place__c = orderDto.pickupPlace;
                            orderitem.Discharge_Place__c = orderDto.dischargePlace;
                            orderitem.Add_to_Buying_ShippingLine__c = orderDto.addServiceCharge;
                            orderitem.Add_to_Buying_Origin__c = orderDto.addOriginCharge;
                            orderitem.Add_to_Buying_Destination__c = orderDto.addDestinCharge;
                            orderitem.Add_to_Buying_Additional__c = orderDto.addAdditionalCharge;
                            orderitem.Add_to_Buying_Ex_works__c = orderDto.addExWorksCharge;
                            orderitem.Included_PDF_ShippingLine__c = orderDto.includeServiceCharge ;
                            orderitem.Included_PDF_Origin__c = orderDto.includeOriginCharge;
                            orderitem.Included_PDF_Destination__c = orderDto.includeDestinCharge;
                            orderitem.Included_PDF_Additional__c = orderDto.includeAdditionalCharge;
                            orderitem.Included_PDF_Ex_works__c = orderDto.includeExWorksCharge;
                            orderitem.Ex_Works_Charge_Name__c = orderDto.exWorksId;
                            orderitem.Ex_Works_Charge__c = orderDto.exWorksCharge;
                            orderitem.Buying_Rate__c = orderDto.orderBuyingRate;
                            orderItem.Shipping_Line__c = orderDto.shippLine;
                            orderItem.Quotation_Item__c = orderDto.quoteItemId;
                            if(orderDto.quoteItemId != null) quoteItemId.add(orderDto.quoteItemId);
                            orderItem.Agent__c = orderDto.agentId;
                            orderItem.INCO_Term__c = orderDto.incoTermId;
                            orderItem.Charges_Included__c = orderDto.chargesIncluded;
                            orderItem.Selling_Charges_Included__c = orderDto.sellingChargesIncluded;
                            orderItem.Chargeable_Weight__c = orderDto.chargeableWeight;
                            orderItem.Operational_Charges_buying__c = orderDto.operationalChargeBuying;
                            orderItem.Operational_Charges_selling__c = orderDto.operationalChargeSelling;
                            if(orderDto.checkBoxSelected == true) orderItemList.add(orderItem);
                        }
                    }
                }
            }
            ////
            system.debug('orderItemList '+orderItemList.size());
            system.debug('orderItemList '+orderItemList);
            if(orderItemList.size()>0){
                insert orderItemList;
                system.debug(' after insert orderItemList '+orderItemList);
                List<Consignee__c> conList = new List<Consignee__c>();
                List<Shipper__c> shipList = new List<Shipper__c>();
                for(Order_Item__c item : orderItemList){
                    if(consigneeList.size() > 0){
                        for(consigneeList consObj : consigneeList){
                            if(consObj.consigneeId != null){
                                Consignee__c coObj = new Consignee__c();
                                coObj.Consignee__c=consObj.consigneeId;
                                coObj.Order_Item__c = item.id;
                                conList.add(coObj);
                            }
                        }
                    }
                    if(shipperList.size() > 0){
                        for(shipperList ssObj : shipperList){
                            Shipper__c shipObj = new Shipper__c();
                            shipObj.Shipper__c = ssObj.shipperId;
                            shipObj.Order_Item__c= item.id;
                            shipList.add(shipObj);
                        }
                    }
                }
                if(conList.size() > 0) insert conList;
                if(shipList.size() > 0) insert shipList;
                
                //AdditionalCharge Changes
                if(quoteItemId.size() > 0){
                    List<Order_Charges__c> orderChargeList =new List<Order_Charges__c>();
                    Map<Id,List<Quotation_Charges__c>> itemIdtoQuoteMap = new Map<Id,List<Quotation_Charges__c>>();
                    for(Quotation_Charges__c chrgeObj : [Select isExWorks__c,id,Charge_Value__c,Buying_Rate__c,Charge_Name__c,Quotation_Item__c,Charge_Name_text__c from Quotation_Charges__c where Quotation_Item__c in : quoteItemId]){
                        if(!itemIdtoQuoteMap.containsKey(chrgeObj.Quotation_Item__c)) 
                        itemIdtoQuoteMap.put(chrgeObj.Quotation_Item__c,new List<Quotation_Charges__c>());
                        itemIdtoQuoteMap.get(chrgeObj.Quotation_Item__c).add(chrgeObj);
                    }
                    system.debug('itemIdtoQuoteMap '+itemIdtoQuoteMap.size());
                    for(Order_Item__c item : orderItemList){
                        if(itemIdtoQuoteMap.containsKey(item.Quotation_Item__c)){
                            for(Quotation_Charges__c chrgeObj : itemIdtoQuoteMap.get(item.Quotation_Item__c)){
                                Order_Charges__c orderChargeObj = new Order_Charges__c();
                                orderChargeObj.Charge_Name__c = chrgeObj.Charge_Name__c;
                                orderChargeObj.Charge_Value__c = chrgeObj.Charge_Value__c;
                                orderChargeObj.Buying_Rate__c = chrgeObj.Buying_Rate__c;
                                orderChargeObj.Charge_Name_Text__c = chrgeObj.Charge_Name_text__c;
                                orderChargeObj.Order_Item__c = item.id;
                                orderChargeObj.isAdditionalCharge__c = true;
                                orderChargeObj.isExWorks__c = chrgeObj.isExWorks__c;
                                orderChargeList.add(orderChargeObj);
                            }
                        }
                    }
                    if(orderChargeList.size() > 0) insert orderChargeList;
                }
            }
        } 
        if(orderList.size() > 0){
            return orderList[0];
        }
        return null;
    }
    @AuraEnabled
    public static Order__c getOrderRecordType(String recordId) {
        return [Select recordtype.name,Order_Type__c from Order__c where id =: recordId limit 1];
    }
    @AuraEnabled
    public static string cloneOrder(String recordId) {
        List<String> orderItemId = new List<String>();
        Map<Id, List<Order_Charges__c>> itemIdtoOrderChargeMap = new Map<Id, List<Order_Charges__c>>();
        Map<Id, List<Shipper__c>> itemIdtoShipperMap = new Map<Id, List<Shipper__c>>();
        Map<Id, List<Consignee__c>> itemIdtoConsigneeMap = new Map<Id, List<Consignee__c>>();
        Order__c orderObj = [SELECT RecordtypeId,BBMS_Job_Number__c, Record_Number__c, Order_Type__c, isAir__c, isLCL__c, Amendment_Remarks__c, Total_Teus__c, Status__c, BSLS_ID__c, Order_Item_Link__c, Booking_Reference_Number__c, Customer_Reference_Number__c, Amount__c, Target__c, Opportunity_Order__c, Branch__c, Operations_Executive__c, Integration__c, Customer_Name__c, Quotation__c, Order_Validity__c, Leadc_Order__c, Account_Order__c, Booking_Party__c, CurrencyIsoCode, Name FROM Order__c where id =: recordId];
        Order__c orderObjCloneCopy  = orderObj.clone(false, false, false, false);
        insert orderObjCloneCopy;
        List<Order_Item__c> itemList = new List<Order_Item__c>();
        for(Order_Item__c item : [SELECT Id, Name, Agent__c, BAF_Order__c, BL_Fees__c, Bayan_Charges__c, Bayan_Order__c, Bayan_cancellation_charge_Order__c, Bunker_surcharge_Order__c, CMC_Order__c, Carriage_Congestion_Surcharge__c, Carrier_Security_Fees__c, Cleaning_charges_Order__c, Container_Lashing_Charges_Order__c, Container_movement_charges_Order__c, Container_stripping_Order__c, DG_Surcharge__c, DO_charges__c, DTHC_Order__c, Destination_Customs_Clearance_Order__c, Destination_Loading_Charges_Order__c, EIC_Order__c, Equipment_Type_Order__c, Export_Service_Fees__c, Fasah_Charges__c, Fasah_fee_Order__c, Free_time_certificate_charges_Order__c, Fuel_Surcharge__c, Fumigation_Order__c, Gate_pass_charges__c, ISPS_Order__c, Inland_Fuel_Surcharge__c, Inland_Handling_Fees__c, Inland_haulage__c, Inspection_Order__c, Insurance_charges_Order__c, LOLO_Charges__c, Lashing_Charges__c, Lift_on_Lift_off_Order__c, Low_Sulphur_Surcharge__c, MCCFOOGC_Order__c, Loading_Charges_Order__c, MOT_fine_charges_Order__c, Non_Palletized_Surcharge_Order__c, Miscellaneous_Order__c, OTHC_Order__c, Operational_Recovery_Surcharge__c, Origin_Customs_clearance_Order__c, Origin_Detention_Demurrage_Charges__c, Origin_Loading_Charges_Order__c, Overweight_Overheight_surcharge__c, Pest_control_Order__c, Pickup_Charges__c, Port_Shuttling_Order__c, Port_of_Discharge_Order__c, Port_of_Loading_Order__c, Quantity__c, RMS_Order__c, Re_palletization_Order__c, Reefer_PTI_charges_Order__c, Reefer_cntr_plug_in_charges_Order__c, Reefer_steam_wash_Order__c, Remarks_Additional_Charges__c, Remarks_Destination_Charges__c, Remarks_Origin_Charges__c, Remarks_SL_Charges__c, Route_Order__c, Sea_Freight_Order__c, Seal_Charges_Order__c, Stuffing_Charges_Order__c, Sweeping_Cleaning_Order__c, Tabadul_Order__c, Tarpauline_charge_Order__c, Total_Additional__c, Total_Destination_c__c, Total_INCO_Order__c, Total_Order__c, Total_SL_Order__c, Truck_Head_charges_Order__c, Truck_idling_charges_Order__c, VGM__c, Vessel_certificate_charges_Order__c, War_Risk_Surcharge__c, Wrapping_packing_charges_Order__c, Xray_Order__c, Shipping_Line_Order__c, Teus__c, Place_of_Pickup__c, Place_of_Discharge__c, Ex_Works_Charge__c, Ex_Works_Charge_Name__c, Add_to_Buying_Additional__c, Add_to_Buying_Destination__c, Add_to_Buying_Ex_works__c, Add_to_Buying_Origin__c, Add_to_Buying_ShippingLine__c, Included_PDF_Additional__c, Included_PDF_Destination__c, Included_PDF_Ex_works__c, Included_PDF_Origin__c, Included_PDF_ShippingLine__c, Freight_Difference_FD__c, Alternate_depot_release_charges__c, Carrier_container_repositioning_charges__c, Vessel_ETD__c, Buying_Rate__c, Shipping_Line__c, Quotation_Item__c, Pickup_Place__c, Discharge_Place__c, Tank_Rental_Charges__c, BSLS_ID__c, Profit_Margin__c, Greater_Vessel_ETD__c, Teus_FB__c, Buying_Rate_Type__c, INCO_Term__c, Route__c, Route_Profit_Margin__c, Profit__c, Customer_Port_Pair_Margin__c, Tab_View__c, Airport_of_Destination__c, Airport_of_Loading__c, Commodity__c, Charges_Included__c, Transit_Time__c, Agent_Profit_Share__c, Selling_Charges_Included__c, Operational_Charges_buying__c, Operational_Charges_selling__c, POD_freetime__c, Order_Cancelled__c, Selling_Rate_Kg__c, Total_CBM__c, Total_Volumetric_Weight__c, Total_Gross_Weight__c, Airline__c FROM Order_Item__c where Order__c =: recordId]){
            orderItemId.add(item.id);
            Order_Item__c obj = new Order_Item__c();
            obj = item;
            obj.id = null;
            obj.Order__c = orderObjCloneCopy.id;
            obj.BSLS_ID__c = null;
            obj.Parent_OrderItem__c = item.id;
            itemList.add(obj);
        }
        if(itemList.size() >0 ) {
            insert itemList;
            for(Order_Charges__c orderChargeObj : [SELECT Id, Name, Charge_Name_Text__c, isAdditionalCharge__c, Buying_Rate__c, Order_Item__c, Charge_Value__c, Charge_Type__c, Charge_Name__c FROM Order_Charges__c where Order_Item__c in :orderItemId ]){
                if(!itemIdtoOrderChargeMap.containskey(orderChargeObj.Order_Item__c)){
                    itemIdtoOrderChargeMap.put(orderChargeObj.Order_Item__c,new List<Order_Charges__c>());
                }
                itemIdtoOrderChargeMap.get(orderChargeObj.Order_Item__c).add(orderChargeObj);
            }
            for(Shipper__c shipperObj : [SELECT Id, Order_Item__c, Shipper__c, Name FROM Shipper__c where Order_Item__c in : orderItemId]){
                if(!itemIdtoShipperMap.containskey(shipperObj.Order_Item__c)){
                    itemIdtoShipperMap.put(shipperObj.Order_Item__c,new List<Shipper__c>());
                }
                itemIdtoShipperMap.get(shipperObj.Order_Item__c).add(shipperObj);
            }
            for(Consignee__c consigneeObj : [SELECT Order_Item__c, Consignee__c, Name, Id FROM Consignee__c where Order_Item__c in : orderItemId]){
                if(!itemIdtoConsigneeMap.containskey(consigneeObj.Order_Item__c)){
                    itemIdtoConsigneeMap.put(consigneeObj.Order_Item__c,new List<Consignee__c>());
                }
                itemIdtoConsigneeMap.get(consigneeObj.Order_Item__c).add(consigneeObj);
            }
            List<Order_Charges__c> newChargeList = new list<Order_Charges__c>();
            List<Shipper__c> newShipperList = new list<Shipper__c>();
            List<Consignee__c> newConsigneeList = new list<Consignee__c>();
            for(Order_Item__c item : itemList){
                if(itemIdtoOrderChargeMap.containsKey(item.Parent_OrderItem__c)){
                    for(Order_Charges__c orderChargeObj : itemIdtoOrderChargeMap.get(item.Parent_OrderItem__c)){
                        Order_Charges__c obj = new Order_Charges__c();
                        obj = orderChargeObj;
                        obj.Order_Item__c = item.id;
                        newChargeList.add(obj);
                    }
                }
                if(itemIdtoShipperMap.containsKey(item.Parent_OrderItem__c)){
                    for(Shipper__c ShipperObj : itemIdtoShipperMap.get(item.Parent_OrderItem__c)){
                        Shipper__c obj = new Shipper__c();
                        obj = ShipperObj;
                        obj.Order_Item__c = item.id;
                        newShipperList.add(obj);
                    }
                }
                if(itemIdtoConsigneeMap.containsKey(item.Parent_OrderItem__c)){
                    for(Consignee__c ConsigneeObj : itemIdtoConsigneeMap.get(item.Parent_OrderItem__c)){
                        Consignee__c obj = new Consignee__c();
                        obj = ConsigneeObj;
                        obj.Order_Item__c = item.id;
                        newConsigneeList.add(obj);
                    }
                }
            }
            if(newConsigneeList.size() > 0) Insert newConsigneeList;
            if(newShipperList.size() > 0) Insert newShipperList;
            if(newChargeList.size() > 0) Insert newChargeList;
        }
        system.debug('orderObjCloneCopy '+orderObjCloneCopy.id);
        return orderObjCloneCopy.id;
    }
    public class EquipData{
        @AuraEnabled public string quoteRemark{get;set;}
        @AuraEnabled public string operationalChargeBuying{get;set;}
        @AuraEnabled public string operationalChargeSelling{get;set;}
        @AuraEnabled public Decimal chargeableWeight { get; set; }
        @AuraEnabled public string currencyCode{get;set;}
        @AuraEnabled public string airLineId{get;set;}
        @AuraEnabled
        public Decimal PODFreeTime { get; set; }
        @AuraEnabled
        public Decimal sellingRateKg { get; set; }
        @AuraEnabled
        public String quotationType { get; set; }
        @AuraEnabled
        public String shipName { get; set; }
        @AuraEnabled
        public Boolean isLCL { get; set; }
        @AuraEnabled
        public Boolean isAir { get; set; }
        @AuraEnabled
        public String recordtypeId { get; set; }
        @AuraEnabled
        public String chargesIncluded { get; set; }
        @AuraEnabled
        public String quotationId { get; set; }
        @AuraEnabled
        public String enquiryId { get; set; }
        @AuraEnabled
        public String sellingChargesIncluded { get; set; }
        @AuraEnabled
        public String accountId { get; set; }
        @AuraEnabled
        public String leadId { get; set; }
        @AuraEnabled
        public Decimal sellingRate { get; set; }
        @AuraEnabled
        public Decimal baf { get; set; }
        @AuraEnabled
        public Decimal bayan { get; set; }
        @AuraEnabled
        public Decimal bunkerSurcharge { get; set; }
        @AuraEnabled
        public Decimal cleaningCharges { get; set; }
        @AuraEnabled
        public Decimal containerMaintenance { get; set; }
        @AuraEnabled
        public Decimal destinationCustomClearnace { get; set; }
        @AuraEnabled
        public Decimal destinationLoading { get; set; }
        @AuraEnabled
        public Decimal dthc { get; set; }
        @AuraEnabled
        public Decimal eic { get; set; }
        @AuraEnabled
        public String equipmentType { get; set; }
        @AuraEnabled
        public Decimal fasahFee { get; set; }
        @AuraEnabled
        public Decimal inspection { get; set; }
        @AuraEnabled
        public Decimal insurance { get; set; }
        @AuraEnabled
        public Decimal isps { get; set; }
        @AuraEnabled
        public Decimal liftOnOff { get; set; }
        @AuraEnabled
        public Decimal loadingCharges { get; set; }
        @AuraEnabled
        public Decimal originCustomClearance { get; set; }
        @AuraEnabled
        public Decimal originloadingCharges { get; set; }
        @AuraEnabled
        public Decimal othc { get; set; }
        @AuraEnabled
        public String postOfDischarge { get; set; }
        @AuraEnabled
        public String postOfLoading { get; set; }
        @AuraEnabled
        public Decimal portShuttling { get; set; }
        @AuraEnabled
        public Decimal refeerCentr { get; set; }
        @AuraEnabled
        public String rmsID{ get; set; }
        @AuraEnabled
        public String routeID{ get; set; }
        @AuraEnabled
        public Decimal seaFreight{ get; set; }
        @AuraEnabled
        public Decimal sealCharges{ get; set; }
        @AuraEnabled
        public Decimal tabadul{ get; set; }
        @AuraEnabled
        public Decimal tarapulin{ get; set; }
        @AuraEnabled
        public Decimal totalInco{ get; set; }
        @AuraEnabled
        public Decimal totalSL{ get; set; }
        @AuraEnabled
        public Decimal truckIdealing{ get; set; }
        @AuraEnabled
        public Decimal Qty{ get; set; }
        @AuraEnabled
        public Decimal xRay{ get; set; }
        @AuraEnabled
        public Boolean checkBoxSelected { get; set; }
        
        
        @AuraEnabled public Decimal bayanCharges{ get; set; }
        @AuraEnabled public Decimal blFees{ get; set; }
        @AuraEnabled public Decimal carriageCongestionSurcharge{ get; set; }
        @AuraEnabled public Decimal dgSurcharge{ get; set; }
        @AuraEnabled public Decimal exportServiceFees{ get; set; }
        @AuraEnabled public Decimal fasahCharges{ get; set; }
        @AuraEnabled public Decimal fuelSurcharges{ get; set; }
        @AuraEnabled public Decimal gatePassCharges{ get; set; }
        @AuraEnabled public Decimal inlandFuelSurcharges{ get; set; }
        @AuraEnabled public Decimal inlandHandlingFees{ get; set; }
        @AuraEnabled public Decimal inlandHaulage{ get; set; }
        @AuraEnabled public Decimal lowSulpherSurcharge{ get; set; }
        @AuraEnabled public Decimal containerLashing{ get; set; }
        @AuraEnabled public Decimal operationalRecoverySurcharge{ get; set; }
        @AuraEnabled public Decimal lashingCharges{ get; set; }
        @AuraEnabled public Decimal originDetentionCharges{ get; set; }
        @AuraEnabled public Decimal overWeightSurcharge{ get; set; }
        @AuraEnabled public Decimal pickupCharges{ get; set; }
        @AuraEnabled public Decimal totalDestination{ get; set; }
        @AuraEnabled public Decimal vgm{ get; set; }
        @AuraEnabled public Decimal warRiskCharges{ get; set; }
        @AuraEnabled public Decimal totalAdditional{ get; set; }
        @AuraEnabled public String remarksAdditionalCharges{ get; set; }
        @AuraEnabled public String remarksDesinationCharges{ get; set; }
        @AuraEnabled public String remarksoriginCharges{ get; set; }
        @AuraEnabled public String remarksSLCharges{ get; set; }
        
        @AuraEnabled public Decimal dOcharges{ get; set; }
        @AuraEnabled public Decimal lOLOCharges{ get; set; }
        @AuraEnabled public Decimal carrierSecurityFees{ get; set; }
        @AuraEnabled public String pickupPlace { get; set; }
        @AuraEnabled public String dischargePlace { get; set; }
        @AuraEnabled public boolean addServiceCharge {get;set;}
        @AuraEnabled public boolean addOriginCharge {get;set;}
        @AuraEnabled public boolean addDestinCharge {get;set;}
        @AuraEnabled public boolean addAdditionalCharge {get;set;}
        @AuraEnabled public boolean addExWorksCharge {get;set;}
        @AuraEnabled public boolean includeServiceCharge {get;set;}
        @AuraEnabled public boolean includeOriginCharge {get;set;}
        @AuraEnabled public boolean includeDestinCharge {get;set;}
        @AuraEnabled public boolean includeAdditionalCharge {get;set;}
        @AuraEnabled public boolean includeExWorksCharge {get;set;}
        @AuraEnabled public String exWorksId {get;set;}
        @AuraEnabled public Decimal exWorksCharge {get;set;}
        @AuraEnabled public decimal orderBuyingRate {get; set;}
        @AuraEnabled public String shippLine {get; set;}
        @AuraEnabled public String quoteItemId {get; set;}
        @AuraEnabled public String agentId {get; set;}
        @AuraEnabled public String incoTermId { get; set; }
    }
    public class consigneeList{
        @AuraEnabled public String consigneeId {get; set;}
        @AuraEnabled public String consigneeName {get; set;}
    }
    public class shipperList{
        @AuraEnabled public String shipperId {get; set;}
        @AuraEnabled public String shipperName {get; set;}
    }
}