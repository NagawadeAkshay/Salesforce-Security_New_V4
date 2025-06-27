/**
 * Created by REI on 11-06-2020.
 */

@isTest
private with sharing class TestTimeBasedAutoApprovalBatch {
    @isTest
    static void verifyTimeBasedAutoApprovalBatch(){
        String nameSpaceprefix  = AppUtils.getNamespacePrefix();
        SObjectConfig__c sObjCon = new SObjectConfig__c();
        sObjCon.Name = nameSpaceprefix + 'SampleObject1__c';
        sObjCon.CriteriaField__c =  nameSpaceprefix  + 'Status__c';
        sObjCon.EnableTimeBaseApproval__c = true;
        insert sObjCon;
        System.assertNotEquals(null, sObjCon.Id);

        ApprovalProcessStepCache__c apsc = new ApprovalProcessStepCache__c(
            EnableTimeBaseApproval__c = true,
            Name = 'Step_1',
            ApprovalStepId__c = TestHelper.getStepId('TestClassSampleApprovalProcess'),
            SobjectText__c = sObjCon.Name,
            ProcessDefinitionName__c = 'TestClassSampleApprovalProcess',
            TimeForApproval__c = '{"min":1}',
            StepName__c = 'Step_1',
            StepNumber__c = 1
        );
        insert apsc;
        System.assertNotEquals(null, apsc.Id);
        TestHelper.skipApprovalStepTrigger = true; 
        TestHelper.getProcessInstanceNodes();        

        TimeBasedAutoApprovalBatch obj = new TimeBasedAutoApprovalBatch();
        System.assertNotEquals(null, obj);
        
        String query = obj.getQuery();
        System.assertNotEquals(null, query);
        List<SObject> scope = Database.query(query);
        System.assertEquals(1, scope.size());
        
        obj.execute(scope);
        TimeBasedAutoApprovalBatch.TimeBasedApproval instance = new TimeBasedAutoApprovalBatch.TimeBasedApproval();
        instance.dateVal = null;
        instance.hours = null;
        instance.min = null;
        instance.day = null;
    }
}