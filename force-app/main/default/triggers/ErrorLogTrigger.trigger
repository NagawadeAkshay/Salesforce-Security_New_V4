/*
Trigger to set default recordtype.
    ***********************************************************
    Audit History
    ***********************************************************
    16/07/2018      Prajakta Gadhe            Created
    *********************************************************** 

*/

trigger ErrorLogTrigger on ErrorLog__c( before insert) {
      
      new ErrorLogTriggerHelper().process();
      
}