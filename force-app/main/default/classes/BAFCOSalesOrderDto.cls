public class BAFCOSalesOrderDto {
    @AuraEnabled
    public String routeId { get; set; }
    @AuraEnabled
    public String routeName { get; set; }
    @AuraEnabled
    public String routingRegular { get; set; }
    @AuraEnabled
    public String shipmentKind { get; set; }
    @AuraEnabled
    public String serviceType { get; set; }
    @AuraEnabled
    public String incoTerm { get; set; }
    @AuraEnabled
    public String portLoading { get; set; }
     @AuraEnabled
    public String portLoadingId { get; set; }
    @AuraEnabled
    public String placeOfPickup { get; set; }
    @AuraEnabled
    public String placeOfDischarge { get; set; }
    @AuraEnabled
    public String dgClass { get; set; }
    @AuraEnabled
    public String portDestination { get; set; }
    @AuraEnabled
    public String shippingLine { get; set; }
    @AuraEnabled
    public String commodity { get; set; }
    @AuraEnabled
    public Decimal cargoWeights { get; set; }
    @AuraEnabled
    public Boolean dangerousGoods { get; set; }
    @AuraEnabled
    public String remarks { get; set; }
    @AuraEnabled
    public String enquiryId { get; set; }
}