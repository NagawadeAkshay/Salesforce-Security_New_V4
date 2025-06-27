public with sharing class GGQueueTriggerHelper extends TriggerHelper{ 
  
    public override void processBeforeInsert(){
        updateQueueId(Trigger.new);
    } 
    public override void processBeforeUpdate() {
      updateQueueId(Trigger.new);  
    }
    
     public void updateQueueId(List<GGQueue__c> queueList) {
          Set <String> queueIdSet = new Set <String> ();
         for(GGQueue__c queue : queueList){
              queue.InternalUniqueID__c = queue.DeveloperName__c;
              queueIdSet.add(queue.DeveloperName__c);   
         
         }
         Map<String,String> queueIdMap = new Map<String,String>();
         
        List<Group> queueNameList = [SELECT Id, Type,DeveloperName FROM Group 
                                   WHERE Type = 'Queue' AND DeveloperName in :queueIdSet WITH USER_MODE];//CRUD/FLS False +ve As per business scenario we can't check for portal/external users
        for(Group queue : queueNameList){
             queueIdMap.put(queue.DeveloperName,queue.Id);   
        }
        
        for(GGQueue__c queue : queueList){
            queue.QueueId__c = queueIdMap.get(queue.DeveloperName__c);
        }
     
     }















}