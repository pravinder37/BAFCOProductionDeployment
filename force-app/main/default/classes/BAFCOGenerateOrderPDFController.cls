public class BAFCOGenerateOrderPDFController {
    public static final Id EXPORT_RECORDTYPE_Id = Schema.SObjectType.Order__c.getRecordTypeInfosByName()
        .get('Export')
        .getRecordTypeId();
    public static final Id IMPORT_RECORDTYPE_Id = Schema.SObjectType.Order__c.getRecordTypeInfosByName()
        .get('Import')
        .getRecordTypeId();
    public Boolean showShippLine {get;set;}
    public Boolean showPickupPlace {get;set;}
    public Boolean showPickupDischarge {get;set;} 
    public Boolean showCharges {get;set;}
    public String recordId {get;set;}
    public Boolean isLCL {get;set;}
    public String loadingPortLabel { get; set; }
    public String destinationPortLabel { get; set; }
    public Boolean isImport {get;set;}
    public Boolean isExport {get;set;}
    public String title{get;set;}
    public boolean displayShipperlist {get;set;}
    public BAFCOGeneratePDFDto dto {get;set;}
    public String header { get; set; }
    public BAFCOGenerateOrderPDFController(ApexPages.StandardController controller){
        Map<String, String> pageParameters = ApexPages.currentPage().getParameters();
        String showShippLine = pageParameters.get('showShippLine');
        String showCharges = pageParameters.get('showCharges');
        String recordId = pageParameters.get('recordId');
        Order__c orderObj = [Select id,name,Account_Order__r.name from Order__c where id=: recordId];
        system.debug('orderObj '+orderObj);
        String orderName = orderObj.Account_Order__r.name+' - '+orderObj.Name+'.pdf';
        Apexpages.currentPage().getHeaders().put( 'content-disposition', 'inline; filename=' + orderName );
        if(showShippLine == 'true') this.showShippLine = true; 
        else this.showShippLine = false;
        if(showCharges == 'true') this.showCharges = true; 
        else this.showCharges = false;
        this.recordId = recordId;
        this.isImport = false;
        this.displayShipperlist = false;
        dto =new BAFCOGeneratePDFDto();
    }
    public void getQuoteData(){
        system.debug(' recordid '+this.recordId);
        Boolean has40HCEquip = false;
        Boolean DC20Added = false;
        if(this.recordId != null ){
            Order__c orderObj = [Select Remarks__c,Quotation__r.NAme,isAir__c,isLCL__c,id,Recordtype.Name,Quotation__r.Terms_and_Conditions__c,RecordtypeId,
                                 Quotation__r.Effective_From__c,Quotation__r.Payment_Terms__c,Quotation__r.Inclusions__c,
                                 Quotation__r.Exclusions__c,Quotation__r.Remarks__c,Account_Order__r.Name,Name,
                                 (Select Agent__r.name,Route_Order__r.Service_Type__c,Route_Order__r.INCO_Term__r.name from Order_Items__r),createdDate,CreatedBy.Name,Quotation__r.Quotation_Validity__c from Order__c where id =: this.recordId];
            this.dto.quoteNumber = orderObj.Name;
            if(orderObj.Quotation__r.Quotation_Validity__c != null )this.dto.validityTo = orderObj.Quotation__r.Quotation_Validity__c.day()+'-'+ BAFCOLeadDetailsController.getMonthName(orderObj.Quotation__r.Quotation_Validity__c.month()) +'-'+orderObj.Quotation__r.Quotation_Validity__c.year();
            this.dto.customerName = orderObj.Account_Order__r.Name;
            if(orderObj.isLCL__c == true || orderObj.isAir__c == true) this.isLCL = true;
            else this.isLCL = false;
            if(orderObj.isAir__c == true){
                this.loadingPortLabel ='Airport of Loading :';
                this.destinationPortLabel = 'Airport of Destination :';
            }
            else{
                this.loadingPortLabel ='Port of Loading :';
                this.destinationPortLabel = 'Port of Destination :';
            }
            this.dto.quoteIssued =orderObj.Quotation__r.NAme+' | '+ orderObj.createdDate.day()+'-'+ BAFCOLeadDetailsController.getMonthName(orderObj.createdDate.month()) +'-'+orderObj.createdDate.year();
            this.dto.preparedBy = orderObj.CreatedBy.Name;
            this.dto.paymentTerm = orderObj.Quotation__r.Payment_Terms__c;
            this.dto.recordTypeName = orderObj.RecordType.Name;
            if(orderObj.recordtypeId == EXPORT_RECORDTYPE_Id){
                this.title = 'Create Order';
                this.isImport = false;
                this.isExport = true;
                List<String> inclusionList =orderObj.Quotation__r.Inclusions__c != null ? orderObj.Quotation__r.Inclusions__c.split(';;') : null; 
                if(inclusionList != null && inclusionList.size() > 0){
                    this.dto.inclusionHeader = inclusionList[0] != null ? inclusionList[0] : null;
                    if(inclusionList.size() >1){
                        this.dto.inclusionList = inclusionList[1].split(';');
                    }
                }
                List<String> exclusionList =orderObj.Quotation__r.Exclusions__c != null ? orderObj.Quotation__r.Exclusions__c.split(';;') : null; 
                if(exclusionList != null && exclusionList.size() > 0){
                    this.dto.exclusionHeader = exclusionList[0] != null ? exclusionList[0] : null;
                    if(exclusionList.size() >1){
                        this.dto.exclusionList = exclusionList[1].split(';');
                    }
                }
            }
            else if(orderObj.recordtypeId == IMPORT_RECORDTYPE_Id){
                this.title = 'Agent Copy';
                this.isImport = true;
                this.isExport = false;
                List<String> termsList =orderObj.Quotation__r.Terms_and_Conditions__c != null ? orderObj.Quotation__r.Terms_and_Conditions__c.split(';;') : null; 
                if(termsList != null && termsList.size() > 0){
                    this.dto.termsNConditionHeader = termsList[0] != null ? termsList[0] : null;
                    if(termsList.size() >1){
                        this.dto.termsNConditionList = termsList[1].split(';');
                    }
                }
            }
            this.dto.remarks = orderObj.Remarks__c != null ? orderObj.Remarks__c : null;
            if(orderObj.Quotation__r.Effective_From__c != null)
                this.dto.effectiveFrom = orderObj.Quotation__r.Effective_From__c.day()+'-'+ BAFCOLeadDetailsController.getMonthName(orderObj.Quotation__r.Effective_From__c.month()) +'-'+orderObj.Quotation__r.Effective_From__c.year();
            if(orderObj.Order_Items__r.size() > 0){
                this.dto.serviceType = orderObj.Order_Items__r[0].Route_Order__r.Service_Type__c;
                this.dto.shippingTerm =orderObj.Order_Items__r[0].Route_Order__r.INCO_Term__r.name;
                if(orderObj.Order_Items__r[0].Agent__c != null)
                this.header = 'AGENT COPY - '+orderObj.Order_Items__r[0].Agent__r.name;
                else this.header = 'AGENT COPY';
            }
            if(orderObj.Account_Order__c != null){
                Account acc = [Select id,BillingStreet,BillingCity,BillingState,BillingPostalCode,BillingCountry, Owner.name from Account where id =: orderObj.Account_Order__c];
                String Address = acc.BillingStreet != null ? String.valueOf(acc.BillingStreet) :'';
                Address += acc.BillingCity != null ? ', '+String.valueOf(acc.BillingCity) :'';
                Address += acc.BillingState != null ? ', '+String.valueOf(acc.BillingState) :'';
                Address += acc.BillingPostalCode != null ? ', '+String.valueOf(acc.BillingPostalCode) :'';
                Address += acc.BillingCountry != null ? ', '+String.valueOf(acc.BillingCountry) :'';
                this.dto.address = Address != '' ? Address : '-';
                this.dto.salesResponsible = acc.Owner.name;
                List<Contact> contlist = [Select name,email,Phone,fax,Account.BillingStreet, Account.BillingCity, Account.BillingState, Account.BillingPostalCode,
                                          Account.BillingCountry from contact where AccountId = : orderObj.Account_Order__c order by createddate desc];
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
            system.debug('dto '+this.dto);
            List<Order_Item__c> quoteItem = [SELECT Airline__r.name,Selling_Rate_Kg__c,POD_freetime__c,RMS_Order__r.Free_time_POD__c,Agent_Profit_Share__c,Order__r.Order_Type__c,Order__r.recordtypeId,CurrencyIsoCode, (Select Charge_Name_Text__c,Charge_value__c,Buying_Rate__c from Order_Charges__r where isAdditionalCharge__c = true and isExWorks__c = false), Quotation_Item__r.Quotation__r.Name,Commodity__c,Route__r.Commodity__r.name,Airport_of_Destination__r.name,Airport_of_Loading__r.Name,Order__r.isAir__c,Tab_View__c,Order__r.isLCL__c,Tank_Rental_Charges__c,Shipping_Line__r.name,Ex_Works_Charge_Name__r.name,Route_Order__r.Service_Type__c,Id,Route_Order__r.Name, Name, Order__c, Agent__c, BAF_Order__c, BL_Fees__c, Bayan_Charges__c,
                                             Bayan_Order__c, Bayan_cancellation_charge_Order__c, Bunker_surcharge_Order__c,
                                             CMC_Order__c, Carriage_Congestion_Surcharge__c, Carrier_Security_Fees__c,
                                             Cleaning_charges_Order__c, Container_Lashing_Charges_Order__c, Container_movement_charges_Order__c,
                                             Container_stripping_Order__c, DG_Surcharge__c, DO_charges__c, DTHC_Order__c, Destination_Customs_Clearance_Order__c,
                                             Destination_Loading_Charges_Order__c, EIC_Order__c, Equipment_Type_Order__c, Export_Service_Fees__c, Fasah_Charges__c,
                                             Fasah_fee_Order__c, Free_time_certificate_charges_Order__c, Fuel_Surcharge__c, Fumigation_Order__c, Gate_pass_charges__c,
                                             ISPS_Order__c, Inland_Fuel_Surcharge__c, Inland_Handling_Fees__c, Inland_haulage__c, Insurance_charges_Order__c,
                                             Inspection_Order__c, LOLO_Charges__c, Lashing_Charges__c, Lift_on_Lift_off_Order__c, Loading_Charges_Order__c,
                                             Low_Sulphur_Surcharge__c, MCCFOOGC_Order__c, MOT_fine_charges_Order__c, Miscellaneous_Order__c,
                                             Non_Palletized_Surcharge_Order__c, OTHC_Order__c, Operational_Recovery_Surcharge__c, Origin_Customs_clearance_Order__c,
                                             Origin_Detention_Demurrage_Charges__c, Origin_Loading_Charges_Order__c, Overweight_Overheight_surcharge__c,
                                             Pest_control_Order__c, Pickup_Charges__c, Port_Shuttling_Order__c, Port_of_Discharge_Order__c, Port_of_Loading_Order__c,
                                             Quantity__c, RMS_Order__c, Re_palletization_Order__c, Reefer_PTI_charges_Order__c, Reefer_cntr_plug_in_charges_Order__c,
                                             Reefer_steam_wash_Order__c, Remarks_Destination_Charges__c, Remarks_Additional_Charges__c, Remarks_Origin_Charges__c,
                                             Remarks_SL_Charges__c, Route_Order__c, Sea_Freight_Order__c, Seal_Charges_Order__c, Stuffing_Charges_Order__c,
                                             Sweeping_Cleaning_Order__c, Tabadul_Order__c, Tarpauline_charge_Order__c, Total_Additional__c, Total_Destination_c__c,
                                             Total_INCO_Order__c, Total_Order__c, Total_SL_Order__c, Truck_Head_charges_Order__c, Truck_idling_charges_Order__c,
                                             VGM__c, Vessel_certificate_charges_Order__c, War_Risk_Surcharge__c, Wrapping_packing_charges_Order__c, Xray_Order__c,
                                             Shipping_Line_Order__c, Teus__c, Place_of_Pickup__c, Place_of_Discharge__c, Ex_Works_Charge__c, Ex_Works_Charge_Name__c, 
                                             Add_to_Buying_Additional__c, Add_to_Buying_Destination__c, Add_to_Buying_Ex_works__c, Add_to_Buying_ShippingLine__c,
                                             Add_to_Buying_Origin__c, Included_PDF_Additional__c, Included_PDF_Destination__c, Included_PDF_Ex_works__c, 
                                             Included_PDF_Origin__c, Freight_Difference_FD__c, Included_PDF_ShippingLine__c, Carrier_container_repositioning_charges__c,
                                             Vessel_ETD__c, Alternate_depot_release_charges__c, Buying_Rate__c, Shipping_Line__c, Quotation_Item__c,
                                             Pickup_Place__c,Port_of_Loading_Order__r.name,Port_of_Discharge_Order__r.name, Discharge_Place__c,Equipment_Type_Order__r.Name,
                                             Total_Volumetric_Weight__c,Total_Gross_Weight__c,Total_CBM__c
                                             FROM Order_Item__c 
                                             where Order__c =: this.recordId];
            system.debug('quoteItem' +quoteItem);
            if(quoteItem.size() > 0){
                List<Id> routeId = new List<Id>();
                Map<Id,List<Route_Equipment__c>> rIdtoEquipMap = new Map<Id,List<Route_Equipment__c>>();
                for(Order_Item__c item : quoteItem){
                    routeId.add(item.Route__c);
                }
                if(routeId.size() > 0){
                    for(Route_Equipment__c rEquip : [SELECT Volumetric_weight_Kgs__c,Route__r.Total_Volumetric_Weight__c,Weight_Kgs__c,CBM__c ,Route__r.Total_CBM__c,Route__r.Total_Gross_Weight_KGs__c,Id, Length__c, Width__c, Height__c, Units__c, UOM__c, Name FROM Route_Equipment__c where Route__c in : routeId]){
                        if(!rIdtoEquipMap.containsKey(rEquip.Route__c)){
                            rIdtoEquipMap.put(rEquip.Route__c,new list<Route_Equipment__c>());
                        }
                        rIdtoEquipMap.get(rEquip.Route__c).add(rEquip);
                    }
                }
                system.debug('rIdtoEquipMap '+rIdtoEquipMap);
                List<BAFCOGeneratePDFDto.serviceChargeList> quoteItemDto = new List<BAFCOGeneratePDFDto.serviceChargeList>();
                List<BAFCOGeneratePDFDto.ContainerList> containerDtoList = new List<BAFCOGeneratePDFDto.ContainerList>();
                List<BAFCOGeneratePDFDto.ContainerExportList> containerExportDtoList = new List<BAFCOGeneratePDFDto.ContainerExportList>();
                List<Route_Equipment__c> routeEquipList= new List<Route_Equipment__c>();
                for(Order_Item__c item : quoteItem){                    
                    BAFCOGeneratePDFDto.ContainerList contDto = new BAFCOGeneratePDFDto.ContainerList();
                    contDto.quoteNo = item.Quotation_Item__r.Quotation__r.Name;
                    contDto.qty = item.Quantity__c;
                    contDto.equipmentType = item.Equipment_Type_Order__r.name;
                    contDto.BuyingRate = item.CurrencyIsoCode+' '+String.valueOF(item.Buying_Rate__c);
                    contDto.perShipment = item.CurrencyIsoCode+' '+String.valueOF(item.Buying_Rate__c);
                    contDto.podFreeTime = item.POD_freetime__c;
                    contDto.exWorks = item.CurrencyIsoCode +' 0';
                    contDto.total = item.CurrencyIsoCode+' '+(item.Quantity__c > 0 ? item.Quantity__c : 0) * (item.Buying_Rate__c  > 0 ? item.Buying_Rate__c : 0);
                    system.debug('contDto '+contDto);
                    containerDtoList.add(contDto);
                    
                    BAFCOGeneratePDFDto.ContainerExportList conExportDto = new BAFCOGeneratePDFDto.ContainerExportList();
                    conExportDto.quoteNo = item.Quotation_Item__r.Quotation__r.Name;
                    conExportDto.qty = item.Quantity__c;
                    conExportDto.equipmentType = item.Order__r.isAir__c == true ? 'CBM:'+item.Total_CBM__c+' Gross:'+item.Total_Gross_Weight__c :item.Equipment_Type_Order__r.name;
                    conExportDto.unitPrice = item.CurrencyIsoCode +' '+ item.Total_Order__c;
                    conExportDto.freight =item.CurrencyIsoCode +' '+( (item.Quantity__c > 0 ? item.Quantity__c : 0) * (item.Total_Order__c  > 0 ? item.Total_Order__c : 0));
                    conExportDto.commodity = item.Commodity__c;
                    conExportDto.airline = item.Airline__c != null ? item.Airline__r.name : '-';
                    containerExportDtoList.add(conExportDto);
                    if(rIdtoEquipMap.size() > 0 && rIdtoEquipMap.containsKey(item.Route__c))routeEquipList.addAll(rIdtoEquipMap.get(item.Route__c));
                    BAFCOGeneratePDFDto.serviceChargeList itemDto = new BAFCOGeneratePDFDto.serviceChargeList();                       
                    itemDto.shippingLine = item.Shipping_Line__r.name != null ? item.Shipping_Line__r.name  : '-';
                    system.debug('item.Pickup_Place__c '+item.Pickup_Place__c);
                    if(item.Pickup_Place__c != null ) this.showPickupPlace = true;
                    if(item.Discharge_Place__c != null ) this.showPickupDischarge = true;
                    itemDto.placeOfPickup = item.Pickup_Place__c;
                    itemDto.placeOfDischarge = item.Discharge_Place__c;
                    itemDto.airLine = item.Airline__c != null ? item.Airline__r.name : '-';
                    itemDto.currencyCode = item.CurrencyIsoCode;
                    itemDto.isImport = item.Order__r.recordtypeId == EXPORT_RECORDTYPE_Id ? false : true;
                    if(item.Order__r.isAir__c == true){
                        itemDto.portOfLoading = item.Airport_of_Loading__r.name;
                        itemDto.portOfDestination = item.Airport_of_Destination__r.name;
                        itemDto.equipmentType = item.Tab_View__c;
                        itemDto.totalCBM = item.Total_CBM__c;
                        itemDto.totalGrossWeight = item.Total_Gross_Weight__c;
                        itemDto.totalVolumetricWeight = item.Total_Volumetric_Weight__c;
                        itemDto.shippingLine = '-';
                    }
                    else{
                        
                        itemDto.portOfLoading = item.Port_of_Loading_Order__r.name;
                        itemDto.portOfDestination = item.Port_of_Discharge_Order__r.name;
                        itemDto.equipmentType = item.Equipment_Type_Order__r.name;
                        itemDto.shippingLine = item.Shipping_Line__r.name;
                    }
                    
                    itemDto.total = item.currencyIsoCode+' '+ item.Total_Order__c;
                    itemDto.rateKg =item.Selling_Rate_Kg__c > 0 ? item.Selling_Rate_Kg__c.setScale(2) : 0;
                    itemDto.agentShare = item.currencyIsoCode+' '+ (item.Agent_Profit_Share__c != null ? item.Agent_Profit_Share__c : 0);
                    
                    //Additional Charges
                    List<BAFCOGenerteQuoteDto.AdditionalCharge> addtionalChargeList = new List<BAFCOGenerteQuoteDto.AdditionalCharge>();
                    if(item.Order_Charges__r != null && item.Order_Charges__r.size() > 0){
                        for(Order_Charges__c chargeObj : item.Order_Charges__r){
                            BAFCOGenerteQuoteDto.AdditionalCharge dtoObj = new BAFCOGenerteQuoteDto.AdditionalCharge();
                            dtoObj.name = chargeObj.Charge_Name_Text__c;
                            if(item.Add_to_Buying_Additional__c == true) dtoObj.value = chargeObj.Buying_Rate__c;
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
                this.dto.ContainerList = containerDtoList;
                this.dto.ContainerExportList = containerExportDtoList;
                this.dto.routeEquipList = routeEquipList;
                system.debug('dto 2 '+this.dto);
                //ConsigneeList
                List<BAFCOGeneratePDFDto.consigneeList> consigneeList = new List<BAFCOGeneratePDFDto.consigneeList>();
                List<Id> ConsigneeAcctIds = new List<Id>();
                List<Consignee__c> consigneeRecords = new List<Consignee__c>();
                Map<Id,Contact> acctidToContactMap = new Map<Id,Contact>();
                for(Consignee__c consigneeObj : [Select id, Consignee__r.name from Consignee__c where Order_Item__c =: quoteItem[0].id]){
                    ConsigneeAcctIds.add(consigneeObj.Consignee__c);
                    consigneeRecords.add(consigneeObj);
                }
                for(Contact con : [Select Name,Email,phone,MobilePhone,Account.name from contact where AccountId in : ConsigneeAcctIds order by createddate desc limit 1]){
                    acctidToContactMap.put(con.Accountid,con);
                }
                system.debug('acctidToContactMap '+acctidToContactMap);
                for(Consignee__c consigneeObj : consigneeRecords ){
                    BAFCOGeneratePDFDto.consigneeList consDto = new BAFCOGeneratePDFDto.consigneeList();
                    consDto.consignee = consigneeObj.Consignee__r.Name;
                    if(acctidToContactMap.containsKey((consigneeObj.Consignee__c))){
                        Contact cont = acctidToContactMap.get(consigneeObj.Consignee__c);
                        consDto.contact = cont.Name;
                        consDto.phone = cont.phone;
                        consDto.mobile  = cont.MobilePhone;
                        consDto.email = cont.Email;
                    }
                    consigneeList.add(consDto);
                }
                if(consigneeList.size() > 0) this.dto.consigneeList = consigneeList;
                
                //Shipper List 
                
                List<BAFCOGeneratePDFDto.shipperList> shipperList = new List<BAFCOGeneratePDFDto.shipperList>();
                List<Id> shipperListAcctIds = new List<Id>();
                List<Shipper__c> shipperRecords = new List<Shipper__c>();
                Map<Id,Contact> acctidToShippContactMap = new Map<Id,Contact>();
                for(Shipper__c ShipperObj : [Select id, Shipper__r.name from Shipper__c where Order_Item__c =: quoteItem[0].id]){
                    shipperListAcctIds.add(ShipperObj.Shipper__c);
                    shipperRecords.add(ShipperObj);
                }
                for(Contact con : [Select Name,Email,phone,MobilePhone,Account.name from contact where AccountId in : shipperListAcctIds order by createddate desc limit 1]){
                    acctidToShippContactMap.put(con.Accountid,con);
                }
                for(Shipper__c ShipperObj : shipperRecords ){
                    BAFCOGeneratePDFDto.shipperList consDto = new BAFCOGeneratePDFDto.shipperList();
                    consDto.shipper = ShipperObj.Shipper__r.Name;
                    if(acctidToShippContactMap.containsKey((ShipperObj.Shipper__c))){
                        Contact cont = acctidToShippContactMap.get(ShipperObj.Shipper__c);
                        consDto.contact = cont.Name;
                        consDto.phone = cont.phone;
                        consDto.mobile  = cont.MobilePhone;
                        consDto.email = cont.Email;
                    }
                    shipperList.add(consDto);
                }
                if(shipperList.size() > 0) {
                    this.dto.shipperList = shipperList;
                    this.displayShipperlist = true;
                }
                system.debug('this.dto. '+this.dto);
            }
        }
    }
}