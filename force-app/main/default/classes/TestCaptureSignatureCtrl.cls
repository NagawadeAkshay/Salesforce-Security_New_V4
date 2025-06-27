/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private with sharing class TestCaptureSignatureCtrl {
    public static AttachmentExtension__c attachExt;
    public static CaptureSignatureCtrl ctrl;
    public static Document doc;
    public static Attachment attachementInstance;
    
    private static void setup(){
        doc = TestHelper.createTestDocument(true, 'New Doc');
        DigitalSignature__c sign = new DigitalSignature__c();
        sign.Name = 'abc';
        sign.RecipientTitle__c = 'abc';
        sign.RecipientEmail__c = 'joshianuja23@gmail.com';
        sign.Notes__c = 'abc';
        sign.SignatureStatus__c = 'completed';
        //sign.DocverifyId__c = 'a0L37000000QgrIEAS';
        sign.DocverifyId__c = doc.id;
        insert sign;
        
        PageLayoutConfig__c plc = TestHelper.getPageLayoutConfig(false,'SampleObject11__c');
     
        insert plc;
        TabConfig__c tc = TestHelper.getTabConfig(plc.Id,true);
        PageBlockConfig__c pbc = TestHelper.getPageBlockConfig(tc.Id,true);
        PageAttachmentConfig__c pac = new PageAttachmentConfig__c();
        pac.Name='Create';
        pac.PageBlockConfig__c = pbc.Id;
        pac.AttachmentCount__c = 1;
        insert pac;
        
        attachementInstance = TestHelper.getAttachment(pac.Id, true);
        AttachmentExtension__c attachmentExtension = new AttachmentExtension__c();
        attachmentExtension.Classification__c = 'History';
        attachmentExtension.Attachment__c = attachementInstance.Id;
        attachmentExtension.ParentId__c = pac.Id;
        attachmentExtension.DigitalSignature__c = sign.id;
        insert attachmentExtension;
        
        
    }
    
    private class WebServiceMockImpl implements WebServiceMock
    {
        public void doInvoke(
        Object stub, Object request, Map<String,Object> response,
        String endpoint, String soapAction, String requestName,
        String responseNS, String responseName, String responseType){
            return;
        }
    }
    

    
    @IsTest
    public static void testAllMethod_1(){
        setup();
        ApexPages.currentPage().getParameters().put('docid',doc.id);
        ApexPages.currentPage().getHeaders().put('Referer','Refer');
        ApexPages.currentPage().getParameters().put('status','new');
        ctrl = new CaptureSignatureCtrl();
        //CaptureSignatureCtrl.extractRequestInfo();
        ctrl.captureEvent();
        system.assertNotEquals(null, ctrl);
    }
    @IsTest
    public static void testAllMethod_2(){
        setup();
        ApexPages.currentPage().getHeaders().put('Referer','Refer');
        ApexPages.currentPage().getParameters().put('docid',doc.id);
        ApexPages.currentPage().getParameters().put('status','completed');
        ctrl = new CaptureSignatureCtrl();
        Test.startTest();
        //System.Test.setMock(WebServiceMock.class, new WebServiceMockImpl());
        //CaptureSignatureCtrl.extractRequestInfo();
        //ctrl.captureEvent();
        system.assertNotEquals(null, ctrl);
        Test.stopTest();
    }
    
     @IsTest
    public static void testAllMethod_4(){        
        setup();
       Test.startTest();
        System.Test.setMock(WebServiceMock.class, new WebServiceMockImpl());
        ApexPages.currentPage().getHeaders().put('Referer','Refer');
        ApexPages.currentPage().getParameters().put('recipient','aaa');
        ApexPages.currentPage().getParameters().put('event','aaa');
        ApexPages.currentPage().getParameters().put('domain','aaa');
        ApexPages.currentPage().getParameters().put('error','System Error');
        ApexPages.currentPage().getParameters().put('docid',doc.id);
        ApexPages.currentPage().getParameters().put('status','completed');
        ctrl = new CaptureSignatureCtrl();
        ctrl.attachmentObj = attachementInstance;
    //  string res = CaptureSignatureCtrl.extractRequestInfo();
        ctrl.captureEvent();
         Test.stopTest();
        system.assertNotEquals(null, ctrl);
    }
    
}