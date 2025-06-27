trigger ConfigBusinessRuleTrigger on LayoutBusinessRuleConfig__c  (before insert, before update, after undelete) {
    new ConfigBusinessRuleTriggerHelper().process();
}