/*
    Batch class to send the Task Reminder emails by fetching Task records.
    Batchsize should be 20 by assuming max 500 task per user. 
    **********************************************************
    Audit History
    
    **********************************************************
    2017-10-25        Shantanu Gadhe            Created 
    **********************************************************  
*/
global with sharing class TaskReminderJob extends BatchApexHandler {
    
    global override String getQuery() { 
        String query = 'Select Id,Name from User where isActive= true WITH USER_MODE';
        return query;
    }
    
    global override void execute(List<SObject> scope1){
        processRecords(scope1);        
    }
    
    private void processRecords(List<User> usersList){
        List<id> userIdList = new List<id>();      
        Map<String,EmailTemplate> taskTemplateMap = new Map<String,EmailTemplate>();
        Map<String,String> SObjectConfigMap = new Map<String,String>();
        String taskReminderType= KeyValueStoreHelper.getTextValue('TaskReminderType',true) != null ?KeyValueStoreHelper.getTextValue('TaskReminderType',true):'Mulitple';
        List<String> templateNames = new List<String>();
        if(KeyValueStoreHelper.getTextValue('TaskReminderTemplateMultiple',true) != null){
            templateNames.add(KeyValueStoreHelper.getTextValue('TaskReminderTemplateMultiple',true));
        }
        if(KeyValueStoreHelper.getTextValue('TaskReminderTemplateIndividual',true) != null){
            templateNames.add(KeyValueStoreHelper.getTextValue('TaskReminderTemplateIndividual',true));
        }
        List<Emailtemplate> taskTemplateList = [SELECT Subject,Body,HtmlValue,Name,DeveloperName,BrandTemplateId,TemplateType 
                                                from EmailTemplate where DeveloperName IN :templateNames WITH USER_MODE];//CRUD/FLS False +ve As per business scenario we can't check for portal/external users
        for(EmailTemplate taskTemplate : taskTemplateList){
            if(taskTemplate.DeveloperName == (KeyValueStoreHelper.getTextValue('TaskReminderTemplateIndividual',true))){
                taskTemplateMap.put('Individual',taskTemplate);
            }
            if(taskTemplate.DeveloperName == (KeyValueStoreHelper.getTextValue('TaskReminderTemplateMultiple',true))){
                taskTemplateMap.put('Multiple',taskTemplate);
            }    
        }
        for(User u : UsersList){
           userIdList.add(u.id);
        }
        List<Task> usersDueTaskList = getDueTasksOfUsers(userIdList);
        if(usersDueTaskList != null){
            Set<String> sObjectTypeSet = new Set<String>();
            if(usersDueTaskList != null){
                for(Task t : usersDueTaskList ){
                    if(t.whatId != null){
                        sObjectTypeSet.add(String.valueOf((t.whatId).getSobjectType()));
                    }
                }
            }
            SObjectConfigMap = getSObjectConfigMap(sObjectTypeSet);
            Map<Id,Set<Task>> userDueTaskMap = getUsersDueTaskMap(usersDueTaskList);
            Map<Id,Map<String,Set<Task>>> sortedUserDueTaskMap = new Map<Id,Map<String,Set<Task>>>(); 
            sortedUserDueTaskMap = getSortedUserDueTaskMap(userDueTaskMap,SObjectConfigMap );
            if(sortedUserDueTaskMap.size() != 0){
                if(taskReminderType == 'Multiple'){
                    sendSingleEmail(sortedUserDueTaskMap,taskTemplateMap);
                }
                if(taskReminderType == 'Individual'){
                    sendSeparateEmail(sortedUserDueTaskMap,taskTemplateMap);
                }
            }   
        }
    }     
    
    private Map<String,String> getSObjectConfigMap(Set<String> sObjectTypeSet){
        String sobjectTypes = '(\''+ String.join(new List<String>(sObjectTypeSet),'\',\'')+'\')'; 
        Map<String,String> SObjectConfigMap1 = new Map<String,String>();
        List<SobjectConfig__c> sObjectConfigList =new List<SobjectConfig__c>();
        if(Schema.sObjectType.SobjectConfig__c.isAccessible()){
        sObjectConfigList = [Select id,Name,ReminderDays__c from SobjectConfig__c 
                                                    where Name IN : new List<String>(sObjectTypeSet) WITH USER_MODE];
        }
        if(sObjectConfigList .size() != 0){
            for(SobjectConfig__c sObjectConfig:sObjectConfigList){
                if(sObjectconfig.ReminderDays__c != null){
                    SObjectConfigMap1.put(sObjectConfig.Name,sObjectconfig.ReminderDays__c);
                } 
            }
        }
     return SObjectConfigMap1;     
    }
    ///returns list of tasks related to Users
    private List<Task> getDueTasksOfUsers(List<id> userList){
        String usersIds = '(\''+ String.join(userList,'\',\'')+'\')';                                
        List<task> dueTasks = new List<Task>();
        dueTasks  =[SELECT id,OwnerId,ActivityDate,TaskAction__c,TaskConfig__r.ReminderDays__c,TaskConfig__r.SendIndividualTaskReminder__c,TaskConfig__r.TaskReminderTemplate__r.DeveloperName__c,
        WhatId  FROM Task WHERE (Status = 'Not Started' OR Status = 'In Progress') AND OwnerId IN : userList WITH USER_MODE];//CRUD/FLS False +ve As per business scenario we can't check for portal/external users
        if(dueTasks.size() == 0){
            return null;
        }else{
            return dueTasks;
        }
    }
    
    private Map<Id,Set<Task>> getUsersDueTaskMap(List<Task> usersDueTaskList){
        Map<Id,Set<Task>> userDueTaskMap = new Map<Id,Set<Task>>();
            for(Task task:usersDueTaskList){
                if(task.OwnerId != null){
                    if(userDueTaskMap.get(task.OwnerId) == null) {
                       userDueTaskMap.put(task.OwnerId,new Set<Task>());
                    }
                    userDueTaskMap.get(task.OwnerId).add(task);
                }
            }       

        return userDueTaskMap;          
    }
    
    private Map<Id,Map<String,Set<Task>>> getSortedUserDueTaskMap(Map<Id,Set<Task>> userDueTaskMap,Map<String,String> SObjectConfigMap){
        Map<Id,Map<String,Set<Task>>> sortedUserDueTaskMap = new Map<Id,Map<String,Set<Task>>>();
        for(Id userId:userDueTaskMap.KeySet()){
            Map<String,Set<Task>> duedaysTaskMap = new Map<String,Set<Task>>();
            duedaysTaskMap = getDuedaysTaskMap(userDueTaskMap.get(userId),SObjectConfigMap);
                if(duedaysTaskMap.size() != 0){
                    sortedUserDueTaskMap.put(userId,duedaysTaskMap);
            }           
        }
        return sortedUserDueTaskMap;
    }
    //Map of due Day and Set of Tasks on that Due day,use turnaryoperators
     private Map<String,Set<Task>> getDuedaysTaskMap(Set<task> tasks,Map<String,String> SObjectConfigMap){
        Map<String,Set<Task>> dueTasksMap = new Map<String,Set<Task>>();       
        String numberOfDays = KeyValueStoreHelper.getTextValue('TaskReminderNumberOfDays',true) != null?KeyValueStoreHelper.getTextValue('TaskReminderNumberOfDays',true):'7,15,30';            
        List<EmailFeeder> taskList = new List<EmailFeeder>();  
            for(Task task : tasks){
                if(task.whatId != null){
                    String SObjectType = String.valueOf((task.whatId).getSobjectType());
                    if(sObjectConfigMap.get(SObjectType) != null  ){ 
                        numberOfDays = sObjectConfigMap.get(SObjectType);
                    }
                    if(task.TaskConfig__r.ReminderDays__c != null){
                        numberOfDays = (task.TaskConfig__r.ReminderDays__c);
                    }
                    boolean isDue = validateTask(numberOfDays,task);
                    if(task.TaskConfig__r.SendIndividualTaskReminder__c ==true && isDue == true){
                        String template = task.TaskConfig__r.TaskReminderTemplate__r.DeveloperName__c != null ? task.TaskConfig__r.TaskReminderTemplate__r.DeveloperName__c:KeyValueStoreHelper.getTextValue('TaskReminderTemplateIndividual',true);
                        taskList.add(new EmailFeeder().targetObjectId(task.OwnerId).template(template).contextRecordId(task.id));
                        continue;
                    }
                } 
                for(String day : validateTaskDates(numberOfDays, task).KeySet()){
                    if(dueTasksMap.get(day) == null) {
                       dueTasksMap.put(day, new Set<Task>());
                    }
                dueTasksMap.get(day).add(task);
                }
            }
        EmailFeeder.sendEmails(tasklist);
        return dueTasksMap;  
    }
    
    private Map<String,Task> validateTaskDates(String numberOfDays, Task task){
        Map<String, Task> validatedTaskMap = new Map<String, Task>();
        Set<String> dueDaySet = new Set<String>();
        dueDaySet.addAll(numberOfDays.split(','));
        for(String day:dueDaySet){ //what about todays task-
            if(task.ActivityDate == Date.Today().addDays(Integer.valueOf(day))){
                validatedTaskMap.put(day,task);    
            }
        }
        return validatedTaskMap;  
    } 
    
    private void sendSingleEmail(Map<Id,Map<String,Set<Task>>> sortedUserDueTaskMap,Map<String,EmailTemplate> taskTemplateMap){
        List<EmailFeeder> emailFeederList = new List<EmailFeeder>();
        EmailTemplate emailTemplate = taskTemplateMap.get('Multiple');
        String pastData = '';
        String futureData = '';
        for(id userId:sortedUserDueTaskMap.KeySet()){
            String template = emailTemplate.HtmlValue;
            Map<String,Set<Task>> dueDaystaskMap = sortedUserDueTaskMap.get(userId);
            Map<String,Integer> taskCountByDueDaysMap = new Map<String,Integer>();
            boolean containPastDues = false;
            boolean containFutureDues = false;      
        for (String days:dueDaystaskMap.KeySet()){
                Set<Task> taskSet = dueDaystaskMap.get(days);
                taskCountByDueDaysMap.put(days,taskSet.size());
                if(days.contains('-')){ 
                    containPastDues = true;        
                    pastData = pastData +'<li>'+  String.format(System.Label.TaskReminderPastDue, new List<String>{ days.replace('-',''),String.valueOf(taskset.size()) })+'</li>';                
                }else{
                    containFutureDues = true;
                    futureData = futureData+'<li>' +  String.format(System.Label.TaskReminderfutureDue, new List<String>{days,String.valueOf(taskset.size())})+'</li>'; 
                }                                        
            }                      
            if(containPastDues){                
                pastData  = '<ul>'+pastData+'</ul>';
                template = template.replace('{Past_N_Days_Header}',System.Label.TaskReminderPastDueHeader);
                template = template.replace('{Past_N_Days}',pastData);
            }else{
                template = template.replace('{Past_N_Days_Header}','');
                template = template.replace('{Past_N_Days}','');
            }
            if(containFutureDues){
                futureData = '<ul>'+futuredata+'</ul>';
                template = template.replace('{Future_N_Days_Header}',System.Label.TaskReminderFutureDueHeader);
                template = template.replace('{Future_N_Days}',futureData); 
            }else{
                template = template.replace('{Future_N_Days_Header}','');
                template = template.replace('{Future_N_Days}',''); 
            }                            
        EmailFeeder ef = new EmailFeeder();
        ef.TargetObjectId(userId);
        ef.subject(emailTemplate.Subject);
        ef.htmlBody(template);
        emailFeederList.add(ef);
        } 
        EmailFeeder.sendEmails(emailFeederList);   
    }
    
   private void sendSeparateEmail(Map<Id,Map<String,Set<Task>>> sortedUserDueTaskMap, Map<String,EmailTemplate> taskTemplateMap){   
        List<EmailFeeder> emailFeederList = new List<EmailFeeder>();        
        EmailTemplate emailTemplate = taskTemplateMap.get('Individual');     
        for(id userId:sortedUserDueTaskMap.KeySet()){
            Map<String,Set<Task>> dueDaystaskMap = sortedUserDueTaskMap.get(userId);
            Map<String,Integer> taskCountByDueDaysMap = new Map<String,Integer>(); 
        String body = '';       
        for (String days:dueDaystaskMap.KeySet()){
            Set<task> taskSet = dueDaystaskMap.get(days);
            for(Task dueTask:taskSet){
                EmailFeeder ef = new EmailFeeder();
                ef.TargetObjectId(dueTask.OwnerId);
                ef.template(emailTemplate.DeveloperName);
                ef.contextRecordId(dueTask.id);
                emailFeederList.add(ef);
            }             
         }                   
      
        } 
        EmailFeeder.sendEmails(emailFeederList);   
   }
   
   private boolean validateTask(String numberOfDays, Task task){
        List<String> daysList = new List<String>();
        daysList = numberOfDays.split(',');
        boolean isDue = false;
        for(String day:daysList){
            if(task.Activitydate == Date.Today().addDays(Integer.valueOf(day))){
                isDue = true;
            }           
        }
        return isDue;
   }      
   
  }