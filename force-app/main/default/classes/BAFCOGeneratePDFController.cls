public without sharing class BAFCOGeneratePDFController {
    public static final Id QUOTE_EXPORT_RECORDTYPE_Id = Schema.SObjectType.quotation__c.getRecordTypeInfosByName()
        .get('Export')
        .getRecordTypeId();
    public static final Id QUOTE_IMPORT_RECORDTYPE_Id = Schema.SObjectType.quotation__c.getRecordTypeInfosByName()
        .get('Import')
        .getRecordTypeId();
    public Boolean showShippLine {get;set;}
    public Boolean showPickupPlace {get;set;}
    public Boolean showPickupDischarge {get;set;}
    public Boolean showCharges {get;set;}
    public Boolean isPhone {get;set;}
    public String recordId {get;set;}
    public Boolean isLCL {get;set;}
    
    public String subject { get; set; }
    public String loadingPortLabel { get; set; }
    public String destinationPortLabel { get; set; }
    public String body { get; set; }
    public String emailid{get; set;}
    
    public BAFCOGeneratePDFDto dto {get;set;}
    public BAFCOGeneratePDFController(ApexPages.StandardController controller){
        Map<String, String> pageParameters = ApexPages.currentPage().getParameters();
        String showShippLine = pageParameters.get('showShippLine');
        String showCharges = pageParameters.get('showCharges');
        String recordId = pageParameters.get('recordId');
        String device = pageParameters.get('device');
        Quotation__c QuoteObj = [Select id,name,Account__r.name from Quotation__c where id=: recordId];
        String quoteName = QuoteObj.Account__r.name+' - '+QuoteObj.Name+'.pdf';
        Apexpages.currentPage().getHeaders().put( 'content-disposition', 'inline; filename=' + quoteName );
        if(showShippLine == 'true') this.showShippLine = true; 
        else this.showShippLine = false;
        if(showCharges == 'true') this.showCharges = true; 
        else this.showCharges = false;
        this.recordId = recordId;
        if(device == 'PHONE') this.isPhone = true;
        else this.isPhone = false;
        dto =new BAFCOGeneratePDFDto();
        System.debug('device '+device);
    }
    public void getQuoteData(){
        system.debug(' recordid '+this.recordId);
        Boolean has40HCEquip = false;
        Boolean DC20Added = false;
        if(this.recordId != null ){
            Quotation__c quoteObj = [Select isAir__c,isLCL__c,Recordtype.Name,Terms_and_Conditions__c,RecordtypeId,Effective_From__c,Payment_Terms__c,Inclusions__c,Exclusions__c,Remarks__c,Account__r.Name,Name,(Select Route__r.Service_Type__c,Route__r.INCO_Term__r.name from Quotation_Items__r),createdDate,CreatedBy.Name,Quotation_Validity__c from Quotation__c where id =: this.recordId];
            this.dto.quoteNumber = quoteObj.Name;
            if(quoteObj.Quotation_Validity__c != null )this.dto.validityTo = quoteObj.Quotation_Validity__c.day()+'-'+ BAFCOLeadDetailsController.getMonthName(quoteObj.Quotation_Validity__c.month()) +'-'+quoteObj.Quotation_Validity__c.year();
            this.dto.customerName = quoteObj.Account__r.Name;
            if(quoteObj.isLCL__c == true || quoteObj.isAir__c == true) this.isLCL = true;
            else this.isLCL = false;
            if(quoteObj.isAir__c == true){
                this.loadingPortLabel ='Airport of Loading :';
                this.destinationPortLabel = 'Airport of Destination :';
            }
            else{
                this.loadingPortLabel ='Port of Loading :';
                this.destinationPortLabel = 'Port of Destination :';
            }
            this.dto.quoteIssued = quoteObj.createdDate.day()+'-'+ BAFCOLeadDetailsController.getMonthName(quoteObj.createdDate.month()) +'-'+quoteObj.createdDate.year();
            this.dto.preparedBy = quoteObj.CreatedBy.Name;
            this.dto.paymentTerm = quoteObj.Payment_Terms__c;
            this.dto.recordTypeName = quoteObj.RecordType.Name;
            if(quoteObj.recordtypeId == QUOTE_EXPORT_RECORDTYPE_Id){
                List<String> inclusionList =quoteObj.Inclusions__c != null ? quoteObj.Inclusions__c.split(';;') : null; 
                if(inclusionList != null && inclusionList.size() > 0){
                    this.dto.inclusionHeader = inclusionList[0] != null ? inclusionList[0] : null;
                    if(inclusionList.size() >1){
                        this.dto.inclusionList = inclusionList[1].split(';');
                    }
                }
                List<String> exclusionList =quoteObj.Exclusions__c != null ? quoteObj.Exclusions__c.split(';;') : null; 
                if(exclusionList != null && exclusionList.size() > 0){
                    this.dto.exclusionHeader = exclusionList[0] != null ? exclusionList[0] : null;
                    if(exclusionList.size() >1){
                        this.dto.exclusionList = exclusionList[1].split(';');
                    }
                }
            }
            else if(quoteObj.recordtypeId == QUOTE_IMPORT_RECORDTYPE_Id){
                List<String> termsList =quoteObj.Terms_and_Conditions__c != null ? quoteObj.Terms_and_Conditions__c.split(';;') : null; 
                if(termsList != null && termsList.size() > 0){
                    this.dto.termsNConditionHeader = termsList[0] != null ? termsList[0] : null;
                    if(termsList.size() >1){
                        this.dto.termsNConditionList = termsList[1].split(';');
                    }
                }
            }
            this.dto.remarks = quoteObj.Remarks__c != null ? quoteObj.Remarks__c : null;
            if(quoteObj.Effective_From__c != null)
                this.dto.effectiveFrom = quoteObj.Effective_From__c.day()+'-'+ BAFCOLeadDetailsController.getMonthName(quoteObj.Effective_From__c.month()) +'-'+quoteObj.Effective_From__c.year();
            if(quoteObj.Quotation_Items__r.size() > 0){
                this.dto.serviceType = quoteObj.Quotation_Items__r[0].Route__r.Service_Type__c;
                this.dto.shippingTerm =quoteObj.Quotation_Items__r[0].Route__r.INCO_Term__r.name;
            }
            if(quoteObj.Account__c != null){
                Account acc = [Select id,BillingStreet,BillingCity,BillingState,BillingPostalCode,BillingCountry, Owner.name from Account where id =: quoteObj.Account__c];
                String Address = acc.BillingStreet != null ? String.valueOf(acc.BillingStreet) :'';
                Address += acc.BillingCity != null ? ', '+String.valueOf(acc.BillingCity) :'';
                Address += acc.BillingState != null ? ', '+String.valueOf(acc.BillingState) :'';
                Address += acc.BillingPostalCode != null ? ', '+String.valueOf(acc.BillingPostalCode) :'';
                Address += acc.BillingCountry != null ? ', '+String.valueOf(acc.BillingCountry) :'';
                this.dto.address = Address != '' ? Address : '-';
                this.dto.salesResponsible = acc.Owner.name;
                List<Contact> contlist = [Select name,email,Phone,fax,Account.BillingStreet, Account.BillingCity, Account.BillingState, Account.BillingPostalCode,
                                          Account.BillingCountry from contact where AccountId = : quoteObj.Account__c order by createddate desc];
                if(contlist.size() >0){
                    Contact cont = contlist[0];
                    this.dto.contactPerson = cont.Name;                    
                    this.dto.phone = cont.Phone;
                    this.dto.email =cont.Email;
                }
                else{
                    this.dto.contactPerson = '-';
                    this.dto.phone = '-';
                    this.dto.email ='-';
                }
            }
            else{
                this.dto.contactPerson = '-';
                this.dto.address =  '-';
                this.dto.phone = '-';
                this.dto.email ='-';
            }
            List<Quotation_Item__c> quoteItem = [Select Add_to_Buying_Additional__c,Total_Volumetric_Weight__c,Airline__r.name,Total_Gross_Weight__c,Total_CBM__c,Quotation__r.Name,Agent__r.Name,Selling_Rate_Kg__c,CurrencyIsoCode,(Select Charge_NAme__r.Name,Charge_value__c,Buying_Rate__c,Charge_Name_text__c from Quotation_Charges__r where isAdditional_Charge__c = true),Shipping_Linee__r.name,Quantity__c,Commodity__c,Airport_of_Loading__r.name,Airport_of_Destination__r.name,Quotation__r.isAir__c,Quotation__r.isLCL__c,Tab_View__c,Tank_Rental_Charges__c,Freight_Difference_FD__c,Carrier_container_repositioning_charges__c,Alternate_depot_release_charges__c,Included_PDF_ShippingLine__c,Included_PDF_Origin__c,Included_PDF_Ex_works__c,Included_PDF_Destination__c,Included_PDF_Additional__c,Route__r.Service_Type__c,Ex_Works_Charge__c,Ex_Works_Charge_Name__r.name,Place_of_Discharge__r.Name,Place_of_Pickup__r.Name,Port_of_Discharge__r.name,Port_of_Loading__r.name,BAF__c,Bayan__c,Bayan_cancellation_charge__c,Bunker_surcharge__c,Cleaning_charges__c,
                                                 CMC__c,Container_movement_charges__c,Container_stripping__c,
                                                 Destination_Customs_Clearance__c,Destination_Loading_Charges__c,DTHC__c,EIC__c,Equipment_Type__c,
                                                 Fasah_fee__c,Free_time_certificate_charges__c,Fumigation__c,Inspection__c,Insurance_charges__c,
                                                 ISPS__c,Lift_on_Lift_off__c,Loading_Charges__c,Ministry_clearnce_charge_for_OOG_cargo__c,
                                                 Miscellaneous__c,MOT_fine_charges__c,Non_Palletized_Surcharge__c,Origin_Customs_clearance__c,
                                                 Origin_Loading_Charges__c,OTHC__c,Pest_control__c,Port_of_Discharge__c,Port_of_Loading__c,
                                                 Port_Shuttling__c,Re_palletization__c,Reefer_cntr_plug_in_charges__c,Reefer_PTI_charges__c,
                                                 Reefer_steam_wash__c,RMS__c,Route__c,Sea_Freight__c,Seal_Charges__c,Stuffing_Charges__c,
                                                 SweepingCleaning__c,Tabadul__c,Tarpauline_charge__c,Total_INCO__c,Total_SL__c,Truck_Head_charges__c,
                                                 Truck_idling_charges__c,Vessel_certificate_charges__c,Wrappingpacking_charges__c,Xray__c,Quotation__r.RecordtypeId,
                                                 Quotation__r.Leadc__c,Quotation__r.Opportunity__c,Quotation__r.Account__c,Total__c,Agent_Name__c,
                                                 Remarks_SL_Charges__c,Remarks_Origin_Charges__c,Remarks_Destination_Charges__c,Remarks_Additional_Charges__c,Total_Additional__c,War_Risk_Surcharge__c,VGM__c,Total_Dest__c,Pickup_Charges__c,Overweight_surcharge__c,Origin_Detention_Demurrage_Charges__c,Lashing_Charges__c,Operational_Recovery_Surcharge__c,Low_Sulphur_Surcharge__c,Inland_haulage__c,Inland_Handling_Fees__c,Inland_Fuel_Surcharge__c,Gate_pass_charges__c,Fuel_Surcharge__c,Fasah_Charges__c,Export_Service_Fees__c,DG_Surcharge__c,Carriage_Congestion_Surcharge__c,BL_Fees__c,Bayan_Charges__c,
                                                 Container_Lashing_Charges__c,DO_charges__c,LOLO_Charges__c,Carrier_Security_Fees__c,
                                                 Shipping_Line__c,Equipment_Type__r.Name,/*Place_of_Pickup__c,Place_of_Discharge__c*/Pickup_Place__c,Discharge_Place__c    
                                                 from Quotation_Item__c 
                                                 where Quotation__c =: this.recordId];
            if(quoteItem.size() > 0){
                List<Id> routeId = new List<Id>();
                Map<Id,List<Route_Equipment__c>> rIdtoEquipMap = new Map<Id,List<Route_Equipment__c>>();
                for(Quotation_Item__c item : quoteItem){
                    routeId.add(item.Route__c);
                }
                system.debug('routeId '+routeId);
                for(Route_Equipment__c rEquip : [SELECT Volumetric_weight_Kgs__c,Route__r.Total_Volumetric_Weight__c,Weight_Kgs__c,CBM__c ,Route__r.Total_CBM__c,Route__r.Total_Gross_Weight_KGs__c,Id, Length__c, Width__c, Height__c, Units__c, UOM__c, Name FROM Route_Equipment__c where Route__c in : routeId]){
                    if(!rIdtoEquipMap.containsKey(rEquip.Route__c)){
                        rIdtoEquipMap.put(rEquip.Route__c,new list<Route_Equipment__c>());
                    }
                    rIdtoEquipMap.get(rEquip.Route__c).add(rEquip);
                }
                system.debug('rIdtoEquipMap '+rIdtoEquipMap);
                List<BAFCOGeneratePDFDto.serviceChargeList> quoteItemDto = new List<BAFCOGeneratePDFDto.serviceChargeList>();
                List<BAFCOGeneratePDFDto.ContainerExportList> containerExportDtoList = new List<BAFCOGeneratePDFDto.ContainerExportList>();
                List<Route_Equipment__c> routeEquipList= new List<Route_Equipment__c>();
                for(Quotation_Item__c item : quoteItem){
                    
                    BAFCOGeneratePDFDto.ContainerExportList conExportDto = new BAFCOGeneratePDFDto.ContainerExportList();
                    conExportDto.quoteNo = item.Quotation__r.Name;
                    conExportDto.qty = item.Quantity__c;
                    conExportDto.equipmentType = item.Quotation__r.isAir__c == true ? 'CBM:'+item.Total_CBM__c+' Gross:'+item.Total_Gross_Weight__c :item.Equipment_Type__r.name;
                    conExportDto.unitPrice = item.CurrencyIsoCode +' '+ item.Total__c;
                    conExportDto.freight =item.CurrencyIsoCode +' '+( (item.Quantity__c > 0 ? item.Quantity__c : 0) * (item.Total__c  > 0 ? item.Total__c : 0));
                    conExportDto.commodity = item.Commodity__c;
                    conExportDto.airline = item.Airline__c != null ? item.Airline__r.name : '-';
                    containerExportDtoList.add(conExportDto);
                    
                    BAFCOGeneratePDFDto.serviceChargeList itemDto = new BAFCOGeneratePDFDto.serviceChargeList();
                    itemDto.shippingLine = item.Shipping_Linee__r.name;
                    system.debug('item.Pickup_Place__c '+item.Pickup_Place__c);
                    if(item.Pickup_Place__c != null ) this.showPickupPlace = true;
                    if(item.Discharge_Place__c != null ) this.showPickupDischarge = true;
                    itemDto.placeOfPickup = item.Pickup_Place__c;
                    itemDto.placeOfDischarge = item.Discharge_Place__c; 
                    itemDto.currencyCode = item.CurrencyIsoCode;
                    if(rIdtoEquipMap.size() > 0 )routeEquipList.addAll(rIdtoEquipMap.get(item.Route__c));
                    if(item.Quotation__r.isAir__c == true){
                        itemDto.portOfLoading = item.Airport_of_Loading__r.name;
                        itemDto.portOfDestination = item.Airport_of_Destination__r.name;
                        itemDto.equipmentType = item.Tab_View__c;
                        itemDto.totalCBM = item.Total_CBM__c;
                        itemDto.totalGrossWeight = item.Total_Gross_Weight__c;
                        itemDto.totalVolumetricWeight = item.Total_Volumetric_Weight__c;
                    }
                    else{
                        
                        itemDto.portOfLoading = item.Port_of_Loading__r.name;
                        itemDto.portOfDestination = item.Port_of_Discharge__r.name;
                        itemDto.equipmentType = item.Equipment_Type__r.name;
                    }
                    itemDto.shippingLine = item.Shipping_Linee__r.name;
                    itemDto.total = item.CurrencyIsoCode+' '+ item.Total__c;
                    itemDto.rateKg = item.Selling_Rate_Kg__c > 0 ? item.Selling_Rate_Kg__c.setScale(2) : 0;
                    itemDto.commodity = item.Commodity__c;
                    itemDto.agentShare = item.Agent__c != null ? item.Agent__r.Name : '-';                
                    //Additional Charges
                    List<BAFCOGenerteQuoteDto.AdditionalCharge> addtionalChargeList = new List<BAFCOGenerteQuoteDto.AdditionalCharge>();
                    if(item.Quotation_Charges__r != null && item.Quotation_Charges__r.size() > 0){
                        for(Quotation_Charges__c chargeObj : item.Quotation_Charges__r){
                            BAFCOGenerteQuoteDto.AdditionalCharge dtoObj = new BAFCOGenerteQuoteDto.AdditionalCharge();
                            dtoObj.name = chargeObj.Charge_Name_text__c;
                            if(item.Add_to_Buying_Additional__c == true ) dtoObj.value = chargeObj.Buying_Rate__c;
                            else dtoObj.value = chargeObj.Charge_Value__c;
                            dtoObj.includeAdditionalCharge = item.Included_PDF_Additional__c;
                            addtionalChargeList.add(dtoObj);
                        }
                    }
                    itemDto.addtionalChargeList = addtionalChargeList;
                    
                    //ExWorks Charges
                    BAFCOImportRMSDto.exWorksObj xWorksObj = new BAFCOImportRMSDto.exWorksObj();
                    xWorksObj.LoadCharge = item.Ex_Works_Charge__c  > 0 ?  item.Ex_Works_Charge__c : null ;
                    xWorksObj.Id = item.Ex_Works_Charge_Name__c != null ? item.Ex_Works_Charge_Name__r.name : null;
                    xWorksObj.includeExWorksCharge = item.Included_PDF_Ex_works__c ;
                    itemDto.exWorksObj = xWorksObj;
                    quoteItemDto.add(itemDto);
                }
                this.dto.serviceChargeList = quoteItemDto; 
                system.debug('routeEquipList '+routeEquipList);
                this.dto.routeEquipList = routeEquipList;
                this.dto.ContainerExportList = containerExportDtoList;
            }
        }
    }
}