public class BAFCOAllQuotationItemDto {
    //General variable 
    @AuraEnabled public String itemId { get; set; }
    @AuraEnabled public Decimal buyingRate { get; set; }
    @AuraEnabled public Decimal transitTime { get; set; }
    @AuraEnabled public Decimal buyingRatekg { get; set; }
    @AuraEnabled public Decimal sellingRatekg { get; set; }
    @AuraEnabled public Decimal chargeableWeight { get; set; }
    @AuraEnabled public String includedBuyingCharges {get;set;}
    @AuraEnabled public String includedSellingCharges {get;set;}
    @AuraEnabled public Decimal seaFreight { get; set; }
    @AuraEnabled public Decimal totalSellingRate { get; set; }
    @AuraEnabled public Decimal totalBuyingRate { get; set; }
    @AuraEnabled public String validity { get; set; }
    @AuraEnabled public String rmsId { get; set; }
    @AuraEnabled public String currencyCode { get; set; }
    @AuraEnabled public String equipmentName { get; set; }
    @AuraEnabled public String equipmentId { get; set; }
    @AuraEnabled public String quotationDate { get; set; }
    @AuraEnabled public Decimal totaladditionalCharge { get; set; }
    //destiation charge
    @AuraEnabled public Decimal destinBayanCharges { get; set; }
    @AuraEnabled public Decimal destinCustomClearanceCharges { get; set; }
    @AuraEnabled public Decimal destinDOCharges { get; set; }
    @AuraEnabled public Decimal destinDTHCCharges { get; set; }
    @AuraEnabled public Decimal destinFasahCharges { get; set; }
    @AuraEnabled public Decimal destinGatePassCharges { get; set; }
    @AuraEnabled public Decimal destinLOLOCharges { get; set; }
    @AuraEnabled public Decimal destinTransPortationCharges { get; set; }
    @AuraEnabled public Decimal destinTotalCharges { get; set; }
    
    //OriginCharges
    @AuraEnabled Public decimal bayan{get; set;}
    @AuraEnabled Public decimal blFees{get; set;}
    @AuraEnabled Public decimal originCustomClearance{get; set;}
    @AuraEnabled Public decimal exportServiceFees{get; set;}
    @AuraEnabled Public decimal fasahFees{get; set;}
    @AuraEnabled Public decimal inspection{get; set;}
    @AuraEnabled Public decimal insuranceCharges{get; set;}
    @AuraEnabled Public decimal liftOnLiftOff{get; set;}
    @AuraEnabled Public decimal OriginDetention{get; set;}
    @AuraEnabled Public decimal OriginLoadingCharges{get; set;}
    @AuraEnabled Public decimal pickUpCharges{get; set;}
    @AuraEnabled Public decimal ReeferControlPlugInCharge{get; set;}
    @AuraEnabled Public decimal tabadul{get; set;}
    @AuraEnabled Public decimal trapulinCharges{get; set;}
    @AuraEnabled Public decimal truckIdlingCharges{get; set;}
    @AuraEnabled Public decimal transportationCharges{get; set;}
    @AuraEnabled Public decimal vgm{get; set;}
    @AuraEnabled Public decimal xray{get; set;}
    @AuraEnabled Public decimal lashingCharges{get; set;}
    @AuraEnabled Public decimal fuelSurcharge{get; set;}
    @AuraEnabled Public decimal TotalOrigincharges{get; set;}
    
    //Service Charges
    @AuraEnabled public decimal BAF  {get; set;}
    @AuraEnabled public decimal bunkerCharges {get; set;}
    @AuraEnabled public decimal cleaningCharges {get; set;}
    @AuraEnabled public decimal CMC {get; set;}
    @AuraEnabled public decimal carriageCongestionSurcharge {get; set;}
    @AuraEnabled public decimal carrierSecurityFees {get; set;}
    @AuraEnabled public decimal dgSurcharge {get; set;}
    @AuraEnabled public decimal DTHC {get; set;}
    @AuraEnabled public decimal equipmentImbalance {get; set;}
    @AuraEnabled public decimal inlandFuelCharges {get; set;}
    @AuraEnabled public decimal inlandHandlingfees {get; set;}
    @AuraEnabled public decimal inlandHaulage {get; set;}
    @AuraEnabled public decimal ISPS {get; set;}
    @AuraEnabled public decimal lowerSulphurSurcharge {get; set;}
    @AuraEnabled public decimal operationalRecovery {get; set;}
    @AuraEnabled public decimal OTHC {get; set;}
    @AuraEnabled public decimal overWeightCharge {get; set;}
    @AuraEnabled public decimal sealCharges {get; set;}
    @AuraEnabled public decimal warRiskSurcharges {get; set;}
    @AuraEnabled public decimal totalSl {get; set;}
    @AuraEnabled public String exWorksCharge {get; set;}
    @AuraEnabled public decimal LoadCharge {get; set;}
    @AuraEnabled
    public list<additionalChargeList> additionalChargeList { get; set; }
    
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
    
    public class additionalChargeList{
        @AuraEnabled
        public String Name { get; set; }
        @AuraEnabled
        public Decimal value { get; set; }
        @AuraEnabled public Decimal buyingCharge {get;set;}
    }
}