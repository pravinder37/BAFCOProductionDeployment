public without sharing class BAFCOQuoteCopyContentController {
    @AuraEnabled 
    public static List<QuoteLineList>  getQuoteDataOnLoad(String quoteId){
        List<QuoteLineList> quoteItemList = new List<QuoteLineList>();
        String SubjectLine = '';
        List<Quotation_Item__c> quoteList = [Select Quotation__r.Quotation_Validity__c, Route__r.Commodity__r.name,Discharge_Place__c,Pickup_Place__c,Quotation__r.Account__r.Owner.Name,CurrencyIsoCode,Quotation__r.Name,Customer_Name__c,Shipping_Linee__r.name,Quantity__c,Route__r.Cargo_Weight__c,Rms__r.Free_time_POD__c, Rms__r.Free_time__c,Route__r.INCO_Term__r.name,Route__r.Service_Type__c,id,Quotation__r.Exclusions__c,Quotation__r.Inclusions__c,Quotation__r.Terms_and_Conditions__c,Total__c,Quotation__r.Recordtype.Name,Port_of_Loading__r.Name,Port_of_Discharge__r.Name,Equipment_Type__r.Name from Quotation_Item__c where quotation__c =: quoteId];
        if(quoteList.size() > 0){
            Set<String> portStringSet = new Set<String>();
            Map<Id,String> itemIdToPortString = new  Map<Id,String>();
            for(Quotation_Item__c item : quoteList){
                portStringSet.add(item.Port_of_Loading__r.Name+'-'+item.Port_of_Discharge__r.name);
            }
            // to concatenate all POL & POD 
            for(String ss : portStringSet){
                SubjectLine += ss+','; 
            }
            SubjectLine = SubjectLine.removeEnd(',');
            for(Quotation_Item__c item : quoteList){
                QuoteLineList dto = new QuoteLineList();
                dto.quotationValidity = item.Quotation__r.Quotation_Validity__c != null ? (item.Quotation__r.Quotation_Validity__c.day()+'-'+ BAFCOLeadDetailsController.getMonthName(item.Quotation__r.Quotation_Validity__c.month()) +'-'+item.Quotation__r.Quotation_Validity__c.year()) : '-';
                dto.quoteName = item.Quotation__r.name;
                dto.loadingPort = item.Port_of_Loading__c != null ? item.Port_of_Loading__r.Name : '';
                dto.dischargePort = item.Port_of_Discharge__c != null ? item.Port_of_Discharge__r.Name : '';
                dto.equipmentType = item.Equipment_Type__c != null ? item.Equipment_Type__r.Name : '';
                dto.total = item.Total__c;
                dto.recordtypeName = item.Quotation__r.Recordtype.Name;
                dto.serviceType = item.Route__r.Service_Type__c;
                dto.cargoWeight = item.Route__r.Cargo_Weight__c > 0 ? item.Route__r.Cargo_Weight__c : 0;
                dto.quantity = item.Quantity__c;
                dto.shippingLine = item.Shipping_Linee__r.name;
                dto.customerRefNo ='';
                dto.customerPONo ='';
                dto.subjectLine = SubjectLine;
                dto.customerName = item.Customer_Name__c;
                dto.currencyCode = item.CurrencyIsoCode;
                dto.placeOfPickup = item.Pickup_Place__c != null ? item.Pickup_Place__c : '-';
                dto.placeOfDischarge = item.Discharge_Place__c != null ? item.Discharge_Place__c : '-';
                dto.saleman = item.Quotation__r.Account__r.Owner.Name;
                if(item.Route__r.INCO_Term__c != null) dto.incoterm = item.Route__r.INCO_Term__r.name;                
                else dto.incoterm = '';
                dto.commodity = item.Route__r.Commodity__c != null ? item.Route__r.Commodity__r.name : '';
                if(item.RMS__c != null){
                    dto.freeTimePOD = item.RMS__r.Free_time_POD__c ;
                    dto.freeTimePOL = item.RMS__r.Free_time__c ;
                }
                if(item.Quotation__r.Recordtype.Name == 'Export'){
                    List<String> inclusionList = item.Quotation__r.Inclusions__c != null ? item.Quotation__r.Inclusions__c.split(';;') : null; 
                    if(inclusionList != null && inclusionList.size() > 0){
                        dto.header = inclusionList[0] != null ? inclusionList[0] : null;
                        if(inclusionList.size() >1){
                            dto.headerList = inclusionList[1].split(';');
                        }
                    }
                    List<String> exclusionList =item.Quotation__r.Exclusions__c != null ? item.Quotation__r.Exclusions__c.split(';;') : null; 
                    if(exclusionList != null && exclusionList.size() > 0){
                        dto.exportHeader = exclusionList[0] != null ? exclusionList[0] : null;
                        if(exclusionList.size() >1){
                            dto.exportHeaderList = exclusionList[1].split(';');
                        }
                    }
                }
                else if(item.Quotation__r.Recordtype.Name == 'Import'){
                    List<String> termsList =item.Quotation__r.Terms_and_Conditions__c != null ? item.Quotation__r.Terms_and_Conditions__c.split(';;') : null; 
                    if(termsList != null && termsList.size() > 0){
                        dto.header = termsList[0] != null ? termsList[0] : null;
                        if(termsList.size() >1){
                            dto.headerList = termsList[1].split(';');
                        }
                    }
                }
                quoteItemList.add(dto);
            }
        }
        return quoteItemList;
    }
    @AuraEnabled 
    public static void  sendEmail(String toSend,String toCCSend, String toBCCSend, String subject,String body,String quoteId){ 
        system.debug('quoteId '+quoteId);
                    List<Messaging.EmailFileAttachment> emailFileAttList = new List<Messaging.EmailFileAttachment>();
        if(quoteId != null){
            Quotation__c quoteObj = new Quotation__c();
            quoteObj.id = quoteId;
            quoteObj.Status__c = 'Awaiting CRO';
            emailFileAttList = getContentVers(quoteId);
            update quoteObj;
            system.debug('quoteObj '+quoteObj);
        }
        List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        System.debug('body '+body);
		
        List<String> sendTo = toSend.split(',');
        if(toCCSend != '') {
            List<String> ccTo = toCCSend.split(',');
            mail.setCcAddresses(ccTo);
        }
        if(toBCCSend != ''){
            List<String> bccTo = toBCCSend.split(',');
            mail.setBccAddresses(bccTo);
        }
        mail.setToAddresses(sendTo);
        mail.setSubject(subject); 
        if(emailFileAttList.size() > 0) {
			mail.setFileAttachments(emailFileAttList);   
        }
        mail.setHtmlBody(body);
        mails.add(mail);
        Messaging.sendEmail(mails);
    }
     public static List<Messaging.EmailFileAttachment> getContentVers(Id objId) {  
        List<Messaging.EmailFileAttachment> emailAttachList = new List<Messaging.EmailFileAttachment>();
        List<ContentDocumentLink> CDLs = [SELECT ContentDocumentId FROM ContentDocumentLink WHERE LinkedEntityId =: objId];
        List <Id> CDIdList = new List <Id> ();
        
        for (ContentDocumentLink nextCDL : CDLs) {
            CDIdList.add(nextCDL.ContentDocumentId); 
        }
        List<ContentDocument> entries = [SELECT Id, Title, FileType FROM ContentDocument WHERE ContentDocument.Id IN :CDIdList];
        if(entries.size() > 0) {
            List<ContentVersion> cvList = [SELECT Id, title, VersionData, FileExtension, ContentDocumentId 
                                           FROM ContentVersion 
                                           WHERE ContentDocumentId IN:entries 
                                           And isLatest = true];
            for(ContentVersion cvObj : cvList) {
                emailAttachList.add(setEmailFileAtt(cvObj));            
            }
            return emailAttachList;
        }
        return emailAttachList;
    }
    
    public static Messaging.EmailFileAttachment setEmailFileAtt(ContentVersion cvObj) {
        Messaging.EmailFileAttachment emlAtt = new Messaging.EmailFileAttachment();
        Blob fileData = cvObj.VersionData;
        emlAtt.setFilename(cvObj.title+'.'+ + cvObj.FileExtension);
        emlAtt.setBody(fileData);
        return emlAtt;
    }
    public class QuoteLineList{
        @AuraEnabled public String loadingPort{get;set;}
        @AuraEnabled public String quotationValidity{get;set;}
        @AuraEnabled public String dischargePort{get;set;}
        @AuraEnabled public String equipmentType{get;set;}
        @AuraEnabled public Decimal total{get;set;}
        @AuraEnabled public String recordtypeName{get;set;}
        @AuraEnabled public String header{get;set;}
        @AuraEnabled public List<String> headerList{get;set;}
        @AuraEnabled public String exportHeader{get;set;}
        @AuraEnabled public List<String> exportHeaderList{get;set;}
        @AuraEnabled public String serviceType{get;set;}
        @AuraEnabled public String incoterm{get;set;}
        @AuraEnabled public Decimal freeTimePOD{get;set;}
        @AuraEnabled public Decimal freeTimePOL{get;set;}
        @AuraEnabled public Decimal cargoWeight{get;set;}
        @AuraEnabled public Decimal quantity{get;set;}
        @AuraEnabled public String shippingLine{get;set;}
        @AuraEnabled public String customerRefNo{get;set;}
        @AuraEnabled public String customerPONo{get;set;}
        @AuraEnabled public String subjectLine{get;set;}
        @AuraEnabled public String customerName{get;set;}
        @AuraEnabled public String quoteName{get;set;}
        @AuraEnabled public String currencyCode{get;set;}
        @AuraEnabled public String saleman{get;set;}
        @AuraEnabled public String placeOfPickup{get;set;}
        @AuraEnabled public String placeOfDischarge{get;set;}
        @AuraEnabled public String commodity{get;set;}
    }
}