global with sharing class SendToOwnerEmailHandler implements Messaging.InboundEmailHandler {
    global Messaging.InboundEmailResult handleInboundEmail(Messaging.InboundEmail email,
                                                         Messaging.Inboundenvelope envelope) {
          Messaging.InboundEmailResult result = new Messaging.InboundEmailresult();
          result.success = true;
          String parentId = email.plainTextBody;
		String fldname = null;
          if(!String.isEmpty(parentId.replaceAll( '\\s+', ''))) {
			Id recordId = Id.valueOf(parentId);
			SchemaManager.SObjectWrapper parentSObject = SchemaManager.getSObject(recordId);
			List<SobjectConfig__c> lstSobjectConfigs;
			if(Schema.sObjectType.SobjectConfig__c.isAccessible()) {
				lstSobjectConfigs = [Select Name,ApprovalReCallCommentFieldAPIName__c,ApprovalReCallFieldAPIName__c 
												from SobjectConfig__c 
												where Name =: parentSObject.objectName WITH USER_MODE Limit 1];
			}
			if(lstSobjectConfigs.size()>0) { 
		  		fldname = (lstSobjectConfigs[0].ApprovalReCallCommentFieldAPIName__c != null ? lstSobjectConfigs[0].ApprovalReCallCommentFieldAPIName__c : 'Name');
		  		if(lstSobjectConfigs[0].ApprovalReCallFieldAPIName__c != null)
  					fldname = (fldname != null ? fldname+','+lstSobjectConfigs[0].ApprovalReCallFieldAPIName__c : lstSobjectConfigs[0].ApprovalReCallFieldAPIName__c);
			  	List<SObject> lstSObj;
				if(AppUtils.isObjectAccessible(parentSObject.objectName)){ //CRUD/FLS False +ve with the help of AppUtils we have performed check
					lstSObj = Database.query('select Id,'+ string.escapeSingleQuotes(fldname) +' from '+string.escapeSingleQuotes(parentSObject.objectName)+' where Id =:'+String.escapeSingleQuotes(parentId),AccessLevel.USER_MODE);//SOQL Injection - False +ve - Dynamic parts of the query string is ecsapeSingleQuotes to prevent SOQL Injection
				}  
				String approvalComments = Label.ApprovalReCallComment;
		  		if(lstSObj.size() > 0 && String.isNotEmpty(lstSobjectConfigs[0].ApprovalReCallCommentFieldAPIName__c)) {
					approvalComments = String.valueOf(lstSObj[0].get(lstSobjectConfigs[0].ApprovalReCallCommentFieldAPIName__c));
		 		}
				String objName ='';
		 		if(String.isBlank(objName)){
                    objName = lstSObj[0].Id.getSobjectType().getDescribe().getName();
                }
				ApprovalRecallBatch.recall(parentId, approvalComments,null);
			 	if(lstSObj.size()>0 && lstSobjectConfigs[0].ApprovalReCallFieldAPIName__c != null) {
		  			if(Schema.SObjectType.SobjectConfig__c.fields.ApprovalReCallFieldAPIName__c.isUpdateable() &&
					Schema.SObjectType.SobjectConfig__c.fields.ApprovalReCallFieldAPIName__c.isAccessible()){
						lstSObj[0].put(lstSobjectConfigs[0].ApprovalReCallFieldAPIName__c, false);
					}
					if(AppUtils.isObjectAccessible(objName) && AppUtils.isObjectUpdateable(objName)) { //Added for SF review  
							update as user lstSObj; //FLS/ CRUD False +ve with the help of apputil we have performed check
					}
			 	}
			}
			else {
				CustomExceptions.logException('SObject Config not present for this record '+parentId+' object. Please connect with System admin. ',true);
			}
          }
          return result;
 	}
}