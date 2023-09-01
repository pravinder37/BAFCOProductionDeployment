public class BAFCOOrderCreationDto {
    @AuraEnabled
    public String routeName { get; set; }
    @AuraEnabled
    public String routeId { get; set; }
    @AuraEnabled
    public List<equipment> equipment { get; set; }
    
    public class equipment{
        @AuraEnabled
        public String key { get; set; }
        @AuraEnabled
        public List<value> value { get; set; }
    }
    public class value{
        @AuraEnabled public string quoteRemark{get;set;}
        @AuraEnabled public string operationalChargeBuying{get;set;}
        @AuraEnabled public string operationalChargeSelling{get;set;}
        @AuraEnabled public Decimal chargeableWeight { get; set; }
        @AuraEnabled public String currencyCode { get; set; }
        @AuraEnabled public String airLineId { get; set; }
        @AuraEnabled public Decimal sellingRateKg { get; set; }
        @AuraEnabled public Decimal PODFreeTime { get; set; }
        @AuraEnabled public String sellingChargesIncluded { get; set; }
        @AuraEnabled public String quotationType { get; set; }
        @AuraEnabled public Boolean isLCL { get; set; }
        @AuraEnabled public Boolean isAir { get; set; }
        @AuraEnabled public String incoTermId { get; set; }
        @AuraEnabled public String tabView { get; set; }
        @AuraEnabled public Decimal agentShare { get; set; }
        @AuraEnabled
        public String recordtypeId { get; set; }
        @AuraEnabled
        public String shipName { get; set; }
        @AuraEnabled
        public Decimal Qty { get; set; }
        @AuraEnabled
        public Decimal sellingTotal { get; set; }
        @AuraEnabled
        public String accountId { get; set; }
        @AuraEnabled
        public Decimal baf { get; set; }
        @AuraEnabled
        public Decimal bayan { get; set; }
        @AuraEnabled
        public Decimal bunkerSurcharge { get; set; }
        @AuraEnabled
        public Decimal cleaningCharges { get; set; }
        @AuraEnabled
        public Decimal containerMaintenance { get; set; }
        @AuraEnabled
        public Decimal destinationCustomClearnace { get; set; }
        @AuraEnabled
        public Decimal destinationLoading { get; set; }
        @AuraEnabled
        public Decimal dthc { get; set; }
        @AuraEnabled
        public Decimal eic { get; set; }
        @AuraEnabled
        public String enquiryId { get; set; }
        @AuraEnabled
        public String equipmentType { get; set; }
        @AuraEnabled
        public Decimal fasahFee { get; set; }
        @AuraEnabled
        public Decimal inspection { get; set; }
        @AuraEnabled
        public Decimal insurance { get; set; }
        @AuraEnabled
        public Decimal isps { get; set; }
        @AuraEnabled
        public String leadId { get; set; }
        @AuraEnabled
        public Decimal liftOnOff { get; set; }
        @AuraEnabled
        public Decimal loadingCharges { get; set; }
        @AuraEnabled
        public Decimal originCustomClearance { get; set; }
        @AuraEnabled
        public Decimal originloadingCharges { get; set; }
        @AuraEnabled
        public Decimal othc { get; set; }
        @AuraEnabled
        public Decimal portShuttling { get; set; }
        @AuraEnabled
        public String chargesIncluded { get; set; }
        @AuraEnabled
        public String postOfDischarge { get; set; }
        @AuraEnabled
        public String postOfLoading { get; set; }
        @AuraEnabled
        public String quotationId { get; set; }
        @AuraEnabled
        public Decimal refeerCentr { get; set; }
        @AuraEnabled
        public String rmsID { get; set; }
        @AuraEnabled
        public String routeID { get; set; }
        @AuraEnabled
        public Decimal seaFreight { get; set; }
        @AuraEnabled
        public Decimal sealCharges { get; set; }
        @AuraEnabled
        public Decimal sellingRate { get; set; }
        @AuraEnabled
        public Decimal tabadul { get; set; }
        @AuraEnabled
        public Decimal tarapulin { get; set; }
        @AuraEnabled
        public Decimal totalInco { get; set; }
        @AuraEnabled
        public Decimal totalSL { get; set; }
        @AuraEnabled
        public Decimal truckIdealing { get; set; }
        @AuraEnabled
        public Decimal xRay { get; set; }
        @AuraEnabled
        public Boolean checkBoxSelected { get; set; }
        
        @AuraEnabled public Decimal bayanCharges{ get; set; }
        @AuraEnabled public Decimal blFees{ get; set; }
        @AuraEnabled public Decimal carriageCongestionSurcharge{ get; set; }
        @AuraEnabled public Decimal dgSurcharge{ get; set; }
        @AuraEnabled public Decimal exportServiceFees{ get; set; }
        @AuraEnabled public Decimal fasahCharges{ get; set; }
        @AuraEnabled public Decimal fuelSurcharges{ get; set; }
        @AuraEnabled public Decimal gatePassCharges{ get; set; }
        @AuraEnabled public Decimal inlandFuelSurcharges{ get; set; }
        @AuraEnabled public Decimal inlandHandlingFees{ get; set; }
        @AuraEnabled public Decimal inlandHaulage{ get; set; }
        @AuraEnabled public Decimal lowSulpherSurcharge{ get; set; }
        @AuraEnabled public Decimal operationalRecoverySurcharge{ get; set; }
        @AuraEnabled public Decimal lashingCharges{ get; set; }
        @AuraEnabled public Decimal originDetentionCharges{ get; set; }
        @AuraEnabled public Decimal overWeightSurcharge{ get; set; }
        @AuraEnabled public Decimal pickupCharges{ get; set; }
        @AuraEnabled public Decimal totalDestination{ get; set; }
        @AuraEnabled public Decimal vgm{ get; set; }
        @AuraEnabled public Decimal warRiskCharges{ get; set; }
        @AuraEnabled public Decimal totalAdditional{ get; set; }
        @AuraEnabled public String remarksAdditionalCharges{ get; set; }
        @AuraEnabled public String remarksDesinationCharges{ get; set; }
        @AuraEnabled public String remarksoriginCharges{ get; set; }
        @AuraEnabled public String remarksSLCharges{ get; set; }
        
        @AuraEnabled public Decimal containerLashingCharges{ get; set; }
        @AuraEnabled public Decimal dOcharges{ get; set; }
        @AuraEnabled public Decimal lOLOCharges{ get; set; }
        @AuraEnabled public Decimal carrierSecurityFees{ get; set; }
        @AuraEnabled public String pickupPlace { get; set; }
        @AuraEnabled public String dischargePlace { get; set; }
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
        @AuraEnabled public String exWorksId {get;set;}
        @AuraEnabled public Decimal exWorksCharge {get;set;}
        @AuraEnabled public decimal orderBuyingRate {get; set;}
        @AuraEnabled public String shippLine {get;set;}
        @AuraEnabled public String quoteItemId {get; set;}
        @AuraEnabled public String agentId {get; set;}
        @AuraEnabled public Decimal containerLashing {get; set;}
    }
   
}