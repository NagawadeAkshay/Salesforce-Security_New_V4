trigger ConfigDataTableActionTrigger on DataTableAction__c  (before insert, before update, after undelete) {
    new ConfigDataTableActionTriggerHelper().Process();
}