trigger FlexTableTrigger on DataTableConfig__c (before insert,before update,after insert,before delete) {
    new FlexTableTriggerHelper().process();
}