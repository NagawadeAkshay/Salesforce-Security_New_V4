/*
Batch class to create task for delegated approver  
**********************************************************
Audit History

**********************************************************
2017-11-3      Prajakta Gadhe            Created 
**********************************************************  
*/

//This Batch will run on daily basis at 11 PM

global with sharing class DelegateApprovarTaskCreationBatch extends BatchApexHandler {
    //private String userId;
    //here we have two constructors. In parameterized constructor we pass list of users to get their delegate
    private  List<String> userIds;
    private Boolean processDelegateApprover;
    global DelegateApprovarTaskCreationBatch(List<String> userIds){//here we can pass all list of users
          this.userIds = userIds;
          processDelegateApprover = true;
    }
    global DelegateApprovarTaskCreationBatch(){
           processDelegateApprover = false;
    }

    global override String getQuery() { 
        String query;
        if(processDelegateApprover == true){
            String userIdsStr = '(';
            if(userIds.size() > 0){
                for(String uid: userIds){
                    userIdsStr += '\'' + String.escapeSingleQuotes(uid) + '\',';
                }
            }else{
                userIdsStr += '\'\'';
            }
            userIdsStr = userIdsStr.removeend(',') + ')';
            query = 'Select Id,DelegatedApproverId from User where Id IN '+ userIdsStr +' WITH USER_MODE';//here we get list of users with delegate for whom we need to create task
            //query = 'Select Id,DelegatedApproverId from User where Id = \'' + userId + '\'';//delagate from yesterday,today and tomorrow
        }else{
            query = 'Select Id,DelegatedApproverId from User where isActive= true and EnableDelegate__c =  true and (DelegateFrom__c = TODAY OR DelegateFrom__c = YESTERDAY OR DelegateFrom__c = TOMORROW) and DelegatedApproverId !=null  WITH USER_MODE';//delagate from yesterday,today and tomorrow
        }
        return query;
    }
    global override void execute(List<SObject> scope1){   
        try{
            processRecords(scope1);
        }catch(Exception e){
            CustomExceptions.logException(e, true, false);
        }        
    }  
    global override void finish(){

    }
    private void processRecords(List<User> UsersList) {
        List<String> originalUserIdList = new List<String>();
        Map<String, String> userToDelegateUserIdMap =  new  Map<String, String>() ;
        for(User usr : UsersList) {
            originalUserIdList.add(usr.id);
            userToDelegateUserIdMap.put(usr.id,usr.DelegatedApproverId);  
        }
        Map <String, Schema.SObjectField> fieldMap = Schema.getGlobalDescribe().get('Task').getDescribe().fields.getMap();// HERE all fields of task object are get to copy all data of original user to delegate user
        List<String> taskFieldList = new List<String>();
        for(String taskField : fieldMap.keyset()){
            if(fieldMap.get(taskField ).getDescribe().isUpdateable()){
                if((taskField.EndsWith('__c')&& taskField.StartsWith('gnt__')) || taskField.EndsWith('__c') == false) {
                    taskFieldList.add(taskField);
                }
            }
        }
        Set<String> taskFieldSet = new Set<String>();
        taskFieldSet.addAll(taskFieldList);

        List<String> taskFieldsList = new List<String>();
        taskFieldsList.addAll(taskFieldSet);
        String taskFields = String.join(taskFieldsList, ',');// comma separted task fields
        //String [] sobjectdataSeparatedList1 = taskFieldSet.split(',');
        String taskQuery = 'Select ' + string.escapeSingleQuotes(taskFields)  + ' From Task WHERE OwnerId IN :originalUserIdList And WorkitemId__c != null';
        List<task> originalUserTaskList =  Database.query(taskQuery, AccessLevel.USER_MODE); //SOQL Injection - False +ve - Dynamic part of query is escapeSingleQuotes/static bind
       // List<task> originalUserTaskList =[SELECT id,OwnerId,WhatId,ParentTask__c FROM Task ];
        List<String> delegateTaskIdList =  new List<String>();
        List<String> delegateUserIdList = new List<String>(); 
        for(Task ownerTask1 : originalUserTaskList) {
            delegateTaskIdList.add(ownerTask1.id);
            delegateUserIdList.add(userToDelegateUserIdMap.get(ownerTask1 .OwnerId)); 
        }
        List<task> delegateUserTasksList = [SELECT id,OwnerId,WhatId,ParentTask__c FROM Task WHERE ParentTask__c IN : delegateTaskIdList And OwnerId IN : delegateUserIdList WITH USER_MODE];//CRUD/FLS False +ve As per business scenario we can't check for portal/external users
        Set<String> parentIds =  new Set<String>();
        for(Task parentTask : delegateUserTasksList ){
            parentIds.add(parentTask.ParentTask__c );
        }
        List<Task> userTaskCloneList =  new list<Task>();
        for(Task ownerTask : originalUserTaskList) {
            Task cloneTask;
            if(!parentIds.contains(ownerTask.id)) { 
                cloneTask = ownerTask.clone();
                if(Schema.sObjectType.Task.fields.OwnerId.isCreateable()){
                    cloneTask.OwnerId = userToDelegateUserIdMap.get(ownerTask .OwnerId);
                }
                if(Schema.sObjectType.Task.fields.ParentTask__c.isCreateable()){
                    cloneTask.ParentTask__c = ownerTask.id;
                }
                userTaskCloneList.add(cloneTask);
            }
        }
        if(Schema.sObjectType.Task.isCreateable()){
            insert as user userTaskCloneList;
        }
    }
}