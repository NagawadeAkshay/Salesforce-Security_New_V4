/*
This  TriggerHelper 
*******************************************************************************
Audit History
    
*******************************************************************************
08-01-2022      Tejashreee D        1. added with sharing for SF security review, EmailQueue, EmailTemplateConfig, is Public R/W AND 
Config form is Public Read only     
*******************************************************************************
*/
public with sharing class EmailQueueTriggerHelper extends TriggerHelper {
	public override void processBeforeInsert() { 
				recordSnapshot(trigger.new);
	}
	public override void processBeforeUpdate() { 		
		recordSnapshot(trigger.new);
        setToEmailId(trigger.new);
  }

	public void recordSnapshot(List<EmailQueue__c> queues) {
		//List of templateNames
		List<String> templatesName = new List<String>();
		for(EmailQueue__c eq : queues){
			if(eq.TemplateName__c != null){
				templatesName.add(eq.TemplateName__c);
			}
		}
		
		List<EmailTemplateConfig__c> emailtemplateConfig = new List<EmailTemplateConfig__c>();
		//Map of templatname and soql fields
		Map<String,String> soqlFieldsMap = new Map<String,String>();
		//Map of objname and set of Recordids
		Map<String, Set<String>> contextRecordIdMap = new Map<String, Set<String>>();
		//Map of objname and set of field
		Map<String, Set<String>> fieldsMap = new Map<String, Set<String>>();
		if(Schema.sObjectType.EmailTemplateConfig__c.isAccessible()){
			emailtemplateConfig = [SELECT SOQLField__c,DeveloperName__c from EmailTemplateConfig__c 
								where DeveloperName__c IN:templatesName WITH USER_MODE];
		}
		for(EmailTemplateConfig__c ec : emailtemplateConfig){
			soqlFieldsMap.put(ec.DeveloperName__c,ec.SOQLField__c);
		}
		for(EmailQueue__c eq : queues){
			if(eq.TemplateName__c != null){	
				if(soqlFieldsMap.get(eq.TemplateName__c) != null){
                    if(eq.ContextRecordIds__c != null){
                        String sObjectName = String.valueOf(((Id)eq.ContextRecordIds__c).getSobjectType());
                        if(contextRecordIdMap.get(sObjectName) == null){
                            contextRecordIdMap.put(sObjectName,new Set<String>());
                        }
                        contextRecordIdMap.get(sObjectName).add(string.escapeSingleQuotes(eq.ContextRecordIds__c));  
                        if(fieldsMap.get(sObjectName) == null){
                            fieldsMap.put(sObjectName, new Set<String>());
                        }
                        fieldsMap.get(sObjectName).addAll(new Set<String>((soqlFieldsMap.get(eq.TemplateName__c).split(',')))); 
                    }
            	}
			}
		}
        List<sObject> sdata = new List<sObject>();
        Map<String,sObject> sdataMap = new Map<String,sObject>();
		for(String ObjName:contextRecordIdMap.keySet()){
			String records = String.join(new List<String>(contextRecordIdMap.get(objName)),'\',\'');
			records = '(\''+records+'\')';
			String fields = string.escapeSingleQuotes(String.join(new List<String>(fieldsMap.get(ObjName)),','));
			List<sObject> sa =Database.query('SELECT '+ fields + ' FROM ' + string.escapeSingleQuotes(objName) + ' WHERE id IN '+ AppUtils.parseWhereClause(records), AccessLevel.USER_MODE); //NOPMD SOQL Injection - False +ve - Applied esacpeSingleQuotes in records from AppUtils.parseWhereClause method
			sdata.addAll(sa);
		}
		for(sObject s:sdata){
			sdataMap.put(s.id,s);
		}
		for(EmailQueue__c eq : queues){
			if(eq.TemplateName__c != null){
				if(soqlFieldsMap.get(eq.TemplateName__c) != null){
					Map<string, SObject> recordMap = new Map<string, SObject>();
                    if(eq.ContextRecordIds__c != null){
                      	RecordMap.put(eq.ContextRecordIds__c,sdataMap.get((Id)eq.ContextRecordIds__c));
						eq.RecordSnapshot__c = JSON.serialize(recordMap);  
                    }
					
				}
			}
		}
		
	}
  /*
	  Name : Pankaj D
	  Comment : Populate emaiid in email queue
	  Bug : New Ohio requirement
  */
  public void setToEmailId(List<EmailQueue__c> queues) {
  Set<Id> setUserIds = new Set<Id>();
  String emailId;
  
    if(queues.size() > 0) {
        for(EmailQueue__c emq : queues) {
            if(emq.Status__c == 'Processed' && emq.TargetObjectId__c != null && (emq.TargetObjectId__c.StartsWith('005') || emq.TargetObjectId__c.StartsWith('003')))
                setUserIds.add(emq.TargetObjectId__c);
        }    
    }
    If(setUserIds != null){    
        Map<Id,String> usermap = new Map<Id,String>();
		List<User> userLst = new List<User>();
		if(User.sObjectType.getDescribe().isAccessible() == true){ 
        	userLst  = [SELECT Email,Id,Name FROM User where id in : setUserIds WITH USER_MODE];//CRUD/FLS False +ve As per business scenario we can't check for portal/external users
		}
		if(userLst != null && userLst.size()>0){
            for(User obj : UserLst){
                usermap.put(obj.Id,obj.Email);
			}
		}
        
        Map<Id,String> contmap = new Map<Id,String>();  
		List<Contact> contLst = new List<Contact>();
		if(Contact.sObjectType.getDescribe().isAccessible() == true){ 
        	contLst = [SELECT Email,Id FROM Contact where id in : setUserIds WITH USER_MODE];//CRUD/FLS False +ve As per business scenario we can't check for portal/external users
		}
		if(contLst != null && contLst.size()>0){
            for(Contact obj : contLst){
                contmap.put(obj.Id,obj.Email);
			}
		}
            
        for(EmailQueue__c eq : queues){
            if(eq.TargetObjectId__c != null && (eq.TargetObjectId__c.StartsWith('005') || eq.TargetObjectId__c.StartsWith('003'))){
                
                if(usermap.keySet().contains(eq.TargetObjectId__c)) {
                    emailId = usermap.get(eq.TargetObjectId__c);
                }
                if(contmap.keySet().contains(eq.TargetObjectId__c)) {
                    emailId = contmap.get(eq.TargetObjectId__c);
                }
                
                eq.ToEmails__c = emailId;
            }
        }
    }
  
  }
}