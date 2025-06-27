public with sharing class AttachmentExtensionTriggerHelper extends TriggerHelper{
    public override void processBeforeInsert() {    	
    	attachmentExtName();
    }
    public override void processBeforeUpdate() {    	
    	attachmentExtName();
    }
    public void attachmentExtName() {
    	List<Attachment> attch = new List<Attachment>();
	    List<Id> attachId = new List<Id>();
	    for (AttachmentExtension__c  attExt : (List<AttachmentExtension__c>)trigger.new) {
	        attachId.add(attExt.Attachment__c);
	    }
	    //Map<Id,Attachment> attachmentMap = new Map<Id,Attachment>([SELECT ID,Name FROM ATTACHMENT WHERE Id IN : attachId]);
		  Map<Id,Attachment> attachmentMap = new Map<Id,Attachment>();
	    if(ATTACHMENT.sObjectType.getDescribe().isAccessible() == true){
	    	attachmentMap = new Map<Id,Attachment>([SELECT ID,Name FROM ATTACHMENT WHERE Id IN : attachId  WITH USER_MODE]);
	    }
	    for (AttachmentExtension__c  attExt : (List<AttachmentExtension__c>)trigger.new) {
	        Attachment att = attachmentMap.get(attExt.Attachment__c);
	        if (att != null) {
	            attExt.AttachmentName__c = att.Name;       
	        }
	    } 
    }
	
}