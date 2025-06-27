/**
    Test class for SnapshotUtils
    **********************************************************
    Audit History
    **********************************************************
    4/28/2014   	Vineeth   	Created
    7/13/2015 		Jianwen 	Edited
    10/27/2016 		Anuja		Edited
    **********************************************************  
*/
@isTest
private with sharing class TestSnapshotUtils {
    
       static PageLayoutActionConfig__c plac;
       static PageTemplate__c temp;
       static SampleObject11__c ann;
       
       static void setup(){
           List<Id> layoutData = new List<id>();
           layoutData = TestHelper.setLayoutData(AppUtils.getNamespacePrefix()+'SampleObject11__c');  
           plac = new PageLayoutActionConfig__c();
           plac.HistoryPostAction__c = true;
           plac.PageLayoutConfig__c = layoutData.get(0);
           plac.HistoryPostActionCondition__c = 'IsDeleted';
           plac.HistoryPostActionPDFFilename__c ='TestFile.pdf';
           plac.name = 'test';
           insert plac;
              
           temp = TestHelper.getPageTemplateConfig(false);
           temp.ViewLayoutConfig__c = layoutData.get(0);
           insert temp;
                 
           ann = TestHelper.getSampleObject1(false);
           ann.SampleText1__c = 'true';
           insert ann;
       }
       static void setup_1(){
           List<Id> layoutData = new List<id>();
           layoutData = TestHelper.setLayoutData(AppUtils.getNamespacePrefix()+'SampleObject11__c');  
           plac = new PageLayoutActionConfig__c();
           plac.HistoryPostAction__c = true;
           plac.PageLayoutConfig__c = layoutData.get(0);
           plac.HistoryPostActionPDFFilename__c ='TestFile.pdf';
           plac.name = 'test';
           insert plac;
              
           temp = TestHelper.getPageTemplateConfig(false);
           temp.ViewLayoutConfig__c = layoutData.get(0);
           insert temp;
                 
           ann = TestHelper.getSampleObject1(false);
           ann.SampleText1__c = 'true';
           insert ann;
       }
        @IsTest(OnInstall=false)
    	private static void testcreateSnapshot() {
        user u = testHelper.getAdminUser(false);
        system.runAs(u){
            Test.startTest();
            setup();
            SnapshotUtils.createSnapshot(ann.id,temp.Name,'','');  
           // SnapshotUtils.approvalSnapshot(plac.Id,ann.id,'temp.Name','','','test.pdf');
            Test.stopTest();
           System.assertNotEquals(plac.Id,null); 
        }
        
    }
   
    @IsTest(OnInstall=false)
    private static void test_1() {
        user u = testHelper.getAdminUser(false);
        system.runAs(u){
            Test.startTest();
            setup();
            SnapshotUtils.historyPostAction(plac.Id+'',ann.id,temp.Name,'','');  
            SnapshotUtils.approvalSnapshot(plac.Id,ann.id,'temp.Name','','','test.pdf');
            Test.stopTest();
            System.assertNotEquals(plac.Id,null); 
        }
        
    }
    @IsTest(OnInstall=false)
    private static void test_2() {
        user u = testHelper.getAdminUser(false);
        system.runAs(u){
            Test.startTest();
            setup_1();
            SnapshotUtils.historyPostAction(plac.Id+'',ann.id,temp.Name,'','');  
            SnapshotUtils.approvalSnapshot(plac.Id,ann.id,'temp.Name','','','test.pdf');
            Test.stopTest(); 
            System.assertNotEquals(plac.Id,null);
        }
        
    }
 
    /*@IsTest(OnInstall=false)
    private static void testCreateSnapshot_2() {
        user u = testHelper.getAdminUser(false);
        system.runAs(u){
        Test.startTest();  
            setup();
                SnapshotUtils.historyPostAction(plac.Id+'',ann.Id,temp.Name,'','');
            Test.stopTest();
        }         
    }*/

    @isTest
    static void testCreateSnapshotWithSalesforceFileEnabled() {
        Test.startTest();
        SampleObject11__c sampleObj = TestHelper.getSampleObject1(true);
        Id recordId = sampleObj.Id;
        String templateName = 'TestTemplate';
        String flexTableParameter = '{"SnapshotName": "TestSnapshot"}';
        String listParams = 'TestListParams';
        String pkgId = 'TestPkgId';
        List<String> formTypes = new List<String>{'FormType1', 'FormType2'};
        String parentLayId = 'TestParentLayId';
        String classification = 'TestClassification';
        String result = SnapshotUtils.createSnapshot(recordId, templateName, flexTableParameter, listParams, pkgId, formTypes, parentLayId, classification);
        System.assertNotEquals('', result);
        Test.stopTest();
    }
}