public class BAFCOImportRMSDto {
    public BAFCOImportRMSDto(){
        additionalChargeList = new List<BAFCOImportRMSDto.AdditionalCharge>();
    }
    @AuraEnabled
    public Decimal seaFreightSellRate { get; set; }
    @AuraEnabled
    public Decimal quantity { get; set; }
    @AuraEnabled
    public Decimal quoteBuyingRate { get; set; }
    @AuraEnabled
    public Decimal total { get; set; }
    @AuraEnabled
    public String quotationItemId { get; set; }
    @AuraEnabled
    public String selectedShippLine { get; set; }
    @AuraEnabled
    public String agentTabSelected { get; set; }
    @AuraEnabled
    public Decimal offSet { get; set; }
    @AuraEnabled
    public String incoTermId { get; set; }
    @AuraEnabled
    public String currencyCode { get; set; }
    @AuraEnabled
    public String pickupPlace { get; set; }
    @AuraEnabled
    public String dischargePlace { get; set; }
    @AuraEnabled
    public exWorksObj exWorksObj  { get; set; }
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
    @AuraEnabled
    public serviceChargeList serviceChargeList { get; set; }
    @AuraEnabled public sellingFieldObj sellingFieldObj {get;set;}
    @AuraEnabled
    public List<AdditionalCharge> additionalChargeList { get; set; }
    public Class AdditionalCharge{ 
        @AuraEnabled
        public String name { get; set; }
        @AuraEnabled
        public Decimal value { get; set; }
        @AuraEnabled public decimal sellingCharge {get;set;}
    }
    public class serviceChargeList{
        @AuraEnabled
        public Decimal offSet { get; set; }
        @AuraEnabled
        public String currencyCode { get; set; }
        @AuraEnabled
        public BAFCOImportRMSDto.destinChargeObj destinChargeObj { get; set; }
        @AuraEnabled
        public BAFCOImportRMSDto.originChargesObj originChargesObj { get; set; }
        @AuraEnabled
        public BAFCOImportRMSDto.servichargesObj servichargesObj { get; set; }
        @AuraEnabled
        public BAFCOImportRMSDto.additionalChargesObj additionalChargesObj { get; set; }
    }
    public class destinChargeObj{
        @AuraEnabled
        public Decimal destinBayanCharges { get; set; }
        @AuraEnabled
        public Decimal destinCustomClearanceCharges { get; set; }
        @AuraEnabled
        public Decimal destinDOCharges { get; set; }
        @AuraEnabled
        public Decimal destinDTHCCharges { get; set; }
        @AuraEnabled
        public Decimal destinFasahCharges { get; set; }
        @AuraEnabled
        public Decimal destinGatePassCharges { get; set; }
        @AuraEnabled
        public Decimal destinLOLOCharges { get; set; }
        @AuraEnabled
        public Decimal destinTransPortationCharges { get; set; }
        @AuraEnabled
        public Decimal destinTotalCharges { get; set; }
        @AuraEnabled
        public Boolean DestinTotalChanged { get; set; }
        @AuraEnabled public Boolean includeDestinCharge { get; set; }
    }
    public class originChargesObj{
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
        @AuraEnabled Public String directionValue{get; set;}
        @AuraEnabled Public String loadingChargeId{get; set;}
        @AuraEnabled Public Boolean originTotalChanged{get; set;}
        @AuraEnabled Public String loadingChargeName{get; set;}
        @AuraEnabled public Boolean includeOriginCharge { get; set; }
    }
    public class servichargesObj{
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
        @AuraEnabled public boolean shippTotalChanged  {get; set;}
        @AuraEnabled public Boolean includeServiceCharge { get; set; }
    }
    public class exWorksObj{
        @AuraEnabled public String Id {get; set;}
        @AuraEnabled public String Name {get; set;}
        @AuraEnabled public String pickup {get; set;}
        @AuraEnabled public String LoadingPort {get; set;}
        @AuraEnabled public decimal LoadCharge {get; set;}
        @AuraEnabled public Boolean includeExWorksCharge { get; set; }
    }
    public class additionalChargesObj{
        @AuraEnabled public decimal Bayancancellationcharge {get; set;}
        @AuraEnabled public decimal Cleaningcharges {get; set;}
        @AuraEnabled public decimal ContainerLashingCharges {get; set;}
        @AuraEnabled public decimal Containermovementcharges {get; set;}
        @AuraEnabled public decimal Containerstripping {get; set;}
        @AuraEnabled public decimal Freetimecertificatecharges {get; set;}
        @AuraEnabled public decimal Fumigation {get; set;}
        @AuraEnabled public decimal Inspection {get; set;}
        @AuraEnabled public decimal Insurancecharges {get; set;}
        @AuraEnabled public decimal MinistryclearncechargeforOOGcargo {get; set;}
        @AuraEnabled public decimal Miscellaneous {get; set;}
        @AuraEnabled public decimal MOTfinecharges {get; set;}
        @AuraEnabled public decimal NonPalletizedSurcharge {get; set;}
        @AuraEnabled public decimal Pestcontrol {get; set;}
        @AuraEnabled public decimal Repalletization {get; set;}
        @AuraEnabled public decimal Reefercntrplugincharges {get; set;}
        @AuraEnabled public decimal ReeferPTIcharges {get; set;}
        @AuraEnabled public decimal Reefersteamwash {get; set;}
        @AuraEnabled public decimal StuffingCharges {get; set;}
        @AuraEnabled public decimal SweepingCleaning {get; set;}
        @AuraEnabled public decimal TruckHeadcharges {get; set;}
        @AuraEnabled public decimal Truckidlingcharges {get; set;}
        @AuraEnabled public decimal Vesselcertificatecharges {get; set;}
        @AuraEnabled public decimal Wrappingpackingcharges {get; set;}
        @AuraEnabled public decimal totalAdditional {get; set;}
        @AuraEnabled public decimal AlternateDepotReleaseCharges {get; set;}
        @AuraEnabled public decimal FreightDifference {get; set;}
        @AuraEnabled public decimal CarrierContainerRepositioningCharges {get; set;}
        @AuraEnabled public decimal tankRentalCharge {get; set;}
        @AuraEnabled public Boolean includeAdditionalCharge { get; set; }
    }
    public class sellingFieldObj{
        @AuraEnabled public String sellingInputField {get; set;}
        @AuraEnabled public String InputField {get; set;}
        @AuraEnabled public decimal sellingdestinTotalCharges {get; set;}
        @AuraEnabled public decimal sellingTotalOrigincharges {get; set;}
        @AuraEnabled public decimal sellingtotalSl {get; set;}
        @AuraEnabled public decimal sellingexWorksTotal {get; set;}
        @AuraEnabled public decimal sellingadditionalChargeTotal {get; set;}
    }
}