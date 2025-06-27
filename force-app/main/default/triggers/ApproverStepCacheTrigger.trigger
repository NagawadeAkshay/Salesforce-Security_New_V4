trigger ApproverStepCacheTrigger on ApprovalProcessStepCache__c (before insert,before update) {
    if(TestHelper.skipApprovalStepTrigger ==  false){
    new ApprovalProcessStepCacheTriggerHelper().process();
    }
   
}