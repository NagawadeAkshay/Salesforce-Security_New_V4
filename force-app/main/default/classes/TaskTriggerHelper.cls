public with sharing class TaskTriggerHelper extends TriggerHelper{       
    public static Boolean skipTrigger = false;
    private static Map<String, TaskConfig__c> taskConfigByAction;
    
    public static List<TaskConfig__c> getTaskConfigByApprovalNameAndStep(String approvalProcessName, String approvalStepName) {
        if(taskConfigByAction == null) {
            taskConfigByAction = new Map<String, TaskConfig__c>();
        }
        if (Schema.sObjectType.TaskConfig__c.isAccessible()) {
            List<TaskConfig__c> taskConfigs = [select PhaseConfig__c,TaskAction__c from TaskConfig__c 
                                            where ApprovalDefinitionName__c =:approvalProcessName 
                                            and ApprovalStepName__c = :approvalStepName WITH USER_MODE]; 
            for(TaskConfig__c tasCnfg : taskConfigs) {
                taskConfigByAction.put(tasCnfg.TaskAction__c, tasCnfg);
            }
        }
        return taskConfigByAction.values();
    }
    
    private static List<TaskConfig__c> getTaskConfig(List<String> taskActions) {
        if(taskConfigByAction == null) {
            taskConfigByAction = new Map<String, TaskConfig__c>();
        }
        List<String> tasks = new List<String>();
        for(String action : taskActions) {
            if(!taskConfigByAction.containsKey(action)) {
                tasks.add(action);
            }
        }
        if(tasks.size() > 0) {
            if (Schema.sObjectType.TaskConfig__c.isAccessible()) {
                List<TaskConfig__c> taskConfigs = [select PhaseConfig__c,TaskAction__c from TaskConfig__c where 
                            TaskAction__c in :tasks WITH USER_MODE]; 
                for(TaskConfig__c tasCnfg : taskConfigs) {
                    taskConfigByAction.put(tasCnfg.TaskAction__c, tasCnfg);
                }
            }
        }
        return taskConfigByAction.values();
    }
    
    public override void processBeforeInsert(){
        if(!skipTrigger) {
            populateActivityDuplicateDate(Trigger.new);            
            updatePhaseName(Trigger.new);
            handleSalesforceInbox(Trigger.new);
        }
    }

    public override void processBeforeUpdate(){
        populateActivityDuplicateDate(Trigger.new);
        closeRelatedTasks();
    }
    public override void processAfterInsert(){
        sendEmailNotification(Trigger.new);
    }
    
    public static boolean skipCloseTaskMethod = false;
    

    private void closeRelatedTasks(){
        if(!TaskTriggerHelper.skipCloseTaskMethod){
            // Code Bulkification...
            Set<Id> tskIdSet = new Set<Id>();
            Set<Id> tskWhatIdSet = new Set<Id>();
            Set<String> tskGroupIdSet = new Set<String>();
            Set<String> tskActionSet = new Set<String>();
            List<Task> tskList = (List<Task>) Trigger.new; 
            for(Task tkVal:tskList){
                Task tskOldVal = (Task)trigger.oldMap.get(tkVal.Id);
                //if(tsk.status == 'Completed' && tskOld.Status == 'In Progress'){ // changed entry criteria to below, as part of ticket 44649
                if(tkVal.status == 'Completed' && tskOldVal.Status != 'Completed'){
                    tskIdSet.add(tkVal.Id);
                    tskWhatIdSet.add(tkVal.WhatId);
                    tskGroupIdSet.add(tkVal.GroupId__c);
                    tskActionSet.add(tkVal.TaskAction__c);
                }
            }   //CRUD/FLS False +ve As per business scenario we can't check for portal/external users
                List<task> taskList = [Select id, Status from Task Where 
                    WhatId IN :tskWhatIdSet AND Status != 'Completed' AND AssignedToQueue__c = true 
                        AND GroupId__c IN :tskGroupIdSet AND ID NOT IN :tskIdSet AND TaskAction__c IN :tskActionSet WITH USER_MODE];//CRUD/FLS False +ve As per business scenario we can't check for portal/external users
                for(Task t : taskList){
                    t.Status = 'Completed';
                }
                TaskTriggerHelper.skipCloseTaskMethod = true;
                SystemContextMethodsHelper sc = new SystemContextMethodsHelper();
                sc.updateTasks(taskList);
            //}
        }
    }
    
    public void populateActivityDuplicateDate(List<Task> taskList){
        for(Task taskInstance : taskList){
            taskInstance.ActivityDuplicateDate__c = taskInstance.ActivityDate;  
        }       
    }
    
    public void updatePhaseName(List<Task> taskList) {
       
        List<String> taskActions = new List<String>();
        Set<Id> phases = new Set<Id>();
        Map<String,List<Id>> actionPhaseMap = new Map<String,List<Id>>();
       
        for(Task t: taskList) {
            if(t.TaskAction__c != null) {
                taskActions.add(t.TaskAction__c);
            }
            
        }
        List<TaskConfig__c> taskConfig = getTaskConfig(taskActions); 
        for(TaskConfig__c config : taskConfig){
            List<Id> phaseIds = actionPhaseMap.get(config.TaskAction__c);
            if(phaseIds == null){
                phaseIds = new List<Id>();
            }
            phaseIds.add(config.PhaseConfig__c);
            actionPhaseMap.put(config.TaskAction__c,phaseIds);
            phases.add(config.PhaseConfig__c);
        }
        Map<Id,PhaseConfig__c> phaseMap = new Map<Id,PhaseConfig__c>();
        if(Schema.sObjectType.PhaseConfig__c.isAccessible()) {
            phaseMap = new Map<Id,PhaseConfig__c>([select CustomAppName__c,id,name 
                                                                    from PhaseConfig__c where id in:phases WITH USER_MODE]);
        }
        for(Task task: taskList){
            if(taskConfigByAction.get(task.TaskAction__c) != null) {
                task.TaskConfig__c = taskConfigByAction.get(task.TaskAction__c).Id;
            }
            List<Id> pIds = actionPhaseMap.get(task.TaskAction__c);
            if(pIds!=null){
                for(Id pId : pIds){
                    PhaseConfig__c phase = phaseMap.get(pId);
                    if(phase != null) {
                        task.PhaseName__c = phase.name;
                        task.CustomAppName__c = phase.CustomAppName__c;
                    }
                }
            } 
        }

    } 
    /*method to send the email Notification to Owner of the Task whenever the Task is inserted
    Only if Email Template and SendNotification is configured in Related Taskconfig. 
    */
    private void  sendEmailNotification(List<Task> taskList){
        List<String> taskConfigIdList = new List<String>();
        List<TaskConfig__c> taskConfigList = new List<Taskconfig__c>();
        List<EmailFeeder> emailFeederList = new List<EmailFeeder>();
        //Map of Taskconfig id and related Email Template DeveloperName
        Map<String,String> taskConfigMap = new Map<String,String>();
        for (Task task :taskList){
            if(task.TaskConfig__c!= null) {
                taskConfigIdList.add(task.TaskConfig__c);
            }       
        }
        if(Schema.sObjectType.Taskconfig__c.isAccessible()) {
        taskConfigList = [SELECT id,Name,EmailTemplateConfig__r.DeveloperName__c,SendTaskAssignmentNotification__c 
                        from Taskconfig__c where id IN:taskConfigIdList WITH USER_MODE];
        }
        for(Taskconfig__c taskConfig:taskconfigList){
            if(taskconfig.EmailTemplateConfig__c != null && taskConfig.SendTaskAssignmentNotification__c == true){
                taskConfigMap.put(taskConfig.id,taskconfig.EmailTemplateConfig__r.DeveloperName__c);
            }
        }
        for(Task task:taskList){
            if(task.TaskConfig__c != null ){               
                if(taskConfigMap.get(task.TaskConfig__c ) != null){
                    EmailFeeder emailFeeder = new EmailFeeder().template(taskConfigMap.get(task.TaskConfig__c)).contextRecordId(task.whatId).TargetObjectId(task.ownerId);
                    emailFeederList.add(emailFeeder); 
                }              
            }
        }
        EmailFeeder.sendEmails(emailFeederList);                 
    }


    private void handleSalesforceInbox(List<Task> taskList) {
        List<Task> toParseList= new List<Task>();
        
        for(Task newTask:taskList) {
            if(newTask.Type=='Email' && newTask.FromAddress__c==null && newTask.ToAddress__c==null 
                && newTask.EmailSubject__c==null) {
                toParseList.add(newTask);
            }
        }
        
        if(toParseList.size()!= 0) {
            for(Task newTask:toParseList) {
                String valueToAssign;
                String Description =newTask.Description;
                if(String.isNotEmpty(Description)) {
                    valueToAssign = Description.substringBetween('From:','To:'); 
                    newTask.FromAddress__c=valueToAssign;

                    valueToAssign = Description.substringBetween('To:','Cc:'); 
                    newTask.ToAddress__c=valueToAssign;

                    valueToAssign = Description.substringBetween('Cc:','Bcc:'); 
                    newTask.CCAddress__c = valueToAssign;

                    valueToAssign = Description.substringBetween('Subject:','Body:'); 
                    newTask.EmailSubject__c=valueToAssign;
                    
                }
            }
        }
    }   
}