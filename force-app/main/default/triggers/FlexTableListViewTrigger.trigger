trigger FlexTableListViewTrigger on FlexTableFilterListViewConfig__c (before insert, before update, before delete, after insert, after update) {
    new FlexTableListViewTriggerHelper().process();
}