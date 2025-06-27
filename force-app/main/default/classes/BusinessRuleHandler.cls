/*
  Extend this class to provide custom business rule/validation logic for 
  your functionality. The extended class can be developed directly
  in the client org. The extended class must be registered in 
  BusinessRuleConfig__c custom setting.

  **********************************************************
  Audit History
  **********************************************************
  2014-10-25  Shah Kadirmohideen            Created
  **********************************************************  
*/
global abstract with sharing class BusinessRuleHandler {

  global Object contextData;

    public void createBusinessRule(SObject recordObj){

      execute(recordObj);
    }
  
    //returns true if no errors are found
    global abstract BusinessRuleResult execute(SObject record);
   
}