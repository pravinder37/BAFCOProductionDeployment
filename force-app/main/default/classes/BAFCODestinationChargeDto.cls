public class BAFCODestinationChargeDto {
	@AuraEnabled
    public Decimal bayanCharges { get; set; }
    @AuraEnabled
    public Decimal customClearance { get; set; }    
    @AuraEnabled
    public Decimal doCharges { get; set; }
    @AuraEnabled
    public Decimal DTHC { get; set; }
    @AuraEnabled
    public Decimal fasahCharges { get; set; }
    @AuraEnabled
    public Decimal gatePassCharges { get; set; }
    @AuraEnabled
    public Decimal LOLOCharges { get; set; }
    @AuraEnabled
    public Decimal total { get; set; }
    @AuraEnabled
    public Decimal transportation { get; set; }
    @AuraEnabled
    public String currencyCode { get; set; }
    @AuraEnabled
    public Decimal offSet { get; set; }
    
}