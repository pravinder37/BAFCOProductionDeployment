@isTest
global class BAFCOOrderCalloutMockTest implements HttpCalloutMock{
    global HttpResponse respond(HttpRequest request) {
         String json = '{\"Status\":\"Sucess\",\"SFOrderNumber\":\"ORD-12/22-091\",\"SORO\":\"46418\"}';
        HttpResponse response = new HttpResponse();        
        response.setHeader('Content-Type', 'application/json');
        response.setBody(json);
        response.setStatus('Success');
        response.setStatusCode(200);
        return response;        
    }
}