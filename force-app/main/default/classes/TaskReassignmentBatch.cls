//Moved ProcessInstanceWorkitem query into without sharing context
global with sharing class TaskReassignmentBatch implements Database.Batchable < sObject >, Database.Stateful{
    
    private String query;
    private Set<Id> idSet;
    private Id oldOwnerId;
    private Id newOwnerId;
    private List<Id> processedTaskIdList;
    private Set<Id> failIDsLst;
    private Map<String,Id> taskworkItemMap;
    global TaskReassignmentBatch (Set<Id> idSet, Id oldOwnerId, Id newOwnerId){
        this.idSet = idSet;
        this.oldOwnerId = oldOwnerId;
        this.newOwnerId = newOwnerId;
        this.processedTaskIdList = new List<Id>();
        this.failIDsLst = new Set<Id>();
        this.taskworkItemMap = new Map<String,Id>();
    }
    
    global Database.QueryLocator start(Database.BatchableContext batchableCon){
        List<String> allowedStatus = new List<String>();
        allowedStatus.add('In Progress');
        allowedStatus.add('Not Started');
        query = 'Select id, ownerId, WorkitemId__c, WhatId from Task Where OwnerId = :'+String.escapeSingleQuotes(oldOwnerId)+'AND Status IN :allowedStatus';
        if(idSet != null){
            List<Id> idList = new List<Id>();
            idList.addAll(idSet);
            query = query + ' and id In: idList WITH USER_MODE';
        }else{
            query = query + ' WITH USER_MODE';
        }
        return Database.getQueryLocator(String.escapeSingleQuotes(query));
    }
    
     global void execute(Database.BatchableContext batchableCon, List <sObject> scope){
        Savepoint sp = Database.setSavepoint();
        try{
            Set<Id> workItemIdSet = new Set<Id>();
            if( Schema.sObjectType.Task.fields.ownerId.isUpdateable() && Schema.sObjectType.Task.fields.ReassignedFrom__c.isUpdateable() && Schema.sObjectType.Task.fields.IsReassignmentInitiated__c.isUpdateable()){
                for(Task tsk : (List<Task>) scope){
                    tsk.ownerId = newOwnerId;
                    tsk.ReassignedFrom__c = oldOwnerId;
                    tsk.IsReassignmentInitiated__c = false;
                    if(tsk.WorkitemId__c != null){
                        workItemIdSet.add(tsk.WorkitemId__c);
                        taskworkItemMap.put(tsk.WorkitemId__c,tsk.Id);
                    }
                    processedTaskIdList.add(tsk.Id);
                }
            }
            if(workItemIdSet.size() > 0){
                reassignApprovalProcesses(workItemIdSet);
            }
                SystemContextMethodsHelper cls = new SystemContextMethodsHelper();
                String sObjName = cls.getSobjectName(scope[0]);
                if(Apputils.isObjectUpdateable(sObjName)){ //CRUD/FLS False +ve sobject CRUD performed with the help of other class
		            Database.SaveResult[] lsr = Database.update(scope,false, AccessLevel.USER_MODE);
		            Integer recordid = 0;
		           
		            for(Database.SaveResult sr: lsr){
		                if(!sr.isSuccess()){
		                    failIDsLst.add(scope[recordid].id);
		                }
		                recordid++ ;
		            }
		
		            //share related records to reassigned users
		            shareRecordToReassignedUser();
		        }
        }
        catch(Exception e){
             Database.rollback( sp );
         // Reverting IsReassignmentInitiated__c intalize to false
            if(Schema.sObjectType.Task.fields.IsReassignmentInitiated__c.isUpdateable() 
            && Schema.sObjectType.Task.fields.IsReassignmentInitiated__c.isCreateable()){
                for(Task tsk : (List<Task>) scope){
                    tsk.IsReassignmentInitiated__c = false;
                }
            }
            if(Schema.sObjectType.Task.isUpdateable() && Schema.SObjectType.Task.isCreateable()){
                upsert as user scope;
            }
        }
    }
    
    global void finish(Database.BatchableContext batchableCon) {
        // Is ReassignInsitted back to false for failed RecordsId
        try{
            List<Task> newUpdateTaskLst = new List<Task>();
            if(failIDsLst.size() > 0 ){
                for(Id tskId : failIDsLst){
                    Task tsk = new Task();
                    if(Schema.sObjectType.Task.isUpdateable() && Schema.sObjectType.Task.isCreateable()){
                        tsk.id =  tskId; // CRUD/FLS False Positive: Id field 
                    }
                    if(Schema.sObjectType.Task.fields.IsReassignmentInitiated__c.isUpdateable() && Schema.sObjectType.Task.fields.IsReassignmentInitiated__c.isCreateable()){
                        tsk.IsReassignmentInitiated__c = false;
                    }
                    newUpdateTaskLst.add(tsk);
                }
                if(Schema.sObjectType.Task.isUpdateable() && Schema.sObjectType.Task.isCreateable()){ // Security Scan FLS Update
                    upsert as user newUpdateTaskLst;
                }
            }

            // send email
            Set<String> fieldsSet = new Set<String>();
            String fldsToQuery = KeyValueStoreHelper.getTextValue('TaskReassignmentEmailFields',true);
            fldsToQuery = fldsToQuery == null ? 'id' : !fldsToQuery.containsIgnoreCase('id') ? 'id,'+fldsToQuery :fldsToQuery;

            fieldsSet.addAll(fldsToQuery.split(','));
            String query = 'Select '+ String.escapeSingleQuotes(fldsToQuery) + ' FROM task WHERE Id IN : processedTaskIdList WITH USER_MODE';
            List<Task> tskList =  Database.query(String.escapeSingleQuotes(query));
            if(tskList.size() > 0){
                sendEmail(tskList,fieldsSet);
            }
        }
        catch(Exception e){
             CustomExceptions.logException(e, true, false);
        }
    }
    
    private void shareRecordToReassignedUser(){
        Map<String, String> taskIdToObjTypeMap = new Map<String, String>();
        List<SObject> RecordShareList = new List<SObject>();
        String objName = '';
        Map<Id, Task> tskMap;
        if(Schema.sObjectType.task.fields.Id.isAccessible()){
            tskMap = new Map<Id, Task>([Select Id, OwnerId, ParentOwnerId__c, What.type from task 
            Where Id IN : processedTaskIdList ORDER BY What.Type]);  
            
        for(Id tskId : tskMap.keySet()){
            Task tsk = tskMap.get(tskId);
            String str = tsk.What.Type;
            Schema.SObjectType testShareType = chkHasShare(str); 
            if(testShareType != null){
                SObject testShare = testShareType.newSObject();
                testShare.put('ParentId', tsk.What.id);
                testShare.put('UserOrGroupId',newOwnerId);
                testShare.put('AccessLevel', 'edit');
                RecordShareList.add(testShare);
            }else{
                List<Sobject> objectResult = new List<Sobject>();
                
                Id recId = String.escapeSingleQuotes(tsk.What.id);
                Map<String,Object> shareMasterMap = getMasterShare(str,null);
                SObject testMasterShare = (SObject)shareMasterMap.get('masterSobject');
                String shareParentAPIName = (String) shareMasterMap.get('shareParentAPIName');
                if(String.isBlank(objName)){ //added for SF review
                    objName = testMasterShare.Id.getSobjectType().getDescribe().getName();
                } 
                SObjectType objectType = ((SObject)Type.forName('Schema', objName).newInstance()).getSObjectType();

                String query = 'SELECT ' +SchemaManager.getFields(shareParentAPIName)+ ' FROM ' +String.valueOf(tsk.What.id.getSobjectType())+ ' WHERE  Id =:recId WITH USER_MODE';
                objectResult = Database.query(String.escapeSingleQuotes(query));
                Id parIdVal;
                if(shareParentAPIName !=null && shareParentAPIName.contains('__r')){
                    String[] sharAPIArr = shareParentAPIName.split('__r');
                    String sobjParStr = sharAPIArr[0]+'__r';
                    String sobjFieldAPI = sharAPIArr[1].replace('.','');
                    SObject sobjPr = objectResult[0].getSObject(sobjParStr);
                    parIdVal = (Id) sobjPr.get(sobjFieldAPI);
                }else{
                    parIdVal = (Id)objectResult[0].get(shareParentAPIName);
                }
                testMasterShare.put('ParentId', parIdVal);
                testMasterShare.put('UserOrGroupId', newOwnerId);
                if(objectType.getDescribe().fields.getMap().get('AccessLevel').getDescribe().isUpdateable()){
                	testMasterShare.put('AccessLevel', 'read');
                }
                RecordShareList.add(testMasterShare);
            }
       }
        }
    if(AppUtils.isObjectAccessible(objName) && AppUtils.isObjectCreateable(objName)) { //Added for SF review  
    insert as user RecordShareList; //CRUD/FLS False +ve with the help of AppUtils we have performed check
    }
}
    
// Iterating over Object to get MD Relationship Field Object to get Share Record....
private Map<String,Object> getMasterShare(String objectAPIName, String sharePAIName){

    String shareParentAPIName = sharePAIName != null?sharePAIName:null;
    Map<String,Object> returnMap = new Map<String,Object>();
    Map<String, Schema.SObjectField> fieldMap = Schema.getGlobalDescribe().get(objectAPIName).getDescribe().fields.getMap();
    String objAPIName;
    Sobject sobjRes;
    Schema.SObjectType shareSobjectTest;
    for(String fieldAPIName: fieldMap.keySet()){
        Schema.DescribeFieldResult fval = fieldMap.get(fieldAPIName).getDescribe();

        if(fval.isCascadeDelete()){
            if(fval.isNamePointing() == false){
                Schema.SObjectType ref = fval.getReferenceTo()[0];
                objAPIName = ref.getDescribe().getName();
                if(String.isNotEmpty(shareParentAPIName)){
                    shareParentAPIName = shareParentAPIName + '.' + fval.getName();
                } else {
                    shareParentAPIName = fval.getName();
                }
                break;
            }  
        }
    }

    if(String.isNotEmpty(objAPIName)){
        shareSobjectTest = chkHasShare(objAPIName);
    }

    if(shareSobjectTest == null){
        shareParentAPIName = shareParentAPIName.replace('__c', '__r');
       returnMap = getMasterShare(objAPIName, shareParentAPIName);
       return returnMap;
    }else{
        sobjRes = shareSobjectTest.newSObject();
    }
    
    
    if(sobjRes != null && shareParentAPIName != null){
        
        returnMap.put('shareParentAPIName', shareParentAPIName);
        returnMap.put('masterSobject', sobjRes); 
             
    }
    
    return returnMap;  
}

// Method to check for Object have share permission/ or access..
private Schema.SObjectType chkHasShare(String objectShareName){
    Schema.SObjectType shareSobjectTest;
    objectShareName = objectShareName.removeEnd('__c');
    objectShareName = objectShareName + '__Share';
    shareSobjectTest =  Schema.getGlobalDescribe().get(objectShareName);
    return shareSobjectTest;
}
    
  
    private void reassignApprovalProcesses(Set<Id> workItemIdSet){
        
        List<ProcessInstanceWorkitem> workItemList = new List<ProcessInstanceWorkitem>();
        SystemContextMethodsHelper cls = new SystemContextMethodsHelper();
        workItemList = cls.getProcessInstWorkitem(workItemIdSet);
        
        for(ProcessInstanceWorkitem workItem : workItemList){
            workItem.ActorId = newOwnerId;
        }
        if(Schema.sObjectType.ProcessInstanceWorkitem.isUpdateable()){
            Database.SaveResult[] lsr = Database.update(workItemList,false, AccessLevel.USER_MODE);
            Integer recordid = 0;
           
            for(Database.SaveResult sr: lsr){
                if(!sr.isSuccess()){
                    Id tskId = taskworkItemMap.get((String)workItemList[recordid].id);
                    failIDsLst.add(tskId);
                }
                recordid++ ;
            }      
        }
    }
    
    private void sendEmail(List<Task> tskList, Set<String> fields){ 
        List<User> userList = [Select id, Name, Email from User Where Id = :oldOwnerId OR Id = : newOwnerId WITH USER_MODE];
        String [] toadd = new List<String>();
        String oldUserName;
        String newUserName;
        for(User usr : userList){
            if(usr.Id == oldOwnerId){
                oldUserName = usr.Name;
            }else{
                newUserName = usr.Name;
            }
            toadd.add(usr.Email);
        }
        
        Messaging.Email[] emailList = new Messaging.Email[0];
        Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
        String subject = 'Task Reassignment Report';
        String Emails = String.join(emailList,',');
        String ToAddress= String.join(toadd,',');
        EmailFeeder emailFeederObj = new EmailFeeder().toEmail(ToAddress).subject(subject).htmlBody(getTableEmailBody(tskList, oldUserName, newUserName,fields)); 
        emailFeederObj.send();
    //    message.setToAddresses(toadd);
    //    message.setSaveAsActivity(false);
    //    message.setSubject(subject);
    //    message.setHtmlBody();
   //     emailList.add(message);
    //    Messaging.sendEmail(emailList);
    }
    
    private string getTableEmailBody(List<Task> tskList, String oldUserName, String newUserName, Set<String> fields){
        
        String htmlBody = 'Hello,</br>';
        htmlBody +='</br>Below tasks has been reassigned from '+oldUserName+' to '+newUserName+' successfully. Please find the details below:</br></br>';
        // style variables
        String tdStyle = 'font-size: 1.2em !important;border: 1px solid #98bf21 !important;padding: 3px 7px 2px 7px !important; font-family: verdana !important;';
        String trStyle = ''; //'color: #000000 !important;background-color: #EAF2D3 !important;';
        String thStyle = ''; //'font-size: 1.3em !important;text-align: left !important;padding-top: 5px !important;padding-bottom: 4px !important;background-color: #A7C942;color: #ffffff;padding: 3px 7px 2px 7px !important;';
        String tableStyle = 'border-collapse: collapse !important;font-family: verdana !important;width: 50% !important;';
        //open table..
        htmlBody += '<table border="1" style="'+tableStyle+'"><tr style="'+trStyle+'"><th style="'+thStyle+'">ID</th><th style="'+thStyle+'">Task Type</th><th style="'+thStyle+'">Due Date</th><th style="'+thStyle+'">Assigned By</th></tr>'; // 
        //iterate over list and output columns/data into table rows...
        for(Task tsk : tskList){
            htmlBody+= '<tr style="'+trStyle+'">';
            for(String fld : fields){
               htmlBody += '<td style="'+tdStyle+'">' + tsk.get(fld) + '</td>';
            }
        }
        //close table...
        htmlBody += '</table>';
        htmlBody += '</br></br>Sincerely,</br></br>Enterprise Grants Management System(EGMS)</br>';
        return htmlBody;
    }
}