public class BAFCOGeneratePDFMobileController {
    
    public String recordId {get;set;}
    public BAFCOGeneratePDFMobileController(ApexPages.StandardController controller){
        Map<String, String> pageParameters = ApexPages.currentPage().getParameters();
        String recordId = pageParameters.get('recordId');
        this.recordId = recordId;
        system.debug('this.recordId '+this.recordId);
    }
    public PageReference savePdf() {
        PageReference pdf =  Page.BAFCOGeneratePdf;
        pdf.getParameters().put('recordId',(String)this.recordId);
        pdf.getParameters().put('showShippLine','true');
        pdf.getParameters().put('showCharges','true');
        pdf.getParameters().put('nooverride', '1');
        pdf.setRedirect(true);
        Quotation__c QuoteObj = [Select id,name,Account__r.name from Quotation__c where id=: this.recordId];
        Blob b = null;
        if(test.isRunningTest())  b = blob.valueOf('Unit.Test');
        else b = pdf.getContentAsPdf();
        ContentVersion conVer = new ContentVersion();
        conVer.ContentLocation = 'S';
        conVer.PathOnClient = QuoteObj.Account__r.name+' - '+QuoteObj.Name+'.pdf';
        conVer.Title = QuoteObj.Account__r.name+' - '+QuoteObj.Name+'.pdf';
        conVer.VersionData = b;
        insert conVer;
        List<ContentDocumentLink> toDelete = [Select id from ContentDocumentLink where LinkedEntityId =: this.recordId];
        if(toDelete.size() > 0) delete toDelete;
        Id conDoc = [SELECT ContentDocumentId FROM ContentVersion WHERE Id =:conVer.Id].ContentDocumentId;
        ContentDocumentLink conDocLink = New ContentDocumentLink();
        conDocLink.LinkedEntityId = this.recordId;
        conDocLink.ContentDocumentId = conDoc;
        conDocLink.shareType = 'V';
        insert conDocLink;
        PageReference pg = new PageReference('/'+this.recordId);
        pg.setRedirect(true);
        return pg;  
    }
}