global with sharing class DownloadCSVBatchHelper {
    public transient List<sObject> objectList;
    public string fieldNamesOfColumns;
    public transient Map<String,Double> totalNumberMap = new Map<String,Double>();
    public transient Map<String,String> fieldMap;
    public String objectName;
    public String[] sfields = new List<string>();
    public transient String[] fieldLabels;
    public transient DataTableConfig__c flexTable;
    public string mode{get;set;}
    public Boolean enableHideColumnLogic = false;
    private transient String flexTableParam;
    private transient String listParam;
    private transient boolean initialize;
    public String flexTableHeader; 
    public Map<String,String> fieldApiNameToDataType = new Map<String,String>();
    public  transient String newLine{get;set;}
    public transient String comma{get;set;}
    public transient List<String> forIterationOverSobject;
    public transient List<String> fieldApiNameLabel;
    // public transient List<FlexDataWrapper> flexDataWrapperList;
    // public List<FlexTableWrapper> flexTableWrapperList {get;set;}
    public List<Integer> index {get;set;}
    public transient Integer indexSize;
    public  Map<Integer,String>indexAPI{get;set;}
    public  Map<Integer,String>indexLabel{get;set;}
    public   Map<Integer,String>indexwidth;  
    public transient Component.Apex.OutputPanel body;
    private transient String html = '';
    public transient Boolean hideFlexTableHeaderInCSV{get;set;}
    private static boolean testForCsv = false;
    public String tableName{get;
            set{
                tableName = 'FlexTableSO1';
            if(mode=='text/csv' && testForCsv == false){
                 //fetchData('test');
                 testForCsv = true;
                }
            }
    } 
    public Set<String> setFieldTypesToTextAlignRight = new Set<String>{'CURRENCY', 'DECIMAL', 'DOUBLE', 'INTEGER', 'PERCENT'};
    global DownloadCSVBatchHelper() {
        newLine = '\n';
        comma = ',';
        hideFlexTableHeaderInCSV = KeyValueStoreHelper.getBooleanValue('HideFlexTableHeaderForCSV',true) == null? false : KeyValueStoreHelper.getBooleanValue('HideFlexTableHeaderForCSV',true); 
        
    }
public String uniqueField='';
public String objName;
    public Boolean useHistoryNameField = true;
    public List<String> exportFieldNames = new List<String>(); 
    private static Map<String, DataTableConfig__c> flexTableMap = new Map<String, DataTableConfig__c>();
    private static Map<String, List<String>> recIdsBytableName = new Map<String, List<String>>();
    private static Set<String> userFields = new Set<String>();
    private static Set<String> acctFields = new Set<String>();
    private static Map<String, Set<String>> recordFields = new Map<String, Set<String>>();
    private static User userRec;
    private static Account userAcctRec;
    private static Map<String, SObject> recordById = new Map<String, SObject>();
    public Map<String, DataTableDetailConfig__c> apiNameToFlexTableDetail;
    public static void addFlexTable(String tableName, String recordId) {
        if(recIdsBytableName.get(tableName) == null) {
            recIdsBytableName.put(tableName, new List<String>());
        }
        recIdsBytableName.get(tableName).add(recordId);
    }
    
    public String getFormattedNumber(Object numberValue, String strObjectName, String strFieldName){
        String formattedNumber = String.valueOf(numberValue);

        Integer fieldScale = 0;
        try{
            fieldScale = SchemaManager.getSObjectField(strObjectName, strFieldName).getDescribe().getScale();
        } catch(Exception exc){
            fieldScale = SchemaManager.getSObjectField(strObjectName, AppUtils.getNameSpacePrefix() + strFieldName).getDescribe().getScale();
        }
        try{
            if(String.isNotBlank(formattedNumber)){
                if(formattedNumber.indexOf('.') != -1){
                    List<String> formattedArray = formattedNumber.split('\\.');
                    if(formattedArray != null && !formattedArray.isEmpty()){
                        String strValue = formattedArray[0];
                        String strPrecision = formattedArray[1];
                        formattedNumber = strValue;
                        if(fieldScale != null && String.isNotBlank(strPrecision) && String.isNotBlank(strValue)){
                            fieldScale = fieldScale > 2 ? 2 : fieldScale;
                            String strScaleValue = strPrecision.substring(0, fieldScale > strPrecision.length() ? strPrecision.length() : fieldScale);
                            if(String.isNotBlank(strScaleValue)){
                                Integer intValue = Integer.valueOf(strScaleValue);
                                if(intValue != null && Math.mod(intValue, 10) == 0){
                                    intValue = intValue / 10;                                
                                }
                                formattedNumber += intValue != null && intValue != 0 ? + '.' + intValue : '';
                            }                        
                        }
                    }        
                }
            }
            return formattedNumber != null ? formattedNumber : '';
        } catch(Exception exc){
            return formattedNumber;
        }
    }

    public String getFormattedNumberCSV(Double numberValue, String strObjectName, String strFieldName){
            Decimal decValue = Decimal.valueOf(numberValue);
            Integer fieldScale = 2;
            try{
                fieldScale = SchemaManager.getSObjectField(strObjectName, strFieldName).getDescribe().getScale();
            } catch(Exception exc){
                fieldScale = SchemaManager.getSObjectField(strObjectName, AppUtils.getNameSpacePrefix() + strFieldName).getDescribe().getScale();
            }

            if(fieldScale > 2){
                decValue = decValue.setScale(2);
            }
            String formattedNumber = decValue.format();

            if(fieldScale > 1 && formattedNumber.indexOf('.') != -1 && formattedNumber.length() - formattedNumber.indexOf('.') < 3){
                return formattedNumber + 0;
            }else if(formattedNumber.indexOf('.') == -1){
                return formattedNumber += fieldScale > 1 ? +'.00':'.0';
            }
            return formattedNumber; 
        }

    public static void getTableRecords() {
        if(!recIdsBytableName.isEmpty()){
            //if(Schema.sObjectType.DataTableConfig__c.isAccessible() && Schema.sObjectType.DataTableDetailConfig__c.isAccessible() && Schema.sObjectType.FlexTableListViewUserConfig__c.isAccessible() && Schema.sObjectType.FlexTableFilterListViewConfig__c.isAccessible()){
            if(DataTableConfig__c.sObjectType.getDescribe().isAccessible() == true && DataTableDetailConfig__c.sObjectType.getDescribe().isAccessible() == true && FlexTableListViewUserConfig__c.sObjectType.getDescribe().isAccessible() == true && FlexTableFilterListViewConfig__c.sObjectType.getDescribe().isAccessible() == true){
                List<DataTableConfig__c> flexTableRecords ;
                for(DataTableConfig__c dataTable : [SELECT id,Name,FieldNames__c,FilterCriteria__c,Header__c,HelpConfig__c,OrderBy__c,SObject__c,SkipFieldsForExport__c
                                        ,SobjectConfig__r.Name,RecordTypeId,HeaderIconDocumentName__c,PDFRenderType__c,Sort_Direction__c,SubHeader__c,
                                        (select id,FieldAPIName__c,FieldLabelOverride__c,FieldWidth__c,HideColumnJSON__c from Flex_Table_Detail_Configs__r),
                                        (SELECT Id,FlexTableListViewConfig__c,FlexTableListViewConfig__r.Label__c,FlexTableListViewConfig__r.FilterClause__c FROM 
                                                Flex_Table_List_View_User_Configs__r where User__c=:UserInfo.getUserId()),
                                        (SELECT Id,IsActive__c,Label__c,ShowinPDF__c,FilterClause__c FROM Flex_Table_Filter_List_View_Configs__r) 
                                        FROM DataTableConfig__c 
                                        WHERE Name = : recIdsBytableName.KeySet() WITH USER_MODE]) {
                    flexTableMap.put(dataTable.Name, dataTable);
                    getUserMergeFields(dataTable);
                    getAcctMergeFields(dataTable);
                    getRecordMergeFields(dataTable);
                }
            }
        }
        getAllRecords();
    }
    
    private static void replaceMergeFields(DataTableConfig__c flexTableRec, String recordId) {
        if(userFields.size() > 0) {
            replaceUserMergeFields(flexTableRec);
        }
        if(acctFields.size() > 0) {
            replaceAcctMergeFields(flexTableRec);
        }
        if(String.isEmpty(recordId)){
            return;
        }
        SObject rec = recordById.get(recordId);
        if(rec != null) {
            String sObjectAPIName = String.valueOf( rec.getSObjectType() );
           if(recordFields.get(sObjectAPIName) != null && recordFields.get(sObjectAPIName).size() > 0) {
                replaceRecordMergeFields(flexTableRec, rec, recordFields.get(sObjectAPIName));
            }
        }
    }
    
    private static void replaceRecordMergeFields(DataTableConfig__c flexTable, SObject rec, Set<String> fieldsToReplace) {
        String sObjectAPIName = String.valueOf( rec.getSObjectType() );
        for(FlexTableListViewUserConfig__c listViewUser : flexTable.Flex_Table_List_View_User_Configs__r) {
            if(listViewUser.FlexTableListViewConfig__r.FilterClause__c != Null) {
                for(String userField : fieldsToReplace) {
                    Object fieldVal = AppUtils.getFieldValue(rec, userField);
                    String fieldStrVal = fieldVal != null ? String.escapeSingleQuotes(string.valueOf(fieldVal)) : '';
                    listViewUser.FlexTableListViewConfig__r.FilterClause__c = listViewUser.FlexTableListViewConfig__r.FilterClause__c.replace('{!' + sObjectAPIName + '.' + userField + '}',
                                            fieldStrVal);
                }
            }
        }
        for(FlexTableFilterListViewConfig__c flexAction : flexTable.Flex_Table_Filter_List_View_Configs__r) {
                if(flexAction.IsActive__c == true && flexAction.FilterClause__c != null) {
                    for(String userField : fieldsToReplace) {
                        Object fieldVal = AppUtils.getFieldValue(rec, userField);
                        String fieldStrVal = fieldVal != null ? String.escapeSingleQuotes(string.valueOf(fieldVal)) : '';
                        flexAction.FilterClause__c = flexAction.FilterClause__c.replace('{!' + sObjectAPIName + '.' + userField + '}',
                                                fieldStrVal);
                    }
                }
                
        }
        if(String.isNotEmpty( flexTable.FilterCriteria__c)) {
            for(String userField : fieldsToReplace) {
                Object fieldVal = AppUtils.getFieldValue(rec, userField);
                String fieldStrVal = fieldVal != null ? String.escapeSingleQuotes(string.valueOf(fieldVal)) : '';
                flexTable.FilterCriteria__c = flexTable.FilterCriteria__c.replace('{!' + sObjectAPIName + '.' + userField + '}',
                                        fieldStrVal);
            }
        } 
        
    }
    
    private static void replaceUserMergeFields(DataTableConfig__c flexTable) {
        for(FlexTableListViewUserConfig__c listViewUser : flexTable.Flex_Table_List_View_User_Configs__r) {
            if(listViewUser.FlexTableListViewConfig__r.FilterClause__c != Null) {
                for(String userField : userFields) {
                    Object fieldVal = AppUtils.getFieldValue(userRec, userField);
                    String fieldStrVal = fieldVal != null ? String.escapeSingleQuotes(string.valueOf(fieldVal)) : '';
                    listViewUser.FlexTableListViewConfig__r.FilterClause__c = listViewUser.FlexTableListViewConfig__r.FilterClause__c.replace('{!User.' + userField + '}',
                                            fieldStrVal);
                }
            }
        }
        for(FlexTableFilterListViewConfig__c flexAction : flexTable.Flex_Table_Filter_List_View_Configs__r) {
                if(flexAction.IsActive__c == true &&  flexAction.FilterClause__c != null) {
                    for(String userField : userFields) {
                        Object fieldVal = AppUtils.getFieldValue(userRec, userField);
                        String fieldStrVal = fieldVal != null ? String.escapeSingleQuotes(string.valueOf(fieldVal)) : '';
                        flexAction.FilterClause__c = flexAction.FilterClause__c.replace('{!User.' + userField + '}',
                                                fieldStrVal);
                    }
                }
        }
        if(String.isNotEmpty( flexTable.FilterCriteria__c)) {
            for(String userField : userFields) {
                Object fieldVal = AppUtils.getFieldValue(userRec, userField);
                String fieldStrVal = fieldVal != null ? String.escapeSingleQuotes(string.valueOf(fieldVal)) : '';
                flexTable.FilterCriteria__c = flexTable.FilterCriteria__c.replace('{!User.' + userField + '}',
                                        fieldStrVal);
            }
        } 
    }
    
    private static void replaceAcctMergeFields(DataTableConfig__c flexTable) {
        for(FlexTableListViewUserConfig__c listViewUser : flexTable.Flex_Table_List_View_User_Configs__r) {
            if(listViewUser.FlexTableListViewConfig__r.FilterClause__c != Null) {
                for(String userField : acctFields) {
                    Object fieldVal = AppUtils.getFieldValue(userAcctRec, userField);
                    String fieldStrVal = fieldVal != null ? String.escapeSingleQuotes(string.valueOf(fieldVal)) : '';
                    listViewUser.FlexTableListViewConfig__r.FilterClause__c = listViewUser.FlexTableListViewConfig__r.FilterClause__c.replace('{!Account.' + userField + '}',
                                            fieldStrVal);
                }
            }
        }
        for(FlexTableFilterListViewConfig__c flexAction : flexTable.Flex_Table_Filter_List_View_Configs__r) {
                if(flexAction.IsActive__c == true &&  flexAction.FilterClause__c != null) {
                    for(String userField : acctFields) {
                        Object fieldVal = AppUtils.getFieldValue(userAcctRec, userField);
                        String fieldStrVal = fieldVal != null ? String.escapeSingleQuotes(string.valueOf(fieldVal)) : '';
                        flexAction.FilterClause__c = flexAction.FilterClause__c.replace('{!Account.' + userField + '}',
                                                fieldStrVal);
                    }
                }
                
        }
        if(String.isNotEmpty( flexTable.FilterCriteria__c)) {
            for(String userField : acctFields) {
                Object fieldVal = AppUtils.getFieldValue(userAcctRec, userField);
                String fieldStrVal = fieldVal != null ? String.escapeSingleQuotes(string.valueOf(fieldVal)) : '';
                flexTable.FilterCriteria__c = flexTable.FilterCriteria__c.replace('{!Account.' + userField + '}',
                                        fieldStrVal);
            }
        }
    }
    
    private static void getAllRecords() {
        getUserRecord();
        getAccountRecord();
        List<String> recordIds = new List<String>();
        for(List<String> records :  recIdsBytableName.Values()) {
            recordIds.addAll(records);
        }
        if(recordIds.size() > 0) {
            for(String objectAPIName : recordFields.KeySet()) {
                //String objectAPIName = flexTableMap.get(tableName).SObject__c;
                if(recordFields.get(objectAPIName) != null && recordFields.get(objectAPIName).size() > 0) {
                    List<String> fieldsToQuery = new List<String>();
                    fieldsToQuery.addAll(recordFields.get(objectAPIName));
                    String recQuery = 'select ' + String.escapeSingleQuotes(String.join(fieldsToQuery, ',')) + ' from ' + String.escapeSingleQuotes(objectAPIName) + ' where Id in:recordIds' ;
                    List<SObject> records  ;
                    for(SObject sobj : Database.query(String.escapeSingleQuotes(recQuery), AccessLevel.USER_MODE)) { //SOQL Injection - False +ve - Dynamic part of query is escapeSingleQuotes/static bind
                        recordById.put(sobj.Id, sobj);
                    }
                }
            }//101
           recordIds = null;
        }
    }
    
    private static void getAccountRecord() {
        if(acctFields.size() > 0) {
            userFields.add('OrganizationId__c');
            getUserRecord();
            if(userRec.OrganizationId__c == null) {
                throw new CustomExceptions.InputDataException('No organization associated with User. Please contact administrator');
            }
            List<String> fieldsToQuery = new List<String>();
            fieldsToQuery.addAll(acctFields);
            String userAccount =  userRec.OrganizationId__c;
            String accQuery = 'select ' + String.escapeSingleQuotes(String.join(fieldsToQuery, ',')) + ' from Account where Id= :userAccount ' ;
            List<Account> accts;
            if(Schema.sObjectType.Account.isAccessible()) {
                accts = Database.query(String.escapeSingleQuotes(accQuery), AccessLevel.USER_MODE); //SOQL Injection - False +ve - Dynamic part of query is static bind
            }
            if(accts.size() == 0) {
                throw new CustomExceptions.InputDataException('Ornization associated with user is not valid. Please contact administrator. Org id:' + userRec.OrganizationId__c);
            }
            userAcctRec = accts[0];
            accts = null;//101
            fieldsToQuery = null;//101
        }
    }
    
    private static void getUserRecord() {
        if(userRec == null && userFields.size() > 0) {
            List<String> fieldsToQuery = new List<String>();
            fieldsToQuery.addAll(userFields); 
            String currentUserId = UserInfo.getUserId();
            String userRecQuery = 'select ' + String.join(fieldsToQuery, ',') + ' from User where Id=:currentUserId   ' ; //CRUD/FLS False +ve As per business scenario we can't check for portal/external users
            userRec = Database.query(String.escapeSingleQuotes(userRecQuery),AccessLevel.USER_MODE); //SOQL Injection - False +ve - Dynamic part of query is static bind
            fieldsToQuery = null;//101
        }
    }
    
    private static Map<String, String> getMergeFields(String filterString, String regex) {
        Pattern regexForExtractingUserFields = Pattern.compile(regex); 
        Matcher regexMatcherForExtractingUserTokens = regexForExtractingUserFields.matcher(filterString);        
             
        Map<String, String> userFieldsToQueryMap = new Map<String, String>();
        while (regexMatcherForExtractingUserTokens.find()) {//SOQL/SOSL Injection False +ve         
            String userToken = regexMatcherForExtractingUserTokens.group();
            String userTokenAfterRemove = userToken.substring(2,userToken.length()-1); 
            List<String> userSplitField = userTokenAfterRemove.split('\\.', 2);
            userFieldsToQueryMap.put(userToken, userSplitField[1]);
        }
        return userFieldsToQueryMap;
    }
    
    private static void getUserMergeFields(DataTableConfig__c flexTable) {
        String regex = '\\{!(User\\.[a-zA-Z0-9\\.\\_]+)\\}'; 
        for(FlexTableListViewUserConfig__c listViewUser : flexTable.Flex_Table_List_View_User_Configs__r) {
            if(listViewUser.FlexTableListViewConfig__r.FilterClause__c != Null) {
                Map<String, String> mergeFields = getMergeFields(listViewUser.FlexTableListViewConfig__r.FilterClause__c, regex);
                userFields.addAll(mergeFields.values());
            }
        }
        for(FlexTableFilterListViewConfig__c flexAction : flexTable.Flex_Table_Filter_List_View_Configs__r) {
                if(flexAction.IsActive__c == true  && flexAction.FilterClause__c != null) {
                    Map<String, String> mergeFields = getMergeFields(flexAction.FilterClause__c, regex);
                    userFields.addAll(mergeFields.values());
                }
        }
        if(String.isNotEmpty( flexTable.FilterCriteria__c)) {
            Map<String, String> mergeFields = getMergeFields(flexTable.FilterCriteria__c, regex);
            userFields.addAll(mergeFields.values());
        }
    }
    
    
    private static void getAcctMergeFields(DataTableConfig__c flexTable) {
        String regex = '\\{!(Account\\.[a-zA-Z0-9\\.\\_]+)\\}'; 
        for(FlexTableListViewUserConfig__c listViewUser : flexTable.Flex_Table_List_View_User_Configs__r) {
            if(listViewUser.FlexTableListViewConfig__r.FilterClause__c != Null) {
                Map<String, String> mergeFields = getMergeFields(listViewUser.FlexTableListViewConfig__r.FilterClause__c, regex);
                acctFields.addAll(mergeFields.values());
            }
        }
        for(FlexTableFilterListViewConfig__c flexAction : flexTable.Flex_Table_Filter_List_View_Configs__r) {
                if(flexAction.IsActive__c == true  && flexAction.FilterClause__c != null) {
                    Map<String, String> mergeFields = getMergeFields(flexAction.FilterClause__c, regex);
                    acctFields.addAll(mergeFields.values());
                }
        }
        if(String.isNotEmpty( flexTable.FilterCriteria__c)) {
            Map<String, String> mergeFields = getMergeFields(flexTable.FilterCriteria__c, regex);
            acctFields.addAll(mergeFields.values());
        }
    }
    
    private static void getRecordMergeFields(DataTableConfig__c flexTable) {
        List<String> recordIds = recIdsBytableName.get(flexTable.Name);
        if(recordIds == null || recordIds.size() == 0) {
            return;
        }
        String recordId = recIdsBytableName.get(flexTable.Name)[0];
        if(String.isEmpty(recordId)){
            return;
        }
        String objName = Id.valueOf(recordId).getSObjectType().getDescribe().getName();
        String regex = '\\{!(' + objName + '\\.[a-zA-Z0-9\\.\\_]+)\\}'; 
        
        for(FlexTableListViewUserConfig__c listViewUser : flexTable.Flex_Table_List_View_User_Configs__r) {
            if(listViewUser.FlexTableListViewConfig__r.FilterClause__c != Null) {
                Map<String, String> mergeFields = getMergeFields(listViewUser.FlexTableListViewConfig__r.FilterClause__c, regex);
                if(recordFields.get(objName) == null) {
                    recordFields.put(objName, new Set<String>());
                }
                recordFields.get(objName).addAll(mergeFields.values());
                
            }
        } 
        for(FlexTableFilterListViewConfig__c flexAction : flexTable.Flex_Table_Filter_List_View_Configs__r) {
                if(flexAction.IsActive__c == true &&  flexAction.FilterClause__c != null) {
                    Map<String, String> mergeFields = getMergeFields(flexAction.FilterClause__c, regex);
                    if(recordFields.get(objName) == null) {
                        recordFields.put(objName, new Set<String>());
                    }
                    recordFields.get(objName).addAll(mergeFields.values());
                }
        }
        if(String.isNotEmpty( flexTable.FilterCriteria__c )) {
            Map<String, String> mergeFields = getMergeFields(flexTable.FilterCriteria__c, regex);
            if(recordFields.get(objName) == null) {
                recordFields.put(objName, new Set<String>());
            }
            recordFields.get(objName).addAll(mergeFields.values());
        }
    }
    
    public static String recordIdToProcess;
    public string fetchData(String tableName,String recordId ,Map<String, String> urlParams,Map<String, Object> urlParamsMap)  {
        String listViewFilterClause;
        flexTable = flexTableMap.get(tableName);
        
        recordId = recordIdToProcess != null ? recordIdToProcess : recordId;
        if(String.isnotEmpty(recordId)) {
            recordId = String.valueOf(Id.valueOf(recordId));
        }
        if(String.isEmpty( recordId ) || tableName == 'History' || flexTable ==null) {
            String strFlexTableParam =null;// ApexPages.currentPage().getParameters().containsKey('flexTableParam') ? ApexPages.currentPage().getParameters().get('flexTableParam') : null;
            if(String.isNotBlank(strFlexTableParam)){
                flexTableParam = EncodingUtil.urlDecode(strFlexTableParam,'UTF-8');
                Map<string, object> mergeFieldsKeyValueMap = ((Map<string,object>)JSON.deserializeUntyped(flexTableParam));    
                if(mergeFieldsKeyValueMap.containsKey('RecordId')) {
                    recordId = (String)mergeFieldsKeyValueMap.get('RecordId');   
                    recordId = String.escapeSingleQuotes(String.valueOf(Id.valueOf(recordId)));
                }
            }
            addFlexTable(tableName, recordId);
            getTableRecords();
            flexTable = flexTableMap.get(tableName);
        }
        
        flexTable = flexTable.clone(true, true, true, true);
        replaceMergeFields(flexTable, recordId);
        
        flexTableHeader = flexTable.Header__c;
        if(flexTable.Flex_Table_List_View_User_Configs__r != null) {
            for(FlexTableListViewUserConfig__c listViewUser : flexTable.Flex_Table_List_View_User_Configs__r) {
                if(listViewUser.FlexTableListViewConfig__r.FilterClause__c != Null) {
                    listViewFilterClause = listViewUser.FlexTableListViewConfig__r.FilterClause__c;
                    flexTableHeader = listViewUser.FlexTableListViewConfig__r.Label__c;
                }
            }                                                          
        }
            
        String recordTypeName = Schema.SObjectType.DataTableConfig__c.getRecordTypeInfosById().get(flexTable.RecordTypeId).getname();                         
        if(recordTypeName == 'Data Table Enhanced'){
            objectName = flexTable.SobjectConfig__r.Name;
            enableHideColumnLogic = true;
        }else{
            objectName = flexTable.SObject__c; 
        }                        
         useHistoryNameField = true;
        List<ID> recordsList = new List<Id>();  
        recordsList.add(recordId); 
        if(recordId != Null) {
            objName = Id.valueOf(recordId).getSObjectType().getDescribe().getName();
        }else {
            objName = objectName;
        }
        
        fieldLabels = new List<string>();
        fieldMap = new Map<String,String>();
        forIterationOverSobject = new List<string>();
        fieldApiNameLabel = new List<String>();
        index  = new List<Integer>();
        indexAPI = new Map<Integer,String>();
        indexLabel = new Map<Integer,String>();
        indexwidth = new Map<Integer,String>();
        Map<String, string> hideColumnJSON = new Map<String, string>();
        apiNameToFlexTableDetail = new Map<String, DataTableDetailConfig__c>();
        for(DataTableDetailConfig__c dataTableDetail : flexTable.Flex_Table_Detail_Configs__r) {
            hideColumnJSON.put(dataTableDetail.FieldAPIName__c,dataTableDetail.HideColumnJSON__c); 
            apiNameToFlexTableDetail.put(dataTableDetail.FieldAPIName__c, dataTableDetail);
        }        
        Integer i=0;
        List<String> flexFieldNames = flexTable.FieldNames__c.split(',');
         SObject record;
         if(recordId != Null && hideColumnJSON != null && enableHideColumnLogic){
            Id myId = (Id)recordId;
            Schema.SObjectType sobjectType = myId.getSObjectType();
            String sobjectName = sobjectType.getDescribe().getName();
            Map<String, Schema.SObjectField> objectFields = Schema.getGlobalDescribe().get(sobjectName).getDescribe().fields.getMap();
            String fieldName = '';
            for(String s : objectFields.keySet()) {
            fieldName += ' ' + s + ',';
           }
           fieldName = fieldName.removeEnd(',');
           if(AppUtils.isObjectAccessible(sobjectName)){ //CRUD/FLS False +ve with the help of AppUtils we have performed check
            record = Database.query('Select '+string.escapeSingleQuotes(fieldName) + ' From ' + string.escapeSingleQuotes(sobjectName) + ' Where Id = :myId',AccessLevel.USER_MODE);//SOQL Injection - False +ve - Dynamic parts of the query string is ecsapeSingleQuotes to prevent SOQL Injection
           }
        }
        


        Set<string> exportFieldNamesSet = new Set<string>();
       // List<String> exportFieldNames = new List<String>();
        if(!String.isEmpty(flexTable.SkipFieldsForExport__c)) {
            List<String> skipExportFieldNames = flexTable.SkipFieldsForExport__c.split(',');
            Set<String> skipExportFieldNamesSet = new Set<String>(skipExportFieldNames); 
            for(String flexField : flexFieldNames) {
                if(!skipExportFieldNamesSet.contains(flexField)) {
                    exportFieldNames.add(flexField);
                }
            }
        }
        else {
              
            exportFieldNames = flexTable.FieldNames__c.split(',');
            if(enableHideColumnLogic && hideColumnJSON != null && record != null){
               exportFieldNamesSet =removeHideColumn(exportFieldNames,record,hideColumnJSON);
               List<String> lStrings = new List<String>(exportFieldNamesSet);
               exportFieldNames = lStrings;
            }
           
        }
         
        for(string s: exportFieldNames) {
            s = s.trim();
            //5. Find if a given field is a lookup field. If yes, get its respective name.
            if(s == 'OldValue' || s == 'NewValue' && objectName !=null){
                objectName= objectName.contains('__c')?objectName.replace('__c','__History'):objectName;
            }
            SchemaManager.Field fld = SchemaManager.getFieldSchemaResult(objectName,s.trim());            
            String fielName = s;
            String originalFielName = s;
            fielName = fielName.replaceAll(AppUtils.getNameSpacePrefix(),'');
            String type = fld.fieldDesc.getType()+'';
            if(type!='ID' && type!='REFERENCE'){ 
                forIterationOverSobject.add(fielName.trim());
                fieldApiNameToDataType.put(fielName.trim(),type);
                fieldApiNameLabel.add(fld.fieldDesc.getLabel()+'');
            }           
            String dataType = String.ValueOf(fld.fieldDesc.getType()) ;
            if(String.ValueOf(fld.fieldDesc.getType()) == 'REFERENCE') {
                if(s.containsIgnoreCase('CreatedById') || s.containsIgnoreCase('RecordTypeId') || s.containsIgnoreCase('LastModifiedById') || s.containsIgnoreCase('OwnerId') || s.containsIgnoreCase('ParentId') || s.containsIgnoreCase('ContactId') || s.containsIgnoreCase('AccountId') || s.containsIgnoreCase('ProfileId')) {
                    s = s.toLowerCase().replace('id', '.Name');
                } else {
                 //Bug 178572: Internal- Relationship field does not support in the PDF/XLS
                  // s = s;
                    s = s.substringBefore('__c');
                    s = s + '__r.Name';
                }  
            }       
            //Strip off the Id field    
            if(s != 'Id') {
                //CSV: Get the field labels. Else it shows API Names
                fieldLabels.add(String.ValueOf(fld.fieldDesc.getLabel()));
                //list of fields for query
                string namespace = AppUtils.getNameSpacePrefix();
                if(s.startsWithIgnoreCase(namespace) && objectName.startsWithIgnoreCase(namespace)) {
                    s = s.substringAfter(namespace);
                    s = s.replaceAll(namespace, '');
                }
                sfields.add(s);
                indexAPI.put(i,s);                                
                       
                if(s.containsIgnoreCase('createdby.Name') && tableName == 'History') {
                    indexLabel.put(i,apiNameToFlexTableDetail.get(originalFielName) != null && apiNameToFlexTableDetail.get(originalFielName).FieldLabelOverride__c != null ? apiNameToFlexTableDetail.get(originalFielName).FieldLabelOverride__c : Label.ChangedBy);
                }else if(s.containsIgnoreCase('CreatedDate') && tableName == 'History') {
                    indexLabel.put(i,apiNameToFlexTableDetail.get(originalFielName) != null && apiNameToFlexTableDetail.get(originalFielName).FieldLabelOverride__c != null ? apiNameToFlexTableDetail.get(originalFielName).FieldLabelOverride__c : Label.ChangedOn);
                }else if(s.containsIgnoreCase('owner.Name')){
                    indexLabel.put(i,apiNameToFlexTableDetail.get(originalFielName) != null && apiNameToFlexTableDetail.get(originalFielName).FieldLabelOverride__c != null ? apiNameToFlexTableDetail.get(originalFielName).FieldLabelOverride__c : Label.AssignedTo);
                }else {
                    //indexLabel.put(i,apiNameToFlexTableDetail.get(originalFielName) != null && apiNameToFlexTableDetail.get(originalFielName).FieldLabelOverride__c != null ? apiNameToFlexTableDetail.get(originalFielName).FieldLabelOverride__c : fld.fieldDesc.getLabel());
                    String fieldLabel = fld.fieldDesc.getLabel()+'';
                    fieldLabel = (originalFielName.contains('CreatedById')) ? Label.CreatedBy :
                                    (originalFielName.contains('LastModifiedById')) ? Label.LastModifiedBy :
                                    (originalFielName.contains('ContactId')) ? Label.Contact :
                                    (originalFielName.contains('OwnerId')) ? Label.AssignedTo :
                                    (originalFielName.contains('RecordTypeId')) ? Label.RecordType :
                                    (originalFielName.contains('ActivityDate')) ? Label.DueDate :
                                    fieldLabel;
                    if(apiNameToFlexTableDetail.get(originalFielName) != null && apiNameToFlexTableDetail.get(originalFielName).FieldLabelOverride__c != null) {
                        fieldLabel = apiNameToFlexTableDetail.get(originalFielName).FieldLabelOverride__c;
                }
                    indexLabel.put(i,fieldLabel);
                }

                fieldMap.put(s,fld.fieldDesc.getLabel());
                indexwidth.put(i, apiNameToFlexTableDetail.get(originalFielName) != null && apiNameToFlexTableDetail.get(originalFielName).FieldWidth__c != null ? apiNameToFlexTableDetail.get(originalFielName).FieldWidth__c +'%'  :'');      
                index.add(i);      
                i++;                               
            }               
            indexSize = index.size();
        }
        
        fieldLabels.sort();
        sfields.sort();
        string fieldNames = AppUtils.fieldsList(sfields);
        // Check the filter param
        String whereClause;
        String limitClause;
        List<String> enableInPdf = new List<String>();
        //6. Frame & execute the query
        List<String> fieldNamesLst = fieldNames.split(',');
        List<String> updatedFieldNamesLst = fieldNames.split(',');
        for(String fieldName : fieldNamesLst){
            SObjectType r = ((SObject)(Type.forName('Schema.'+objectName).newInstance())).getSObjectType();
            if(fieldName.contains('.')){
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
                                if(RefDisplayType != null && RefDisplayType == Schema.DisplayType.PICKLIST ){
                                    // fieldNames = fieldNames.replace(fieldName,'toLabel('+fieldName+')');
                                        Integer index = updatedFieldNamesLst.indexOf(fieldName);
                                        if(index != -1){
                                            updatedFieldNamesLst.remove(index);
                                            updatedFieldNamesLst.add(index,'toLabel('+fieldName+')');
                                        }
                                }
                            }
                         }

                    }
                }
            }
            DescribeSObjectResult d = r.getDescribe();
            Schema.DisplayType type;
            if(d.fields.getMap().get(fieldName) !=  null){
                type =  d.fields.getMap().get(fieldName).getDescribe().getType();
            }
            if(type != null && type == Schema.DisplayType.PICKLIST && fieldName.containsIgnoreCase('__c')){
              // fieldNames = fieldNames.replace(fieldName,'toLabel('+fieldName+')');
                Integer index = updatedFieldNamesLst.indexOf(fieldName);
                if(index != -1 && index < updatedFieldNamesLst.size()){
                    updatedFieldNamesLst.add(index,'toLabel('+fieldName+')');
                    updatedFieldNamesLst.remove(index+1);
                }
            }
        }
        
        for(string s : updatedFieldNamesLst){
              s=AppUtils.getNameSpacePrefix()+s;
        }

        fieldNames = AppUtils.fieldsList(updatedFieldNamesLst);
        fieldNamesOfColumns = fieldNames;
        string query = 'SELECT ' +String.escapeSingleQuotes(fieldNames) + ' FROM ' + String.escapeSingleQuotes(objectName);         
        if(whereClause == null && flexTable.FilterCriteria__c != null && flexTable.FilterCriteria__c != ''){
            Map<String,Object> mergeFieldsKeyValueMap = new Map<String,Object>(); 
           
            if(urlParamsMap.size() > 0){
                mergeFieldsKeyValueMap = urlParamsMap;           
            }
            //temp fix
            if(FlexLayoutPrintGenerator.isFormSelected) {
                mergeFieldsKeyValueMap.put('parentId', recordId);
                mergeFieldsKeyValueMap.put('recordId', (String)FlexLayoutPrintGenerator.selectedLayoutHolder.formRecordMap.get(FlexLayoutPrintGenerator.selectedLayotId).get('Id'));
            }
            mergeFieldsKeyValueMap.put('parentRecordIdOfFlexTable',recordId);
            if( mergeFieldsKeyValueMap.size() > 0) {
                whereClause = new FlexTableCtrl().getFilterClauseString(flexTable.FilterCriteria__c, mergeFieldsKeyValueMap, false);
                limitClause = KeyValueStoreHelper.getTextValue('LimitFlexTableRowsOnDynamicLayout',true);
                if(!String.isEmpty(whereClause) && !String.isEmpty(limitClause) ){
                    whereClause = whereClause+limitClause;
                }   
            }
            if(listViewFilterClause != Null && mergeFieldsKeyValueMap.size() > 0) { 
                whereClause = new FlexTableCtrl().getFilterClauseString(listViewFilterClause, mergeFieldsKeyValueMap, false);
                limitClause = KeyValueStoreHelper.getTextValue('LimitFlexTableRowsOnDynamicLayout',true);
                if(!String.isEmpty(whereClause) && !String.isEmpty(limitClause) ){
                    whereClause = whereClause+limitClause;
                } 
            }else if(listViewFilterClause != Null) {
                whereClause = listViewFilterClause;
            }
            if(String.isEmpty(whereClause)) {
                whereClause = flexTable.FilterCriteria__c;
            }
             mergeFieldsKeyValueMap = null;//101   
        }
        if(!String.isEmpty(whereClause)){
            query += ' WHERE ';
            query +=  whereClause;
        }
        if(flexTable.OrderBy__c!= null && flexTable.OrderBy__c!= ''){
            query += ' WITH USER_MODE order By ';
            query += String.escapeSingleQuotes(flexTable.OrderBy__c);
            if(flexTable.Sort_Direction__c != null && flexTable.Sort_Direction__c != '' && !flexTable.OrderBy__c.contains(',')) {
                query += ' ' + String.escapeSingleQuotes(flexTable.Sort_Direction__c);
            }
        }else{
            query += ' WITH USER_MODE ';
        }          
        if(flexTable.Flex_Table_Filter_List_View_Configs__r.size() > 1) {
            for(FlexTableFilterListViewConfig__c flexAction : flexTable.Flex_Table_Filter_List_View_Configs__r) {
                if(flexAction.IsActive__c == true && flexAction.ShowinPDF__c == true) {
                    enableInPdf.add(flexAction.Label__c);
                }
            }
        }
       return query;
    }

    public static Map<String, String> getDownloadCSVIcon(){

        map<string,string> DownloadCSVIconMap = new map<string,string>();
        DownloadCSVIconMap.put('fa fa-pencil','utility:edit');
        DownloadCSVIconMap.put('fa fa-arrow','utility:right');
        DownloadCSVIconMap.put('fa fa-ban','utility:close');
        DownloadCSVIconMap.put('fa fa-bolt','utility:thunder');
        DownloadCSVIconMap.put('fa fa-check','utility:success'); 
        DownloadCSVIconMap.put('fa fa-clone','utility:clone');
        DownloadCSVIconMap.put('fa fa-close','utility:close');
        DownloadCSVIconMap.put('fa fa-cloud-download','utility:download');
        DownloadCSVIconMap.put('fa fa-cloud-upload','utility:upload');
        DownloadCSVIconMap.put('fa fa-comments','utility:chat');
        DownloadCSVIconMap.put('fa fa-exchange','utility:exchange');
        DownloadCSVIconMap.put('fa fa-external-link','utility:open');
        DownloadCSVIconMap.put('fa fa-eye','utility:preview');
        DownloadCSVIconMap.put('fa fa-file','utility:page');
        DownloadCSVIconMap.put('fa fa-file-pdf','utility:file_pdf');
        DownloadCSVIconMap.put('fa fa-file-text','utility:file');
        DownloadCSVIconMap.put('fa fa-gavel','utility:thunder');
        DownloadCSVIconMap.put('fa fa-level-up','utility:up');
        DownloadCSVIconMap.put('fa fa-money','utility:currency');
        DownloadCSVIconMap.put('fa fa-play','utility:play');
        DownloadCSVIconMap.put('fa fa-plus-circle','utility:add');
        DownloadCSVIconMap.put('fa fa-reply','utility:back');
        DownloadCSVIconMap.put('fa fa-share','utility:share');
        DownloadCSVIconMap.put('fa fa-share-square-o','utility:share_post');
        DownloadCSVIconMap.put('fa fa-sign-in','utility:login');
        DownloadCSVIconMap.put('fa fa-sign-out','utility:logout');
        DownloadCSVIconMap.put('fa fa-sitemap','utility:hierarchy');
        DownloadCSVIconMap.put('fa fa-sticky-note','utility:note');
        DownloadCSVIconMap.put('fa fa-stop','utility:stop');
        DownloadCSVIconMap.put('fa fa-tags','utility:tags');
        DownloadCSVIconMap.put('fa fa-times','utility:close');
        DownloadCSVIconMap.put('fa fa-trash','utility:delete');
        DownloadCSVIconMap.put('fa fa-trophy','custom:custom48');
        DownloadCSVIconMap.put('fa fa-undo','utility:undo');
        DownloadCSVIconMap.put('fa fa-unlock','utility:unlock');
        DownloadCSVIconMap.put('fa fa-paper-plane-o','utility:send');
        DownloadCSVIconMap.put('glyphicon glyphicon-pencil','utility:edit');
        DownloadCSVIconMap.put('glyphicon glyphicon-remove','utility:close');
        DownloadCSVIconMap.put('glyphicon glyphicon-send','utility:send');
        DownloadCSVIconMap.put('glyphicon glyphicon-thumbs-down','utility:dislike');
        DownloadCSVIconMap.put('glyphicon glyphicon-thumbs-up','utility:like');
        DownloadCSVIconMap.put('glyphicon glyphicon-trash','utility:delete');
        DownloadCSVIconMap.put('fa fa-history','utility:skip_back');
        DownloadCSVIconMap.put('fa fa-table','utility:table');
        DownloadCSVIconMap.put('fa fa-coffee','utility:coffee');
        DownloadCSVIconMap.put('fa fa-cubes','utility:cubes');
        DownloadCSVIconMap.put('fa fa-star','utility:favorite');
        DownloadCSVIconMap.put('fa fa-exclamation-triangle','utility:warning');
        DownloadCSVIconMap.put('fa fa-line-DownloadCSV','utility:lineDownloadCSV');
        DownloadCSVIconMap.put('fa fa-comment','utility:comments');
        DownloadCSVIconMap.put('fa fa-caret-square-o-down','utility:down');
        DownloadCSVIconMap.put('fa fa-wrench','utility:settings');
        DownloadCSVIconMap.put('fa fa-share-square-o','utility:share');
        DownloadCSVIconMap.put('fa fa-bolt','utility:lightning');
        DownloadCSVIconMap.put('fa fa-trash-o','utility:delete');
        DownloadCSVIconMap.put('glyphicon glyphicon-book','utility:knowledge_base');
        DownloadCSVIconMap.put('fa fa-file-text-o','utility:contract_doc');
        DownloadCSVIconMap.put('fa fa-wechat','utility:chat');
        DownloadCSVIconMap.put('fa fa-paperclip','utility:attach');
        DownloadCSVIconMap.put('fa fa-usd','utility:moneybag');
        DownloadCSVIconMap.put('glyphicon glyphicon-tasks','utility:task');
        DownloadCSVIconMap.put('fa fa-folder','utility:open_folder');
        DownloadCSVIconMap.put('fa fa-paper-plane-o','utility:send');
        DownloadCSVIconMap.put('fa fa-play','utility:play');
    
        return DownloadCSVIconMap;
    }
    
    public static Map<String, String> getDownloadCSVIconLwc(){
    
        map<string,string> DownloadCSVIconMaplwc = new map<string,string>();
        DownloadCSVIconMaplwc.put('fa fa-pencil','utility:edit');
        DownloadCSVIconMaplwc.put('fa fa-arrow','utility:right');
        DownloadCSVIconMaplwc.put('fa fa-ban','utility:error');
        DownloadCSVIconMaplwc.put('fa fa-bolt','utility:thunder');
        DownloadCSVIconMaplwc.put('fa fa-check','utility:success'); 
        DownloadCSVIconMaplwc.put('fa fa-clone','utility:clone');
        DownloadCSVIconMaplwc.put('fa fa-close','utility:close');
        DownloadCSVIconMaplwc.put('fa fa-cloud-download','utility:download');
        DownloadCSVIconMaplwc.put('fa fa-cloud-upload','utility:upload');
        DownloadCSVIconMaplwc.put('fa fa-comments','utility:chat');
        DownloadCSVIconMaplwc.put('fa fa-exchange','utility:exchange');
        DownloadCSVIconMaplwc.put('fa fa-external-link','utility:open');
        DownloadCSVIconMaplwc.put('fa fa-eye','utility:preview');
        DownloadCSVIconMaplwc.put('fa fa-file','utility:page');
        DownloadCSVIconMaplwc.put('fa fa-file-pdf','utility:pdf_ext');
        DownloadCSVIconMaplwc.put('fa fa-file-pdf-o','utility:pdf_ext');
        DownloadCSVIconMaplwc.put('fa fa-file-text','utility:file');
        DownloadCSVIconMaplwc.put('fa fa-gavel','utility:thunder');
        DownloadCSVIconMaplwc.put('fa fa-level-up','utility:up');
        DownloadCSVIconMaplwc.put('fa fa-money','utility:currency');
        DownloadCSVIconMaplwc.put('fa fa-play','utility:play');
        DownloadCSVIconMaplwc.put('fa fa-plus-circle','utility:add');
        DownloadCSVIconMaplwc.put('fa fa-reply','utility:back');
        DownloadCSVIconMaplwc.put('fa fa-share','utility:share');
        DownloadCSVIconMaplwc.put('fa fa-share-square-o','utility:share_post');
        DownloadCSVIconMaplwc.put('fa fa-sign-in','utility:login');
        DownloadCSVIconMaplwc.put('fa fa-sign-out','utility:logout');
        DownloadCSVIconMaplwc.put('fa fa-sitemap','utility:hierarchy');
        DownloadCSVIconMaplwc.put('fa fa-sticky-note','utility:note');
        DownloadCSVIconMaplwc.put('fa fa-stop','utility:stop');
        DownloadCSVIconMaplwc.put('fa fa-tags','utility:tags');
        DownloadCSVIconMaplwc.put('fa fa-times','utility:close');
        DownloadCSVIconMaplwc.put('fa fa-trash','utility:delete');
        DownloadCSVIconMaplwc.put('fa fa-trophy','custom:custom48');
        DownloadCSVIconMaplwc.put('fa fa-undo','utility:undo');
        DownloadCSVIconMaplwc.put('fa fa-unlock','utility:unlock');
        DownloadCSVIconMaplwc.put('fa fa-paper-plane-o','utility:send');
        DownloadCSVIconMaplwc.put('glyphicon glyphicon-pencil','utility:edit');
        DownloadCSVIconMaplwc.put('glyphicon glyphicon-remove','utility:close');
        DownloadCSVIconMaplwc.put('glyphicon glyphicon-send','utility:send');
        DownloadCSVIconMaplwc.put('glyphicon glyphicon-thumbs-down','utility:dislike');
        DownloadCSVIconMaplwc.put('glyphicon glyphicon-thumbs-up','utility:like');
        DownloadCSVIconMaplwc.put('glyphicon glyphicon-trash','utility:delete');
        DownloadCSVIconMaplwc.put('fa fa-history','utility:skip_back');
        DownloadCSVIconMaplwc.put('fa fa-table','utility:table');
        DownloadCSVIconMaplwc.put('fa fa-coffee','utility:coffee');
        DownloadCSVIconMaplwc.put('fa fa-cubes','utility:cubes');
        DownloadCSVIconMaplwc.put('fa fa-star','utility:favorite');
        DownloadCSVIconMaplwc.put('fa fa-exclamation-triangle','utility:warning');
        DownloadCSVIconMaplwc.put('fa fa-line-DownloadCSV','utility:graph');
        DownloadCSVIconMaplwc.put('fa fa-comment','utility:comments');
        DownloadCSVIconMaplwc.put('fa fa-caret-square-o-down','utility:down');
        DownloadCSVIconMaplwc.put('fa fa-wrench','utility:settings');
        DownloadCSVIconMaplwc.put('fa fa-share-square-o','utility:share');
        DownloadCSVIconMaplwc.put('fa fa-bolt','utility:lightning');
        DownloadCSVIconMaplwc.put('fa fa-trash-o','utility:delete');
        DownloadCSVIconMaplwc.put('glyphicon glyphicon-book','utility:knowledge_base');
        DownloadCSVIconMaplwc.put('fa fa-file-text-o','utility:contract_doc');
        DownloadCSVIconMaplwc.put('fa fa-wechat','utility:chat');
        DownloadCSVIconMaplwc.put('fa fa-paperclip','utility:attach');
        DownloadCSVIconMaplwc.put('fa fa-usd','utility:moneybag');
        DownloadCSVIconMaplwc.put('glyphicon glyphicon-tasks','utility:task');
        DownloadCSVIconMaplwc.put('fa fa-folder','utility:open_folder');
        DownloadCSVIconMaplwc.put('fa fa-paper-plane-o','utility:send');
        DownloadCSVIconMaplwc.put('fa fa-play','utility:play');
        DownloadCSVIconMaplwc.put('fa fa-folder-open-o','utility:opened_folder');
        DownloadCSVIconMaplwc.put('fa fa-check-square-o','utility:multi_select_checkbox');
        DownloadCSVIconMaplwc.put('fa fa-male','utility:user');
    
        return DownloadCSVIconMaplwc;
    }
    
    

    Set<string> removeHideColumn(List<String >tableFieldAPIList,sObject record,Map<String,String> hideColumnMap){
            Set<String> tableFieldAPISet= new Set<String>();
        tableFieldAPISet.addAll(tableFieldAPIList);
        
        for(String apiName:tableFieldAPISet){
            if(hideColumnMap.get(apiName)!=null && record!=null){
                ExpressionJSONEvaluator.recordMap = new  Map<String,sObject>();
                Boolean expressionResult=  ExpressionJSONEvaluator.evaluateExpression(hideColumnMap.get(apiName), record, ' ');
                if(expressionResult){
                    tableFieldAPISet.remove(apiName);
                }                           
            }
        }
        
        return tableFieldAPISet;
    }
    public Map<String, Schema.DisplayType> getFieldDataType(String objectName, List<String> fieldNameLst){
        Map<String, Schema.DisplayType> fieldDatTypeMap = new Map<String, Schema.DisplayType>();
        fieldNameLst = !fieldNameLst.isEmpty() ? fieldNameLst : new List<String>();
        if(!fieldNameLst.isEmpty()){
            for(String field : fieldNameLst){
                SObjectType r = ((SObject)(Type.forName('Schema.'+objectName).newInstance())).getSObjectType();
                DescribeSObjectResult d = r.getDescribe();
                Schema.DisplayType type;
                if(d.fields.getMap().get(field) !=  null){
                    type =  d.fields.getMap().get(field).getDescribe().getType();
                }
                fieldDatTypeMap.put(field,type);
            } 
        }
        return fieldDatTypeMap;
    }

    public string getFormattedString(String fieldString){
        if(!fieldString.startsWith('<a')){
            String fieldValueWithoutHTML = String.valueOf(fieldString).stripHtmlTags();
            fieldValueWithoutHTML = fieldValueWithoutHTML.trim();
            if(!String.isEmpty(fieldValueWithoutHTML) && !fieldValueWithoutHTML.isAsciiPrintable()){
                Pattern regexForExtractingId = Pattern.compile('\\s*title\\s*=\"([^\"]*)\"');
                Matcher regexMatcherForExtractingId = regexForExtractingId.matcher(fieldString);        
                String valueF = '';
                while(regexMatcherForExtractingId.find()){//SOQL/SOSL Injection False +ve
                    string value = regexMatcherForExtractingId.group(0);
                    if(!String.isEmpty(value)){
                        valueF += value.substringBetween('"')+ '; ';
                    }
                }
                if(!String.isEmpty(valueF)){
                     valueF = valueF .removeEnd('; ');
                }else{
                    return fieldString;
                }
                 return valueF;    
            }else{
                return fieldValueWithoutHTML;
            }
        }
        return fieldString;
    }

    public String getAltValue(String fieldStr){
        String altVal = '';
        if(!String.isEmpty(fieldStr)){
            String regex = 'alt="([^"]*)"';
            Pattern regexForExtractingAlt = Pattern.compile(regex);
            Matcher regexMatcherForExtractingAlt = regexForExtractingAlt.matcher(fieldStr);
            while(regexMatcherForExtractingAlt.find()){//SOQL/SOSL Injection False +ve
                String val = regexMatcherForExtractingAlt.group(0);
                val = val.remove('alt=').remove('"');
                altVal += val;
            }    
        }
        return altVal;
    }
}