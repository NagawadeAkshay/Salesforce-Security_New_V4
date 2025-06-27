trigger EmailQueueTrigger on EmailQueue__c (before insert,before update) {
	new EmailQueueTriggerHelper().process();
}