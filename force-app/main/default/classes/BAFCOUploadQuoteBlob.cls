@RestResource(urlMapping='/getQuoteBlob/*')
global class BAFCOUploadQuoteBlob {
@HttpGet
    global static String getQuoteBlob() {
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        String rUrlId = req.requestURI.split('getQuoteBlob/')[1];
        if(rUrlId != null){
            PageReference pdf =  Page.BAFCOGeneratePdf;
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