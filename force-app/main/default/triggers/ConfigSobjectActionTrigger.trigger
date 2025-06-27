trigger ConfigSobjectActionTrigger  on SobjectActionConfig__c (before insert, before update, after undelete) {
     new SobjectActionTriggerHelper().process();
}