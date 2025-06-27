/**
**/
global with sharing class DownloadFiles {
    public String downloadURL {get; set;}
    public Integer closetimeout {get; set;}

    public DownloadFiles(){ 
        try{
            Id recordId = SFDCEncoder.SFDC_JSENCODE(Apexpages.currentPage().getParameters().get('id'));//NOPMD ApexXSSFromURLParam - False +Ve - We are using custom method for encoding 
            PageReference pageRef = null;
            if(recordId != null){
                String strClosetimeout = SFDCEncoder.SFDC_JSENCODE(Apexpages.currentPage().getParameters().get('closetimeout'));//NOPMD ApexXSSFromURLParam - False +Ve - We are using custom method for encoding 
                closetimeout = String.isNotBlank(strClosetimeout) ? Integer.valueOf(strClosetimeout) : 5000;
                Set<Id> setContentDocIds = new Set<Id>();
                for(ContentDocumentLink objContentDocumentLink : [SELECT Id, ContentDocumentId FROM ContentDocumentLink 
                        WHERE LinkedEntityId =: recordId WITH USER_MODE]){//CRUD/FLS False +ve As per business scenario we can't check for portal/external users
                    setContentDocIds.add(objContentDocumentLink.ContentDocumentId);
                }
                if(!setContentDocIds.isEmpty()){
                    Map<Id, ContentDocument> mapContentDocs = new Map<Id, ContentDocument>([SELECT Id FROM ContentDocument WHERE Id IN :setContentDocIds WITH USER_MODE]);//CRUD/FLS False +ve As per business scenario we can't check for portal/external users
                    if(!mapContentDocs.isEmpty()){
                        downloadURL = '/sfc/servlet.shepherd/document/download/' + String.join(new List<Id>(mapContentDocs.keySet()), '/');
                    }                    
                }
            }
        }catch(Exception e){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage()));
        }
    }
}