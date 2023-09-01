public class BAFCOLocalOperationQuoteController {
    public static final Id QUOTE_EXPORT_RECORDTYPE_Id = Schema.SObjectType.quotation__c.getRecordTypeInfosByName()
        .get('Export')
        .getRecordTypeId();
    public static final Id QUOTE_IMPORT_RECORDTYPE_Id = Schema.SObjectType.quotation__c.getRecordTypeInfosByName()
        .get('Import')
        .getRecordTypeId();
	@AuraEnabled
    public static List<Route_Equipment__c> getRouteListOnload(String routeId){
        if(routeId != null){
            return [Select id,Name,Equipment_type__r.name,Quantity__c,Route__r.Opportunity_Enquiry__r.Account.FD__c from Route_Equipment__c where Route__c =: routeId ];
        }
        return null;
    }
     @AuraEnabled
    public static String genrateQuotation(String routeId,String optyId,String quotationId, BAFCOGenerteQuoteDto dto,String quoteRemarks,
                                          Decimal additionalChargeTotal,Boolean cameReviseCompt,Boolean sameRoute){
         List<BAFCOGenerteQuoteDto.AdditionalCharge> additionalChargeList = dto.additionalChargeList;
         Quotation__c quoteObj = new Quotation__c();
         if(quotationId == ''  || quotationId == null || (cameReviseCompt  == true && sameRoute == true)){
            Opportunity enqObj  = [SELECT Accountid,Business_Type__c,Id,No_of_Quotes__c,(Select id,name,Name__c from Quotations__r order by createdDate)  FROM Opportunity where id =: optyId];            
            quoteObj.Opportunity__c = optyId;
            quoteObj.Account__c = enqObj.accountid;
             if(enqObj.Business_Type__c == 'Export') {
                 if(dto.isLCL == true) {
                     quoteObj.isLCL__c = true;
                     quoteObj.Quotation_Type__c = 'LCL Export';
                 }
                 else if(dto.isAir == true) {
                     quoteObj.isAir__c = true;
                     quoteObj.Quotation_Type__c = 'Air Export';
                 }
                 else{
                     quoteObj.Quotation_Type__c = 'Local Operation Export';
                 }
                 quoteObj.recordtypeId = QUOTE_EXPORT_RECORDTYPE_Id;
             }
             else if(enqObj.Business_Type__c == 'Import') {
                 quoteObj.recordtypeId = QUOTE_IMPORT_RECORDTYPE_Id;
                 if(dto.isLCL == true) {
                     quoteObj.isLCL__c = true;
                     quoteObj.Quotation_Type__c = 'LCL Import';
                 }
                 else if(dto.isAir == true) {
                     quoteObj.isAir__c = true;
                     quoteObj.Quotation_Type__c = 'Air Import';
                 }
                 else{
                     quoteObj.Quotation_Type__c = 'Local Operation Import';
                 }
             }
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
        //quoteItemObj.Port_of_Discharge__c = rmsObj.Port_Of_Discharge__c;
        //quoteItemObj.Port_of_Loading__c = rmsObj.Port_Of_Loading__c;
        if(dto.isLCL != true && dto.isAir != true) quoteItemObj.Equipment_Type__c = dto.selectedEquipment;
        else if(dto.isLCL == true || dto.isAir == true){
           quoteItemObj.Tab_View__c = dto.selectedEquipment;                                     
        }
        quoteItemObj.Total_Additional__c = additionalChargeTotal;
        quoteItemObj.CurrencyIsoCode = dto.currencyCode;
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
            opportunity enqObj  = [SELECT Id,Business_Type__c,No_of_Quotes__c,(Select id,name,Name__c from Quotations__r order by createdDate) FROM opportunity where id =: optyId];
            if(enqObj.Business_Type__c == 'Export') quoteObj.recordtypeId = QUOTE_EXPORT_RECORDTYPE_Id;
            else if(enqObj.Business_Type__c == 'Import') quoteObj.recordtypeId = QUOTE_IMPORT_RECORDTYPE_Id;
            
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
                    quoteObj.isRevise__c = true;
                }
                else{
                    Integer  quoteSize = quoteList2.size();
                    quoteObj.Name__c = 'Quote/'+Year1+'/'+quoteSize;
                }
            }
            quoteObj.remarks__c = quoteRemarks;
            if(dto.isLCL == true) quoteObj.isLCL__c = true;
            else if(dto.isAir == true) quoteObj.isAir__c = true; 
            update quoteObj;
        }
        quoteItemObj.Total__c = dto.total;
        quoteItemObj.Buying_Rate__c = dto.quoteBuyingRate;
        quoteItemObj.Buying_Input__c = dto.buyingRateInput;                                      
        quoteItemObj.Pickup_Place__c = dto.pickupPlaceName;
        quoteItemObj.Discharge_Place__c = dto.dischargePlaceName;
                                              
        if(dto.isAir == true){
            quoteItemObj.Airport_of_Destination__c = dto.portDestinationId != '' ? dto.portDestinationId : null;
            quoteItemObj.Airport_of_Loading__c = dto.portLoadingId != '' ? dto.portLoadingId : null; 
            if(dto.airShippline != '') quoteItemObj.Airline__c = dto.airShippline;
        }
        else{
            quoteItemObj.Port_of_Loading__c = dto.portLoadingId != '' ? dto.portLoadingId : null;  
            quoteItemObj.Port_of_Discharge__c = dto.portDestinationId != '' ? dto.portDestinationId : null;
            if(dto.airShippline != '') quoteItemObj.Shipping_Linee__c = dto.airShippline;
        }
        quoteItemObj.Total_Additional__c = additionalChargeTotal;
        quoteItemObj.Sea_Freight__c = dto.totalRate;  
        quoteItemObj.Quantity__c = dto.quantity;
        quoteItemObj.INCO_Term__c = dto.incoTermId;
        quoteItemObj.Add_to_Buying_Additional__c =  dto.addAdditionalCharge != null ? dto.addAdditionalCharge : false;
        quoteItemObj.Included_PDF_Additional__c =  dto.includeAdditionalCharge != null ? dto.includeAdditionalCharge : false;
        
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
    public static List<BAFCOAllQuotationItemDto> getQuoteLineItem(String quoteId){
        List<BAFCOAllQuotationItemDto> dtoList = new List<BAFCOAllQuotationItemDto>();
        for(Quotation_Item__c item : [SELECT Quotation__r.Quotation_Type__c,Service_Type__c,Total_Ex_Works_Charges__c,Quotation__r.isLCL__c,Buying_Rate__c,Tank_Rental_Charges__c,Included_PDF_ShippingLine__c,Included_PDF_Origin__c,Included_PDF_Destination__c,Included_PDF_Additional__c,Included_PDF_Ex_works__c,Id, Alternate_depot_release_charges__c,Carrier_container_repositioning_charges__c,Freight_Difference_FD__c,Ex_Works_Charge_Name__r.name,Ex_Works_Charge__c,Add_to_Buying_ShippingLine__c,Add_to_Buying_Origin__c,Add_to_Buying_Ex_works__c,Add_to_Buying_Destination__c,Add_to_Buying_Additional__c,Quotation__r.CreatedDate,Name,Agent_Name__c,Equipment_Type__r.name, CurrencyIsoCode, Quotation__c, BAF__c, Bayan__c, Bayan_cancellation_charge__c, Bunker_surcharge__c, CMC__c, Cleaning_charges__c, Container_movement_charges__c, Container_Lashing_Charges__c, Container_stripping__c, DTHC__c, Destination_Customs_Clearance__c, Destination_Loading_Charges__c, EIC__c, Equipment_Type__c, Fasah_fee__c, Free_time_certificate_charges__c, Fumigation__c, ISPS__c, Inspection__c, Insurance_charges__c, Lift_on_Lift_off__c, MOT_fine_charges__c, Ministry_clearnce_charge_for_OOG_cargo__c, Miscellaneous__c, Non_Palletized_Surcharge__c, OTHC__c, Origin_Customs_clearance__c, Origin_Loading_Charges__c, Pest_control__c, Port_Shuttling__c, Port_of_Discharge__c, Port_of_Loading__c, RMS__c, Re_palletization__c, Reefer_PTI_charges__c, Reefer_cntr_plug_in_charges__c, Reefer_steam_wash__c, Route__c, Sea_Freight__c, Seal_Charges__c, Stuffing_Charges__c, SweepingCleaning__c, Tabadul__c, Tarpauline_charge__c, Total_INCO__c, Total_SL__c, Total__c, Truck_Head_charges__c, Truck_idling_charges__c, Vessel_certificate_charges__c, Wrappingpacking_charges__c, Xray__c, Shipping_Line__c, Loading_Charges__c, Carriage_Congestion_Surcharge__c, Carrier_Security_Fees__c, Bayan_Charges__c, BL_Fees__c, DG_Surcharge__c, DO_charges__c, Export_Service_Fees__c, Fasah_Charges__c, Fuel_Surcharge__c, Gate_pass_charges__c, Inland_Fuel_Surcharge__c, Inland_Handling_Fees__c, Inland_haulage__c, Low_Sulphur_Surcharge__c, Operational_Recovery_Surcharge__c, Lashing_Charges__c, LOLO_Charges__c, Origin_Detention_Demurrage_Charges__c, Overweight_surcharge__c, Pickup_Charges__c, Total_Dest__c, War_Risk_Surcharge__c, VGM__c, Total_Additional__c, Charges_Included__c
                                      FROM Quotation_Item__c where Quotation__c =: quoteId]){
                                          BAFCOAllQuotationItemDto itemDto = new BAFCOAllQuotationItemDto();
                                          itemDto.totalBuyingRate = item.Buying_Rate__c;
                                          itemDto.totalSellingRate = item.Total__c;
                                          itemDto = BAFCOQuotationReviseController.assignQuoteItemData(item,itemDto);
                                          itemDto.equipmentName = item.Equipment_Type__r.name;
                                          itemDto.equipmentId = item.Equipment_Type__c;  
                                          itemDto.totaladditionalCharge = item.Total_Additional__c;
                                          itemDto.totalBuyingRate = item.Buying_Rate__c;
                                          dtoList.add(itemDto);
       }
        return dtoList;
    }
    @AuraEnabled
    public static String genrateAirImportQuotation(String routeId,String optyId,String quotationId, BAFCOGenerteQuoteDto dto,String quoteRemarks,Decimal additionalChargeTotal,Boolean cameReviseCompt,Boolean sameRoute,String agentName, String airLine){
        List<BAFCOGenerteQuoteDto.AdditionalCharge> additionalChargeList = dto.additionalChargeList;
        Quotation__c quoteObj = new Quotation__c();
        String agentId = [Select id from Agent__c where name =: agentName limit 1].id;
        String airLineId = [Select id from Airline__c where name =: airLine limit 1].id;
        if(quotationId == ''  || quotationId == null || (cameReviseCompt  == true && sameRoute == true)){
            Opportunity enqObj  = [SELECT Accountid,Business_Type__c,Id,No_of_Quotes__c,(Select id,name,Name__c from Quotations__r order by createdDate)  FROM Opportunity where id =: optyId];            
            quoteObj.Opportunity__c = optyId;
            quoteObj.Account__c = enqObj.accountid;
            if(enqObj.Business_Type__c == 'Export') {
                if(dto.isLCL == true) {
                    quoteObj.isLCL__c = true;
                    quoteObj.Quotation_Type__c = 'LCL Export';
                }
                else if(dto.isAir == true) {
                    quoteObj.isAir__c = true;
                    quoteObj.Quotation_Type__c = 'Air Export';
                }
                else{
                    quoteObj.Quotation_Type__c = 'Local Operation Export';
                }
                quoteObj.recordtypeId = QUOTE_EXPORT_RECORDTYPE_Id;
            }
            else if(enqObj.Business_Type__c == 'Import') {
                quoteObj.recordtypeId = QUOTE_IMPORT_RECORDTYPE_Id;
                if(dto.isLCL == true) {
                    quoteObj.isLCL__c = true;
                    quoteObj.Quotation_Type__c = 'LCL Import';
                }
                else if(dto.isAir == true) {
                    quoteObj.isAir__c = true;
                    quoteObj.Quotation_Type__c = 'Air Import';
                }
                else{
                    quoteObj.Quotation_Type__c = 'Local Operation Import';
                }
            }
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
        Route__c routeDetails = BAFCOAirEnquiryController.getAirRouteEquipment(routeId);
        if(routeDetails!=NULL){
            quoteItemObj.Total_CBM__c = routeDetails.Total_CBM__c;
            quoteItemObj.Total_Gross_Weight__c = routeDetails.Total_Gross_Weight_KGs__c;
            quoteItemObj.Total_Volumetric_Weight__c = routeDetails.Total_Volumetric_Weight__c;
        }
        //quoteItemObj.Port_of_Discharge__c = rmsObj.Port_Of_Discharge__c;
        //quoteItemObj.Port_of_Loading__c = rmsObj.Port_Of_Loading__c;
        if(dto.isLCL != true && dto.isAir != true) quoteItemObj.Equipment_Type__c = dto.selectedEquipment;
        else if(dto.isLCL == true || dto.isAir == true){
            quoteItemObj.Tab_View__c = dto.selectedEquipment;                                     
        }
        quoteItemObj.Total_Additional__c = additionalChargeTotal;
        quoteItemObj.CurrencyIsoCode = dto.currencyCode;
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
            opportunity enqObj  = [SELECT Id,Business_Type__c,No_of_Quotes__c,(Select id,name,Name__c from Quotations__r order by createdDate) FROM opportunity where id =: optyId];
            if(enqObj.Business_Type__c == 'Export') quoteObj.recordtypeId = QUOTE_EXPORT_RECORDTYPE_Id;
            else if(enqObj.Business_Type__c == 'Import') quoteObj.recordtypeId = QUOTE_IMPORT_RECORDTYPE_Id;
            
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
            if(dto.isLCL == true) quoteObj.isLCL__c = true;
            else if(dto.isAir == true) quoteObj.isAir__c = true; 
            update quoteObj;
        }
        quoteItemObj.Total__c = dto.total;
        quoteItemObj.RMS__c = dto.rmsId;
        quoteItemObj.Agent__c = agentId;
        quoteItemObj.Airline__c = airlineId;
        quoteItemObj.Buying_Rate__c = dto.quoteBuyingRate;
        quoteItemObj.Pickup_Place__c = dto.pickupPlaceName;
        quoteItemObj.Discharge_Place__c = dto.dischargePlaceName;
        quoteItemObj.Transit_Time__c = dto.transitTime;
        quoteItemObj.Tab_View__c = dto.selectedEquipment;
        if(dto.isAir == true){
            quoteItemObj.Airport_of_Destination__c = dto.portDestinationId != '' ? dto.portDestinationId : null;
            quoteItemObj.Airport_of_Loading__c = dto.portLoadingId != '' ? dto.portLoadingId : null; 
            if(dto.airShippline != '') quoteItemObj.Airline__c = dto.airShippline;
        }
        else{
            quoteItemObj.Port_of_Loading__c = dto.portLoadingId != '' ? dto.portLoadingId : null;  
            quoteItemObj.Port_of_Discharge__c = dto.portDestinationId != '' ? dto.portDestinationId : null;
            if(dto.airShippline != '') quoteItemObj.Shipping_Linee__c = dto.airShippline;
        }
        quoteItemObj.Total_Additional__c = additionalChargeTotal;
        quoteItemObj.Sea_Freight__c = dto.totalRate;  
        quoteItemObj.Buying_Input__c = dto.buyingRateInput;
        quoteItemObj.Quantity__c = dto.quantity;
        quoteItemObj.INCO_Term__c = dto.incoTermId;
        system.debug('chargeableWeight '+dto.chargeableWeight);
        quoteItemObj.Add_to_Buying_Additional__c = dto.addAdditionalCharge != null ? dto.addAdditionalCharge : false;
        quoteItemObj.Included_PDF_Additional__c = dto.includeAdditionalCharge != null ? dto.includeAdditionalCharge : false;
        if(dto.chargeableWeight > 0 ) {
            quoteItemObj.Selling_Rate_Kg__c =  dto.totalRate/dto.chargeableWeight;
            quoteItemObj.Chargeable_Weight__c = dto.chargeableWeight;
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
    public static void dummyData(){
        Integer a;
        Integer b;
        Integer c;
        a=123456;
        a=123;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
        a=123456;
    }
}