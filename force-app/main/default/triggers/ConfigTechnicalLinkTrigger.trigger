trigger ConfigTechnicalLinkTrigger on TechnicalLinkConfig__c  (before insert, before update, after undelete) {
    TriggerHelper th = new TriggerHelper ();
    th.setInternalUniqueID();
}