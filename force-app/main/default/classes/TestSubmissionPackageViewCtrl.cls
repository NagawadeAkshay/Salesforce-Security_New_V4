/**
    Test class for ReviewGroupEditCtrl
    **********************************************************
    Audit History
    **********************************************************
    4/27/2014   Hafsa                           Created
    4/28/2014   Ryan Chadwick                   modified
    **********************************************************  
*/
@isTest
private with sharing class TestSubmissionPackageViewCtrl {
    
    @IsTest(OnInstall=false)
    public static void test_ctrl(){
        User u = TestHelper.getAdminUser(true);
        System.runAs(u) {
        //arrange
        PageTemplate__c pageTemplate = TestHelper.getPageTemplateConfig(false);
        pageTemplate.RecordTypeId	=	Schema.SObjectType.PageTemplate__c.getRecordTypeInfosByName().get('Layout Form').getRecordTypeId();
        insert pageTemplate;
        Package__c pack = TestHelper.getPackage(true, pageTemplate);
        Package__c packTwo = TestHelper.getPackage(true, pageTemplate);
        
        //act
        Test.startTest();
        ApexPages.currentPage().getParameters().put('id',pack.Id);
        SubmissionPackageViewCtrl ctrl = new SubmissionPackageViewCtrl( new ApexPages.StandardController(pack) );
        ctrl.getKeyValueMap();
        Test.stopTest();
        
        //assert
        System.assert(ctrl != null);
        System.assertEquals(ctrl.recordId, pack.Id);
        }
    }    
}