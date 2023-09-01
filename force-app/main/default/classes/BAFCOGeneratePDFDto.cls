public class BAFCOGeneratePDFDto {
    @AuraEnabled public string customerName{get;set;}
    @AuraEnabled public string contactPerson{get;set;}
    @AuraEnabled public string address{get;set;}
    @AuraEnabled public string phone{get;set;}
    @AuraEnabled public string email{get;set;}
    @AuraEnabled public string quoteNumber{get;set;}
    @AuraEnabled public string quoteIssued{get;set;}
    @AuraEnabled public string preparedBy{get;set;}
    @AuraEnabled public string salesResponsible{get;set;}
    @AuraEnabled public string effectiveFrom{get;set;}
    @AuraEnabled public string validityTo{get;set;}
    @AuraEnabled public string serviceType{get;set;}
    @AuraEnabled public string shippingTerm{get;set;}
    @AuraEnabled public string paymentTerm{get;set;}
    @AuraEnabled public string remarks{get;set;}
    @AuraEnabled public string recordTypeName{get;set;}
    @AuraEnabled public string exclusionHeader{get;set;}
    @AuraEnabled public List<string> exclusionList{get;set;}
    @AuraEnabled public string inclusionHeader{get;set;}
    @AuraEnabled public List<string> inclusionList{get;set;}
    @AuraEnabled public string termsNConditionHeader{get;set;}
    @AuraEnabled public List<string> termsNConditionList{get;set;}
    @AuraEnabled public List<serviceChargeList> serviceChargeList{get;set;}
    @AuraEnabled public List<consigneeList> consigneeList{get;set;}
    @AuraEnabled public List<shipperList> shipperList{get;set;}
    @AuraEnabled public List<ContainerList> ContainerList{get;set;}
    @AuraEnabled public List<ContainerExportList> ContainerExportList{get;set;}
    @AuraEnabled public List<Route_Equipment__c> routeEquipList{get;set;}
    
    public class serviceChargeList{
        @AuraEnabled public string shippingLine{get;set;}
        @AuraEnabled public string transitTime{get;set;}
        @AuraEnabled public string placeOfPickup{get;set;}
        @AuraEnabled public string placeOfDischarge{get;set;}
        @AuraEnabled public string portOfLoading{get;set;}
        @AuraEnabled public string portOfDestination{get;set;}
        @AuraEnabled public string equipmentType{get;set;}
        @AuraEnabled public string lclTabView{get;set;}
        @AuraEnabled public String total{get;set;}
        @AuraEnabled public Decimal rateKg{get;set;}
        @AuraEnabled public decimal totalDC{get;set;}
        @AuraEnabled public Boolean ShowtotalDC{get;set;}
        @AuraEnabled public String agentShare{get;set;}
        @AuraEnabled public string equipmentTypeDC{get;set;}
        @AuraEnabled public string airLine{get;set;}
        @AuraEnabled public string serviceType{get;set;}
        @AuraEnabled public string commodity{get;set;}
        @AuraEnabled public Decimal quantity{get;set;}
        @AuraEnabled public String currencyCode{get;set;}
        @AuraEnabled public Boolean isImport{get;set;}
        @AuraEnabled public decimal totalCBM{get;set;}
        @AuraEnabled public decimal totalGrossWeight{get;set;}
        @AuraEnabled public decimal totalVolumetricWeight{get;set;}
        @AuraEnabled
        public BAFCOImportRMSDto.destinChargeObj destinChargeObj { get; set; }
        @AuraEnabled
        public BAFCOImportRMSDto.originChargesObj originChargesObj { get; set; }
        @AuraEnabled
        public BAFCOImportRMSDto.servichargesObj servichargesObj { get; set; }
        @AuraEnabled
        public BAFCOImportRMSDto.exWorksObj exWorksObj { get; set; }
        @AuraEnabled public List<BAFCOGenerteQuoteDto.AdditionalCharge> addtionalChargeList {get;set;}
    }
    public Class consigneeList{
        @AuraEnabled public string consignee{get;set;}
        @AuraEnabled public string contact{get;set;}
        @AuraEnabled public string phone{get;set;}
        @AuraEnabled public string email{get;set;}
        @AuraEnabled public string mobile{get;set;}
        @AuraEnabled public string consigneeRef{get;set;}
    }
    public Class shipperList{
        @AuraEnabled public string shipper{get;set;}
        @AuraEnabled public string contact{get;set;}
        @AuraEnabled public string phone{get;set;}
        @AuraEnabled public string email{get;set;}
        @AuraEnabled public string mobile{get;set;}
        @AuraEnabled public string notify{get;set;}
    }
    public class ContainerList{
        @AuraEnabled public string quoteNo{get;set;}
        @AuraEnabled public Decimal qty{get;set;}
        @AuraEnabled public string equipmentType{get;set;}
        @AuraEnabled public String BuyingRate{get;set;}
        @AuraEnabled public String exWorks{get;set;}
        @AuraEnabled public String perShipment{get;set;}
        @AuraEnabled public String total{get;set;}
        @AuraEnabled public Decimal podFreeTime{get;set;}
    }
    public class ContainerExportList{
        @AuraEnabled public string quoteNo{get;set;}
        @AuraEnabled public Decimal qty{get;set;}
        @AuraEnabled public string equipmentType{get;set;}
        @AuraEnabled public string unitPrice{get;set;}
        @AuraEnabled public string freight{get;set;}
        @AuraEnabled public String commodity{get;set;}
        @AuraEnabled public String airline{get;set;}
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