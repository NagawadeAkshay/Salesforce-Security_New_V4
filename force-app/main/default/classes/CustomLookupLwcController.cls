/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 10-17-2024
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
public with sharing class CustomLookupLwcController { 

    public with sharing class CustomLookupWrapper{
        @AuraEnabled
        public list<sObject> sObjectList {get;set;}
        @AuraEnabled
        public Map<String, String> fieldLableMap {get;set;}
        @AuraEnabled
        public Map<String, String> fieldDataTypeMap {get;set;}
        @AuraEnabled
        public Map<String, Integer> scaleMap {get;set;}
        @AuraEnabled
        public String timeZone {get;set;}
        @AuraEnabled
        public String userLocale {get;set;}

        public CustomLookupWrapper(list<sObject> sObjectList, Map<String, String> fieldLableMap,Map<String, String> fieldDataTypeMap,Map<String, Integer> scaleMap) {
            this.sObjectList = sObjectList;
            this.fieldLableMap = fieldLableMap;
            this.fieldDataTypeMap = fieldDataTypeMap;
            this.scaleMap = scaleMap;
            this.timeZone = (UserInfo.getTimeZone()).toString();
            this.userLocale =UserInfo.getLocale();
        }
    }

    @AuraEnabled(cacheable=true)
    public static CustomLookupWrapper fetchLookupData(string searchKey , string sObjectApiName, String lookupfieldName,String fieldsName, string filterClause,String pageBlockDetailId) {    
        
        String objectName; 
        string sQuery = '';
        String sortField;
        String sortDirection;

        if(String.isNotEmpty(pageBlockDetailId)){
            List<PageBlockDetailConfig__c> pbdList = new List<PageBlockDetailConfig__c>();
            if(Schema.sObjectType.PageBlockDetailConfig__c.isAccessible()){
                pbdList = [SELECT Id,Name,DisplayLookupFieldNames__c,LookupSortBy__c,LookupSortDirection__c,LookupObjectAPIName__c,FilterCriteria__c 
                FROM PageBlockDetailConfig__c WHERE Id = :pageBlockDetailId WITH USER_MODE];
            }
            if(pbdList.size() > 0){
                // getting information through PageBlockDetail
                String displayFieldsTemp = pbdList[0].DisplayLookupFieldNames__c;
                String lookupSortBy = pbdList[0].LookupSortBy__c;
                String lookupSortDirection = pbdList[0].LookupSortDirection__c;
                string lookupfilterClause = pbdList[0].FilterCriteria__c;
                if(String.isNotEmpty(displayFieldsTemp)){
                    fieldsName = displayFieldsTemp;
                    sortField = lookupSortBy;
                    sortDirection = lookupSortDirection;
                }else{
                    List<SobjectConfig__c> sobjectConfig = new List<SobjectConfig__c>();
                    Schema.DescribeFieldResult fldRes = SchemaManager.getFieldSchemaResult(sObjectApiName, lookupfieldName).fieldDesc;
                    string sObjectName;
                    for(Schema.SObjectType reference : fldRes.getReferenceTo()) {
                        sObjectName = String.escapeSingleQuotes(reference.getDescribe().getName());
                    }
                    String query = 'select Name,DisplayFieldsAPIName__c,LookupSortBy__c,LookupSortDirection__c from SobjectConfig__c where Name =:sObjectName WITH USER_MODE'; 
                    sobjectConfig = Database.query(string.escapesingleQuotes(query)); //SOQL Injection - False +ve - No Dynamic part in this query string
                    if(sobjectConfig.size () > 0 && sobjectConfig[0].DisplayFieldsAPIName__c != null){     
                        // getting information through sobjectConfig                
                        fieldsName = sobjectConfig[0].DisplayFieldsAPIName__c;
                        sortField = sobjectConfig[0].LookupSortBy__c;
                        sortDirection = sobjectConfig[0].LookupSortDirection__c;
                    }else{
                        //providing default information
                        fieldsName = 'Id,Name';
                        sortField  = 'LastModifiedDate' ;
                        sortDirection = 'DESC';
                    }
                }
            }
        }
     
        Schema.DescribeFieldResult describeField = Schema.getGlobalDescribe().get(sObjectApiName).getDescribe().fields.getMap().get(lookupfieldName).getDescribe();
        for(Schema.SObjectType reference : describeField.getReferenceTo()) {
            objectName = reference.getDescribe().getName(); // relational field objectName
        }

        List <sObject> returnList = new List <sObject> ();
        Map<String, String> lableNameMap = new Map<String, String>();
        Map<String, Integer> scaleMap = new Map<String, Integer>();
        Map<String, String> dataTypeMap = new Map<String, String>();
        List<String> fieldNamesList = new List<String>();
        List<String> fieldNamesListforQuerry = new List<String>();
        Boolean avoidDuplicate = false;
        string lable;
        Integer scaleVal;
        Schema.DisplayType dataType ;
        string sWildCardText ='%'+ String.escapeSingleQuotes(searchKey) + '%';

        if(fieldsName.contains('{')){
            Map<String, Object> m = (Map<String, Object>) JSON.deserializeUntyped(fieldsName);   
            string  apiName;
            string lableName1;
            fieldsName='';
            for(String s:m.keyset()) {
                apiName = s;
                if(apiName.containsIgnoreCase('CreatedById') || apiName.containsIgnoreCase('RecordTypeId') || apiName.containsIgnoreCase('LastModifiedById') || 
                    apiName.containsIgnoreCase('OwnerId') || apiName.containsIgnoreCase('ParentId') || apiName.containsIgnoreCase('ContactId') ||
                    apiName.containsIgnoreCase('AccountId') || apiName.containsIgnoreCase('ProfileId')){
                        apiName = apiName.toLowerCase().replace('id', '.Name');
                }
                lableName1 = (String)m.get(s);
                lableNameMap.put(apiName.toLowercase(), lableName1);
                fieldsName+=''+String.escapeSingleQuotes(apiName)+',';
            }   
            fieldsName = fieldsName.removeEnd(',');
        }

        SObjectType r = ((SObject)(Type.forName('Schema.'+objectName).newInstance())).getSObjectType();
        DescribeSObjectResult d = r.getDescribe();
        for(string fieldName: fieldsName.split(',')){
            Schema.DisplayType typeIsReference ;   
            if(!fieldName.contains('.')){
                typeIsReference = d.fields.getMap().get(AppUtils.getNameSpacePrefix()+fieldName).getDescribe().getType();
                if(typeIsReference == Schema.DisplayType.REFERENCE){
                    if(fieldName.containsIgnoreCase('CreatedById') || fieldName.containsIgnoreCase('RecordTypeId') || fieldName.containsIgnoreCase('LastModifiedById') || 
                        fieldName.containsIgnoreCase('OwnerId') || fieldName.containsIgnoreCase('ParentId') || fieldName.containsIgnoreCase('ContactId') ||
                        fieldName.containsIgnoreCase('AccountId') || fieldName.containsIgnoreCase('ProfileId')){
                        fieldName = fieldName.toLowerCase().replace('id', '.Name');    
                    }else{
                        fieldName = fieldName.substringBefore('__c');
                        fieldName = fieldName + '__r.Name';
                    }
                }
            }
            fieldNamesList.add(fieldName);
        }
        if(fieldNamesList.size() > 0){
            fieldNamesListforQuerry.addAll(fieldNamesList);
        }
        if(!(fieldNamesListforQuerry.contains('Name'))){
            fieldNamesListforQuerry.add('Name');
        }

        if(filterClause != null){
            sQuery = 'Select ' +String.join(fieldNamesListforQuerry, ', ')+ ' From ' + String.escapeSingleQuotes(objectName) + ' Where ('+ filterClause+ ') and (';// Name Like : sWildCardText order by createdDate DESC LIMIT 500';
            //sQuery = 'Select ' +String.join(fieldNamesListforQuerry, ', ')+ ' From ' + String.escapeSingleQuotes(objectName) + ' Where ('+ AppUtils.parseWhereClause(filterClause)+ ') and (';// Name Like : sWildCardText order by createdDate DESC LIMIT 500';
        }else{
            sQuery = 'Select ' +String.join(fieldNamesListforQuerry, ', ')+ ' From ' + String.escapeSingleQuotes(objectName) + ' Where (';
        }
         
        for(string fieldName: fieldNamesList){
            avoidDuplicate = false;
            if(fieldName.containsIgnoreCase('createdby.Name') || fieldName.containsIgnoreCase('RecordType.Name') || 
                fieldName.containsIgnoreCase('LastModifiedBy.Name') || fieldName.containsIgnoreCase('owner.Name') || 
                fieldName.containsIgnoreCase('ParentId') || fieldName.containsIgnoreCase('ContactId') || 
                fieldName.containsIgnoreCase('AccountId') || fieldName.containsIgnoreCase('ProfileId')) {
                    dataType = Schema.DisplayType.STRING;
                    scaleVal = 0; 
                    if(fieldName.containsIgnoreCase('createdby.Name') ){
                        lable = Label.CreatedBy;
                    }else if(fieldName.containsIgnoreCase('RecordType.Name')){
                        lable = Label.RecordType;
                    }else if(fieldName.containsIgnoreCase('LastModifiedBy.Name')){
                        lable = Label.LastModifiedBy;
                    }else if(fieldName.containsIgnoreCase('owner.Name')){
                        lable ='Owner';
                    }
                    avoidDuplicate = true;
            }
            
            if(fieldName.contains('.')&& !avoidDuplicate){
                List<String> splitRefField = fieldName.split('\\.',-1);
                splitRefField = fieldName.split('\\.',-1);
                String refFieldName =fieldName;
                Schema.SObjectType referenceObject;
                if(splitRefField.size() > 1){
                    Map<String, Schema.SObjectField> referenceFieldsMap = new Map<String, Schema.SObjectField>();
                    Schema.SObjectType dataTableObjectType;
                    dataTableObjectType = SchemaManager.getSObjectTypeFromName(objectName);
                    if(dataTableObjectType <> null) {
                        Schema.DescribeSObjectResult dataTableObjectResult = dataTableObjectType.getDescribe();
                        Map<String, Schema.SObjectField> dataObjectFieldsMap = dataTableObjectResult.fields.getMap();
                        referenceFieldsMap = dataObjectFieldsMap;
                    }
                    for(String splittedField:splitRefField){
                        refFieldName = splittedField;
                        if(splittedField.contains('__r')){
                            splittedField= (splittedField.containsIgnoreCase('__r') ? splittedField.replace('__r','__c'):splittedField +'Id');
                            if(splittedField != null && referenceFieldsMap.get(splittedField.toLowerCase()+'') != null){
                            Schema.DescribeFieldResult reffieldDescribe = referenceFieldsMap.get(splittedField.toLowerCase()+'').getDescribe();
                                if(reffieldDescribe.getReferenceTo().size() > 0){
                                    referenceObject = reffieldDescribe.getReferenceTo().get(0);
                                }
                            }
                        }else{
                            if(referenceObject != null){
                            Schema.DescribeSObjectResult sObjDescribe = referenceObject.getDescribe();
                            Map<String, Schema.SObjectField> fieldsMap = sObjDescribe.fields.getMap();
                            Schema.SObjectField sObjField = fieldsMap.get(refFieldName);
                                Schema.DisplayType RefDisplayType = sObjField!= null ? sObjField.getDescribe().getType() : null;
                                lable = sObjField!= null ? sObjField.getDescribe().getLabel() : null;
                                dataType = RefDisplayType;
                                scaleVal = sObjField.getDescribe().getScale();
                            }
                        }
                    }
                }
            }else{
                if(!avoidDuplicate){
                    dataType = d.fields.getMap().get(AppUtils.getNameSpacePrefix()+fieldName).getDescribe().getType();
                    scaleVal = d.fields.getMap().get(AppUtils.getNameSpacePrefix()+fieldName).getDescribe().getScale();
                    lable = d.fields.getMap().get(AppUtils.getNameSpacePrefix()+fieldName).getDescribe().getLabel(); 
                }
            }
            
            if(!lableNameMap.containsKey(fieldName.toLowercase()) && fieldName != 'Id'){
                lableNameMap.put(fieldName.toLowercase(), lable);
                dataTypeMap.put(fieldName.toLowercase(), String.valueOf(dataType));
                scaleMap.put(fieldName.toLowercase(), scaleVal);
            } 
            if(!dataTypeMap.containsKey(fieldName.toLowercase()) && fieldName != 'Id'){
                dataTypeMap.put(fieldName.toLowercase(), String.valueOf(dataType));
                scaleMap.put(fieldName.toLowercase(), scaleVal);
            }
            // Search logic 
            if (fieldName != 'Id'){
                if(dataType == Schema.DisplayType.STRING || dataType == Schema.DisplayType.EMAIL || dataType == Schema.DisplayType.PHONE || dataType == Schema.DisplayType.PICKLIST || dataType == Schema.DisplayType.URL){
                    sQuery += String.escapeSingleQuotes(fieldName)+ ' Like : sWildCardText';
                    sQuery +=' OR ';
                }
            }

            if(dataType == Schema.DisplayType.DATETIME){
                if(searchKey != null && searchKey != ''  ){
                    DATETIME dateTimeValue;
                    try {
                        dateTimeValue = Datetime.valueOf(searchKey);
                        sQuery += String.escapeSingleQuotes(fieldName)+ '  =: dateTimeValue';
                        sQuery +=' OR ';
                    } catch (Exception e) {
                    }    
                }     
            }
            
            if(dataType == Schema.DisplayType.BOOLEAN ){
                if(searchKey != null && searchKey != ''  ){
                    Boolean checkValue; 
                    if(searchKey == 'true'){
                        checkValue = true;
                        sQuery += String.escapeSingleQuotes(fieldName)+ ' =:  checkValue';
                        sQuery +=' OR ';
                    }
                    if(searchKey == 'false'){
                        checkValue = false;
                        sQuery += String.escapeSingleQuotes(fieldName)+ ' =:  checkValue';
                        sQuery +=' OR ';
                    } 
                } 
            }
         
            if(dataType == Schema.DisplayType.INTEGER || dataType == Schema.DisplayType.DOUBLE || dataType == Schema.DisplayType.PERCENT || 
              dataType == Schema.DisplayType.CURRENCY){
                searchKey = searchKey.replaceAll(',', '');
                searchKey = searchKey.replaceAll('$', '');//need changes
                Decimal searchKeyCoversion;
                if(searchKey != null && searchKey != ''  ){
                     
                    try{
                        searchKeyCoversion = Decimal.valueOf(searchKey);
                        sQuery += String.escapeSingleQuotes(fieldName)+ ' =:  searchKeyCoversion';
                        sQuery +=' OR ';
                    }catch(Exception e) {
                    } 
                }
            }
            if(dataType == Schema.DisplayType.TEXTAREA ){    
            }
            if(dataType == Schema.DisplayType.DATE ){
                   
            }
        }

        sortDirection = sortDirection == null ? 'ASC':sortDirection;
        sortField = sortField == null ? 'createdDate':sortField;
        sQuery = sQuery.removeEnd(' OR ');
        sQuery +=' ) order by ' +string.EscapeSingleQuotes(sortField)+' '+ string.EscapeSingleQuotes(sortDirection) +' LIMIT 500';
        
        for (sObject obj: SystemContextMethodsHelper.runQueryInSystemMode(sQuery,sWildCardText)) {
            returnList.add(obj);
        }
        CustomLookupWrapper viewWrapper = new  CustomLookupWrapper(returnList,lableNameMap,dataTypeMap,scaleMap);
        return viewWrapper;
    }
    
    // Method to fetch lookup default value 
    @AuraEnabled
    public static sObject fetchDefaultRecord(string sObjectApiName, string lookupfieldName, string availableRecordId) {

        string objectName; 
        Schema.DescribeFieldResult f = Schema.getGlobalDescribe().get(sObjectApiName).getDescribe().fields.getMap().get(lookupfieldName).getDescribe();
        for(Schema.SObjectType reference : f.getReferenceTo()) {
            objectName = reference.getDescribe().getName();
        }
        availableRecordId = String.escapeSingleQuotes(availableRecordId);
        for (sObject obj: database.query('Select Id,Name From ' + string.EscapeSingleQuotes(objectName) + ' Where Id = : availableRecordId LIMIT 1', AccessLevel.USER_MODE)) {  //SOQL Injection - False +ve - Dynamic part of query string is escapeSingleQuotes
            return obj;
        }
        return null;
    } 
    
    @TestVisible
     public with sharing class CustomWrapper{
        @AuraEnabled
        public list<sObject> ObjectList {get;set;}
        @AuraEnabled
        public Map<String, String> fieldKeyMap {get;set;}
        @AuraEnabled
        public Map<String, String> fieldDataMap {get;set;}
        @AuraEnabled
        public Map<String, Integer> scale {get;set;}
        @AuraEnabled
        public String timelol {get;set;}   
        @AuraEnabled
         public String userLol {get;set;}
        @AuraEnabled
        public String field {get;set;}
         @AuraEnabled
        public String requiredfield {get;set;}
         @AuraEnabled
        public String testrequired {get;set;}
         @AuraEnabled
        public String fieldlabel {get;set;}
         @AuraEnabled
        public String key {get;set;}
         

        public CustomWrapper(list<sObject> sObjectList, Map<String, String> fieldLableMap,Map<String, String> fieldDataTypeMap,Map<String, Integer> scaleMap,String label){
            this.ObjectList = sObjectList;
            this.fieldKeyMap = fieldLableMap;
            this.fieldDataMap = fieldDataTypeMap;
            this.scale = scaleMap;
            this.timelol = (UserInfo.getTimeZone()).toString();
            this.userLol =UserInfo.getLocale();
            this.field = label;
            this.requiredfield = label;
            this.testrequired = label;
            this.fieldlabel = label;
            this.key  = label;
        }
    }
    
    
}