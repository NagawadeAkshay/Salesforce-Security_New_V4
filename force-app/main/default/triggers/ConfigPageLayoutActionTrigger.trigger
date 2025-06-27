trigger ConfigPageLayoutActionTrigger on PageLayoutActionConfig__c (before insert,before update) {
	TriggerHelper th = new TriggerHelper ();
	th.setInternalUniqueID();
	new ConfigPageLayoutActionTriggerHelper().process();
}