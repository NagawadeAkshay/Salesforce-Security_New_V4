/*
    This is a class with keyword "with sharing".
    This enables the methods defined here to execute in User Context, that is, the current user's permissions, 
    field-level security, and sharing rules are taken into account during code execution.     
    *******************************************************************************************************************
    Audit History
    ********************************************************************************************************************
    28-Aug-2018 Prajakta Gadhe    Created
    **********************************************************************************************************************  
*/

public with sharing class WithSharingHelper {    
   
    
    public static List<AttachmentExtension__c> getRelatedAttachmentmentExtension() { 
        if (Schema.sObjectType.AttachmentExtension__c.isAccessible()) {
            return [SELECT Id,Classification__c,Attachment__c FROM AttachmentExtension__c 
            WHERE Classification__c NOT IN ('Digitally Signed','Digitally Signed Original','History') AND (AttachmentType__c = 'Attachment' OR AttachmentType__c = null) AND IsCloned__c != true 
            WITH USER_MODE limit 500];
        }else{
            return new List<AttachmentExtension__c>();
        }
    }
        
    public static  List<Attachment> getRelatedAttachments(List<String> attchmentsIds){ 
        return [select Id, Name,ParentId,ContentType,Description,LastModifiedDate  
        from Attachment WHERE Id IN :attchmentsIds WITH USER_MODE limit 500];
    }
}