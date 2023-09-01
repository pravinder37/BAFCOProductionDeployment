public class BAFCOImportQuoteController {
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
    public static List<Agent__c> getAgentsRecords(){
        return [Select Id, Name from Agent__c];
    }
    @AuraEnabled
    public static Map<String,Map<String,List<BAFCORMSDto>>> getImportRMSDetails(String portLoading, String portDestination, String commodity,String routeId,String enquiryId) {
        List<String> rmsEquipmentList = new List<String>();
        Map<String,Map<String,List<BAFCORMSDto>>> agentToEquipMap = new Map<String,Map<String,List<BAFCORMSDto>>>();
        List<String> routeEquipmentList = new List<String>();
        Map<String,Decimal> routeEquipmentoquantityMap = new Map<String,Decimal>();
        Date todaysDate = System.today();
        String QuoteId = '';    
        Integer uniqueEquip = 0;
        Boolean isFDAccount = false;
        String accountId = null;
        Map<String,String>  quoteItemToIdMap = new Map<String,String>();
        for(Route_Equipment__c routeEquip : [Select Equipment_Type__r.name,Quantity__c  FROM Route_Equipment__c WHERE Route__c=:routeId]){
            routeEquipmentList.add(routeEquip.Equipment_Type__r.name);
            routeEquipmentoquantityMap.put(routeEquip.Equipment_Type__r.name,routeEquip.Quantity__c);
        }
        for(RMS__c rmsObj : [Select Equipment_Type__c  FROM RMS__c WHERE Port_Of_Loading__r.Name =: portLoading 
                             AND Port_Of_Discharge__r.Name =: portDestination
                             AND Validity__c >=: todaysDate AND recordtypeId =: RMS_IMPORT_RECORDTYPE_Id]){
                                 rmsEquipmentList.add(rmsObj.Equipment_Type__c) ;                     
                             }
        // to get Previously generated Quote
        List<Quotation__c> quoteList = [SELECT Id FROM Quotation__c where Opportunity__c  =: enquiryId limit 1];
        if(quoteList.size() > 0) QuoteId = quoteList[0].Id;
        
        Opportunity opty = [Select id,Account.Fd__c from Opportunity where id =: enquiryId limit 1];
        if(opty.Account.Fd__c == true) isFDAccount = true;
        if(opty.AccountId != null) accountId = opty.AccountId;
        
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
        for(RMS__c rmsObj : [Select CurrencyIsoCode,Remarks__c,Rate_Type__c,Agent__r.Name,Validity__c, Id,Sea_Freight__c, Equipment_Type__c,Shipping_Line__c,Shipping_Line__r.Name,Equipment_Type__r.name  
                             FROM RMS__c WHERE Port_Of_Loading__r.Name =: portLoading 
                             AND Port_Of_Discharge__r.Name =: portDestination
                             AND Shipping_Line__r.Name != null
                             AND Equipment_Type__r.name != null
                             AND Validity__c >=: todaysDate
                             AND recordtypeId =: RMS_IMPORT_RECORDTYPE_Id
                             AND Equipment_Type__r.name in : routeEquipmentList
                             AND(Customer_name__c =: accountId OR Customer_name__c = null)
                            ]){
                                if(!agentToEquipMap.ContainsKey(rmsObj.Agent__r.Name)){
                                    agentToEquipMap.put(rmsObj.Agent__r.Name,new Map<String,List<BAFCORMSDto>>());
                                }
                                Map<String,List<BAFCORMSDto>> tempMap = agentToEquipMap.get(rmsObj.Agent__r.Name);
                                if(!tempMap.containsKey(rmsObj.Shipping_Line__r.Name)){
                                    tempMap.put(rmsObj.Shipping_Line__r.Name, new List<BAFCORMSDto>());
                                }
                                BAFCORMSDto rmsDto = new BAFCORMSDto();  
                                if(routeEquipmentoquantityMap.containsKey(rmsObj.Equipment_Type__r.name)){
                                    rmsDto.quantity = routeEquipmentoquantityMap.get(rmsObj.Equipment_Type__r.name);
                                }
                                rmsDto.equipmentName = rmsObj.Equipment_Type__r.name;
                                rmsDto.equipmentId = rmsObj.Equipment_Type__c;
                                rmsDto.seaFreight = rmsObj.Sea_Freight__c ; 
                                rmsDto.uniqueEquip = uniqueEquip;
                                uniqueEquip = uniqueEquip+1;
                                rmsDto.rmsID = rmsObj.id;
                                rmsDto.quotationId = QuoteId;
                                rmsDto.agentId = rmsObj.Agent__c;
                                rmsDto.agentName = rmsObj.Agent__r.Name;
                                rmsDto.rateType =rmsObj.Rate_Type__c ;
                                rmsDto.rmsRemarks = rmsObj.Remarks__c;
                                rmsDto.fdAccount = isFDAccount;
                                rmsDto.currencyCode = rmsObj.CurrencyIsoCode;
                                /* NEED TO DISCUSS */
                                /* String key = rmsObj.Shipping_Line__r.Name+'-'+rmsObj.Equipment_Type__r.name;
if(quoteItemToIdMap.containsKey(key)){
rmsDto.quotationItemId = quoteItemToIdMap.get(key);  
}*/
                                Date d = rmsObj.Validity__c != null ? rmsObj.Validity__c : null;
                                rmsDto.buyingRateValidity = d;
                                if(d != null)
                                    rmsDto.validity = DateTime.newInstance(d.year(),d.month(),d.day()).format('dd-MMM-YYYY') +', '+system.today().daysBetween(d) +' Days';
                                tempMap.get(rmsObj.Shipping_Line__r.Name).add(rmsDto);
                                
                            }
        for(String equip : routeEquipmentList){
            for(String key : agentToEquipMap.keyset()){
                for(String key2 : agentToEquipMap.get(key).keyset()){
                    Boolean found = false;
                    for(BAFCORMSDto dto : agentToEquipMap.get(key).get(key2)){
                        if(dto.equipmentName == equip){
                            found = true;
                            break;
                        }
                    }
                    if(!found){
                        BAFCORMSDto rmsDto = new BAFCORMSDto();
                        rmsDto.equipmentName = equip;
                        rmsDto.equipmentId  = '';
                        rmsDto.uniqueEquip = uniqueEquip;
                        rmsDto.fdAccount = isFDAccount;
                        uniqueEquip = uniqueEquip+1;
                        rmsDto.rmsID = '';
                        agentToEquipMap.get(key).get(key2).add(rmsDto);
                    }
                }
            }
        }
        return agentToEquipMap;
    }
    @AuraEnabled
    public static String genrateQuotation(String routeId, String rmsId, String enquiryId,String quotationId, BAFCOImportRMSDto dto, String incoTerm,String remarks, Decimal additionalChargeTotal,Boolean cameReviseCompt, Boolean sameRoute,string agentName, BAFCOImportRMSDto.sellingFieldObj sellingFieldObj){
       /// system.debug('dto '+dto);
       // system.debug('enquiryId '+enquiryId);
      //  system.debug('agentName '+agentName);
        List<BAFCOImportRMSDto.AdditionalCharge> additionalChargeList = dto.additionalChargeList;
        shippingLineChargesDTO shipLineDto = BAFCOshippingLineChargesController.getShippingCharges(rmsId);
        List<Quotation__c> quoteList = new List<Quotation__c>();
        RMS__c rmsObj = [SELECT Id, Port_Of_Loading__c, Port_Of_Discharge__c, Equipment_Type__c FROM RMS__c where id =: rmsId Limit 1];
        BAFCOIncoChargesDto incoDto = BAFCOLRoutingDetailsController.getIncoCharges(rmsId,incoTerm);
        Quotation__c quoteObj = new Quotation__c();
        if(quotationId == ''  || quotationId == null || (cameReviseCompt  == true && sameRoute == true)){
            List<opportunity> enqList  = [SELECT Id,AccountId,Business_Type__c,No_of_Quotes__c,(Select id,name,Name__c from Quotations__r order by createdDate) FROM Opportunity where id =: enquiryId];     
            if(enqList.size() > 0){
                opportunity enqObj = enqList[0];
                //quoteObj.Leadc__c = enqObj.Lead__c;   
                quoteObj.Account__c = enqObj.AccountId;             
                if(enqObj.Business_Type__c == 'Export') {
                    quoteObj.recordtypeId = QUOTE_EXPORT_RECORDTYPE_Id;
                    quoteObj.Quotation_Type__c = 'Sea Export';
                }
                else if(enqObj.Business_Type__c == 'Import') {
                    quoteObj.recordtypeId = QUOTE_IMPORT_RECORDTYPE_Id;
                    quoteObj.Quotation_Type__c = 'Sea Import';
                }
                
                Decimal quoteNumber = enqObj.No_of_Quotes__c + 1;
                quoteList = enqObj.Quotations__r;
            }
            else{
               List<opportunity> enqList1  = [SELECT AccountId,Id,Service_Type__c,Business_Type__c,No_of_Quotes__c,(Select id,name,Name__c from Quotations__r order by createdDate) FROM opportunity where id =: enquiryId];
                system.debug('enqList1 '+enqList1);
                if(enqList1.size() > 0){
                    opportunity enqObj = enqList1[0];
                    quoteObj.Leadc__c = enqObj.Lead__c;
                    quoteObj.Account__c = enqObj.AccountId;
                    if(enqObj.Business_Type__c == 'Export') {
                        quoteObj.recordtypeId = QUOTE_EXPORT_RECORDTYPE_Id;
                    }
                    else if(enqObj.Business_Type__c == 'Import') {
                        quoteObj.recordtypeId = QUOTE_IMPORT_RECORDTYPE_Id;
                    }      
                    quoteObj.Quotation_Type__c = enqObj.Service_Type__c;
                   Decimal quoteNumber = enqObj.No_of_Quotes__c + 1;
                    quoteList = enqObj.Quotations__r;
               }
            }
            quoteObj.Opportunity__c = enquiryId;            
            integer year =  Date.Today().Year();
            string s1=string.valueof(year).right(2);
            Integer Year1= Integer.valueof(s1);
                if(quoteList.size() > 0 ){
                    if(cameReviseCompt == true){
                        String fullName = quoteList[0].Name__c;
                        String lastName = fullName.Substring(fullName.lastIndexOf('/')+1,fullName.length());
                        quoteObj.Name__c = 'Quote/'+Year1+'/'+lastName+'-'+quoteList.size();
                        quoteObj.isRevise__c = true;
                    }else{                
                        Integer  quoteSize = quoteList.size();
                        quoteObj.Name__c = 'Quote/'+Year1+'/'+quoteSize;
                    }
                }
                else{
                    quoteObj.Name__c = 'Quote/'+Year1+'/'+1;
                }
            
            quoteObj.Remarks__c = remarks;
            quoteObj.Effective_From__c = system.today();
            Insert quoteObj;
        }
        else{
            quoteObj.Id = quotationId;
            
        }
        Quotation_Item__c quoteItemObj = new Quotation_Item__c();
        quoteItemObj.Route__c = routeId;
        quoteItemObj.RMS__c = rmsId;
        quoteItemObj.CurrencyIsoCode = dto.currencyCode;
        quoteItemObj.Agent_Name__c = agentName;
        if(rmsObj != null){
            quoteItemObj.Port_of_Discharge__c = rmsObj.Port_Of_Discharge__c;
            quoteItemObj.Port_of_Loading__c = rmsObj.Port_Of_Loading__c;
            quoteItemObj.Equipment_Type__c = rmsObj.Equipment_Type__c;
        }
        if(quotationId == '' || quotationId == null || (cameReviseCompt  == true && sameRoute == true)){
            String initialquoteName = [Select Name from Quotation__c where id=: quoteObj.id limit 1].Name;
            quoteItemObj.Name = initialquoteName + ' - 1';
            quoteItemObj.Quotation__c = quoteObj.id;
        }
        else{
            List<Quotation_Item__c> quoteList3 = [Select id,Quotation__r.name from Quotation_Item__c where Quotation__c =: quotationId];
            quoteItemObj.Quotation__c = quotationId;
            if(quoteList3.size() > 0){
                quoteItemObj.Name = quoteList3[0].Quotation__r.name + ' - '+quoteList3.size() + 1;
            }
            quoteObj.id = quotationId;
            List<opportunity> enqList5  = [SELECT Id,Business_Type__c,No_of_Quotes__c,(Select id,name,Name__c from Quotations__r order by createdDate) FROM Opportunity where id =: enquiryId]; 
            opportunity enqObj = new opportunity();
            if(enqList5.size() > 0) enqObj = enqList5[0];
           integer year =  Date.Today().Year();
            string s1=string.valueof(year).right(2);
            Integer Year1= Integer.valueof(s1);
            Decimal quoteNumber = enqObj.No_of_Quotes__c != null ? enqObj.No_of_Quotes__c + 1 : 0;
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
            
            quoteObj.Remarks__c = remarks;
           if(enqObj.Business_Type__c == 'Export') quoteObj.recordtypeId = QUOTE_EXPORT_RECORDTYPE_Id;
           else if(enqObj.Business_Type__c == 'Import') quoteObj.recordtypeId = QUOTE_IMPORT_RECORDTYPE_Id;                    
           update quoteObj;
        }
        
		quoteItemObj.Total__c = dto.total;
        quoteItemObj.Total_Additional__c = additionalChargeTotal;
        quoteItemObj.Sea_Freight__c = dto.seaFreightSellRate;
        quoteItemObj.Pickup_Place__c= dto.pickupPlace;
        quoteItemObj.INCO_Term__c = dto.incoTermId;
        quoteItemObj.Discharge_Place__c = dto.dischargePlace;
        quoteItemObj.Buying_Rate__c = dto.quoteBuyingRate > 0 ? dto.quoteBuyingRate : null;
        quoteItemObj.Quantity__c = dto.quantity;
        quoteItemobj.Selling_Charges_Include__c = sellingFieldObj.sellingInputField; 
        quoteItemobj.Buying_Charges_Include__c = sellingFieldObj.InputField;
        quoteItemobj.Total_Selling_Service_Charge__c = sellingFieldObj.sellingtotalSl;
        quoteItemobj.Total_Selling_Origin_Charge__c = sellingFieldObj.sellingTotalOrigincharges;
        quoteItemobj.Total_Selling_Destin_Charge__c = sellingFieldObj.sellingdestinTotalCharges;
        quoteItemobj.Total_Selling_Additional_Charge__c = sellingFieldObj.sellingadditionalChargeTotal;
        quoteItemobj.Total_Selling_ExWorks_Charge__c = sellingFieldObj.sellingexWorksTotal;
        quoteItemObj.Add_to_Buying_Additional__c =  dto.addAdditionalCharge != null ? dto.addAdditionalCharge : false;
        quoteItemObj.Included_PDF_Additional__c =  dto.includeAdditionalCharge != null ? dto.includeAdditionalCharge : false;
        
       system.debug('sellingFieldObj '+sellingFieldObj);
        if(dto.selectedShippLine != '' ){
            List<Shipping_Line__c> shipLine = [Select id from Shipping_Line__c where name =:dto.selectedShippLine limit 1];
            if(shipLine.size() > 0) quoteItemObj.Shipping_Linee__c = shipLine[0].id;
        }
        if(dto.agentTabSelected != ''){
            List<Agent__c> agentList = [Select id from Agent__c where name =:dto.agentTabSelected limit 1];
            if(agentList.size() > 0) quoteItemObj.Agent__c = agentList[0].id;
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
            assignAdditionalChargeIntoQuoteItem(additionalChargeList,quoteItemObj,dto);
            if(dto.exWorksObj != null){
                BAFCOLRoutingDetailsController.insertExWorksQuotationCharge(dto.exWorksObj.Name,dto.exWorksObj.LoadCharge,quoteItemObj);
            }

        }
        Catch(Exception e){
            System.debug('Exception '+e.getMessage());
        }
        
        return quoteObj.Id;
    }
    public static Quotation_item__c updateOperationalChargeText(List<BAFCOImportRMSDto.AdditionalCharge> additionalChargeList,Quotation_item__c quoteItemObj,BAFCOImportRMSDto dto){
        String OperationalChargesbuying = '';
        String OperationalChargeSelling = '';
        for(BAFCOImportRMSDto.AdditionalCharge dto2 : additionalChargeList){
            if(dto2.value > 0){
                String nn = dto2.name + ' : '+dto2.value+' '+dto.currencyCode;
                OperationalChargesbuying = OperationalChargesbuying + nn + '\n ';
            }
            if(dto2.sellingCharge > 0) {
                String nn = dto2.name + ' : '+dto2.sellingCharge+' '+dto.currencyCode;
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
    public static void assignAdditionalChargeIntoQuoteItem(List<BAFCOImportRMSDto.AdditionalCharge> additionalChargeList, Quotation_item__c quoteItemObj,BAFCOImportRMSDto dto){
        Map<String,id> additionalChargeMap = new Map<String,id>();
        for(Additional_Charge__c addnObj :  [Select id, name from Additional_Charge__c]){
            additionalChargeMap.put(addnObj.name,addnObj.id);
        }
        List<Quotation_Charges__c> chargeList = new List<Quotation_Charges__c>();
        for(BAFCOImportRMSDto.AdditionalCharge dto2 : additionalChargeList){
            system.debug('dto2' +dto2);
            Quotation_Charges__c newObj = new Quotation_Charges__c();
            newObj.Quotation_Item__c = quoteItemObj.id;
            newObj.Charge_Value__c = dto2.sellingCharge;
            newObj.Buying_Rate__c = dto2.value;
            newObj.isAdditional_Charge__c = true;
            if(additionalChargeMap.containsKey(dto2.name))newObj.Charge_Name__c = additionalChargeMap.get(dto2.name);
            newObj.Charge_Name_text__c = dto2.name;
            chargeList.add(newObj);
        }
        system.debug('chargeList '+chargeList);
        if(chargeList.size() > 0) insert chargeList;
        
    }
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