/*Tejashree D - Adding with sharing for SF review after analysis */
global with sharing class TaskCreationHandler{
    
    private static  List<TaskConfig__c> taskConfig;
    public static Map<String,List<TaskConfig__c>> taskActionConfigMap = new Map<String,List<TaskConfig__c>>();
    private static BusinessHours bh;
    
    static{
        if (Schema.sObjectType.BusinessHours.fields.IsDefault.isAccessible()){
            bh = [SELECT Id FROM BusinessHours WHERE IsDefault = true];//CRUD/FLS False +ve As per business scenario we can't check for portal/external users
        }
    }
    
    global with sharing class TaskBulkClass{
        global Id ownerUserId {get;set;}
        global Id recordId {get;set;}
        global String action {get;set;}
        global String recordName {get;set;}
        global String groupName {get;set;} //Optional
        global Date dueDate {get;set;} //Optional
        global Date startDate {get;set;} //Optional
        global boolean taskCompleted {get;set;} //Optional
        global String comments {get;set;} //Optional
        global String taskType {get;set;} //Optional
        global String taskScheduleDetailId {get;set;} //Optional
        global String subject {get;set;} //Optional
    }

    /*
        Bulkified create tasks
    */
    global static List<Task> createBulkTasks(List<TaskBulkClass> bulkList, boolean create){
        //Contains Group Name as key and List of Group Members as Values 
        Map<String, Set<GroupMember>> groupNameMemberMap = new Map<String, Set<GroupMember>>();
        Set<String> queueNames = new Set<String>();
        List<String> taskAction = new List<String> ();
        Boolean isQueueAssigned = false;
        for(TaskBulkClass bulkInstance : bulkList){
            if(!String.isEmpty(bulkInstance.groupName)){
                queueNames.add(bulkInstance.groupName);
                isQueueAssigned = true;
            }
            taskAction.add(bulkInstance.action);
        }
        if(isQueueAssigned){
                List<GroupMember> groupMembers = [SELECT Id, GroupId, UserOrGroupId, Group.DeveloperName 
                                                FROM GroupMember
                                                where Group.type='Queue' and Group.DeveloperName in :queueNames 
                                                WITH USER_MODE]; //CRUD/FLS False +ve As per business scenario we can't check for portal/external users
            for(GroupMember memberInstance : groupMembers){
                if(groupNameMemberMap.get(memberInstance.Group.DeveloperName) != null){
                    Set<GroupMember> memberList = groupNameMemberMap.get(memberInstance.Group.DeveloperName);
                    memberList.add(memberInstance);
                }
                else{
                    Set<GroupMember> memberList = new Set<GroupMember> (); 
                    memberList.add(memberInstance);
                    groupNameMemberMap.put(memberInstance.Group.DeveloperName, memberList);
                }
            }
        }
        taskConfig = TaskCreationHandler.getTaskConfig(taskAction, 'MyTasks');
        if(taskConfig!= null){
            for(TaskConfig__c config : taskConfig){
                List<TaskConfig__c> taskConfigs = taskActionConfigMap.get(config.TaskAction__c);
                if(taskConfigs == null){
                    taskConfigs= new List<TaskConfig__c>(); 
                }
                taskConfigs.add(config);
                taskActionConfigMap.put(config.TaskAction__c,taskConfigs);
            }   
        }

        Set<Id> activeUsers = getActiveUsers(bulkList, groupNameMemberMap);
        List<Task> taskList = initializeBulkTasks(bulkList, groupNameMemberMap, activeUsers);
        if(create == true){
            if(Schema.sObjectType.Task.isCreateable()){
                insert as user taskList;
            }
        }
        return taskList;
    }

    private static Set<Id> getActiveUsers(List<TaskBulkClass> taskBulkList, Map<String, Set<GroupMember>> groupNameMemberMap) {
        Set<Id> activeUsers = new Set<Id>();
        for(TaskBulkClass bulkInstance1 : taskBulkList){
            if(bulkInstance1.groupName != null){
                Set<GroupMember> groupsGroupMembers = groupNameMemberMap.get(bulkInstance1.groupName);
                for(GroupMember grpMember1 : groupsGroupMembers){
                    activeUsers.add(grpMember1.UserOrGroupId);
                }
            }
        }
        if (Schema.sObjectType.User.fields.Name.isAccessible()){
            List<User> userList = [Select id,name from user where id in :activeUsers and IsActive = true WITH USER_MODE]; //CRUD/FLS False +ve As per business scenario we can't check for portal/external users
        activeUsers = new Set<Id>();
        for(User u : userList){
            activeUsers.add(u.id);

        }
        return activeUsers;
    }
        return null;
    }

    private static List<Task> initializeBulkTasks(List<TaskBulkClass> taskBulkList, Map<String, Set<GroupMember>> groupNameMemberMap, Set<Id> activeUsers) {
        List<Task> taskList = new List<Task>();
        List<ID> recordList = new List<ID>();
        String objectType ='';
        String actionName ='';
        List<String> mergeFieldsList = new List<String>();
        List<String> mergeFieldsList2 = new List<String>();
        Set<String> mergeFields = new Set<String>();
        String s = '';
        for(TaskBulkClass bulkInstance : taskBulkList){
            recordList.add(String.escapeSingleQuotes(bulkInstance.recordId));
        }

        if(!taskBulkList.isEmpty() && taskBulkList[0].action != null ){ 
            actionName = taskBulkList[0].action ;  
            objectType = String.valueOf(taskBulkList[0].recordId.getSobjectType());
        }
       
        List<TaskConfig__c> TaskConfigList = taskActionConfigMap.get(actionName);
        if(TaskConfigList != null && !TaskConfigList.isEmpty() && TaskConfigList[0].OrganizationNameOfRecord__c != null ){ 
            mergeFieldsList = AppUtils.getMergeFields(TaskConfigList[0].OrganizationNameOfRecord__c);
        }
        if(TaskConfigList != null && !TaskConfigList.isEmpty() && TaskConfigList[0].Subject__c != null ){ 
            mergeFieldsList2 = AppUtils.getMergeFields(TaskConfigList[0].Subject__c); 
        }
        mergeFields.addAll(mergeFieldsList);
        mergeFields.addAll(mergeFieldsList2);
        mergeFieldsList = new List<String>();
        mergeFieldsList.addAll(mergeFields);
        Set<ID> keys = new Set<ID>();
        Keys.addAll(recordList);
        String query = '';
        if(!mergeFieldsList.isEmpty()){
             query = 'select ' + String.escapeSingleQuotes(String.join(mergeFieldsList, ', ')) + ' from ' + String.escapeSingleQuotes(objectType) + ' where IsDeleted = false AND id IN :Keys';
        }else{
            query = 'select Id from ' + String.escapeSingleQuotes(objectType) + ' where IsDeleted = false AND id IN :Keys';
        }
        //CRUD/FLS False +ve As per business scenario we can't check for portal/external users
        List<Sobject> sobjRec = Database.query(String.escapeSingleQuotes(query),AccessLevel.USER_MODE); //SOQL Injection - False +ve - Dynamic part of query string is escapeSingleQuotes
        Map<Id, Sobject> RecordsOfObject = new Map<Id, Sobject>(sobjRec);

        for(TaskBulkClass bulkInstance : taskBulkList) {
            Task taskInstance = new Task();
            if (Schema.sObjectType.Account.isAccessible() && Schema.sObjectType.TaskConfig__c.fields.OrganizationNameOfRecord__c.isAccessible() &&
            Schema.sObjectType.TaskConfig__c.fields.TaskAction__c.isAccessible()){
            List<TaskConfig__c> tskConfigList = [SELECT id,OrganizationNameOfRecord__c from TaskConfig__c 
                                                where TaskAction__c =: bulkInstance.action WITH USER_MODE];
                if(tskConfigList[0].OrganizationNameOfRecord__c != null && Schema.sObjectType.Task.fields.OrganizationName__c.isCreateable()){ 
                    taskInstance.OrganizationName__c = AppUtils.replaceMergeFields(tskConfigList[0].OrganizationNameOfRecord__c ,bulkInstance.recordId); 
                }
            }
                //WhatId bulkInstance.recordId, bulkInstance.action, bulkInstance.recordName, bulkInstance.taskCompleted, bulkInstance.dueDate
            //if(Schema.sObjectType.Task.fields.WhatId.isCreateable()){
                taskInstance.WhatId = bulkInstance.recordId;//B29u07g05 - False +ve ID field removed check it was failing for guest user
            //}
            //Action
            if(Schema.sObjectType.Task.fields.TaskAction__c.isCreateable()){
                taskInstance.TaskAction__c = bulkInstance.action;
            }
            //Name of Record
            if(String.isEmpty(bulkInstance.recordName) != true){
                if(Schema.sObjectType.Task.fields.ObjectRelationName__c.isCreateable()){
                    taskInstance.ObjectRelationName__c = bulkInstance.recordName;
                }
            }

            //Task Status
            //if(Schema.sObjectType.Task.fields.Status.isCreateable()){ // CRUD/FLS False Positive as per our business scenario we have have to update the standard fields for all profiles
                if(bulkInstance.taskCompleted == true){
                    taskInstance.Status = 'Completed';// CRUD/FLS False Positive
                }
                else{
                    taskInstance.Status = 'Not Started';// CRUD/FLS False Positive
                }
            //}

            if(bulkInstance.startDate != null){
                if(Schema.sObjectType.Task.fields.StartDate__c.isCreateable()){
                    taskInstance.StartDate__c = bulkInstance.startDate;
                }
            }
            if(String.isEmpty(bulkInstance.taskType) != true){
                if(Schema.sObjectType.Task.fields.Type__c.isCreateable()){
                    taskInstance.Type__c = bulkInstance.taskType;
                }
            }
            if(String.isEmpty(bulkInstance.comments) != true){
                if(Schema.sObjectType.Task.fields.description.isCreateable()){
                    taskInstance.description = bulkInstance.comments;
                }
            }
            if(!String.isEmpty(bulkInstance.taskScheduleDetailId)){
                if(Schema.sObjectType.Task.fields.TaskScheduleDetailId__c.isCreateable()){
                    taskInstance.TaskScheduleDetailId__c = bulkInstance.taskScheduleDetailId;
                }
            }
            /*
            if(!String.isEmpty(bulkInstance.subject)){
               taskInstance.subject = truncateSubject(bulkInstance.subject);
            }*/
            
            // 65553 : Bulk Task Creation is not pulling subject from Task config
            // Bug 123107: LSC - Bug : Subject for Bulk task creation is populating null value. If we remove the field, TaskCreationHandler gives attempt to dereference null error
            if(bulkInstance.recordId != null){
                if(String.isNotBlank(bulkInstance.subject)){
                    taskInstance.subject = truncateSubject(AppUtils.replaceMergeFields(bulkInstance.subject,RecordsOfObject.get(bulkInstance.recordId)));
                }else if(taskActionConfigMap.size() > 0 && String.isNotBlank(taskActionConfigMap.get(bulkInstance.action)[0].Subject__c)){
                    taskInstance.subject = truncateSubject(AppUtils.replaceMergeFields(taskActionConfigMap.get(bulkInstance.action)[0].Subject__c,RecordsOfObject.get(bulkInstance.recordId)));
                }
            }

            if(String.isEmpty(bulkInstance.groupName)){
                taskInstance.OwnerId = bulkInstance.ownerUserId; // CRUD/FLS False Positive: Id field 
                copyTaskConfig(taskInstance, bulkInstance.ownerUserId, bulkInstance.action, bulkInstance.dueDate);
            } else {
                Set<GroupMember> groupsGroupMembers = groupNameMemberMap.get(bulkInstance.groupName);
                for(GroupMember grpMember : groupsGroupMembers){
                    Task taskInstanceCloned = taskInstance.clone();
                    taskInstanceCloned.OwnerId = grpMember.UserOrGroupId;  // CRUD/FLS False Positive: Id field 
                    if(Schema.sObjectType.Task.fields.GroupName__c.isCreateable()){
                        taskInstanceCloned.GroupName__c = grpMember.Group.DeveloperName;
                    }
                    if(Schema.sObjectType.Task.fields.GroupId__c.isCreateable()){
                        taskInstanceCloned.GroupId__c = grpMember.GroupId;
                    }
                    copyTaskConfig(taskInstanceCloned ,grpMember.UserOrGroupId, bulkInstance.action, bulkInstance.dueDate);
                    if(activeUsers.contains(grpMember.UserOrGroupId)){
                        taskList.add(taskInstanceCloned);
                    }
                }
            }
            taskList.add(taskInstance);
        }

        // Assume source object on all records will be of same type i.e. we will create bulk task for same type of object
        dataCopyIntoTasks(taskList);

        return taskList;
    }

    /* method copies data from Source object to task */
    private static void dataCopyIntoTasks(List<Task> targetSobjectList) {
        Map<Id, List<SObject>> taskByParentId = new Map<Id, List<SObject>>();
        for(Task task : targetSobjectList) {
            if(taskByParentId.containsKey(task.WhatId) == false) {
                taskByParentId.put(task.WhatId, new List<SObject>());
            }
            taskByParentId.get(task.WhatId).add(task);
        }
        String objectName = Id.valueOf(targetSobjectList.get(0).WhatId).getSObjectType().getDescribe().getName();
    }


    /*
        Use this method to create a task when no Approval Process is involved
       1  ownerUserId(Required) - The owner of the Task
       2  recordId(Required) - The record Id to which the task is associated (whatId)
       3  action(Required) - The Action Name as defined by Task Action Summary Config Custom Setting
       4  recordName(Required) - Name of Record which shows on Task Count Summary
       5  groupName(Optional) - The Developer Name of group, if the task needs to be assigned to the members of the group
       6  taskCompleted(Required) - When set to true - Status of task is set to "Completed" else is set to "Not Started"
       7  dueDate(Optional) - If set to null, Due Date is grabbed from Task Action Summary Config Custom Setting for the associated action else is set to the passed Due Date
       8  taskType(Required) - Type of Task. Posssible values defined by the type picklist field on Task. Values include Call, Meeting, etc
       9  create(Required) - Creates the list of Tasks if set to true else returns the list without insert
    */
    
    global static List<Task> createTasks(Id ownerUserId, Id recordId, String action, String recordName, String groupName, Boolean taskCompleted, Date dueDate, String taskType, boolean create){
        return createTasks(ownerUserId, recordId, action, recordName, groupName, taskCompleted, dueDate, taskType, null, create);
    }
    global static List<Task> createTasks(Id ownerUserId, Id recordId, String action, String recordName, String groupName, Boolean taskCompleted, Date dueDate, String taskType, String subject, boolean create){
        return createTasks( ownerUserId, recordId, action, recordName, groupName, taskCompleted, dueDate, taskType, subject, true, create);
    }
    global static List<Task> createTasks(Id ownerUserId, Id recordId, String action, String recordName, String groupName, Boolean taskCompleted, Date dueDate, String taskType, String subject, Boolean associateWithApproval, boolean create){
        if(String.isEmpty(groupName) && ownerUserId == null){
            return null;
        }

        if(String.isEmpty(action)){
            return null;
        }
         List<String> taskAction = new List<String> ();
         taskAction.add(action);
         taskConfig = TaskCreationHandler.getTaskConfig(taskAction);
         String isAssociatedWithApproval;
         if(taskConfig!= null){
            for(TaskConfig__c config : taskConfig){
                isAssociatedWithApproval = config.IsAssociatedwithApproval__c;
                List<TaskConfig__c> taskConfigs = taskActionConfigMap.get(config.TaskAction__c);
                if(taskConfigs == null){
                    taskConfigs= new List<TaskConfig__c>(); 
                }
                taskConfigs.add(config);
                taskActionConfigMap.put(config.TaskAction__c,taskConfigs);
            }   
            if(String.isEmpty(subject) && taskConfig.size() > 0 ) {
                //subject = truncateSubject(taskConfig.get(0).Subject__c) ;
                subject = truncateSubject(AppUtils.replaceMergeFields(taskConfig.get(0).Subject__c,recordId));
            } 
        }

        List<Task> taskList = new List<Task>();
        Task taskInstance = initializeTask(ownerUserId,recordId, action, recordName, taskCompleted, dueDate);
        if((isAssociatedWithApproval == 'Null' || isAssociatedWithApproval == 'Yes' || isAssociatedWithApproval == null) && associateWithApproval == true){
                List<ProcessInstanceWorkitem> workItemList = [SELECT id, Actor.Type, ActorId 
                                                    FROM ProcessInstanceWorkitem 
                                                    WHERE ProcessInstance.TargetObjectId = :recordId 
                                                    LIMIT 1];  //NOPMD CRUD/FLS False +ve As per business scenario we can't check for portal/external users
                if(workItemList.size() > 0 && Schema.sObjectType.Task.fields.workItemId__c.isCreateable()){
                    taskInstance.workItemId__c = workItemList.get(0).Id;
                }
                if(String.isEmpty(taskType) != true && Schema.sObjectType.Task.fields.Type.isCreateable()){
                    taskInstance.Type = taskType;
                }     
        }       
        subject = AppUtils.replaceMergeFields(subject,recordId);
        //if(Schema.sObjectType.Task.fields.Subject.isCreateable()){
                        taskInstance.Subject = truncateSubject(subject);//CRUD/FLS False Positive:
        //}
       
        if(String.isEmpty(groupName)){
                          taskInstance.OwnerId = ownerUserId; // CRUD/FLS False Positive: Id field 
            copyTaskConfig(taskInstance,ownerUserId,action, dueDate);
            taskList.add(taskInstance);
        }
        else{
            taskList = initializeGroupTasks(groupName, taskInstance,action,dueDate, null, false);
        }

                    if(create == true && Schema.sObjectType.Task.isCreateable()){
                insert as user taskList;
            }
        return taskList;
    }
       


    /*
        Method created for enhancment in createTask method
    */
    global static List<Task> createTasksEnhanced(Id ownerUserId, SObject record, String action, String recordName, String groupName, Boolean taskCompleted, Date dueDate, String taskType, String subject, Boolean associateWithApproval, boolean create){
      if(String.isEmpty(groupName) && ownerUserId == null && record == null){
          return null;
      }

      if(String.isEmpty(action)){
          return null;
      }
       List<String> taskAction = new List<String> ();
       taskAction.add(action);
       taskConfig = TaskCreationHandler.getTaskConfig(taskAction);
       String isAssociatedWithApproval;
       if(taskConfig!= null){
          for(TaskConfig__c config : taskConfig){
              isAssociatedWithApproval = config.IsAssociatedwithApproval__c;
              List<TaskConfig__c> taskConfigs = taskActionConfigMap.get(config.TaskAction__c);
              if(taskConfigs == null){
                  taskConfigs= new List<TaskConfig__c>(); 
              }
              taskConfigs.add(config);
              taskActionConfigMap.put(config.TaskAction__c,taskConfigs);
          }   
          if(String.isEmpty(subject) && taskConfig.size() > 0 ) {
              //subject = truncateSubject(taskConfig.get(0).Subject__c) ;
              subject = truncateSubject(AppUtils.replaceMergeFields(taskConfig.get(0).Subject__c,record));
          } 
      }

      List<Task> taskList = new List<Task>();
      Task taskInstance = initializeTask(ownerUserId,record.Id, action, recordName, taskCompleted, dueDate);
        if(Schema.sObjectType.ProcessInstanceWorkitem.fields.Id.isAccessible()) {
            if((isAssociatedWithApproval == 'Null' || isAssociatedWithApproval == 'Yes' || isAssociatedWithApproval == null) && associateWithApproval == true){

          List<ProcessInstanceWorkitem> workItemList = [SELECT id, Actor.Type, ActorId 
                                                        FROM ProcessInstanceWorkitem 
                                                        WHERE ProcessInstance.TargetObjectId = :record.Id 
                                                         LIMIT 1];  //CRUD/FLS False +ve As per business scenario we can't check for portal/external users
                if(workItemList.size() > 0 && Schema.sObjectType.Task.fields.workItemId__c.isCreateable()){
                  taskInstance.workItemId__c = workItemList.get(0).Id;
              }
          }    
      }

        if(String.isEmpty(taskType) != true && Schema.sObjectType.Task.fields.Type.isCreateable()){
              taskInstance.Type = taskType;
      }
      subject = AppUtils.replaceMergeFields(subject,record);
      //taskInstance.Subject = subject;
        //if(Schema.sObjectType.Task.fields.Subject.isCreateable()){CRUD/FLS False Positive:
            taskInstance.Subject = truncateSubject(subject);//CRUD/FLS False Positive:
      //}
     
      if(String.isEmpty(groupName)){
            taskInstance.OwnerId = ownerUserId;// CRUD/FLS False Positive: Id field 
          copyTaskConfig(taskInstance,ownerUserId,action, dueDate);
          taskList.add(taskInstance);
      }
      else{
          taskList = initializeGroupTasks(groupName, taskInstance,action,dueDate, null, false);
      }

        if(create == true && Schema.sObjectType.Task.isCreateable()){
              insert as user taskList;
          }
      return taskList;
  }

    /*
        Overloaded Method should be called when a task creation is needed as part of an approval process

        recordId(Required) - The record Id to which the task is associated (whatId)
        action(Required) - The Action Name as defined by Task Action Summary Config Custom Setting
        recordName(Required) - Name of Record which shows on Task Count Summary
        groupName(Optional) - The Developer Name of group, if the task needs to be assigned to the members of the group. (Obsolete parameter)
        dueDate(Optional) - If set to null, Due Date is grabbed from Task Action Summary Config Custom Setting for the associated action else is set to the passed Due Date
        create(Required) - Creates the list of Tasks if set to true else returns the list without insert.
        
        Modified By Pankaj - 
            In case of Approval task we wil use ApprovalDefinitionName__c and ApprovalStepName__c to identify task type. There can be use case where we need different step task to associate
            with different phase. Action will be used if no entry found for approvalDefinitionName and ApprovalStepName. In This casae action should be different for every entry.
    */
    global static List<Task> createApprovalProcessTasks(Id recordId, String action, String recordName, String groupName, Date dueDate,  boolean create){
        return createApprovalProcessTasks(recordId, action, recordName, groupName, dueDate,  null, create);
    }

    global static List<Task> createApprovalProcessTasks(Id recordId, String action, String recordName, String groupName, Date dueDate, String subject,  boolean create){
        return createApprovalProcessTasks(recordId, action, recordName, groupName, dueDate,  subject, create, null);

    }

    global static List<Task> createApprovalProcessTasks(Id recordId, String action, String recordName, String groupName, Date dueDate, String subject,  boolean create, string fieldName){
        List<ProcessInstanceWorkitem> workItemList = new List<ProcessInstanceWorkitem>();
        workItemList = [SELECT id, Actor.Type, Actor.name, ActorId FROM ProcessInstanceWorkitem 
                        WHERE ProcessInstance.TargetObjectId = :recordId LIMIT 1];  //CRUD/FLS False +ve As per business scenario we can't check for portal/external users
        String sobjectAPIName = recordId.getSObjectType().getDescribe().getName();
        //Prajakta: Support for Dynamic approver field name.--------------------
        if(String.isEmpty(fieldName)){
            if(Schema.sObjectType.SobjectConfig__c.isAccessible()){
                List<SobjectConfig__c> sobjectColList = [Select  ApproverFieldAPIName__c  From SobjectConfig__c 
                                                        Where Name = :sobjectAPIName WITH USER_MODE];
                if(sobjectColList.size() > 0){
                    fieldName = sobjectColList.get(0).ApproverFieldAPIName__c;
                }
            }
        }
        if(workItemList.isEmpty() == true){
            if(String.isNotEmpty(fieldName)){
                Approval.ProcessSubmitRequest requestForApproval = new Approval.ProcessSubmitRequest();
                String soqlQuery = 'Select ' + String.escapeSingleQuotes(fieldName)  + ' FROM ' +  String.escapeSingleQuotes(sobjectAPIName)  + ' Where Id = :recordId with USER_MODE';
                SObject sobjId;
                if(AppUtils.isObjectAccessible(sobjectAPIName)){ //CRUD/FLS False +ve with the help of AppUtils we have performed check
                    sobjId = Database.query(String.escapeSingleQuotes(soqlQuery)); //SOQL Injection - False +ve - Dynamic part of query string is escapeSingleQuotes
                }
                String colName = fieldName;
                Id userId= (Id)sobjId.get(colName);
                List<Id> userIdList = new List<Id>();
                userIdList.add(userId);
                requestForApproval.setNextApproverIds(userIdList); 
                requestForApproval.setComments('Submitted for approval.');
                requestForApproval.setObjectId(recordId);
               //Submit for Approval
               Approval.ProcessResult result = Approval.process(requestForApproval);
               if(Schema.sObjectType.ProcessInstanceWorkitem.fields.id.isAccessible()) {
               workItemList = [SELECT id, Actor.Type, Actor.name, ActorId FROM ProcessInstanceWorkitem 
                                WHERE ProcessInstance.TargetObjectId = :recordId LIMIT 100]; //CRUD/FLS False +ve As per business scenario we can't check for portal/external users
               }
            }else{
                Approval.ProcessSubmitRequest requestForApproval = new Approval.ProcessSubmitRequest();
                requestForApproval.setComments('Submitted for approval.');
                requestForApproval.setObjectId(recordId);
                //Submit for Approval
                Approval.ProcessResult result = Approval.process(requestForApproval);
                if(Schema.sObjectType.ProcessInstanceWorkitem.fields.id.isAccessible()) {
                workItemList = [SELECT id, Actor.Type, Actor.name, ActorId FROM ProcessInstanceWorkitem 
                                WHERE ProcessInstance.TargetObjectId = :recordId LIMIT 100];  //CRUD/FLS False +ve As per business scenario we can't check for portal/external users
            }
        }
        }
        if(workItemList.isEmpty() == true){
            return null;
        }

        List<Task> taskList = new List<Task>();
        Map<Task, Task> delegrateTaskByOrginalTask = new Map<Task,Task>();
        //get approval process step name and approval process name
        if(Schema.sObjectType.ProcessInstanceNode.fields.Id.isAccessible() && 
        Schema.sObjectType.ProcessInstanceNode.fields.ProcessNodeId.isAccessible()) {
        List<ProcessInstanceNode> instanceSteps = [select id, ProcessInstance.ProcessDefinition.DeveloperName, ProcessNodeId 
                                                    from ProcessInstanceNode 
                                                    where ProcessInstance.TargetObjectId = :recordId 
                                                    and NodeStatus = 'Pending'  LIMIT 10];//CRUD/FLS False +ve As per business scenario we can't check for portal/external users
        if(instanceSteps.size() > 0) {
                if(Schema.sObjectType.ProcessNode.isAccessible() && Schema.sObjectType.ProcessNode.fields.DeveloperName.isAccessible()) {
            List<ProcessNode> processNodes = [select DeveloperName from ProcessNode where id= :instanceSteps[0].ProcessNodeId ]; 
            List<TaskConfig__c> taskConfigs = TaskTriggerHelper.getTaskConfigByApprovalNameAndStep(instanceSteps[0].ProcessInstance.ProcessDefinition.DeveloperName, processNodes[0].DeveloperName);
            //if(taskConfigs.size() > 0) {
            //   action = taskConfigs[0].TaskAction__c;
                 }   
            }
        }
        subject = truncateSubject(AppUtils.replaceMergeFields(subject,recordId));
        for(ProcessInstanceWorkitem workItem : workItemList) {
            //Task Creation
            Task taskInstance = initializeTask(recordId, action, recordName, false, dueDate);
            //if(Schema.sObjectType.Task.fields.Subject.isCreateable() && Schema.sObjectType.Task.fields.Subject.isUpdateable()){
                taskInstance.Subject = subject; //CRUD/FLS False Positive:
            //}
            //Assign to Group or User
            if(workItem.Actor.Type != null && workItem.Actor.Type.equals('User')){
                taskInstance.OwnerId = workItem.ActorId; // CRUD/FLS False Positive: Id field 
                
                if(Schema.sObjectType.Task.fields.WorkItemId__c.isCreateable() && Schema.sObjectType.Task.fields.WorkItemId__c.isUpdateable()){
                    taskInstance.WorkItemId__c = workItem.Id;
                }

                copyTaskConfig(taskInstance,workItem.ActorId,action, dueDate);
                taskList.add(taskInstance);
                Date todayDate = date.today();
                User u = new User();
                u = [SELECT id,Name,DelegatedApproverId,DelegateFrom__c,DelegateTo__c,EnableDelegate__c 
                    FROM User WHERE Id = :taskInstance.OwnerId WITH USER_MODE]; //CRUD/FLS False +ve As per business scenario we can't check for portal/external users
                String delegateApproversSet;
                delegateApproversSet = u.DelegatedApproverId;
                Boolean delegateApprove = false;
                if(Schema.sObjectType.ProcessInstanceNode.isAccessible() && Schema.sObjectType.ProcessInstanceNode.fields.Id.isAccessible() && Schema.sObjectType.ProcessInstanceNode.fields.NodeStatus.isAccessible()) {
                List<ProcessInstanceNode> processInstanceNode = [SELECT Id,NodeStatus,ProcessInstanceId,ProcessNodeId,ProcessNodeName,ProcessInstance.ProcessDefinitionId,ProcessInstance.TargetObjectId 
                FROM ProcessInstanceNode where  ProcessInstance.TargetObjectId = :recordId And NodeStatus in('Started', 'Pending') ]; //CRUD/FLS False +ve As per business scenario we can't check for portal/external users
            
                if(processInstanceNode.size() > 0){
                     String approvalDefinationId1 = processInstanceNode.get(0).ProcessInstance.ProcessDefinitionId;
                     String approvalStepId1 = processInstanceNode.get(0).ProcessNodeId;
                      List<ApprovalProcessStepCache__c>  approvalStepCacheList = [SELECT ApprovalDefinitionId__c,ApprovalStepId__c,allowDelegate__c 
                            FROM ApprovalProcessStepCache__c 
                            Where ApprovalDefinitionId__c = : approvalDefinationId1 And ApprovalStepId__c = : approvalStepId1 WITH USER_MODE]; //CRUD/FLS False +ve As per business scenario we can't check for portal/external users
                        if(approvalStepCacheList.size() > 0) {
                            delegateApprove = approvalStepCacheList.get(0).allowDelegate__c;
                        }
                    }
                }
                if(delegateApproversSet !=  null && delegateApprove == true && todayDate >= u.DelegateFrom__c && todayDate <= u.DelegateTo__c && u.EnableDelegate__c == true){
                    Task delegatetaskInstance = initializeTask(recordId, action, recordName, false, dueDate);

                    delegatetaskInstance = initializeTask(recordId, action, recordName, false, dueDate);
                    if(Schema.sObjectType.Task.fields.Subject.isCreateable() && Schema.sObjectType.Task.fields.Subject.isUpdateable()){  
                        delegatetaskInstance.Subject = subject;//CRUD/FLS False Positive:
                    }
                    delegatetaskInstance.OwnerId = delegateApproversSet;  // CRUD/FLS False Positive: Id field 
                   
                    if(Schema.sObjectType.Task.fields.WorkItemId__c.isCreateable() && Schema.sObjectType.Task.fields.WorkItemId__c.isUpdateable()){
                        delegatetaskInstance.WorkItemId__c = workItem.Id;
                    }
                    copyTaskConfig(taskInstance,delegateApproversSet,action, dueDate);

                    //Due Date and Subject are missign on Delegated Approver
                    //User Story 119247: Internal - Enhancement - Delegated Approver - Provide support for multiple approval in delegated approver functionality
                    if(taskInstance.subject!=null && subject == null){
                        if(Schema.sObjectType.Task.fields.Subject.isCreateable() && Schema.sObjectType.Task.fields.Subject.isUpdateable()){  
                            delegatetaskInstance.Subject =truncateSubject(AppUtils.replaceMergeFields(taskInstance.subject,recordId));  //CRUD/FLS False Positive:
                        }
                    }
                    if(Schema.sObjectType.Task.fields.ActivityDate.isCreateable() && Schema.sObjectType.Task.fields.ActivityDate.isUpdateable()){
                    delegatetaskInstance.ActivityDate = dueDate;
                    }
                    delegrateTaskByOrginalTask.put(delegatetaskInstance, taskInstance);
                }
            } else {
                taskList = initializeGroupTasks( groupName, taskInstance,action,duedate, groupName != null ? null : workItem.ActorId, true);
                for(Task task : taskList){
                    if(Schema.sObjectType.Task.fields.WorkItemId__c.isCreateable() && Schema.sObjectType.Task.fields.WorkItemId__c.isUpdateable()){
                        task.WorkItemId__c = workItem.Id;
                    }
                    if(Schema.sObjectType.Task.fields.TaskAction__c.isCreateable() && Schema.sObjectType.Task.fields.TaskAction__c.isUpdateable()){
                        task.TaskAction__c = action;
                    }
                }
            }
        }
            for(Task task : taskList){
                if(task.subject != null){
                    //if(Schema.sObjectType.Task.fields.Subject.isCreateable() && Schema.sObjectType.Task.fields.Subject.isUpdateable()){
                    task.Subject = truncateSubject(AppUtils.replaceMergeFields(task.subject,recordId)).replace('\\', '');//CRUD/FLS False Positive:
            //}
                }
            }
        
        if(create == true){
            if(Schema.sObjectType.Task.isCreateable()){
                insert as user taskList;
                    if(Schema.sObjectType.Task.fields.ParentTask__c.isCreateable() && Schema.sObjectType.Task.fields.ParentTask__c.isUpdateable()){
                    for(Task t : delegrateTaskByOrginalTask.keySet()) {
                        t.ParentTask__c = delegrateTaskByOrginalTask.get(t).Id;
                    }
                }
                List<Task>  delegatedTaskList = new List<Task>();
                //insert delegrateTaskByOrginalTask.keySet();
                delegatedTaskList.addAll(delegrateTaskByOrginalTask.keySet());
                if(Schema.sObjectType.Task.isCreateable()){
                insert as user delegatedTaskList;
            }
        }        
        }        
        taskList.addAll(delegrateTaskByOrginalTask.keySet());
        return taskList;
    }


    /*
        Overloaded Method should be called when a task creation is needed as part of an approval process

        recordId(Required) - The record Id to which the task is associated (whatId)
        action(Required) - The Action Name as defined by Task Action Summary Config Custom Setting
        recordName(Required) - Name of Record which shows on Task Count Summary
        dueDate(Optional) - If set to null, Due Date is grabbed from Task Action Summary Config Custom Setting for the associated action else is set to the passed Due Date
        create(Required) - Creates the list of Tasks if set to true else returns the list without insert
    */
    global static List<Task> createApprovalProcessTasks(Id recordId, String action, String recordName, Date dueDate,  boolean create){
        List<ProcessInstanceWorkitem> workItemList = new List<ProcessInstanceWorkitem>();
        workItemList = [SELECT id, Actor.Type, ActorId FROM ProcessInstanceWorkitem 
                        WHERE ProcessInstance.TargetObjectId = :recordId LIMIT 1]; //CRUD/FLS False +ve As per business scenario we can't check for portal/external users
        if(workItemList.isEmpty() == true){
            Approval.ProcessSubmitRequest requestForApproval = new Approval.ProcessSubmitRequest();
            requestForApproval.setComments('Submitted for approval.');
            requestForApproval.setObjectId(recordId);
            //Submit for Approval
            Approval.ProcessResult result = Approval.process(requestForApproval);
            workItemList = [SELECT id, Actor.Type, ActorId FROM ProcessInstanceWorkitem 
                            WHERE ProcessInstance.TargetObjectId = :recordId LIMIT 1]; //CRUD/FLS False +ve As per business scenario we can't check for portal/external users
        }

        if(workItemList.isEmpty() == true){
            return null;
        }

        ProcessInstanceWorkitem workItem = workItemList.get(0);
        //Task Creation
        List<Task> taskList = new List<Task>();
        Task taskInstance = initializeTask(recordId, action, recordName, false, dueDate);
        //Assign to Group or User
        if(workItem.Actor.Type != null && workItem.Actor.Type.equals('User')){
                taskInstance.OwnerId = workItem.ActorId;  // CRUD/FLS False Positive: Id field 
            if(Schema.sObjectType.Task.fields.WorkItemId__c.isCreateable()){
                taskInstance.WorkItemId__c = workItem.Id;  
            }
            copyTaskConfig(taskInstance,workItem.ActorId,action, dueDate);
            taskList.add(taskInstance);
        }
        else{
            List<Group> groupList = [select id, DeveloperName from Group where id = :workItem.ActorId WITH USER_MODE]; //CRUD/FLS False +ve As per business scenario we can't check for portal/external users
            taskList = initializeGroupTasks(groupList.get(0).DeveloperName, taskInstance,action,dueDate,null, true);
            for(Task task : taskList){
                if(Schema.sObjectType.Task.fields.WorkItemId__c.isCreateable()){
                    task.WorkItemId__c = workItem.Id;
                }
                if(Schema.sObjectType.Task.fields.TaskAction__c.isCreateable()){
                    task.TaskAction__c = action;
                }
            } 
        }

        if(create == true){
                if(Schema.sObjectType.Task.isCreateable()){
                    insert as user taskList;
                }
        }
        return taskList;
    }

    /*
        Helper method used to get the Task Action Summary of the associated task object
    */
    public static TaskConfig__c getTaskConfig(String action, String groupType) {
        List<TaskConfig__c> taskConfigList = new List<TaskConfig__c>();
        if(Schema.sObjectType.TaskConfig__c.isAccessible()) {
            taskConfigList = [select GroupType__c,TaskAction__c,TaskLabel__c,Name,SobjectName__c,
                        PhaseConfig__r.Name,Subject__c,DueDateOffset__c,PhaseConfig__r.CustomAppName__c,IsAssociatedwithApproval__c from
                        TaskConfig__c where TaskAction__c =: action and GroupType__c =:groupType WITH USER_MODE];
        }
        if(taskConfigList.size() > 0){
                return taskConfigList[0];
        }
        return null;
    }

    public static List<TaskConfig__c> getTaskConfig(List<String>action) {
        List<TaskConfig__c> taskConfigList = new List<TaskConfig__c>();
        if(Schema.sObjectType.TaskConfig__c.isAccessible()) {
            taskConfigList = [select GroupType__c,TaskAction__c,TaskLabel__c,Name,SobjectName__c,
                PhaseConfig__r.Name,PhaseConfig__r.CustomAppName__c,Subject__c,DueDateOffset__c,IsAssociatedwithApproval__c from
                        TaskConfig__c where TaskAction__c in :action WITH USER_MODE];
        }
        if(taskConfigList.size() > 0){
                return taskConfigList;
        }
        return null;
    }
    
    /*
        Helper method used to get the Task Action Summary of the associated task object
    */
    public static List<TaskConfig__c> getTaskConfig(List<String>action, String groupType) {
        List<TaskConfig__c> taskConfigList = new List<TaskConfig__c>();
        if(Schema.sObjectType.TaskConfig__c.isAccessible()) {
            taskConfigList = [select OrganizationNameOfRecord__c,GroupType__c,TaskAction__c,TaskLabel__c,Name,SobjectName__c,
                PhaseConfig__r.Name,PhaseConfig__r.CustomAppName__c,Subject__c,DueDateOffset__c,IsAssociatedwithApproval__c from
                        TaskConfig__c where TaskAction__c in :action and GroupType__c =:groupType WITH USER_MODE];
        }
        if(taskConfigList.size() > 0){
                return taskConfigList;
        }
        return null;
    }

    /*
        Helper method used to initialize values of a task instance
        recordId(Required) - The record Id to which the task is associated (whatId)
        action(Required) - The Action Name as defined by Task Action Summary Config Custom Setting
        recordName(Required) - Name of Record which shows on Task Count Summary
        taskCompleted(Required) - When set to true - Status of task is set to "Completed" else is set to "Not Started"
        dueDate(Optional) - If set to null, Due Date is grabbed from Task Action Summary Config Custom Setting for the associated action else is set to the passed Due Date
    */
    private static Task initializeTask(Id recordId, String action, String recordName, Boolean taskCompleted, Date dueDate){
        Task taskInstance = new Task();
        //User Story 171188: Enhancement - NED - Task object’s organization field
        List<TaskConfig__c> taskConfigList = new List<TaskConfig__c>();
        if(Schema.sObjectType.TaskConfig__c.isAccessible()) {
            taskConfigList = [SELECT id,OrganizationNameOfRecord__c 
                                                from TaskConfig__c where TaskAction__c =: action WITH USER_MODE];
        }
        if(taskConfigList.size() > 0 && taskConfigList[0].OrganizationNameOfRecord__c != null
            && Schema.sObjectType.Task.fields.OrganizationName__c.isCreateable() && Schema.sObjectType.Task.fields.OrganizationName__c.isUpdateable()){
                    taskInstance.OrganizationName__c = AppUtils.replaceMergeFields(taskConfigList[0].OrganizationNameOfRecord__c ,recordId);
        }
        
        
        //WhatId
        //if(Schema.sObjectType.Task.fields.WhatId.isCreateable() && Schema.sObjectType.Task.fields.WhatId.isUpdateable()){
            taskInstance.WhatId = recordId;  //B29u07g05 - False +ve ID field removed check it was failing for guest user
        //}
        //Action
        if(Schema.sObjectType.Task.fields.TaskAction__c.isCreateable() && Schema.sObjectType.Task.fields.TaskAction__c.isUpdateable()){
            taskInstance.TaskAction__c = action;
        }
        //Name of Record
        if(String.isEmpty(recordName) != true && Schema.sObjectType.Task.fields.ObjectRelationName__c.isCreateable()
        && Schema.sObjectType.Task.fields.ObjectRelationName__c.isUpdateable()){
                taskInstance.ObjectRelationName__c = recordName;
            
        }

        //Task Status
        //if(Schema.sObjectType.Task.fields.Status.isCreateable() && Schema.sObjectType.Task.fields.Status.isUpdateable()){// CRUD/FLS False Positive as per our business scenario we have have to update the standard fields for all profiles
            if(taskCompleted == true){
                taskInstance.Status = 'Completed'; // CRUD/FLS False Positive
            }
            else{
                taskInstance.Status = 'Not Started';// CRUD/FLS False Positive
            }
        //}
        
        List<Task> taskList = new List<Task>();
        taskList.add(taskInstance);
        dataCopyIntoTask(recordId, taskList, false);
        return taskInstance;
    }
    
    
    /*
        Helper method used to initialize values of a task instance
        ownerId(required) - The owner for whom the task is created.
        recordId(Required) - The record Id to which the task is associated (whatId)
        action(Required) - The Action Name as defined by Task Action Summary Config Custom Setting
        recordName(Required) - Name of Record which shows on Task Count Summary
        taskCompleted(Required) - When set to true - Status of task is set to "Completed" else is set to "Not Started"
        dueDate(Optional) - If set to null, Due Date is grabbed from Task Action Summary Config Custom Setting for the associated action else is set to the passed Due Date
    */
    private static Task initializeTask(Id ownerId,Id recordId, String action, String recordName, Boolean taskCompleted, Date dueDate){
        Task taskInstance = new Task();
        FrameworkConfig__c fc = FrameworkConfig__c.getValues('UserIsExternalUserFieldApiName');
        if(fc!=null){           
            //List<User> userList = [SELECT Id,isExternalUser__c FROM USER WHERE Id = :ownerId];
            String query = 'SELECT Id, '+ String.escapeSingleQuotes(fc.TextValue__c) + ' FROM USER WHERE Id =:'+String.escapeSingleQuotes(ownerId)+'WITH USER_MODE'; //CRUD/FLS False +ve As per business scenario we can't check for portal/external users
            List<User> userList = Database.Query(String.escapeSingleQuotes(query)); //SOQL Injection - False +ve - FrameworkConfig__c is only created and updated by Admin User
            if(userList.size() > 0){
                //if(userList[0].isExternalUser__c){
                if((Boolean)userList[0].get(fc.TextValue__c) && Schema.sObjectType.Task.fields.IsVisibleInSelfService.isCreateable()
                && Schema.sObjectType.Task.fields.IsVisibleInSelfService.isUpdateable()){
                        taskInstance.IsVisibleInSelfService = true;
                }
            }
        }
        List<TaskConfig__c> taskConfigList  = new List<TaskConfig__c>();
        if(Schema.sObjectType.Account.isAccessible()) {
            taskConfigList = [SELECT id,OrganizationNameOfRecord__c from TaskConfig__c 
                    where TaskAction__c =: action WITH USER_MODE];
        }
        if(taskConfigList.size() > 0 && taskConfigList[0].OrganizationNameOfRecord__c != null 
        && Schema.sObjectType.Task.fields.OrganizationName__c.isCreateable() && Schema.sObjectType.Task.fields.OrganizationName__c.isUpdateable()){
          taskInstance.OrganizationName__c = AppUtils.replaceMergeFields(taskConfigList[0].OrganizationNameOfRecord__c ,recordId);
        }

        //WhatId
        //if(Schema.sObjectType.Task.fields.WhatId.isCreateable() && Schema.sObjectType.Task.fields.WhatId.isUpdateable()){
            taskInstance.WhatId = recordId; //B29u07g05 - False +ve ID field removed check it was failing for guest user
        //}
        //Action
        if(Schema.sObjectType.Task.fields.TaskAction__c.isCreateable() && Schema.sObjectType.Task.fields.TaskAction__c.isUpdateable()){
            taskInstance.TaskAction__c = action;
        }
        //TaskConfig__c taskConfigRecord;
        //Document Type and Phase Name
        //Name of Record
        if(String.isEmpty(recordName) != true && Schema.sObjectType.Task.fields.ObjectRelationName__c.isCreateable()
        && Schema.sObjectType.Task.fields.ObjectRelationName__c.isUpdateable()){
                taskInstance.ObjectRelationName__c = recordName;
            }

        //Task Status
        //if(Schema.sObjectType.Task.fields.Status.isCreateable() && Schema.sObjectType.Task.fields.Status.isUpdateable()){
            if(taskCompleted == true){
                taskInstance.Status = 'Completed';// CRUD/FLS False Positive
            }
            else{
                taskInstance.Status = 'Not Started';
            }
        //}
        
        List<Task> taskList = new List<Task>();
        taskList.add(taskInstance);
        dataCopyIntoTask(recordId, taskList, false);
        return taskInstance;
    }
    
    private static Task copyTaskConfig(Task taskInstance,Id ownerId,String action,Date dueDate){
        TaskConfig__c taskConfigRecord;
        //Document Type and Phase Name
        if((taskActionConfigMap.size () > 0 && taskActionConfigMap.get(action) != null)) {
            List<TaskConfig__c> taskConfigs =   taskActionConfigMap.get(action); 
            String activeAppName = UserPreferenceHelper.getAppName('ActiveAppName__c',ownerId);
            
            for(TaskConfig__c taskConfg : taskConfigs){
                if(taskConfg.PhaseConfig__r.CustomAppName__c.equalsIgnoreCase(activeAppName)){
                    taskConfigRecord = taskConfg ;
                    break;
                }
            }
        }
        else{
            taskConfigRecord  = TaskCreationHandler.getTaskConfig(action, 'MyTasks');
        }
        if(taskConfigRecord != null){
            if(Schema.sObjectType.Task.fields.DocumentType__c.isCreateable() && Schema.sObjectType.Task.fields.DocumentType__c.isUpdateable()){
                taskInstance.DocumentType__c = taskConfigRecord.SobjectName__c;
            }
            if(Schema.sObjectType.Task.fields.PhaseName__c.isCreateable() && Schema.sObjectType.Task.fields.PhaseName__c.isUpdateable()){
                taskInstance.PhaseName__c = taskConfigRecord.PhaseConfig__r.Name;
            }
            if(Schema.sObjectType.Task.fields.CustomAppName__c.isCreateable() && Schema.sObjectType.Task.fields.CustomAppName__c.isUpdateable()){
                taskInstance.CustomAppName__c = taskConfigRecord.PhaseConfig__r.CustomAppName__c;
                
            }
            if(Schema.sObjectType.Task.fields.TaskConfigId__c.isCreateable() && Schema.sObjectType.Task.fields.TaskConfigId__c.isUpdateable()){
                taskInstance.TaskConfigId__c = taskConfigRecord.id;            
            }
            if(taskInstance.Subject == null){
                //If standard field is empty then we take subject field data from taskconfig object                 
                   taskInstance.Subject = taskConfigRecord.Subject__c;//CRUD/FLS False Positive:

            }            
        }else{
            taskActionConfigMap.put(action, new List<TaskConfig__c>()); // Code Added for avoid SOQL Limit while getting Task Config.
        }
        if(Schema.sObjectType.Task.fields.ActivityDate.isCreateable() && Schema.sObjectType.Task.fields.ActivityDate.isUpdateable()){
                if(dueDate != null){
            taskInstance.ActivityDate = dueDate;
        } else {
            if(taskConfigRecord != null && taskConfigRecord.DueDateOffset__c != null){
                Datetime businessDateTime = BusinessHours.addGMT(bh.id,System.now(), (Long)(taskConfigRecord.DueDateOffset__c * 86400000));             
                date d = date.newinstance(businessDateTime .year(), businessDateTime .month(), businessDateTime .day());
                taskInstance.ActivityDate = d;//Date.today().addDays(taskConfigRecord.DueDateOffset__c.intValue());
            }
            else{
                Datetime businessDateTime = BusinessHours.addGMT(bh.id,System.now(), (Long)(7 * 86400000));             
                date d = date.newinstance(businessDateTime .year(), businessDateTime .month(), businessDateTime .day());
                taskInstance.ActivityDate = d;
                    }
            }
        } 
        return taskInstance;
    } 

    /*
        Helper method used to initialize values of a task instance
        groupName(Required) - The Developer Name of the Group for whose members tasks need to be created
        taskInstance(Required) - The Instance of Task whose values have been initialized by initializeTask.
    */
    private static List<Task> initializeGroupTasks(String groupName, Task taskInstance,String action,Date dueDate, String groupId, Boolean skipTaskToSubmittor){
        List<Task> taskList = new List<Task>();
        List<GroupMember> groupMembers;
        if(groupId != null) {
            //if(Schema.sObjectType.GroupMember.fields.GroupId.isAccessible()) { 
            groupMembers = [SELECT Id, Group.DeveloperName, GroupId, UserOrGroupId FROM GroupMember 
                Where Group.Id = :groupId and Group.Type='Queue'];//NOPMD CRUD/FLS False +ve As per business scenario we can't check for portal/external users
            //}
        } else {
            //if(Schema.sObjectType.GroupMember.fields.GroupId.isAccessible()) { 
            groupMembers = [SELECT Id, Group.DeveloperName, GroupId, UserOrGroupId FROM GroupMember 
                Where Group.DeveloperName = :groupName and Group.Type='Queue'];//NOPMD CRUD/FLS False +ve As per business scenario we can't check for portal/external users
            //}
        }
        Set<Id> activeUsers = new Set<Id>();
        for(GroupMember grpMember1 : groupMembers){
            activeUsers.add(grpMember1.UserOrGroupId);
        }
        //User Story 148730: Research - Delegate Approver Enhancements - Part 2
         //code for delegate Approver in Queue base -- 1
        List<ProcessInstanceNode> processInstanceNode = [SELECT Id,NodeStatus,ProcessInstanceId,ProcessNodeId,ProcessNodeName,ProcessInstance.ProcessDefinitionId,ProcessInstance.TargetObjectId 
        FROM ProcessInstanceNode 
        where  ProcessInstance.TargetObjectId = :taskInstance.WhatId And NodeStatus in('Started', 'Pending') ]; //CRUD/FLS False +ve As per business scenario we can't check for portal/external users
            
        Boolean delegateApprove = false;
        Date todayDate = date.today();
        if(processInstanceNode.size() > 0){
            String approvalDefinationId1 = processInstanceNode.get(0).ProcessInstance.ProcessDefinitionId;
            String approvalStepId1 = processInstanceNode.get(0).ProcessNodeId;
            List<ApprovalProcessStepCache__c>  approvalStepCacheList = new List<ApprovalProcessStepCache__c>();
            if(Schema.sObjectType.Account.isAccessible()){
                approvalStepCacheList = [SELECT ApprovalDefinitionId__c,ApprovalStepId__c,allowDelegate__c 
                FROM ApprovalProcessStepCache__c
                Where ApprovalDefinitionId__c = : approvalDefinationId1 And ApprovalStepId__c = : approvalStepId1 
                WITH USER_MODE];
            }
            if(approvalStepCacheList.size() > 0) {
                delegateApprove = approvalStepCacheList.get(0).allowDelegate__c;
            }
        }     
        List<User> delegateUserList = [SELECT id,Name,DelegatedApproverId,DelegateFrom__c,DelegateTo__c,EnableDelegate__c 
        FROM User WHERE Id IN :activeUsers and DelegatedApproverId NOT IN :activeUsers and IsActive = true WITH USER_MODE]; //CRUD/FLS False +ve As per business scenario we can't check for portal/external users
        //Prajakta:If Queue user is current logged in user then remove that user and task is not created for that user.
        if(skipTaskToSubmittor == true && KeyValueStoreHelper.getBooleanValue('HideApprovalForSubmittor',true) != null && KeyValueStoreHelper.getBooleanValue('HideApprovalForSubmittor',true)){
            activeUsers.remove(UserInfo.getUserId());

        }
        if (Schema.sObjectType.User.fields.Name.isAccessible()) {
            List<User> userList = [Select id,name from user where id in :activeusers and IsActive = true WITH USER_MODE]; //CRUD/FLS False +ve As per business scenario we can't check for portal/external users
        activeusers = new Set<Id>();
        for(User u : userList){
            activeusers.add(u.id);
        }

        for(GroupMember grpMember : groupMembers){ 
            if(String.valueOf(grpMember.UserOrGroupId).startsWith('005')) {
                Task taskInstanceCloned = taskInstance.clone();
                    taskInstanceCloned.OwnerId = grpMember.UserOrGroupId;  // CRUD/FLS False Positive: Id field 
                    if(Schema.sObjectType.Task.fields.GroupName__c.isCreateable() && Schema.sObjectType.Task.fields.GroupName__c.isUpdateable()){
                taskInstanceCloned.GroupName__c = grpMember.Group.DeveloperName;
                    }
                    if(Schema.sObjectType.Task.fields.GroupId__c.isCreateable() && Schema.sObjectType.Task.fields.GroupId__c.isUpdateable()){
                taskInstanceCloned.GroupId__c = grpMember.GroupId;
                    }
                taskInstanceCloned = copyTaskConfig(taskInstanceCloned,grpMember.UserOrGroupId,action, dueDate);
                if(activeusers.contains(grpMember.UserOrGroupId)){
                    taskList.add(taskInstanceCloned);
                }
            } 
            
        }
        }
        //code for delegate Approver in Queue base -- 2
        for(User user : delegateUserList){
            if(user.DelegatedApproverId !=  null && delegateApprove == true && todayDate >= user.DelegateFrom__c && todayDate <= user.DelegateTo__c && user.EnableDelegate__c == true){
                Task taskInstanceCloned = taskInstance.clone();
                taskInstanceCloned.OwnerId = user.DelegatedApproverId;  // CRUD/FLS False Positive: Id field 
                taskInstanceCloned = copyTaskConfig(taskInstanceCloned,user.DelegatedApproverId,action, dueDate);
                taskList.add(taskInstanceCloned);
            }
        }
        dataCopyIntoTask(taskInstance.WhatId, taskList, true);
        return taskList;
    }
    
    /* method copies data from Source object to task */
    private static void dataCopyIntoTask(Id recordId, List<Task> targetSobjectList, boolean isGroupTask){
        String objectName = recordId.getSObjectType().getDescribe().getName();
        Type objectExistsCheck = Type.forName(objectName);
        String namespace = AppUtils.getNameSpacePrefix();
        if(!objectName.startsWith(namespace) && objectName.endsWith('__c') && objectExistsCheck == null){
            objectName = namespace+objectName;
        }
        if(isGroupTask){
            Map<Id, List<Sobject>> srcIdToTargetSobjectsMap = new Map<Id, List<Sobject>>();
            srcIdToTargetSobjectsMap.put(recordId, targetSobjectList);
        }else{
            AppUtils.copyRecord(objectName, 'Task', recordId, targetSobjectList.get(0));
        }
    }
    
    /*Recall Record for Submitter and Non-Submitter */
    global static void recallRecord(Id recordId,String comments){
        List<ProcessInstanceWorkitem>  workitem = new List<ProcessInstanceWorkitem>();
        List<String> workitemIds = new List<String>();
        Set<String> procInsIds = new Set<String>();
        Set<String> procsSubIds = new Set<String>();
        try{
             
              List<ProcessInstance> procins = new List<ProcessInstance>([select Id,SubmittedById from ProcessInstance where Status = 'Pending' and TargetObjectId = :recordId ]); //CRUD/FLS False +ve As per business scenario we can't check for portal/external users
              for(ProcessInstance prIns : procins){
                  procInsIds.add(prIns.Id);
                  procsSubIds.add(prIns.SubmittedById);
              }
              if(procins != null && procins.size() > 0){
                 workitem =[select Id from ProcessInstanceWorkitem where ProcessInstanceId in :procInsIds ];//CRUD/FLS False +ve As per business scenario we can't check for portal/external users
                 for(ProcessInstanceWorkitem pitems : workitem){
                     workitemIds.add(pitems.Id);
                 }
                 if(procsSubIds.contains(UserInfo.getUserId())){
                   // call Recall Method by Submitter
                   recallRecordForSubmitter(recordId, workitemIds, comments, workitem);
                 }
                 else{
                   // call recall Method by Non Subitter
                   recallRecordForNonSubmiter(recordId, workitem);
                 }
              } 
        }
         catch(Exception e){
           // ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage()));
           // Add Custom Exception
           CustomExceptions.logException(e, true, true);
            //return null;
        } 
    }

    /*  Recall record if you are submitter @parameter required recordId and ProccessIntanceWorkItem List*/
    private static void recallRecordForSubmitter(String recordId, List<String> workitem, String comments, List<ProcessInstanceWorkitem> pwrkItem){  
     // Task need to be deleted
        List<Task> updateTaskList = [SELECT Id, ParentRecordId__c, WorkitemId__c, Status FROM Task 
        WHERE WorkitemId__c in :workitem and Status != 'Completed' and WhatId =:recordId WITH USER_MODE]; //CRUD/FLS False +ve As per business scenario we can't check for portal/external users
        if(updateTaskList.size() > 0){
            //if(Schema.sObjectType.Task.fields.Status.isUpdateable()){// CRUD/FLS False Positive as per our business scenario we have have to update the standard fields for all profiles
                    for(Task approvalTask : updateTaskList) {
                            approvalTask.Status = 'Completed';// CRUD/FLS False Positive
                    }
            //}
            if(Schema.sObjectType.Task.isUpdateable()){
                update as user updateTaskList;
            }
        } 
            
      Approval.ProcessWorkitemRequest pwr = new   Approval.ProcessWorkitemRequest();
      // Recall Logic
      notifyAdditionalPeople('Removed',recordId);    
      if(workitem!=null && workitem.size() > 0 ){
         if(comments !=null){
            pwr.SetComments(comments);
         }
         else{
            pwr.SetComments(System.Label.RecallComments);
         }
         pwr.setWorkItemId(pwrkItem[0].Id);
         pwr.setAction('Removed'); 
         Approval.ProcessResult pr = Approval.process(pwr);
        }
    }

     /* Recall Record Method for Non Submitter @parameter required is recordId and ProccessIntanceWorkItem List*/
     private static void recallRecordForNonSubmiter(String recordId,List<ProcessInstanceWorkitem> workitem){
        List<ApprovalDecisionActionConfig__c> approvalDecisionActionConfigList;
        Map<String,ApprovalDecisionActionConfig__c> actionConfigMap;   
        SchemaManager.SObjectWrapper parentSObject;
        UserPreferences__c pref = UserPreferences__c.getInstance();  
        if(pref == null || pref.ActiveAppName__c == null) {
            CustomExceptions.logException(String.format(System.Label.UserPrefrenceLabel, new List<String>{Userinfo.getUserId()}), false);
        }
        String customAppName = pref.ActiveAppName__c;
        if(recordId !=null){
            parentSObject = SchemaManager.getSObject((Id)recordId);  
        }
        if(parentSObject != null && parentSObject.objectName != null){
             if(!string.isEmpty(parentSObject.objectName)){
                if(ApprovalDecisionActionConfig__c.sObjectType.getDescribe().isAccessible() == true){
                            approvalDecisionActionConfigList  =  [select ActionLabelOverride__c,Action__c,CommentsFieldsAPIName__c,CommentsRequired__c,HideAction__c,
                                                                    FilterCriteriaforUserReassign__c,SobjectConfig__r.ApprovalReCallEnable__c,SobjectConfig__r.ApprovalReCallFieldAPIName__c,
                                                                    SobjectConfig__r.ApprovalReCallCommentFieldAPIName__c FROM ApprovalDecisionActionConfig__c 
                                                                    where SobjectConfig__r.Name =:parentSObject.objectName and CustomAppConfig__r.Name=:customAppName  
                                                                    WITH USER_MODE order by Sequence__c];
             } 
          }
        }
        actionConfigMap = new Map<String,ApprovalDecisionActionConfig__c>();
        for(ApprovalDecisionActionConfig__c approvalDecisionActionConfig: approvalDecisionActionConfigList){
                      actionConfigMap.put(approvalDecisionActionConfig.Action__c,approvalDecisionActionConfig);
        }
        ApprovalDecisionCtrl appdecissionCtrl = new ApprovalDecisionCtrl();
        appdecissionCtrl.sendToOwner(workitem[0],actionConfigMap.get('Send to Owner'));
    }

   /*
        Author : Prajakta
        Closes a single task. Accepts task Id.
   */
    global static void closeTask(Id taskId){
        //if(Schema.SObjectType.Task.fields.Status.isUpdateable()){// CRUD/FLS False Positive as per our business scenario we have have to update the standard fields for all profiles
            Task t = new Task(Id = taskId, Status = 'Completed'); // CRUD/FLS False Positive
            if(Schema.sObjectType.Task.isUpdateable()){
            update as user t;
            }
        //}
    }

    /*
        Author : Prajakta
        Closes collection of tasks. Accepts list of task Ids.
   */    
    global static void closeTasks(List<Id> taskIdList){
            List<Task> taskList = new  List<Task>();
            //if(Schema.SObjectType.Task.fields.Status.isUpdateable()){// CRUD/FLS False Positive as per our business scenario we have have to update the standard fields for all profiles
            for(Id task : taskIdList){
                Task tsk = new Task();
                tsk.Id = task;
                tsk.Status = 'Completed';
                taskList.add(tsk);
            }
            //}
            if(Schema.sObjectType.Task.isUpdateable()){
            update as user taskList;
            }
    }

    /*
        Author : Prajakta
        Closes collection of tasks. Accepts list of task sobject.
   */  
    global static void closeTasks(List<Task> tasklist){
        //if(Schema.SObjectType.Task.fields.Status.isUpdateable()){// CRUD/FLS False Positive as per our business scenario we have have to update the standard fields for all profiles
            for(Task tsk : tasklist){
            tsk.status = 'Completed'; 
            }
        //}
            if(Schema.sObjectType.Task.isUpdateable()){
            update as user tasklist;
            }
    }


    public Static void notifyAdditionalPeople(String action, Id recordId){
            List<EmailFeeder> emailFeeders = new List<EmailFeeder>();
            List<ProcessInstanceNode> processInstanceSteps = [SELECT Id,NodeStatus,ProcessInstanceId,ProcessNodeId,ProcessNodeName,ProcessInstance.ProcessDefinitionId,ProcessInstance.TargetObjectId 
            FROM ProcessInstanceNode 
            where ProcessInstance.TargetObjectId = :recordId And NodeStatus in('Started', 'Pending') ]; //CRUD  FLS- False +ve - Std obj  - will not check permission here 
            String approvalDefinationId = processInstanceSteps.get(0).ProcessInstance.ProcessDefinitionId;
            String approvalStepId = processInstanceSteps.get(0).ProcessNodeId;
            List<ApprovalProcessStepCache__c>  processStepCacheList = new List<ApprovalProcessStepCache__c>();
            if(Schema.sObjectType.ApprovalProcessStepCache__c.isAccessible()){
                processStepCacheList = [SELECT ApprovalDefinitionId__c,ApprovalStepId__c,NotifyAdditionalPeople__c,ApproveEmailTemplate__r.name,ReassignedEmailTemplate__r.name,RejectEmailTemplate__r.name,SendToOwnerEmailTemplate__r.name,EmailFieldAPIName__c,NotifyPreviousApprovers__c,FieldAPIForTask__c,ApproveTaskConfig__r.TaskAction__c,ReassignTaskConfig__r.TaskAction__c,DisapproveTaskConfig__r.TaskAction__c,SendtoOwnerTaskConfig__r.TaskAction__c
            FROM ApprovalProcessStepCache__c 
            Where ApprovalDefinitionId__c = : approvalDefinationId And ApprovalStepId__c = : approvalStepId WITH USER_MODE];
            }
            String templateName = null;
            if(processStepCacheList.size() > 0 && processStepCacheList.get(0).NotifyAdditionalPeople__c == true){
                Set<String> emailAddresses = new Set<String>();
                if(processStepCacheList.get(0).EmailFieldAPIName__c != null){
                    String sobjectName = recordId.getSObjectType().getDescribe().getName();
                    String query = 'Select ' + String.escapeSingleQuotes(processStepCacheList.get(0).EmailFieldAPIName__c) + ' From ' + String.escapeSingleQuotes(sobjectName) + ' Where Id = : recordId';
                    SObject sobj;
                    if(AppUtils.isObjectAccessible(sobjectName)){ //CRUD/FLS False +ve with the help of AppUtils we have performed check
                        sobj = Database.query(String.escapeSingleQuotes(query),AccessLevel.USER_MODE); //SOQL Injection - False +ve - Dynamic part of query string is escapeSingleQuotes
                    }
                    String emailFields = processStepCacheList.get(0).EmailFieldAPIName__c;
                     List<String> emailSeparatedFields = emailFields.split(',');
                     for(String emailSep : emailSeparatedFields){
                        String emailId = (String)sobj.get(emailSep);
                        if(emailId != null){
                             emailAddresses.addAll(emailId.split(','));
                        }
                     }
                    
                }
                
                if(action == 'Removed'){
                     templateName = processStepCacheList.get(0).SendToOwnerEmailTemplate__r.name;
                }
                if(processStepCacheList.get(0).NotifyPreviousApprovers__c == true){
                     List<ProcessInstanceStep> processInstance = [SELECT Id,ActorId,OriginalActorId,ProcessInstanceId,StepStatus,ProcessInstance.ProcessDefinitionId,ProcessInstance.TargetObjectId 
                     FROM ProcessInstanceStep where  ProcessInstance.TargetObjectId = :recordId And StepStatus='Approved' WITH USER_MODE]; //CRUD/FLS False +ve As per business scenario we can't check for portal/external users
                     for(ProcessInstanceStep actor : processInstance){
                        emailAddresses.add(actor.ActorId);
                     }
                }
                if(emailAddresses.size() > 0 && templateName != null) {     
                        for(String emailStr : emailAddresses) {
                            //check pattern
                            EmailFeeder emailFeeder = new EmailFeeder();
                            if(isValidSalesforceId(emailStr)){
                                 emailFeeder.contextRecordId(recordId).template(templateName).TargetObjectId(emailStr);
                                 emailFeeders.add(emailFeeder); 
                            }
                            else{
                                 emailFeeder.contextRecordId(recordId).template(templateName).toEmail(emailStr);
                                 emailFeeders.add(emailFeeder); 
                            }
                            
                        }
                        EmailFeeder.SendEmails(emailFeeders);
                } 
           }
        }
        
         public static Boolean isValidSalesforceId( String sfdcId){
             try {
    
                if ( Pattern.compile( '[a-zA-Z0-9]{15}|[a-zA-Z0-9]{18}' ).matcher( sfdcId ).matches() ){
                   
                    return true;
                }
            } catch ( Exception e ){
            }
    
            return false;
        }
    /*
    Author : Sonali
    Truncate the subject if it is more than 255 characters
    */      
    private static String  truncateSubject(String subjectToTruncate) {
        if(subjectToTruncate != null) {
            // maxSize allowed is 255;
            if(subjectToTruncate.length() > 255 ){
                subjectToTruncate = subjectToTruncate.substring(0, 255);
            }
        }
        return subjectToTruncate;
     }

     global static List<Task> createBulkTasksFor2(List<TaskBulkClass> bulkList, boolean create){
        //Contains Group Name as key and List of Group Members as Values 
        Map<String, Set<GroupMember>> groupNameMemberMap = new Map<String, Set<GroupMember>>();
        Set<String> queueNames = new Set<String>();
        List<String> taskAction = new List<String> ();
        Boolean isQueueAssigned = false;
        for(TaskBulkClass bulkInstance : bulkList){
            if(!String.isEmpty(bulkInstance.groupName)){
                queueNames.add(bulkInstance.groupName);
                isQueueAssigned = true;
            }
            taskAction.add(bulkInstance.action);
        }
        if(isQueueAssigned){
                List<GroupMember> groupMembers = [SELECT Id, GroupId, UserOrGroupId, Group.DeveloperName 
                                                FROM GroupMember
                                                where Group.type='Queue' and Group.DeveloperName in :queueNames 
                                                WITH USER_MODE];//CRUD/FLS False +ve with the help of Schema we have performed the check
            for(GroupMember memberInstance : groupMembers){
                if(groupNameMemberMap.get(memberInstance.Group.DeveloperName) == null){
                    Set<GroupMember> memberList = new Set<GroupMember> (); 
                    memberList.add(memberInstance);
                    groupNameMemberMap.put(memberInstance.Group.DeveloperName, memberList);
                }
            }
        }
        taskConfig = TaskCreationHandler.getTaskConfig(taskAction, 'MyTasks');
        if(taskConfig!= null){
            for(TaskConfig__c config : taskConfig){
                List<TaskConfig__c> taskConfigs = taskActionConfigMap.get(config.TaskAction__c);
                if(taskConfigs == null){
                    taskConfigs= new List<TaskConfig__c>(); 
                }
                taskConfigs.add(config);
                taskActionConfigMap.put(config.TaskAction__c,taskConfigs);
            }   
        }

        Set<Id> activeUsers = getActiveUsers(bulkList, groupNameMemberMap);
        List<Task> taskList = initializeBulkTasks(bulkList, groupNameMemberMap, activeUsers);
        if(create == true){
            if(Schema.sObjectType.Task.isCreateable()){
                insert as user taskList;
            }
        }
        return taskList;
    }
    
      global static List<Task> createTasks2(Id ownerUserId, Id recordId, String action, String recordName, String groupName, Boolean taskCompleted, Date dueDate, String taskType, String subject, Boolean associateWithApproval, boolean create){
         List<String> taskAction = new List<String> ();
         taskAction.add(action);
         taskConfig = TaskCreationHandler.getTaskConfig(taskAction);
         String isAssociatedWithApproval;
         if(taskConfig!= null){
            for(TaskConfig__c config : taskConfig){
                isAssociatedWithApproval = config.IsAssociatedwithApproval__c;
                List<TaskConfig__c> taskConfigs = taskActionConfigMap.get(config.TaskAction__c);
                taskConfigs.add(config);
                taskActionConfigMap.put(config.TaskAction__c,taskConfigs);
            }   
            if(String.isEmpty(subject) && taskConfig.size() > 0 ) {
                //subject = truncateSubject(taskConfig.get(0).Subject__c) ;
                subject = truncateSubject(AppUtils.replaceMergeFields(taskConfig.get(0).Subject__c,recordId));
            } 
        }

        List<Task> taskList = new List<Task>();
        Task taskInstance = initializeTask(ownerUserId,recordId, action, recordName, taskCompleted, dueDate);
        if((isAssociatedWithApproval == 'Null' || isAssociatedWithApproval == 'Yes' || isAssociatedWithApproval == null) && associateWithApproval == true){
                List<ProcessInstanceWorkitem> workItemList = [SELECT id, Actor.Type, ActorId 
                                                    FROM ProcessInstanceWorkitem 
                                                    WHERE ProcessInstance.TargetObjectId = :recordId 
                                                    LIMIT 1];  //False +ve - CRUD/ FLS - STD OBJECT will not check permission 
                if(String.isEmpty(taskType) != true && Schema.sObjectType.Task.fields.Type.isCreateable()){
                    taskInstance.Type = taskType;
                }     
        }       
        subject = AppUtils.replaceMergeFields(subject,recordId);
        //if(Schema.sObjectType.Task.fields.Subject.isCreateable()){
                        taskInstance.Subject = truncateSubject(subject);//CRUD/FLS False Positive:
        //}
       
        if(String.isEmpty(groupName)){
                          taskInstance.OwnerId = ownerUserId; // CRUD/FLS False Positive: Id field 
            copyTaskConfig(taskInstance,ownerUserId,action, dueDate);
            taskList.add(taskInstance);
        }

             if(create == true && Schema.sObjectType.Task.isCreateable()){
                insert as user taskList;
            }
        return taskList;
    }
       


    /*
        Method created for enhancment in createTask method
    */
    global static List<Task> createTasksEnhanced2(Id ownerUserId, SObject record, String action, String recordName, String groupName, Boolean taskCompleted, Date dueDate, String taskType, String subject, Boolean associateWithApproval, boolean create){
 
       List<String> taskAction = new List<String> ();
       taskAction.add(action);
       taskConfig = TaskCreationHandler.getTaskConfig(taskAction);
       String isAssociatedWithApproval;
       if(taskConfig!= null){
          for(TaskConfig__c config : taskConfig){
              isAssociatedWithApproval = config.IsAssociatedwithApproval__c;
              List<TaskConfig__c> taskConfigs = taskActionConfigMap.get(config.TaskAction__c);
            
              taskConfigs.add(config);
              taskActionConfigMap.put(config.TaskAction__c,taskConfigs);
          }   
          
      }

      List<Task> taskList = new List<Task>();
      Task taskInstance = initializeTask(ownerUserId,record.Id, action, recordName, taskCompleted, dueDate);
        if(Schema.sObjectType.ProcessInstanceWorkitem.fields.Id.isAccessible()) {
            if((isAssociatedWithApproval == 'Null' || isAssociatedWithApproval == 'Yes' || isAssociatedWithApproval == null) && associateWithApproval == true){

          List<ProcessInstanceWorkitem> workItemList = [SELECT id, Actor.Type, ActorId 
                                                        FROM ProcessInstanceWorkitem 
                                                        WHERE ProcessInstance.TargetObjectId = :record.Id 
                                                         LIMIT 1];  //STD OBJ
               
          }    
      }

        if(String.isEmpty(taskType) != true && Schema.sObjectType.Task.fields.Type.isCreateable()){
              taskInstance.Type = taskType;
      }
      subject = AppUtils.replaceMergeFields(subject,record);
      //taskInstance.Subject = subject;
        //if(Schema.sObjectType.Task.fields.Subject.isCreateable()){CRUD/FLS False Positive:
            taskInstance.Subject = truncateSubject(subject);//CRUD/FLS False Positive:
      //}
     
          taskList = initializeGroupTasks(groupName, taskInstance,action,dueDate, null, false);
      

        if(create == true && Schema.sObjectType.Task.isCreateable()){
              insert as user taskList;
          }
      return taskList;
  }
}