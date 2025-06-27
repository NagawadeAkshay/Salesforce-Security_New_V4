trigger SObjectSharingRuleTrigger on SObjectSharingRule__c(before insert,before update,after insert, after delete) {
    new SObjectSharingRuleTriggerHelper().process();       
}