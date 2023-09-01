@RestResource(urlMapping='/getOrderBlob/*')
global class BAFCOUploadOrderBlob {
    @HttpGet
    global static String getOrderBlob() {
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        String rUrlId = req.requestURI.split('getOrderBlob/')[1];
        if(rUrlId != null){
            PageReference pdf = null;
            Order__c OrderObj = [Select id,Order_Type__c from order__c where id =: rUrlId limit 1];
            if(OrderObj.Order_Type__c == 'Sea Import') pdf = Page.BAFCOOrderImportPDFPage;
            else if(OrderObj.Order_Type__c == 'Air Export' || OrderObj.Order_Type__c == 'Air Import') pdf = Page.BAFCOAirOrderPDFPage;
            else pdf = Page.BAFCOOrderPDFPage;
            pdf.getParameters().put('recordId',(String)rUrlId);
            pdf.getParameters().put('showShippLine','true');
            pdf.getParameters().put('showCharges','true');
            pdf.getParameters().put('nooverride', '1');
            pdf.setRedirect(true);
            Blob b = null;
            if(Test.isRunningTest()) { 
                b = blob.valueOf('Unit.Test');
            }
            else{
                b = pdf.getContentAsPdf();
            }
			return FormData.writeFileBody('test',b,'orderPdf');
        }
        return null;
    }
}