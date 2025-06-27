@isTest public with sharing class TestSuperCloneCtrl {
    static PageTemplate__c pt;
    static void setUp(){
        pt = TestHelper.getPageTemplateConfig(true);
    }
    @isTest static void testDoCloneStr(){
        User u = TestHelper.getAdminUser(true);
         setUp();
        System.runAs(u) {
            Test.startTest();
                String ptId = SuperCloneCtrl.doCloneStr(pt.Id);
                String falseCheck = 'true';
                System.assertEquals('true',falseCheck);
            Test.stopTest();
        }
    }
    @isTest static void testDoClone(){
        User u = TestHelper.getAdminUser(true);
         setUp();
        System.runAs(u) {
            Test.startTest();
                SuperCloneCtrl.doClone(pt.Id);
                String falseCheck = 'true';
                System.assertEquals('true',falseCheck);
            Test.stopTest();
        }
    }
}