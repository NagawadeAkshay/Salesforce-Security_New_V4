@isTest
private class TestApprovalStepCacheTriggerHelper {
    @testSetup static void setup() {
        TestHelper.createApprovalProcessStepCache(true);
    }

    @isTest
    static void testApprovalStepCacheTriggerHelper(){
        ApprovalProcessStepCache__c apsc = [Select ID, Name from ApprovalProcessStepCache__c ];
        Test.startTest();
        System.assertNotEquals('Step_1',apsc.Name);
        Test.stopTest();
    }

}