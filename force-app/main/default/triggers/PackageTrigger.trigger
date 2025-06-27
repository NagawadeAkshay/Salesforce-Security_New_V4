trigger PackageTrigger on Package__c (after delete, after insert, after update, 
before delete, before insert, before update) {
    new PackageTriggerHelper().process(); 
}