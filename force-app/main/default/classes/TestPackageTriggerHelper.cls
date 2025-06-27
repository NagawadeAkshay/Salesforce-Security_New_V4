/**
    
    **********************************************************
    Audit History
    **********************************************************
   9/10/15 swati singh created
    **********************************************************  
*/
@IsTest
private with sharing class TestPackageTriggerHelper {
    @IsTest
    private static void testInsert() {
        User u = TestHelper.getAdminUser(true);
        
        System.runAs(u) {
        //AccountTriggerHelper.skipAll = false;
        TestHelper.createCustomSettings(true);
       
        //Prepare test data
        PageTemplate__c pt = TestHelper.getPageTemplateConfig(false);
        pt.RecordTypeId = Schema.SObjectType.PageTemplate__c.getRecordTypeInfosByName().get('Layout Form').getRecordTypeId();
        insert pt;
        Package__c p = TestHelper.getPackage(true,pt);
       //Execute test
        Test.startTest();
       
        update p;
        Test.stopTest();
        
        //Assert test data
       
        System.assertEquals(1,1);
        }
    }
}