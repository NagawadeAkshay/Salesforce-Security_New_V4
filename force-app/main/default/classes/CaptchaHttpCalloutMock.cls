/**
 * Created by REI on 14-06-2020.
 */

@isTest
public with sharing class CaptchaHttpCalloutMock  implements HttpCalloutMock{
    public HttpResponse respond(HttpRequest req){
        KeyValueHolder__mdt objMetadataHolder = KeyValueHolderHelper.getKeyValueHolder('Recaptcha');   
        if(objMetadataHolder != null && objMetadataHolder.BooleanValue__c && String.isNotBlank(objMetadataHolder.TextValue__c) ){
	        // String baseUrl =string.valueOf(KeyValueHolderHelper.getKeyValueHolder('Recaptcha').TextValue__c);
	        // System.assertEquals(baseUrl, req.getEndpoint());
	        // System.assertEquals('POST', req.getMethod());
			// // Create a fake response
	        // HttpResponse res = new HttpResponse();
	        // res.setHeader('Content-Type', 'application/json');
	        // res.setBody('{"success":true}');
	        // res.setStatusCode(200);
	        // return res;
			HttpResponse res = new HttpResponse();
			res.setHeader('Content-Type', 'application/json');
			res.setBody('{"success": true, "challenge_ts": "2024-06-07T12:34:56Z", "hostname": "test.com"}');
			res.setStatusCode(200);
			return res;
        }
        return null;
    }
}