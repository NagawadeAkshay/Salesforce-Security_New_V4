/**
    Syncs records from the following custom objects to their equivalent custom settings.
    Synching happens for all insert, update & delete operations on the custom objects. This class is designed
    to work for any custom object and list custom setting as long as the field API names are the same 
    between those sobject types. Also the custom setting is required to have a field called 'SourceRecordId__c'
    which will be stored with the custom object record id.
     
    Currently thsi helper class is used for the following 6 objects. It is called from the triggers defined
    on the corresponding custom objects.
    
    Source (Custom Object)          Destination (Custom Setting)
    ----------------------          ----------------------------
    PageLayoutConfig__c             PageLayoutConfig__c
    TabConfig__c                    TabConfig__c
    PageBlockConfig__c              PageBlockConfig__c
    PageBlockDetailConfig__c        PageBlockDetailConfig__c
    OpportunityStageConfig__c       StageName__c
    StepReviewConfig__c             StepReviewCache__c
    
    **********************************************************
    Audit History
    **********************************************************
    3/28/2012   Shah Kadirmohideen      Created
    **********************************************************  
*/
public with sharing class DataSyncTriggerHelper extends TriggerHelper {
    private Schema.SObjectType targetSObjectType; 
    private String targetObjectName;
    private String namespacePrefix;
    private static String SOURCE_RECORD_ID_FIELD_NAME = 'SourceRecordId__c';
    private List<SObject> sObjectActiveList;
    //Constructor 
    public DataSyncTriggerHelper(Schema.SObjectType targetSObjectType) {
        this.targetSObjectType = targetSObjectType;
        this.targetObjectName = targetSObjectType.getDescribe().getName();  //will not be counted against governor limit
        this.namespacePrefix = AppUtils.getNameSpacePrefix();
        this.sObjectActiveList = Trigger.New;
    } 

    public DataSyncTriggerHelper(Schema.SObjectType targetSObjectType, List<SObject> sObjectActiveList){
        this.targetSObjectType = targetSObjectType;
        this.targetObjectName = targetSObjectType.getDescribe().getName();  //will not be counted against governor limit
        this.namespacePrefix = AppUtils.getNameSpacePrefix();
        this.sObjectActiveList = sObjectActiveList; 
    } 
    
    public override void processAfterInsert() {
        copyRecord();
    }
    
    public override void processAfterUpdate() {
        copyRecord(); 
    }
    
    public override void processBeforeDelete() {
        deleteRecord();
    }
    
    /* PRIVATE METHODS */
    
    /*
        When a record is created or updated on any of the 4 custom objects, this method performs an upsert
        on their equivalent custom setting to sync up the record. It is just one way sync.
    */
    private void copyRecord() {
    	/* passed internalUniqueId 							: AJ */
    	Set<String> internalUniqueId = new Set<String>(); 
        for(SObject record : sObjectActiveList) {
	    	internalUniqueId.add((String)record.get(namespacePrefix + 'InternalUniqueID__c'));
    	} 
	 	Map<String, SObject> targetRecordsMap = fetchTargetRecords(internalUniqueId);
        
        //Map<String, SObject> targetRecordsMap = fetchTargetRecords(Trigger.NewMap.keySet());
        List<SObject> insertTargetRecords = new List<SObject>();
        List<SObject> updateTargetRecords = new List<SObject>();
         String objName ='';
        for (SObject record : sObjectActiveList) {
            //SObject targetRec = targetRecordsMap.get(record.Id);
            if(String.isBlank(objName))
            objName = record.Id.getSobjectType().getDescribe().getName();
            SObject targetRec = targetRecordsMap.get((String)record.get(namespacePrefix + 'InternalUniqueID__c'));
            if (targetRec == null) {
                targetRec = targetSObjectType.newSObject();
                String upsertField = getSourceRecordIdFieldName();
                //targetRec.put(getSourceRecordIdFieldName(), record.Id);
                targetRec.put(getSourceRecordIdFieldName(), (String)record.get(namespacePrefix + 'InternalUniqueID__c'));
                insertTargetRecords.add(targetRec);
            }
            else {
                updateTargetRecords.add(targetRec);
            }
            AppUtils.copyFieldValues(record, targetRec, new Set<String>{'OwnerId'});
        }
            if(AppUtils.isObjectCreateable(objName)){
                   insert as user insertTargetRecords; //FLS/ CRUD False +ve with the help of apputil we have performed check
            }

            if(AppUtils.isObjectUpdateable(objName)){
                update as user updateTargetRecords; //FLS/ CRUD False +ve with the help of apputil we have performed check
            }
        }
    
    
    /*
        When a record is deleted on any of the 4 custom objects, this method deletes
        it on its equivalent custom setting as well.
    */
    private void deleteRecord() {
    	/* passed internalUniqueId 							: AJ */
    	Set<String> internalUniqueId = new Set<String>(); 
    	internalUniqueId.add((String)Trigger.Old[0].get(namespacePrefix + 'InternalUniqueID__c'));
	 	Map<String, SObject> targetRecordsMap = fetchTargetRecords(internalUniqueId);
        
        //Map<String, SObject> targetRecordsMap = fetchTargetRecords(Trigger.OldMap.keySet());
        List<SObject> deleteTargetRecords = new List<SObject>();

        for (SObject record : Trigger.Old) {
            //SObject targetRec = targetRecordsMap.get(record.Id);
            SObject targetRec = targetRecordsMap.get((String)record.get(namespacePrefix + 'InternalUniqueID__c'));
            if (targetRec != null) {
                deleteTargetRecords.add(targetRec);
            }
        }
        if(deleteTargetRecords!= null && deleteTargetRecords.size()>0){
            SystemContextMethodsHelper cls = new SystemContextMethodsHelper();
            String objName = cls.getSobjectName(deleteTargetRecords[0]);
            if(AppUtils.isObjectDeletable(objName)){
                delete as user deleteTargetRecords; //FLS/ CRUD False +ve with the help of apputil we have performed check
            }
        }
 		
    }
    
    /*
        For a given set of record ids (from a custom object), it fetches the matching records from another object 
        as specified by 'targetObjectName' variable.
    */
    private Map<String, SObject> fetchTargetRecords(Set<String> inputRecordIds) {
        String soql = 'Select Id, ' + String.escapeSingleQuotes(getSourceRecordIdFieldName()) + ' from ' + String.escapeSingleQuotes(targetObjectName) + ' where ' + 
                            String.escapeSingleQuotes(getSourceRecordIdFieldName()) + ' IN: inputRecordIds';
        List<SObject> records;
        if(AppUtils.isObjectAccessible(targetObjectName)){     //CRUD/FLS False +ve with the help of AppUtils we have performed check
            records = Database.query(soql, AccessLevel.USER_MODE); //SOQL Injection - False +ve - Dynamic part of query is escapeSingleQuotes/static bind
        }
        Map<String, SObject> objectMap = new Map<String, SObject>();  //key->value from 'Name' field
        for (SObject record : records) {
            objectMap.put((String) record.get(getSourceRecordIdFieldName()), record);
        }
        return objectMap;
    }
    
    //Prepares the source record id field name along with the namespace prefix
    private String getSourceRecordIdFieldName() {
        return namespacePrefix + SOURCE_RECORD_ID_FIELD_NAME;
    }

}