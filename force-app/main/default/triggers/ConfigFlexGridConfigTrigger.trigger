trigger ConfigFlexGridConfigTrigger on FlexGridConfig__c  (before insert, before update, after undelete) {
     new FlexGridConfigTriggerHelper().process();
}