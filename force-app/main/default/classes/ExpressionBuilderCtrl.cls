/*
    Controller for ExpressionBuilder component.
    
    ****************************************************************************************
    Audit History
    ****************************************************************************************
    Shantanu Gadhe          Created
    Tomy Pallissery         Added remote actions and FieldResultWrapper inner wrapper class
    ****************************************************************************************
*/
global with sharing class ExpressionBuilderCtrl {
    
    @RemoteAction
    global static boolean saveJSONExpression(String contextRecordId, String contextRecordJSONField, String jsonExp){
        Id  recordId = contextRecordId;
        sObject sObj = recordId.getSObjectType().newSObject(recordId);
        sObj.put(contextRecordJSONField, jsonExp);
        if(AppUtils.isObjectUpdateable(String.valueOf(recordId.getSObjectType()))){
            update as user sObj; //FLS/ CRUD False +ve with the help of apputil we have performed check
        }
        return true;
    }

    /*
        Configuration setup data need for the component
    */
    @RemoteAction
    global static Map<String, Object> fetchConfigurations() {
        Map<String, Object> mapConfig = new Map<String, Object>();
        List<String> ggProfilesList = new List<String>();
        //SampleObject1__c.GGProfiles__c (which refers Global Picklist named GGProfiles) describe approach is used 
        //until salesforce provides describe calls for Global Picklist, or until an alternate solution is found.
        Schema.DescribeFieldResult ggProfileFieldResult = SampleObject1__c.GGProfiles__c.getDescribe();
        List<Schema.PicklistEntry> picklistEntriesList = ggProfileFieldResult.getPicklistValues();
        List<String> customAppList = new List<String>();
        for (CustomAppConfig__c cac: CustomAppConfig__c.getAll().values()) {
            if(cac.Active__c) {
                customAppList.add(cac.Name);
            } 
        }
        for(Schema.PicklistEntry picklistVal : picklistEntriesList){
            ggProfilesList.add(picklistVal.getValue());
        }
        String Type ='Queue';
        
        set<string> QueueList = new set<string>();
        set<string> newGroupField = new set<string>{'Name'};    
        String GroupfieldStr = String.join(new List<String>(newGroupField),',' );
        String QueueQuery = 'SELECT '+ String.escapeSingleQuotes(GroupfieldStr) + ' FROM Group where Type =:Type';
        List<Group> QueueRecordList = Database.query(QueueQuery, AccessLevel.USER_MODE); //SOQL Injection - False +ve - Dynamic parts of the query string is ecsapeSingleQuotes to prevent SOQL Injection
        if(QueueRecordList.size() > 0){
        
           for(Group grp : QueueRecordList){
            QueueList.add(grp.Name);
           }
        }


        //mapConfig.put('profile', new List<String> {'PM', 'PO', 'FO', 'FD', 'EXE', 'SME', 'SPI', 'System Administrator'});
        mapConfig.put('profile', ggProfilesList);
        mapConfig.put('queue', QueueList);
        mapConfig.put('usertype', new List<String> {'Applicant','Internal','Reviewer'});
        mapConfig.put('context', new List<String> {'Create','Edit','View'});
        //mapConfig.put('userapp', new List<String> {'StateasGrantor', 'StateasGrantee','StateasRecipient'});
        mapConfig.put('userapp', customAppList);
        return mapConfig;
    }

    /*
        Returns the expression JSON in string format, created by the expression builder
        Param: contextRecordId : Salesforce ID of the record where the component is used/displayed
        Param: contextRecordJSONField : Field API name of the field where the JSON string is stored
    */
    @RemoteAction
    global static String fetchExpressionJSON(String contextRecordId, String contextRecordJSONField){
        if(String.isBlank(contextRecordId)){
            return null;
        }
        Id recordId = String.escapeSingleQuotes(contextRecordId);
        String objName = recordId.getSObjectType().getDescribe().getName();
        String query =  ' SELECT ' + String.escapeSingleQuotes(contextRecordJSONField) + ' FROM ' + String.escapeSingleQuotes(objName) + ' WHERE Id =:recordId';//SOQL Injection - False +ve - Dynamic part of query string is escapeSingleQuotes
        List<sObject> sobjList = Database.query(String.escapeSingleQuotes(query), AccessLevel.USER_MODE);
        if(sobjList.size() == 0){
            return null;
        }
        sObject contextSObject = sobjList[0];
        return String.valueOf(contextSObject.get(contextRecordJSONField));
    }

    /*
        Returns the list of sobject config wrapped in FieldResultWrapper, for populating object selection picklist
        Using FieldResultWrapper to avoid creation of another wrapper class 
    */
    @RemoteAction
    global static List<FieldResultWrapper> fetchSobjectConfigList() {
        List<SobjectConfig__c> lstSobjectConfig = new List<SobjectConfig__c>();
        if(Schema.sObjectType.SobjectConfig__c.isAccessible()){
            lstSobjectConfig = [SELECT Name, ObjectLabel__c FROM SobjectConfig__c WHERE Name != NULL WITH USER_MODE];
        }
        List<FieldResultWrapper> lstFieldResultWrapper = new List<FieldResultWrapper>();
        for(SobjectConfig__c sobjConfig : lstSobjectConfig) {
            FieldResultWrapper fld = new FieldResultWrapper();
            fld.name = sobjConfig.Name;
            fld.label = String.isEmpty(sobjConfig.ObjectLabel__c) ? sobjConfig.Name : sobjConfig.ObjectLabel__c;
            lstFieldResultWrapper.add(fld);
        }
        return lstFieldResultWrapper;
    }
    
    /*
        Returns list of wrapper class object, for field selection in the component
    */
    @RemoteAction
    global static List<FieldResultWrapper> fetchInitialRelatedFields(String fieldProviderSObjectName) {
        if(String.isBlank(fieldProviderSObjectName)){
            return null;
        }
        List<FieldResultWrapper> fieldResultsList = populateFieldResultList(fieldProviderSObjectName, 1);
        return fieldResultsList;
    }

    /*
        Returns list of wrapper class object, for field selection in the component
    */
    @RemoteAction
    global static List<FieldResultWrapper> fetchObjectRelatedFields(String objectName, Integer fieldLevel){
        return populateFieldResultList(objectName, fieldLevel);
    }

    /*
        Helper method to fetch related fields of object
    */
    private static List<FieldResultWrapper> populateFieldResultList(String objectName, Integer fieldLevel){
        Schema.DescribeSObjectResult[] descResultSourceObj = Schema.describeSObjects( new String[]{ objectName });

        if(descResultSourceObj.size() == 0){
            return null;
        }
        Map<String, Schema.SObjectField> sourceObjFieldsMap = descResultSourceObj[0].fields.getMap();
        List<FieldResultWrapper> fieldResultsList = new List<FieldResultWrapper>();
        for(Schema.SObjectField field : sourceObjFieldsMap.values()){
            Schema.DescribeFieldResult descFieldResult = field.getDescribe();
            FieldResultWrapper fldResWrapperObj = new FieldResultWrapper();
            fldResWrapperObj.name = descFieldResult.getName();
            fldResWrapperObj.label = descFieldResult.getLabel();
            fldResWrapperObj.type = String.valueOf(descFieldResult.getType());
            fldResWrapperObj.objectName = objectName;
            fldResWrapperObj.level = fieldLevel;

            Integer relationOrder = descFieldResult.getRelationshipOrder();
            Schema.DisplayType fieldDisplayType = descFieldResult.getType();
            fldResWrapperObj.HasCrossReference =  (( relationOrder != null && relationOrder == 0) || (fieldDisplayType == Schema.DisplayType.reference)) ? true : false;

            if(fldResWrapperObj.HasCrossReference){
                List<Schema.sobjectType> reference = descFieldResult.getReferenceTo();
                fldResWrapperObj.RelationshipObjName = reference[0].getDescribe().getName();
                fldResWrapperObj.RelationshipName = descFieldResult.getRelationshipName();
            }else{
                fldResWrapperObj.RelationshipObjName = '';
                fldResWrapperObj.RelationshipName = '';
            }
            fieldResultsList.add(fldResWrapperObj);
        }
        return fieldResultsList;
    }

    global with sharing class FieldResultWrapper{
        global String Name {get; set;}
        global String Label {get; set;}
        global String Type {get; set;}
        global String ObjectName {get; set;}
        global String RelationshipObjName {get; set;}
        global String RelationshipName {get; set;}
        global Boolean HasCrossReference {get; set;}
        global Integer Level {get; set;}
    }
}