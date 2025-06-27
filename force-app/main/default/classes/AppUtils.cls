/*
    Provides search functionality for partners and also allows creation of new partners,
    delete partners and edit partners.
    
    ***********************************************************
    Audit History
    ***********************************************************
    2012-11-30      Jagan Valayapathy   Created
    2014-02-26      Glen Watson         Uncommented the debug lines
    2014-05-09      Hafsa Syed          Updated getCurrentFiscalYear
    *********************************************************** 
*/
global with sharing class AppUtils {  
    public static final String className = 'AppUtils';
    public static final Integer GOOGLE_MAPS_GEOCODE_LIMIT = 2500;
    public static final Integer SOQL_JQUERY_LIMIT = 10000;
    public static boolean UPDATINGFLEXTABLECONFIG = false;
    public static boolean UPDATINGFLEXTABLELISTVIEWCONFIG = false;
    global static final Integer SOQL_LIMIT = 10000; //Based on maximum records allowed for StandardSetController (https://www.salesforce.com/us/developer/docs/pages/Content/apex_pages_standardsetcontroller.htm)
    public static Integer SOQL_LIMIT_FOR_BATCH = 10000;
    public static final Integer DML_LIMIT = 10000;
    public static final Integer LIST_LIMIT = 1000;
    private static final Integer DEFAULT_SEARCH_RECORDS_DISPLAYED = 20; //Should probably equal DEFAULT_MAX_VIEWED_RECORDS_STORED
    public static final Integer DEFAULT_MAX_VIEWED_RECORDS_STORED = 20; //Should probably equal DEFAULT_SEARCH_RECORDS_DISPLAYED
    public static final Integer ACCOUNT_HIERARCHY_DEPTH = 3;
    public static final String LINE_BREAK = '\r\n';
    public static final Set<String> NON_CAPITALIZED_WORDS = new Set<String>{'a', 'an', 'and', 'for', 'in', 'the', 'to', 'of', 'on'};
    public static final List<String> SEARCH_ALPHABET = new List<string>{'A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P','Q','R','S','T','U','V','W','X','Y','Z','All'};
    public static final String RETURN_URL_KEY = 'retUrl';
    public static String docBaseUrl=''; 
    public static String staticResourceBaseUrl=''; 
    private static String nameSpacePrefixCache;
    
    private static boolean isloggingEnabled;
    public static string dateTimeFormat;
    public static Boolean skipTeamMemberTrigger = false;
    global static transient Boolean skipStepReviewTrigger = false;
    global static transient Boolean skipGrantMonitoringPlanTrigger = false;
    global static transient Boolean callFutureMethodUserTrigger = false;
    global static transient Boolean skipAccountTrigger = false;
    global static transient Boolean skipDohAnnouncementTrigger = false;
    global static transient Boolean skipDOH_ReviewStepTriggerHelper = false;
    global static transient Boolean skipDOH_ProgramTrigger = false;
    global static transient Boolean skipPhaseConfigTrigger = false;
    global static transient Boolean skipDOH_UserTrigger = false;
    global static transient Boolean skipDohApplicationTrigger = false;
    public enum attachmentCategory {HISTORY}
    //This variable can be used by product team to skip trigger execution in case of approval recall batch.
    global static Boolean skipTriggerInRecallBatch = false;
    private static Map<Schema.SObjectType,Map<String,Id>> rtypesCache;
    private static Map<String,String>localeToDateTimeFmtMap;
    private static Map<String,String>localeTimeFmtMap;
    private static Map<String,String>localeCurrencySymbolMap;
    private static String formattedString = '';
    static {
        rtypesCache = new Map<Schema.SObjectType,Map<String,Id>>();
        KeyValueHolder__mdt objMetadataHolder = KeyValueHolderHelper.getKeyValueHolder('BaseURL');  
        docBaseUrl = URL.getOrgDomainURL().toExternalForm();
        UserPreferences__c userPref = UserPreferences__c.getInstance();
        String baseURLConfig;
        if(objMetadataHolder != null && objMetadataHolder.BooleanValue__c && String.isNotBlank(objMetadataHolder.Description__c) && String.isBlank(baseURLConfig) && UserInfo.getUserType() != 'Guest' && userPref.IsInternal__c){
            baseURLConfig = objMetadataHolder.Description__c;
        }
        staticResourceBaseUrl = String.isNotBlank(baseURLConfig) ? baseURLConfig : URL.getOrgDomainUrl().toExternalForm();
       
        getLocaleCurrencySymbolMap();
        getLocaleToDateTimeFmtMap();
        getLocaleTimeFmtMap();
    }

    webservice static Boolean validateExpression(String expression) // you can pass parameters
    {  
        return false;
    }

    //User Story 91157: Internal - Assignment of Manage Permission Set using Post Install Script and within User Trigger
    global static void processPermissionSets(Set<Id> userIds){
       // Deprecated method
    }

    // Validating URl Field in Edit Layout..new method...
    @AuraEnabled
    public static Boolean validateURLFormat(String url){
        Boolean validURL = false;

        //new logic
        Boolean metaBooleanValue = KeyValueHolderHelper.getBooleanValue('URLValidationRegex');
        String metaTextValue = KeyValueHolderHelper.getTextValue('URLValidationRegex');
        if(String.isNotBlank(url) && metaBooleanValue){
            url = url.toLowerCase();
            String defaultRegexFormat ='^(http|https?://)?(www\\.)?([-a-z0-9]{1,63}\\.)*?[a-z0-9][-a-z0-9]{0,61}[a-z0-9]\\.[a-z]{2,6}(/[-\\w@\\+\\.~#\\?&/=%]*)?$';
            String regexFormat = String.isNotBlank(metaTextValue) ? metaTextValue : defaultRegexFormat;
            Boolean sameRegex = defaultRegexFormat.equals(regexFormat);
            Pattern urlFormat = Pattern.Compile(regexFormat);
            Matcher matchUrlFormat = urlFormat.matcher(url);
            validURL = matchUrlFormat.Matches();
        } else {
            validURL = true;
        }
        return validURL;
    }
    
    // Returns a map of active, user-available RecordType IDs for a given SObjectType,
    // keyed by each RecordType's unique, unchanging DeveloperName
    global static Map<String, Id> GetRecordTypeIdsByDeveloperName( Schema.SObjectType token ) {
        // Do we already have a result? 
        Map<String, Id> mapRecordTypes = rtypesCache.get(token);
        // If not, build a map of RecordTypeIds keyed by DeveloperName
        if (mapRecordTypes == null) {
            mapRecordTypes = new Map<String, Id>();
            rtypesCache.put(token,mapRecordTypes);
        } else {
           // If we do, return our cached result immediately!
           return mapRecordTypes;
        }
    
        // Get the Describe Result
        Schema.DescribeSObjectResult obj = token.getDescribe();
    
        // Obtain ALL Active Record Types for the given SObjectType token
        // (We will filter out the Record Types that are unavailable
        // to the Running User using Schema information)
        String objName = String.escapeSingleQuotes(obj.getName());
        String soql = 
            'SELECT Id, Name, DeveloperName '
            + 'FROM RecordType '
            + 'WHERE SObjectType =:objName '
            + 'AND IsActive = TRUE'; //CRUD  FLS- False +ve - Std obj  - will not check permission here 
        List<SObject> results;
        try {
            results = Database.query(String.escapeSingleQuotes(soql),AccessLevel.USER_MODE);
        } catch (Exception ex) {
            results = new List<SObject>();
        }
    
        // Obtain the RecordTypeInfos for this SObjectType token
        Map<Id,Schema.RecordTypeInfo> recordTypeInfos = obj.getRecordTypeInfosByID();
    
        // Loop through all of the Record Types we found,
        //      and weed out those that are unavailable to the Running User
        for (SObject rt : results) {  
            if (recordTypeInfos.get(rt.Id).isAvailable()) {
                // This RecordType IS available to the running user,
                //      so add it to our map of RecordTypeIds by DeveloperName
                mapRecordTypes.put(String.valueOf(rt.get('DeveloperName')),rt.Id);
            }
        }
    
        return mapRecordTypes;
    }
    global static Integer getNumericValueFromString(String data) { // Dk : Spring Cleanup 7-4-16
    
        return null;
    }
    /* Get formated String(eg: input:- (A,B,C) ===>> Output:- ('A','B','C')) for SOQL query */
    global static String queryFormattedString(List<String> lstStrKeyWord, String keyWord){
        
        if(lstStrKeyWord !=  null){
            for(String keyWrd: lstStrKeyWord){
                formattedString += '\''+string.escapeSingleQuotes(keyWrd)+'\',';
            }
            formattedString = formattedString.removeEnd(',');
        } 
        else if(keyWord != null && keyword.contains(',')){
                    List<String> lstStrKeyWords = keyWord.split(',');
                    queryFormattedString(lstStrKeyWords, null);
        }else{
            if(keyWord != null || keyWord != '')
                formattedString = '\''+String.escapeSingleQuotes(keyWord)+'\'';
        } 
        return formattedString != null ? '('+formattedString+')':'';       
    }
    
    global static Map<String,String> getRelationshipFieldMap(String objectName){
       // String ns = AppUtils.getNamespacePrefix();
        //objectName = objectName.removeStart(ns);
        Map<String,Schema.SObjectType> gd = Schema.getGlobalDescribe();
        Schema.SObjectType sobjType = gd.get(objectName);
        Schema.DescribeSObjectResult dsor;
        if(sobjType != null){
        dsor = sobjType.getDescribe();
        
        Map<String,String> finalMap = 
            new Map<String, String>();
        // map of all fields in the object
        Map<String, Schema.SObjectField> objectFields = dsor.fields.getMap();
        // iterate over the requested fields and get the describe info for each one. 
        // add it to a map with field name as key
        for(String field : objectFields.keySet()){
          Schema.DescribeFieldResult dr = objectFields.get(field).getDescribe();
          // add the results to the map to be returned
          finalMap.put(dr.getName().tolowerCase(), dr.getRelationshipName()); 
      }
      return finalMap;
      }
      return null;
    }
    
    global static Boolean getIsNewUserRegWindowOpen(){ // Dk : Spring Cleanup 7-4-16
        return null;
    }
    
    global static List<String> getMergeFields(String header){
        List<String>mergeFieldKey = new List<String>();
        if (header == null) return mergeFieldKey;
        
        Pattern regex = Pattern.compile('\\{!([^}]*)\\}'); 
        Matcher regexMatcher = regex.matcher(header);        
        
        while (regexMatcher.find()){//SOQL/SOSL Injection False +ve          
            String fieldName = regexMatcher.group();
            if(!fieldName.contains('$')){
                fieldName = fieldName.substring(2,fieldName.length()-1);
                mergeFieldKey.add(String.escapeSingleQuotes(fieldName));
            }                                        
        }  
        return mergeFieldKey;
    }


    /* Get Merge Fields for Form Config Form Instance*/
    public static List<String> getMergeFieldsWithoutObject(String header){
        List<String>mergeFieldKey = new List<String>();
        if (header == null) return mergeFieldKey;
        
        Pattern regex = Pattern.compile('\\{!([^}]*)\\}'); 
        Matcher regexMatcher = regex.matcher(header);        
        
        while (regexMatcher.find()){//SOQL/SOSL Injection False +ve          
            String fieldName = regexMatcher.group();
            if(!fieldName.contains('$')) {
                if(fieldName.contains('.')) {
                    fieldName = fieldName.substring(fieldName.indexOf('.')+1,fieldName.length()-1);
                    mergeFieldKey.add(String.escapeSingleQuotes(fieldName));
                }
            }                                        
        }  
        return mergeFieldKey;
    }
    
    public static Map<String,Set<String>> getJSONMergeFields(String content) {
        Map<String,Set<String>> objNameByFields = new Map<String, Set<String>>();
        if (content == null) return objNameByFields;
        
        Pattern regex = Pattern.compile('\\{"([^}]*)\\"}'); 
        Matcher regexMatcher = regex.matcher(content);        
        
        while (regexMatcher.find()){  //SOQL/SOSL Injection False +ve       
            String fieldName = regexMatcher.group();
            fieldName = fieldName.replace('{','').replace('"','').replace('}','');
            List<String> objList = fieldName.split(',');
            for(String objByFld : objList) {
                List<String> data = objByFld.split(':');
                if(data.size() != 2) {
                    throw new CustomExceptions.InputDataException('Invalid JSON');
                }
                if(SchemaManager.doesObjExist(data.get(0)) == false){
                    throw new CustomExceptions.InputDataException('Object does not exist with API Name : ' + data.get(0));                          
                } 
                else{
                     //SchemaManager.getSObjectField(data.get(0),data.get(1));
                }
                
                if(objNameByFields.get(data.get(0).trim()) == null) {
                    objNameByFields.put(data.get(0).trim(), new Set<String>());
                }
                objNameByFields.get(data.get(0).trim()).add(data.get(1).trim());
            }
        }    
        return objNameByFields;
    }
        
                
    global static List<String> getUserMergeFields(String header){
        List<String>mergeFieldKey = new List<String>();
        if (header == null) return mergeFieldKey;
        
        Pattern regex = Pattern.compile('\\{!([^}]*)\\}'); 
        Matcher regexMatcher = regex.matcher(header);        
        
        while (regexMatcher.find()){//SOQL/SOSL Injection False +ve         
            String fieldName = regexMatcher.group();
            if(fieldName.contains('$')){
                fieldName = fieldName.substring(2,fieldName.length()-1);
                mergeFieldKey.add(String.escapeSingleQuotes(fieldName));
            }                                        
        } 
        return mergeFieldKey;
    }

   /* Generic Method To Return Field Name From Merge Field
      eg: {!User.Name} if we pass this merge field it return Name*/
    public static List<String> getMergeFieldSupport(String header, List<String> objApiNameList){
      List<String>mergeFieldKey = new List<String>();
      if(header == null) return mergeFieldKey;
      if(objApiNameList != null && objApiNameList.size() > 0){
          for(String objApiName:objApiNameList){
      objApiName = objApiName + '\\.';
      Pattern regexForExtractingUserFields = Pattern.compile('\\{!('+objApiName+'[^}]*)\\}'); 
      Matcher regexMatcherForExtractingUserTokens = regexForExtractingUserFields.matcher(header); 
      
      while(regexMatcherForExtractingUserTokens.find()){//SOQL/SOSL Injection False +ve
         String userToken = regexMatcherForExtractingUserTokens.group();
         if(userToken != null ){
            userToken= userToken.substring(userToken.indexOf('.')+1,userToken.length()-1); 
            mergeFieldKey.add(userToken);
         }
      }
          }
      }
      return mergeFieldKey;
    }

   /* Generic Method To Replace Merge Field with actual value
      eg: {!User.Name}  merge field replace with it  value*/
    public static String replceMergeFieldsList(String body, List<Sobject> objRecordList, List<String> mergeFieldsList){
          if(String.isEmpty(body)){
                return body;
          }
          if(objRecordList != null && objRecordList.size() > 0){
              for(Sobject objrecord : objRecordList){
          String objectAPIName = String.valueOf(objrecord.getSObjectType());
          if(mergeFieldsList.size() > 0){
              for(String fildNm : mergeFieldsList){
                 Object value = AppUtils.getFieldValue(objrecord, fildNm);
                 if(value !=null){
                    body = body.replace('{!'+objectAPIName+'.'+fildNm+'}', String.escapeSingleQuotes(String.valueOf(value)));  
                 } else{
                    body = body.replace('{!'+objectAPIName+'.'+fildNm+'}', '');
                 }    
              }
          }
              }
          }
          return body;
    }

    /*
        Method to replace the Merge Fields here the FilterString is String with MergeFields 
        MergeField Syntax : {!ObjectName.FieldName}
        Example: 
        This is regular field {!SampleObject1__c.SampleText1__c} .
        This is relationship field {!SampleObject1__r.SampleObject2__r.SampleText2__c}
    */
    public static String replaceRecordMergeFields(String filterString,Id recordId){
        String objectAPIName = String.valueOf(recordId.getSobjectType());
        Pattern regexForExtractingUserFields = Pattern.compile('\\{!(' + objectAPIName + '\\.[a-zA-Z0-9\\.\\_]+)\\}'); 
        Matcher regexMatcherForExtractingUserTokens = regexForExtractingUserFields.matcher(filterString);        
             
        Map<String, String> acctFieldsToQueryMap = new Map<String, String>();
        while (regexMatcherForExtractingUserTokens.find()){//SOQL/SOSL Injection False +ve         
            String userToken = regexMatcherForExtractingUserTokens.group();
            String userTokenAfterRemove = userToken.substring(2,userToken.length()-1); 
            List<String> userSplitField = userTokenAfterRemove.split('\\.', 2);
            acctFieldsToQueryMap.put(userToken, userSplitField[1]);
        }
        if(acctFieldsToQueryMap.size() > 0) {
            recordId = String.escapeSingleQuotes(recordId);
            String queryStr = 'SELECT Id,Name '+ ' FROM ' + String.escapeSingleQuotes(objectAPIName) + ' WHERE Id =: recordId';
            List<SObject> records;
            if(AppUtils.isObjectAccessible(objectAPIName)){ //CRUD/FLS False +ve with the help of AppUtils we have performed check
                records = Database.query(String.escapeSingleQuotes(queryStr),AccessLevel.USER_MODE); //SOQL Injection - False +ve - Dynamic part of query is escapeSingleQuotes/static bind
            }
            if(records.size() > 0) {
                for(String replaceStr : acctFieldsToQueryMap.keySet()) {
                    Object value = AppUtils.getFieldValue(records[0], acctFieldsToQueryMap.get(replaceStr));
                    if(value != null) {
                        filterString = filterString.replace(replaceStr, String.escapeSingleQuotes(String.valueOf(value)));
                    } else {
                        filterString = filterString.replace(replaceStr, '');
                    }
                }
            }
        }
        return filterString;
    }
    
    public static List<String> getRequiredFieldsFromMetadata(String sObjectName){
        List<String> reqFieldMetadataList = new List<String>();
        try{
            Schema.SObjectType sobjTypeVal = SchemaManager.getSObjectTypeFromName(sObjectName);
            Map<String, Schema.SobjectField> fieldsMap = sobjTypeVal.getDescribe().fields.getMap();
            List<String> unecessaryFields = new List<String>{'ownerid'};
            for (String s : fieldsMap.keySet()){
                if(!unecessaryFields.contains(s) && !fieldsMap.get(s).getDescribe().isNillable() && fieldsMap.get(s).getDescribe().isUpdateable() && fieldsMap.get(s).getDescribe().isCreateable()  && fieldsMap.get(s).getDescribe().getType() != Schema.DisplayType.BOOLEAN){
                    reqFieldMetadataList.add(fieldsMap.get(s).getDescribe().getName());
                }
            }
        }catch(Exception e){

        }
        return reqFieldMetadataList;
    }
    
    global static string replaceMergeFieldsForTemplates(String text,Sobject record){ // Dk : Spring Cleanup 7-4-16
       
        return null;
    }
    
    global static String replaceMergeFields(String text, Sobject record){
        List<String> mergeFields = getMergeFields(text);
        List<String> userFields = getUserMergeFields(text);
        List<String> massagedUserFields = new List<String>();
        if(userFields != null){
            for(string mergeField : userFields){
                if(mergeField.startsWith('$')){
                    //.remove('User.').
                    massagedUserFields.add(mergeField.subStringAfter('$'));
                }
            }
        }
        if(massagedUserFields.size() > 0){
            text = replaceUserFields(text,massagedUserFields);
        }
        return replaceFields(text,mergeFields,record);
    }

    global static string replaceUserFields(String text, List<String> fields){
        //Map<String,List<String>> objectFieldMap = new Map<String,List<String>>();
        Set<String> userFields = new Set<string>();
        userFields.addAll(fields);
        userFields.add('id');
        List<String> newFieldsList = new List<String>();
        newFieldsList.addAll(userFields);
        string intermediateValue;
        Id userId = UserInfo.getUserId();
        String query = 'select ' + String.escapeSingleQuotes(String.join(newFieldsList,',')) + ' from User where id =:userId';
        List<User> users = Database.query(String.escapeSingleQuotes(query),AccessLevel.USER_MODE);  //CRUD/FLS False +ve As per business scenario we can't check for portal/external users
        User u;
        if(users.size() > 0 ){
            u = users[0];
        }   
        for(String field : fields){
            List<String> splitFields = field.split('\\.');
            if(!splitFields[0].containsIgnoreCase('UserRole') && !splitFields[0].containsIgnoreCase('Profile')){
                text = text.replace('{!$'+field +'}',String.escapeSingleQuotes(u.get(splitFields[1])+''));
            }else{
                intermediateValue = u.getSobject(splitFields[0]).get(splitFields[1]) + '';  
                text = text.replace('{!$'+field +'}',String.escapeSingleQuotes(intermediateValue));  
            }

        }
        return text;
    }
    
    public static Object getFieldValue(Sobject record, String fieldAPIName) {
        if(String.isEmpty(fieldAPIName) || record == null) {
            return null;
        }
        Object value = null;
        if(fieldAPIName.contains('.')){
            List<String> relationshipFields = fieldAPIName.split('\\.');
            Sobject temp;
            integer i = 0;
            for(i=0;i<relationshipFields.size()-1;i++){    
                String singleField = relationshipFields[i];                                                 
                if(temp == null){
                    temp = record.getSobject(singleField);
                    
                }else{
                    temp = temp.getSobject(singleField);
                }
                if(temp == null) { //Tomy - 17/04/2018 - added null check, for integrity, if any level in relationship is null
                    return null;
                }   
            } 
            if(temp != null && temp.get(relationshipFields[i]) != null){
                value = temp.get(relationshipFields[i]);
            }
        }else{
            value = record.get(fieldAPIName);
        }
        return value;
    }
   /*
    //* use of this method - to get picklist/Multipicklist labels 
    
    public static Object getMultiPickListFieldValue(Sobject record, String fieldAPIName) {
        if(String.isEmpty(fieldAPIName) || record == null) {
            return null;
        }
        Object value = null;
        String objectAPIName =  null;
        if(fieldAPIName.contains('.')){
            List<String> relationshipFields = fieldAPIName.split('\\.');
            Sobject temp;
            integer i = 0;
            for(i=0;i<relationshipFields.size()-1;i++){    
                String singleField = relationshipFields[i];                                                 
                if(temp == null){
                    temp = record.getSobject(singleField);  
                }else{
                    temp = temp.getSobject(singleField);
                }
                if(temp == null) { 
                    return null;
                }   
            } 
            fieldAPIName = relationshipFields[relationshipFields.size() - 1];
            if(temp != null && temp.get(relationshipFields[i]) != null){
                value = temp.get(relationshipFields[i]);
                objectAPIName =  String.valueOf(temp.getSObjectType());
            }
        }else{                            
            value = record.get(fieldAPIName);
            objectAPIName =  String.valueOf(record.getSObjectType());
        }            
        String apiValues =String.valueOf(value);
        value = null;
        if(apiValues != null){
            Schema.DescribeFieldResult dsr = SchemaManager.fetchDescribeFieldResult(objectAPIName,fieldAPIName);
            List<String> apiValuesList = new List<String>();
            if (String.isNotEmpty(apiValues) ){ 
                apiValuesList = apiValues.split(';');
            }
            for(Schema.PicklistEntry ple : dsr.getPicklistValues()){
                if (apiValuesList.size() > 1 ){                                                   
                    for(String apiValue :apiValuesList){
                        if(apiValue.equalsIgnoreCase(String.valueOf(ple.getValue()))){
                            if(value == null){
                                value = String.valueOf(ple.getLabel());
                            }else{
                                value =value+';'+ String.valueOf(ple.getLabel());
                            }
                            break;
                        }
                    }
                }
                else if(String.isNotEmpty(apiValues) && apiValues.equalsIgnoreCase(String.valueOf(ple.getValue())) ){
                    value = ple.getLabel();
                }
            }
        }
        return value;
    }*/

    public static Object getParentRecord(Sobject record, String fieldAPIName) {
        if(String.isEmpty(fieldAPIName)) {
            return null;
        }
        Object value = null;
        Sobject temp;
        if(fieldAPIName.contains('.')){
            List<String> relationshipFields = fieldAPIName.split('\\.');
            
            integer i = 0;
            for(i=0;i<relationshipFields.size()-1;i++){    
                String singleField = relationshipFields[i];                                                 
                if(temp == null){
                    temp = record.getSobject(singleField);
                    
                }else{
                    temp = temp.getSobject(singleField);
                }
                if(temp == null) { //Tomy - 17/04/2018 - added null check, for integrity, if any level in relationship is null
                    return null;
                }   
            } 
        }else{
            return record;
        }
        return temp;
    }

    //Prajakta: added to set fieldvalue in case of relationship fields
    public static void setFieldValue(Sobject record, String fieldAPIName, Object value) {
         if(String.isEmpty(fieldAPIName)) {
                return;
            }
           
            if(fieldAPIName.contains('.')){
                List<String> relationshipFields = fieldAPIName.split('\\.');
                Sobject temp;
                integer i = 0;
                for(i=0;i<relationshipFields.size()-1;i++) {    
                    String singleField = relationshipFields[i];                                                 
                    if(temp == null) {
                        temp = record.getSobject(singleField);
                        
                    }else{
                        temp = temp.getSobject(singleField);
                    }
                    if(temp == null) { 
                        return ;
                    }   
                } 
                if(temp != null && temp.get(relationshipFields[i]) != null){
                    temp.put(relationshipFields[i], value);
                }
            }else{
                 record.put(fieldAPIName, value);
            } 
    }
    
    public static String getFormattedNumber(Double value, Integer decimalScaleVal, Boolean isCurrency, String dataType) {
        String formated='';
        String updateVal='';
        if (value != null) {
            decimal decVal = decimal.valueOf(value);
        decimalScaleVal = decimalScaleVal == null ? 0 : decimalScaleVal;
            // Set Decimal Scale to 2 when its greator than 2...
            if(decimalScaleVal > 2){
                decimalScaleVal = 2;
            }
        String val = string.valueOf(decVal.setScale(decimalScaleVal));
        String[] valList = val.reverse().split('\\.');    
        if(valList.size() > 0){                     
            List<String> stringList = new List<String>{};
            Integer subs = 0;
            String fristPart, secondPart;
            if(valList.size()==2){
                fristPart = valList[1];
                secondPart = valList[0];
            }
            else if(valList.size()==1){
                fristPart = valList[0];
            }
            for(Integer x = 1; x < fristPart.length() + 1; x++){
                if(math.mod(x, 3) == 0){
                    stringList.add(fristPart.substring(subs, x));
                    subs = x;
                }
                else if(x == fristPart.length()){
                    stringList.add(fristPart.substring(subs, x));
                }
            }
            fristPart = string.join(stringList, ',');
            formated = fristPart;
            valList = new List<String>();
            if( secondPart !=null ){
                if(secondPart.length() == 1){
                    secondPart = secondPart + '0';
                }                          
                valList.add(secondPart);
                valList.add(fristPart);
                formated = string.join(valList, '.');               
            }                   
            formated=formated.reverse();
            if(formated.endsWith(',00')){
                formated=formated.substring(0,formated.lastIndexOf(','));
            }
        }
        if(isCurrency == true) {
            formated = getLocaleCurrencySymbol()+''+ formated;
                //return formated;
        }
            if(dataType == 'PERCENT'){
                formated = formated+'%' ;
        }
            updateVal = formated;
            if(updateVal.contains('-')){
                updateVal = updateVal.remove('-');
                updateVal = '('+updateVal+')';
            }
            if(updateVal.contains(getLocaleCurrencySymbol() + ',')){
                updateVal = updateVal.replace(getLocaleCurrencySymbol() + ',',getLocaleCurrencySymbol());
            }
            if(updateVal.contains('(,')){
                updateVal = updateVal.replace('(,','(');
            }
        }

        return updateVal;
        /*
         if (val != null) {
             String format =  '###,###,###,##0';
             decimalScaleVal = decimalScaleVal == null ? 0 : decimalScaleVal;
             if (decimalScaleVal > 0) {
                format += '.';
            }
            for (Integer i=0; i<decimalScaleVal; i++) {
                format += '0';
            }
            List<String> args = new String[]{'0','number',format};
            formattedNo = String.format(val.format(), args);
            if(isCurrency == true) {
                formattedNo = getLocaleCurrencySymbol()+''+ formattedNo;
            }
         }
         return formattedNo;*/
}

    public static String getFormattedNumber(Double val, Integer decimalScaleVal) {
        String formattedNo = ''; 
         if (val != null) {
             String format =  '###,###,###,##0';
             decimalScaleVal = decimalScaleVal == null ? 0 : decimalScaleVal;
                String strVal = val.format();
                List<String> strValList = strVal.split('\\.');
             if (decimalScaleVal > 0) {
                // Set Decimal Scale to 2 when its greator than 2...
                if(decimalScaleVal > 2){
                   decimalScaleVal = 2;                                         
                }

                // if String Value of 2 index Zero...
                if(strValList.size() == 1){
                    String stVal = '0000';
                    formattedNo = strValList[0]+'.'+stVal.substring(0,decimalScaleVal);
                }else{
                    if(strValList[1].length() < 2){
                        strValList[1] += '0000';
                        formattedNo = strValList[0]+'.'+strValList[1].substring(0,decimalScaleVal);
                    }else{
                    formattedNo = strValList[0]+'.'+strValList[1].substring(0,decimalScaleVal); 
                }  
                } 

            }else{
                formattedNo = strValList[0];                
            }
            //List<String> args = new String[]{'0','number',format};
           // formattedNo = String.format(val.format(), args);
         }
         return formattedNo;
    }
    
    public static List<String> getFieldValueAsString(List<Sobject> recordList, String fieldAPIName) {
        List<String> valueList = new List<String>();
        String value = '';
        if(recordList != null && recordList.size() > 0){
            for(Sobject record: recordList){
        String objectAPIName = String.valueOf(record.getSObjectType());
        Map<String, Schema.SObjectField> fieldMap = Schema.getGlobalDescribe().get(objectAPIName).getDescribe().fields.getMap();
                if(record.get(fieldAPIName) == null) return valueList;
        
        Schema.DisplayType FldType = fieldMap.get(fieldAPIName).getDescribe().getType();
        String fieldType = String.valueof(FldType);
        if(fieldType == 'DateTime') {
            value = Datetime.valueOf(record.get(fieldAPIName)).format('MM/dd/yyyy HH:mm:ss');
        } else if(fieldType == 'Date') {
            value = Date.valueOf(record.get(fieldAPIName)).format();
        } else if(fieldType == 'Double' || fieldType == 'Currency'){
            value = getFormattedNumber(Double.valueOf(record.get(fieldAPIName)), fieldMap.get(fieldAPIName).getDescribe().getScale(), 
                            (fieldType == 'Currency'),fieldType);
        }else if(fieldType == 'Email'){
            value = '<a href="mailto:'+String.valueOf(record.get(fieldAPIName))+'">'+String.valueOf(record.get(fieldAPIName))+'</a>';
        } 
        else {
            value = String.valueOf(record.get(fieldAPIName));
        }
            }
        }
        valueList.add(value);
        return valueList;
    }

    public static string replaceMergeFieldForTemplate(String text, String objectAPI, List<String> fieldList, Sobject record){
        String value='';
        List<String> valueList = new List<String>();
        Integer i=0;
        if(record != null && fieldList != null && fieldList.size() > 0){

            List<Sobject> recordList ;

            for(String field :fieldList){
                recordList = new List<Sobject>();
                if(field.contains('.')){
                    value ='';
                    List<String> relationshipFields = field.split('\\.');
                    Sobject temp;
                    for(i=0;i<relationshipFields.size()-1;i++) {    
                        String singleField = relationshipFields[i];                                                 
                        if(temp == null) {
                            temp = record.getSobject(singleField);
                        } else {
                            temp = temp.getSobject(singleField);
                        }   
                    } 
                    if(temp != null && temp.get(relationshipFields[i]) != null) {
                        recordList.add(temp);
                        valueList = getFieldValueAsString(recordList, relationshipFields[i]);
                        value = valueList[0];
                    }
                    if(String.isNotEmpty(value)) {
                        text = text.replace('{!'+ objectAPI + '.' +field+'}',String.escapeSingleQuotes(value));                                      
                    } else {
                        text = text.replace('{!'+ objectAPI + '.' +field+'}','');
                    }
                } else {
                        if(record.get(field) == null){
                           text = text.replace('{!'+ objectAPI + '.' +field+'}','');     
                        } else {
                        recordList.add(record);
                        valueList = getFieldValueAsString(recordList, field);
                        value = valueList[0];
                            text = text.replace('{!'+ objectAPI + '.' +field+'}',String.escapeSingleQuotes(value));
                        }
                   }
            } 
        }
        return text;
    }

    global static string replaceFields(String text,List<String> mergeFields,Sobject record){
        String value='';
        Integer i=0;
        if(mergeFields.size () > 0){
            if(record != null){
                for(String field : mergeFields){
                    if(field.contains('.')){
                        value ='';
                        List<String> relationshipFields = field.split('\\.');
                        Sobject temp;
                        for(i=0;i<relationshipFields.size()-1;i++){    
                            String singleField = relationshipFields[i];                                                 
                            if(temp == null){
                                temp = record.getSobject(singleField);
                                
                            }else{
                                temp = temp.getSobject(singleField);
                            }   
                        } 
                        if(temp != null && temp.get(relationshipFields[i]) != null){
                            value = String.valueOf(temp.get(relationshipFields[i]));
                        }
                        if(value != null) {
                            if(value.contains('\'')){
                                text = text.replace('{!'+field+'}',value);    
                            }else{
                                text = text.replace('{!'+field+'}',String.escapeSingleQuotes(value));  
                            }                                     
                        }else{
                            text = text.replace('{!'+field+'}','');
                        }
                    }else{
                        if(record.get(field) == null){
                           text = text.replace('{!'+field+'}','');     
                        }
                        else{
                            try{
                                if(String.isNotEmpty(dateTimeFormat)){
                                    value = Datetime.valueOf(record.get(field)).format('yyyy-MM-dd HH:mm:ss'); 
                                }else{
                                    value = Datetime.valueOf(record.get(field)).format(); 
                                }
                            }catch(Exception e){
                                value = String.valueOf(record.get(field));
                            }
                            text = text.replace('{!'+field+'}',String.escapeSingleQuotes(value));
                        }
                    }                    
                }
            }
        } 
        return text;
    }
    global static String replaceMergeFields(String text, Id recordId){
        if(recordId != null){
            Integer i=0;
            String value = ''; 
            String objectType = String.valueOf(recordId.getSobjectType());           
            List<String> mergeFieldsList = getMergeFields(text);
            Set<String> mergeFields = new Set<String>();
            Schema.DisplayType fielddataType;
            mergeFields.addAll(mergeFieldsList);
            mergeFieldsList = new List<String>();
            mergeFieldsList.addAll(mergeFields);
            if(mergeFields.size () > 0){
                String query = 'select ' + String.escapeSingleQuotes(String.join(mergeFieldsList, ', ')) + ' from ' + String.escapeSingleQuotes(objectType) + ' where IsDeleted = false AND id =:'+String.escapeSingleQuotes(recordId);
                List<Sobject> sobjRec;
                if(AppUtils.isObjectAccessible(objectType)){ //CRUD/FLS False +ve with the help of AppUtils we have performed check
                    sobjRec = Database.query(String.escapeSingleQuotes(query),AccessLevel.USER_MODE); //SOQL Injection - False +ve - Dynamic part of query is escapeSingleQuotes/static bind
                }
                if(sobjRec.size () > 0){
                    for(String field : mergeFields){
                        if(field.contains('.')){
                            List<String> relationshipFields = field.split('\\.');
                            Sobject temp;
                            for(i=0;i<relationshipFields.size()-1;i++){    
                                String singleField = relationshipFields[i];                                                 
                                if(temp == null){
                                    temp = sobjRec[0].getSobject(singleField);
                                    
                                }else{
                                    temp = temp.getSobject(singleField);
                                }   
                                // Try Catch For Sobject Exception to Be Handled..
                                try{
                                    if(temp.get(relationshipFields[relationshipFields.size() - 1]) != null){
                                        fielddataType = temp.getSobjectType().getDescribe().fields.getMap().get(relationshipFields[relationshipFields.size() -1].toLowerCase()).getDescribe().getType();
                                    }     
                                }catch(Exception ex){

                                } 
                            } 
                            if(temp != null && relationshipFields != null && temp.get(relationshipFields[i]) != null) {
                                value = String.valueOf(temp.get(relationshipFields[i]));
                                if(fielddataType == Schema.DisplayType.DateTime)
                                {
                                    Datetime dateGMT=Datetime.valueOf(value);
                                      Integer offset = UserInfo.getTimezone().getOffset(dateGMT);
                                
                                    Datetime local = dateGMT.addSeconds(offset/1000);
                                    string s1=local.format();
                                    value=s1;
                                }
                                //Bug 203544: NED - Task - Date field is not properly updating in the Pending Task table
                                if(fielddataType == Schema.DisplayType.Date){
                                    Date dToday = Date.valueOf(value);
                                    Datetime dt = datetime.newInstance(dToday.year(), dToday.month(),dToday.day());
                                    Datetime s1 = AppUtils.getLocalDateTime( dt);
                                    value=s1.formatGMT('dd/MM/yyyy');
                                }
                                text = text.replace('{!'+field+'}', String.escapeSingleQuotes(value));
                            } else {
                                text = text.replace('{!'+field+'}', '');
                            }
                        }else{
                            if(sobjRec[0].get(field) != null) {
                          value = String.valueOf(sobjRec[0].get(field));
                               fielddataType = sobjRec[0].getSobjectType().getDescribe().fields.getMap().get(field.toLowerCase()).getDescribe().getType();
                            if(fielddataType == Schema.DisplayType.DateTime)
                            {
                            Datetime dateGMT=Datetime.valueOf(value);
                              Integer offset = UserInfo.getTimezone().getOffset(dateGMT);
                        
                            Datetime local = dateGMT.addSeconds(offset/1000);
                            string s1=local.format();
                            value=s1;
                            }
                          //Bug 203544: NED - Task - Date field is not properly updating in the Pending Task table
                            if(fielddataType == Schema.DisplayType.Date){
                                Date dToday = Date.valueOf(value);
                                Datetime dt = datetime.newInstance(dToday.year(), dToday.month(),dToday.day());
                                Datetime s1 = AppUtils.getLocalDateTime( dt);
                                value=s1.formatGMT('dd/MM/yyyy');
                            }
                            text = text.replace('{!'+field+'}',String.escapeSingleQuotes(value));
                            } else {
                                text = text.replace('{!'+field+'}', '');
                            }
                        }                        
                    }
                }
            }
        }
        return text;
    }

    
    global static List<SelectOption> prepareSelectOption(Schema.DescribeFieldResult describeField) {// Dk : Spring Cleanup 7-4-16
        /*
        List<SelectOption> selectOptions = new List<SelectOption>();
        List<Schema.PicklistEntry> picklistEntries = describeField.getPickListValues();
        
        for( Schema.PicklistEntry opt : picklistEntries)
        {
            if(opt.isActive())
            {
                selectOptions.add(new SelectOption(opt.getLabel(), opt.getValue()));
            }
        }
        return selectOptions;*/
        return null;
    }
    global static Boolean isSystemAdminUser(){
        Boolean isAdmin = false;
        UserPreferences__c userPrefs = UserPreferences__c.getInstance();
        if (userPrefs.ProfileName__c == 'System Administrator') {
            isAdmin = true;
        }
       
        String valueText = KeyValueStoreHelper.getTextValue('AdminProfileNames', true);
        /*if(profile != null && profile.size() > 0){
            isAdmin = true;
        }*/
        return isAdmin;
    }
    global static String concatenate(String[] arr, String sep) {
        String result = '';
        if (arr == null) return result;
        Integer i=1;
        for (String ele : arr) {
            result += ele;
            if (i < arr.size()) result += sep;
            i++;
        }
        return result;
    }

   global static String concatenate(Set<String> arr, String sep) {
        String result = '';
        if (arr == null) return result;
        Integer i=1;
        for (String ele : arr) {
            result += ele;
            if (i < arr.size()) result += sep;
            i++;
        } 
        return result;
   }

   global static String concatenate(Set<Id> arr, String sep) {
        String result = '';
        if (arr == null) return result;
        Integer i=1;
        for (Id ele : arr) {
            result += ele;
            if (i < arr.size()) result += sep;
            i++;
        }
        return result;
   }

    global static String soqlList(Set<String> inStr) {
        return soqlList(new List<String>(inStr));
    }
    
    global static boolean isSite(){
        Boolean isSite = [Select UserType from User where Id=:UserInfo.getUserId()  WITH USER_MODE LIMIT 1].UserType == 'Guest';//CRUD/FLS False +ve As per business scenario we can't check for portal/external users
        return isSite;
    }
    
    global static String soqlList(String[] inStr) {
        integer i = 0;
        for(String strInstance:inStr){
            inStr[i] = String.escapeSingleQuotes(strInstance);
            i++;
        }
        String[] outStr = new String[]{};
        if(inStr.size() == 0)
        {
            return '()';
        }
        
        String commaSepInput = String.join(inStr, '\',\''); 
        return '(\''+commaSepInput+'\')' ;   
    }   
    
    global static String fieldsList(String[] inStr) {
        String[] outStr = new String[]{};
        if(inStr.size() == 0)
        {
            return '()';
        }
        
        String commaSepInput = String.join(inStr, ','); 
        return ''+commaSepInput+'' ;   
    }
    
    global static String getSelectedTabName(){
        String selectedTab='';
        Cookie tabNameCookie = ApexPages.currentPage().getCookies().get('govgrants_tabname');
        if(tabNameCookie !=null){
            selectedTab =tabNameCookie.getValue(); 
        }
        return selectedTab;
    }
    global static void setTabCookie() {
    }
    global static String setTabCookie(String tabName) {
        return null;          
    }
    
    global static String soqlList(List<User> Ids) {
        if(Ids.size() == 0)
        {
            return '()';
        }
        String commaSepInput = String.join(Ids, '\',\'');
        return '(\'' + commaSepInput + '\')' ;  
    }
    
    global static String soqlList(Set<Id> inStr) {
        return soqlList(new List<Id>(inStr));
    }
    
    global static String[] selectField(sObject[] objs, String fieldName) { // Dk : Spring Cleanup 7-4-16
        
        return null;
    }
        
    //private static boolean firstFilterApplied = false;
    // Dk : Spring Cleanup 7-4-16
    global static String whereOrAndClause() { //decides if to add WHERE or AND to sql based on firstFilterApplied flag
       
        return null;
    }
    global static void resetWhereOrAndClause() {
    }
    
    global static void setReturnOnPage(String url, PageReference page) {
    }
    
    global static PageReference getReturnPage() {
        return null;
    }
    
    global static Object[] reverse(Object[] anArray) {
        return null;
    }
    
    //Input fieldName may or maynot have the namespace.
    global static String applyNamespacePrefix(String fieldName) {
        String namespace = getNameSpacePrefix();
        if (!fieldName.startsWith(namespace)) {
            fieldName = namespace + fieldName;
        }
        return fieldName;
    }

    //Input fieldName with nameSpace
    global static String removeNamespacePrefix(String fieldName) {
        String namespace = getNameSpacePrefix();
        String fieldNameWithoutNameSpace = fieldName;
        if (fieldNameWithoutNameSpace.startsWith(namespace)) {
            fieldNameWithoutNameSpace = fieldNameWithoutNameSpace.substring(namespace.length());
        }
        return fieldNameWithoutNameSpace;
    }
    
    global static String getNameSpacePrefix()
    {
        if(nameSpacePrefixCache == null)
        {
            nameSpacePrefixCache = sObjectType.AccordionHeader__c.getName().removeEnd('AccordionHeader__c');
        }
        return nameSpacePrefixCache;
    }
    
    private static Id adminProfileId; //cache 
    global static Boolean isAdminUser()
    {
        if (Schema.sObjectType.Profile.fields.Id.isAccessible()) {
            if(adminProfileId == null)
            {
            adminProfileId = [Select Id from Profile where UserType = 'Standard' AND PermissionsCustomizeApplication = true WITH USER_MODE LIMIT 1].Id;
            }
            return UserInfo.getProfileId() == adminProfileId;
        }
        return null;
    }
    
    global static String toString(Exception ex){
        return null;
    }
    
    global static Boolean isInternalUser(){
        return (UserInfo.getUserType() == 'Standard');
    }
    /*
        Determines if the org is a sandbox org
    */
    global static boolean isSandbox() {return null; }
    //
    global static List<SObject> sortList(List<Sobject> items, String sortField, Boolean ascending) {return null;}

    
    /*
        Copies all fields from one record to another which are of different sobject types.
        It is assumed that both records have the same set of field api names.
        Also ensure that all fields are selected on the fromRec before invoking this method.
        @fieldsToExclude - set of field API names which should not be copied over
    */
    global static void copyFieldValues(SObject fromRec,  SObject toRec, Set<String> fieldsToExclude) {
        SchemaManager.SObjectWrapper fromObjWrapper = SchemaManager.getSObject(fromRec.getSObjectType().getDescribe().getName());
        Map<String, SchemaManager.SObjectFieldWrapper> fromFieldsDescribe = fromObjWrapper.fieldsMap;  //key in lowercase
        
                            
        SchemaManager.SObjectWrapper toObjWrapper = SchemaManager.getSObject(toRec.getSObjectType().getDescribe().getName());
        Map<String, SchemaManager.SObjectFieldWrapper> toFieldsDescribe = toObjWrapper.fieldsMap;  //key in lowercase
        
                            
        for(SchemaManager.SObjectFieldWrapper fromFieldwrapper : fromFieldsDescribe.values()) {
              
            Schema.DescribeFieldResult fromFR = fromFieldwrapper.fieldResult;
            
            SchemaManager.SObjectFieldWrapper toFieldWrapper = toFieldsDescribe.get(fromFieldwrapper.fieldName.toLowercase());
            
            if (toFieldWrapper != null) {
                Schema.DescribeFieldResult toFR = toFieldWrapper.fieldResult;
                if (toFR != null && toFR.isUpdateable() && fieldContains(fieldsToExclude, fromFieldwrapper.fieldName) == false) {
                    toRec.put(toFieldwrapper.fieldName, fromRec.get(fromFieldwrapper.fieldName));
                }
            }
        }
    }

    global static void copyRecord(SObject source, SObject target, boolean create){
        String ns = AppUtils.getNameSpacePrefix();
        String sourceName = source.getSobjectType().getDescribe().getName();
        String targetName = target.getSobjectType().getDescribe().getName();
        Map<String, Schema.SObjectField> fieldMap = Schema.getGlobalDescribe().get(targetName).getDescribe().fields.getMap();
        List<RecordCopyConfig__c> copyList;
            if(Schema.sObjectType.RecordCopyConfig__c.isAccessible()){ //Added for SF security review
                    copyList = [select SourceFieldName__c, TargetFieldName__c
            from RecordCopyConfig__c where SourceObjectName__c =:sourceName and TargetObjectName__c =:targetName  WITH USER_MODE];
                }

        for(RecordCopyConfig__c recordConfig : copyList){
                    String targetField;
                    if(Schema.sObjectType.RecordCopyConfig__c.fields.TargetFieldName__c.isCreateable() && Schema.sObjectType.RecordCopyConfig__c.isAccessible()){//Added for SF review
                        targetField = recordConfig.TargetFieldName__c;
                    }
            targetField = targetField.trim();
            String targetFld = targetField;
                    if(Schema.sObjectType.RecordCopyConfig__c.fields.SourceFieldName__c.isCreateable() && Schema.sObjectType.RecordCopyConfig__c.isAccessible()){//Added for SF review
            if(fieldMap.containsKey(targetFld.removeStart(ns))){
                 if(recordConfig.SourceFieldName__c.contains('.')){
                   if(recordConfig.SourceFieldName__c.countMatches('.') == 1){
                        String [] relationShipField = recordConfig.SourceFieldName__c.split('\\.');
                        Sobject sobj = source.getSObject(relationShipField[0]);
                        if(sobj != null) {
                            Object val = sobj.get(relationShipField[1]);
                            target.put(targetField,val);
                        }
                   }
                 }else{
                    target.put(targetField, source.get(recordConfig.SourceFieldName__c));
                 }
             }
        }
                }
                SystemContextMethodsHelper cls = new SystemContextMethodsHelper();
                String objName = cls.getSobjectName(target);
        if (create && isObjectCreateable(objName)) { 
            insert as user target;  //CRUD - False +ve - As this is Sobject with the help of other method we have checked CRUD 
        }
    }
    
    /*This method is used to map  values to existing record */  
    global static void copyRecord(String sourceObject,String targetObject,Id sourceRecordIDs,Sobject sobjectRec){
            String ns = AppUtils.getNameSpacePrefix();
            if (sourceRecordIDs != null ) {
                Sobject targetObjInstance = sobjectRec ;
                Map<String, Schema.SObjectField> fieldMap = Schema.getGlobalDescribe().get(targetObject).getDescribe().fields.getMap();
                
                 
                List<RecordCopyConfig__c> recordCopy = [select SourceFieldName__c, TargetFieldName__c
                    from RecordCopyConfig__c where SourceObjectName__c =:sourceObject and TargetObjectName__c =:targetObject WITH USER_MODE];
                String sourceRecordQuery,sourceRecFields;
                Set<String> sourceFieldSet = new Set<String>();
                Map<String,String> sourceTargetFieldsMap = new Map<String,String>();
                for(RecordCopyConfig__c recordConfig :recordCopy){
                    sourceTargetFieldsMap.put(recordConfig.TargetFieldName__c,recordConfig.SourceFieldName__c);
                    sourceFieldSet.add(recordConfig.SourceFieldName__c.toLowerCase());
                }
                List<String> sourceFieldLst = new List<String>();
                sourceFieldLst.addAll(sourceFieldSet);
                if(sourceFieldLst != null && sourceFieldLst.size () > 0){
                    sourceRecordQuery = 'select '+String.escapeSingleQuotes(String.join(sourceFieldLst, ', '))+' from '+String.escapeSingleQuotes(sourceObject)+ ' where id = :sourceRecordIDs';
                    List<Sobject> sourceRec;
                    if(AppUtils.isObjectAccessible(sourceObject)){//CRUD/FLS False +ve with the help of AppUtils we have performed check
                        sourceRec = Database.query(String.escapeSingleQuotes(sourceRecordQuery),AccessLevel.USER_MODE); //SOQL Injection - False +ve - Dynamic part of query is escapeSingleQuotes/static bind
                    }
                    for(Sobject srcObject :sourceRec){
                        for(String targetField : sourceTargetFieldsMap.keySet()){
                            String targetFld = targetField;
                            if(fieldMap.containsKey(targetFld.removeStart(ns))){
                                String sourceField  = sourceTargetFieldsMap.get(targetField);
                                if(sourceField.contains('.')){
                                    if(sourceField.countMatches('.') == 1){
                                        String [] relationShipField = sourceField.split('\\.');
                                        Sobject sobj = srcObject.getSObject(relationShipField[0]);
                                        if(sobj != null) {
                                            Object val = sobj.get(relationShipField[1]);
                                            targetObjInstance.put(targetField,val);
                                        }
                                    }
                                }else{
                                    targetObjInstance.put(targetField,srcObject.get(sourceField));
                                }
                            }
                        }   
                    }
                }
        }
    }
    
    
    global static void copyRecord(String sourceObject,String targetObject,Id sourceRecordIDs,Sobject sobjectRec,String groupName){
            String ns = AppUtils.getNameSpacePrefix();
            if (sourceRecordIDs != null ) {
            Sobject targetObjInstance = sobjectRec;
                Map<String, Schema.SObjectField> fieldMap = Schema.getGlobalDescribe().get(targetObject).getDescribe().fields.getMap();
                List<RecordCopyConfig__c> recordCopy = [select SourceFieldName__c, TargetFieldName__c,GroupName__c
                    from RecordCopyConfig__c where SourceObjectName__c =:sourceObject and TargetObjectName__c =:targetObject and GroupName__c = :groupName WITH USER_MODE];
                String sourceRecordQuery,sourceRecFields;
                Set<String> sourceFieldSet = new Set<String>();
                Map<String,String> sourceTargetFieldsMap = new Map<String,String>();
                for(RecordCopyConfig__c recordConfig :recordCopy){
                    sourceTargetFieldsMap.put(recordConfig.TargetFieldName__c,recordConfig.SourceFieldName__c);
                    sourceFieldSet.add(recordConfig.SourceFieldName__c.toLowerCase());
                }
                if(sourceFieldSet != null && sourceFieldSet.size () > 0){
                    sourceRecordQuery = 'select '+String.escapeSingleQuotes(AppUtils.concatenate(sourceFieldSet, ', '))+' from '+String.escapeSingleQuotes(sourceObject)+ ' where id = :sourceRecordIDs';
                    List<Sobject> sourceRec;
                    if(AppUtils.isObjectAccessible(sourceObject)){//CRUD/FLS False +ve with the help of AppUtils we have performed check
                        sourceRec = Database.query(String.escapeSingleQuotes(sourceRecordQuery),AccessLevel.USER_MODE); //SOQL Injection - False +ve - Dynamic part of query is escapeSingleQuotes/static bind
                    }
                    for(Sobject srcObject :sourceRec){
                        for(String targetField : sourceTargetFieldsMap.keySet()){
                            String targetFld = targetField;
                            if(fieldMap.containsKey(targetFld.removeStart(ns))){
                            String sourceField  = sourceTargetFieldsMap.get(targetField);
                            if(sourceField.contains('.')){
                                if(sourceField.countMatches('.') == 1){
                                    String [] relationShipField = sourceField.split('\\.');
                                    Sobject sobj = srcObject.getSObject(relationShipField[0]);
                                    if(sobj != null) {
                                        Object val = sobj.get(relationShipField[1]);
                                        targetObjInstance.put(targetField,val);
                                    }
                                }
                            }else{
                                targetObjInstance.put(targetField,srcObject.get(sourceField));
                            }
                        }
                    }
                }
                }
                
            
        }
    }
    
    
    
    /*
        This method uses Record Copy Config to create an instance of target record , as per the field mapping(Source - Target) mentioned
        in Record Copy Config object.   
    */
    global static List<Sobject> copyRecords(String sourceObject,String targetObject,List<Id> sourceRecordIDs,boolean create){
            List<Sobject> targetObjectList = new List<Sobject>();
            String ns = AppUtils.getNameSpacePrefix();
            if (sourceRecordIDs == null || sourceRecordIDs.size() == 0) return targetObjectList;
            Map<String, Schema.SObjectField> fieldMap = Schema.getGlobalDescribe().get(targetObject).getDescribe().fields.getMap();
            try{
                List<RecordCopyConfig__c> recordCopy = [select SourceFieldName__c, TargetFieldName__c
                    from RecordCopyConfig__c where SourceObjectName__c =:sourceObject and TargetObjectName__c =:targetObject WITH USER_MODE];
                Map<String, Schema.SObjectType> gd = Schema.getGlobalDescribe(); 
                Schema.SObjectType st = gd.get(targetObject);
                String sourceRecordQuery,sourceRecFields;
                Set<String> sourceFieldSet = new Set<String>();
                Map<String,String> sourceTargetFieldsMap = new Map<String,String>();
                for(RecordCopyConfig__c recordConfig :recordCopy){
                    sourceTargetFieldsMap.put(recordConfig.TargetFieldName__c,recordConfig.SourceFieldName__c);
                    sourceFieldSet.add(recordConfig.SourceFieldName__c.toLowerCase());
                }
                if(sourceFieldSet != null && sourceFieldSet.size () > 0){
                    List<Id> sourceRecordIdsSanitized = new List<Id>();
                    for(Id sourceRecId : sourceRecordIDs) {
                        sourceRecordIdsSanitized.add(String.escapeSingleQuotes(sourceRecId));
                    }
                    sourceRecordQuery = 'select '+String.escapeSingleQuotes(AppUtils.concatenate(sourceFieldSet, ', '))+' from '+String.escapeSingleQuotes(sourceObject)+ ' where id in :sourceRecordIdsSanitized';
                    List<Sobject> sourceRec;
                    if(AppUtils.isObjectAccessible(sourceObject)){ //CRUD/FLS False +ve with the help of AppUtils we have performed check
                        sourceRec = Database.query(String.escapeSingleQuotes(sourceRecordQuery),AccessLevel.USER_MODE); //SOQL Injection - False +ve - Dynamic part of query is escapeSingleQuotes/static bind
                    }
                    Sobject targetObjInstance;
                    for(Sobject srcObject :sourceRec){ 
                        targetObjInstance = st.newSObject();
                        for(String targetField : sourceTargetFieldsMap.keySet()){
                            String targetFld = targetField;
                            if(fieldMap.containsKey(targetFld.removeStart(ns))){
                            String sourceField  = sourceTargetFieldsMap.get(targetField);
                             if(sourceField.contains('.')){
                                if(sourceField.countMatches('.') == 1){
                                    String [] relationShipField = sourceField.split('\\.');
                                    Sobject sobj = srcObject.getSObject(relationShipField[0]);
                                    if(sobj != null) {
                                        Object val = sobj.get(relationShipField[1]);
                                        targetObjInstance.put(targetField,val);
                                    }
                                }
                            }else{
                                targetObjInstance.put(targetField,srcObject.get(sourceField));
                            }
                        }
                        }
                        targetObjectList.add(targetObjInstance);
                    }
                    if(create){
                        if(targetObjectList.size()>0)
                        {
                            SystemContextMethodsHelper cls = new SystemContextMethodsHelper();
                            String objName = cls.getSobjectName(targetObjectList[0]);
                            if(isObjectCreateable(objName)){
                                insert as user targetObjectList;//CRUD - False +ve - As this is Sobject with the help of other method we have checked CRUD
                            }
                        }  
                    }
                }
                
            }catch(Exception e){

            }
        return targetObjectList; 
    }
    
    global static List<Sobject> copyRecords(String sourceObject, String targetObject, Map<Id, List<Sobject>> srcIdToTargetSobjectsMap, boolean create){
        List<Sobject> targetObjectList = new List<Sobject>();
        Set<Id> sourceRecordIDs = srcIdToTargetSobjectsMap.keySet();
        
        if (sourceRecordIDs == null || sourceRecordIDs.size() == 0){
            return targetObjectList;
        }
        Map<String, Schema.SObjectField> fieldMap = Schema.getGlobalDescribe().get(targetObject).getDescribe().fields.getMap();
        Map<String, Schema.SObjectType> gd = Schema.getGlobalDescribe(); 
        Schema.SObjectType st = gd.get(targetObject);
        Sobject targetObjInstance = st.newSObject();
        String sourceRecordQuery,sourceRecFields;
        Set<String> sourceFieldSet = new Set<String>();
        Map<String,String> sourceTargetFieldsMap = new Map<String,String>();
        String ns = AppUtils.getNameSpacePrefix();
        // get the entries from RecordCopyConfig__c for the given SRC and TARGET
        
        List<RecordCopyConfig__c> recordCopy = [select SourceFieldName__c, TargetFieldName__c
            from RecordCopyConfig__c where SourceObjectName__c =:sourceObject and TargetObjectName__c =:targetObject WITH USER_MODE];
        
        if(recordCopy != null && recordCopy.size() > 0){
            // create map of SRC field --> TARGET field map. Also get the comma separated list of SRC fields
            for(RecordCopyConfig__c recordConfig :recordCopy){
                sourceTargetFieldsMap.put(recordConfig.TargetFieldName__c,recordConfig.SourceFieldName__c);
                sourceFieldSet.add(recordConfig.SourceFieldName__c.toLowerCase());
            }
             if(sourceFieldSet != null && sourceFieldSet.size () > 0){
                // Query the SRC records
                sourceRecordQuery = 'SELECT '+String.escapeSingleQuotes(AppUtils.concatenate(sourceFieldSet, ', '))+' FROM '+String.escapeSingleQuotes(sourceObject)+ ' WHERE ID IN :sourceRecordIDs';
                List<Sobject> sourceRec;
                if(AppUtils.isObjectAccessible(sourceObject)){ //CRUD/FLS False +ve with the help of AppUtils we have performed check
                    sourceRec = Database.query(String.escapeSingleQuotes(sourceRecordQuery),AccessLevel.USER_MODE); //SOQL Injection - False +ve - Dynamic part of query is escapeSingleQuotes/static bind
                }
                // populate TARGET records using the mapping and fetched SRC records
                for(Sobject srcObject : sourceRec){
                    List<Sobject> targetObjects = srcIdToTargetSobjectsMap.get(srcObject.Id);
                    for(Sobject targetRec : targetObjects){
                        for(String targetField : sourceTargetFieldsMap.keySet()){
                            String targetFld = targetField;
                            if(fieldMap.containsKey(targetFld.removeStart(ns))){
                            String sourceField  = sourceTargetFieldsMap.get(targetField);
                            if(sourceField.contains('.')){
                                if(sourceField.countMatches('.') == 1){
                                    String [] relationShipField = sourceField.split('\\.');
                                    Sobject sobj = srcObject.getSObject(relationShipField[0]);
                                    if(sobj != null){
                                        Object val = sobj.get(relationShipField[1]);
                                        targetRec.put(targetField,val);
                                    }
                                }
                            }else{
                                targetRec.put(targetField,srcObject.get(sourceField));
                            }
                        }
                        }
                        targetObjectList.add(targetRec);
                    }
                }
                
                if(create){
                    if(targetObjectList.size()>0)
                        {
                            SystemContextMethodsHelper cls = new SystemContextMethodsHelper();
                            String objName = cls.getSobjectName(targetObjectList[0]);
                            if(isObjectCreateable(objName)){
                                insert as user targetObjectList;//CRUD - False +ve - As this is Sobject with the help of other method we have checked CRUD
                            }
                        }  
                }
            }
        }
        return targetObjectList;
    }

    private static Boolean fieldContains(Set<String> fieldsToExclude, String field) {
        if (fieldsToExclude != null) {
            for (String fieldToExclude : fieldsToExclude) {
                if (field.endsWith(fieldToExclude)) {
                    return true;
                }
            }
        }
        return false;
    }
        
    global static void sendEmail(String[] toAddresses, String[] ccAddresses, String replyToEmail, 
                Boolean bccSender, String subject, String plainTextBody, String htmlBody)
    {
        String toAddress = String.join(toAddresses, ',');
        String ccAddress = String.join(ccAddresses, ',');
        new EmailFeeder().toEmail(toAddress).ccEmail(ccAddress).subject(subject).htmlBody(htmlBody).replyToEmail(replyToEmail).plainTextBody(plainTextBody).send(); 
    }
    
    global static void sendEmail(String[] toAddresses, String subject, String plainTextBody, String htmlBody) {
        String toAddress = String.join(toAddresses, ',');
        new EmailFeeder().toEmail(toAddress).subject(subject).htmlBody(htmlBody).plainTextBody(plainTextBody).send(); 
    }
    
    global static String getOrgWideEmailAddress() {
        String OWDName = KeyValueStoreHelper.getTextValue('OWDName', true);   
        if (String.isNotEmpty(OWDName)) {
            List<OrgWideEmailAddress> owaList = [select Id from OrgWideEmailAddress where DisplayName=:OWDName WITH USER_MODE LIMIT 1]; //CRUD/FLS False +ve as per business scenario it is failing for portal/guest users
            if (owaList.size() == 1) {
                return owaList.get(0).Id;
            }
        }
        return null;
    }  
    global static void sendEmail(String[] toAddresses, String subject, String plainTextBody, String htmlBody,boolean setOWD) {
        String toAddress = String.join(toAddresses, ',');
        new EmailFeeder().toEmail(toAddress).subject(subject).htmlBody(htmlBody).plainTextBody(plainTextBody).send(); 
        
    }
    
    global static void sendEmailUsingTemplate(Id templateId, Map<Id,Id> appIdToContIdMap, boolean setOWD){
        List<EmailFeeder> emailFeeders = new List<EmailFeeder>();
        List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
        List<OrgWideEmailAddress> owaList = new List<OrgWideEmailAddress>();
        if (Schema.sObjectType.EmailTemplate.fields.Name.isAccessible()) {
        String templateName = [select Name,DeveloperName from EmailTemplate where Id = :templateId WITH USER_MODE LIMIT 1].DeveloperName;
        for(Id ids : appIdToContIdMap.keyset()){
            if(appIdToContIdMap.get(ids) != null){
                EmailFeeder emailFeeder = new EmailFeeder();
                emailFeeder.contextRecordId(ids).template(templateName).TargetObjectId(appIdToContIdMap.get(ids)); 
                emailFeeders.add(emailFeeder);
            }
        }
        EmailFeeder.SendEmails(emailFeeders);
    }
    }
    
    global static void sendEmailUsingTemplate(Id templateId, Map<Id,Set<Id>> appIdToContIdSetMap, boolean setOWD){
        List<EmailFeeder> emailFeeders = new List<EmailFeeder>();
        if (Schema.sObjectType.EmailTemplate.fields.Name.isAccessible()) {
        String templateName = [select Name,DeveloperName from EmailTemplate where Id = :templateId WITH USER_MODE LIMIT 1].DeveloperName;
        for(Id whatId : appIdToContIdSetMap.keyset()){
            Set<Id> contIdSet = appIdToContIdSetMap.get(whatId);
            for(Id contId : contIdSet){
                EmailFeeder emailFeeder = new EmailFeeder();
                emailFeeder.contextRecordId(whatId).template(templateName).TargetObjectId(contId); 
                emailFeeders.add(emailFeeder);
            }
        }
        EmailFeeder.SendEmails(emailFeeders);
    }
    }
    
    global static void sendEmailUsingTemplate(Map<Id,Id>  WhatIdtemplateMap, Map<id,id> sendEmailMap, boolean setOWD){
        List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
        List<OrgWideEmailAddress> owaList = new List<OrgWideEmailAddress>();
        
        if(setOWD){
            String OWDName = KeyValueStoreHelper.getTextValue('OWDName',true);   
            owaList=[select id, DisplayName from OrgWideEmailAddress 
                        where DisplayName=:OWDName WITH USER_MODE LIMIT 1];//CRUD/FLS False +ve as per business scenario it is failing for portal/guest users
        }
        for(Id ids : sendEmailMap.keyset()){
            if(sendEmailMap.get(ids) != null){
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                mail.setTemplateId(WhatIdtemplateMap.get(ids));
                mail.setTargetObjectId(sendEmailMap.get(ids));  
                mail.setWhatId(ids); 
                if(setOWD && owaList!= null && owaList.size () > 0){
                    mail.setOrgWideEmailAddressId(owaList[0].id);
                }
                mails.add(mail);
            }
        }
        if (!Test.isRunningTest()) {
            Messaging.sendEmail(mails);
        }
    }
    
    // method to send email to users without contact using email templates
    global static void sendEmailUsingTemplate(Id templateId, Map<Id, String[]> recIdToAddressMap, Id dummyContactId,  boolean setOWD){
        List<EmailFeeder> emailFeeders = new List<EmailFeeder>();
        if (Schema.sObjectType.EmailTemplate.fields.Name.isAccessible()) {
        String templateName = [select Name,DeveloperName from EmailTemplate where Id = :templateId WITH USER_MODE LIMIT 1].DeveloperName;
        for(String whatId : recIdToAddressMap.keyset()){
            String[] contIdSet = recIdToAddressMap.get(whatId);
            for(String contId : contIdSet){
                EmailFeeder emailFeeder = new EmailFeeder();
                emailFeeder.contextRecordId(whatId).template(templateName).toEmail(contId); 
                emailFeeders.add(emailFeeder);
            }
        }
        EmailFeeder.SendEmails(emailFeeders);
    }
    }
    
    // method to send email to users without contact using email templates
    global static void sendEmailUsingTemplate(Map<Id, Id> recIdToTemplateIdMap, Map<Id, String[]> recIdToAddressMap, Id dummyContactId,  boolean setOWD){
        List<EmailFeeder> emailFeeders = new List<EmailFeeder>();
        if (Schema.sObjectType.EmailTemplate.fields.Name.isAccessible()) {
        Map<Id, EmailTemplate> idToTemplateNameMap = new Map<Id, EmailTemplate>([select Name,developerName from EmailTemplate where Id = :recIdToTemplateIdMap.values() WITH USER_MODE]);
        for(Id whatId : recIdToTemplateIdMap.keyset()){
            String[] contIdSet = recIdToAddressMap.get(whatId);
            for(String contId : contIdSet){
                EmailFeeder emailFeeder = new EmailFeeder();
                emailFeeder.contextRecordId(whatId).template(idToTemplateNameMap.get(whatId).developerName).toEmail(contId); 
                emailFeeders.add(emailFeeder);
            }
        }
        EmailFeeder.SendEmails(emailFeeders);
    }
    }
    
    /* This method is will notify Admin and Support with email in case of any exception*/
    global static void notifyTechSupport(Exception e){  // Dk : Spring Cleanup 7-4-16
    }
    
    /* This method is will notify Admin and Support with email in case of any exception*/
    global static void notifyTechSupport(Database.SaveResult[] saveResult,List<Sobject> sobejctList,String clsName){
    }

    private static String escChar = '|';
    private static String regexEscChar = '\\|';
    /*
     * Decodes an ecoded string back into a string array
     * @see AppUtils#encodeToString
     */
    global static String[] decodeToArray(String dbVal){
        String[] results = new String[0];
        if(dbVal != null){
            for(String s : dbVal.split('(?<!['+regexEscChar+']);(?!;)')) {
                results.add(s.replaceAll(regexEscChar+';;', escChar).replaceAll(regexEscChar+';', ';'));
            }
        }
        return results;
    }
    
    /*
     * Encodes an array into a single string
     * @see AppUtils#decodeToArray
     */
    global static String encodeToString(String[] displayVals){
        String result = '';
        if(displayVals != null){
        for(String s : displayVals) {
            if(String.isBlank(s)) {
                throw new ValidationException('Cannot encode a null or empty string');
            }
            s = s.replaceAll(';', escChar+';');
            if(s.endsWith(escChar)) { //stop the user from escaping the seperating comma
                s += ';;';
            }
            result += s + ';';
        }
        }
        /**Bug 181769 START- added below logic to remove ; if only 1 value is present in picklist to solve bad picklist error  */
        if(result.length() > 0){
            integer occOfSemi = result.countMatches(';');
                if(occOfSemi == 1){
                   result=  result.removeEnd(';');
                   return result;
                }else{
                   return result;
                }
        }
        /**Bug 181769 END */
        return null;       
    }
    
    /*
     * Encodes an array into a single string
     * @see AppUtils#decodeToArray
     */
    global static String encodeToString(String displayVal){
        String result = '';
        if(displayVal != null){
            if(String.isBlank(displayVal)) {
                throw new ValidationException('Cannot encode a null or empty string');
            }
            displayVal = displayVal.replaceAll(';', escChar+';');
            if(displayVal.endsWith(escChar)) { //stop the user from escaping the seperating comma
                displayVal += ';;';
            }
            result += displayVal + ';';
        }
        return result;
    }
    
    global static void dumpUrlParameters()  // Dk : Spring Cleanup 7-4-16
    {
    }
    
    global static String urlParam(String key) // Dk : Spring Cleanup 7-4-16
    {
        return null;
    }
    
    global static ValidationException createValidationException(Exception ex) // Dk : Spring Cleanup 7-4-16
            {
        return null;
    }
    
    private static String prettyMessage(String message)
    {
        return null;
    }
    
    global static boolean isMultiSelectEmpty(String values) { // Dk : Spring Cleanup 7-4-16
        return null;
    }
    
    global static String[] getStringsFromMultiSelect(String values) {   // Dk : Spring Cleanup 7-4-16
        return null;
    }

    
    /* INNER CLASSES */
    
    global with sharing class ValidationException extends Exception {}
    
    global with sharing class AgencyAutocomplete // Dk : Spring Cleanup 7-4-16
    {
        global String agencyName {get; set;}
        global String agencyAbbr {get; set;}
        global AgencyAutocomplete(String agencyName, String agencyAbbr)
        {
            this.agencyName = agencyName;
            this.agencyAbbr = agencyAbbr;
        }
    }
    
    
    global static String trim(String str){  // Dk : Spring Cleanup 7-4-16
            return null;   
    }
    
    /* This method returns current Fiscal year */
    global static String getCurrentFiscalYear(){
        Integer currentFY;
        Date todaydate = Date.today();    
        Integer currentyear = todaydate.year();
        Integer currentMonth = todaydate.month();
        Integer startMonth = KeyValueStoreHelper.getIntegerValue('FiscalYearStartMonth',true);
        if (currentMonth < startMonth){
            currentFY =  (currentyear - 1);
        }
        else {
            currentFY = currentyear;
        }  
        return String.valueOf(currentFY);   /* Returns a 4 digit year */                      
    }
    
    /* This method returns list of Fiscal years.*/
    global static List<String> getFiscalYearPickListValues(){
        return null;
    }
    /* This method returns list of Countries.*/
    global static List<String> getCountryPickListValues(){
       return null;
    }
    
    /* Pankaj : This method returns list of picklist values for given object and field.*/
    global static List<String> getPickListValues(String objectAPIName, String fieldAPIName){    // Dk : Spring Cleanup 7-4-16
        return null;
    }
    
    /*  Use this method to submit any record for approval process through Apex.
        Parametes : Record ID of the record which is to be submitted for approval
    */
    global static Approval.ProcessResult submitRecordForApproval(Id recordId){ // Dk : Spring Cleanup 7-4-16
        return null;
    }
    
    
    /* 
        Method populates the Task Object with values from an SObject record Id.
        It should be called before any Task is created in the system. 
    */
    global static Task assignTaskForSObject(Task approvalTask, String recordId){
       
        Id rcrdId = recordId;
        String name = rcrdId.getSobjectType().getDescribe().getName();
        AppUtils.copyRecord(name,'Task',recordId,approvalTask);
        return approvalTask;
    }
    
    
    
    
    /*
        METHOD TO RETURN THE FIELD LABEL OVERRIDE FROM CUSTOM SETTING (Flex Table Field Label Override Config)     
    */

    
    
    /* This method is used to format the Currency*/
    global static String formatCurrency(Decimal numberTobeFormatted){
        // this will give us the number with comma formatted and 2 decimal points, e.g, 5,000,000.56
       /* String decimalStrWithScaleFormat = numberTobeFormatted.setScale(2).format();
        
        //this will give us the number formatted as above but with additional $ sign, e.g, $5,000,000.56
        String decimalStrWithDollarSign = string.format('{0}', new string[]{decimalStrWithScaleFormat});
        
        return decimalStrWithDollarSign ;*/
        String val = string.valueOf(numberTobeFormatted.setScale(2));
        String[] valList = val.reverse().split('\\.');      
        String formated='';
        String updateVal='';
        if(valList.size() > 0){                     
            List<String> stringList = new List<String>{};
            Integer subs = 0;
            String fristPart, secondPart;
            if(valList.size()==2){
                fristPart = valList[1];
                secondPart = valList[0];
            }
            else if(valList.size()==1){
                fristPart = valList[0];
            }
            for(Integer x = 1; x < fristPart.length() + 1; x++){
                if(math.mod(x, 3) == 0){
                    stringList.add(fristPart.substring(subs, x));
                    subs = x;
                }
                else if(x == fristPart.length()){
                    stringList.add(fristPart.substring(subs, x));
                }
            }
            fristPart = string.join(stringList, ',');
            formated = fristPart;
            valList = new List<String>();
            if( secondPart !=null ){
                if(secondPart.length() == 1){
                    secondPart = secondPart + '0';
                }                          
                valList.add(secondPart);
                valList.add(fristPart);
                formated = string.join(valList, '.');               
            }                   
            formated=formated.reverse();
            if(formated.endsWith(',00')){
                formated=formated.substring(0,formated.lastIndexOf(','));
            }
        }
       
        val = getLocaleCurrencySymbol()+''+ formated;             
        //Comment : User Story 100297: Internal - Enhancement - Format currency field history on PDF..
        updateVal = val;
        if(updateVal.contains('-')){
        updateVal = updateVal.remove('-');
        updateVal = '('+updateVal+')';
        }
        if(updateVal.contains(getLocaleCurrencySymbol() + ',')){
        updateVal = updateVal.replace(getLocaleCurrencySymbol() + ',',getLocaleCurrencySymbol());
        }
        if(updateVal.contains('(,')){
        updateVal = updateVal.replace('(,','(');
        }
        return updateVal;
    }
    
    global static Boolean checkAdminUser(){
        Boolean isAdmin = false;
        UserPreferences__c userPrefs = UserPreferences__c.getInstance();
        String valueText = KeyValueStoreHelper.getTextValue('AdminProfileNames', true);
        if(valueText != null && valueText != ''){
            List<String> tokens = valueText.split(',');
            for(String profileName : tokens){
                if(profileName.equalsIgnoreCase(userPrefs.ProfileName__c)){
                    isAdmin = true;
                    break;
                }
            }
        }
        return isAdmin;
    }
    
    /*This method is used to fetch the current url and paramters - which can be used to pass to next page as a retURL*/
    global static String getRetURL(){
        String currentURL = URL.getCurrentRequestUrl().toExternalForm();
        String param = URL.getCurrentRequestUrl().getQuery();
        URL u = new URL(currentURL);
        String retURL = u.getPath() +'?'+param; 
        return retURL;
    }
    
    global static String getDefaultPhase(){
        String appName = UserPreferenceHelper.getStringValue('ActiveAppName__c');
        if(!String.isEmpty(appName)){
            if(Schema.sObjectType.PhaseConfig__c.isAccessible()){
                List<PhaseConfig__c> lstConfig = [Select Id, Name, Sequence__c From PhaseConfig__c 
                    Where CustomAppName__c = :appName And (PhaseType__c = 'Phase' OR PhaseType__c = 'Home')
                    WITH USER_MODE
                    Order by Sequence__c];
                if(lstConfig.size() > 0){
                    return lstConfig[0].Name;
                }
            }
        }
        return null;
    }
    
    global static String getMonthName(Integer month){   // Dk : Spring Cleanup 7-4-16
        
        return null;
    }
    global static Boolean isHistoryTable(String objectName){
        Set<String> historyTablesLib = new Set<String>{'casehistory','profile','processinstanceworkitem','task','report','attachment','processdefinition','contentversion'};  
                 
        Map<String,Schema.SObjectType> gd = Schema.getGlobalDescribe();        
        for(String objName:gd.keySet()){
            if(objName.endsWithIgnoreCase('__History') || objName.endsWithIgnoreCase('History')){          
                historyTablesLib.add(objName) ;    
                
            }
        }
        if(historyTablesLib.contains(objectName.toLowerCase())){
            return true;
        }
        return false;
    }
    global static String generateToken(Integer length) {
        String newS = String.valueOf(System.now().getTime());
        String inputKey = UserInfo.getUserId()+String.valueOf(Math.random()*10000) ; 
        if( Blob.valueOf(inputKey).size() > 512){
            inputKey = UserInfo.getUserId() ;
        }
        Blob hmacKey = Blob.valueOf(inputKey) ;
        String algorithmName = KeyValueStoreHelper.getTextValue('KeyedHashAlgorithm', true); //'HMacSHA1';
        if(String.isEmpty(algorithmName)){
            algorithmName= 'HMacSHA1' ;
        }
        Blob mac = Crypto.generateMac(algorithmName, Blob.valueOf(newS), hmacKey);
                                                                  
        String token = EncodingUtil.urlEncode(EncodingUtil.base64Encode(mac), 'UTF-8');
        token = token.replaceAll('%', 'p');
        Integer tokenLength = token.length();
        if (length > 0 && token.length() > length) {
            Integer startingPnt = tokenLength - length; 
            return token.substring(startingPnt, tokenLength); 
        }
        else {
            return token;
        }
    }
    global static PageReference getHomePage() {
        String activeAppName = UserPreferenceHelper.getStringValue('ActiveAppName__c');
        if(Schema.sObjectType.PhaseConfig__c.isAccessible()){
            List<PhaseConfig__c> phaseConfigAttributes = [select  URL__c FROM PhaseConfig__c where CustomAppName__c = : activeAppName 
                                                        and SelectedByDefault__c = true WITH USER_MODE limit 1];
            if(phaseConfigAttributes.size() > 0) {
                String phaseURL = phaseConfigAttributes[0].URL__c; //ApexOpenRedirect - False +ve - as only admin can create/update the value
                return new PageReference(URL.getOrgDomainURL().toExternalForm() + '/' + phaseURL); //ApexOpenRedirect - False +ve - used salesforce standard function
            }
        }
        return null;
    }

    global static String getUserType() {
        UserPreferences__c userPref = UserPreferences__c.getInstance();
        if (userPref == null) return '';

        if (userPref.IsApplicant__c) {
            return 'Applicant';
        }
        else if (userPref.IsReviewer__c) {
            return 'Reviewer';
        }
        else if (userPref.IsInternal__c) {
            return 'Internal';
        }
        return '';
    }
    
    global static boolean isApplicant(){
            
          UserPreferences__c userPrefs = UserPreferences__c.getInstance();
            if(userPrefs != null){
                if(UserPrefs.IsApplicant__c){
                    return true;
                }else{
                    return false;
                }
            }
            return false;
    }
    
    
    global static string getProfileInfo(){
      
        UserPreferences__c userPrefs = UserPreferences__c.getInstance();
        if(userPrefs != null){
            return userPrefs.ProfileName__c;
        }
        return null;
    }
    global static string getRoleInfo(){
      
        UserPreferences__c userPrefs = UserPreferences__c.getInstance();
        if(userPrefs != null){
            return userPrefs.RoleName__c;
        }
        return null;
    }
    /*Show / Hide Dynamic Layout components*/
    
    global static boolean showHideComponent(Boolean isViewLayout,Boolean isInternal,Boolean isApplicant,String profileNames,
                                        String recordId,String hideContext,String userType,string userProfile){
        if(userProfile == null && !Test.isRunningTest()) {
            throw new CustomExceptions.InputDataException('Profile Name is missing in user preference custom setting. Please contact Administrator.');
        }
        /*if(userType == null) {
            throw new CustomExceptions.InputDataException('User role is missing in custom setting (Global config). Please contact Administrator.');
        }*/
        Boolean hideForContext = false;
        boolean hideForUser = false;
        boolean hideForProfile = false;
        Set<Boolean> hideValues = new Set<Boolean>();   
        if(hideContext != null){ 
            if(isViewLayout && hideContext.containsIgnoreCase('View')){
                hideForContext = true;
            }else if(!isViewLayout && recordId != null && hideContext.containsIgnoreCase('Edit') ){
                hideForContext = true;
            }else if(!isViewLayout && recordId == null && hideContext.containsIgnoreCase('Create') ){
                hideForContext  = true;
            }
            hideValues.add(hideForContext);
        }
                        
        if( userType != null){
            if(isInternal && userType.containsIgnoreCase('Internal')){
               hideForUser = true;
            }else if(isApplicant && userType.containsIgnoreCase('Applicant')){
                hideForUser = true;
            }else if(!isApplicant && !isInternal && userType.containsIgnoreCase('Reviewer')){
               hideForUser  = true;
            }
            hideValues.add(hideForUser);
        }
        
        if(!String.isEmpty(profileNames)){
            String [] profiles = profileNames.split(';');
            for(String pName :profiles){
                if(pName.equalsIgnoreCase(userProfile)){
                    hideForProfile = true;
                    break;
                }
            } 
            hideValues.add(hideForProfile);
        }  
        Boolean result = null;
        for(Boolean hideComponent : hideValues){
            if(result == null){
                result = hideComponent;
            }else{
                result &= hideComponent;
            }
        }
        return result;
    }
    
    global static boolean showHideComponent(Boolean isViewLayout,Boolean isInternal,Boolean isApplicant,String profileNames,
                                        String recordId,String hideContext,String userType,String userProfile, String roleNames, String userRole){
        if(userProfile == null  && !Test.isRunningTest()) {
            throw new CustomExceptions.InputDataException('Profile Name is missing in user preference custom setting. Please contact administrator.');
        }
        //pankaj will fix this for custom setting
        /*if(userType == null) {
            throw new CustomExceptions.InputDataException('User role is missing in custom setting (Global config). Please contact administrator.');
        }*/
        if(hideContext != null){ 
            if(isViewLayout && hideContext.containsIgnoreCase('View')){
                return true;
            }else if(!isViewLayout && recordId != null && hideContext.containsIgnoreCase('Edit') ){
                return true;
            }else if(!isViewLayout && recordId == null && hideContext.containsIgnoreCase('Create') ){
                return true;
            }
        }
                        
        if( userType != null){
            if(isInternal && userType.containsIgnoreCase('Internal')){
                return true;
            }else if(isApplicant && userType.containsIgnoreCase('Applicant')){
                return true;
            }else if(!isApplicant && !isInternal && userType.containsIgnoreCase('Reviewer')){
                return true;
            }
        }
        
        if(!String.isEmpty(profileNames)){
            String [] profiles = profileNames.split(';');
            for(String pName :profiles){
                if(pName.equalsIgnoreCase(userProfile)){
                    return true;
                }
            } 
        }  

        if(!String.isEmpty(roleNames)){
            String [] roles = roleNames.split(';');
            for(String rName :roles){
                if(rName.equalsIgnoreCase(userRole)){
                    return true;
                }
            } 
        }  
        return false;
    }

    global static void createFormInstanceRecord(String pkagId,String parentId,List<String> formType){
        List<FormInstance__c> formInstanceList = new List<FormInstance__c>();
        List<FormInstance__c> newFormInstanceList = new List<FormInstance__c>();
        Map <String,FormInstance__c> formInstanceMap = new Map<String,FormInstance__c>();
        List<PackageFormConfig__c> pacFormConfigList;
        if(pkagId != null){
            if(Schema.sObjectType.FormInstance__c.isAccessible()){
                formInstanceList = [select ParentRecordId__c,Percentage__c,PackageBusinessForm__c from FormInstance__c where ParentRecordId__c =:parentId WITH USER_MODE];
            }
            if(Schema.sObjectType.PackageFormConfig__c.isAccessible()){
                if(formType == null || formType.size() == 0){
                    pacFormConfigList = [SELECT Id, PackageConfig__c, FormConfig__c FROM PackageFormConfig__c WHERE PackageConfig__c =: pkagId and FormConfig__r.Status__c='Active' WITH USER_MODE];
                }else{
                    pacFormConfigList = [SELECT Id, PackageConfig__c, FormConfig__c FROM PackageFormConfig__c WHERE PackageConfig__c =: pkagId and FormConfig__r.FormType__c IN:formType WITH USER_MODE];
                }
            }
            if(formInstanceList.size() > 0){
                for (FormInstance__c formInst:formInstanceList){
                    formInstanceMap.put(formInst.PackageBusinessForm__c,formInst);
                }
            }
            if(pacFormConfigList.size() > 0 ){
                for(PackageFormConfig__c packFormConfig: pacFormConfigList){
                    if(formInstanceMap.get(packFormConfig.Id) != null)continue;
                    FormInstance__c frmInstance = new FormInstance__c();
                    if(Schema.sObjectType.FormInstance__c.fields.PackageBusinessForm__c.isCreateable()){
                        frmInstance.PackageBusinessForm__c = packFormConfig.Id;
                    }
                    if(Schema.sObjectType.FormInstance__c.fields.ParentRecordId__c.isCreateable()){
                        frmInstance.ParentRecordId__c = parentId;
                    }
                    if(Schema.sObjectType.FormInstance__c.fields.Percentage__c.isCreateable()){
                        frmInstance.Percentage__c = 0;
                    }
                    newFormInstanceList.add(frmInstance);
                }
            }
            if(newFormInstanceList.size() > 0 && Schema.sObjectType.FormInstance__c.isCreateable()){
                insert as user newFormInstanceList;
            }

        }
    }

    public static String getUniqueJobName(String batchApexName) {
        String uniqueJobName = batchApexName + '_' + System.now().format('yyyy-MM-dd_k:m:s:S');
        return uniqueJobName;
    }
    
    //added for hide fields JSON in view and print genarator
    public static String removeDecimalPart(String fieldVal){
        List<String> decimalVal = String.isNotBlank(fieldVal) ? fieldVal.split('\\.') : null;
        if(decimalVal != null && decimalVal.size() > 1){
            fieldVal = (decimalVal.get(1) == '0' || decimalVal.get(1) == '00' || decimalVal.get(1) == '000') ? decimalVal.get(0) : fieldVal;
            return fieldVal.replaceAll(',', '');
        }
        return fieldVal;
    }

    //prepares schedule time that would allow the job to run only once after X minutes from current time.
    public static String prepareJobsSchTime(DateTime startDate, Integer addMinutes) {
        Datetime scheduleTime = startDate.addMinutes(addMinutes);
        String hour = scheduleTime.format('k');
        if (hour == '24') hour = '0';
        String scheduleTimeStr = '0 ' + scheduleTime.format('m') + ' ' + hour +  scheduleTime.format(' d M') + ' ? ' + scheduleTime.format('yyyy');
        return scheduleTimeStr;
    }
 /*Show / Hide Dynamic Layout components*/
    //DK : temp method to support or operator--- 
    global static boolean showHideComponent(Boolean isViewLayout,Boolean isInternal,Boolean isApplicant,String profileNames,
                                        String recordId,String hideContext,String userType,String userProfile, String operator){
        
        if(userProfile == null  && !Test.isRunningTest()) {
            //throw new CustomExceptions.InputDataException('Profile Name is missing in user preference custom setting. Please contact administrator.');
            //String myLabel = System.Label.UserPrefrenceLabel;
            
            CustomExceptions.logException(String.format(System.Label.UserPrefrenceLabel, new List<String>{Userinfo.getUserId()}), false);

        }  
       
        if(operator == 'AND') {
            Boolean hideForContext = false;
            boolean hideForUser = false;
            boolean hideForProfile = false;
            Set<Boolean> hideValues = new Set<Boolean>();   
            if(hideContext != null){ 
                if(isViewLayout && hideContext.containsIgnoreCase('View')){
                    hideForContext = true;
                }else if(!isViewLayout && recordId != null && hideContext.containsIgnoreCase('Edit') ){
                    hideForContext = true;
                }else if(!isViewLayout && recordId == null && hideContext.containsIgnoreCase('Create') ){
                      hideForContext  = true;
                }
                hideValues.add(hideForContext);
            }
                            
            if( userType != null){
                if(isInternal && userType.containsIgnoreCase('Internal')){
                   hideForUser = true;
                }else if(isApplicant && userType.containsIgnoreCase('Applicant')){
                    hideForUser = true;
                }else if(!isApplicant && !isInternal && userType.containsIgnoreCase('Reviewer')){
                   hideForUser  = true;
                }
                hideValues.add(hideForUser);
            }
            
            if(!String.isEmpty(profileNames)){
                String [] profiles = profileNames.split(';');
                for(String pName :profiles){
                    if(pName.equalsIgnoreCase(userProfile)){
                        hideForProfile = true;
                        break;
                    }
                } 
                hideValues.add(hideForProfile);
            }  
            Boolean result;
            for(Boolean hideComponent : hideValues){
                if(result == null){
                    result = hideComponent;
                }else{
                    result &= hideComponent;
                }
            }
            return result;
        } else {     
            Boolean hideForContext = false;
            boolean hideForUser = false;
            boolean hideForProfile = false;  
            Set<Boolean> hideValues = new Set<Boolean>();          
            if(hideContext != null){ 
                if(isViewLayout && hideContext.containsIgnoreCase('View')){
                    //return true;
                    hideForContext = true;
                }else if(!isViewLayout && recordId != null && hideContext.containsIgnoreCase('Edit') ){
                    //return true;
                    hideForContext = true;
                }else if(!isViewLayout && recordId == null && hideContext.containsIgnoreCase('Create') ){
                    //return true;
                    hideForContext  = true;
                }
                hideValues.add(hideForContext);                
            }                           
            if( userType != null){
                if(isInternal && userType.containsIgnoreCase('Internal')){
                    //return true;
                    hideForUser = true;
                }else if(isApplicant && userType.containsIgnoreCase('Applicant')){
                    //return true;
                    hideForUser = true;
                }else if(!isApplicant && !isInternal && userType.containsIgnoreCase('Reviewer')){
                    //return true;
                    hideForUser  = true;
                }                
                hideValues.add(hideForUser);
            }                       
            if(!String.isEmpty(profileNames)){
                String [] profiles = profileNames.split(';');
                for(String pName :profiles){
                    if(pName.equalsIgnoreCase(userProfile)){
                        //return true;
                        hideForProfile = true;
                        break;                        
                    }
                }
                hideValues.add(hideForProfile);                                 
            }
            Boolean result;
            for(Boolean hideComponent : hideValues){
                if(result == null){
                    result = hideComponent;
                }else{
                    result ^= hideComponent;
                }
            }
            return result;                        
        }  
        
    }      

 /*Show / Hide Dynamic Layout components*/
    
    global static boolean showHideComponent(Boolean isViewLayout,Boolean isInternal,Boolean isApplicant,String profileNames,
                                        String recordId,String hideContext,String userType,String userProfile, String roleNames, String userRole, String operator){
        if(userProfile == null  && !Test.isRunningTest()) {
            throw new CustomExceptions.InputDataException('Profile Name is missing in user preference custom setting. Please contact administrator.');
        }
        if(operator == 'AND') {
            Boolean hideForContext = false;
            boolean hideForUser = false;
            boolean hideForProfile = false;
            boolean hideForRole = false;
            Set<Boolean> hideValues = new Set<Boolean>();   
            if(hideContext != null){ 
                if(isViewLayout && hideContext.containsIgnoreCase('View')){
                    hideForContext = true;
                }else if(!isViewLayout && recordId != null && hideContext.containsIgnoreCase('Edit') ){
                    hideForContext = true;
                }else if(!isViewLayout && recordId == null && hideContext.containsIgnoreCase('Create') ){
                      hideForContext  = true;
                }
                hideValues.add(hideForContext);
            }
                            
            if( userType != null){
                if(isInternal && userType.containsIgnoreCase('Internal')){
                   hideForUser = true;
                }else if(isApplicant && userType.containsIgnoreCase('Applicant')){
                    hideForUser = true;
                }else if(!isApplicant && userType.containsIgnoreCase('Reviewer')){
                   hideForUser  = true;
                }
                hideValues.add(hideForUser);
            }
            
            if(!String.isEmpty(profileNames)){
                String [] profiles = profileNames.split(';');
                for(String pName :profiles){
                    if(pName.equalsIgnoreCase(userProfile)){
                        hideForProfile = true;
                        break;
                    }
                } 
                hideValues.add(hideForProfile);
            }  
            if(!String.isEmpty(roleNames)){
                String [] roles = roleNames.split(';');
                for(String rName :roles){
                    if(rName.equalsIgnoreCase(userRole)){
                        hideForRole = true;
                        break;
                    }
                } 
                hideValues.add(hideForRole);
            }
            Boolean result;
            for(Boolean hideComponent : hideValues){
                if(result == null){
                    result = hideComponent;
                }else{
                    result &= hideComponent;
                }
            }
            return result;
        } else {
            if(hideContext != null){ 
                if(isViewLayout && hideContext.containsIgnoreCase('View')){
                    return true;
                }else if(!isViewLayout && recordId != null && hideContext.containsIgnoreCase('Edit') ){
                    return true;
                }else if(!isViewLayout && recordId == null && hideContext.containsIgnoreCase('Create') ){
                    return true;
                }
            }
                            
            if( userType != null){
                if(isInternal && userType.containsIgnoreCase('Internal')){
                    return true;
                }else if(isApplicant && userType.containsIgnoreCase('Applicant')){
                    return true;
                }else if(!isApplicant && userType.containsIgnoreCase('Reviewer')){
                    return true;
                }
            }

            if(!String.isEmpty(profileNames)){
                String [] profiles = profileNames.split(';');
                for(String pName :profiles){
                    if(pName.equalsIgnoreCase(userProfile)){
                        return true;
                    }
                } 
            }  

            if(!String.isEmpty(roleNames)){
                String [] roles = roleNames.split(';');
                for(String rName :roles){
                    if(rName.equalsIgnoreCase(userRole)){
                        return true;
                    }
                } 
            }
        }  
        return false;
    }
    global static boolean readOnlyOrEditableForComponent(Boolean isViewLayout,Boolean isInternal,Boolean isApplicant,String profileNames,
                                        String recordId,String readContext,String userType,string userProfile,string userRole,string userRoles){
        if(readContext != null){ 
            if(isViewLayout && readContext.containsIgnoreCase('View')){
                return true;
            }else if(!isViewLayout && recordId != null && readContext.containsIgnoreCase('Edit') ){
                return true;
            }else if(!isViewLayout && recordId == null && readContext.containsIgnoreCase('Create') ){
                return true;
            }
        }
                        
        if( userType != null){
            if(isInternal && userType.containsIgnoreCase('Internal')){
                return true;
            }else if(isApplicant && userType.containsIgnoreCase('Applicant')){
                return true;
            }else if(!isApplicant && !isInternal && userType.containsIgnoreCase('Reviewer')){
                return true;
            }
        }
        
        if(!String.isEmpty(profileNames)){
            String [] profiles = profileNames.split(';');
            for(String pName :profiles){
                if(pName.equalsIgnoreCase(userProfile)){
                    return true;
                }
            } 
        }

        if(!String.isEmpty(userRoles)){
            String [] roles = userRoles.split(';');
            for(String rName :roles){
                if(rName.equalsIgnoreCase(userRole)){
                    return true;
                }
            } 
        }    
        return false;
    }
    
    
    global static String setTabNameFromID(){ 
        Id recordId = SFDCEncoder.SFDC_JSENCODE(ApexPages.currentPage().getParameters().get('id'));
        String SobjectName;
        if(recordId != null){
            SobjectName = String.valueOf(recordId.getSObjectType());
        }
        String appName = UserPreferenceHelper.getStringValue('ActiveAppName__c');
        String profileName = getProfileInfo();
        String query = 'select Name from PhaseConfig__c where SObject__c includes (\'' +  String.escapeSingleQuotes(SobjectName) + '\') and CustomAppName__c =:appName and AvailableforProfiles__c '
        + 'includes (\'' + String.escapeSingleQuotes(profileName) + '\')'
         +' order by sequence__c';
         List<PhaseConfig__c> phases;
         if(Schema.sObjectType.PhaseConfig__c.isAccessible()) {
            phases = Database.query(query,AccessLevel.USER_MODE);//SOQL Injection - False +ve - Dynamic part of query string is escapeSingleQuotes 
         }
        if(phases.size () > 0){
            String tabName = setTabCookie(phases[0].name);
            return tabName;
        }
        return null;
    }
    
    
   global static Set<String> getMergeFieldsForTemplate(Set<String> fields,String objectType){   // Dk : Spring Cleanup 7-4-16
       return null;
   }
   // Dk : Spring Cleanup 7-4-16
   global static List<Messaging.SingleEmailMessage> sendTaskNotification(String[] toAddresses,String subject,string body,boolean setOWD){
            return null;
    }
    
    
    /* This method uses standard Business Hour method to add Business Days. Offset days is converted into milliseconds*/
    global static Datetime addBusinessDays(Datetime actualDate, Integer offsetDays) {
        return null;   
    }
    
    public static Datetime getLocalDateTime(Datetime z) {    
        Datetime l = z.Date();
        l = l.addHours(z.hour());
        l = l.addMinutes(z.minute());
        l = l.addSeconds(z.second());
        return l;
    }
    
    public static Boolean isObjectAccessible(String objectName) {
        sobject sObj = Schema.getGlobalDescribe().get(objectName.toLowerCase()).newSObject() ;        
        return sObj.getSObjectType().getDescribe().isAccessible();
    }
    
    public static Boolean isObjectUpdateable(String objectName) {
        sobject sObj = Schema.getGlobalDescribe().get(objectName.toLowerCase()).newSObject() ;        
        return sObj.getSObjectType().getDescribe().isUpdateable();
    }
    
    public static Boolean isObjectDeletable(String objectName) {
        sobject sObj = Schema.getGlobalDescribe().get(objectName.toLowerCase()).newSObject() ;
        return sObj.getSObjectType().getDescribe().isDeletable();
    }
    
    public static Boolean isObjectCreateable(String objectName) {
        sobject sObj = Schema.getGlobalDescribe().get(objectName.toLowerCase()).newSObject() ;        
        return sObj.getSObjectType().getDescribe().isCreateable();
    }
    
    public static Boolean checkEmailAddress(String emailAddress) {
        String emailRegex = '[a-zA-Z0-9\\.\\!\\#\\$\\%\\&\\*\\/\\=\\?\\^\\_\\+\\-\\`\\{\\|\\}\\~\'._%+-]+@[a-zA-Z0-9\\-.-]+\\.[a-zA-Z]+';
        List<String> ListEAddrs = emailAddress.split(';');
        for( String singleEmail : ListEAddrs) {
            if(!Pattern.compile(emailRegex).matcher(singleEmail).matches()) {
                return false;
            }
        }
        return true;         
    }
    
    public static String resizeString(Integer length,String value){
        String resizedString = value;
        if(value.length() > length){
            resizedString =value.substring(0,length);      
        }
        return resizedString;
   }

    public static Double getLatestVersion(){
        List<ApexClass>  apexClassList = [SELECT ApiVersion FROM ApexClass WITH USER_MODE ORDER BY ApiVersion DESC LIMIT 1];//CRUD/FLS False +ve As per business scenario we can't check for portal/external users
        if(apexClassList.size() > 0){
            return apexClassList[0].ApiVersion;
        }else{
            return 42.0;
        }
    }
        
     /*
    Method  :   executeAnonymousScript(String anonymousExecuteScript)
    Purpose :   This method will run script which is define in flex table action.
    */
    global static String executeAnonymousScript(String anonymousExecuteScript) {
       return null;
    }

    public static string getActiveTabNameFromId(String strRecordId, String currentAppName) {
        if(String.isBlank(strRecordId)) {
            return '';
        }
        Id recordId = Id.valueOf(strRecordId);
        String objectName = recordId.getSObjectType().getDescribe().getName();
        List<SObjectPhaseConfig__c> sObjPhaseConfigList;

        if(Schema.sObjectType.SObjectPhaseConfig__c.isAccessible()) {
             sObjPhaseConfigList = [SELECT PhaseConfig__r.Name, PhaseConfig__r.CustomAppName__c,
                                                            SObjectConfig__r.Name
                                                        FROM SObjectPhaseConfig__c
                                                        WHERE PhaseConfig__r.CustomAppName__c =: currentAppName
                                                        AND SObjectConfig__r.Name =: objectName
                                                        AND HighlightPhase__c = true 
                                                        WITH USER_MODE];
        }
        if(sObjPhaseConfigList.size() == 0) {
            return '';
        }

        if(sObjPhaseConfigList.size() > 1) {
            CustomExceptions.logException('Please configure only single record for App: ' + currentAppName + ' SObject: ' + objectName + ' with Highlight Phase checked.' , false);
        }

        return sObjPhaseConfigList[0].PhaseConfig__r.Name;
    }
    /*Created By: Amol Darekar
    Created Date: 14th Sept 2018
    Modified Date: 24th June 2019
    Modified By : Tom Pallissery
    Modifications : Added support for top level domain in url to be configurable
    Purpose: Get base url of VF page inorder to get content of custom form pdf page exist in client org.*/
    public static String getPdfRedirectionURL() {
        PageReference tmpPage = Page.PdfRedirectionHandler;      
        String vfPageBaseUrl= tmpPage.getContent().tostring();
        vfPageBaseUrl = vfPageBaseUrl.Substring(vfPageBaseUrl.indexof('https'),vfPageBaseUrl.indexOfIgnoreCase('pdfredirectionhandler'));
        String topLevelDomain = (KeyValueStoreHelper.getTextValue('OrgTopLevelDomain', true) == null ? 'com' : KeyValueStoreHelper.getTextValue('OrgTopLevelDomain', true));
        Set<String> lstTopDomains = new Set<String>(topLevelDomain.split(',')); // change this to profile level config later, instead of key value
        for(String domain : lstTopDomains) {
            if(domain.startsWith('.')) {
                domain = domain.replaceFirst('.',''); // to ensure it contains only single dot in the beginnning, remove and append again
            }
            domain = '.' + domain;
            if(vfPageBaseUrl.indexof(domain) != -1) {
                vfPageBaseUrl = vfPageBaseUrl.Substring(vfPageBaseUrl.indexof('https'),vfPageBaseUrl.indexof(domain));   
                vfPageBaseUrl += domain;
                break;
            }
        }

        //Replace gnt package namespace with c  
        if(String.IsNotBlank(vfPageBaseUrl) && vfPageBaseUrl.contains('--gnt'))
            vfPageBaseUrl =  vfPageBaseUrl.replace('--gnt','--c');

        // Prevent URL Redirect Attack....
        URL currentURL = New URL('https://' + ApexPages.currentPage().getUrl());
        Set<String> whiteListedDomains = new Set<String>();
        whiteListedDomains.add(currentURL.getHost());
        if(vfPageBaseUrl == NULL || !whiteListedDomains.contains(New URL(vfPageBaseUrl).getHost())){
            vfPageBaseUrl = '';
        }
        return vfPageBaseUrl;
    }

    //User Story 71061: Internal - Remove document object dependency and move to static resource
    //User Story 110349: Internal - Optimization - CPU time limit - AppUtils.getIcons method
    static Map<String, String> iconMaps = new Map<String, String>();
 @AuraEnabled
    public static String getIcons(String strResourceName) {
        try {
            if(iconMaps.containsKey(strResourceName)){
                return iconMaps.get(strResourceName);
            }
            fetchIcons(new List<String>{strResourceName});
            return iconMaps.get(strResourceName);
        } catch(Exception ex){
            return null;
        }
    }

    //User Story 110349: Internal - Optimization - CPU time limit - AppUtils.getIcons method
    public static void fetchIcons(List<String> lstIconNames){
        try {
            Set<String> setIconNames = new Set<String>();
            for(String strName : lstIconNames){
                if(!iconMaps.containsKey(strName)){
                    setIconNames.add(strName);
                }
            }
            if(!setIconNames.isEmpty()){
                Map<String, String> mapIcons;
                
                if(!iconMaps.keySet().containsAll(setIconNames)){                    
                    mapIcons = SystemContextMethodsHelper.getIcons(setIconNames);
                }
                if(mapIcons != null && !mapIcons.isEmpty()){
                    iconMaps.putAll(mapIcons);
                }
            }
        } catch(Exception ex){
            
        }
    }

    @AuraEnabled
    public static String parseErrorMessageList(String pageMessageListString){
        List<LightningPageMessage> pageMessageList = (List<LightningPageMessage>) JSON.deserialize(pageMessageListString,List<LightningPageMessage>.class); // false+ for Deserializing objects from an untrusted source is security-sensitive as sanitizing it by using SFDCEncoder.sanitizeJSON
        for (LightningPageMessage msg : pageMessageList) {
            msg.messageBody = handleSystemExceptionMsg(msg.messageBody);
        }
        return JSON.serialize(pageMessageList);
    }

    /*
        Created By : Shantanu Gadhe
        Description : to handle the System Exception message. 
    */

    public static String handleSystemExceptionMsg(String msg){
        if(msg.contains('FIELD_CUSTOM_VALIDATION_EXCEPTION')){
            //msg = msg.substringBetween('FIELD_CUSTOM_VALIDATION_EXCEPTION,',':');
            msg = msg.substring(0, msg.lastIndexOf(':'));
            msg = msg.substringAfter('FIELD_CUSTOM_VALIDATION_EXCEPTION,');
            msg = msg.unescapeHtml4();
        }
        if(msg.contains('INSUFFICIENT_ACCESS_ON_CROSS_REFERENCE_ENTITY')){
            msg = msg.substringBetween('INSUFFICIENT_ACCESS_ON_CROSS_REFERENCE_ENTITY,',':'); 
        }
        if(msg.contains('INSUFFICIENT_ACCESS_OR_READONLY')){
            msg = msg.substringBetween('INSUFFICIENT_ACCESS_OR_READONLY,',':'); 
        }
        if(msg.contains('FIELD_INTEGRITY_EXCEPTION,')){
            msg = msg.substringBetween('FIELD_INTEGRITY_EXCEPTION,',':'); 
        }
        if(msg.contains('FIELD_FILTER_VALIDATION_EXCEPTION,')){
            msg = msg.substringBetween('FIELD_FILTER_VALIDATION_EXCEPTION,',':'); 
        }
        if(msg.contains('INVALID_CROSS_REFERENCE_KEY,')){
            msg = msg.substringBetween('INVALID_CROSS_REFERENCE_KEY,',':'); 
        }
        if(msg.contains('INVALID_CROSS_REFERENCE_TYPE_FOR_FIELD,')){
            msg = msg.substringBetween('INVALID_CROSS_REFERENCE_TYPE_FOR_FIELD,',':'); 
        }
        if(msg.contains('INVALID_OR_NULL_FOR_RESTRICTED_PICKLIST,')){
            msg = msg.substringBetween('INVALID_OR_NULL_FOR_RESTRICTED_PICKLIST,',':'); 
        }
        if(msg.contains('INVALID_USERID,')){
            msg = msg.substringBetween('INVALID_USERID,',':'); 
        }
        if(msg.contains('ITEM_NOT_FOUND,')){
            msg = msg.substringBetween('ITEM_NOT_FOUND,',':'); 
        }
        if(msg.contains('LIMIT_EXCEEDED,')){
            msg = msg.substringBetween('LIMIT_EXCEEDED,',':'); 
        }
        if(msg.contains('MALFORMED_ID,')){
            msg = msg.substringBetween('MALFORMED_ID,',':'); 
        }
        if(msg.contains('RELATED_ENTITY_FILTER_VALIDATION_EXCEPTION,')){
            msg = msg.substringBetween('RELATED_ENTITY_FILTER_VALIDATION_EXCEPTION,',':'); 
        }
        if(msg.contains('REQUIRED_FIELD_MISSING,')){
            msg = msg.substringBetween('REQUIRED_FIELD_MISSING,',':'); 
        }
        if(msg.contains('UNSUPPORTED_APEX_TRIGGER_OPERATON,')){
            msg = msg.substringBetween('UNSUPPORTED_APEX_TRIGGER_OPERATON,',':'); 
        }
        if(msg.contains('INVALID_CROSS_REFERENCE_TYPE_FOR_FIELD,')){
            msg = msg.substringBetween('INVALID_CROSS_REFERENCE_TYPE_FOR_FIELD,',':'); 
        }
        if(msg.contains('INVALID_CROSS_REFERENCE_KEY,')){
            msg = msg.substringBetween('INVALID_CROSS_REFERENCE_KEY,',':'); 
        }        
        if(msg.contains('NO_APPLICABLE_PROCESS,')){
            msg = 'No Applicable Approval Process';
        }
        if(msg.contains('ALREADY_IN_PROCESS,')){
            msg = 'The record has already been submitted for Approval';
        }
        if(msg.contains('INSUFFICIENT_ACCESS_OR_READONLY,')){
            msg = Label.insufficientPrivilagesErrorForUser;
        }
        if (msg.contains('GNT.CustomExceptions.TriggerException') && msg.contains('CANNOT_INSERT_UPDATE_ACTIVATE_ENTITY,') ) {
            // Extract the custom error message specific to TriggerException
            if(msg.contains('(GNT)')){
              msg = msg.substringBetween('GNT.CustomExceptions.TriggerException: ', '(GNT)');
        }else{
                msg = msg.substringBetween('GNT.CustomExceptions.TriggerException: ', ':');
            }
        }
        if(msg.contains('CANNOT_INSERT_UPDATE_ACTIVATE_ENTITY,')){
            msg = msg.substringBetween('CustomExceptions.TriggerException:','Class'); 
        }
        String parsedMessage = parseExceptionMsg(msg); // Added By Dipak Pawar for User Story 71991: Enhancement - Remove truncation of SF error messages
        parsedMessage = parsedMessage.replace(':[','');
        parsedMessage = parsedMessage.replace('[','');
        parsedMessage = parsedMessage.replace(']','');

        return parsedMessage;
    }

    /*
        Created By : Dipak Pawar
        Description : To parse exception message and log exception to ErrorLog__c object using platform event.
    */

    public static String handleSystemExceptionMsg(Exception objException){
        if(objException != null){
            if(KeyValueHolderHelper.getBooleanValue('EnableLogException') != null && KeyValueHolderHelper.getBooleanValue('EnableLogException')){
                LogExceptionHandler.logException(objException);
            }
            return handleSystemExceptionMsg(objException.getMessage());
        }
        return null;        
    }

    /*
    * Author    : Dipak Pawar
    * Issue No  : User Story 71991: Enhancement - Remove truncation of SF error messages
    * Date      : 22 April 2020
    */
    public static String parseExceptionMsg(string errorMsg){
        String innerMsg = '';
        boolean isTriggerException = false;
        if(!String.isEmpty(errorMsg) && errorMsg.contains('GNT.CustomExceptions.') && errorMsg.contains('Class.GNT.') ){
            isTriggerException = true;
            innerMsg = errorMsg.substringBetween('GNT.CustomExceptions.','Class.GNT.');
        }
        
        if(!String.isEmpty(errorMsg) && errorMsg.contains(':') && !isTriggerException){            
            List<String> parts = new List<String>();
            List<String> subParts = new List<String>();
            innerMsg = errorMsg;
            parts = errorMsg.split(':', 2);
            if(!String.isEmpty(parts[1]) && parts[1].contains(',')){
                if(errorMsg.contains('data value too large') || errorMsg.contains('STRING_TOO_LONG')){//User Story 119466: Entered text should not display in Validation error message
                    if(errorMsg.contains('STRING_TOO_LONG')){
                innerMsg = parts[1];
                subParts = parts[1].split(',',2);
                if(!String.isEmpty(subParts[1])){
                    innerMsg = subParts[1];
                    String partString = subParts[1]; // partString - This is trigger error In Progress.: []
                    String errorMessage = partString.substringBefore(': ['); // errorMessage -  This is trigger error In Progress.
                    if(!String.isEmpty(errorMessage)){
                        innerMsg = errorMessage.trim();
                        if(innerMsg.contains(':')){
                            innerMsg = parseExceptionMsg(innerMsg); // called recursive funtion to parse stack trace of error messages for finding correct error message
                        }
                    }
                }                    
            }                         

                }else{
                    innerMsg = parts[1];
                    subParts = parts[1].split(',',2);
                    if(!String.isEmpty(subParts[1])){
                        innerMsg = subParts[1];
                        String partString = subParts[1]; // partString - This is trigger error In Progress.: []
                        String errorMessage = partString.substringBefore(': ['); // errorMessage -  This is trigger error In Progress.
                        if(!String.isEmpty(errorMessage)){
                            innerMsg = errorMessage.trim();
                            if(innerMsg.contains(':')){
                                innerMsg = parseExceptionMsg(innerMsg); // called recursive funtion to parse stack trace of error messages for finding correct error message
                            }
                        }
                    }         
                }
                
                           
            }                         
        } else {
            innerMsg = errorMsg;
        }
        if(innerMsg == null){
            innerMsg = errorMsg;
        }
        return innerMsg;
    }

    /*
        Method: getUserTimeZoneFormat()
        Purpose: To get Time Zone format of user based on locale value seleceted
    */
    public static String getUserTimeZoneFormat(){
        String userLocale = UserInfo.getLocale();
        if(!localeTimeFmtMap.containsKey(userLocale))  return 'hh:mm a';
        return  localeTimeFmtMap.get(userLocale);
    }

     public static String getUserDateFormatHolder() {
        String  userLocale  = UserInfo.getLocale();
        if(userLocale == 'en_CA')  return 'dd/mm/yyyy';  
         if(userLocale == 'en_US')  return 'mm/dd/yyyy';
        if (!localeToDateTimeFmtMap.containsKey(userLocale))    return 'MM-dd-yyyy';
        return localeToDateTimeFmtMap.get(userLocale).substringBefore(' ');
    }

     public static String getUserDateTimeFormatHolder() {
        String  userLocale  = UserInfo.getLocale();
        if(userLocale == 'en_CA')  return 'dd/mm/yyyy h:mm a';  
        if(userLocale == 'en_US')  return 'mm/dd/yyyy h:mm a';
        if (!localeToDateTimeFmtMap.containsKey(userLocale))    return 'MM-dd-yyyy';
        return localeToDateTimeFmtMap.get(userLocale).substringBefore(' ');
    }
    //  -------------------------------------------------------
    //  getUserDateFormat: e.g. M/d/yyyy
    //  -------------------------------------------------------
    public static String getUserDateFormat() {
        String      userLocale  = UserInfo.getLocale();
        if (!localeToDateTimeFmtMap.containsKey(userLocale))    return 'MM-dd-yyyy';
        return localeToDateTimeFmtMap.get(userLocale).substringBefore(' ');
    }

    //  -------------------------------------------------------
    //  getUserDateTimeFormat: e.g. M/d/yyyy hh.mm.ss
    //  -------------------------------------------------------
    public static String getUserDateTimeFormat() {
        String userLocale  = UserInfo.getLocale();
        if (!localeToDateTimeFmtMap.containsKey(userLocale))    return 'MM-dd-yyyy hh:mm a';
        return localeToDateTimeFmtMap.get(userLocale);
    }

    public static String getLocaleCurrencySymbol(){
        String curryLocale = UserInfo.getDefaultCurrency();
        if(!localeCurrencySymbolMap.containsKey(curryLocale))  return '$';
        return localeCurrencySymbolMap.get(curryLocale);
    }


    public static Map<String,String> getLocaleToDateTimeFmtMap () {
    if (localeToDateTimeFmtMap == null)
        localeToDateTimeFmtMap  = new Map<String,String> {
            'af_ZA' => 'yyyy-MM-dd HH:mm',
            'ar_AE' => 'd/M/yyyy h:mm a',
            'ar_BH' => 'd/M/yyyy h:mm a',
            'ar_DZ' => 'd/M/yyyy h:mm a',
            'ar_EG'=> 'd/M/yyyy h:mm a',
            'ar_IQ'=> 'd/M/yyyy h:mm a',
            'ar_JO'         => 'dd/MM/yyyy hh:mm a',
            'ar_KW'=> 'd/M/yyyy h:mm a',
            'ar_LB'         => 'dd/MM/yyyy hh:mm a',
            'ar_LY'=> 'd/M/yyyy h:mm a',
            'ar_MA'=> 'd/M/yyyy HH:mm',
            'ar_OM'=> 'd/M/yyyy h:mm a',
            'ar_QA'=> 'd/M/yyyy h:mm a',
            'ar_SA'         => 'dd/MM/yyyy hh:mm a',
            'ar_SD'=> 'd/M/yyyy h:mm a',
            'ar_SY'=> 'dd/MM/yyyy hh:mm a',
            'ar_TN'=> 'd/M/yyyy h:mm a',
            'ar_YE'=> 'd/M/yyyy h:mm a',
            'az_AZ'=> 'dd.MM.yyyy HH:mm',
            'be_BY'=> 'd.M.yyyy H.mm',
            'bg_BG'=> 'dd.MM.yyyy HH:mm',
            'bn_BD'=> 'd/M/yyyy h:mm a',
            'bn_IN'=> 'd/M/yyyy h:mm a',
            'bs_BA'=> 'd.M.yyyy. HH:mm',
            'ca_ES'         => 'dd/MM/yyyy HH:mm',
            'ca_ES_EURO'    => 'dd/MM/yyyy HH:mm',
            'cs_CZ'         => 'd.M.yyyy H:mm',
            'cy_GB'=> 'dd/MM/yyyy HH:mm',
            'da_DK'         => 'dd-MM-yyyy HH:mm',
            'de_AT'         => 'dd.MM.yyyy HH:mm',
            'de_AT_EURO'    => 'dd.MM.yyyy HH:mm',
            'de_BE'=> 'dd.MM.yyyy=> HH:mm',
            'de_DE'         => 'dd.MM.yyyy HH:mm',
            'de_DE_EURO'    => 'dd.MM.yyyy HH:mm',
            'de_LU'         => 'dd.MM.yyyy HH:mm',
            'de_LU_EURO'    => 'dd.MM.yyyy HH:mm',
            'de_CH'=> 'dd.MM.yyyy HH:mm',
            'dz_BT'=> 'yyyy-MM-dd ཆུ་ཚོད་ h སྐར་མ་ mm a',
            'el_GR'         => 'd/M/yyyy h:mm a',
            'en_AG'=> 'dd/MM/yyyy=> h:mm a',
            'en_AU'=> 'd/MM/yyyy h:mm a',
            'en_BB'=> 'dd/MM/yyyy HH:mm',
            'en_BS'=> 'dd/MM/yyyy=> h:mm a',
            'en_BZ'=> 'dd/MM/yyyy=> HH:mm',
            'en_BM'=> 'dd/MM/yyyy HH:mm',
            'en_BW'=> 'dd/MM/yyyy=> HH:mm',
            'en_CA'         => 'dd/MM/yyyy h:mm a',
            'en_CM'=> 'dd/MM/yyyy=> HH:mm',
            'en_KY'=> 'dd/MM/yyyy=> h:mm a',
            'en_ER'=> 'dd/MM/yyyy=> h:mm a',
            'en_FK'=> 'dd/MM/yyyy=> HH:mm',
            'en_FJ'=> 'dd/MM/yyyy=> h:mm a',
            'en_GM'=> 'dd/MM/yyyy=> h:mm a',
            'en_GH'=> 'dd/MM/yyyy HH:mm',
            'en_GI'=> 'dd/MM/yyyy=> HH:mm',
            'en_GY'=> 'dd/MM/yyyy=> h:mm a',
            'en_HK'=> 'd/M/yyyy=> h:mm a',
            'en_IN'=> 'd/M/yyyy h:mm a',
            'en_ID'=> 'dd/MM/yyyy HH:mm',
            'en_IE'         => 'dd/MM/yyyy HH:mm',
            'en_IE_EURO'    => 'dd/MM/yyyy HH:mm',
            'en_JM'=> 'dd/MM/yyyy=> h:mm a',
            'en_KE'=> 'dd/MM/yyyy=> HH:mm',
            'en_LR'=> 'dd/MM/yyyy=> h:mm a',
            'en_MG'=> 'dd/MM/yyyy=> HH:mm',
            'en_MW'=> 'dd/MM/yyyy=> h:mm a',
            'en_MY'=> 'dd/MM/yyyy HH:mm',
            'en_MU'=> 'dd/MM/yyyy=> HH:mm',
            'en_NA'=> 'dd/MM/yyyy=> h:mm a',
            'en_NZ'=> 'd/MM/yyyy h:mm a',
            'en_NG'=> 'dd/MM/yyyy HH:mm',
            'en_PK'=> 'dd/MM/yyyy=> h:mm a',
            'en_PG'=> 'dd/MM/yyyy=> h:mm a',
            'en_PH'=> 'M/d/yyyy h:mm a',
            'en_RW'=> 'dd/MM/yyyy=> HH:mm',
            'en_SH'=> 'dd/MM/yyyy=> HH:mm',
            'en_WS'=> 'dd/MM/yyyy=> h:mm a',
            'en_SC'=> 'dd/MM/yyyy=> HH:mm',
            'en_SL'=> 'dd/MM/yyyy=> h:mm a',
            'en_SG'=> 'dd/MM/yyyy HH:mm',
            'en_SX'=> 'dd/MM/yyyy=> HH:mm',
            'en_SB'=> 'dd/MM/yyyy=> h:mm a',
            'en_ZA'=> 'yyyy/MM/dd h:mm a',
            'en_SZ'=> 'dd/MM/yyyy=> h:mm a',
            'en_TZ'=> 'dd/MM/yyyy=> HH:mm',
            'en_TO'=> 'dd/MM/yyyy=> h:mm a',
            'en_TT'=> 'dd/MM/yyyy=> h:mm a',
            'en_UG'=> 'dd/MM/yyyy=> HH:mm',
           'en_GB'=> 'dd/MM/yyyy HH:mm',
            'en_US'         => 'MM/dd/yyyy h:mm a',
            'en_VU'=> 'dd/MM/yyyy=> h:mm a',
            'es_AR'         => 'dd/MM/yyyy HH:mm',
            'es_BO'         => 'dd-MM-yyyy hh:mm a',
            'es_CL'=> 'dd-MM-yyyy H:mm',
            'es_CO'         => 'd/MM/yyyy hh:mm a',
            'es_CR'         => 'dd/MM/yyyy hh:mm a',
            'es_CU'=> 'd/M/yyyy HH:mm',
            'es_DO'=> 'dd/MM/yyyy hh:mm a',
            'es_EC'=> 'dd/MM/yyyy H:mm',
            'es_ES'         => 'd/MM/yyyy H:mm',
            'es_ES_EURO'    => 'd/MM/yyyy H:mm',
            'es_GT'         => 'd/MM/yyyy hh:mm a',
            'es_HN'         => 'MM-dd-yyyy hh:mm a',
            'es_MX'         => 'd/MM/yyyy hh:mm a',
            'es_NI'=> 'MM-dd-yyyy hh:mm a',
            'es_PA'=> 'MM/dd/yyyy hh:mm a',
            'es_PE'         => 'dd/MM/yyyy hh:mm a',
            'es_PR'         => 'MM-dd-yyyy hh:mm a',
            'es_PY'         => 'dd/MM/yyyy hh:mm a',
            'es_SV'         => 'MM-dd-yyyy hh:mm a',
            'es_US'=> 'M/d/yyyy h:mm a',
            'es_VE'         => 'dd/MM/yyyy hh:mm a',
            'et_EE'         => 'd.MM.yyyy H:mm',
            'eu_ES'=> 'yyyy/M/d HH:mm',
            'fa_IR'=> 'yyyy/M/d،\u200f H:mm',
            'fi_FI'         => 'd.M.yyyy H:mm',
            'fi_FI_EURO'    => 'd.M.yyyy H:mm',
            'fr_BE'         => 'd/MM/yyyy H:mm',
            'fr_CA'         => 'yyyy-MM-dd HH:mm',
            'fr_KM'=> 'dd/MM/yyyy HH:mm',
            'fr_FR'         => 'dd/MM/yyyy HH:mm',
            'fr_FR_EURO'    => 'dd/MM/yyyy HH:mm',
            'fr_GN'=> 'dd/MM/yyyy HH:mm',
            'fr_HT'=> 'dd/MM/yyyy HH:mm',
            'fr_LU'         => 'dd/MM/yyyy HH:mm',
            'fr_MR'=> 'dd/MM/yyyy h:mm a',
            'fr_MC'         => 'dd/MM/yyyy HH:mm',
            'fr_CH'=> 'dd.MM.yyyy HH:mm',
            'fr_WF'=> 'dd/MM/yyyy HH:mm',
            'ga_IE'=> 'dd/MM/yyyy HH:mm',
            'gu_IN'=> 'd/M/yyyy hh:mm a',
            'hi_IN'=> 'd/M/yyyy h:mm a',
            'hr_HR'=> 'dd.MM.yyyy. HH:mm',
            'hu_HU'=> 'yyyy.MM.dd. H:mm',
            'hy_AM'=> 'dd.MM.yyyy=> HH:mm',
            'in_ID'=> 'dd/MM/yyyy H:mm',
            'is_IS'         => 'd.M.yyyy HH:mm',
            'it_CH'         => 'dd.MM.yyyy HH:mm',
            'it_IT'         => 'dd/MM/yyyy H.mm',
            'iw_IL'         => 'HH:mm dd/MM/yyyy',
            'ja_JP'         => 'yyyy/MM/dd H:mm',
            'ka_GE'=> 'dd.MM.yyyy=> HH:mm',
            'kk_KZ'=> 'dd.MM.yyyy=> HH:mm',
            'km_KH'=> 'd/M/yyyy=> h:mm a',
            'kn_IN'=> 'd/M/yyyy hh:mm a',
            'ko_KP'=> 'yyyy. M. d. a h:mm',
            'ko_KR'         => 'yyyy. M. d a h:mm',
            'ky_KG'=> 'd/M/yyyy HH:mm',
            'lb_LU'=> 'dd.MM.yyyy HH:mm',
            'lo_LA'=> 'd/M/yyyy=> H:mm',
            'lt_LT'         => 'yyyy.M.d HH.mm',
            'lu_CD'=> 'd/M/yyyy HH:mm',
            'lv_LV'=> 'dd.MM.yyyy HH:mm',
            'mk_MK'=> 'd.M.yyyy HH:mm',
            'ml_IN'=> 'd/M/yyyy h:mm a',
            'mr_IN'=> 'd/M/yyyy=> h:mm a',
            'ms_BN'=> 'd/MM/yyyy=> h:mm a',
            'ms_MY'         => 'dd/MM/yyyy h:mm a',
            'mt_MT'=> 'dd/MM/yyyy HH:mm',
            'my_MM'=> 'dd-MM-yyyy B H:mm',
            'ne_NP'=> 'yyyy/M/d=> HH:mm',
            'nl_AW'=> 'dd-MM-yyyy HH:mm',
            'nl_BE'         => 'd/MM/yyyy H:mm',
            'nl_NL'         => 'd-M-yyyy H:mm',
            'nl_SR'=> 'dd-MM-yyyy HH:mm',
            'no_NO'         => 'dd.MM.yyyy HH:mm',
            'pl_PL'=> 'dd.MM.yyyy HH:mm',
            'ps_AF'=> 'GGGGG yyyy/M/d H:mm',
            'pt_AO'=> 'dd/MM/yyyy=> HH:mm',
            'pt_BR'         => 'dd/MM/yyyy HH:mm',
            'pt_CV'=> 'dd/MM/yyyy=> HH:mm',
            'pt_MZ'=> 'dd/MM/yyyy=> HH:mm',
            'pt_PT'         => 'dd-MM-yyyy H:mm',
            'pt_ST'=> 'dd/MM/yyyy=> HH:mm',
            'rm_CH'=> 'dd-MM-yyyy HH:mm',
            'rn_BI'=> 'd/M/yyyy HH:mm',
            'ro_MD'=> 'dd.MM.yyyy=> HH:mm',
            'ro_RO'         => 'dd.MM.yyyy HH:mm',
            'ru_KZ'=> 'dd.MM.yyyy=> H:mm',
            'ru_RU'=> 'dd.MM.yyyy H:mm',
            'sh_BA'=> 'dd.MM.yyyy. HH:mm',
            'sh_CS'=> 'dd.MM.yyyy. HH:mm',
            'sh_ME'=> 'dd.MM.yyyy. HH:mm',
            'sk_SK'         => 'd.M.yyyy H:mm',
            'sl_SI'=> 'd.M.yyyy H:mm',
            'so_DJ'=> 'dd/MM/yyyy h:mm a',
            'so_SO'=> 'dd/MM/yyyy h:mm a',
            'sr_BA'=> 'yyyy-MM-dd HH:mm',
            'sr_CS'=> 'd.M.yyyy. HH.mm',
            'sr_RS'=> 'd.M.yyyy. HH.mm',
            'sq_AL'=> 'yyyy-MM-dd h.mm.a',
            'sv_SE'         => 'yyyy-MM-dd HH:mm',
            'sw_KE'=> 'dd/MM/yyyy=> HH:mm',
            'ta_IN'=> 'd/M/yyyy=> a h:mm',
            'ta_LK'=> 'd/M/yyyy=> HH:mm',
            'te_IN'=> 'dd-MM-yyyy h:mm a',
            'tg_TJ'=> 'dd/MM/yyyy HH:mm',
            'th_TH'=> 'd/M/yyyy=> H:mm น.',
            'ti_ET'=> 'dd/MM/yyyy h:mm a',
            'tl_PH'=> 'M/d/yyyy h:mm a',
            'tr_TR'=> 'dd.MM.yyyy HH:mm',
            'uk_UA'=> 'dd.MM.yyyy H:mm',
            'ur_PK'=> 'd/M/yyyy h:mm a',
            'uz_LATN_UZ'=> 'dd/MM/yyyy=> HH:mm',
            'vi_VN'         => 'HH:mm dd/MM/yyyy',
            'yo_BJ'=> 'dd/MM/yyyy HH:mm',
            'xh_ZA'=> 'M/d/yyyy h:mm a',
            'zh_CN'         => 'yyyy-M-d ah:mm',
            'zh_CN_PINYIN'=> 'yyyy/M/d ah:mm',
            'zh_CN_STROKE'=> 'yyyy/M/d ah:mm',
            'zh_HK'=> 'yyyy年M月d日 ah:mm',
            'zh_HK_STROKE'=> 'd/M/yyyy ah:mm',
            'zh_MO'=> 'd/M/yyyy ah:mm',
            'zh_SG'=> 'dd/MM/yyyy a hh:mm',
            'zh_TW'=> 'yyyy/M/d a h:mm',
            'zh_TW_STROKE'=> 'yyyy/M/d ah:mm',
            'zu_ZA'=> 'M/d/yyyy HH:mm'
        };
        return localeToDateTimeFmtMap;
}
    public static Map<String,String> getLocaleToDateTimeFmtMap11 () {
    
        localeToDateTimeFmtMap  = new Map<String,String> {
            'af_ZA' => 'yyyy-MM-dd HH:mm',
            'ar_AE' => 'd/M/yyyy h:mm a',
            'ar_BH' => 'd/M/yyyy h:mm a',
            'ar_DZ' => 'd/M/yyyy h:mm a',
            'ar_EG'=> 'd/M/yyyy h:mm a',
            'ar_IQ'=> 'd/M/yyyy h:mm a',
            'ar_JO'         => 'dd/MM/yyyy hh:mm a',
            'ar_KW'=> 'd/M/yyyy h:mm a',
            'ar_LB'         => 'dd/MM/yyyy hh:mm a',
            'ar_LY'=> 'd/M/yyyy h:mm a',
            'ar_MA'=> 'd/M/yyyy HH:mm',
            'ar_OM'=> 'd/M/yyyy h:mm a',
            'ar_QA'=> 'd/M/yyyy h:mm a',
            'ar_SA'         => 'dd/MM/yyyy hh:mm a',
            'ar_SD'=> 'd/M/yyyy h:mm a',
            'ar_SY'=> 'dd/MM/yyyy hh:mm a',
            'ar_TN'=> 'd/M/yyyy h:mm a',
            'ar_YE'=> 'd/M/yyyy h:mm a',
            'az_AZ'=> 'dd.MM.yyyy HH:mm',
            'be_BY'=> 'd.M.yyyy H.mm',
            'bg_BG'=> 'dd.MM.yyyy HH:mm',
            'bn_BD'=> 'd/M/yyyy h:mm a',
            'bn_IN'=> 'd/M/yyyy h:mm a',
            'bs_BA'=> 'd.M.yyyy. HH:mm',
            'ca_ES'         => 'dd/MM/yyyy HH:mm',
            'ca_ES_EURO'    => 'dd/MM/yyyy HH:mm',
            'cs_CZ'         => 'd.M.yyyy H:mm',
            'cy_GB'=> 'dd/MM/yyyy HH:mm',
            'da_DK'         => 'dd-MM-yyyy HH:mm',
            'de_AT'         => 'dd.MM.yyyy HH:mm',
            'de_AT_EURO'    => 'dd.MM.yyyy HH:mm',
            'de_BE'=> 'dd.MM.yyyy=> HH:mm',
            'de_DE'         => 'dd.MM.yyyy HH:mm',
            'de_DE_EURO'    => 'dd.MM.yyyy HH:mm',
            'de_LU'         => 'dd.MM.yyyy HH:mm',
            'de_LU_EURO'    => 'dd.MM.yyyy HH:mm',
            'de_CH'=> 'dd.MM.yyyy HH:mm',
            'dz_BT'=> 'yyyy-MM-dd ཆུ་ཚོད་ h སྐར་མ་ mm a',
            'el_GR'         => 'd/M/yyyy h:mm a',
            'en_AG'=> 'dd/MM/yyyy=> h:mm a',
            'en_AU'=> 'd/MM/yyyy h:mm a',
            'en_BB'=> 'dd/MM/yyyy HH:mm',
            'en_BS'=> 'dd/MM/yyyy=> h:mm a',
            'en_BZ'=> 'dd/MM/yyyy=> HH:mm',
            'en_BM'=> 'dd/MM/yyyy HH:mm',
            'en_BW'=> 'dd/MM/yyyy=> HH:mm',
            'en_CA'         => 'dd/MM/yyyy h:mm a',
            'en_CM'=> 'dd/MM/yyyy=> HH:mm',
            'en_KY'=> 'dd/MM/yyyy=> h:mm a',
            'en_ER'=> 'dd/MM/yyyy=> h:mm a',
            'en_FK'=> 'dd/MM/yyyy=> HH:mm',
            'en_FJ'=> 'dd/MM/yyyy=> h:mm a',
            'en_GM'=> 'dd/MM/yyyy=> h:mm a',
            'en_GH'=> 'dd/MM/yyyy HH:mm',
            'en_GI'=> 'dd/MM/yyyy=> HH:mm',
            'en_GY'=> 'dd/MM/yyyy=> h:mm a',
            'en_HK'=> 'd/M/yyyy=> h:mm a',
            'en_IN'=> 'd/M/yyyy h:mm a',
            'en_ID'=> 'dd/MM/yyyy HH:mm',
            'en_IE'         => 'dd/MM/yyyy HH:mm',
            'en_IE_EURO'    => 'dd/MM/yyyy HH:mm',
            'en_JM'=> 'dd/MM/yyyy=> h:mm a',
            'en_KE'=> 'dd/MM/yyyy=> HH:mm',
            'en_LR'=> 'dd/MM/yyyy=> h:mm a',
            'en_MG'=> 'dd/MM/yyyy=> HH:mm',
            'en_MW'=> 'dd/MM/yyyy=> h:mm a',
            'en_MY'=> 'dd/MM/yyyy HH:mm',
            'en_MU'=> 'dd/MM/yyyy=> HH:mm',
            'en_NA'=> 'dd/MM/yyyy=> h:mm a',
            'en_NZ'=> 'd/MM/yyyy h:mm a',
            'en_NG'=> 'dd/MM/yyyy HH:mm',
            'en_PK'=> 'dd/MM/yyyy=> h:mm a',
            'en_PG'=> 'dd/MM/yyyy=> h:mm a',
            'en_PH'=> 'M/d/yyyy h:mm a',
            'en_RW'=> 'dd/MM/yyyy=> HH:mm',
            'en_SH'=> 'dd/MM/yyyy=> HH:mm',
            'en_WS'=> 'dd/MM/yyyy=> h:mm a',
            'en_SC'=> 'dd/MM/yyyy=> HH:mm',
            'en_SL'=> 'dd/MM/yyyy=> h:mm a',
            'en_SG'=> 'dd/MM/yyyy HH:mm',
            'en_SX'=> 'dd/MM/yyyy=> HH:mm',
            'en_SB'=> 'dd/MM/yyyy=> h:mm a',
            'en_ZA'=> 'yyyy/MM/dd h:mm a',
            'en_SZ'=> 'dd/MM/yyyy=> h:mm a',
            'en_TZ'=> 'dd/MM/yyyy=> HH:mm',
            'en_TO'=> 'dd/MM/yyyy=> h:mm a',
            'en_TT'=> 'dd/MM/yyyy=> h:mm a',
            'en_UG'=> 'dd/MM/yyyy=> HH:mm',
           'en_GB'=> 'dd/MM/yyyy HH:mm',
            'en_US'         => 'MM/dd/yyyy h:mm a',
            'en_VU'=> 'dd/MM/yyyy=> h:mm a',
            'es_AR'         => 'dd/MM/yyyy HH:mm',
            'es_BO'         => 'dd-MM-yyyy hh:mm a',
            'es_CL'=> 'dd-MM-yyyy H:mm',
            'es_CO'         => 'd/MM/yyyy hh:mm a',
            'es_CR'         => 'dd/MM/yyyy hh:mm a',
            'es_CU'=> 'd/M/yyyy HH:mm',
            'es_DO'=> 'dd/MM/yyyy hh:mm a',
            'es_EC'=> 'dd/MM/yyyy H:mm',
            'es_ES'         => 'd/MM/yyyy H:mm',
            'es_ES_EURO'    => 'd/MM/yyyy H:mm',
            'es_GT'         => 'd/MM/yyyy hh:mm a',
            'es_HN'         => 'MM-dd-yyyy hh:mm a',
            'es_MX'         => 'd/MM/yyyy hh:mm a',
            'es_NI'=> 'MM-dd-yyyy hh:mm a',
            'es_PA'=> 'MM/dd/yyyy hh:mm a',
            'es_PE'         => 'dd/MM/yyyy hh:mm a',
            'es_PR'         => 'MM-dd-yyyy hh:mm a',
            'es_PY'         => 'dd/MM/yyyy hh:mm a',
            'es_SV'         => 'MM-dd-yyyy hh:mm a',
            'es_US'=> 'M/d/yyyy h:mm a',
            'es_VE'         => 'dd/MM/yyyy hh:mm a',
            'et_EE'         => 'd.MM.yyyy H:mm',
            'eu_ES'=> 'yyyy/M/d HH:mm',
            'fa_IR'=> 'yyyy/M/d،\u200f H:mm',
            'fi_FI'         => 'd.M.yyyy H:mm',
            'fi_FI_EURO'    => 'd.M.yyyy H:mm',
            'fr_BE'         => 'd/MM/yyyy H:mm',
            'fr_CA'         => 'yyyy-MM-dd HH:mm',
            'fr_KM'=> 'dd/MM/yyyy HH:mm',
            'fr_FR'         => 'dd/MM/yyyy HH:mm',
            'fr_FR_EURO'    => 'dd/MM/yyyy HH:mm',
            'fr_GN'=> 'dd/MM/yyyy HH:mm',
            'fr_HT'=> 'dd/MM/yyyy HH:mm',
            'fr_LU'         => 'dd/MM/yyyy HH:mm',
            'fr_MR'=> 'dd/MM/yyyy h:mm a',
            'fr_MC'         => 'dd/MM/yyyy HH:mm',
            'fr_CH'=> 'dd.MM.yyyy HH:mm',
            'fr_WF'=> 'dd/MM/yyyy HH:mm',
            'ga_IE'=> 'dd/MM/yyyy HH:mm',
            'gu_IN'=> 'd/M/yyyy hh:mm a',
            'hi_IN'=> 'd/M/yyyy h:mm a',
            'hr_HR'=> 'dd.MM.yyyy. HH:mm',
            'hu_HU'=> 'yyyy.MM.dd. H:mm',
            'hy_AM'=> 'dd.MM.yyyy=> HH:mm',
            'in_ID'=> 'dd/MM/yyyy H:mm',
            'is_IS'         => 'd.M.yyyy HH:mm',
            'it_CH'         => 'dd.MM.yyyy HH:mm',
            'it_IT'         => 'dd/MM/yyyy H.mm',
            'iw_IL'         => 'HH:mm dd/MM/yyyy',
            'ja_JP'         => 'yyyy/MM/dd H:mm',
            'ka_GE'=> 'dd.MM.yyyy=> HH:mm',
            'kk_KZ'=> 'dd.MM.yyyy=> HH:mm',
            'km_KH'=> 'd/M/yyyy=> h:mm a',
            'kn_IN'=> 'd/M/yyyy hh:mm a',
            'ko_KP'=> 'yyyy. M. d. a h:mm',
            'ko_KR'         => 'yyyy. M. d a h:mm',
            'ky_KG'=> 'd/M/yyyy HH:mm',
            'lb_LU'=> 'dd.MM.yyyy HH:mm',
            'lo_LA'=> 'd/M/yyyy=> H:mm',
            'lt_LT'         => 'yyyy.M.d HH.mm',
            'lu_CD'=> 'd/M/yyyy HH:mm',
            'lv_LV'=> 'dd.MM.yyyy HH:mm',
            'mk_MK'=> 'd.M.yyyy HH:mm',
            'ml_IN'=> 'd/M/yyyy h:mm a',
            'mr_IN'=> 'd/M/yyyy=> h:mm a',
            'ms_BN'=> 'd/MM/yyyy=> h:mm a',
            'ms_MY'         => 'dd/MM/yyyy h:mm a',
            'mt_MT'=> 'dd/MM/yyyy HH:mm',
            'my_MM'=> 'dd-MM-yyyy B H:mm',
            'ne_NP'=> 'yyyy/M/d=> HH:mm',
            'nl_AW'=> 'dd-MM-yyyy HH:mm',
            'nl_BE'         => 'd/MM/yyyy H:mm',
            'nl_NL'         => 'd-M-yyyy H:mm',
            'nl_SR'=> 'dd-MM-yyyy HH:mm',
            'no_NO'         => 'dd.MM.yyyy HH:mm',
            'pl_PL'=> 'dd.MM.yyyy HH:mm',
            'ps_AF'=> 'GGGGG yyyy/M/d H:mm',
            'pt_AO'=> 'dd/MM/yyyy=> HH:mm',
            'pt_BR'         => 'dd/MM/yyyy HH:mm',
            'pt_CV'=> 'dd/MM/yyyy=> HH:mm',
            'pt_MZ'=> 'dd/MM/yyyy=> HH:mm',
            'pt_PT'         => 'dd-MM-yyyy H:mm',
            'pt_ST'=> 'dd/MM/yyyy=> HH:mm',
            'rm_CH'=> 'dd-MM-yyyy HH:mm',
            'rn_BI'=> 'd/M/yyyy HH:mm',
            'ro_MD'=> 'dd.MM.yyyy=> HH:mm',
            'ro_RO'         => 'dd.MM.yyyy HH:mm',
            'ru_KZ'=> 'dd.MM.yyyy=> H:mm',
            'ru_RU'=> 'dd.MM.yyyy H:mm',
            'sh_BA'=> 'dd.MM.yyyy. HH:mm',
            'sh_CS'=> 'dd.MM.yyyy. HH:mm',
            'sh_ME'=> 'dd.MM.yyyy. HH:mm',
            'sk_SK'         => 'd.M.yyyy H:mm',
            'sl_SI'=> 'd.M.yyyy H:mm',
            'so_DJ'=> 'dd/MM/yyyy h:mm a',
            'so_SO'=> 'dd/MM/yyyy h:mm a',
            'sr_BA'=> 'yyyy-MM-dd HH:mm',
            'sr_CS'=> 'd.M.yyyy. HH.mm',
            'sr_RS'=> 'd.M.yyyy. HH.mm',
            'sq_AL'=> 'yyyy-MM-dd h.mm.a',
            'sv_SE'         => 'yyyy-MM-dd HH:mm',
            'sw_KE'=> 'dd/MM/yyyy=> HH:mm',
            'ta_IN'=> 'd/M/yyyy=> a h:mm',
            'ta_LK'=> 'd/M/yyyy=> HH:mm',
            'te_IN'=> 'dd-MM-yyyy h:mm a',
            'tg_TJ'=> 'dd/MM/yyyy HH:mm',
            'th_TH'=> 'd/M/yyyy=> H:mm น.',
            'ti_ET'=> 'dd/MM/yyyy h:mm a',
            'tl_PH'=> 'M/d/yyyy h:mm a',
            'tr_TR'=> 'dd.MM.yyyy HH:mm',
            'uk_UA'=> 'dd.MM.yyyy H:mm',
            'ur_PK'=> 'd/M/yyyy h:mm a',
            'uz_LATN_UZ'=> 'dd/MM/yyyy=> HH:mm',
            'vi_VN'         => 'HH:mm dd/MM/yyyy',
            'yo_BJ'=> 'dd/MM/yyyy HH:mm',
            'xh_ZA'=> 'M/d/yyyy h:mm a',
            'zh_CN'         => 'yyyy-M-d ah:mm',
            'zh_CN_PINYIN'=> 'yyyy/M/d ah:mm',
            'zh_CN_STROKE'=> 'yyyy/M/d ah:mm',
            'zh_HK'=> 'yyyy年M月d日 ah:mm',
            'zh_HK_STROKE'=> 'd/M/yyyy ah:mm',
            'zh_MO'=> 'd/M/yyyy ah:mm',
            'zh_SG'=> 'dd/MM/yyyy a hh:mm',
            'zh_TW'=> 'yyyy/M/d a h:mm',
            'zh_TW_STROKE'=> 'yyyy/M/d ah:mm',
            'zu_ZA'=> 'M/d/yyyy HH:mm'
    };
    return localeCurrencySymbolMap;

}
public static Map<String,String> getLocaleToDateTimeFmtMap1 () {
   
        localeToDateTimeFmtMap  = new Map<String,String> {
            'af_ZA' => 'yyyy-MM-dd HH:mm',
            'ar_AE' => 'd/M/yyyy h:mm a',
            'ar_BH' => 'd/M/yyyy h:mm a',
            'ar_DZ' => 'd/M/yyyy h:mm a',
            'ar_EG'=> 'd/M/yyyy h:mm a',
            'ar_IQ'=> 'd/M/yyyy h:mm a',
            'ar_JO'         => 'dd/MM/yyyy hh:mm a',
            'ar_KW'=> 'd/M/yyyy h:mm a',
            'ar_LB'         => 'dd/MM/yyyy hh:mm a',
            'ar_LY'=> 'd/M/yyyy h:mm a',
            'ar_MA'=> 'd/M/yyyy HH:mm',
            'ar_OM'=> 'd/M/yyyy h:mm a',
            'ar_QA'=> 'd/M/yyyy h:mm a',
            'ar_SA'         => 'dd/MM/yyyy hh:mm a',
            'ar_SD'=> 'd/M/yyyy h:mm a',
            'ar_SY'=> 'dd/MM/yyyy hh:mm a',
            'ar_TN'=> 'd/M/yyyy h:mm a',
            'ar_YE'=> 'd/M/yyyy h:mm a',
            'az_AZ'=> 'dd.MM.yyyy HH:mm',
            'be_BY'=> 'd.M.yyyy H.mm',
            'bg_BG'=> 'dd.MM.yyyy HH:mm',
            'bn_BD'=> 'd/M/yyyy h:mm a',
            'bn_IN'=> 'd/M/yyyy h:mm a',
            'bs_BA'=> 'd.M.yyyy. HH:mm',
            'ca_ES'         => 'dd/MM/yyyy HH:mm',
            'ca_ES_EURO'    => 'dd/MM/yyyy HH:mm',
            'cs_CZ'         => 'd.M.yyyy H:mm',
            'cy_GB'=> 'dd/MM/yyyy HH:mm',
            'da_DK'         => 'dd-MM-yyyy HH:mm',
            'de_AT'         => 'dd.MM.yyyy HH:mm',
            'de_AT_EURO'    => 'dd.MM.yyyy HH:mm',
            'de_BE'=> 'dd.MM.yyyy=> HH:mm',
            'de_DE'         => 'dd.MM.yyyy HH:mm',
            'de_DE_EURO'    => 'dd.MM.yyyy HH:mm',
            'de_LU'         => 'dd.MM.yyyy HH:mm',
            'de_LU_EURO'    => 'dd.MM.yyyy HH:mm',
            'de_CH'=> 'dd.MM.yyyy HH:mm',
            'dz_BT'=> 'yyyy-MM-dd ཆུ་ཚོད་ h སྐར་མ་ mm a',
            'el_GR'         => 'd/M/yyyy h:mm a',
            'en_AG'=> 'dd/MM/yyyy=> h:mm a',
            'en_AU'=> 'd/MM/yyyy h:mm a',
            'en_BB'=> 'dd/MM/yyyy HH:mm',
            'en_BS'=> 'dd/MM/yyyy=> h:mm a',
            'en_BZ'=> 'dd/MM/yyyy=> HH:mm',
            'en_BM'=> 'dd/MM/yyyy HH:mm',
            'en_BW'=> 'dd/MM/yyyy=> HH:mm',
            'en_CA'         => 'dd/MM/yyyy h:mm a',
            'en_CM'=> 'dd/MM/yyyy=> HH:mm',
            'en_KY'=> 'dd/MM/yyyy=> h:mm a',
            'en_ER'=> 'dd/MM/yyyy=> h:mm a',
            'en_FK'=> 'dd/MM/yyyy=> HH:mm',
            'en_FJ'=> 'dd/MM/yyyy=> h:mm a',
            'en_GM'=> 'dd/MM/yyyy=> h:mm a',
            'en_GH'=> 'dd/MM/yyyy HH:mm',
            'en_GI'=> 'dd/MM/yyyy=> HH:mm',
            'en_GY'=> 'dd/MM/yyyy=> h:mm a',
            'en_HK'=> 'd/M/yyyy=> h:mm a',
            'en_IN'=> 'd/M/yyyy h:mm a',
            'en_ID'=> 'dd/MM/yyyy HH:mm',
            'en_IE'         => 'dd/MM/yyyy HH:mm',
            'en_IE_EURO'    => 'dd/MM/yyyy HH:mm',
            'en_JM'=> 'dd/MM/yyyy=> h:mm a',
            'en_KE'=> 'dd/MM/yyyy=> HH:mm',
            'en_LR'=> 'dd/MM/yyyy=> h:mm a',
            'en_MG'=> 'dd/MM/yyyy=> HH:mm',
            'en_MW'=> 'dd/MM/yyyy=> h:mm a',
            'en_MY'=> 'dd/MM/yyyy HH:mm',
            'en_MU'=> 'dd/MM/yyyy=> HH:mm',
            'en_NA'=> 'dd/MM/yyyy=> h:mm a',
            'en_NZ'=> 'd/MM/yyyy h:mm a',
            'en_NG'=> 'dd/MM/yyyy HH:mm',
            'en_PK'=> 'dd/MM/yyyy=> h:mm a',
            'en_PG'=> 'dd/MM/yyyy=> h:mm a',
            'en_PH'=> 'M/d/yyyy h:mm a',
            'en_RW'=> 'dd/MM/yyyy=> HH:mm',
            'en_SH'=> 'dd/MM/yyyy=> HH:mm',
            'en_WS'=> 'dd/MM/yyyy=> h:mm a',
            'en_SC'=> 'dd/MM/yyyy=> HH:mm',
            'en_SL'=> 'dd/MM/yyyy=> h:mm a',
            'en_SG'=> 'dd/MM/yyyy HH:mm',
            'en_SX'=> 'dd/MM/yyyy=> HH:mm',
            'en_SB'=> 'dd/MM/yyyy=> h:mm a',
            'en_ZA'=> 'yyyy/MM/dd h:mm a',
            'en_SZ'=> 'dd/MM/yyyy=> h:mm a',
            'en_TZ'=> 'dd/MM/yyyy=> HH:mm',
            'en_TO'=> 'dd/MM/yyyy=> h:mm a',
            'en_TT'=> 'dd/MM/yyyy=> h:mm a',
            'en_UG'=> 'dd/MM/yyyy=> HH:mm',
           'en_GB'=> 'dd/MM/yyyy HH:mm',
            'en_US'         => 'MM/dd/yyyy h:mm a',
            'en_VU'=> 'dd/MM/yyyy=> h:mm a',
            'es_AR'         => 'dd/MM/yyyy HH:mm',
            'es_BO'         => 'dd-MM-yyyy hh:mm a',
            'es_CL'=> 'dd-MM-yyyy H:mm',
            'es_CO'         => 'd/MM/yyyy hh:mm a',
            'es_CR'         => 'dd/MM/yyyy hh:mm a',
            'es_CU'=> 'd/M/yyyy HH:mm',
            'es_DO'=> 'dd/MM/yyyy hh:mm a',
            'es_EC'=> 'dd/MM/yyyy H:mm',
            'es_ES'         => 'd/MM/yyyy H:mm',
            'es_ES_EURO'    => 'd/MM/yyyy H:mm',
            'es_GT'         => 'd/MM/yyyy hh:mm a',
            'es_HN'         => 'MM-dd-yyyy hh:mm a',
            'es_MX'         => 'd/MM/yyyy hh:mm a',
            'es_NI'=> 'MM-dd-yyyy hh:mm a',
            'es_PA'=> 'MM/dd/yyyy hh:mm a',
            'es_PE'         => 'dd/MM/yyyy hh:mm a',
            'es_PR'         => 'MM-dd-yyyy hh:mm a',
            'es_PY'         => 'dd/MM/yyyy hh:mm a',
            'es_SV'         => 'MM-dd-yyyy hh:mm a',
            'es_US'=> 'M/d/yyyy h:mm a',
            'es_VE'         => 'dd/MM/yyyy hh:mm a',
            'et_EE'         => 'd.MM.yyyy H:mm',
            'eu_ES'=> 'yyyy/M/d HH:mm',
            'fa_IR'=> 'yyyy/M/d،\u200f H:mm',
            'fi_FI'         => 'd.M.yyyy H:mm',
            'fi_FI_EURO'    => 'd.M.yyyy H:mm',
            'fr_BE'         => 'd/MM/yyyy H:mm',
            'fr_CA'         => 'yyyy-MM-dd HH:mm',
            'fr_KM'=> 'dd/MM/yyyy HH:mm',
            'fr_FR'         => 'dd/MM/yyyy HH:mm',
            'fr_FR_EURO'    => 'dd/MM/yyyy HH:mm',
            'fr_GN'=> 'dd/MM/yyyy HH:mm',
            'fr_HT'=> 'dd/MM/yyyy HH:mm',
            'fr_LU'         => 'dd/MM/yyyy HH:mm',
            'fr_MR'=> 'dd/MM/yyyy h:mm a',
            'fr_MC'         => 'dd/MM/yyyy HH:mm',
            'fr_CH'=> 'dd.MM.yyyy HH:mm',
            'fr_WF'=> 'dd/MM/yyyy HH:mm',
            'ga_IE'=> 'dd/MM/yyyy HH:mm',
            'gu_IN'=> 'd/M/yyyy hh:mm a',
            'hi_IN'=> 'd/M/yyyy h:mm a',
            'hr_HR'=> 'dd.MM.yyyy. HH:mm',
            'hu_HU'=> 'yyyy.MM.dd. H:mm',
            'hy_AM'=> 'dd.MM.yyyy=> HH:mm',
            'in_ID'=> 'dd/MM/yyyy H:mm',
            'is_IS'         => 'd.M.yyyy HH:mm',
            'it_CH'         => 'dd.MM.yyyy HH:mm',
            'it_IT'         => 'dd/MM/yyyy H.mm',
            'iw_IL'         => 'HH:mm dd/MM/yyyy',
            'ja_JP'         => 'yyyy/MM/dd H:mm',
            'ka_GE'=> 'dd.MM.yyyy=> HH:mm',
            'kk_KZ'=> 'dd.MM.yyyy=> HH:mm',
            'km_KH'=> 'd/M/yyyy=> h:mm a',
            'kn_IN'=> 'd/M/yyyy hh:mm a',
            'ko_KP'=> 'yyyy. M. d. a h:mm',
            'ko_KR'         => 'yyyy. M. d a h:mm',
            'ky_KG'=> 'd/M/yyyy HH:mm',
            'lb_LU'=> 'dd.MM.yyyy HH:mm',
            'lo_LA'=> 'd/M/yyyy=> H:mm',
            'lt_LT'         => 'yyyy.M.d HH.mm',
            'lu_CD'=> 'd/M/yyyy HH:mm',
            'lv_LV'=> 'dd.MM.yyyy HH:mm',
            'mk_MK'=> 'd.M.yyyy HH:mm',
            'ml_IN'=> 'd/M/yyyy h:mm a',
            'mr_IN'=> 'd/M/yyyy=> h:mm a',
            'ms_BN'=> 'd/MM/yyyy=> h:mm a',
            'ms_MY'         => 'dd/MM/yyyy h:mm a',
            'mt_MT'=> 'dd/MM/yyyy HH:mm',
            'my_MM'=> 'dd-MM-yyyy B H:mm',
            'ne_NP'=> 'yyyy/M/d=> HH:mm',
            'nl_AW'=> 'dd-MM-yyyy HH:mm',
            'nl_BE'         => 'd/MM/yyyy H:mm',
            'nl_NL'         => 'd-M-yyyy H:mm',
            'nl_SR'=> 'dd-MM-yyyy HH:mm',
            'no_NO'         => 'dd.MM.yyyy HH:mm',
            'pl_PL'=> 'dd.MM.yyyy HH:mm',
            'ps_AF'=> 'GGGGG yyyy/M/d H:mm',
            'pt_AO'=> 'dd/MM/yyyy=> HH:mm',
            'pt_BR'         => 'dd/MM/yyyy HH:mm',
            'pt_CV'=> 'dd/MM/yyyy=> HH:mm',
            'pt_MZ'=> 'dd/MM/yyyy=> HH:mm',
            'pt_PT'         => 'dd-MM-yyyy H:mm',
            'pt_ST'=> 'dd/MM/yyyy=> HH:mm',
            'rm_CH'=> 'dd-MM-yyyy HH:mm',
            'rn_BI'=> 'd/M/yyyy HH:mm',
            'ro_MD'=> 'dd.MM.yyyy=> HH:mm',
            'ro_RO'         => 'dd.MM.yyyy HH:mm',
            'ru_KZ'=> 'dd.MM.yyyy=> H:mm',
            'ru_RU'=> 'dd.MM.yyyy H:mm',
            'sh_BA'=> 'dd.MM.yyyy. HH:mm',
            'sh_CS'=> 'dd.MM.yyyy. HH:mm',
            'sh_ME'=> 'dd.MM.yyyy. HH:mm',
            'sk_SK'         => 'd.M.yyyy H:mm',
            'sl_SI'=> 'd.M.yyyy H:mm',
            'so_DJ'=> 'dd/MM/yyyy h:mm a',
            'so_SO'=> 'dd/MM/yyyy h:mm a',
            'sr_BA'=> 'yyyy-MM-dd HH:mm',
            'sr_CS'=> 'd.M.yyyy. HH.mm',
            'sr_RS'=> 'd.M.yyyy. HH.mm',
            'sq_AL'=> 'yyyy-MM-dd h.mm.a',
            'sv_SE'         => 'yyyy-MM-dd HH:mm',
            'sw_KE'=> 'dd/MM/yyyy=> HH:mm',
            'ta_IN'=> 'd/M/yyyy=> a h:mm',
            'ta_LK'=> 'd/M/yyyy=> HH:mm',
            'te_IN'=> 'dd-MM-yyyy h:mm a',
            'tg_TJ'=> 'dd/MM/yyyy HH:mm',
            'th_TH'=> 'd/M/yyyy=> H:mm น.',
            'ti_ET'=> 'dd/MM/yyyy h:mm a',
            'tl_PH'=> 'M/d/yyyy h:mm a',
            'tr_TR'=> 'dd.MM.yyyy HH:mm',
            'uk_UA'=> 'dd.MM.yyyy H:mm',
            'ur_PK'=> 'd/M/yyyy h:mm a',
            'uz_LATN_UZ'=> 'dd/MM/yyyy=> HH:mm',
            'vi_VN'         => 'HH:mm dd/MM/yyyy',
            'yo_BJ'=> 'dd/MM/yyyy HH:mm',
            'xh_ZA'=> 'M/d/yyyy h:mm a',
            'zh_CN'         => 'yyyy-M-d ah:mm',
            'zh_CN_PINYIN'=> 'yyyy/M/d ah:mm',
            'zh_CN_STROKE'=> 'yyyy/M/d ah:mm',
            'zh_HK'=> 'yyyy年M月d日 ah:mm',
            'zh_HK_STROKE'=> 'd/M/yyyy ah:mm',
            'zh_MO'=> 'd/M/yyyy ah:mm',
            'zh_SG'=> 'dd/MM/yyyy a hh:mm',
            'zh_TW'=> 'yyyy/M/d a h:mm',
            'zh_TW_STROKE'=> 'yyyy/M/d ah:mm',
            'zu_ZA'=> 'M/d/yyyy HH:mm'
    };
    return localeCurrencySymbolMap;

}
    public static Map<String,String> getLocaleCurrencySymbolMap2(){
   
    localeCurrencySymbolMap = new Map<String,String>{
       'AED'=> 'د.إ',
      'AFN'=> '؋',
      'ALL'=> 'L',
      'AMD'=> '֏',
      'ANG'=> 'ƒ',
      'AOA'=> 'Kz',
      'ARS'=> '$',
      'AUD'=> '$',
      'AWG'=> 'ƒ',
      'AZN'=> '₼',
      'BAM'=> 'KM',
      'BBD'=> '$',
      'BDT'=> '৳',
      'BGN'=> 'лв',
      'BHD'=> '.د.ب',
      'BIF'=> 'FBu',
      'BMD'=> '$',
      'BND'=> '$',
      'BOB'=> '$b',
      'BRL'=> 'R$',
      'BSD'=> '$',
      'BTC'=> '฿',
      'BTN'=> 'Nu.',
      'BWP'=> 'P',
      'BYR'=> 'Br',
      'BYN'=> 'Br',
      'BZD'=> 'BZ$',
      'CAD'=> '$',
      'CDF'=> 'FC',
      'CHF'=> 'CHF',
      'CLP'=> '$',
      'CNY'=> '¥',
      'COP'=> '$',
      'CRC'=> '₡',
      'CUC'=> '$',
      'CUP'=> '₱',
      'CVE'=> '$',
      'CZK'=> 'Kč',
      'DJF'=> 'Fdj',
      'DKK'=> 'kr',
      'DOP'=> 'RD$',
      'DZD'=> 'دج',
      'EEK'=> 'kr',
      'EGP'=> '£',
      'ERN'=> 'Nfk',
      'ETB'=> 'Br',
      'ETH'=> 'Ξ',
      'EUR'=> '€',
      'FJD'=> '$',
      'FKP'=> '£',
      'GBP'=> '£',
      'GEL'=> '₾',
      'GGP'=> '£',
      'GHC'=> '₵',
      'GHS'=> 'GH₵',
      'GIP'=> '£',
      'GMD'=> 'D',
      'GNF'=> 'FG',
      'GTQ'=> 'Q',
      'GYD'=> '$',
      'HKD'=> 'HK$',
      'HNL'=> 'L',
      'HRK'=> 'kn',
      'HTG'=> 'G',
      'HUF'=> ' Ft',
      'IDR'=> 'IDR',
      'ILS'=> 'ש"ח',
      'IMP'=> '£',
      'INR'=> '₹',
      'IQD'=> 'ع.د',
      'IRR'=> '﷼',
      'ISK'=> 'kr',
      'JEP'=> '£',
      'JMD'=> '$',
      'JOD'=> 'JD',
      'JPY'=> '¥',
      'KES'=> 'Ksh',
      'KGS'=> '  com',
      'KHR'=> '៛',
      'KMF'=> 'CF',
      'KPW'=> 'KPW',
      'KRW'=> '￦',
      'KWD'=> 'KD',
      'KYD'=> '$',
      'KZT'=> 'лв',
      'LAK'=> '₭',
      'LBP'=> '£',
      'LKR'=> '₨',
      'LRD'=> '$',
      'LSL'=> 'M',
      'LTC'=> 'Ł',
      'LTL'=> 'Lt',
      'LVL'=> 'Ls',
      'LYD'=> 'LD',
      'MAD'=> 'MAD',
      'MDL'=> 'lei',
      'MGA'=> 'Ar',
      'MKD'=> 'ден',
      'MMK'=> 'K',
      'MNT'=> '₮',
      'MOP'=> 'MOP$',
      'MRO'=> 'UM',
      'MRU'=> 'UM',
      'MUR'=> '₨',
      'MVR'=> 'Rf',
      'MWK'=> 'MK',
      'MXN'=> '$',
      'MYR'=> 'RM',
      'MZN'=> 'MT',
      'NAD'=> '$',
      'NGN'=> '₦',
      'NIO'=> 'C$',
      'NOK'=> 'kr',
      'NPR'=> '₨',
      'NZD'=> '$',
      'OMR'=> '﷼',
      'PAB'=> 'B/.',
      'PEN'=> 'S/.',
      'PGK'=> 'K',
      'PHP'=> 'Php',
      'PKR'=> '₨',
      'PLN'=> 'zł',
      'PYG'=> 'Gs',
      'QAR'=> '﷼',
      'RMB'=> '￥',
      'RON'=> 'lei',
      'RSD'=> 'Дин.',
      'RUB'=> 'руб.',
      'RWF'=> 'RF',
      'SAR'=> '﷼',
      'SBD'=> '$',
      'SCR'=> '₨',
      'SDG'=> 'ج.س.',
      'SEK'=> 'kr',
      'SGD'=> '$',
      'SHP'=> '£',
      'SLL'=> 'Le',
      'SOS'=> 'S',
      'SRD'=> '$',
      'SSP'=> '£',
      'STD'=> 'Db',
      'STN'=> 'Db',
      'SVC'=> '$',
      'SYP'=> '£',
      'SZL'=> 'E',
      'THB'=> '฿',
      'TJS'=> 'SM',
      'TMT'=> 'T',
      'TND'=> 'د.ت',
      'TOP'=> 'T$',
      'TRL'=> '₤',
      'TRY'=> '₺',
      'TTD'=> '$',
      'TVD'=> '$',
      'TWD'=> 'NT$',
      'TZS'=> 'TSh',
      'UAH'=> '₴',
      'UGX'=> 'USh',
      'USD'=> '$',
      'UYU'=> '$U',
      'UZS'=> 'лв',
      'VEF'=> 'Bs',
      'VND'=> '₫',
      'VUV'=> 'VT',
      'WST'=> 'WS$',
      'XAF'=> 'FCFA',
      'XBT'=> 'Ƀ',
      'XCD'=> '$',
      'XOF'=> 'CFA',
      'XPF'=> '₣',
      'YER'=> '﷼',
      'ZAR'=> 'R',
      'ZWD'=> 'Z$'
    };
    return localeCurrencySymbolMap;

}
    public static Map<String,String> getLocaleCurrencySymbolMap4(){
   
    localeCurrencySymbolMap = new Map<String,String>{
       'AED'=> 'د.إ',
      'AFN'=> '؋',
      'ALL'=> 'L',
      'AMD'=> '֏',
      'ANG'=> 'ƒ',
      'AOA'=> 'Kz',
      'ARS'=> '$',
      'AUD'=> '$',
      'AWG'=> 'ƒ',
      'AZN'=> '₼',
      'BAM'=> 'KM',
      'BBD'=> '$',
      'BDT'=> '৳',
      'BGN'=> 'лв',
      'BHD'=> '.د.ب',
      'BIF'=> 'FBu',
      'BMD'=> '$',
      'BND'=> '$',
      'BOB'=> '$b',
      'BRL'=> 'R$',
      'BSD'=> '$',
      'BTC'=> '฿',
      'BTN'=> 'Nu.',
      'BWP'=> 'P',
      'BYR'=> 'Br',
      'BYN'=> 'Br',
      'BZD'=> 'BZ$',
      'CAD'=> '$',
      'CDF'=> 'FC',
      'CHF'=> 'CHF',
      'CLP'=> '$',
      'CNY'=> '¥',
      'COP'=> '$',
      'CRC'=> '₡',
      'CUC'=> '$',
      'CUP'=> '₱',
      'CVE'=> '$',
      'CZK'=> 'Kč',
      'DJF'=> 'Fdj',
      'DKK'=> 'kr',
      'DOP'=> 'RD$',
      'DZD'=> 'دج',
      'EEK'=> 'kr',
      'EGP'=> '£',
      'ERN'=> 'Nfk',
      'ETB'=> 'Br',
      'ETH'=> 'Ξ',
      'EUR'=> '€',
      'FJD'=> '$',
      'FKP'=> '£',
      'GBP'=> '£',
      'GEL'=> '₾',
      'GGP'=> '£',
      'GHC'=> '₵',
      'GHS'=> 'GH₵',
      'GIP'=> '£',
      'GMD'=> 'D',
      'GNF'=> 'FG',
      'GTQ'=> 'Q',
      'GYD'=> '$',
      'HKD'=> 'HK$',
      'HNL'=> 'L',
      'HRK'=> 'kn',
      'HTG'=> 'G',
      'HUF'=> ' Ft',
      'IDR'=> 'IDR',
      'ILS'=> 'ש"ח',
      'IMP'=> '£',
      'INR'=> '₹',
      'IQD'=> 'ع.د',
      'IRR'=> '﷼',
      'ISK'=> 'kr',
      'JEP'=> '£',
      'JMD'=> '$',
      'JOD'=> 'JD',
      'JPY'=> '¥',
      'KES'=> 'Ksh',
      'KGS'=> '  com',
      'KHR'=> '៛',
      'KMF'=> 'CF',
      'KPW'=> 'KPW',
      'KRW'=> '￦',
      'KWD'=> 'KD',
      'KYD'=> '$',
      'KZT'=> 'лв',
      'LAK'=> '₭',
      'LBP'=> '£',
      'LKR'=> '₨',
      'LRD'=> '$',
      'LSL'=> 'M',
      'LTC'=> 'Ł',
      'LTL'=> 'Lt',
      'LVL'=> 'Ls',
      'LYD'=> 'LD',
      'MAD'=> 'MAD',
      'MDL'=> 'lei',
      'MGA'=> 'Ar',
      'MKD'=> 'ден',
      'MMK'=> 'K',
      'MNT'=> '₮',
      'MOP'=> 'MOP$',
      'MRO'=> 'UM',
      'MRU'=> 'UM',
      'MUR'=> '₨',
      'MVR'=> 'Rf',
      'MWK'=> 'MK',
      'MXN'=> '$',
      'MYR'=> 'RM',
      'MZN'=> 'MT',
      'NAD'=> '$',
      'NGN'=> '₦',
      'NIO'=> 'C$',
      'NOK'=> 'kr',
      'NPR'=> '₨',
      'NZD'=> '$',
      'OMR'=> '﷼',
      'PAB'=> 'B/.',
      'PEN'=> 'S/.',
      'PGK'=> 'K',
      'PHP'=> 'Php',
      'PKR'=> '₨',
      'PLN'=> 'zł',
      'PYG'=> 'Gs',
      'QAR'=> '﷼',
      'RMB'=> '￥',
      'RON'=> 'lei',
      'RSD'=> 'Дин.',
      'RUB'=> 'руб.',
      'RWF'=> 'RF',
      'SAR'=> '﷼',
      'SBD'=> '$',
      'SCR'=> '₨',
      'SDG'=> 'ج.س.',
      'SEK'=> 'kr',
      'SGD'=> '$',
      'SHP'=> '£',
      'SLL'=> 'Le',
      'SOS'=> 'S',
      'SRD'=> '$',
      'SSP'=> '£',
      'STD'=> 'Db',
      'STN'=> 'Db',
      'SVC'=> '$',
      'SYP'=> '£',
      'SZL'=> 'E',
      'THB'=> '฿',
      'TJS'=> 'SM',
      'TMT'=> 'T',
      'TND'=> 'د.ت',
      'TOP'=> 'T$',
      'TRL'=> '₤',
      'TRY'=> '₺',
      'TTD'=> '$',
      'TVD'=> '$',
      'TWD'=> 'NT$',
      'TZS'=> 'TSh',
      'UAH'=> '₴',
      'UGX'=> 'USh',
      'USD'=> '$',
      'UYU'=> '$U',
      'UZS'=> 'лв',
      'VEF'=> 'Bs',
      'VND'=> '₫',
      'VUV'=> 'VT',
      'WST'=> 'WS$',
      'XAF'=> 'FCFA',
      'XBT'=> 'Ƀ',
      'XCD'=> '$',
      'XOF'=> 'CFA',
      'XPF'=> '₣',
      'YER'=> '﷼',
      'ZAR'=> 'R',
      'ZWD'=> 'Z$'
    };
    return localeCurrencySymbolMap;

}
public static Map<String,String> getLocaleTimeFmtMap () {
    if (localeTimeFmtMap == null)
        localeTimeFmtMap  = new Map<String,String> {
            'af_ZA' => 'HH:mm',
            'ar_AE' => 'h:mm a',
            'ar_BH' => 'h:mm a',
            'ar_DZ' => 'h:mm a',
            'ar_EG'=> 'h:mm a',
            'ar_IQ'=> 'h:mm a',
            'ar_JO'         => 'hh:mm a',
            'ar_KW'=> 'h:mm a',
            'ar_LB'         => 'hh:mm a',
            'ar_LY'=> 'h:mm a',
            'ar_MA'=> 'HH:mm',
            'ar_OM'=> 'h:mm a',
            'ar_QA'=> 'h:mm a',
            'ar_SA'         => 'hh:mm a',
            'ar_SD'=> 'h:mm a',
            'ar_SY'=> 'hh:mm a',
            'ar_TN'=> 'h:mm a',
            'ar_YE'=> 'h:mm a',
            'az_AZ'=> 'HH:mm',
            'be_BY'=> 'H.mm',
            'bg_BG'=> 'HH:mm',
            'bn_BD'=> 'h:mm a',
            'bn_IN'=> 'h:mm a',
            'bs_BA'=> 'HH:mm',
            'ca_ES'         => 'HH:mm',
            'ca_ES_EURO'    => 'HH:mm',
            'cs_CZ'         => 'H:mm',
            'cy_GB'=> 'HH:mm',
            'da_DK'         => 'HH:mm',
            'de_AT'         => 'HH:mm',
            'de_AT_EURO'    => 'HH:mm',
            'de_BE'=> 'HH:mm',
            'de_DE'         => 'HH:mm',
            'de_DE_EURO'    => 'HH:mm',
            'de_LU'         => 'HH:mm',
            'de_LU_EURO'    => 'HH:mm',
            'de_CH'=> 'HH:mm',
            'dz_BT'=> 'ཆུ་ཚོད་ h སྐར་མ་ mm a',
            'el_GR'         => 'h:mm a',
            'en_AG'=> 'h:mm a',
            'en_AU'=> 'h:mm a',
            'en_BB'=> 'HH:mm',
            'en_BS'=> 'h:mm a',
            'en_BZ'=> 'HH:mm',
            'en_BM'=> 'HH:mm',
            'en_BW'=> 'HH:mm',
            'en_CA'         => 'h:mm a',
            'en_CM'=> 'HH:mm',
            'en_KY'=> 'h:mm a',
            'en_ER'=> 'h:mm a',
            'en_FK'=> 'HH:mm',
            'en_FJ'=> 'h:mm a',
            'en_GM'=> 'h:mm a',
            'en_GH'=> 'HH:mm',
            'en_GI'=> 'HH:mm',
            'en_GY'=> 'h:mm a',
            'en_HK'=> 'h:mm a',
            'en_IN'=> 'h:mm a',
            'en_ID'=> 'HH:mm',
            'en_IE'         => 'HH:mm',
            'en_IE_EURO'    => 'HH:mm',
            'en_JM'=> 'h:mm a',
            'en_KE'=> 'HH:mm',
            'en_LR'=> 'h:mm a',
            'en_MG'=> 'HH:mm',
            'en_MW'=> 'h:mm a',
            'en_MY'=> 'HH:mm',
            'en_MU'=> 'HH:mm',
            'en_NA'=> 'h:mm a',
            'en_NZ'=> 'h:mm a',
            'en_NG'=> 'HH:mm',
            'en_PK'=> 'h:mm a',
            'en_PG'=> 'h:mm a',
            'en_PH'=> 'h:mm a',
            'en_RW'=> 'HH:mm',
            'en_SH'=> 'HH:mm',
            'en_WS'=> 'h:mm a',
            'en_SC'=> 'HH:mm',
            'en_SL'=> 'h:mm a',
            'en_SG'=> 'HH:mm',
            'en_SX'=> 'HH:mm',
            'en_SB'=> 'h:mm a',
            'en_ZA'=> 'h:mm a',
            'en_SZ'=> 'h:mm a',
            'en_TZ'=> 'HH:mm',
            'en_TO'=> 'h:mm a',
            'en_TT'=> 'h:mm a',
            'en_UG'=> 'HH:mm',
           'en_GB'=> 'HH:mm',
            'en_US'         => 'h:mm a',
            'en_VU'=> 'h:mm a',
            'es_AR'         => 'HH:mm',
            'es_BO'         => 'hh:mm a',
            'es_CL'=> 'H:mm',
            'es_CO'         => 'hh:mm a',
            'es_CR'         => 'hh:mm a',
            'es_CU'=> 'HH:mm',
            'es_DO'=> 'hh:mm a',
            'es_EC'=> 'H:mm',
            'es_ES'         => 'H:mm',
            'es_ES_EURO'    => 'H:mm',
            'es_GT'         => 'hh:mm a',
            'es_HN'         => 'hh:mm a',
            'es_MX'         => 'hh:mm a',
            'es_NI'=> 'hh:mm a',
            'es_PA'=> 'hh:mm a',
            'es_PE'         => 'hh:mm a',
            'es_PR'         => 'hh:mm a',
            'es_PY'         => 'hh:mm a',
            'es_SV'         => 'hh:mm a',
            'es_US'=> 'h:mm a',
            'es_VE'         => 'hh:mm a',
            'et_EE'         => 'H:mm',
            'eu_ES'=> 'HH:mm',
            'fa_IR'=> 'H:mm',
            'fi_FI'         => 'H:mm',
            'fi_FI_EURO'    => 'H:mm',
            'fr_BE'         => 'H:mm',
            'fr_CA'         => 'HH:mm',
            'fr_KM'=> 'HH:mm',
            'fr_FR'         => 'HH:mm',
            'fr_FR_EURO'    => 'HH:mm',
            'fr_GN'=> 'HH:mm',
            'fr_HT'=> 'HH:mm',
            'fr_LU'         => 'HH:mm',
            'fr_MR'=> 'h:mm a',
            'fr_MC'         => 'HH:mm',
            'fr_CH'=> 'HH:mm',
            'fr_WF'=> 'HH:mm',
            'ga_IE'=> 'HH:mm',
            'gu_IN'=> 'hh:mm a',
            'hi_IN'=> 'h:mm a',
            'hr_HR'         => 'HH:mm',
            'hu_HU'=> 'H:mm',
            'hy_AM'=> 'HH:mm',
            'in_ID'=> 'H:mm',
            'is_IS'         => 'HH:mm',
            'it_CH'         => 'HH:mm',
            'it_IT'         => 'H.mm',
            'iw_IL'         => 'HH:mm ',
            'ja_JP'         => 'H:mm',
            'ka_GE'=> 'HH:mm',
            'kk_KZ'=> 'HH:mm',
            'km_KH'         => 'h:mm a',
            'kn_IN'=> 'hh:mm a',
            'ko_KP'=> 'a h:mm',
            'ko_KR'=> 'a h:mm',
            'ky_KG'=> 'HH:mm',
            'lb_LU'=> 'HH:mm',
            'lo_LA'=> 'H:mm',
            'lt_LT'         => 'HH.mm',
            'lu_CD'=> 'HH:mm',
            'lv_LV'         => 'HH:mm',
            'mk_MK'=> 'HH:mm',
            'ml_IN'=> 'h:mm a',
            'mr_IN'=> 'h:mm a',
            'ms_BN'=> 'h:mm a',
            'ms_MY'         => 'h:mm a',
            'mt_MT'=> 'HH:mm',
            'my_MM'=> 'B H:mm',
            'ne_NP'=> 'HH:mm',
            'nl_AW'=> 'HH:mm',
            'nl_BE'         => 'H:mm',
            'nl_NL'         => 'H:mm',
            'nl_SR'=> 'HH:mm',
            'no_NO'         => 'HH:mm',
            'pl_PL'=> 'HH:mm',
            'ps_AF'=> 'H:mm',
            'pt_AO'=> 'HH:mm',
            'pt_BR'         => 'HH:mm',
            'pt_CV'=> 'HH:mm',
            'pt_MZ'=> 'HH:mm',
            'pt_PT'         => 'H:mm',
            'pt_ST'=> 'HH:mm',
            'rm_CH'=> 'HH:mm',
            'rn_BI'=> 'HH:mm',
            'ro_MD'=> 'HH:mm',
            'ro_RO'         => 'HH:mm',
            'ru_KZ'=> 'H:mm',
            'ru_RU'=> 'H:mm',
            'sh_BA'=> 'HH:mm',
            'sh_CS'=> 'HH:mm',
            'sh_ME'=> 'HH:mm',
            'sk_SK'         => 'H:mm',
            'sl_SI'         => 'H:mm',
            'so_DJ'=> 'h:mm a',
            'so_SO'=> 'h:mm a',
            'sr_BA'=> 'HH:mm',
            'sr_CS'=> 'HH.mm',
            'sr_RS'=> 'HH.mm',
            'sq_AL'=> 'h.mm.a',
            'sv_SE'         => 'HH:mm',
            'sw_KE'=> 'HH:mm',
            'ta_IN'=> 'a h:mm',
            'ta_LK'=> 'HH:mm',
            'te_IN'=> 'h:mm a',
            'tg_TJ'=> 'HH:mm',
            'th_TH'=> 'H:mm น.',
            'ti_ET'=> 'h:mm a',
            'tl_PH'=> 'h:mm a',
            'tr_TR'=> 'HH:mm',
            'uk_UA'=> 'H:mm',
            'ur_PK'         => 'h:mm a',
            'uz_LATN_UZ'=> 'HH:mm',
            'vi_VN'         => 'HH:mm',
            'yo_BJ'=> 'HH:mm',
            'xh_ZA'=> 'h:mm a',
            'zh_CN'         => 'ah:mm',
            'zh_CN_PINYIN'=> 'ah:mm',
            'zh_CN_STROKE'=> 'ah:mm',
            'zh_HK'         => 'ah:mm',
            'zh_HK_STROKE'=> 'ah:mm',
            'zh_MO'=> 'ah:mm',
            'zh_SG'=> 'a hh:mm',
            'zh_TW'=> 'a h:mm',
            'zh_TW_STROKE'=> 'ah:mm',
            'zu_ZA'=> 'HH:mm'            
        };
        return localeToDateTimeFmtMap;
}
    public static Map<String,String> getLocaleTimeFmtMap11 () {
    
        localeTimeFmtMap  = new Map<String,String> {
            'af_ZA' => 'HH:mm',
            'ar_AE' => 'h:mm a',
            'ar_BH' => 'h:mm a',
            'ar_DZ' => 'h:mm a',
            'ar_EG'=> 'h:mm a',
            'ar_IQ'=> 'h:mm a',
            'ar_JO'         => 'hh:mm a',
            'ar_KW'=> 'h:mm a',
            'ar_LB'         => 'hh:mm a',
            'ar_LY'=> 'h:mm a',
            'ar_MA'=> 'HH:mm',
            'ar_OM'=> 'h:mm a',
            'ar_QA'=> 'h:mm a',
            'ar_SA'         => 'hh:mm a',
            'ar_SD'=> 'h:mm a',
            'ar_SY'=> 'hh:mm a',
            'ar_TN'=> 'h:mm a',
            'ar_YE'=> 'h:mm a',
            'az_AZ'=> 'HH:mm',
            'be_BY'=> 'H.mm',
            'bg_BG'=> 'HH:mm',
            'bn_BD'=> 'h:mm a',
            'bn_IN'=> 'h:mm a',
            'bs_BA'=> 'HH:mm',
            'ca_ES'         => 'HH:mm',
            'ca_ES_EURO'    => 'HH:mm',
            'cs_CZ'         => 'H:mm',
            'cy_GB'=> 'HH:mm',
            'da_DK'         => 'HH:mm',
            'de_AT'         => 'HH:mm',
            'de_AT_EURO'    => 'HH:mm',
            'de_BE'=> 'HH:mm',
            'de_DE'         => 'HH:mm',
            'de_DE_EURO'    => 'HH:mm',
            'de_LU'         => 'HH:mm',
            'de_LU_EURO'    => 'HH:mm',
            'de_CH'=> 'HH:mm',
            'dz_BT'=> 'ཆུ་ཚོད་ h སྐར་མ་ mm a',
            'el_GR'         => 'h:mm a',
            'en_AG'=> 'h:mm a',
            'en_AU'=> 'h:mm a',
            'en_BB'=> 'HH:mm',
            'en_BS'=> 'h:mm a',
            'en_BZ'=> 'HH:mm',
            'en_BM'=> 'HH:mm',
            'en_BW'=> 'HH:mm',
            'en_CA'         => 'h:mm a',
            'en_CM'=> 'HH:mm',
            'en_KY'=> 'h:mm a',
            'en_ER'=> 'h:mm a',
            'en_FK'=> 'HH:mm',
            'en_FJ'=> 'h:mm a',
            'en_GM'=> 'h:mm a',
            'en_GH'=> 'HH:mm',
            'en_GI'=> 'HH:mm',
            'en_GY'=> 'h:mm a',
            'en_HK'=> 'h:mm a',
            'en_IN'=> 'h:mm a',
            'en_ID'=> 'HH:mm',
            'en_IE'         => 'HH:mm',
            'en_IE_EURO'    => 'HH:mm',
            'en_JM'=> 'h:mm a',
            'en_KE'=> 'HH:mm',
            'en_LR'=> 'h:mm a',
            'en_MG'=> 'HH:mm',
            'en_MW'=> 'h:mm a',
            'en_MY'=> 'HH:mm',
            'en_MU'=> 'HH:mm',
            'en_NA'=> 'h:mm a',
            'en_NZ'=> 'h:mm a',
            'en_NG'=> 'HH:mm',
            'en_PK'=> 'h:mm a',
            'en_PG'=> 'h:mm a',
            'en_PH'=> 'h:mm a',
            'en_RW'=> 'HH:mm',
            'en_SH'=> 'HH:mm',
            'en_WS'=> 'h:mm a',
            'en_SC'=> 'HH:mm',
            'en_SL'=> 'h:mm a',
            'en_SG'=> 'HH:mm',
            'en_SX'=> 'HH:mm',
            'en_SB'=> 'h:mm a',
            'en_ZA'=> 'h:mm a',
            'en_SZ'=> 'h:mm a',
            'en_TZ'=> 'HH:mm',
            'en_TO'=> 'h:mm a',
            'en_TT'=> 'h:mm a',
            'en_UG'=> 'HH:mm',
           'en_GB'=> 'HH:mm',
            'en_US'         => 'h:mm a',
            'en_VU'=> 'h:mm a',
            'es_AR'         => 'HH:mm',
            'es_BO'         => 'hh:mm a',
            'es_CL'=> 'H:mm',
            'es_CO'         => 'hh:mm a',
            'es_CR'         => 'hh:mm a',
            'es_CU'=> 'HH:mm',
            'es_DO'=> 'hh:mm a',
            'es_EC'=> 'H:mm',
            'es_ES'         => 'H:mm',
            'es_ES_EURO'    => 'H:mm',
            'es_GT'         => 'hh:mm a',
            'es_HN'         => 'hh:mm a',
            'es_MX'         => 'hh:mm a',
            'es_NI'=> 'hh:mm a',
            'es_PA'=> 'hh:mm a',
            'es_PE'         => 'hh:mm a',
            'es_PR'         => 'hh:mm a',
            'es_PY'         => 'hh:mm a',
            'es_SV'         => 'hh:mm a',
            'es_US'=> 'h:mm a',
            'es_VE'         => 'hh:mm a',
            'et_EE'         => 'H:mm',
            'eu_ES'=> 'HH:mm',
            'fa_IR'=> 'H:mm',
            'fi_FI'         => 'H:mm',
            'fi_FI_EURO'    => 'H:mm',
            'fr_BE'         => 'H:mm',
            'fr_CA'         => 'HH:mm',
            'fr_KM'=> 'HH:mm',
            'fr_FR'         => 'HH:mm',
            'fr_FR_EURO'    => 'HH:mm',
            'fr_GN'=> 'HH:mm',
            'fr_HT'=> 'HH:mm',
            'fr_LU'         => 'HH:mm',
            'fr_MR'=> 'h:mm a',
            'fr_MC'         => 'HH:mm',
            'fr_CH'=> 'HH:mm',
            'fr_WF'=> 'HH:mm',
            'ga_IE'=> 'HH:mm',
            'gu_IN'=> 'hh:mm a',
            'hi_IN'=> 'h:mm a',
            'hr_HR'         => 'HH:mm',
            'hu_HU'=> 'H:mm',
            'hy_AM'=> 'HH:mm',
            'in_ID'=> 'H:mm',
            'is_IS'         => 'HH:mm',
            'it_CH'         => 'HH:mm',
            'it_IT'         => 'H.mm',
            'iw_IL'         => 'HH:mm ',
            'ja_JP'         => 'H:mm',
            'ka_GE'=> 'HH:mm',
            'kk_KZ'=> 'HH:mm',
            'km_KH'         => 'h:mm a',
            'kn_IN'=> 'hh:mm a',
            'ko_KP'=> 'a h:mm',
            'ko_KR'=> 'a h:mm',
            'ky_KG'=> 'HH:mm',
            'lb_LU'=> 'HH:mm',
            'lo_LA'=> 'H:mm',
            'lt_LT'         => 'HH.mm',
            'lu_CD'=> 'HH:mm',
            'lv_LV'         => 'HH:mm',
            'mk_MK'=> 'HH:mm',
            'ml_IN'=> 'h:mm a',
            'mr_IN'=> 'h:mm a',
            'ms_BN'=> 'h:mm a',
            'ms_MY'         => 'h:mm a',
            'mt_MT'=> 'HH:mm',
            'my_MM'=> 'B H:mm',
            'ne_NP'=> 'HH:mm',
            'nl_AW'=> 'HH:mm',
            'nl_BE'         => 'H:mm',
            'nl_NL'         => 'H:mm',
            'nl_SR'=> 'HH:mm',
            'no_NO'         => 'HH:mm',
            'pl_PL'=> 'HH:mm',
            'ps_AF'=> 'H:mm',
            'pt_AO'=> 'HH:mm',
            'pt_BR'         => 'HH:mm',
            'pt_CV'=> 'HH:mm',
            'pt_MZ'=> 'HH:mm',
            'pt_PT'         => 'H:mm',
            'pt_ST'=> 'HH:mm',
            'rm_CH'=> 'HH:mm',
            'rn_BI'=> 'HH:mm',
            'ro_MD'=> 'HH:mm',
            'ro_RO'         => 'HH:mm',
            'ru_KZ'=> 'H:mm',
            'ru_RU'=> 'H:mm',
            'sh_BA'=> 'HH:mm',
            'sh_CS'=> 'HH:mm',
            'sh_ME'=> 'HH:mm',
            'sk_SK'         => 'H:mm',
            'sl_SI'         => 'H:mm',
            'so_DJ'=> 'h:mm a',
            'so_SO'=> 'h:mm a',
            'sr_BA'=> 'HH:mm',
            'sr_CS'=> 'HH.mm',
            'sr_RS'=> 'HH.mm',
            'sq_AL'=> 'h.mm.a',
            'sv_SE'         => 'HH:mm',
            'sw_KE'=> 'HH:mm',
            'ta_IN'=> 'a h:mm',
            'ta_LK'=> 'HH:mm',
            'te_IN'=> 'h:mm a',
            'tg_TJ'=> 'HH:mm',
            'th_TH'=> 'H:mm น.',
            'ti_ET'=> 'h:mm a',
            'tl_PH'=> 'h:mm a',
            'tr_TR'=> 'HH:mm',
            'uk_UA'=> 'H:mm',
            'ur_PK'         => 'h:mm a',
            'uz_LATN_UZ'=> 'HH:mm',
            'vi_VN'         => 'HH:mm',
            'yo_BJ'=> 'HH:mm',
            'xh_ZA'=> 'h:mm a',
            'zh_CN'         => 'ah:mm',
            'zh_CN_PINYIN'=> 'ah:mm',
            'zh_CN_STROKE'=> 'ah:mm',
            'zh_HK'         => 'ah:mm',
            'zh_HK_STROKE'=> 'ah:mm',
            'zh_MO'=> 'ah:mm',
            'zh_SG'=> 'a hh:mm',
            'zh_TW'=> 'a h:mm',
            'zh_TW_STROKE'=> 'ah:mm',
            'zu_ZA'=> 'HH:mm'            
        };
        return localeToDateTimeFmtMap;
}


public static Map<String,String> getLocaleCurrencySymbolMap(){
        if(localeCurrencySymbolMap == null)
        localeCurrencySymbolMap = new Map<String,String>{
           'AED'=> 'د.إ',
          'AFN'=> '؋',
          'ALL'=> 'L',
          'AMD'=> '֏',
          'ANG'=> 'ƒ',
          'AOA'=> 'Kz',
          'ARS'=> '$',
          'AUD'=> '$',
          'AWG'=> 'ƒ',
          'AZN'=> '₼',
          'BAM'=> 'KM',
          'BBD'=> '$',
          'BDT'=> '৳',
          'BGN'=> 'лв',
          'BHD'=> '.د.ب',
          'BIF'=> 'FBu',
          'BMD'=> '$',
          'BND'=> '$',
          'BOB'=> '$b',
          'BRL'=> 'R$',
          'BSD'=> '$',
          'BTC'=> '฿',
          'BTN'=> 'Nu.',
          'BWP'=> 'P',
          'BYR'=> 'Br',
          'BYN'=> 'Br',
          'BZD'=> 'BZ$',
          'CAD'=> '$',
          'CDF'=> 'FC',
          'CHF'=> 'CHF',
          'CLP'=> '$',
          'CNY'=> '¥',
          'COP'=> '$',
          'CRC'=> '₡',
          'CUC'=> '$',
          'CUP'=> '₱',
          'CVE'=> '$',
          'CZK'=> 'Kč',
          'DJF'=> 'Fdj',
          'DKK'=> 'kr',
          'DOP'=> 'RD$',
          'DZD'=> 'دج',
          'EEK'=> 'kr',
          'EGP'=> '£',
          'ERN'=> 'Nfk',
          'ETB'=> 'Br',
          'ETH'=> 'Ξ',
          'EUR'=> '€',
          'FJD'=> '$',
          'FKP'=> '£',
          'GBP'=> '£',
          'GEL'=> '₾',
          'GGP'=> '£',
          'GHC'=> '₵',
          'GHS'=> 'GH₵',
          'GIP'=> '£',
          'GMD'=> 'D',
          'GNF'=> 'FG',
          'GTQ'=> 'Q',
          'GYD'=> '$',
          'HKD'=> 'HK$',
          'HNL'=> 'L',
          'HRK'=> 'kn',
          'HTG'=> 'G',
          'HUF'=> ' Ft',
          'IDR'=> 'IDR',
          'ILS'=> 'ש"ח',
          'IMP'=> '£',
          'INR'=> '₹',
          'IQD'=> 'ع.د',
          'IRR'=> '﷼',
          'ISK'=> 'kr',
          'JEP'=> '£',
          'JMD'=> '$',
          'JOD'=> 'JD',
          'JPY'=> '¥',
          'KES'=> 'Ksh',
          'KGS'=> '  com',
          'KHR'=> '៛',
          'KMF'=> 'CF',
          'KPW'=> 'KPW',
          'KRW'=> '￦',
          'KWD'=> 'KD',
          'KYD'=> '$',
          'KZT'=> 'лв',
          'LAK'=> '₭',
          'LBP'=> '£',
          'LKR'=> '₨',
          'LRD'=> '$',
          'LSL'=> 'M',
          'LTC'=> 'Ł',
          'LTL'=> 'Lt',
          'LVL'=> 'Ls',
          'LYD'=> 'LD',
          'MAD'=> 'MAD',
          'MDL'=> 'lei',
          'MGA'=> 'Ar',
          'MKD'=> 'ден',
          'MMK'=> 'K',
          'MNT'=> '₮',
          'MOP'=> 'MOP$',
          'MRO'=> 'UM',
          'MRU'=> 'UM',
          'MUR'=> '₨',
          'MVR'=> 'Rf',
          'MWK'=> 'MK',
          'MXN'=> '$',
          'MYR'=> 'RM',
          'MZN'=> 'MT',
          'NAD'=> '$',
          'NGN'=> '₦',
          'NIO'=> 'C$',
          'NOK'=> 'kr',
          'NPR'=> '₨',
          'NZD'=> '$',
          'OMR'=> '﷼',
          'PAB'=> 'B/.',
          'PEN'=> 'S/.',
          'PGK'=> 'K',
          'PHP'=> 'Php',
          'PKR'=> '₨',
          'PLN'=> 'zł',
          'PYG'=> 'Gs',
          'QAR'=> '﷼',
          'RMB'=> '￥',
          'RON'=> 'lei',
          'RSD'=> 'Дин.',
          'RUB'=> 'руб.',
          'RWF'=> 'RF',
          'SAR'=> '﷼',
          'SBD'=> '$',
          'SCR'=> '₨',
          'SDG'=> 'ج.س.',
          'SEK'=> 'kr',
          'SGD'=> '$',
          'SHP'=> '£',
          'SLL'=> 'Le',
          'SOS'=> 'S',
          'SRD'=> '$',
          'SSP'=> '£',
          'STD'=> 'Db',
          'STN'=> 'Db',
          'SVC'=> '$',
          'SYP'=> '£',
          'SZL'=> 'E',
          'THB'=> '฿',
          'TJS'=> 'SM',
          'TMT'=> 'T',
          'TND'=> 'د.ت',
          'TOP'=> 'T$',
          'TRL'=> '₤',
          'TRY'=> '₺',
          'TTD'=> '$',
          'TVD'=> '$',
          'TWD'=> 'NT$',
          'TZS'=> 'TSh',
          'UAH'=> '₴',
          'UGX'=> 'USh',
          'USD'=> '$',
          'UYU'=> '$U',
          'UZS'=> 'лв',
          'VEF'=> 'Bs',
          'VND'=> '₫',
          'VUV'=> 'VT',
          'WST'=> 'WS$',
          'XAF'=> 'FCFA',
          'XBT'=> 'Ƀ',
          'XCD'=> '$',
          'XOF'=> 'CFA',
          'XPF'=> '₣',
          'YER'=> '﷼',
          'ZAR'=> 'R',
          'ZWD'=> 'Z$'
        };
        return localeCurrencySymbolMap;

    }

    public static Boolean isLogEnabled = null;
    public static String logLevel = null;
    

    // User Story 97989: Internal - Enhancement - 302 status code for managed static resources
    public static Map<String, String> resourceMap = new Map<String, String>();
    public static String getResourceURL(String resourceName){
        // Fetching the resource
        if(resourceMap.containsKey(resourceName)){
            return resourceMap.get(resourceName);
        } else {
            getResourceURL(new List<String>{resourceName});
            return resourceMap.get(resourceName);
        }
    }

    // User Story 97989: Internal - Enhancement - 302 status code for managed static resources
    public static void getResourceURL(List<String> resourceNameList){
        Map<String,String>  resourceListReturn = new Map<String,String>();
        KeyValueHolder__mdt objMetadataHolder = KeyValueHolderHelper.getKeyValueHolder('BaseURL');
        UserPreferences__c userPref = UserPreferences__c.getInstance();
        String baseURLConfig;
        if(objMetadataHolder != null && objMetadataHolder.BooleanValue__c && String.isNotBlank(objMetadataHolder.Description__c) && String.isBlank(baseURLConfig) && UserInfo.getUserType() != 'Guest' && userPref.IsInternal__c){
            baseURLConfig = objMetadataHolder.Description__c;
        }
        String baseURL = String.isNotBlank(baseURLConfig) ? baseURLConfig : URL.getOrgDomainUrl().toExternalForm();
        String namespacePrefix = AppUtils.getNameSpacePrefix().removeEnd('__');
        // Fetching the resource
        if(!resourceMap.keySet().containsAll(resourceNameList)){
            if (Schema.sObjectType.StaticResource.fields.Name.isAccessible()) {
        for(StaticResource obj : [SELECT Name, NamespacePrefix, SystemModStamp FROM StaticResource WHERE Name IN :resourceNameList and NamespacePrefix =: namespacePrefix  ORDER BY Name]){//CRUD  FLS- False +ve - Std obj  - will not check permission here 
            String strResourceURL = baseURL + '/resource/' + obj.SystemModStamp.getTime() + '/' + (String.isNotBlank(obj.NamespacePrefix) ? obj.NamespacePrefix + '__' : '') + obj.Name;
                resourceMap.put(obj.Name, strResourceURL);
            }
        }
            }
    }

    // Task 104303: Internal - Enhancement - Ignore record/object-level access check
    // User Story 127005: Internal - Spring'21 release - View All, Modify All, Edit, and Delete Object Permissions Removed for Guest Users - Part 2
    static Boolean skipPermissionCheck;

    //new method
    public static Boolean isSkipPermissionCheck(){
        if(skipPermissionCheck == null){
            skipPermissionCheck = false;

            //new logic
            Boolean metaBooleanValue = KeyValueHolderHelper.getBooleanValue('DisableRecordLevelAccessCheck');
            String metaTextValue = KeyValueHolderHelper.getTextValue('DisableRecordLevelAccessCheck');
                 if (metaBooleanValue && String.isNotBlank(metaTextValue)) {
                    //new code block added  aboe code block commented
                    String profileName = [SELECT Name FROM Profile WHERE Id = :UserInfo.getProfileId()].Name.toLowerCase();//CRUD  FLS- False +ve - Std obj  - will not check permission here 
                    Set<String> setConfigProfiles = new Set<String>(new List<String>(metaTextValue.toLowerCase().split(';')));
                    if (setConfigProfiles != null && !setConfigProfiles.isEmpty() && setConfigProfiles.contains(profileName)) {
                        skipPermissionCheck = true;
                    }
                }
            //}
        }
        return skipPermissionCheck;
    }

    public static boolean isLightningTheme(){
        if(UserInfo.getUiThemeDisplayed()=='Theme4d' || UserInfo.getUiThemeDisplayed()=='Theme4u'){
            return true;
        }
        return false;
    }
    
    public static boolean isExperienceCloud(){
        try{
            if(Auth.CommunitiesUtil.isGuestUser()){
                return true;
            }
            String networkId = Network.getNetworkId();
            if(String.isNotEmpty(networkId)){
                if(Schema.sObjectType.Network.isAccessible()){
                    Network currentSite = [SELECT Id,OptionsSiteAsContainerEnabled from Network where Id = :Network.getNetworkId() WITH USER_MODE LIMIT 1];
                    return currentSite.OptionsSiteAsContainerEnabled;
                }
            }        
            return false;
        }catch(Exception ex){
            return false;
        }
    }
    
     public static String parseWhereClause(String whereClause){
        if(whereClause == null) 
            return '';
        if(whereClause.contains('\'\'')){
            whereClause = whereClause.replaceAll('\\\'\\\'','null');
        }
        String[] splitClause = whereClause.replaceAll('\\\\','').split('\'');
        String clearClause = splitClause[0];
        if(splitClause.size() > 1){
            for(integer x=1;x<splitClause.size();x++) {
                clearClause += '\'' + string.escapeSingleQuotes(splitClause[x]) + '\'';
    
                if(splitClause.size() > x+1){
                    x++;
                    clearClause += splitClause[x];
                }
            }
        }
        return clearClause;
    }


    public static Map<String, String> getActionIcon(){
    
        map<string,string> fafaLwcUtilityMap = new map<string,string>();
        fafaLwcUtilityMap.put('fa fa-pencil','utility:edit');
        fafaLwcUtilityMap.put('fa fa-arrow','utility:right');
        fafaLwcUtilityMap.put('fa fa-ban','utility:close');
        fafaLwcUtilityMap.put('fa fa-bolt','utility:thunder');
        fafaLwcUtilityMap.put('fa fa-check','utility:success'); 
        fafaLwcUtilityMap.put('fa fa-clone','utility:clone');
        fafaLwcUtilityMap.put('fa fa-close','utility:close');
        fafaLwcUtilityMap.put('fa fa-cloud-download','utility:download');
        fafaLwcUtilityMap.put('fa fa-cloud-upload','utility:upload');
        fafaLwcUtilityMap.put('fa fa-comments','utility:chat');
        fafaLwcUtilityMap.put('fa fa-exchange','utility:exchange');
        fafaLwcUtilityMap.put('fa fa-external-link','utility:open');
        fafaLwcUtilityMap.put('fa fa-eye','utility:preview');
        fafaLwcUtilityMap.put('fa fa-file','utility:page');
        fafaLwcUtilityMap.put('fa fa-file-pdf','utility:file_pdf');
        fafaLwcUtilityMap.put('fa fa-file-text','utility:file');
        fafaLwcUtilityMap.put('fa fa-gavel','utility:thunder');
        fafaLwcUtilityMap.put('fa fa-level-up','utility:up');
        fafaLwcUtilityMap.put('fa fa-money','utility:currency');
        fafaLwcUtilityMap.put('fa fa-play','utility:play');
        fafaLwcUtilityMap.put('fa fa-plus-circle','utility:add');
        fafaLwcUtilityMap.put('fa fa-reply','utility:back');
        fafaLwcUtilityMap.put('fa fa-share','utility:share');
        fafaLwcUtilityMap.put('fa fa-share-square-o','utility:share_post');
        fafaLwcUtilityMap.put('fa fa-sign-in','utility:login');
        fafaLwcUtilityMap.put('fa fa-sign-out','utility:logout');
        fafaLwcUtilityMap.put('fa fa-sitemap','utility:hierarchy');
        fafaLwcUtilityMap.put('fa fa-sticky-note','utility:note');
        fafaLwcUtilityMap.put('fa fa-stop','utility:stop');
        fafaLwcUtilityMap.put('fa fa-tags','utility:tags');
        fafaLwcUtilityMap.put('fa fa-times','utility:close');
        fafaLwcUtilityMap.put('fa fa-trash','utility:delete');
        fafaLwcUtilityMap.put('fa fa-trophy','custom:custom48');
        fafaLwcUtilityMap.put('fa fa-undo','utility:undo');
        fafaLwcUtilityMap.put('fa fa-unlock','utility:unlock');
        fafaLwcUtilityMap.put('fa fa-paper-plane-o','utility:send');
        fafaLwcUtilityMap.put('glyphicon glyphicon-pencil','utility:edit');
        fafaLwcUtilityMap.put('glyphicon glyphicon-remove','utility:close');
        fafaLwcUtilityMap.put('glyphicon glyphicon-send','utility:send');
        fafaLwcUtilityMap.put('glyphicon glyphicon-thumbs-down','utility:dislike');
        fafaLwcUtilityMap.put('glyphicon glyphicon-thumbs-up','utility:like');
        fafaLwcUtilityMap.put('glyphicon glyphicon-trash','utility:delete');
        fafaLwcUtilityMap.put('fa fa-history','utility:skip_back');
        fafaLwcUtilityMap.put('fa fa-table','utility:table');
        fafaLwcUtilityMap.put('fa fa-coffee','utility:coffee');
        fafaLwcUtilityMap.put('fa fa-cubes','utility:cubes');
        fafaLwcUtilityMap.put('fa fa-star','utility:favorite');
        fafaLwcUtilityMap.put('fa fa-exclamation-triangle','utility:warning');
        fafaLwcUtilityMap.put('fa fa-line-chart','utility:lineChart');
        fafaLwcUtilityMap.put('fa fa-comment','utility:comments');
        fafaLwcUtilityMap.put('fa fa-caret-square-o-down','utility:down');
        fafaLwcUtilityMap.put('fa fa-wrench','utility:settings');
        fafaLwcUtilityMap.put('fa fa-share-square-o','utility:share');
        fafaLwcUtilityMap.put('fa fa-bolt','utility:lightning');
        fafaLwcUtilityMap.put('fa fa-trash-o','utility:delete');
        fafaLwcUtilityMap.put('glyphicon glyphicon-book','utility:knowledge_base');
        fafaLwcUtilityMap.put('fa fa-file-text-o','utility:contract_doc');
        fafaLwcUtilityMap.put('fa fa-wechat','utility:chat');
        fafaLwcUtilityMap.put('fa fa-paperclip','utility:attach');
        fafaLwcUtilityMap.put('fa fa-usd','utility:moneybag');
        fafaLwcUtilityMap.put('glyphicon glyphicon-tasks','utility:task');
        //fafaLwcUtilityMap.put('fa fa-trophy','utility:funding_award_adjustment');
        fafaLwcUtilityMap.put('fa fa-folder','utility:open_folder');
        fafaLwcUtilityMap.put('fa fa-paper-plane-o','utility:send');
        fafaLwcUtilityMap.put('fa fa-play','utility:play');

        return fafaLwcUtilityMap;
    }

    public static Map<String, String> getActionIconLwc(){
    
        map<string,string> fafaLwcUtilityMap = new map<string,string>();
        fafaLwcUtilityMap.put('fa fa-pencil','utility:edit');
        fafaLwcUtilityMap.put('fa fa-arrow','utility:right');
        fafaLwcUtilityMap.put('fa fa-ban','utility:error');
        fafaLwcUtilityMap.put('fa fa-bolt','utility:thunder');
        fafaLwcUtilityMap.put('fa fa-check','utility:success'); 
        fafaLwcUtilityMap.put('fa fa-clone','utility:clone');
        fafaLwcUtilityMap.put('fa fa-close','utility:close');
        fafaLwcUtilityMap.put('fa fa-cloud-download','utility:download');
        fafaLwcUtilityMap.put('fa fa-cloud-upload','utility:upload');
        fafaLwcUtilityMap.put('fa fa-comments','utility:chat');
        fafaLwcUtilityMap.put('fa fa-exchange','utility:exchange');
        fafaLwcUtilityMap.put('fa fa-external-link','utility:open');
        fafaLwcUtilityMap.put('fa fa-eye','utility:preview');
        fafaLwcUtilityMap.put('fa fa-file','utility:page');
        fafaLwcUtilityMap.put('fa fa-file-pdf','utility:pdf_ext');
        fafaLwcUtilityMap.put('fa fa-file-pdf-o','utility:pdf_ext');
        fafaLwcUtilityMap.put('fa fa-file-text','utility:file');
        fafaLwcUtilityMap.put('fa fa-gavel','utility:thunder');
        fafaLwcUtilityMap.put('fa fa-level-up','utility:up');
        fafaLwcUtilityMap.put('fa fa-money','utility:currency');
        fafaLwcUtilityMap.put('fa fa-play','utility:play');
        fafaLwcUtilityMap.put('fa fa-plus-circle','utility:add');
        fafaLwcUtilityMap.put('fa fa-reply','utility:back');
        fafaLwcUtilityMap.put('fa fa-share','utility:share');
        fafaLwcUtilityMap.put('fa fa-share-square-o','utility:share_post');
        fafaLwcUtilityMap.put('fa fa-sign-in','utility:login');
        fafaLwcUtilityMap.put('fa fa-sign-out','utility:logout');
        fafaLwcUtilityMap.put('fa fa-sitemap','utility:hierarchy');
        fafaLwcUtilityMap.put('fa fa-sticky-note','utility:note');
        fafaLwcUtilityMap.put('fa fa-stop','utility:stop');
        fafaLwcUtilityMap.put('fa fa-tags','utility:tags');
        fafaLwcUtilityMap.put('fa fa-times','utility:close');
        fafaLwcUtilityMap.put('fa fa-trash','utility:delete');
        fafaLwcUtilityMap.put('fa fa-trophy','custom:custom48');
        fafaLwcUtilityMap.put('fa fa-undo','utility:undo');
        fafaLwcUtilityMap.put('fa fa-unlock','utility:unlock');
        fafaLwcUtilityMap.put('fa fa-paper-plane-o','utility:send');
        fafaLwcUtilityMap.put('glyphicon glyphicon-pencil','utility:edit');
        fafaLwcUtilityMap.put('glyphicon glyphicon-remove','utility:close');
        fafaLwcUtilityMap.put('glyphicon glyphicon-send','utility:send');
        fafaLwcUtilityMap.put('glyphicon glyphicon-thumbs-down','utility:dislike');
        fafaLwcUtilityMap.put('glyphicon glyphicon-thumbs-up','utility:like');
        fafaLwcUtilityMap.put('glyphicon glyphicon-trash','utility:delete');
        fafaLwcUtilityMap.put('fa fa-history','utility:skip_back');
        fafaLwcUtilityMap.put('fa fa-table','utility:table');
        fafaLwcUtilityMap.put('fa fa-coffee','utility:coffee');
        fafaLwcUtilityMap.put('fa fa-cubes','utility:cubes');
        fafaLwcUtilityMap.put('fa fa-star','utility:favorite');
        fafaLwcUtilityMap.put('fa fa-exclamation-triangle','utility:warning');
        fafaLwcUtilityMap.put('fa fa-line-chart','utility:graph');
        fafaLwcUtilityMap.put('fa fa-comment','utility:comments');
        fafaLwcUtilityMap.put('fa fa-caret-square-o-down','utility:down');
        fafaLwcUtilityMap.put('fa fa-wrench','utility:settings');
        fafaLwcUtilityMap.put('fa fa-share-square-o','utility:share');
        fafaLwcUtilityMap.put('fa fa-bolt','utility:lightning');
        fafaLwcUtilityMap.put('fa fa-trash-o','utility:delete');
        fafaLwcUtilityMap.put('glyphicon glyphicon-book','utility:knowledge_base');
        fafaLwcUtilityMap.put('fa fa-file-text-o','utility:contract_doc');
        fafaLwcUtilityMap.put('fa fa-wechat','utility:chat');
        fafaLwcUtilityMap.put('fa fa-paperclip','utility:attach');
        fafaLwcUtilityMap.put('fa fa-usd','utility:moneybag');
        fafaLwcUtilityMap.put('glyphicon glyphicon-tasks','utility:task');
        //fafaLwcUtilityMap.put('fa fa-trophy','utility:funding_award_adjustment');
        fafaLwcUtilityMap.put('fa fa-folder','utility:open_folder');
        fafaLwcUtilityMap.put('fa fa-paper-plane-o','utility:send');
        fafaLwcUtilityMap.put('fa fa-play','utility:play');
        fafaLwcUtilityMap.put('fa fa-folder-open-o','utility:opened_folder');
        fafaLwcUtilityMap.put('fa fa-check-square-o','utility:multi_select_checkbox');
        fafaLwcUtilityMap.put('fa fa-male','utility:user');

        return fafaLwcUtilityMap;
    }

    public static Map<String, String> getActionIconForClassic(){
    
        map<string,string> fafaLwcUtilityMap = new map<string,string>();
        fafaLwcUtilityMap.put('fa fa-pencil','utility:edit');
        fafaLwcUtilityMap.put('fa fa-arrow','utility:right');
        fafaLwcUtilityMap.put('fa fa-ban','utility:error');
        fafaLwcUtilityMap.put('fa fa-bolt','utility:thunder');
        fafaLwcUtilityMap.put('fa fa-check','utility:success'); 
        fafaLwcUtilityMap.put('fa fa-clone','utility:clone');
        fafaLwcUtilityMap.put('fa fa-close','utility:close');
        fafaLwcUtilityMap.put('fa fa-cloud-download','utility:download');
        fafaLwcUtilityMap.put('fa fa-cloud-upload','utility:upload');
        fafaLwcUtilityMap.put('fa fa-comments','utility:chat');
        fafaLwcUtilityMap.put('fa fa-exchange','utility:exchange');
        fafaLwcUtilityMap.put('fa fa-external-link','utility:open');
        fafaLwcUtilityMap.put('fa fa-eye','utility:preview');
        fafaLwcUtilityMap.put('fa fa-file','utility:page');
        fafaLwcUtilityMap.put('fa fa-file-pdf','utility:pdf_ext');
        fafaLwcUtilityMap.put('fa fa-file-pdf-o','utility:pdf_ext');
        fafaLwcUtilityMap.put('fa fa-file-text','utility:file');
        fafaLwcUtilityMap.put('fa fa-gavel','utility:thunder');
        fafaLwcUtilityMap.put('fa fa-level-up','utility:up');
        fafaLwcUtilityMap.put('fa fa-money','utility:currency');
        fafaLwcUtilityMap.put('fa fa-play','utility:play');
        fafaLwcUtilityMap.put('fa fa-plus-circle','utility:add');
        fafaLwcUtilityMap.put('fa fa-reply','utility:back');
        fafaLwcUtilityMap.put('fa fa-share','utility:share');
        fafaLwcUtilityMap.put('fa fa-share-square-o','utility:share_post');
        fafaLwcUtilityMap.put('fa fa-sign-in','utility:login');
        fafaLwcUtilityMap.put('fa fa-sign-out','utility:logout');
        fafaLwcUtilityMap.put('fa fa-sitemap','utility:hierarchy');
        fafaLwcUtilityMap.put('fa fa-sticky-note','utility:note');
        fafaLwcUtilityMap.put('fa fa-stop','utility:stop');
        fafaLwcUtilityMap.put('fa fa-tags','utility:tags');
        fafaLwcUtilityMap.put('fa fa-times','utility:close');
        fafaLwcUtilityMap.put('fa fa-trash','utility:delete');
        fafaLwcUtilityMap.put('fa fa-trophy','custom:custom48');
        fafaLwcUtilityMap.put('fa fa-undo','utility:undo');
        fafaLwcUtilityMap.put('fa fa-unlock','utility:unlock');
        fafaLwcUtilityMap.put('fa fa-paper-plane-o','utility:send');
        fafaLwcUtilityMap.put('glyphicon glyphicon-pencil','utility:edit');
        fafaLwcUtilityMap.put('glyphicon glyphicon-remove','utility:close');
        fafaLwcUtilityMap.put('glyphicon glyphicon-send','utility:send');
        fafaLwcUtilityMap.put('glyphicon glyphicon-thumbs-down','utility:dislike');
        fafaLwcUtilityMap.put('glyphicon glyphicon-thumbs-up','utility:like');
        fafaLwcUtilityMap.put('glyphicon glyphicon-trash','utility:delete');
        fafaLwcUtilityMap.put('fa fa-history','utility:skip_back');
        fafaLwcUtilityMap.put('fa fa-table','utility:table');
        fafaLwcUtilityMap.put('fa fa-coffee','utility:coffee');
        fafaLwcUtilityMap.put('fa fa-cubes','utility:cubes');
        fafaLwcUtilityMap.put('fa fa-star','utility:favorite');
        fafaLwcUtilityMap.put('fa fa-exclamation-triangle','utility:warning');
        fafaLwcUtilityMap.put('fa fa-line-chart','utility:graph');
        fafaLwcUtilityMap.put('fa fa-comment','utility:comments');
        fafaLwcUtilityMap.put('fa fa-caret-square-o-down','utility:down');
        fafaLwcUtilityMap.put('fa fa-wrench','utility:settings');
        fafaLwcUtilityMap.put('fa fa-share-square-o','utility:share');
        fafaLwcUtilityMap.put('fa fa-bolt','utility:lightning');
        fafaLwcUtilityMap.put('fa fa-trash-o','utility:delete');
        fafaLwcUtilityMap.put('glyphicon glyphicon-book','utility:knowledge_base');
        fafaLwcUtilityMap.put('fa fa-file-text-o','utility:contract_doc');
        fafaLwcUtilityMap.put('fa fa-wechat','utility:chat');
        fafaLwcUtilityMap.put('fa fa-paperclip','utility:attach');
        fafaLwcUtilityMap.put('fa fa-usd','utility:moneybag');
        fafaLwcUtilityMap.put('glyphicon glyphicon-tasks','utility:task');
        //fafaLwcUtilityMap.put('fa fa-trophy','utility:funding_award_adjustment');
        fafaLwcUtilityMap.put('fa fa-folder','utility:open_folder');
        fafaLwcUtilityMap.put('fa fa-paper-plane-o','utility:send');
        fafaLwcUtilityMap.put('fa fa-play','utility:play');
        fafaLwcUtilityMap.put('fa fa-folder-open-o','utility:opened_folder');
        fafaLwcUtilityMap.put('fa fa-check-square-o','utility:multi_select_checkbox');
        fafaLwcUtilityMap.put('fa fa-male','utility:user');

        return fafaLwcUtilityMap;
    }
    @AuraEnabled(cacheable=true)
    public static String getCommunityBaseUrl(){
        String networkId=Network.getNetworkId();
        if(networkId!=null){
            return Network.getLoginUrl(Network.getNetworkId()).replace('/login', '');            
        }else{
            return null;
        }        
    }

    @AuraEnabled(cacheable=true)
    public static String getSOBjectLabel(Id recordId) {
        String sObjectName = recordId.getSObjectType().getDescribe().getLabel();
        return sObjectName;
    }
}