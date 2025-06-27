trigger WorkspaceTrigger on Workspace__c (before insert,before update) {
    new WorkspaceTriggerHelper().process();
}