public class BAFCOReviseQuoteDto {
    @AuraEnabled
    public String quoteNumber {get; set;}
    @AuraEnabled
    public String company {get; set;}
    @AuraEnabled
    public String companyId {get; set;}
    @AuraEnabled
    public String businessType {get; set;}
    @AuraEnabled
    public String mode {get; set;}
    @AuraEnabled
    public String enquiryId {get; set;}
    @AuraEnabled
    public String recordTypeName {get; set;}
    @AuraEnabled
    public String contactMobile {get; set;}
    @AuraEnabled
    public String contactEmail {get; set;}
    @AuraEnabled
    public String leadId {get; set;}
    @AuraEnabled
    public String incoTerm {get; set;}
    @AuraEnabled
    public Decimal accountAvgMargin { get; set; }
    @AuraEnabled
    public Decimal accountBestMargin { get; set; }
    @AuraEnabled
    public Decimal accountAvgCreditDays { get; set; }
    @AuraEnabled
    public Map<String, List<Quotation_Item__c>> routetoItemMap {get; set;}
    @AuraEnabled
    public Boolean isLCL {get; set;}
    @AuraEnabled
    public Boolean isAir {get; set;}
    @AuraEnabled public String currencyString{get;set;}
}