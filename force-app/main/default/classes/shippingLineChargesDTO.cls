public class shippingLineChargesDTO {
    @AuraEnabled
    public Decimal BunkerSurcharge { get; set; }
    @AuraEnabled
    public Decimal BAF { get; set; }    
    @AuraEnabled
    public Decimal ISPS { get; set; }
    @AuraEnabled
    public Decimal OTHC { get; set; }
    @AuraEnabled
    public Decimal CMC { get; set; }
    @AuraEnabled
    public Decimal EIC { get; set; }
    @AuraEnabled
    public Decimal sealCharges { get; set; }
    @AuraEnabled
    public Decimal containerMaintenanceCharge { get; set; }
    @AuraEnabled
    public Decimal equipmentImbalanceCharge { get; set; }
    @AuraEnabled
    public Decimal DTHC { get; set; }
    @AuraEnabled
    public Decimal Total { get; set; }
    @AuraEnabled
    public String currencyCode { get; set; }
    
    
    @AuraEnabled
    public Decimal carriageCongestionSurcharg { get; set; }
    @AuraEnabled
    public Decimal carrierSecurityFees { get; set; }
    @AuraEnabled
    public Decimal cleaningCharges { get; set; }
    @AuraEnabled
    public Decimal DGSurcharge { get; set; }
    @AuraEnabled
    public Decimal inlandFuelSurcharge { get; set; }
    @AuraEnabled
    public Decimal inlandHandlingFees { get; set; }
    @AuraEnabled
    public Decimal inlandhaulage { get; set; }
    @AuraEnabled
    public Decimal lowSulphurSurcharge { get; set; }
    @AuraEnabled
    public Decimal operationalRecoverySurcharge { get; set; }
    @AuraEnabled
    public Decimal overweightsurcharge { get; set; }
    @AuraEnabled
    public Decimal warRiskSurcharge { get; set; }
    @AuraEnabled
    public Decimal offSet { get; set; }
    @AuraEnabled
    public String shipLineName { get; set; }

}