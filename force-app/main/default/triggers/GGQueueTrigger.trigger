/**
* This Trigger is used to populate GGQueue__c fields with salesforce queue.
* 
* CHANGE HISTORY
* =============================================================================
* Date          Name            Description
* 17/10/2018    Prajakta Gadhe      Created
* =============================================================================
*/

trigger GGQueueTrigger on GGQueue__c(before insert, before update) {
      new GGQueueTriggerHelper().process();
    //new GNT.TriggerHelper().process();
   }