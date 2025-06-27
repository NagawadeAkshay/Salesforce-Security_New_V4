trigger FlexTableDetailTrigger on DataTableDetailConfig__c( before insert, before update, after insert, after update) {
    new FlexTableDetailTriggerHelper().process();
}