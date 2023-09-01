public class BAFCOLinitemDto {
    @AuraEnabled
    public String equipmentId { get; set; }
    @AuraEnabled
    public String quoteItemId { get; set; }
    @AuraEnabled
    public String equipmentName { get; set; }
    @AuraEnabled
    public Decimal sellingSeaFreight { get; set; }
    @AuraEnabled
    public Decimal buyingSeaFreight { get; set; }
    @AuraEnabled
    public Decimal sellingDestinationCustomClearance { get; set; }
    @AuraEnabled
    public Decimal buyingDestinationCustomClearance { get; set; }
    @AuraEnabled
    public Decimal sellingBayan { get; set; }
    @AuraEnabled
    public Decimal buyingBayan { get; set; }
    @AuraEnabled
    public Decimal sellingDestinationLoadingCharges { get; set; }
    @AuraEnabled
    public Decimal buyingDestinationLoadingCharges { get; set; }
    @AuraEnabled
    public Decimal sellingFasahFees { get; set; }
    @AuraEnabled
    public Decimal buyingFasahFees { get; set; }
    @AuraEnabled
    public Decimal sellingInspection { get; set; }
    @AuraEnabled
    public Decimal buyingInspection { get; set; }    
    @AuraEnabled
    public Decimal sellingliftOnLiftOff { get; set; }
    @AuraEnabled
    public Decimal buyingliftOnLiftOff { get; set; }
    @AuraEnabled
    public Decimal sellingOriginCustomClerance { get; set; }
    @AuraEnabled
    public Decimal buyingOriginCustomClerance { get; set; }
    @AuraEnabled
    public Decimal sellingOriginLoadingCharges { get; set; }
    @AuraEnabled
    public Decimal buyingOriginLoadingCharges { get; set; }
    @AuraEnabled
    public Decimal sellingPortShuttling { get; set; }
    @AuraEnabled
    public Decimal buyingPortShuttling { get; set; }
    @AuraEnabled
    public Decimal sellingTabadul { get; set; }
    @AuraEnabled
    public Decimal buyingTabadul { get; set; }
    @AuraEnabled
    public Decimal sellingXRay { get; set; }
    @AuraEnabled
    public Decimal buyingXray { get; set; }
    @AuraEnabled
    public Decimal sellingLoadingCharges { get; set; }
    @AuraEnabled
    public Decimal buyingLoadingCharges { get; set; }    
    @AuraEnabled
    public Decimal sellingTotal { get; set; }
    @AuraEnabled
    public Decimal buyingTotal { get; set; }
    @AuraEnabled
    public String validity { get; set; }
    @AuraEnabled
    public String rmsId { get; set; }
    @AuraEnabled
    public list<additionalChargeList> additionalChargeList { get; set; }
    
    public class additionalChargeList{
        @AuraEnabled
        public String Name { get; set; }
        @AuraEnabled
        public Decimal value { get; set; }
    }
}