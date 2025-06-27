public with sharing class ApexJobTriggerHelper extends TriggerHelper{
    public override void processBeforeUpdate() {
        for(ApexJob__c  record : (List<ApexJob__c>)Trigger.New){
            if(Trigger.isUpdate){
                ApexJob__c oldRecord = (ApexJob__c)Trigger.OldMap.get(record.Id);
                 if (oldRecord.Status__c != record.Status__c && record.Status__c == 'Queued') {
                  record.LastQueuedOn__c = System.now();
                }
                if (oldRecord.Status__c != record.Status__c && record.Status__c == 'Started') {
                  record.LastRunStartedOn__c = System.now();
                }
                if (oldRecord.Status__c != record.Status__c && record.Status__c == 'Completed') {
                  record.LastRunEndedOn__c = System.now();
                }
            }  
          }
    }
}