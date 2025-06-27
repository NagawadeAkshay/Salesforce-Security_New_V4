@isTest
private class LayoutXMLGeneratorCtrlTest {
    // @isTest
    // static void verifyLayoutXMLGeneratorCtrl(){
    //     Test.setCurrentPageReference(new PageReference('Page.LayoutXMLGenerator'));
    //     PageLayoutConfig__c objLayoutConfig = new PageLayoutConfig__c(
    //         Name = 'Test View Layout',
    //         Description__c = 'Test Page Layout',
    //         ObjectAPIName__c = 'Opportunity'
    //     );       
    //     insert objLayoutConfig;
    //     System.assertNotEquals(null, objLayoutConfig.Id);

    //     ApexPages.StandardController sc = new ApexPages.StandardController(objLayoutConfig);        
    //     PageReference pageRef = Page.LayoutXMLGenerator;
    //     pageRef.getParameters().put('id', String.valueOf(objLayoutConfig.Id));
    //     Test.setCurrentPage(pageRef);
    //     LayoutXMLGeneratorCtrl obj = new LayoutXMLGeneratorCtrl(sc);
    //     System.assertNotEquals(null, obj);
    //     Map<String,String> mapParams = new Map<String, String>();
    //     mapParams.put('id', objLayoutConfig.Id);

    //     Test.setMock(HttpCalloutMock.class, new LayoutXMLGeneratorCtrlTestMock());
    //     Test.startTest();
    //     Map<String,Object> XMLResult = LayoutXMLGeneratorCtrl.generateXML(mapParams);        
    //     Test.stopTest();
    //     System.assertNotEquals(null, XMLResult);

    //     Attachment attach=new Attachment();   	
    // 	attach.Name='Unit Test Attachment';
    // 	Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
    // 	attach.body=bodyBlob;
    //     attach.parentId=objLayoutConfig.id;
    //     insert attach;

    //     try{
    //         mapParams = new Map<String, String>();
    //         mapParams.put('recordId', attach.Id);
    //         mapParams.put('initTime', String.valueOf(Datetime.now().millisecond()));
    //         XMLResult = LayoutXMLGeneratorCtrl.pollForAttachment(mapParams);      
    //         System.assertNotEquals(null, XMLResult);
    //     } catch(Exception ex){

    //     }        
    // }

    // private class LayoutXMLGeneratorCtrlTestMock implements HttpCalloutMock {
    //     public HTTPResponse respond(HTTPRequest req) {
    //         HTTPResponse res = new HTTPResponse();
    //         res.setHeader('Content-Type', 'application/json');
    //         res.setBody(req.getBody());
    //         res.setStatusCode(200);            
    //         return res;
    //     }
    // }
}