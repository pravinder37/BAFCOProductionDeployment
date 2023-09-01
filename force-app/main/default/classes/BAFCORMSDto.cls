public class BAFCORMSDto {
    
    @AuraEnabled
    public String shippingLineId { get; set; }
    @AuraEnabled
    public String incoTermId { get; set; }
    @AuraEnabled
    public String shippingLineName { get; set; }    
    @AuraEnabled
    public String equipmentId { get; set; }
    @AuraEnabled
    public String equipmentName { get; set; }
    @AuraEnabled
    public Integer uniqueEquip { get; set; }
    @AuraEnabled
    public String commodityName { get; set; }
    @AuraEnabled
    public String agentName { get; set; }
    @AuraEnabled
    public String agentId { get; set; }
    @AuraEnabled
    public String lastModifiedByName { get; set; }
    @AuraEnabled
    public String rmsID { get; set; }
    @AuraEnabled
    public String validity { get; set; }
    @AuraEnabled
    public String rateType { get; set; }
    @AuraEnabled
    public String rmsRemarks { get; set; }
    @AuraEnabled
    public Decimal seaFreight { get; set; }
    @AuraEnabled
    public String businessType { get; set; }
    @AuraEnabled
    public String customerName { get; set; }
    @AuraEnabled
    public String quotationId { get; set; }
    @AuraEnabled
    public String quotationItemId { get; set; }
    @AuraEnabled
    public Decimal quantity { get; set; }
    @AuraEnabled
    public String loadingPortId { get; set; }
    @AuraEnabled
    public String loadingDestinationId { get; set; }
    @AuraEnabled
    public String loadingPortName { get; set; }
    @AuraEnabled
    public String loadingDestinationName { get; set; }
    @AuraEnabled
    public String currencyCode { get; set; }
    @AuraEnabled
    public Boolean allInRate { get; set; }
    @AuraEnabled
    public Boolean FOBAllIn { get; set; }
    @AuraEnabled
    public Boolean ExWorksIn { get; set; }
    @AuraEnabled
    public Boolean oceanfreightCheckbox { get; set; }
    @AuraEnabled
    public String FreeTime { get; set; }
    @AuraEnabled
    public String FreeTimePOD { get; set; }
    @AuraEnabled
    public Decimal chargeableWeight { get; set; }
    @AuraEnabled
    public Decimal rateKgs { get; set; }
    @AuraEnabled public boolean isFDAccount{get;set;}
    @AuraEnabled
    public String remarks { get; set; }
    @AuraEnabled public String commodity { get; set; }
    @AuraEnabled public Date buyingRateValidity { get; set; }
    @AuraEnabled public Boolean fdAccount { get; set; }
    @AuraEnabled public String customerId { get; set; }
    @AuraEnabled public List<BAFCOLeadDetailsController.selectedEquip> selectedEquip{get;set;}
    @AuraEnabled public String contractNumber { get; set; }
}