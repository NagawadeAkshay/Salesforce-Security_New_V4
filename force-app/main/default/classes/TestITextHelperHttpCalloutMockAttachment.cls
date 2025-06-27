@isTest
global with sharing class TestITextHelperHttpCalloutMockAttachment implements HttpCalloutMock {
    global HTTPResponse respond(HTTPRequest req) {    
        HTTPResponse res = new HTTPResponse();
        res.setHeader('Content-Type', 'application/json');
        Account objAccount = new Account(Name = 'TestAccount');
        insert objAccount;
        
        Attachment objAttachment = new Attachment(
            ParentId = objAccount.Id,
            Name = 'Test Attachment for Parent',
            Body = Blob.valueOf('Test Data')
        );        
        insert(objAttachment); 
        
        res.setBody('{attachmentId=00P4P00001lzzUfUAI, exception=null, success=true}');
        res.setStatusCode(200);            
        return res;
    }
}