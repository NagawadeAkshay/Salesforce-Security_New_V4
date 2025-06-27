public with sharing class SobjectAutoSnapCacheSyncTriggerHelper extends TriggerHelper{
    private String namespacePrefix;
   
    private List<SObjectAutoSnapshot__c> sObjectActiveList;
    
    // Constructor
    public SobjectAutoSnapCacheSyncTriggerHelper(List<SObjectAutoSnapshot__c> sobjeAutoSnapList){
       this.namespacePrefix = AppUtils.getNameSpacePrefix(); 
       this.sObjectActiveList = sobjeAutoSnapList;    
    } 
    
    public override void processAfterInsert() {
        insertRecord();
    }
    
    public override void processAfterUpdate() {
        updateRecord(); 
    }
    
    private void insertRecord() {
        Map<String, SObjectAutoSnapshotCache__c> objectMap = new Map<String, SObjectAutoSnapshotCache__c >();
        List<SObjectAutoSnapshotCache__c> insertTargetRecords = new List<SObjectAutoSnapshotCache__c>();
        for(SObjectAutoSnapshot__c sobjAutoObj : sObjectActiveList){
            SObjectAutoSnapshotCache__c sobjCache = new SObjectAutoSnapshotCache__c();  
            sobjCache = splitJsonExp(sobjCache, sobjAutoObj.ExpressionJSON__c);
            if(Schema.sObjectType.SObjectAutoSnapshotCache__c.fields.Name.isCreateable()){
                sobjCache.Name = sobjAutoObj.Name;
            }
            if(Schema.sObjectType.SObjectAutoSnapshotCache__c.fields.SobjectFieldConfigName__c.isCreateable()){
                sobjCache.SobjectFieldConfigName__c = sobjAutoObj.SobjectFieldConfigName__c;
            }
            if(Schema.sObjectType.SObjectAutoSnapshotCache__c.fields.SourceRecordId__c.isCreateable()){
                sobjCache.SourceRecordId__c = sobjAutoObj.InternalUniqueID__c;
            }
            if(Schema.sObjectType.SObjectAutoSnapshotCache__c.fields.SnapShotFileName__c.isCreateable()){
                sobjCache.SnapShotFileName__c = sobjAutoObj.SnapShotFileName__c;
            }
            if(Schema.sObjectType.SObjectAutoSnapshotCache__c.fields.SnapshotClassification__c.isCreateable()){
                sobjCache.SnapshotClassification__c = sobjAutoObj.SnapshotClassification__c;
            }
              //sobjCache.put(getSourceRecordIdFieldName(),sobjCache);
            insertTargetRecords.add(sobjCache);
        }
        if(Schema.sObjectType.SObjectAutoSnapshotCache__c.isCreateable() && insertTargetRecords.size() > 0){
            insert as user insertTargetRecords;
        }
     }
     
     private void updateRecord(){
        Set<String> configName = new Set<String>(); 
        Map<String, SObjectAutoSnapshotCache__c> objectMap = new Map<String, SObjectAutoSnapshotCache__c >();
        List<SObjectAutoSnapshotCache__c> updateTargetRecords = new List<SObjectAutoSnapshotCache__c>();
        for(SObjectAutoSnapshot__c  record : sObjectActiveList) {
            configName.add(record.Name);
        } 
        
        Map<String, SObjectAutoSnapshotCache__c> targetRecordsMap = fetchTargetRecords(configName);
        for(SObjectAutoSnapshot__c  record : sObjectActiveList){
             SObjectAutoSnapshotCache__c  sobjAutoCache = targetRecordsMap.get(record.Name); 
             if(sobjAutoCache !=null){
                sobjAutoCache = splitJsonExp(sobjAutoCache, record.ExpressionJSON__c);
                if(Schema.sObjectType.SObjectAutoSnapshotCache__c.fields.SobjectFieldConfigName__c.isCreateable() && Schema.sObjectType.SObjectAutoSnapshotCache__c.fields.SobjectFieldConfigName__c.isUpdateable()){
                    sobjAutoCache.SobjectFieldConfigName__c = record.SobjectFieldConfigName__c; 
                }
                if(Schema.sObjectType.SObjectAutoSnapshotCache__c.fields.SnapShotFileName__c.isCreateable() && Schema.sObjectType.SObjectAutoSnapshotCache__c.fields.SnapShotFileName__c.isUpdateable()){
                    sobjAutoCache.SnapShotFileName__c = record.SnapShotFileName__c;
                }
                if(Schema.sObjectType.SObjectAutoSnapshotCache__c.fields.SnapshotClassification__c.isCreateable() && Schema.sObjectType.SObjectAutoSnapshotCache__c.fields.SnapshotClassification__c.isUpdateable()){
                    sobjAutoCache.SnapshotClassification__c = record.SnapshotClassification__c;
                }
                  //sobjAutoCache.put(getSourceRecordIdFieldName(),sobjAutoCache);
                  updateTargetRecords.add(sobjAutoCache);                       
             }else{   
                SObjectAutoSnapshotCache__c sobjCache = new SObjectAutoSnapshotCache__c();
                sobjCache = splitJsonExp(sobjCache, record.ExpressionJSON__c);
                if(Schema.sObjectType.SObjectAutoSnapshotCache__c.fields.Name.isCreateable() && Schema.sObjectType.SObjectAutoSnapshotCache__c.fields.Name.isUpdateable()){
                    sobjCache.Name = record.Name;
                }
                if(Schema.sObjectType.SObjectAutoSnapshotCache__c.fields.SobjectFieldConfigName__c.isCreateable() && Schema.sObjectType.SObjectAutoSnapshotCache__c.fields.SobjectFieldConfigName__c.isUpdateable()){
                    sobjCache.SobjectFieldConfigName__c = record.SobjectFieldConfigName__c;
                }
                if(Schema.sObjectType.SObjectAutoSnapshotCache__c.fields.SourceRecordId__c.isCreateable() && Schema.sObjectType.SObjectAutoSnapshotCache__c.fields.SourceRecordId__c.isUpdateable()){
                    sobjCache.SourceRecordId__c =  record.InternalUniqueID__c;
                }
                if(Schema.sObjectType.SObjectAutoSnapshotCache__c.fields.SnapShotFileName__c.isCreateable() && Schema.sObjectType.SObjectAutoSnapshotCache__c.fields.SnapShotFileName__c.isUpdateable()){
                    sobjCache.SnapShotFileName__c = record.SnapShotFileName__c;
                }
                if(Schema.sObjectType.SObjectAutoSnapshotCache__c.fields.SnapshotClassification__c.isCreateable() && Schema.sObjectType.SObjectAutoSnapshotCache__c.fields.SnapshotClassification__c.isUpdateable()){
                    sobjCache.SnapshotClassification__c = record.SnapshotClassification__c;
                }
                updateTargetRecords.add(sobjCache);             
            }            
        }
        if(Schema.sObjectType.SObjectAutoSnapshotCache__c.isCreateable() && Schema.sObjectType.SObjectAutoSnapshotCache__c.isUpdateable() && updateTargetRecords.size() > 0){
            upsert as user updateTargetRecords;
        }           
     }
     
    
   /*
        For a given set of record ids (from a custom object), it fetches the matching records from another object 
        as specified by 'targetObjectName' variable.
    */
    private Map<String, SObjectAutoSnapshotCache__c> fetchTargetRecords(Set<String> configName) {
        List<SObjectAutoSnapshotCache__c> records = new List<SObjectAutoSnapshotCache__c>();
        if(Schema.sObjectType.SObjectAutoSnapshotCache__c.isAccessible()){
        records = [SELECT Id,Name,ExpressionJson__c,ExpressionJson2__c,ExpressionJson3__c,ExpressionJson4__c,SnapShotFileName__c,SnapshotClassification__c,SobjectFieldConfigName__c FROM SObjectAutoSnapshotCache__c WHERE Name IN:configName WITH USER_MODE];
        }
        Map<String, SObjectAutoSnapshotCache__c> objectMap = new Map<String, SObjectAutoSnapshotCache__c>();  //key->value from 'Name' field
        for (SObjectAutoSnapshotCache__c record : records) {
            objectMap.put(record.Name, record);
        }
        return objectMap;
    }
    
    // Mergering of json if json size greater than 255..
    private SObjectAutoSnapshotCache__c  splitJsonExp(SObjectAutoSnapshotCache__c  sobjAutoCache, String jsonExp){  
            if(String.isNotEmpty(jsonExp)){
                if(Schema.sObjectType.SObjectAutoSnapshotCache__c.fields.ExpressionJson__c.isCreateable() && Schema.sObjectType.SObjectAutoSnapshotCache__c.fields.ExpressionJson__c.isUpdateable()){
                    sobjAutoCache.ExpressionJson__c = jsonExp.mid(0,255);
                }
                if(Schema.sObjectType.SObjectAutoSnapshotCache__c.fields.ExpressionJson2__c.isCreateable() && Schema.sObjectType.SObjectAutoSnapshotCache__c.fields.ExpressionJson2__c.isUpdateable()){
                    sobjAutoCache.ExpressionJson2__c = jsonExp.mid(255,510);
                }
                if(Schema.sObjectType.SObjectAutoSnapshotCache__c.fields.ExpressionJson3__c.isCreateable() && Schema.sObjectType.SObjectAutoSnapshotCache__c.fields.ExpressionJson3__c.isUpdateable()){
                    sobjAutoCache.ExpressionJson3__c = jsonExp.mid(510,765);
                }
                if(Schema.sObjectType.SObjectAutoSnapshotCache__c.fields.ExpressionJson4__c.isCreateable() && Schema.sObjectType.SObjectAutoSnapshotCache__c.fields.ExpressionJson4__c.isUpdateable()){
                    sobjAutoCache.ExpressionJson4__c = jsonExp.mid(765,1020);
                }
            }
        return sobjAutoCache;  
    }       
}