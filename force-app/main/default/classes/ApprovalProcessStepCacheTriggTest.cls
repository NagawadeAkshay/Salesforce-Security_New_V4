@isTest
private class ApprovalProcessStepCacheTriggTest {
    @isTest
    static void verifyApprovalProcessStepCacheTriggerHelper(){
        String nameSpaceprefix  = AppUtils.getNamespacePrefix();
        SObjectConfig__c sObjCon = new SObjectConfig__c();
        sObjCon.Name = nameSpaceprefix + 'SampleObject1__c';
        sObjCon.CriteriaField__c =  nameSpaceprefix  + 'Status__c';
        sObjCon.EnableTimeBaseApproval__c = true;
        insert sObjCon;
        System.assertNotEquals(null, sObjCon.Id);

        ApprovalProcessStepCache__c objApprovalProcessStepCache = TestHelper.createApprovalProcessStepCache(false);
        objApprovalProcessStepCache.SobjectText__c = sObjCon.Name;
        objApprovalProcessStepCache.StepName__c = 'Step_1';
        objApprovalProcessStepCache.StepNumber__c = 1;
        objApprovalProcessStepCache.StepNumber__c = 1;
        objApprovalProcessStepCache.Name = 'Step_1';
        insert objApprovalProcessStepCache;
        System.assertNotEquals(null, objApprovalProcessStepCache.Id);
        
        update objApprovalProcessStepCache;

        try {
            objApprovalProcessStepCache.TimeForApproval__c = 'Test';
            update objApprovalProcessStepCache;
        } catch(Exception ex){
            System.assertNotEquals(null, ex);
        }

        try {
            objApprovalProcessStepCache.SobjectText__c = null;
            update objApprovalProcessStepCache;
        } catch(Exception ex){
            System.assertNotEquals(null, ex);
        }

        try {
            objApprovalProcessStepCache.ProcessDefinitionName__c = null;
            update objApprovalProcessStepCache;
        } catch(Exception ex){
            System.assertNotEquals(null, ex);
        }
    }
}