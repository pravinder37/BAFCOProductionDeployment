public class BAFCOIncoChargesDto {
	@AuraEnabled
    public Decimal bayan { get; set; }
    @AuraEnabled
    public Decimal destinationCustomsClearance { get; set; }    
    @AuraEnabled
    public Decimal destinationLoadingCharges { get; set; }
    @AuraEnabled
    public Decimal fasahFee { get; set; }
    @AuraEnabled
    public Decimal inspection { get; set; }
    @AuraEnabled
    public Decimal liftOnLiftOff { get; set; }    
    @AuraEnabled
    public Decimal originCustomsclearance { get; set; }
    @AuraEnabled
    public Decimal originLoadingCharges { get; set; }
    @AuraEnabled
    public Decimal portShuttling { get; set; }    
    @AuraEnabled
    public Decimal tabadul { get; set; }
    @AuraEnabled
    public Decimal xray { get; set; }
    @AuraEnabled
    public Decimal total { get; set; }
    @AuraEnabled
    public Decimal seaFreight { get; set; }  
    @AuraEnabled
    public Decimal loadingCharge { get; set; } 
    @AuraEnabled
    public String loadingChargeId { get; set; } 
    @AuraEnabled
    public String rmsId { get; set; } 
    @AuraEnabled
    public String rmsName { get; set; } 
    @AuraEnabled
    public String currencyCode { get; set; }
    
    @AuraEnabled
    public Decimal bLFees { get; set; } 
    @AuraEnabled
    public Decimal exportServiceFees { get; set; } 
    @AuraEnabled
    public Decimal fuelSurcharge { get; set; } 
    @AuraEnabled
    public Decimal insuranceCharges { get; set; } 
    @AuraEnabled
    public Decimal lashingCharges { get; set; } 
    @AuraEnabled
    public Decimal originDetentionDemurrageCharges { get; set; } 
    @AuraEnabled
    public Decimal OTHC { get; set; } 
    @AuraEnabled
    public Decimal pickupCharges { get; set; } 
    @AuraEnabled
    public Decimal reeferPluginCharges { get; set; } 
    @AuraEnabled
    public Decimal tarpaulinCharges { get; set; } 
    @AuraEnabled
    public Decimal truckidlingCharges { get; set; } 
    @AuraEnabled
    public Decimal vGM { get; set; } 
    @AuraEnabled
    public Decimal offSet { get; set; }
}