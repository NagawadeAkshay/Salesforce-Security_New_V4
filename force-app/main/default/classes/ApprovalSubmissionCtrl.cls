/*
    Class that implements Approval Process API which submits a record
    for Approval when Submit for Approval Button is clicked
    ***********************************************************
    Audit History
    ***********************************************************
    03/31/2014      Vineeth Shetty             Created
    *********************************************************** 
*/
global with sharing class ApprovalSubmissionCtrl {
    
    public String recordName {get;set;}
    public String recordType {get;set;}
    public boolean isError {get;set;}
 	public string errorMessage {get;set;}
    global String themeDocURL {get; set;}
    
    global ApprovalSubmissionCtrl(){
    	
    	String themeDoc = 'GovGrantsTheme';
    	if(AppUtils.isObjectAccessible('Document')){
        	List<Document> docList = [SELECT Id FROM Document WHERE Name =:themeDoc WITH USER_MODE]; //CRUD/FLS False +ve with the help of AppUtils we have performed check
	        if(docList.size() > 0){
	            themeDocURL = '/servlet/servlet.FileDownload?file=' + docList[0].Id;
	        }
	        
	        //record id of the Object submitted for Approval
	        String recordId = SFDCEncoder.SFDC_JSENCODE(ApexPages.currentPage().getParameters().get('id'));//NOPMD ApexXSSFromURLParam - False +Ve - We are using custom method for encoding 
	        SchemaManager.SObjectWrapper parentSObject = SchemaManager.getSObject(ID.valueOf(recordId));
	        if(AppUtils.isObjectAccessible('Document')){
	        	sObject sObjectRecord = Database.query('SELECT Name FROM ' +  String.escapeSingleQuotes(parentSObject.objectName) + ' WHERE IsDeleted = false AND id = :recordId', AccessLevel.USER_MODE); //SOQL Injection - False +ve - Dynamic part of query is escapeSingleQuotes/static bind

	        	recordName = (String)sObjectRecord.get('Name');
	        }			
	        string objectName = parentSObject.objectName.replace(AppUtils.getNameSpacePrefix(), '');
	        SchemaManager.SObjectWrapper sObj = SchemaManager.getSObject(objectName);
	        Schema.DescribeSObjectResult objResult = sObj.objectResult;
	        recordType = objResult.getLabel();
	        isError = false;
    	}
    }
    
    public Boolean getErrorMessagesFlag() {
        return ApexPages.hasMessages();
    }
    
    /*
        Method submits the record for Approval
    */
    public PageReference submitForApproval(){        
        Savepoint sp = Database.setSavepoint();
        //record id of the Object submitted for Approval
        String recordId = SFDCEncoder.SFDC_JSENCODE(ApexPages.currentPage().getParameters().get('id'));//NOPMD ApexXSSFromURLParam - False +Ve - We are using custom method for encoding 
        String templateName = SFDCEncoder.SFDC_JSENCODE(ApexPages.currentPage().getParameters().get('template')); //NOPMD ApexXSSFromURLParam - False +Ve - We are using custom method for encoding        
        //record action
        String recordAction  = SFDCEncoder.SFDC_JSENCODE(ApexPages.currentPage().getParameters().get('Action')); //NOPMD ApexXSSFromURLParam - False +Ve - We are using custom method for encoding 
        
        //Create history pdf
     //   createHistoryPDF(recordId,templateName);
                      
        try{
            //Submit for Approval and Create Task
            List<Task> approvalTaskList = TaskCreationHandler.createApprovalProcessTasks(recordId, recordAction, recordName, null, null, null, true);            
            //Populating Fields on Task Object
            Set<String> ownerIds = new Set<String>();
            for( Task approvalTask : approvalTaskList) {
	            approvalTask = AppUtils.assignTaskForSObject(approvalTask, recordId); 
	            ownerIds.add(approvalTask.ownerId);           
            }
           // approvalTask.Action__c = recordAction;    
                  
            if(Schema.sObjectType.Task.isCreateable() && Schema.sObjectType.Task.isUpdateable()){
                upsert as user approvalTaskList;    
                // share the parent record with the task owner
                Id parentId = recordId;                
                String objectName = parentId.getSObjectType().getDescribe().getName();                 
	            if(objectName.contains('__c')){
	                objectName = objectName.removeEnd('__c');
	            }
            	String shareSobjectName = objectName+'__share'; 
	            if(Schema.getGlobalDescribe().get(shareSobjectName) != null && AppUtils.isObjectAccessible(shareSobjectName)) {
	                String query = 'select UserOrGroupId,AccessLevel from ' + String.escapeSingleQuotes(shareSobjectName) + ' where ParentId=:recordId'; //sf review
	                List<Sobject> shares = Database.query(String.escapeSingleQuotes(query), AccessLevel.USER_MODE); //SOQL Injection - False +ve - Dynamic part of query is escapeSingleQuotes/static bind
	                Set<Id> userGrpId = new Set<Id>();
	                for(Sobject share:shares){
	                    if(share.get('AccessLevel') == 'Edit' || share.get('AccessLevel') == 'All' ){
	                        userGrpId.add((Id)share.get('UserOrGroupId'));
	                    }
	                }
	                List<SObject> sharedObjects = new List<SObject>();
                    String objName = '';
	                for(String ownerId : ownerIds) {
		                sobject shareSobj=Schema.getGlobalDescribe().get(shareSobjectName).newSObject();
                        if(String.isBlank(objName)){ //added for SF review
                            objName = shareSobj.Id.getSobjectType().getDescribe().getName();
                        } 
                        SObjectType objectType = ((SObject)Type.forName('Schema', objName).newInstance()).getSObjectType();
		                if(shareSobj != null) {
		                    if(!userGrpId.contains(ownerId)){
		                        shareSobj.put('ParentId', recordId);
		                        shareSobj.put('UserOrGroupId', ownerId);
                                if(objectType.getDescribe().fields.getMap().get('AccessLevel').getDescribe().isCreateable()){
		                            shareSobj.put('AccessLevel', 'edit'); 
                                }
		                        sharedObjects.add(shareSobj);
		                    }
		                }
	                }
                    
                    if(AppUtils.isObjectCreateable(objName)) { //Added for SF review  
	                    insert as user sharedObjects; //CRUD/FLS False +ve with the help of AppUtils we have performed check
                    }
	            }
        	}
            isError = false;  
            return null;
        }catch(Exception e){
            Database.rollback(sp);
            isError = true;
            errorMessage = AppUtils.handleSystemExceptionMsg(e);
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, errorMessage));
            return null;
        }
        
    }
}