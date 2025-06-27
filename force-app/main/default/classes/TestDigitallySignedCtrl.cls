@isTest
private with sharing class TestDigitallySignedCtrl {
            
    @testSetup static void setup() {
        // Create Custom Setting for Docverfiy Key and Signature...
        TestHelper.createCustomSettings(true);
        TestHelper.getDigitalSignature(true);
    }
    
    @IsTest
    private static void testFeatchDocument(){
        test.startTest();
        new DigitallySignedCtrl();
        SampleObject11__c objSample1 = TestHelper.getSampleObject1(true);
        SampleObject12__c objSample2 = TestHelper.getSampleObject2(true,objSample1.id);
        String parentObjId = objSample2.Id;
        String classification = 'Digitally Signed Original';
        TestHelper.getAttachmentExtensionForDigSign(classification,parentObjId,true);
        System.assertNotEquals(null,parentObjId);
        List<Id> createLayoutData = TestHelper.setLayoutData();
        String pageBlockId = createLayoutData.get(2);
        TestHelper.getPageAttachmentConfig(pageBlockId,true);
        System.assertNotEquals(null,pageBlockId);
        DigitallySignedCtrl.fetchDocuments(parentObjId,pageBlockId,true,true,true);
        test.stopTest();
    }
 	@IsTest
    private static void testDeleteDocument(){
        test.startTest();
        SampleObject11__c objSample1 = TestHelper.getSampleObject1(true);
        SampleObject12__c objSample2 = TestHelper.getSampleObject2(true,objSample1.id);
        String parentObjId = objSample2.Id;
        System.assertNotEquals(null,parentObjId);
        Attachment attachObj = TestHelper.getAttachment(parentObjId,true);
        DigitallySignedCtrl.deleteDocument(attachObj.Id);
        test.stopTest();
    }
            
    @IsTest
    private static void testCancelSignature(){
        test.startTest();
        // Mock Callout of DocVerify.....
        Test.setMock(WebServiceMock.class,new DigitalSignatureCalloutMock());
        String apiKey = TestHelper.getKeyValueStoreStringValue('DocverifyAPIKey');
        String apiSig = TestHelper.getKeyValueStoreStringValue('DocverifyAPISignature');
        String docVerifyId = 'f81fd695-8634-96cc-42157149cbeO';
        System.assertNotEquals(null, docVerifyId);
        DigitallySignedCtrl.cancelSignature(apiKey,apiSig,docVerifyId);
        test.stopTest();
    }

    @isTest
    static void testProperties() {
        DigitallySignedCtrl obj = new DigitallySignedCtrl();
        Account acc = new Account(Name = 'Test');
        Test.startTest();
        insert acc;
        Test.stopTest();
        Id sampleId = acc.Id;
        obj.parentObjectId = sampleId;
        obj.titleValue = 'Sample Title';
        obj.pageBlockId = acc.Id;
        obj.classification = 'Sample Classification';
        obj.isDigiSign = true;
        obj.isViewVal = false;
        String setNamespace = 'MyNamespace';
        obj.namespace = setNamespace;
        System.assertEquals(setNamespace, obj.namespace);
        obj.namespace = null;
        String expectedNamespace = AppUtils.getNameSpacePrefix();
        System.assertEquals(expectedNamespace, obj.namespace);
        System.assertEquals(sampleId, obj.parentObjectId);
        System.assertEquals('Sample Title', obj.titleValue);
        System.assertEquals(acc.Id, obj.pageBlockId);
        System.assertEquals('Sample Classification', obj.classification);
        System.assertEquals(true, obj.isDigiSign);
        System.assertEquals(false, obj.isViewVal);
        Integer offset = obj.timeOffset;
        TimeZone tz = UserInfo.getTimeZone();
        Integer expectedOffset = tz.getOffset(System.now());
        System.assertEquals(expectedOffset, offset);
    }
             
}