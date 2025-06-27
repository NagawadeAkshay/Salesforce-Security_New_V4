trigger ConfigSObjectLayoutTrigger on SObjectLayoutConfig__c  (before insert, before update, after undelete) {
    /*TriggerHelper th = new TriggerHelper ();
    th.setInternalUniqueID();*/ 
    // Tomy - 09/04/2018 - Replaced TriggerHelper with SObjectLayoutConfigTriggerHelper extended from TriggerHelper
    new SObjectLayoutConfigTriggerHelper().process();
}