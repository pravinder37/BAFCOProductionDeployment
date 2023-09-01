@isTest
global class BAFCOExchangeRateMockTest implements HttpCalloutMock{
    global HttpResponse respond(HttpRequest request) {
        String json = '{'+
		'    \"success\": true,'+
		'    \"timestamp\": 1664000763,'+
		'    \"base\": \"USD\",'+
		'    \"date\": \"2022-09-24\",'+
		'    \"rates\": {'+
		'        \"INR\": 81.236404,'+
		'        \"AED\": 3.673042'+
		'    }'+
		'}';
        HttpResponse response = new HttpResponse();        
        response.setHeader('Content-Type', 'application/json');
        response.setBody(json);
        response.setStatus('Success');
        response.setStatusCode(200);
        return response;        
    }
    
}