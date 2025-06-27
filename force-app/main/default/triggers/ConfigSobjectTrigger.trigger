trigger ConfigSobjectTrigger on SobjectConfig__c  (before insert, before update, after undelete, after insert, after update, before delete) {
    new SobjectTriggerHelper().process();
   
}