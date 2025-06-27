trigger ConfigPageTemplateTrigger on PageTemplate__c  (before insert, before update, after undelete) {
    new ConfigPageTemplateTriggerHelper().process();
}