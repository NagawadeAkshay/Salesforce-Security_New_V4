/**
* This batch  will sync salesforce queues with GGQueue__c Object
* 
* CHANGE HISTORY
* =============================================================================
* Date          Name            Description
* 17/10/2018    Prajakta Gadhe      Created
* =============================================================================
*/

global with sharing class SyncQueueBatch  extends BatchApexHandler {

    global SyncQueueBatch(){}

    global override String getQuery() {
        return 'SELECT Id, Name,DeveloperName FROM Group WHERE Type = \'Queue\' WITH USER_MODE';
    }

    global override void execute(List<SObject> scope1){
        List<Group > scope = (List<Group >)scope1;
        List<GGQueue__c> queueList= new List<GGQueue__c >();
       for(Group grp: scope){
           queueList.add(
               new GGQueue__c(
                 Name =  grp.Name,
                 DeveloperName__c = grp.DeveloperName
               )
           );
       }
        if(Schema.sObjectType.GGQueue__c.isCreateable() && Schema.sObjectType.GGQueue__c.isUpdateable()){
       upsert queueList DeveloperName__c;
        }
    }
   
}