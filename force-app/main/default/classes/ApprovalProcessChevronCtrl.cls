/*  This class is used to display the Chevron Graphic
    **********************************************************
    Audit History
    **********************************************************
    08/04/2015   Shrawan Raina      Created
    08/21/2015   Shrawan Raina      Edited
*/
global with sharing class ApprovalProcessChevronCtrl {
    global Id recordId {get;set;}
    private static transient List<ProcessDefinition> procDef {get;set;}
    private static transient Map<String, String> stepOwnerMap {get;set;}
    private static transient Map<String, List<String>> stepFieldMap {get;set;}
    private static transient Map<String, Boolean> stepByVisibility;
    
    global ApprovalProcessChevronCtrl(){
        procDef = new List<ProcessDefinition>();
        stepOwnerMap = new Map<String, String>();
        stepFieldMap = new Map<String, List<String>>();
    }
    
    public with sharing class processWrapper {
        String name;
        String label;
        String actorName;
        Integer color; // 0 - Pending, 1 - Approved, 2 - Rejected
        
        processWrapper() {
            name = '';
            label = '';
            actorName = '';
            color = 0;
        }
    }
    
    @RemoteAction
    global static List<Object> generateApprovalSteps(Id recordId){
            if(recordId != null){
                String sObjectName = recordId.getSObjectType().getDescribe().getName();     
                List<Object> resultList = ApprovalProcessChevronCtrl.fetchProcessInstance(recordId, sObjectName);
                return resultList;
            }
            return null;
    }
        
    public static List<Object> fetchProcessInstance(Id recordId, String sObjectName){
        recordId = String.escapeSingleQuotes(String.valueOf(recordId));
    	List<ProcessInstance> procInstance = new List<ProcessInstance>();
    	String piSOQL = 'SELECT Id, ProcessDefinitionId, ProcessDefinition.Name, TargetObjectId, (SELECT Id, ActorId, Actor.Name, OriginalActor.Name, StepNodeId, StepStatus, Comments FROM Steps ORDER BY StepStatus Desc)' +
                        ' FROM ProcessInstance WHERE TargetObjectId =: recordId ORDER BY CreatedDate Desc LIMIT 1';  //WITH SECURITY_ENFORCED removed because of Polymorphic field
    		procInstance = Database.query(String.escapeSingleQuotes(piSOQL), AccessLevel.USER_MODE);
        
    	if(procInstance.size() == 0) {
    		return null;
    	}
        List<ApprovalProcessStepCache__c> stepList = ApprovalProcessChevronCtrl.fetchProcDefSteps(procInstance[0].ProcessDefinitionId);
        if(stepList.size() == 0) {
        	throw new CustomExceptions.RequiredException('No record found for ApprovalProcessStepCache. Please check object read permission or batch is running.');
        }
        Map<Id, String> processStepMap = ApprovalProcessChevronCtrl.fetchStepMap(recordId, AppUtils.removeNamespacePrefix(sObjectName), stepList, procInstance[0].ProcessDefinitionId);           
        Map<String, String> stepNameByStatus = getStepByStatus(procInstance[0].Id);
        List<ProcessInstanceStep> procSteps = procInstance[0].Steps;
        if(procSteps.size() > 0) {
        	Map<String, List<ProcessInstanceStep>> instanceStepMap = new Map<String, List<ProcessInstanceStep>>(); 
            List<processWrapper> processWrapperList = new List<processWrapper>();
            List<String> processNodeIds = new List<String>();
            for(ProcessInstanceStep step : procSteps) {
                processNodeIds.add(step.Id);
                if(step.StepNodeId == null){
                    processWrapper ownerObj = new processWrapper();
                    ownerObj.name = 'Initial_Step';
                    ownerObj.label = 'Initial Submitter';
                    ownerObj.color = 1;
                    ownerObj.actorName = step.Actor.Name;
                    processWrapperList.add(ownerObj);
                }   
                if(step.StepNodeId != null && processStepMap !=null) {
                	if(instanceStepMap.get(processStepMap.get(step.StepNodeId)) == null) {
                		instanceStepMap.put(processStepMap.get(step.StepNodeId), new List<ProcessInstanceStep>());
                	}
                    instanceStepMap.get(processStepMap.get(step.StepNodeId)).add(step);
                }
            }
            List<ApprovalHistoryExtension__c> approvalHistExtensions = new List<ApprovalHistoryExtension__c>();
            if(Schema.sObjectType.ApprovalHistoryExtension__c.isAccessible()){
                approvalHistExtensions = [SELECT Id, WorkInstanceItemId__c,CreatedBy.Name,Comments__c,SentToOwnerBy__r.Name
                                                                    FROM ApprovalHistoryExtension__c 
                                                                    WHERE WorkInstanceItemId__c in:processNodeIds WITH USER_MODE];
            }
            //Converting into a Wrapper Object list
            Map<Id, String> userByStepId = new Map<Id, String>();
            if(approvalHistExtensions.size() > 0) {
                for(ApprovalHistoryExtension__c ah : approvalHistExtensions) {
                    userByStepId.put(ah.WorkInstanceItemId__c ,ah.SentToOwnerBy__r.Name);
                }
            }
            for(ApprovalProcessStepCache__c step : stepList) {
            	if(stepByVisibility.get(step.Name) == false) continue;
            	processWrapper obj = new processWrapper();
                obj.name = step.Name;
                obj.label = step.StepName__c;
                //Assigning color based on StepStatus 
                if(instanceStepMap.containsKey(step.name)){
                    List<ProcessInstanceStep> piSteps = instanceStepMap.get(step.name);
                    String stepStatus = stepNameByStatus.get(step.name);
                    obj.color = (stepStatus.equals('Approved')) ? 1 : (stepStatus.equals('Rejected')) ? 2 : obj.color;
                    Set<String> actors = new Set<String>();
                    for(ProcessInstanceStep steps : piSteps) {
                    	if(stepStatus.equalsIgnoreCase('Approved') && steps.StepStatus.equalsIgnoreCase('Approved')) {
	                    	actors.add(steps.actor.Name);  
                    	} else if(stepStatus.equalsIgnoreCase('Rejected') && steps.StepStatus.equalsIgnoreCase('Rejected')) {
	                    	actors.add(steps.actor.Name);  
                    	} else if(stepStatus.equalsIgnoreCase('Removed') || stepStatus.equalsIgnoreCase('Pending') && !steps.StepStatus.equalsIgnoreCase('Reassigned') ){
                    		actors.add(steps.OriginalActor.Name);
                            //actors.add(JSON.serialize(userByStepId));
                            //actors.add(steps.Id);
                            
                            if(userByStepId.get(steps.Id) !=  null) {
                               actors.add(userByStepId.get(steps.Id));
                            }
                    	}else if(stepStatus.equalsIgnoreCase('Reassigned') && steps.StepStatus.equalsIgnoreCase('Reassigned') || stepStatus.equalsIgnoreCase('Pending')) {
                            actors.add(steps.actor.Name);  

                        } 
                    }
                    List<String> actorList = new List<String>();
                    actorList.addAll(actors);
                    obj.actorName = String.join(actorList, ', ');
                    //Capturing Actor Name in Wrapper Class
                    //obj.actorName = piStep.Actor.Name;
                } else { //If Step has not entered the status
                    obj.color = 0;
                    //Setting Actor Name from Owner Map if the record has not entered the step
                    if(stepFieldMap.containsKey(step.name)){
                        List<String> ownerList = new List<String>();
                        List<String> fieldList = stepFieldMap.get(step.name);
                        if(fieldList.size() > 0){
                            for(String field : fieldList){
                                if(stepOwnerMap.containsKey(field)){
                                    ownerList.add(stepOwnerMap.get(field));
                                }
                            }
                            obj.actorName = String.join(ownerList, ', ');    
                        } else {
                            obj.actorName = null;
                        }
                    } else {
                		obj.actorName = null;
                    }
                }
                processWrapperList.add(obj);
            }
        	return processWrapperList;
        }
        return null;
    }
    
    public static Map<String, String> getStepByStatus(String processDefnId) {
    	Map<String, String> returnMap = new Map<String, String>();
    	List<ProcessInstanceNode> processNodes = [SELECT ProcessInstanceId,ProcessNode.DeveloperName,ProcessNodeName,NodeStatus FROM 
                                ProcessInstanceNode where ProcessInstanceId = :processDefnId WITH USER_MODE];//CRUD/FLS False +ve As per business scenario we can't check for portal/external users
    	for(ProcessInstanceNode processNode : processNodes) {
    		returnMap.put(processNode.ProcessNode.DeveloperName, processNode.NodeStatus);
    	}
    	return returnMap;
    }
    
    public static List<ApprovalProcessStepCache__c> fetchProcDefSteps(String procDefId) {
		List<ApprovalProcessStepCache__c> steps = new List<ApprovalProcessStepCache__c>();
        if(Schema.sObjectType.ApprovalProcessStepCache__c.isAccessible()){
	    	steps = [SELECT ApprovalStepId__c,EntryCriteria__c,StepName__c,StepNumber__c,Name,assignedApprover__c 
            FROM ApprovalProcessStepCache__c where ApprovalDefinitionId__c=:procDefId WITH USER_MODE order by StepNumber__c asc];
        }
		return steps;
    }
    
    public static Map<Id, String> fetchStepMap(Id recordId, String sObjectName, List<ApprovalProcessStepCache__c> stepList, String procDefId) {
        stepFieldMap = new Map<String, List<String>>();
        Map<Id, String> stepMap = new Map<Id, String>();
        Set<String> stepDevNameSet = new Set<String>();
        Set<String> fieldSet = new Set<String>();
        Sobject record = getRecord(recordId, stepList);
        stepByVisibility = new Map<String, Boolean>();
        for(ApprovalProcessStepCache__c step : stepList){
        	stepByVisibility.put(step.Name, isStepVisible(getStepCriteriaList(step.EntryCriteria__c), record));
            stepDevNameSet.add(step.name);
            if(step.assignedApprover__c != null) {
            	MetadataService.ApprovalStepApprover appr = (MetadataService.ApprovalStepApprover)JSON.deserialize(SFDCEncoder.sanitizeJSON(step.assignedApprover__c), MetadataService.ApprovalStepApprover.Class); // false+ for Deserializing objects from an untrusted source is security-sensitive as sanitizing it by using SFDCEncoder.sanitizeJSON
	            for(MetadataService.Approver approver : appr.approver){
	                if(approver.type_x.equalsIgnoreCase('relateduserfield')){   // Shrawan-11192015 - when type is userHierarchyField (Approval process is using Manager Approval), the Metadata API does not return any name for Assigned Approver
	                    fieldSet.add(AppUtils.removeNamespacePrefix(approver.name));
	                    if(stepFieldMap.containsKey(step.name)) {
	                        List<String> tmpList = stepFieldMap.get(step.name);
	                        tmpList.add(AppUtils.removeNamespacePrefix(approver.name));
	                        stepFieldMap.put(step.name, tmpList);
	                    } else {
	                        stepFieldMap.put(step.name, new List<String> { AppUtils.removeNamespacePrefix(approver.name) });
	                    }
	                }
	            }
            }
        }
        //System.assertEquals('stepCriteriaList.size()', '');
        if(fieldSet.size() > 0) {
        	//TO check if we can reduce this query
            ApprovalProcessChevronCtrl.fetchOwnerMap(recordId, sObjectName, fieldSet);
        } else {
            stepOwnerMap = null;
        }
        List<ProcessNode> procNodeList = new List<ProcessNode>();
        if(ProcessNode.sObjectType.getDescribe().isAccessible() == true){
        	String soql = 'SELECT Id, Name, DeveloperName FROM ProcessNode WHERE ProcessDefinitionId =: procDefId AND DeveloperName IN: stepDevNameSet';
        	procNodeList = Database.query(String.escapeSingleQuotes(soql), AccessLevel.USER_MODE); //SOQL Injection - False +ve - Dynamic part of query is static bind //CRUD/FLS False +ve As per business scenario we can't check for portal/external users
        }
        if(procNodeList.size() > 0){
            for(ProcessNode node : procNodeList){
            	stepMap.put(node.Id, node.DeveloperName);
            }
            return stepMap;
        }
        else
            return null;
    }
    
    public static void fetchOwnerMap(Id recordId, String sObjectName, Set<String> fieldSet){
        stepOwnerMap = new Map<String, String>();
        List<String> relFieldList = new List<String>();
        for(String field : fieldSet){
            relFieldList.add(field.replaceAll('__c$', '__r.Name'));
        }
        String relFields = String.join(relFieldList, ',');
        List<sObject> objList = new List<sObject>();
        //if(AppUtils.isObjectAccessible(AppUtils.removeNamespacePrefix(sObjectName)) == true){
        	String soql = 'SELECT ' + String.escapeSingleQuotes(relFields) + ' FROM ' + String.escapeSingleQuotes(sObjectName) + ' WHERE Id =: recordId';
        	objList = Database.query(String.escapeSingleQuotes(soql), AccessLevel.USER_MODE); //SOQL Injection - False +ve - Dynamic part of query is escapeSingleQuotes/static bind and recordId using escapeSingle in the fetchProcessInstance Method
    	//}
        if(objList.size() > 0){
            for(String field : fieldSet){
                String fieldValue = String.valueOf(ApprovalProcessChevronCtrl.getRelatedFieldValue(objList[0], field.replaceAll('__c$', '__r.Name')));
                if(fieldValue != null && fieldValue != '')
                    stepOwnerMap.put(field, fieldValue);
            }
        }
    }
    
    /*
       Added by Shrawan - 08/25/2105
       This method can be used to fetch the Related field values from Dynamic soql results.
    */
    public static Object getRelatedFieldValue(sObject o, String field){
        if(o == null)
            return null;
        if(field.contains('.')){
            String nextField = field.substringAfter('.');
            String relation = field.substringBefore('.');
            return ApprovalProcessChevronCtrl.getRelatedFieldValue( (sObject) o.getSObject(relation), nextField);
        }
        else
            return o.get(field);
    }
    
    private static Boolean isStepVisible(List<MetadataService.FilterItem> stepCriteriaList, SObject sobj) {
    	if(stepCriteriaList == null || stepCriteriaList.size() == 0) return true;
    	for(MetadataService.FilterItem stepCriteria :stepCriteriaList) {
    		if(isCriteriaMeet(stepCriteria, sobj)) return true;
    	}
    	return false;
    }
    
    private static List<MetadataService.FilterItem> getStepCriteriaList(String entryCriteriaJOSN) {
    	if(String.isEmpty( entryCriteriaJOSN)) return null;
    	MetadataService.ApprovalEntryCriteria approvalEntryCtriteria = (MetadataService.ApprovalEntryCriteria)JSON.deserialize(SFDCEncoder.sanitizeJSON(entryCriteriaJOSN), MetadataService.ApprovalEntryCriteria.Class); // false+ for Deserializing objects from an untrusted source is security-sensitive as sanitizing it by using SFDCEncoder.sanitizeJSON
    	return approvalEntryCtriteria.criteriaItems;
    }
    
    private static Boolean isCriteriaMeet(MetadataService.FilterItem stepCriteria, SObject sobj) {
    	if(sobj == null) return true;
    	if(stepCriteria.value == null && sobj.get(stepCriteria.field) == null) return true;
    	Schema.SObjectField field = sobj.getSobjectType().getDescribe().fields.getMap().get(((stepCriteria.field.substringAfter('.')).toLowerCase()));
    	Schema.DisplayType fldType = field.getDescribe().getType();
    	if(fldType == DisplayType.String || fldType == DisplayType.TextArea) {
    		String fieldVal = String.valueOf(sobj.get(stepCriteria.field.substringAfter('.')));
    		String criteriaVal = String.valueOf(stepCriteria.value);
    		return compareStrings(fieldVal, criteriaVal, stepCriteria.operation);
    	} else if(fldType == DisplayType.Double || fldType == DisplayType.Integer || fldType == DisplayType.Currency) {
    		Double fieldVal = Double.valueOf(sobj.get(stepCriteria.field.substringAfter('.')));
    		Double criteriaVal = Double.valueOf(stepCriteria.value);
    		return compareNumbers(fieldVal, criteriaVal, stepCriteria.operation);
    	}
    	return false;
    }
    
    public static Boolean compareNumbers(Double number1, Double number2, String operator) {
    	if('greaterThan'.equalsIgnoreCase(operator)) return number1 > number2;
    	else if('greaterOrEqual'.equalsIgnoreCase(operator)) return number1 >= number2;
    	else if('lessThan'.equalsIgnoreCase(operator)) return number1 < number2;
    	else if('lessOrEqual'.equalsIgnoreCase(operator)) return number1 <= number2;
    	else if('equals'.equalsIgnoreCase(operator)) return number1 == number2;
    	
    	//System.assertEquals(operator, 'fdfd');
    	return false;
    }
    
    public static Boolean compareStrings(String str1, String str2, String operator) {
    	if('greaterThan'.equalsIgnoreCase(operator)) return str1 > str2;
    	else if('greaterOrEqual'.equalsIgnoreCase(operator)) return str1 >= str2;
    	else if('lessThan'.equalsIgnoreCase(operator)) return str1 < str2;
    	else if('lessOrEqual'.equalsIgnoreCase(operator)) return str1 <= str2;
    	else if('equals'.equalsIgnoreCase(operator)) return str1 == str2;
    	return false;
    }
    
    public static Boolean compareBoolean(String boolean1, String boolean2, String opeartor) {
    	return false;
    }
    public static SObject getRecord(Id recordId, List<ApprovalProcessStepCache__c> stepList) {
    	List<String> fieldsToQuery = new List<String>();
    	for(ApprovalProcessStepCache__c approvalStep : stepList) {
    		List<MetadataService.FilterItem> filterItems = getStepCriteriaList(approvalStep.EntryCriteria__c);
    		if(filterItems != null)
    		for(MetadataService.FilterItem filterItem : filterItems) {
    			fieldsToQuery.add((filterItem.field.substringAfter('.')));
    		}
    	}
    	if(fieldsToQuery.size() > 0) {
    		List<SObject> sobjects = Database.query(String.escapeSingleQuotes('select ' + String.escapeSingleQuotes(String.join(fieldsToQuery, ',')) + ' from ' + String.escapeSingleQuotes(recordId.getSObjectType().getDescribe().getName()) + ' where Id=:recordId'), AccessLevel.USER_MODE); //SOQL Injection - False +ve - Dynamic part of query is escapeSingleQuotes/static bind and recordId using escapeSingle in the fetchProcessInstance Method
    		return sobjects[0];
    	}
    	return null;
    }
    
     @TestVisible
     public with sharing class ApprovalWrapper{
        @AuraEnabled
        public list<sObject> ObjectList {get;set;}
        @AuraEnabled
        public Map<String, String> fieldKeyMap {get;set;}
        @AuraEnabled
        public Map<String, String> fieldDataMap {get;set;}
        @AuraEnabled
        public Map<String, Integer> scale {get;set;}
        @AuraEnabled
        public String timelol {get;set;}   
        @AuraEnabled
         public String userLol {get;set;}
        @AuraEnabled
        public String field {get;set;}
         @AuraEnabled
        public String requiredfield {get;set;}
         @AuraEnabled
        public String testrequired {get;set;}
         @AuraEnabled
        public String fieldlabel {get;set;}
         @AuraEnabled
        public String key {get;set;}
         

        public ApprovalWrapper(list<sObject> sObjectList, Map<String, String> fieldLableMap,Map<String, String> fieldDataTypeMap,Map<String, Integer> scaleMap,String label){
            this.ObjectList = sObjectList;
            this.fieldKeyMap = fieldLableMap;
            this.fieldDataMap = fieldDataTypeMap;
            this.scale = scaleMap;
            this.timelol = (UserInfo.getTimeZone()).toString();
            this.userLol =UserInfo.getLocale();
            this.field = label;
            this.requiredfield = label;
            this.testrequired = label;
            this.fieldlabel = label;
            this.key  = label;
        }
    }
}