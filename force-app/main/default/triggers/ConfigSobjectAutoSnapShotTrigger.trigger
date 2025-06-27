trigger ConfigSobjectAutoSnapShotTrigger  on SObjectAutoSnapshot__c (before insert, before update, after undelete, after insert, after update, before delete){
      new SobjectAutoSnapShotTriggerHelper().process();
}