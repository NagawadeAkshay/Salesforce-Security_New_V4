trigger SampleObjectTrigger on SampleObject1__c (before insert, after insert, before update, after update, before delete, after delete) {
 	new SampleObjectTriggerHelper().process();
}