/**
* Class to take a snapshot of a given parent record id
*
* CHANGE HISTORY
* =============================================================================
* Date          Name            Description
* 01/28/2014     Kunal Shah     Created
* 09/09/2015     Shah Kadirmohideen     Refactored the code
* =============================================================================
*/

global with sharing class AttachmentUtils { 

    global static Attachment exportAsPDF(PageReference pr, Id parentId, String classification, String historyReason, String attachmentName) {
        return exportAsPDF(pr, parentId, classification, historyReason, attachmentName, null);
    }

    public static ContentVersion exportAsFilePDF(PageReference pr, Id parentId, String classification, String historyReason, String attachmentName, String attachmentType){
        pr = new PageReference(EncodingUtil.urlEncode(pr.getUrl(),'UTF-8')); //ApexOpenRedirect  - False +Ve - We are using custom method for encoding
        if (String.isNotEmpty(attachmentName)) {
            attachmentName = AppUtils.replaceMergeFields(attachmentName, parentId);
            if (attachmentName.endsWith('.pdf') == false) {
                attachmentName += '.pdf';
            }
        }

        ContentVersion cvData = new ContentVersion();
        Blob body;
        if(Test.isRunningTest()){
            body = blob.valueOf('TestBody');
        }else{
            body = pr.getContent();
        }

        if(Schema.sObjectType.ContentVersion.fields.Title.isCreateable()){
            cvData.Title = attachmentName;
        }
        if(Schema.sObjectType.ContentVersion.fields.VersionData.isCreateable()){
            cvData.VersionData = body;
        }
        if(Schema.sObjectType.ContentVersion.fields.PathOnClient.isCreateable()){
            cvData.PathOnClient = '/'+ attachmentName;
        }
        if(Schema.sObjectType.ContentVersion.fields.Classification__c.isCreateable()){
            cvData.Classification__c = classification;
        }
        if(Schema.sObjectType.ContentVersion.fields.HistoryReason__c.isCreateable()){
            cvData.HistoryReason__c = historyReason;
        }
        if(Schema.sObjectType.ContentVersion.fields.AttachmentType__c.isCreateable()){
            cvData.AttachmentType__c = attachmentType;
        }
        if(Schema.sObjectType.ContentVersion.isCreateable() && ContentVersion.sObjectType.getDescribe().isAccessible() == true){
             insert as user cvData;
        }
       
        // Content Document Id for update Document Link..
        ContentVersion cvDocId = [SELECT ContentDocumentId FROM ContentVersion WHERE Id=:cvData.Id and IsLatest=true  WITH USER_MODE];//CRUD/FLS False +ve As per business scenario we can't check for portal/external users

        ContentDocumentLink contentlink=new ContentDocumentLink();
        contentlink.LinkedEntityId=parentId;
        contentlink.ShareType= 'I';
        contentlink.ContentDocumentId=cvDocId.ContentDocumentId;
        if(Schema.sObjectType.ContentDocumentLink.isCreateable() && ContentDocumentLink.sObjectType.getDescribe().isAccessible() == true){
            insert as user contentlink; 
        }
        return cvData;
    }

    global static Attachment exportAsPDF(PageReference pr, Id parentId, String classification, String historyReason, String attachmentName, String attachmentType) {
        pr = new PageReference(EncodingUtil.urlEncode(pr.getUrl(),'UTF-8')); //ApexOpenRedirect  - False +Ve - We are using custom method for encoding
        if (String.isNotEmpty(attachmentName)) {
            attachmentName = AppUtils.replaceMergeFields(attachmentName, parentId);
            if (attachmentName.endsWith('.pdf') == false) {
                attachmentName += '.pdf';
    		}
        }
        Attachment attach = new Attachment();
        Blob body;
        if(Test.isRunningTest()){            
            body = blob.valueOf('TestBody');
        }else{
            body = pr.getContent();//pr.getContentAsPDF();
        }
     
        if(Schema.sObjectType.Attachment.fields.Name.isCreateable()){
            attach.Name = attachmentName; 
        }
        if(Schema.sObjectType.Attachment.fields.Body.isCreateable()){
            attach.Body = body;
        }
        if(Schema.sObjectType.Attachment.fields.ContentType.isCreateable()){
            attach.ContentType = 'application/pdf';
        }
        if(Schema.sObjectType.Attachment.fields.IsPrivate.isCreateable()){
            attach.IsPrivate = false;
        }
        //if(Schema.sObjectType.Attachment.fields.ParentId.isCreateable()){
            attach.ParentId = parentId;//CRUD/ FLS false +ve Id field
        //}
        if(Schema.sObjectType.Attachment.isCreateable() && Attachment.sObjectType.getDescribe().isAccessible() == true){
            insert as user attach;
        } 
        
        AttachmentExtension__c attExt = new AttachmentExtension__c();
        if(Schema.sObjectType.AttachmentExtension__c.fields.Attachment__c.isCreateable()){
            attExt.Attachment__c = attach.id;
        }
        if(Schema.sObjectType.AttachmentExtension__c.fields.Classification__c.isCreateable()){
            attExt.Classification__c = classification;
        }
        if(Schema.sObjectType.AttachmentExtension__c.fields.AttachmentType__c.isCreateable()){
            attExt.AttachmentType__c = attachmentType;
        }
        if(Schema.sObjectType.AttachmentExtension__c.fields.ParentId__c.isCreateable()){
            attExt.ParentId__c = parentId;
        }
        if(Schema.sObjectType.AttachmentExtension__c.fields.AttachmentName__c.isCreateable()){
            attExt.AttachmentName__c = attachmentName;
        }
        if(Schema.sObjectType.AttachmentExtension__c.fields.HistoryReason__c.isCreateable()){
            attExt.HistoryReason__c = historyReason;
        }
        if(Schema.sObjectType.AttachmentExtension__c.isCreateable()){
            insert as user attExt;
        }
        return attach;
    }
    
    /*
        Method to export any page as PDF and attach it to ParentId
    */
    global static Attachment exportAsPDF(PageReference pr, String parentId, String classification, String attName) {
        return exportAsPDF(pr, parentId, classification, null, attName);
        }
     
    public static ContentVersion exportAsApprovalFilePDF(PageReference pr, String parentId, String classification, String attName){
        return exportAsFilePDF(pr, parentId, classification, null, attName, null);
    }
     
    global static Attachment exportAsPDF(PageReference pr, String parentId, String classification) {
        Id objectId = (Id)parentId;
        String objectName = objectId.getSObjectType().getDescribe().getName();
        String attName = fetchAttachmentNameFormat(objectName);
        return exportAsPDF(pr, parentId, classification, null, attName);
        }
        
    /* PRIVATE METHODS */
        
    /*Fetch attachment name format*/
    private static String fetchAttachmentNameFormat(String objectName){
    	List<SobjectConfig__c> sobjectConfig = new List<SobjectConfig__c>();
            objectName = string.escapeSingleQuotes(objectName);
	        String query = 'Select AttachmentName__c from SobjectConfig__c where Name =:objectName';
	        sobjectConfig = Database.query(String.escapeSingleQuotes(query), AccessLevel.USER_MODE); //SOQL Injection - False +ve - Dynamic part of query is static bind

        if(sobjectConfig.size() > 0){
            return sobjectConfig[0].AttachmentName__c;
        }
        return null;
    }
    
}