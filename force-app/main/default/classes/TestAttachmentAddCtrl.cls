/*
This class has methods to create charts according to object name.
******************************************************************
Audit History
******************************************************************
2018-10-23 Vaishnavi Tenkale Created
****************************************************************** 
*/

@isTest
private with sharing class TestAttachmentAddCtrl  {
    static List<selectOption> newList;
    static  AttachmentAddCtrl attachmentAddCtrlObj;
    static  SobjectConfig__c sobjectConfigObj ;
    static  SampleObject11__c sampleObject11Obj;
    static  Attachment attachmentObj; 
    static  AttachmentExtension__c attachmentExtensionObj;
    static  PageLayoutConfig__c  pageLayoutConfigObj;
    static  TabConfig__c tabConfigObj;
    static  PageBlockConfig__c pageBlockConfigObj;    
    static  PageAttachmentConfig__c pageAttachmentConfigObj; 
    
    private static void setup(){
        sobjectConfigObj = new SobjectConfig__c(Name=AppUtils.getNamespacePrefix() + 'SampleObject11__c', AttachmentClassifications__c='test1;test2;test3');
        insert SobjectConfigObj; 
        
        sampleObject11Obj=TestHelper.getSampleObject1(true);
        
        attachmentObj = TestHelper.getAttachment(sampleObject11Obj.Id,true);
        attachmentObj.Name = 'New Attachment';
        attachmentObj.Body = Blob.valueOf('Test');
        update attachmentObj;
        
        attachmentExtensionObj = TestHelper.getAttachmentExtension('RESUME OF PROPOSED PERSONNEL',sampleObject11Obj.Id,true);  
        attachmentExtensionObj.Attachment__c = attachmentObj.Id;
        attachmentExtensionObj.IsCloned__c = false;
        update attachmentExtensionObj;
        
        pageLayoutConfigObj = TestHelper.getPageLayoutConfig(true);
        tabConfigObj = TestHelper.getTabConfig(pageLayoutConfigObj.Id, true);
        
        pageBlockConfigObj = TestHelper.getPageBlockConfig(tabConfigObj.Id, true);
        pageBlockConfigObj.AttachmentClassifications__c='other';
        pageBlockConfigObj.ClassificationFieldAPIName__c='SampleText1__c';
        pageBlockConfigObj.AdditionalFieldJSON__c='[{"requiredField": true,"fieldName": "Description__c","fieldLabel": "gsdaj"}]';
        update pageBlockConfigObj;
        
        pageAttachmentConfigObj = TestHelper.getPageAttachmentConfig(pageBlockConfigObj.Id,true);           
        pageAttachmentConfigObj.AttachmentCount__c = -12;
        pageAttachmentConfigObj.MaximumAttachmentCount__c = -11;            
        update pageAttachmentConfigObj;
    }
    //To test ProcessSelected
    @isTest
    private static void TestprocessSelected(){
        newList=new List<selectOption>();
        Test.startTest();
        setup();            
        System.currentPageReference().getParameters().put('parentId', SampleObject11Obj.id);
        apexpages.currentpage().getParameters().put('pBlockId', pageBlockConfigObj.id);
        
        attachmentObj.Description = 'Description';
        update attachmentObj;
        
        AttachmentAddCtrlObj = new AttachmentAddCtrl(); 
        newList = AttachmentAddCtrlObj.classificationsList;
        AttachmentAddCtrlObj.processSelected();
        AttachmentAddCtrlObj.addAttachment();
        AttachmentAddCtrlObj.attachmentObj = attachmentObj;
        AttachmentAddCtrlObj.parentObjectId = SampleObject11Obj.Id;
        AttachmentAddCtrlObj.classificationVal = 'test';
        AttachmentAddCtrlObj.wrapAttachmentList[0].selected=true;
        AttachmentAddCtrlObj.processSelected();
        Test.stopTest();
        
        System.assertNotEquals(AttachmentAddCtrlObj,null);   
    }
    //to test AttachmentAddctrl and without classificationVal, AdditionalFieldJSON__c
    @isTest
    private static void testAttachmentAddCtrl(){
        newList=new List<selectOption>();
      
            Test.startTest();
            setup();
            
            attachmentObj.Description = 'Description';
            update attachmentObj;
            
            PageBlockConfigObj = TestHelper.getPageBlockConfig(TabConfigObj.Id, true);
            
            pageAttachmentConfigObj = TestHelper.getPageAttachmentConfig(pageBlockConfigObj.Id,true);           
            pageAttachmentConfigObj.Classification__c='other';
            update pageAttachmentConfigObj;
            
            System.currentPageReference().getParameters().put('parentId', SampleObject11Obj.id);
            apexpages.currentpage().getParameters().put('pBlockId', PageBlockConfigObj.id);
            
            attachmentAddCtrlObj = new AttachmentAddCtrl(); 
            newList = attachmentAddCtrlObj.classificationsList;
            attachmentAddCtrlObj.attachmentObj = attachmentObj; 
            attachmentAddCtrlObj.classificationVal = 'History';
            List<selectOption> selList = attachmentAddCtrlObj.classificationsList;
            attachmentAddCtrlObj.addAttachment(); 
            Test.stopTest();
      
        System.assertNotEquals(attachmentAddCtrlObj,null);   
    }
    // with classificationVal and AdditionalFieldJSON__c
    @isTest
    public static void testAttachmentsCtrl3(){    
        
        Test.startTest();      
        setup();      
        attachmentAddCtrlObj = new AttachmentAddCtrl();
        attachmentobj.Description = null;   
        update attachmentobj;
        
        pageBlockConfigObj.AdditionalFieldJSON__c='[{"requiredField": true,"fieldName": "","fieldLabel": "gsdaj"}]';
        update pageBlockConfigObj;
        
        attachmentAddCtrlObj.attachmentObj = attachmentObj;
        attachmentAddCtrlObj.classificationVal = 'History';
        List<selectOption> selList = attachmentAddCtrlObj.classificationsList;
        
        attachmentAddCtrlObj.addAttachment();           
        
        Test.stopTest(); 
        System.assertNotEquals(attachmentAddCtrlObj,null);                                            
    }
    
    @isTest
    static void testAddAttachmentCloseModal() {
        AttachmentAddCtrl ctrl = new AttachmentAddCtrl();
        ctrl.addAttachmentCloseModal();
        System.assertEquals(false, ctrl.isSaveClose);
    
    }
    
}