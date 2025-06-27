@isTest
global with sharing class TestITextHelperHttpCalloutMock implements HttpCalloutMock {
    global HTTPResponse respond(HTTPRequest req) {    
        HTTPResponse res = new HTTPResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody(req.getBody());
        res.setStatusCode(200);            
        return res;
    }
}