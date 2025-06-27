/**
    **********************************************************************************************************************
    Audit History
    **********************************************************************************************************************
    2019-07-1        Amol Salve           Created

    **********************************************************************************************************************
    Purpose :triggre on WBSTaskSchedule.
    **********************************************************************************************************************  
*/ 
 trigger WbsTaskScheduleTrigger on WBSTaskSchedule__c(before insert, before update, after insert, after update, before delete, after delete , after undelete){
    
    if(Trigger.isAfter){
        if(Trigger.isInsert){
            WBSTaskScheduleTriggerHelper.afterInsertWbsTaskSchedule(Trigger.newMap);
        }
        else if(Trigger.isUpdate){
            WBSTaskScheduleTriggerHelper.afterUpdateWbsTaskSchedule(Trigger.newMap, Trigger.oldMap);
        }
		else if(Trigger.isdelete){
            WBSTaskScheduleTriggerHelper.afterdeleteWbsTaskSchedule(Trigger.oldMap);
        }
        else if(Trigger.isUndelete){
            WBSTaskScheduleTriggerHelper.afterUndeleteWbsTaskSchedule(Trigger.newMap);
        }
    }
    
    if(trigger.isBefore){
         if(Trigger.isInsert){
             WBSTaskScheduleTriggerHelper.beforeInsertWbsTaskSchedule(Trigger.new);
         }         
         else if(Trigger.isUpdate){
             WBSTaskScheduleTriggerHelper.beforeUpdateWbsTaskSchedule(Trigger.newMap, Trigger.oldMap);
         }
         else if(Trigger.isDelete){
             WBSTaskScheduleTriggerHelper.beforeDeleteWbsTaskSchedule(Trigger.oldMap);
         }
     }
 }