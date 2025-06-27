trigger DataCopyConfigTrigger on RecordCopyConfig__c (before insert, before update) {
	new DataCopyConfigTriggerHelper().process();
}