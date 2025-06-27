@isTest
global with sharing class TestUPSMockHttpResponse implements HttpCalloutMock {
	global HTTPResponse respond(HTTPRequest req) {
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/xml');
        res.setBody('<?xml version="1.0" encoding="UTF-8"?><CityStateLookupResponse><ZipCode ID="0"><Zip5>12345</Zip5><City>SCHENECTADY</City><State>NY</State></ZipCode></CityStateLookupResponse>');
        res.setStatusCode(200);
        return res;
	}
}