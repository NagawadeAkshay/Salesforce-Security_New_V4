trigger CaptureItemTrigger on CaptureItem__c (before insert, before update, after undelete) {
   TriggerHelper th = new TriggerHelper ();
    th.setInternalUniqueID();
    if(Trigger.new != null){
         HideJsonValidationHelper.hideFieldValidation(Trigger.new);
    }
}