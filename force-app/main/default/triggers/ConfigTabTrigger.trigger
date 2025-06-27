trigger ConfigTabTrigger on TabConfig__c  (before insert, before update, after undelete) {
    new ConfigTabTriggerHelper().process();
}