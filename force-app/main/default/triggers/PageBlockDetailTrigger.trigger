trigger PageBlockDetailTrigger on PageBlockConfig__c (before insert,before update) {
    new PageBlockConfigTriggerHelper().process();
}