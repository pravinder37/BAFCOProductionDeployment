@RestResource(urlMapping='/Test/TestAPI')
global class TestAPIApex {
    @HttpPost
    global static String doPost(String APIBodyParams){
        String responseBack;
        try{
            system.debug('APIBodyParams'+APIBodyParams);
            RestRequest req = RestContext.request;
            //String requestBody = req.requestBody.toString();
            //system.debug('requestBody'+requestBody);
            //dxpGunContactUsCaseCreateRequestWrapper reqWrapper = (dxpGunContactUsCaseCreateRequestWrapper) JSON.deserialize(requestBody, dxpGunContactUsCaseCreateRequestWrapper.class);
            //system.debug('reqWrapper'+reqWrapper);
            responseBack=APIBodyParams;
        }
        catch(Exception e){
            System.debug('Catch Message'+e.getMessage());
        }
        return responseBack;        
    }    
    global class dxpGunContactUsCaseCreateRequestWrapper{
        public String JSONBody {get;set;} 
    }
}