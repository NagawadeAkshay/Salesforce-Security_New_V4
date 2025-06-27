trigger EmailTemplateConfigTrigger on EmailTemplateConfig__c (before insert,before update) {
	TriggerHelper th = new TriggerHelper ();
	th.setInternalUniqueID();
	new EmailTemplateConfigTriggerHelper().process();
}