public with sharing class ApprovalProcessStepCacheTriggerHelper extends TriggerHelper{
    public override void processBeforeInsert() {        
        updateSObjectConfig();
        populateIds();
        validateJson();
    }
    
    public override void processBeforeUpdate() {        
        updateSObjectConfig();
        populateIds();
        validateJson();
    }
    
    //throw error is JSON is wrong
    private void validateJson() {
        Map<String,Object> jMap = new Map<String,Object>();
         for(ApprovalProcessStepCache__c apsc: (List<ApprovalProcessStepCache__c>)trigger.new){
                if(String.isNotEmpty( apsc.TimeForApproval__c )){
                    try {
                     Map<String,String> timeApprovalMap = (Map<String,String>)JSON.deserialize(SFDCEncoder.sanitizeJSON(apsc.TimeForApproval__c), Map<String,String>.Class);// false+ for Deserializing objects from an untrusted source is security-sensitive as sanitizing it by using SFDCEncoder.sanitizeJSON
                    } catch(Exception ex) {
                        apsc.addError('TimeForApproval__c data is incorrect. Please correct data. Process Def Name:' + apsc.ProcessDefinitionName__c
                        + ':Step Name:' + apsc.Name + ':Approval Step Id:' + apsc.ApprovalStepId__c + ':Internal Unique Id:' + apsc.InternalUniqueId__c);
                    }
                     
                }
         }
     }
                     
     //populate Approval step Id and approval Def Id as those are specific to org.
     private void populateIds() {
        List<String> fieldStepDevNames = new List<String>();
        for(ApprovalProcessStepCache__c apsc: (List<ApprovalProcessStepCache__c>)trigger.new){
            fieldStepDevNames.add(apsc.Name);
        }
        Map<String, ProcessNode> processNodeByUniqueName = new Map<String, ProcessNode>();
        if(ProcessNode.sObjectType.getDescribe().isAccessible() == true){
            List<ProcessNode> processNodes = [select Id, Name, DeveloperName, ProcessDefinitionId, ProcessDefinition.DeveloperName from ProcessNode 
                    where DeveloperName in:fieldStepDevNames WITH USER_MODE]; //CRUD/FLS False +ve As per business scenario we can't check for portal/external users
            for(ProcessNode pn : processNodes) {
                processNodeByUniqueName.put(pn.ProcessDefinition.DeveloperName + pn.DeveloperName, pn);
            }
        }
        for(ApprovalProcessStepCache__c apsc : (List<ApprovalProcessStepCache__c>)trigger.new){
            ProcessNode pn = processNodeByUniqueName.get(apsc.ProcessDefinitionName__c + apsc.Name);
            if(pn == null) {
                apsc.addError('Approval process step not found. Please correct data. Process Def Name:' + apsc.ProcessDefinitionName__c
                    + ':Step Name:' + apsc.Name + ':Approval Step Id:' + apsc.ApprovalStepId__c + ':Internal Unique Id:' + apsc.InternalUniqueId__c);
            } else {
                apsc.ApprovalStepId__c = pn.Id;
                apsc.ApprovalDefinitionId__c = pn.ProcessDefinitionId;
                }
         }
     }
     
    //associate record with sobject config
    public void updateSObjectConfig() {
       Set<String> setSobjectName = new Set<String>();
       Map<String,SobjectConfig__c> setSobjectMap = new Map<String,SobjectConfig__c>();
       
       for(ApprovalProcessStepCache__c apsc: (List<ApprovalProcessStepCache__c>)trigger.new){
          setSobjectName.add(apsc.SobjectText__c);
       }
       if(Schema.sObjectType.SobjectConfig__c.isAccessible()){
            for(SobjectConfig__c sc:[SELECT Name,Id from SobjectConfig__c where Name IN :setSobjectName WITH USER_MODE]){ //sf review
                setSobjectMap.put(sc.Name,sc);
            }
        }
    
    //Update sobject id 
       for(ApprovalProcessStepCache__c apscs: (List<ApprovalProcessStepCache__c>)trigger.new){
         SobjectConfig__c sobj =  setSobjectMap.get(apscs.SobjectText__c);
           if(sobj !=null){
               apscs.Sobject__c = sobj.Id;
           } else {
                apscs.addError('Sobject config record not found. Please correct data. Process Def Name:' + apscs.ProcessDefinitionName__c
                    + ':Step Name:' + apscs.StepName__c + ':Approval Step Id:' + apscs.ApprovalStepId__c + ':Sobject Name:' + apscs.SobjectText__c);
           }
         
       }
    }
}