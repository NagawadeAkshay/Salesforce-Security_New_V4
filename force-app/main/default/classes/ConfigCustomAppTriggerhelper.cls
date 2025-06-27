/*
    Trigger Helper 
    
    ****************************************************************************************
    Audit History
    ****************************************************************************************
    08-01-2022      Tejashreee D        1. added with sharing for SF security review, Custom app is Public R/W
    ****************************************************************************************
*/
public with sharing class ConfigCustomAppTriggerhelper extends TriggerHelper {
    
    public override void processAfterInsert() {
        syncDataToCache();
        copyDocumentsId();
       
    } 

    public override void processAfterUpdate() {
        syncDataToCache();
        copyDocumentsId();
        
    }
    
    public override void processBeforeDelete() {
        syncDataToCache();
    }
    
    public override void processBeforeInsert() { 
        Map<String, Id> mapApp = new Map<String, Id>();
        Set<String> setAppName = new Set<String>();
        for(CustomApp__c app :(list<CustomApp__c>)trigger.new){
            app.Name = app.Name.deleteWhitespace();
            setAppName.add(app.Name);
        } 
        if(Schema.sObjectType.CustomApp__c.isAccessible()){
            for(CustomApp__c app :[SELECT Id, Name FROM CustomApp__c WHERE  Name IN :setAppName  WITH USER_MODE]){
                mapApp.put(app.Name, app.Id);
            }
        }
        for(CustomApp__c app : (list<CustomApp__c>) trigger.new){
            if(mapApp.containsKey(app.Name) && mapApp.get(app.Name) != app.Id){
                String appName = SFDCEncoder.SFDC_HTMLENCODE(app.Name);
                app.addError('There is already another Custom App Config with the same Name. ' + 'Refer: <a href=\'/' + SFDCEncoder.SFDC_HTMLENCODE(mapApp.get(appName)) + '\'>' + appName + '</a>',FALSE); //NOPMD ApexXSSFromEscapeFalse - False +ve - Sanitized value on above line number - Used SFDCEncoder.SFDC_HTMLENCODE custom() for sanitization
            }
        }
    }

    public override void processBeforeUpdate() { 
        Map<String, Id> mapApp = new Map<String, Id>();
        Set<String> setAppName = new Set<String>();
        for(CustomApp__c app :(list<CustomApp__c>)trigger.new){
            app.Name = app.Name.deleteWhitespace();
            setAppName.add(app.Name);
        } 
        if(Schema.sObjectType.CustomApp__c.isAccessible()){
            for(CustomApp__c app :[SELECT Id, Name FROM  CustomApp__c WHERE  Name IN :setAppName WITH USER_MODE]){//CRUD/FLS False +ve As per business scenario we can't check for portal/external users
                mapApp.put(app.Name, app.Id);
            }
        }
        for(CustomApp__c app : (list<CustomApp__c>) trigger.new){
            if(mapApp.containsKey(app.Name) && mapApp.get(app.Name) != app.Id){
                String appName = SFDCEncoder.SFDC_HTMLENCODE(app.Name);
                app.addError('There is already another  Custom App config  with the same Name. ' + 'Refer: <a href=\'/' + SFDCEncoder.SFDC_HTMLENCODE(mapApp.get(appName)) + '\'>' + appName + '</a>',FALSE); //NOPMD ApexXSSFromEscapeFalse - False +ve - Sanitized value on above line number - Used SFDCEncoder.SFDC_HTMLENCODE custom() for sanitization
            }
        }
    }

    private void syncDataToCache() {
        new DataSyncTriggerHelper(CustomAppConfig__c.getSObjectType()).process();
    } 
    
    private void copyDocumentsId(){
        Set<String> documentNameList = new Set<String>();
        List<Document> documentList = new List<Document>();
        Map<String,String> docMap = new Map<String,string>();
        for(CustomApp__c app :(list<CustomApp__c>)trigger.new){
            if(app.LogoDocumentName__c != null){
                documentNameList.add(app.LogoDocumentName__c);
            }
            if(app.DefaultThemeName__c != null){
                documentNameList.add(app.DefaultThemeName__c);
            }
            if(app.SelectedLogoDocumentName__c != null){
               documentNameList.add(app.SelectedLogoDocumentName__c);
            }
        }
        if(Document.sObjectType.getDescribe().isAccessible() == true){ 
            documentList = [SELECT ID,Name,DeveloperName from Document where DeveloperName IN: documentNameList WITH USER_MODE];//NOPMD CRUD/FLS False +ve As per business scenario we can't check for portal/external users
        }
        for(Document doc:documentList){
            docMap.put(doc.DeveloperName,doc.id); 
        }
        List<CustomAppConfig__c> customAppConfiList = new List<CustomAppConfig__c>();
        for(CustomApp__c app :(list<CustomApp__c>)trigger.new){
            CustomAppConfig__c c = CustomAppConfig__c.getInstance(app.Name);
            if(app.LogoDocumentName__c != null && Schema.sObjectType.CustomAppConfig__c.fields.LogoDocumentId__c.isCreateable() && Schema.sObjectType.CustomAppConfig__c.fields.LogoDocumentId__c.isUpdateable()){
                c.LogoDocumentId__c = docMap.get(app.LogoDocumentName__c);
            }
            if(app.DefaultThemeName__c != null && Schema.sObjectType.CustomAppConfig__c.fields.DefaultThemeId__c.isCreateable() && Schema.sObjectType.CustomAppConfig__c.fields.DefaultThemeId__c.isUpdateable()){             
              c.DefaultThemeId__c= docMap.get(app.DefaultThemeName__c);
            }
            if(app.SelectedLogoDocumentName__c != null && Schema.sObjectType.CustomAppConfig__c.fields.SelectedLogoDocumentId__c.isCreateable() && Schema.sObjectType.CustomAppConfig__c.fields.SelectedLogoDocumentId__c.isUpdateable()){
                c.SelectedLogoDocumentId__c = docMap.get(app.SelectedLogoDocumentName__c);
            }            
            customAppConfiList.add(c);
        }
        if(Schema.sObjectType.CustomAppConfig__c.isCreateable() && Schema.sObjectType.CustomAppConfig__c.isUpdateable()){
            upsert customAppConfiList;//CRUD/FLS False +ve As per business scenario portal/guest users should be able to perform DML.
        }
    }
}