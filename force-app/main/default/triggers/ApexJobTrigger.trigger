trigger ApexJobTrigger on ApexJob__c  (before insert, before update, after undelete) {
    TriggerHelper th = new TriggerHelper ();
    th.setInternalUniqueID();
    new ApexJobTriggerHelper().process();
}