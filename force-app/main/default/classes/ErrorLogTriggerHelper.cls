public with sharing class ErrorLogTriggerHelper extends TriggerHelper{

     public override void processBeforeInsert(){
        String SobjectWithNamespace = AppUtils.getNameSpacePrefix() + 'ErrorLog__c';
        List<RecordType> recordTypeList = new List<RecordType>();
        if(RecordType.sObjectType.getDescribe().isAccessible()) {
            recordTypeList = [ SELECT DeveloperName,SobjectType 
                FROM RecordType 
                WHERE DeveloperName = 'ErrorLog' AND SobjectType =: SobjectWithNamespace WITH USER_MODE
            ];//CRUD/FLS False +ve As per business scenario we can't check for portal/external users
        }
        for(ErrorLog__c error: (List<ErrorLog__c >)Trigger.new){
            if(recordTypeList.size()>0 && error.RecordTypeId == null){
                error.RecordTypeId = recordTypeList[0].Id ;
            }         
        }      
     }     
     
 }