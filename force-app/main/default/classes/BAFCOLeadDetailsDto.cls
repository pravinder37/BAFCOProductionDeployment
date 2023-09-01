public class BAFCOLeadDetailsDto {
    @AuraEnabled
    public Id leadId { get; set; }
    @AuraEnabled
    public String leadName { get; set; }
    @AuraEnabled
    public String createdDate { get; set; }
    @AuraEnabled
    public String owner { get; set; }
    @AuraEnabled
    public String businessType { get; set; }
    @AuraEnabled
    public String modes { get; set; }
    @AuraEnabled
    public String contactEmail { get; set; }
    @AuraEnabled
    public String contactMobile { get; set; }
    @AuraEnabled public String contactName { get; set; }
}