/**
 * Created by REI-U1 on 26-11-2018.
 */

public with sharing class SendToOwnerEventHandler implements PlatformEventHandler{

    public void handle(Set<String> parentIds) {
        // there will be only one Id at a time.
        List<String> Ids = new List<String>();
        Ids.addAll(parentIds);
        Id recordId = Id.valueOf(Ids.get(0));
        //Fetch Object Name by given record Id
        SchemaManager.SObjectWrapper parentSObject = SchemaManager.getSObject(recordId);
        //Fetch related SobjectConfig__c by above object name added Limit 1 for safe side.
        List<SobjectConfig__c> lstSobjectConfigs = new List<SobjectConfig__c>();
        if(Schema.sObjectType.SobjectConfig__c.isAccessible()){
        lstSobjectConfigs = [Select Name,ApprovalReCallCommentFieldAPIName__c,ApprovalReCallFieldAPIName__c
        from SobjectConfig__c
        where Name =: parentSObject.objectName WITH USER_MODE Limit 1];
        }
        if(lstSobjectConfigs.size()>0) { //throw exception is size is zero
            String fldname = (lstSobjectConfigs[0].ApprovalReCallCommentFieldAPIName__c != null ? lstSobjectConfigs[0].ApprovalReCallCommentFieldAPIName__c : null);
            if(lstSobjectConfigs[0].ApprovalReCallFieldAPIName__c != null)
                fldname = (fldname != null ? fldname+','+lstSobjectConfigs[0].ApprovalReCallFieldAPIName__c : lstSobjectConfigs[0].ApprovalReCallFieldAPIName__c);
            //Fetch comment value from record to send recall logic
            List<SObject> lstSObj = Database.query('select Id,'+ string.escapeSingleQuotes(fldname) +' from '+string.escapeSingleQuotes(parentSObject.objectName)+' where Id =:'+string.escapeSingleQuotes(recordId)+'WITH USER_MODE');
            //Dynamic parts of the query string is ecsapeSingleQuotes and Object name is fetched from Schema Method to prevent SOQL Injection
            //Check that SobjectConfig__c having comment field value or not.
            String approvalComments = Label.ApprovalReCallComment;
            if(lstSObj.size() > 0 && String.isNotEmpty(lstSobjectConfigs[0].ApprovalReCallCommentFieldAPIName__c)) {
                approvalComments = String.valueOf(lstSObj[0].get(lstSobjectConfigs[0].ApprovalReCallCommentFieldAPIName__c));
            }

            List<EventBus__e> eventBuses = (List<EventBus__e>) Trigger.New;
            Id publisherUser;
              if(eventBuses!=null && eventBuses.size()>0){
                    for(EventBus__e eb : eventBuses) {
                        if(eb.ParentId__c == recordId) {
                            publisherUser = eb.CreatedById;
                        }
                    }
              }

            ApprovalRecallBatch.recall(recordId, approvalComments, publisherUser);
            if(lstSObj.size()>0 && lstSobjectConfigs[0].ApprovalReCallFieldAPIName__c != null) {
                String objName ='';
		 		if(String.isBlank(objName)){
                    objName = lstSObj[0].Id.getSobjectType().getDescribe().getName();
                }
                SObjectType objectType = ((SObject)Type.forName('Schema', objName).newInstance()).getSObjectType();
                //if(objectType.getDescribe().fields.getMap().get('ApprovalReCallFieldAPIName__c').getDescribe().isUpdateable()){ Do not check FLS CRUD here 
                 //commented as failing on INT Org  
                	lstSObj[0].put(lstSobjectConfigs[0].ApprovalReCallFieldAPIName__c, false);
                //}
                if(AppUtils.isObjectAccessible(objName) && AppUtils.isObjectUpdateable(objName)) { //Added for SF review  
                update as user lstSObj;//CRUD/FLS False +ve with the help of AppUtils we have performed check
                }
            }
        }
    }

}