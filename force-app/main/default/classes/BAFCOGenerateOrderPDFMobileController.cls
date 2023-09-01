public class BAFCOGenerateOrderPDFMobileController {
public String recordId {get;set;}
    public String recordType {get;set;}
    public BAFCOGenerateOrderPDFMobileController(ApexPages.StandardController controller){
        Map<String, String> pageParameters = ApexPages.currentPage().getParameters();
        String recordId = pageParameters.get('recordId');
        this.recordId = recordId;
        this.recordType = pageParameters.get('recordType');
        system.debug('this.recordId' +this.recordId);
    }
    public PageReference saveOrderPDF() {
        PageReference pdf =  Page.BAFCOOrderPDFPage;
        if(recordType == 'Export' ) pdf =  Page.BAFCOOrderPDFPage;
        else if(recordType == 'Import' ) pdf =  Page.BAFCOOrderImportPDFPage;
        pdf.getParameters().put('recordId',(String)this.recordId);
        pdf.getParameters().put('showShippLine','true');
        pdf.getParameters().put('showCharges','true');
        pdf.getParameters().put('nooverride', '1');
        pdf.setRedirect(true);
        Order__c orderObj = [Select id, name,Account_Order__r.name from Order__c where id =: this.recordId ];
        Blob b = null;
        if(Test.isRunningTest()) { 
            b = blob.valueOf('Unit.Test');
        }
        else{
            b = pdf.getContentAsPdf();
        }
        ContentVersion conVer = new ContentVersion();
        conVer.ContentLocation = 'S';
        conVer.PathOnClient = orderObj.Account_Order__r.name+' - '+orderObj.Name+'.pdf';
        conVer.Title = orderObj.Account_Order__r.name+' - '+orderObj.Name+'.pdf';
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