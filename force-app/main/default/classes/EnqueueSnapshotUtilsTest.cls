//User Story 96008: Internal - POC - Snapshot - "Too many SOQL query" error displayed at program approval/reject/forward/send back
@isTest
public with sharing  class EnqueueSnapshotUtilsTest {
       static PageLayoutActionConfig__c objPageLayoutActionConfig;
       static PageTemplate__c objPageTemplate;
       static SampleObject11__c objSampleObject;
    
    static void setup(){
        List<Id> layoutData = new List<id>();
        layoutData = TestHelper.setLayoutData(AppUtils.getNamespacePrefix()+'SampleObject11__c');  
        objPageLayoutActionConfig = new PageLayoutActionConfig__c();
        objPageLayoutActionConfig.HistoryPostAction__c = true;
        objPageLayoutActionConfig.PageLayoutConfig__c = layoutData.get(0);
        objPageLayoutActionConfig.HistoryPostActionCondition__c = 'IsDeleted';
        objPageLayoutActionConfig.HistoryPostActionPDFFilename__c ='TestFile.pdf';
        objPageLayoutActionConfig.name = 'test';
        insert objPageLayoutActionConfig;
        system.assertNotEquals(null, objPageLayoutActionConfig.Id);
        
        objPageTemplate = TestHelper.getPageTemplateConfig(false);
        objPageTemplate.ViewLayoutConfig__c = layoutData.get(0);
        insert objPageTemplate;
        system.assertNotEquals(null, objPageTemplate.Id);
        
        objSampleObject = TestHelper.getSampleObject1(false);
        objSampleObject.SampleText1__c = 'true';
        insert objSampleObject;
        system.assertNotEquals(null, objSampleObject.Id);
    }
    
    static testmethod  void  testEnqueueSnapshotQueueable(){
        setup();
        
        Test.startTest();
        EnqueueSnapshotUtils objEnqueueSnapshotUtils = new EnqueueSnapshotUtils(objPageLayoutActionConfig.Id, objSampleObject.Id, 'template.name',  '',  '', 'Test.pdf');
        Id jobId = System.enqueueJob(objEnqueueSnapshotUtils);

        EnqueueSnapshotUtils objEnqueueSnapshotUtils1 = new EnqueueSnapshotUtils(objSampleObject.Id, 'template.name',  '',  '');
        Test.stopTest(); 
        
        List<Attachment> lstAttachment = [Select id from Attachment];
        system.assertEquals(1, lstAttachment.size());
        
        List<ApprovalSnapshot__c> lstApprovalSnapshot = [Select id from ApprovalSnapshot__c];
        system.assertEquals(1, lstApprovalSnapshot.size());
    }
}