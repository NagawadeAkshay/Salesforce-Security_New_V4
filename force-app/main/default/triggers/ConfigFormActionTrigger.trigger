/**
 * Created by REI on 02-01-2020.
 */

trigger ConfigFormActionTrigger on CaptureAction__c (before insert, before update, after undelete) {
   TriggerHelper th = new TriggerHelper ();
    th.setInternalUniqueID(); 
   new ConfigFormActionTriggerHelper().process();
}