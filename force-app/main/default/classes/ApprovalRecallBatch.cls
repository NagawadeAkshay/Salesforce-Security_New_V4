// this batch gets executed on click of recall. On Click of recall we send email to email service and email servie will invoke this batch.
global with sharing class ApprovalRecallBatch  implements Database.Batchable<sObject> , Database.Stateful{
    public static String query = 'SELECT Id, Name, ApprovalReCallFieldAPIName__c, ApprovalReCallCommentFieldAPIName__c FROM SobjectConfig__c WHERE ApprovalReCallEnable__c = true AND ApprovalReCallFieldAPIName__c != null';
    global Database.QueryLocator start(Database.BatchableContext bachableCon) {        
        return Database.getQueryLocator(String.escapeSingleQuotes(query), AccessLevel.USER_MODE);
    }

    //batch size = 1
    global void execute(Database.BatchableContext bachableCon, List<SobjectConfig__c> scope) {
        processRecords(scope);
    }
    
    global void finish(Database.BatchableContext bachableCon) {
    }
    
    public static void processRecords(List<SobjectConfig__c> scope) {
        List<SObject> sobjListToUpdate = new List<SObject>();
        String objName = '';
        for(SobjectConfig__c sobjConfig : scope) {
            String commentField = sobjConfig.ApprovalReCallCommentFieldAPIName__c != null ? ','+sobjConfig.ApprovalReCallCommentFieldAPIName__c : '';
            String query = 'SELECT Id ' + String.escapeSingleQuotes(commentField) + ' FROM ' + String.escapeSingleQuotes(sobjConfig.Name) + ' WHERE ' + String.escapeSingleQuotes(sobjConfig.ApprovalReCallFieldAPIName__c)+ ' = true';
            for(SObject sobj : Database.query(query, AccessLevel.USER_MODE)) { //SOQL Injection - False +ve - Dynamic part of query is escapeSingleQuotes
                if(String.isBlank(objName)){ //added for SF review
                    objName = sobj.Id.getSobjectType().getDescribe().getName();
                } 
                recall((String)sobj.get('Id'), sobjConfig.ApprovalReCallCommentFieldAPIName__c != null ? (String) sobj.get(sobjConfig.ApprovalReCallCommentFieldAPIName__c): 'Recall', null);
                
                if(Schema.SObjectType.SobjectConfig__c.fields.ApprovalReCallFieldAPIName__c.isUpdateable() &&
                Schema.SObjectType.SobjectConfig__c.fields.ApprovalReCallFieldAPIName__c.isAccessible()){
                    sobj.put(sobjConfig.ApprovalReCallFieldAPIName__c, false);
                sobjListToUpdate.add(sobj);
                }
                
            }
            AppUtils.skipTriggerInRecallBatch = true;

        }
        if(!sobjListToUpdate.isEmpty() && AppUtils.isObjectUpdateable(objName)){ //Added for SF review  
            update as user sobjListToUpdate;//CRUD - False +ve - As this is Sobject with the help of other method we have checked CRUD
        }
    }

    public static void recall(String recordId, String comments, Id userId) {
        List<ProcessInstanceNode> processInstanceNodes = ApprovalDecisionCtrl.getProcessInstanceNodes(recordId);
        List<ApprovalProcessStepCache__c> processStepCacheList = ApprovalDecisionCtrl.getApprovalProcessStepCache(processInstanceNodes);                                                  
        String reassignOwnerId = '';
        //if(processStepCacheList != null && processStepCacheList.size()>0){
        ApprovalDecisionCtrl.notifyAdditionalPeople('Send to Owner',recordId,processStepCacheList,reassignOwnerId);
        List<ProcessInstanceWorkitem> workItemList = new List<ProcessInstanceWorkitem>();
        if(AppUtils.isObjectAccessible('ProcessInstanceWorkitem')){
            workItemList = [SELECT id, ActorId,Actor.Name,ProcessInstance.TargetObjectId FROM ProcessInstanceWorkitem 
                        WHERE ProcessInstance.TargetObjectId = :recordId LIMIT 1]; //CRUD  FLS- False +ve - Std obj  - will not check permission here 
        }  
        if(workItemList.size() == 0) {
            return;
        }
        Approval.ProcessWorkitemRequest workItemRequest = new Approval.ProcessWorkitemRequest();
        workItemRequest.setComments(comments);
        workItemRequest.setAction('Removed');
        workItemRequest.setNextApproverIds(null);
        workItemRequest.setWorkitemId(workItemList.get(0).Id);
        
        Approval.ProcessResult approvalResult =  Approval.process(workItemRequest);
        List<String> approvalInstanceIds = new List<String>();
        for(ProcessInstanceWorkitem processIntanceWorkItem : workItemList){
            approvalInstanceIds.add(processIntanceWorkItem.Id); 
        }
        // close pending task
        ApprovalDecisionCtrl.closePendingTaskWithoutFuture(JSON.serialize(approvalInstanceIds));
        //}
        
        if(userId != null){
        List<ProcessInstance> processInstList = [SELECT Id, (SELECT Id, StepStatus,ProcessNodeId FROM StepsAndWorkitems where StepStatus = 'Removed' 
                                                ORDER BY CreatedDate DESC LIMIT 1 ) 
                                                FROM ProcessInstance WHERE Id =:processInstanceNodes[0].ProcessInstanceId WITH USER_MODE];//CRUD/FLS False +ve As per business scenario we can't check for portal/external users
            if(processInstList.size() > 0) {
               List<ProcessInstanceHistory> processHistList = processInstList[0].StepsAndWorkitems;
                if(processHistList.size() > 0) {                        
                    ApprovalHistoryExtension__c appHistExt = new ApprovalHistoryExtension__c();
                    appHistExt.WorkInstanceItemId__c = processHistList[0].Id;
                        appHistExt.SentToOwnerBy__c = userId;
                    appHistExt.Comments__c = comments;
                    List<SObject> histExtList = new List<SObject>();
                    histExtList.add(appHistExt);
                    SystemContextMethodsHelper systemContextMethodsHelperRef = new SystemContextMethodsHelper();
                    systemContextMethodsHelperRef.insertSobject(histExtList);
                } 
            }
        }
    }
}