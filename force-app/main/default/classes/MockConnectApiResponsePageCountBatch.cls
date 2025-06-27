@IsTest
public class MockConnectApiResponsePageCountBatch implements HttpCalloutMock{

    public HttpResponse respond(HttpRequest request) {
        // Create a fake response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('{"example":"test"}');
        res.setStatusCode(200);
        return res;
    }
}