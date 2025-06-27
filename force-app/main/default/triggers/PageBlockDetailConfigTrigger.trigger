/*
   Trigger for PageBlockDetailConfig__c Object
  ***********************************************************
  Audit History
  ***********************************************************
  06/03/2014    Prem Pal             Created
  *********************************************************** 
*/
trigger PageBlockDetailConfigTrigger on PageBlockDetailConfig__c (after delete, after insert, after update, 
before delete, before insert, before update) {
  new PageBlockDetailConfigTriggerHelper().process();
}