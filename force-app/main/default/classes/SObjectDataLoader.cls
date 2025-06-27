global with sharing class SObjectDataLoader {

    global with sharing class SerializeConfig {
        protected Set<Schema.SObjectField> followRelationships;
        protected Set<Schema.SObjectField> keepRelationshipValues;
        protected Set<Schema.SObjectField> followChildRelationships;
        protected Set<Schema.SObjectField> omitFields;
        protected Map<String,List<String>> userFieldWhiteListMap;
        protected Map<String,List<String>> userChildRelationshipWhiteListMap;
        protected Set<String> blacklistedNamespacePrefix;
        protected Boolean omitCurrencyField;
        protected Map<Schema.SObjectType, Map<String, Schema.SObjectField>> objectFieldDescribeMap;        
        
        public SerializeConfig() {   
            followRelationships = new Set<Schema.SObjectField>();
            keepRelationshipValues = new Set<Schema.SObjectField>(); 
            followChildRelationships = new Set<Schema.SObjectField>();
            omitFields = new Set<Schema.SObjectField>();    
            userFieldWhiteListMap = new Map<String,List<String>>(); 
            userChildRelationshipWhiteListMap = new Map<String,List<String>>();     
            blacklistedNamespacePrefix = new Set<String>();
            omitCurrencyField =false;
            objectFieldDescribeMap = new Map<Schema.SObjectType, Map<String, Schema.SObjectField>>();
        }

        public SerializeConfig follow(Schema.SObjectField relationshipField) {
            followRelationships.add(relationshipField);
            return this;
        }

        public SerializeConfig keepValue(Schema.SObjectField relationshipField) {
            keepRelationshipValues.add(relationshipField);
            return this;
        }
        

        public SerializeConfig followChild(Schema.SObjectField relationshipField) {
            followChildRelationships.add(relationshipField);
            return this;
        }
        
        public SerializeConfig omit(Schema.SObjectField omitField) {
            omitFields.add(omitField);
            if(followRelationships.contains(omitField))
                followRelationships.remove(omitField);
            if(keepRelationshipValues.contains(omitField))
                keepRelationshipValues.remove(omitField);
            if(followChildRelationships.contains(omitField))
                followChildRelationships.remove(omitField);
            return this;
        }
        
        public SerializeConfig auto(Schema.SObjectType sObjectType) {
            followRelationships = new Set<Schema.SObjectField>();
            keepRelationshipValues = new Set<Schema.SObjectField>(); 
            followChildRelationships = new Set<Schema.SObjectField>();
            omitFields = new Set<Schema.SObjectField>();
            Set<Schema.SObjectType> searched = new Set<Schema.SObjectType>();
            Set<Schema.SObjectType> searchedParentOnly = new Set<Schema.SObjectType>(); 
            searchRelationships(sObjectType, 0, 0, true, searched, searchedParentOnly); 
            return this;    
        }

        public SerializeConfig addToUserChildRelationShipWhiteList(Map<String,List<String>> childRelationShipWhiteListMap) {
            UserChildRelationshipWhiteListMap.putAll(childRelationShipWhiteListMap);
            return this;
        }
        
        public SerializeConfig addToUserFieldWhiteList(Map<String,List<String>> FieldWhiteListMap) {
            userFieldWhiteListMap.putAll(FieldWhiteListMap);
            return this;
        }
        
        public SerializeConfig addToBlacklistedNamespace(Set<String> NamespaceList) {
            blacklistedNamespacePrefix.addAll(NamespaceList);
            return this;
        }
        
        public SerializeConfig omitCommonFields(Set<String> fieldnames) {
            if(fieldnames!=null && fieldnames.size()>0) {
                fieldWhitelist.addAll(fieldnames);
                if(fieldnames.contains('CurrencyIsoCode'))
                    omitCurrencyField = true;
            }
            return this;
        }
        
        private void searchRelationships(Schema.SObjectType sObjectType, Integer lookupDepth, Integer childDepth, Boolean searchChildren, Set<Schema.SObjectType> searched, Set<Schema.SObjectType> searchedParentOnly) {   
            if(searched.contains(sObjectType) || (searchChildren == false && searchedParentOnly.contains(sObjectType)) || lookupDepth > 5 || childDepth > 3) 
                return;
            if (searchChildren) {
                searched.add(sObjectType);
            } else {
                searchedParentOnly.add(sObjectType);
            }
            Schema.DescribeSObjectResult sObjectDescribe = sObjectType.getDescribe();
            String sObjectName = sObjectType.getDescribe().getName();            
            if(searchChildren) {
                List<Schema.ChildRelationship> childRelationships = sObjectDescribe.getChildRelationships();
                Set<String> userChildRelationshipWhiteListSet = new Set<String>();      
                if(userChildRelationshipWhiteListMap.get(sObjectName)!= null && userChildRelationshipWhiteListMap.get(sObjectName).size()>0) {
                    userChildRelationshipWhiteListSet.addAll(userChildRelationshipWhiteListMap.get(sObjectName));
                }
                for(Schema.ChildRelationship childRelationship : childRelationships) {                    
                    String childRelationshipName = childRelationship.getRelationshipName();
                    if(childRelationshipName==null || 
                       childRelationshipWhitelist.contains(childRelationshipName) || userChildRelationshipWhiteListSet.contains(childRelationshipName) || matchNameSpaceForObject(childRelationshipName)) 
                        continue;
                    if(childRelationshipName.endsWith('Histories')) 
                        continue;
                    if(!childRelationship.isCascadeDelete()) 
                        continue;
                    followChild(childRelationship.getField()).
                        searchRelationships(childRelationship.getChildSObject(), lookupDepth, childDepth+1, true, searched, searchedParentOnly);
                }
            }
            Map<String, Schema.SObjectField> sObjectFields = objectFieldDescribeMap.get(sObjectType);
            if (sObjectFields == null) {
                sObjectFields = sObjectDescribe.fields.getMap();
                objectFieldDescribeMap.put(sObjectType, sObjectFields);
            }
            
            Set<String> userWhiteListSet = new Set<String>();
            if(userFieldWhiteListMap.get(sObjectName)!= null && userFieldWhiteListMap.get(sObjectName).size()>0) {
                userWhiteListSet.addAll(userFieldWhiteListMap.get(sObjectName));
            }           

            for(Schema.SObjectField sObjectField : sObjectFields.values())
                if(sObjectField.getDescribe().getType() == Schema.DisplayType.Reference) {
                    Boolean omitRefernceToFields = false;
                    for(Schema.sObjectType refernceToType : sObjectField.getDescribe().getReferenceTo()){
                        if(referenceToWhitelist.contains(refernceToType.getDescribe().getName()))
                            omitRefernceToFields = true;
                    }
                    if(!followChildRelationships.contains(sObjectField) && !relationshipWhitelist.contains(sObjectField.getDescribe().getName()) && !omitRefernceToFields && !userWhiteListSet.contains(sObjectField.getDescribe().getName()) && !matchNameSpaceForObject(sObjectField.getDescribe().getName())) {
                        if(sObjectField.getDescribe().getReferenceTo()!=null && sObjectField.getDescribe().getReferenceTo().size()>0)
                            follow(sObjectField).
                                searchRelationships(sObjectField.getDescribe().getReferenceTo()[0], lookupDepth+1, childDepth, false, searched, searchedParentOnly);
                    }
                }
                else if(userWhiteListSet.contains(sObjectField.getDescribe().getName()) || matchNameSpaceForObject(sObjectField.getDescribe().getName()))
                {
                    omit(sObjectField);
                }
                else if(fieldWhitelist.contains(sObjectField.getDescribe().getName())) {
                    omit(sObjectField);
                } 
        }

        private Boolean matchNameSpaceForObject(String ObjectName) {
            Boolean namespaceMatched = false;
            for(String namespaceExcluded : blacklistedNamespacePrefix) {
                namespaceExcluded = namespaceExcluded.trim()+'__';
                if(ObjectName.startsWith(namespaceExcluded))
                    namespaceMatched = true;
            }
            return namespaceMatched;
        } 
        
        private Set<String> relationshipWhitelist = 
            new Set<String>
                { 'OwnerId',
                  'CreatedById',
                  'LastModifiedById',
                  'ProfileId',
                  AppUtils.getNameSpacePrefix() + 'InternalUniqueID__c'                  
                };
                

        private Set<String> childRelationshipWhitelist = 
            new Set<String> 
                { 'Shares', 
                  'ProcessInstances', 
                  'ProcessSteps', 
                  'Tasks', 
                  'ActivityHistories', 
                  'Attachments', 
                  'FeedSubscriptionsForEntity', 
                  'Events', 
                  'Notes', 
                  'NotesAndAttachments', 
                  'OpenActivities', 
                  'Histories', 
                  'Feeds',
                  'CombinedAttachments',
                  'ContentDocuments',
                  'ContentVersions',
                  'AttachedContentDocuments',
                  'RecordAssociatedGroups',
                  AppUtils.getNameSpacePrefix() + 'SobjectConfig__c'
                  };        
    

        private Set<String> referenceToWhitelist = 
            new Set<String>
                { 'User',
                  'Organization',
                  AppUtils.getNameSpacePrefix() + 'PhaseConfig__c',
                  AppUtils.getNameSpacePrefix() + 'ChartConfig__c',
                  AppUtils.getNameSpacePrefix() + 'SobjectConfig__c',
                  AppUtils.getNameSpacePrefix() + 'DataTableConfig__c'
                };
    

        private Set<String> fieldWhitelist = 
            new Set<String>
                {
                    'LastViewedDate',
                    'LastReferencedDate',

                    'MailingAddress',
                    'OtherAddress',
                    'BillingAddress',
                    'ShippingAddress',
                    'Address',
                    AppUtils.getNameSpacePrefix() + 'InternalUniqueID__c' 
                };
                
    }
    
    
    public static String serialize(Set<Id> ids) {        
        if(ids==null || ids.size()==0)
            throw new SerializerException('List of Ids cannot be null or empty.');
        
        Map <Schema.SObjectType,SerializeConfig> strategyBySObjectType = new Map <Schema.SObjectType,SerializeConfig>();
    
        for(Id idRecord : ids) {
            Schema.SObjectType sObjectType = idRecord.getSObjectType();
            if(strategyBySObjectType.get(sObjectType)==null) {
                strategyBySObjectType.put(sObjectType,new SerializeConfig().auto(idRecord.getSObjectType()));
            }
        }
        
        return serialize(ids,strategyBySObjectType);
    }

    public static String serialize(Set<Id> ids, SerializeConfig strategy) {
        return serialize(ids, new Map<Schema.SObjectType, SerializeConfig> { new List<Id>(ids)[0].getSObjectType() => strategy });
    }

    public static String serialize(Set<Id> ids, Map <Schema.SObjectType,SerializeConfig> strategyBySObjectType) {                   
        if(ids==null || ids.size()==0)
            throw new SerializerException('List of Ids cannot be null or empty.');
                    
        RecordsBundle recordsToBundle = new RecordsBundle();
        recordsToBundle.recordSetBundles = new List<RecordSetBundle>();     
        recordsToBundle.recordSetBundlesByType = new Map<String, RecordSetBundle>();
                
        Map <Schema.SObjectType,Set<Id>> recordMapToSerialize = new Map <Schema.SObjectType,Set<Id>>();
        for(Id idRecord : ids) {
            Schema.SObjectType sObjectType = idRecord.getSObjectType();
            if(recordMapToSerialize.get(sObjectType)!=null) {
                recordMapToSerialize.get(sObjectType).add(idRecord);
            }
            else {
                Set<Id> idSet = new Set<Id>();
                idSet.add(idRecord);
                recordMapToSerialize.put(sObjectType,idSet);
            }
        }
        Map<String,Set<Id>> processedIds = new Map<String,Set<Id>>();
        Map<Id, SObject> recordsSerialized = new Map<Id, Sobject>();
        Set<Schema.SObjectType> sObjectTypeSet = recordMapToSerialize.keySet();
        for(Schema.SObjectType sobjectTypes : sObjectTypeSet) {
            serialize(recordMapToSerialize.get(sobjectTypes), sobjectTypes, null, strategyBySObjectType.get(sobjectTypes), 0, 0, recordsToBundle, new Set<Id>());
        }       
        
        recordsToBundle.setRecordTypeMap();
        
        return JSON.serialize(recordsToBundle);             
    }

    public static Set<Id> deserialize(String recordsBundleAsJSON)
    {
        return deserialize(recordsBundleAsJSON, null);
    }
        
    public static Set<Id> deserialize(String recordsBundleAsJSON, IDeserializeCallback callback) {        
        RecordsBundle recordsBundle = (RecordsBundle) 
            JSON.deserialize(recordsBundleAsJSON, SObjectDataLoader.RecordsBundle.class); //Deserializing objects from an untrusted source is security-sensitive : False+ve as the JSON data being processed is controlled input through the code and not directly provided by users, the JSON structure is predefined and static, with no opportunity for external manipulation and the values from this JSON are accessed using static keys, ensuring that only expected data is retrieved.
        return new Map<Id, SObject>(recordsBundle.recordSetBundles[0].Records).keySet();
    }
    
    private static void updateReferenceFieldsInRecords(List<Schema.SObjectField> relationshipsFields,Set<Schema.SObjectField> filteredUnresolvedFieldReferences,Map<Id, SObject> recordsByOriginalId,Sobject orignalRecord,Set<Schema.SObjectField> allUnresolvedFieldReferences) {   
        for(Schema.SObjectField sObjectField : relationshipsFields) {                                       
            Id oldRelatedRecordId = (Id) orignalRecord.get(sObjectField);
            if(oldRelatedRecordId!=null) {
                SObject newRelatedRecord = recordsByOriginalId.get(oldRelatedRecordId);
                Sobject newRecord ;
                if(newRelatedRecord!=null && newRelatedRecord.Id!=null) {
                    newRecord = recordsByOriginalId.get(orignalRecord.ID);
                    newRecord.put(sObjectField, newRelatedRecord.Id);
                }
                else {
                    filteredUnresolvedFieldReferences.add(sObjectField);
                }
            }
            else if(allUnresolvedFieldReferences!=null) {
                allUnresolvedFieldReferences.add(sObjectField);
            }
        }
            if(allUnresolvedFieldReferences!=null) {
                allUnresolvedFieldReferences.addAll(filteredUnresolvedFieldReferences);
            }
    }

    private static void  processUnresolvedRecords(List<UnresolvedReferences> unresolvedReferencesByRecord,Map<Id, SObject> recordsByOriginalId) {    
        List<UnresolvedReferences> unresolvedReferences = new List<UnresolvedReferences>(); 
        Integer recordsSize = unresolvedReferencesByRecord.size();
        if(recordsSize >0) {
            List<Sobject> insertResolvedRecords = new List<Sobject>();
            String sobjectName = '';
            
            for(UnresolvedReferences filteredReference : unresolvedReferencesByRecord) {
                if(String.isBlank(sobjectName)){ //Added for SF review 
                    sobjectName = filteredReference.record.Id.getSobjectType().getDescribe().getName();
                }
                List <Schema.SObjectField> referenceFields = new List<Schema.SObjectField>(filteredReference.References);
                Set<Schema.SobjectField> filteredreferenceFields = new Set<Schema.SobjectField>();
                Sobject oldRecord = filteredReference.Record;
                SObject unprocessedRecord = recordsByOriginalId.get(oldRecord.Id);
                updateReferenceFieldsInRecords(referenceFields, filteredreferenceFields, recordsByOriginalId, oldRecord,null);
                if(filteredreferenceFields.size() >0) {
                     filteredReference.References = filteredreferenceFields;
                     unresolvedReferences.add(filteredReference);
                }
                else {
                     insertResolvedRecords.add(unprocessedRecord);
                }
            }
            unresolvedReferencesByRecord.clear();
            unresolvedReferencesByRecord.addAll(unresolvedReferences);

            if(insertResolvedRecords.size()>0) {
                if(AppUtils.isObjectAccessible(sobjectName) && AppUtils.isObjectCreateable(sobjectName)) { //Added for SF review  
                    insert insertResolvedRecords; //NOPMD CRUD/FLS False +ve with the help of AppUtils we have performed check //FLS False +ve As per business scenario it is breaking for portal/guest users.
                }
                processUnresolvedRecords(unresolvedReferencesByRecord,recordsByOriginalId);
            }       
        }
    }

    private static void serialize(Set<ID> ids, Schema.SObjectType sObjectType, Schema.SObjectField queryByIdField, SerializeConfig config, Integer lookupDepth, Integer childDepth, RecordsBundle recordsToBundle, Set<Id> processedIds) {               
        if(config==null)
            throw new SerializerException('Must pass a valid SerializeConfig instance.');        
        if(lookupDepth > 5 || childDepth > 5) 
            return;

        Schema.DescribeSObjectResult sObjectDesc = sObjectType.getDescribe();

        if (queryByIdField == null) {
            ids.removeAll(processedIds);
        }
        processedIds.addAll(ids);
        if (ids.size() == 0) return;        
        
        if(!sObjectDesc.queryable || !sObjectDesc.isCreateable()) return;
        Map<String, Schema.SObjectField> sObjectFields = config.objectFieldDescribeMap.get(sObjectType);        
        if (sObjectFields == null) {
            sObjectFields = sObjectDesc.fields.getMap();
            config.objectFieldDescribeMap.put(sObjectType, sObjectFields);
        }
        List<Schema.SObjectField> sObjectFieldsToSerialize = listFieldsToSerialize(sObjectFields, config);
                                
        String fieldList = null;
        for(Schema.SObjectField sObjectField : sObjectFieldsToSerialize)
            fieldList = fieldList == null ? sObjectField.getDescribe().getName() : fieldList + ',' + sObjectField.getDescribe().getName();
        String query = String.format('select {0} from {1} where {2} in :ids order by {2}', 
            new List<String> { fieldList, sObjectDesc.getName(), queryByIdField == null ? 'id' : queryByIdField.getDescribe().getName(), 'Name' });
            Map<Id, SObject> recordsToSerializeById = new Map<Id, SObject>(Database.query(query));
        if(recordsToSerializeById.size()==0)
            return;
        
        Set<Schema.SObjectField> sObjectFollowRelationships = config.followRelationships.clone();
        sObjectFollowRelationships.retainAll(sObjectFields.values());
        if(sObjectFollowRelationships.size()>0) {                           
            Map<Schema.DescribeFieldResult, Set<Id>> relationshipsByField = new Map<Schema.DescribeFieldResult, Set<Id>>(); 
            for(Schema.SObjectField sObjectField : sObjectFollowRelationships)
                relationShipsByField.put(sObjectField.getDescribe(), new Set<Id>() );           
            for(SObject recordToSerialize : recordsToSerializeById.values()) {
                for(Schema.DescribeFieldResult relationshipField : relationshipsByField.keySet()) {
                    Id relatedId = (Id) recordToSerialize.get(relationshipField.getSObjectField());
                    if(relatedId!=null)
                        relationshipsByField.get(relationshipField).add(relatedId);
                }
            }            
            for(Schema.DescribeFieldResult relationshipField : relationshipsByField.keySet()) {
                Set<Id> relatedRecordIds = relationshipsByField.get(relationshipField);
                if(relatedRecordIds.size()>0)
                    serialize(relatedRecordIds, relationshipField.getReferenceTo()[0], null, config, lookupDepth+1, childDepth, recordsToBundle, processedIds);                 
            }
        }
                            
        RecordSetBundle recordSetBundle = recordsToBundle.recordSetBundlesByType.get(sObjectDesc.getName());
        if(recordSetBundle!=null) {
            recordSetBundle.Records.addAll(recordsToSerializeById.values());
        }
        else if(recordSetBundle==null) {
            recordSetBundle = new RecordSetBundle();
            recordSetBundle.ObjectType = sObjectDesc.getName();
            recordSetBundle.Records = recordsToSerializeById.values();
            recordsToBundle.recordSetBundles.add(recordSetBundle);
            recordsToBundle.recordSetBundlesByType.put(recordSetBundle.ObjectType, recordSetBundle);
        }
                        
        List<Schema.ChildRelationship> childRelationships = sObjectDesc.getChildRelationships();
        for(Schema.ChildRelationship childRelationship : childRelationships) {             
            Schema.SObjectType childSObjectType = childRelationship.getChildSObject();
            if(config.followChildRelationships.contains(childRelationship.getField()))
                serialize(recordsToSerializeById.keySet(), childSObjectType, childRelationship.getField(), config, lookupDepth, childDepth+1, recordsToBundle, processedIds);
        }
    }
    
    private static List<Schema.SObjectField> listFieldsToSerialize(Map<String, Schema.SObjectField> sObjectFields, SerializeConfig config) {        
        List<Schema.SObjectField> serializeFields = new List<Schema.SObjectField>(); 
        List<String> fieldNames = new List<String>(sObjectFields.keySet());
        fieldNames.sort();
        for(String fieldName : fieldNames) {            
            Schema.SObjectField sObjectField = sObjectFields.get(fieldName);
            if(config.omitFields!=null && config.omitFields.contains(sObjectField))
                continue;            
            Schema.DescribeFieldResult sObjectFieldDescribe = sObjectField.getDescribe();
            if(sObjectFieldDescribe.isAutoNumber() ||
               sObjectFieldDescribe.isCalculated())
               continue;                
            if(sObjectFieldDescribe.getType() == Schema.DisplayType.Reference)
                if(!(config.followRelationships.contains(sObjectField) ||
                     config.keepRelationshipValues.contains(sObjectField) || 
                     config.followChildRelationships.contains(sObjectField)))
                   continue;            
            serializeFields.add(sObjectField);
        }           
        return serializeFields; 
    }
    
    public static Map<String,List<Sobject>> deserializedRecords(String recordsBundleAsJSON) {
        Map<String,List<Sobject>> recordBundleMap = new Map<String,List<Sobject>>();
        RecordsBundle recordsBundle = (RecordsBundle) 
            JSON.deserialize(recordsBundleAsJSON, SObjectDataLoader.RecordsBundle.class); //Deserializing objects from an untrusted source is security-sensitive : False+ve as the JSON data being processed is controlled input through the code and not directly provided by users, the JSON structure is predefined and static, with no opportunity for external manipulation and the values from this JSON are accessed using static keys, ensuring that only expected data is retrieved.
        for(RecordSetBundle recordSetBundle : recordsBundle.recordSetBundles) {
            List<Sobject> recordList = new List<Sobject>();
            if(recordBundleMap.get(recordSetBundle.ObjectType)!= null)
                recordList.addAll(recordBundleMap.get(recordSetBundle.ObjectType)); 
            else
                recordList.addAll(recordSetBundle.Records);
            recordBundleMap.put(recordSetBundle.ObjectType, recordList);
        }
        return recordBundleMap; 
    }

    public with sharing class SerializerException extends Exception {
        
    }

    public interface IDeserializeCallback {
        void unresolvedReferences(Schema.SObjectType sObjectType, List<UnresolvedReferences> unresolvedReferences);
    }
    
    public with sharing class UnresolvedReferences {
        public SObject Record;
        public Set<Schema.SObjectField> References;
    }

    private with sharing class RecordsBundle {        
        public List<RecordSetBundle> RecordSetBundles;          
        public transient Map<String, RecordSetBundle> RecordSetBundlesByType;       
        public Map<Id, RecordType> recordTypeMap;
        public void setRecordTypeMap() {
            Map<String,Schema.SObjectType> globalDesc = Schema.getGlobalDescribe();            
            Set<Id> recordTypeIds = new Set<Id>();
            for (RecordSetBundle bundle : RecordSetBundles) {
                SObjectType accountType = globalDesc.get(bundle.ObjectType);
                Map<String,Schema.SObjectField> mfields = accountType.getDescribe().fields.getMap();                
                                
                if (mfields.containsKey('recordtypeid')) {
                    for (SObject obj : bundle.Records) {
                        if (obj.get('RecordTypeId') != null) {
                            recordTypeIds.add((id)obj.get('RecordTypeId'));
                        }
                    }                   
                }

            }           
            recordTypeMap = new Map<Id, RecordType>([SELECT Id, Description, DeveloperName, Name, SobjectType 
                                                    FROM RecordType WHERE Id=:recordTypeIds WITH USER_MODE]);//CRUD/FLS False +ve As per business scenario we can't check for portal/external users
        }       
    }

    private with sharing class RecordSetBundle {
        public String ObjectType;
        public List<SObject> Records;   
    }
}