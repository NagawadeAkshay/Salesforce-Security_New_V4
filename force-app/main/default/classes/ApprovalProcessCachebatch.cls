/*
* Author - Pankaj H.
* Description - Batch will create approval step cache records. Those records are mimic of salesforce approval step records.
*/
global with sharing class ApprovalProcessCachebatch implements Database.Batchable<sObject>, Database.AllowsCallouts{
    
    Map<String, Map<String, ProcessNode>> processNodesByApprovalDef;
    List<ProcessDefinition> processDefns;
    String sessionId;
    global ApprovalProcessCachebatch() {
        
    }
    
    global ApprovalProcessCachebatch(String sessionId) {
        this.sessionId = sessionId;
    }
    
    global Database.QueryLocator start(Database.BatchableContext bachableCon) {
        String strFilterState = String.escapeSingleQuotes('Active');
        return Database.getQueryLocator('SELECT Id, DeveloperName, State, Type, TableEnumOrId FROM ProcessDefinition WHERE State =: strFilterState WITH USER_MODE'); //CRUD/FLS False +ve As per business scenario we can't check for portal/external users 
    }
    
    global void execute(Database.BatchableContext bachableCon, List<sObject> scope){
        refreshCache((List<ProcessDefinition>)scope);
    }
    
    global void finish(Database.BatchableContext bachableCon){
        
    }
    
    public void refreshCache(List<ProcessDefinition> processDefn) {
        try {
            this.processDefns = processDefn;
            updateCache(getMetadata());

        } catch(Exception ex) {
            CustomExceptions.LogException(ex, true, false);
        }
    }
    
    public MetadataService.ApprovalProcess[] getMetadata() {
        List<String> approvalProcesses = new List<String>();
        Set<String> processDefIds = new Set<String>();
        for(ProcessDefinition processDefn : processDefns) {
            approvalProcesses.add(processDefn.TableEnumOrId + '.' + processDefn.DeveloperName);
            processDefIds.add(processDefn.Id);
        }
        
        List<ProcessNode> processNodes = [select Id, Name, DeveloperName, ProcessDefinitionId, ProcessDefinition.DeveloperName from ProcessNode where ProcessDefinitionId in:processDefIds WITH USER_MODE]; //CRUD/FLS False +ve As per business scenario we can't check for portal/external users 
        processNodesByApprovalDef = new Map<String, Map<String, ProcessNode>>();
        for(ProcessNode procecssNde : processNodes) {
            if(!processNodesByApprovalDef.ContainsKey(procecssNde.ProcessDefinitionId)) {
                processNodesByApprovalDef.put(procecssNde.ProcessDefinitionId, new Map<String, ProcessNode>());
            }
            processNodesByApprovalDef.get(procecssNde.ProcessDefinitionId).put(procecssNde.DeveloperName, procecssNde);
        }
        MetadataService.MetadataPort service = new MetadataService.MetadataPort();
        service.SessionHeader = new MetadataService.SessionHeader_element();
        service.SessionHeader.sessionId = UserInfo.getSessionId();
        MetadataService.ReadApprovalProcessResult result = (MetadataService.ReadApprovalProcessResult) service.readMetadata('ApprovalProcess', approvalProcesses);
        MetadataService.ApprovalProcess[] approvalProcList = (MetadataService.ApprovalProcess[]) result.getRecords();
        return approvalProcList;
    }
        
    /*
    * Describe call to salesforce because we don't get step number using SOQL query on ProcessNode object. If there is error make sure we have entry
    * Remote site setting.
    */    
    public void updateCache(MetadataService.ApprovalProcess[] approvalProcList) { 
        Map<String, ProcessDefinition> processDefByDevName = new Map<String, ProcessDefinition>();
        for(ProcessDefinition processDefn : processDefns) {
            processDefByDevName.put(processDefn.DeveloperName, processDefn);
        }
        List<ApprovalProcessStepCache__c> approvalSteps = new List<ApprovalProcessStepCache__c>();
        for(MetadataService.ApprovalProcess approvalProcess : approvalProcList) {
            MetadataService.ApprovalStep[] approvalStepList = approvalProcess.ApprovalStep;
            ProcessDefinition procesDef = processDefByDevName.get(approvalProcess.fullName.split('\\.')[1]);
            Integer stepNo = 1;
            if(approvalStepList != null){
                for(MetadataService.ApprovalStep approvalStep : approvalStepList) {
                    ProcessNode processnd = processNodesByApprovalDef.get(procesDef.Id).get(approvalStep.Name);
                    ApprovalProcessStepCache__c approvalProcessCache = new ApprovalProcessStepCache__c(ApprovalDefinitionId__c=procesDef.Id, ApprovalStepId__c=processnd.Id,
                                                StepName__c=approvalStep.Label, StepNumber__c=stepNo, Name = approvalStep.Name, 
                                                SobjectText__c=procesDef.TableEnumOrId, allowDelegate__c = approvalStep.allowDelegate,
                                                ProcessDefinitionName__c = processnd.ProcessDefinition.DeveloperName);
                    if(Schema.sObjectType.ApprovalProcessStepCache__c.fields.assignedApprover__c.isCreateable() && Schema.sObjectType.ApprovalProcessStepCache__c.fields.assignedApprover__c.isUpdateable()){
                        if(approvalStep.assignedApprover != null) {
                            approvalProcessCache.assignedApprover__c = JSON.serialize(approvalStep.assignedApprover);
                        } else {
                            approvalProcessCache.assignedApprover__c = null;
                        }
                    }
                    if(Schema.sObjectType.ApprovalProcessStepCache__c.fields.EntryCriteria__c.isCreateable() && Schema.sObjectType.ApprovalProcessStepCache__c.fields.EntryCriteria__c.isUpdateable()){
                        if(approvalStep.entryCriteria != null) {
                            approvalProcessCache.EntryCriteria__c = JSON.serialize(approvalStep.entryCriteria);
                        } else {
                            approvalProcessCache.EntryCriteria__c = null;
                        }
                    }
                    approvalSteps.add(approvalProcessCache);
                    stepNo++;
                }
            }
        }
        if(Schema.sObjectType.ApprovalProcessStepCache__c.isCreateable() && Schema.sObjectType.ApprovalProcessStepCache__c.isUpdateable()){
            upsert as user approvalSteps ApprovalStepId__c;
        }
    }
}