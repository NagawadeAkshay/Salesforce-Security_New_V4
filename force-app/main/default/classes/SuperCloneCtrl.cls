global with sharing class SuperCloneCtrl {

    // Method which Clone Page Template and provide with cloned page layout ID...
    WebService static String  doCloneStr( String cloneId ) {
        PageTemplate__c ptnew;
        PageTemplate__c pt;
        if(Schema.sObjectType.PageTemplate__c.isAccessible()) {
                pt =[SELECT AllowedCharsForRichTextArea__c,CustomAppConfig__c,Description__c,DisplayName__c,NextPageURL__c,RedirectBehaviour__c,
                                EditLayoutConfig__c,FormDisplayType__c,FormType__c,GroupName__c,HelpConfig__c,OMBExpiration__c,OMBNumber__c,RTALimitConfig__c,
                                PackageType__c,ParentObjectFieldAPI__c,PrintLayoutConfig__c,ShowFooterText__c,ShowHeaderText__c,SObjectName__c,
                                Status__c,Type__c,Version__c,ViewLayoutConfig__c,Id,Name,RecordType.Name FROM PageTemplate__c where id =: cloneId WITH USER_MODE];
        }
        ptnew = pt.clone();
        if(Schema.sObjectType.PageTemplate__c.isCreateable()){
            insert ptnew;//FLS False +ve as it is not supported for portal/guest users
        }
        
        String resultId;
        if(pt.EditLayoutConfig__c == pt.PrintLayoutConfig__c && pt.EditLayoutConfig__c == pt.ViewLayoutConfig__c) {
            String recordId  = pt.ViewLayoutConfig__c;
            
            String serialisedData = SObjectDataLoader.serialize(new Set<Id> { recordId });
            Set<Id> recordIds = SObjectDataLoader.deserialize(serialisedData);
            
            Id newId = (new list<Id>(recordIds)[0]);
            if(Schema.sObjectType.PageTemplate__c.fields.EditLayoutConfig__c.isCreateable() && Schema.sObjectType.PageTemplate__c.fields.EditLayoutConfig__c.isUpdateable()){           
                ptnew.EditLayoutConfig__c = newId;
            }
            if(Schema.sObjectType.PageTemplate__c.fields.PrintLayoutConfig__c.isCreateable() && Schema.sObjectType.PageTemplate__c.fields.PrintLayoutConfig__c.isUpdateable()){
                ptnew.PrintLayoutConfig__c = newId;
            }
            if(Schema.sObjectType.PageTemplate__c.fields.ViewLayoutConfig__c.isCreateable() && Schema.sObjectType.PageTemplate__c.fields.ViewLayoutConfig__c.isUpdateable()){
                ptnew.ViewLayoutConfig__c = newId;
            }
            if(Schema.sObjectType.PageTemplate__c.isCreateable() && Schema.sObjectType.PageTemplate__c.isUpdateable()){
                upsert ptnew;//FLS False +ve as it is not supported for portal/guest users
            }
            PageLayoutConfig__c plCone;
            if(Schema.sObjectType.PageLayoutConfig__c.isAccessible()) {
                plCone = [SELECT ID,Name FROM PageLayoutConfig__c where Id =:newId WITH USER_MODE];
            }
            if(Schema.sObjectType.PageLayoutConfig__c.fields.Name.isCreateable() && Schema.sObjectType.PageLayoutConfig__c.fields.Name.isUpdateable()){
                plCone.Name = 'Cloned_'+ newId + '_'+ plCone.Name;
            }

            if(Schema.sObjectType.PageLayoutConfig__c.isCreateable() && Schema.sObjectType.PageLayoutConfig__c.isUpdateable()){
                upsert plCone;//FLS False +ve as it is not supported for portal/guest users
            }

            resultId = Id.valueOf(plCone.Id);
            
            
        }    
        return resultId;    
    }

    // Deprecated Method..
    WebService static void  doClone( String cloneId ) {
        PageTemplate__c ptnew;
        PageTemplate__c pt;
        if(Schema.sObjectType.PageTemplate__c.isAccessible()) {
                pt =[SELECT AllowedCharsForRichTextArea__c,CustomAppConfig__c,Description__c,DisplayName__c,NextPageURL__c,RedirectBehaviour__c,
                        EditLayoutConfig__c,FormDisplayType__c,FormType__c,GroupName__c,HelpConfig__c,OMBExpiration__c,OMBNumber__c,RTALimitConfig__c,
                        PackageType__c,ParentObjectFieldAPI__c,PrintLayoutConfig__c,ShowFooterText__c,ShowHeaderText__c,SObjectName__c,
                        Status__c,Type__c,Version__c,ViewLayoutConfig__c,Id,Name,RecordType.Name FROM PageTemplate__c where id =: cloneId WITH USER_MODE];
        }
        ptnew = pt.clone();
        if(Schema.sObjectType.PageTemplate__c.isCreateable()){
            insert ptnew;//FLS False +ve as it is not supported for portal/guest users
        }
        String resultId;
        if(pt.EditLayoutConfig__c == pt.PrintLayoutConfig__c && pt.EditLayoutConfig__c == pt.ViewLayoutConfig__c) {
            String recordId  = pt.ViewLayoutConfig__c;
            
            String serialisedData = SObjectDataLoader.serialize(new Set<Id> { recordId });
            Set<Id> recordIds = SObjectDataLoader.deserialize(serialisedData);
            
            Id newId = (new list<Id>(recordIds)[0]);
            if(Schema.sObjectType.PageTemplate__c.fields.EditLayoutConfig__c.isCreateable() && Schema.sObjectType.PageTemplate__c.fields.EditLayoutConfig__c.isUpdateable()){                       
                ptnew.EditLayoutConfig__c = newId;
            }
            if(Schema.sObjectType.PageTemplate__c.fields.PrintLayoutConfig__c.isCreateable() && Schema.sObjectType.PageTemplate__c.fields.PrintLayoutConfig__c.isUpdateable()){
                ptnew.PrintLayoutConfig__c = newId;
            }
            if(Schema.sObjectType.PageTemplate__c.fields.ViewLayoutConfig__c.isCreateable() && Schema.sObjectType.PageTemplate__c.fields.ViewLayoutConfig__c.isUpdateable()){
                ptnew.ViewLayoutConfig__c = newId;
            }
            if(Schema.sObjectType.PageTemplate__c.isCreateable() && Schema.sObjectType.PageTemplate__c.isUpdateable()){
                upsert ptnew;//FLS False +ve as it is not supported for portal/guest users
            }
        }   
    }
}