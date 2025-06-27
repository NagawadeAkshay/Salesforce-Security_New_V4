/**
    This class is used to export a list of sObject records into PDF  
        
        Input to this class: printTemplateName
    Audit History
    **********************************************************
    Dated          Name               Description  
    03/11/2019  Atul Naik           Added with Method to Handle Comma in CSV Export
    04/11/2019  Atul Naik           Support Export for Block Structure.
    **********************************************************  
*/


global with sharing class FlexTableExportCtrl {
    public transient List<sObject> objectList;
    FlexDataWrapper fdw = new FlexDataWrapper();
   // public  transient List<Map<String,Object>> sobjectListWithoutHTML {get;set;}
    public transient Map<String,Double> totalNumberMap = new Map<String,Double>();//total Pdf
    public transient Map<String,String> fieldMap;
    public transient Map<String,String> apifieldMap;
    public transient String objectName;
    public transient String[] sfields;
    public transient String[] fieldLabels;
    public transient DataTableConfig__c flexTable;
    public  transient  string mode{get;set;}
    public Boolean enableHideColumnLogic = false;
    //public transient List<String> strValues{set; get;}
    public transient String localeCurrencySymbol = '$';
    private transient String flexTableParam;
    private transient String listParam;
    private transient boolean initialize;
    public transient string flexTableHeader; 
    public transient  Map<String,String> fieldApiNameToDataType;
    public  transient String newLine{get;set;}
    public transient String comma{get;set;}
    private String maskValue = '*****';
    private Map<String,String> maskMap = new Map<String,String>();
    public transient List<String> forIterationOverSobject;
    public transient List<String> fieldApiNameLabel;
    public transient List<FlexDataWrapper> flexDataWrapperList;
    public transient List<FlexTableWrapper> flexTableWrapperList {get;set;}
    public transient List<Integer> index {get;set;}
    public transient Integer indexSize;
    public transient Map<Integer,String>indexAPI{get;set;}
    public transient Map<Integer,String>indexLabel{get;set;}
    public transient Map<Integer,String>indexwidth;    
    //public transient Integer num{get;set;}
    //public transient Boolean IsHistory{get;set;}
    public transient Component.Apex.OutputPanel body;
    private transient String html = '';
    public transient Boolean hideFlexTableHeaderInCSV{get;set;}
    private static boolean testForCsv = false;//103742
    public static boolean hideTotalCheck = false;
    public string lableOfTotal='';
    public  Boolean hideTotal{get;set;}
    public String tableName{get;
            set{
                tableName = value;
            if(mode=='application/vnd.ms-excel' && testForCsv == false){
                 fetchData();
                 testForCsv = true;
                }
            }
    }

    //Added by Dipak Pawar on 2 July 2019, for "Task 54920: Dev-Internal-Flex table export right intend for currency, number and percent fields"
    public Set<String> setFieldTypesToTextAlignRight = new Set<String>{'CURRENCY', 'DECIMAL', 'DOUBLE', 'INTEGER', 'PERCENT'};

    //Constructor       
    global FlexTableExportCtrl() {
        newLine = '\n';
        comma = ',';
        hideFlexTableHeaderInCSV = KeyValueStoreHelper.getBooleanValue('HideFlexTableHeaderForCSV',true) == null? false : KeyValueStoreHelper.getBooleanValue('HideFlexTableHeaderForCSV',true); 
        //num=0;
    }

    public static List<String> getHideExpressionFields(String expressionJson,String sobjectName){
        list<String> expfieldsList = new list<String>();
        String mergeFields= '';
        mergeFields = ExpressionJSONEvaluator.getfieldNamesFromJSON(expressionJson);
        String alternateSobjectName = sobjectName;
        try {
            Map<String,Object> jsonParsed = (Map<String,Object>)Json.deserializeUntyped(expressionJson);
            if(jsonParsed.get('ExpressionObject') != null) {
                alternateSobjectName = String.valueOf(jsonParsed.get('ExpressionObject'));
            }
        } catch(Exception ex) { }
        if(!String.isEmpty(mergeFields)){
            if(String.isNotEmpty(alternateSobjectName) && (ExpressionJSONEvaluator.hasSObjectField(mergeFields,alternateSobjectName) == true)) {
                expfieldsList.addAll(mergeFields.split(','));
            }
        }
        return expfieldsList;
    }
    
    /*
    * As we have multiple flex tables on layout need to void mulitple SOQL. Collect all flex table config names and query it also replace merge fields in bulk.
    */
    // map between tableName + recordId and associated datatable config record.
    private static Map<String, DataTableConfig__c> flexTableMap = new Map<String, DataTableConfig__c>();
    // it will store table and its associated records. we can have same table for multiple forms with different form records.
    private static Map<String, List<String>> recIdsBytableName = new Map<String, List<String>>();
    private static Set<String> userFields = new Set<String>();
    private static Set<String> acctFields = new Set<String>();
    private static Map<String, Set<String>> recordFields = new Map<String, Set<String>>();
    private static User userRec;
    private static Account userAcctRec;
    private static Map<String, SObject> recordById = new Map<String, SObject>();
    
    public static void addFlexTable(String tableName, String recordId) {
        if(recIdsBytableName.get(tableName) == null) {
            recIdsBytableName.put(tableName, new List<String>());
        }
        recIdsBytableName.get(tableName).add(recordId);
    }
    
    public static void getTableRecords() {
        if(!recIdsBytableName.isEmpty()){
            if(Schema.sObjectType.DataTableConfig__c.isAccessible()){
                List<DataTableConfig__c> flexTableRecords = [SELECT id,Name,HideColumnsText__c,FieldNames__c,FilterCriteria__c,Header__c,HelpConfig__c,OrderBy__c,SObject__c,SkipFieldsForExport__c
                                        ,SobjectConfig__r.Name,RecordTypeId,HeaderIconDocumentName__c,PDFRenderType__c,Sort_Direction__c,SubHeader__c,
                                        (select id,FieldAPIName__c,FieldLabelOverride__c,FieldWidth__c,EnableOverAllTotal__c,HideColumnJSON__c,FormulaJSON__c,DisplayFields__c , HideGroupingColumn__c ,EnableRowGrouping__c from Flex_Table_Detail_Configs__r),
                                        (SELECT Id,FlexTableListViewConfig__c,FlexTableListViewConfig__r.Label__c,FlexTableListViewConfig__r.FilterClause__c FROM 
                                                Flex_Table_List_View_User_Configs__r where User__c=:UserInfo.getUserId()),
                                        (SELECT Id,IsActive__c,Label__c,ShowinPDF__c,FilterClause__c FROM Flex_Table_Filter_List_View_Configs__r) 
                                        FROM DataTableConfig__c 
                                        WHERE Name = : recIdsBytableName.KeySet() WITH USER_MODE];  
                for(DataTableConfig__c dataTable : flexTableRecords) {
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
                    String fieldStrVal = fieldVal != null ? String.valueOf(fieldVal) : '';
                    listViewUser.FlexTableListViewConfig__r.FilterClause__c = listViewUser.FlexTableListViewConfig__r.FilterClause__c.replace('{!' + sObjectAPIName + '.' + userField + '}',
                                            fieldStrVal);
                }
            }
        }
        for(FlexTableFilterListViewConfig__c flexAction : flexTable.Flex_Table_Filter_List_View_Configs__r) {
                if(flexAction.IsActive__c == true && flexAction.FilterClause__c != null) {
                    for(String userField : fieldsToReplace) {
                        Object fieldVal = AppUtils.getFieldValue(rec, userField);
                        String fieldStrVal = fieldVal != null ? String.valueOf(fieldVal) : '';
                        flexAction.FilterClause__c = flexAction.FilterClause__c.replace('{!' + sObjectAPIName + '.' + userField + '}',
                                                fieldStrVal);
                    }
                }
                
        }
        if(String.isNotEmpty( flexTable.FilterCriteria__c)) {
            for(String userField : fieldsToReplace) {
                Object fieldVal = AppUtils.getFieldValue(rec, userField);
                String fieldStrVal = fieldVal != null ? String.valueOf(fieldVal) : '';
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
                    String fieldStrVal = fieldVal != null ? String.valueOf(fieldVal) : '';
                    listViewUser.FlexTableListViewConfig__r.FilterClause__c = listViewUser.FlexTableListViewConfig__r.FilterClause__c.replace('{!User.' + userField + '}',
                                            fieldStrVal);
                }
            }
        }
        for(FlexTableFilterListViewConfig__c flexAction : flexTable.Flex_Table_Filter_List_View_Configs__r) {
                if(flexAction.IsActive__c == true &&  flexAction.FilterClause__c != null) {
                    for(String userField : userFields) {
                        Object fieldVal = AppUtils.getFieldValue(userRec, userField);
                        String fieldStrVal = fieldVal != null ? String.valueOf(fieldVal) : '';
                        flexAction.FilterClause__c = flexAction.FilterClause__c.replace('{!User.' + userField + '}',
                                                fieldStrVal);
                    }
                }
                
        }
        if(String.isNotEmpty( flexTable.FilterCriteria__c)) {
            for(String userField : userFields) {
                Object fieldVal = AppUtils.getFieldValue(userRec, userField);
                String fieldStrVal = fieldVal != null ? String.valueOf(fieldVal) : '';
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
                    String fieldStrVal = fieldVal != null ? String.valueOf(fieldVal) : '';
                    listViewUser.FlexTableListViewConfig__r.FilterClause__c = listViewUser.FlexTableListViewConfig__r.FilterClause__c.replace('{!Account.' + userField + '}',
                                            fieldStrVal);
                }
            }
        }
        for(FlexTableFilterListViewConfig__c flexAction : flexTable.Flex_Table_Filter_List_View_Configs__r) {
                if(flexAction.IsActive__c == true &&  flexAction.FilterClause__c != null) {
                    for(String userField : acctFields) {
                        Object fieldVal = AppUtils.getFieldValue(userAcctRec, userField);
                        String fieldStrVal = fieldVal != null ? String.valueOf(fieldVal) : '';
                        flexAction.FilterClause__c = flexAction.FilterClause__c.replace('{!Account.' + userField + '}',
                                                fieldStrVal);
                    }
                }
                
        }
        if(String.isNotEmpty( flexTable.FilterCriteria__c)) {
            for(String userField : acctFields) {
                Object fieldVal = AppUtils.getFieldValue(userAcctRec, userField);
                String fieldStrVal = fieldVal != null ? String.valueOf(fieldVal) : '';
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
                    String recQuery = 'select ' + String.escapeSingleQuotes(String.join(fieldsToQuery, ',')) + ' from ' + String.escapeSingleQuotes(objectAPIName) + ' where Id in:recordIds';
                    List<SObject> records = Database.query(String.escapeSingleQuotes(recQuery),AccessLevel.USER_MODE); //SOQL Injection - False +ve - Dynamic part of query is escapeSingleQuotes/static bind
                    for(SObject sobj : records) {
                        recordById.put(sobj.Id, sobj);
                    }
                }
            }
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
            String accQuery = 'select ' + String.escapeSingleQuotes(String.join(fieldsToQuery, ',')) + ' from Account where Id= :userAccount';
            List<Account> accts = Database.query(String.escapeSingleQuotes(accQuery), AccessLevel.USER_MODE); //SOQL Injection - False +ve - Dynamic part of query is static bind
            if(accts.size() == 0) {
                throw new CustomExceptions.InputDataException('Ornization associated with user is not valid. Please contact administrator. Org id:' + userRec.OrganizationId__c);
            }
            userAcctRec = accts[0];
        }
    }
    
    private static void getUserRecord() {
        if(userRec == null && userFields.size() > 0) {
            List<String> fieldsToQuery = new List<String>();
            fieldsToQuery.addAll(userFields); 
            String currentUserId = UserInfo.getUserId();
            String userRecQuery = 'select ' + String.escapeSingleQuotes(String.join(fieldsToQuery, ',')) + ' from User where Id=:currentUserId';
            userRec = Database.query(String.escapeSingleQuotes(userRecQuery), AccessLevel.USER_MODE); //SOQL Injection - False +ve - Dynamic part of query is escapeSingleQuotes/static bind
        }
    }
    
    /*private static void getMergeFields(List<DataTableConfig__c> flexTableRecords) {
        for(DataTableConfig__c dataTable : flexTableRecords) {
            flexTableMap.put(dataTable.Name, dataTable);
        }
    }*/
    
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
        // get sobject from random object
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
    
    /*******            End of bulk flex table processing           *********/
    
    public static String recordIdToProcess;
    public void fetchData() {
        //1. Get the parameters from the URL
        //2. Get the PageTemplate for the dynamic layout
        mainMap = new Map<String,List<String>>();//Bug 202980: SCDE: Page Layout/Forms - Total should be shown correctly in the Downloaded PDF
        String listViewFilterClause;
        flexTable = flexTableMap.get(tableName);
        // in case of form printing ID will be different.
        String recordId;
        if(SFDCEncoder.SFDC_JSENCODE(ApexPages.CurrentPage().getParameters().get('id')) != null){//ApexXSSFromURLParam - False +Ve - We are using custom method for encoding 
            recordId = SFDCEncoder.SFDC_JSENCODE(ApexPages.CurrentPage().getParameters().get('id'));//ApexXSSFromURLParam - False +Ve - We are using custom method for encoding 
        }
         recordId = recordIdToProcess != null ? recordIdToProcess : recordId;
        //convert 15 to 18 digits
        if(String.isnotEmpty(recordId)) {
            recordId = String.valueOf(Id.valueOf(recordId));
        }
        if(String.isEmpty( recordId ) || tableName == 'History' || flexTable ==null) {
            String strFlexTableParam = ApexPages.currentPage().getParameters().containsKey('flexTableParam') ? ApexPages.currentPage().getParameters().get('flexTableParam') : null;
            if(String.isNotBlank(strFlexTableParam)){
                flexTableParam = SFDCEncoder.sanitizeJSON(strFlexTableParam); // ApexXSSFromURLParam - False +Ve - We are using custom method for encoding 
                Map<string, object> mergeFieldsKeyValueMap = ((Map<string,object>)JSON.deserializeUntyped(flexTableParam));    
                if(mergeFieldsKeyValueMap.containsKey('RecordId')) {
                    recordId = (String)mergeFieldsKeyValueMap.get('RecordId');   
                    recordId = String.valueOf(Id.valueOf(recordId));
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
        //3. Get the Object Name from the FlexTable     
        String recordTypeName = Schema.SObjectType.DataTableConfig__c.getRecordTypeInfosById().get(flexTable.RecordTypeId).getname();                         
        if(recordTypeName == 'Data Table Enhanced'){
            objectName = flexTable.SobjectConfig__r.Name;
            enableHideColumnLogic = true;
            hideTotalCheck = true;
        }else{
            objectName = flexTable.SObject__c; 
        }                        
        Boolean useHistoryNameField = true;
        String uniqueField='';
        String objName;
        List<ID> recordsList = new List<Id>();  
        recordsList.add(recordId); 
        if(recordId != Null) {
            objName = Id.valueOf(recordId).getSObjectType().getDescribe().getName();
        }else {
            objName = objectName;
        }
        String originalObj = objName;
        String childs;
        if(tableName == 'History') {
            String suffix = '__c';   
            if(ApexPages.CurrentPage().getParameters().containsKey('historyObjectSelected') && SFDCEncoder.SFDC_JSENCODE(ApexPages.CurrentPage().getParameters().get('historyObjectSelected')) != null && SFDCEncoder.SFDC_JSENCODE(ApexPages.CurrentPage().getParameters().get('historyObjectSelected')) != '') { //ApexXSSFromURLParam - False +Ve - We are using custom method for encoding
                objName = SFDCEncoder.SFDC_JSENCODE(ApexPages.CurrentPage().getParameters().get('historyObjectSelected'));//ApexXSSFromURLParam - False +Ve - We are using custom method for encoding
                if(!objName.equalsIgnoreCase(originalObj)){
                    Map<String,Object> resultMap = new Map<String,Object>();
                    Map<String,String > childRelationshipMap = new Map<String,String >();
                    Map<String,String > relatedFieldAPI = new Map<String,String >();
                    String queryChildren ;
                    resultMap = FlexTableCtrl.fetchChildRelationships(originalObj);
                    if(resultMap.size() > 0){
                        childRelationShipMap = (Map<String,String>)resultMap.get('ChildObjects');
                        relatedFieldAPI = (Map<String,String>)resultMap.get('RelatedFieldName');
                        String relatedFields = relatedFieldAPI.get(objName);
                        relatedFields = relatedFields.replaceAll(',','=:recordId  OR ');
                        relatedFields += '=:recordId';
                        if(!relatedFieldAPI.get(objName).contains(',')){
                            queryChildren = 'select id from '+ String.escapeSingleQuotes(objName) + ' where ' +String.escapeSingleQuotes(relatedFieldAPI.get(objName))+ '=:recordId';
                        }else{
                            queryChildren = 'select id from '+ String.escapeSingleQuotes(objName) + ' where ' + String.escapeSingleQuotes(relatedFields);
                        }
                    }
                    List<Sobject> objects = database.query(String.escapeSingleQuotes(queryChildren),AccessLevel.USER_MODE); //SOQL Injection - False +ve - Dynamic part of query is escapeSingleQuotes/static bind
                    for(Sobject obj : objects){
                        recordsList.add((Id)obj.get('id'));
                    }
                }
            }
            flexTable.SObject__c = objectName = objName.endsWithIgnoreCase(suffix) ? objName.replace(suffix, '__History') : objName+'History';
            if(!objectName.containsIgnoreCase('__History')){
                flexTable.FilterCriteria__c =  flexTable.FilterCriteria__c.replace('ParentId',flexTable.SObject__c.replace('History','')+'Id');
                flexTable.FieldNames__c = flexTable.FieldNames__c.replace('ParentId,','');
            }
            String idList;  
            if(recordsList.size () > 0){
                idList = '(';
                for(Id rcrdId : recordsList){
                    idList+='\'' + rcrdId + '\',';
                }
                idList = idList.removeEnd(',');
                idList += ')';
            } else{
                idList = '(\'\')';
            }
            // This Code is to check filter criteria blank or null on history table prevent error.
            if(!String.isEmpty(flexTable.FilterCriteria__c)){
                flexTable.FilterCriteria__c = flexTable.FilterCriteria__c.replace('=', ' IN');
                flexTable.FilterCriteria__c = flexTable.FilterCriteria__c.replace('\'{!parentid}\'', idList);
                flexTable.FilterCriteria__c = flexTable.FilterCriteria__c +' and DataType != \'EntityId\' and Field != \'created\'';
            }
            else if(objectName .endsWith('History') && String.isEmpty(flexTable.FilterCriteria__c)){
                flexTable.FilterCriteria__c = 'ParentId IN ' + idList + '  AND Field NOT IN (\'created\',\'feedEvent\',\'ownerAccepted\',\'ownerAssignment\',\'locked\',\'unlocked\')';
            }
            
            List<SobjectConfig__c> sobj = new List<SobjectConfig__c>(); 
            if(SobjectConfig__c.sObjectType.getDescribe().isAccessible() == true) {
                sobj = [SELECT UserFriendlyNameField__c FROM SobjectConfig__c WHERE name =: objName WITH USER_MODE];//CRUD/FLS False +ve with the help of Schema we have performed the check
            }
            if(sobj.size() > 0 && !String.isEmpty(sobj[0].UserFriendlyNameField__c) ){    
                useHistoryNameField = false;
                String query = 'SELECT Id,' + String.escapeSingleQuotes(sobj[0].UserFriendlyNameField__c) +   ' FROM ' + String.escapeSingleQuotes(objName) +  ' WHERE Id =: recordsList';
                List<SObject> recList = Database.query(String.escapeSingleQuotes(query), AccessLevel.USER_MODE); //SOQL Injection - False +ve - Dynamic part of query is escapeSingleQuotes/static bind
                if(recList.size() > 0) {
                    SObject rec = recList[0];
                    uniqueField = String.valueOf(rec.get(sobj[0].UserFriendlyNameField__c));
                }
            }
        }              
        //4. Get the list of field names from the FlexTableConfig ONLY to populate the table header     
        sfields = new List<string>();
        fieldLabels = new List<string>();
        fieldMap = new Map<String,String>();
        apifieldMap = new Map<String,String>();
        forIterationOverSobject = new List<string>();
        fieldApiNameToDataType = new Map<String,String>();
        fieldApiNameLabel = new List<String>();
        
        index  = new List<Integer>();
        indexAPI = new Map<Integer,String>();
        indexLabel = new Map<Integer,String>();
        indexwidth = new Map<Integer,String>();
        // 179175
        Map<String, string> hideColumnJSON = new Map<String, string>();
        Map<String, string> displayFieldsMap = new Map<String, string>();
        Map<String, Boolean> hideGroupingColumn = new Map<String, Boolean>();
        List<String> hideFields = new List<String>();
        Set<String> expFieldsSet = new Set<String>();
        String sobjectName;
        if(recordId != null){
            Id myId = (Id)recordId;
            Schema.SObjectType sobjectType = myId.getSObjectType();
            sobjectName= sobjectType.getDescribe().getName();
        }
        Map<String, DataTableDetailConfig__c> apiNameToFlexTableDetail = new Map<String, DataTableDetailConfig__c>();
        Map<String,boolean> checkOverallEnableMap = new Map<String,boolean>();
        for(DataTableDetailConfig__c dataTableDetail : flexTable.Flex_Table_Detail_Configs__r) {
            if(dataTableDetail.HideColumnJSON__c != null){
                hideColumnJSON.put(dataTableDetail.FieldAPIName__c,dataTableDetail.HideColumnJSON__c); 
                hideFields = getHideExpressionFields(dataTableDetail.HideColumnJSON__c,sobjectName);
                if(hideFields.size() > 0){
                    expFieldsSet.addAll(hideFields);
                }
            }
            if(dataTableDetail.HideGroupingColumn__c == true && dataTableDetail.EnableRowGrouping__c == true ){
                hideGroupingColumn.put(dataTableDetail.FieldAPIName__c,dataTableDetail.HideGroupingColumn__c);
            }
            if(dataTableDetail.FormulaJSON__c != null){
                Map<String,String> timeApprovalMap = (Map<String,String>)JSON.deserialize(SFDCEncoder.sanitizeJSON(dataTableDetail.FormulaJSON__c), Map<String,String>.Class); // false+ve for Deserializing objects from an untrusted source is security-sensitive as sanitizing it by using SFDCEncoder.sanitizeJSON
                List<String> lableName  = timeApprovalMap.values();
                lableOfTotal = lableName[0];
            }
            if(dataTableDetail.DisplayFields__c != null){
                displayFieldsMap.put(dataTableDetail.FieldAPIName__c,dataTableDetail.DisplayFields__c); 
            }
            checkOverallEnableMap.put(dataTableDetail.FieldAPIName__c,dataTableDetail.EnableOverAllTotal__c);
            apiNameToFlexTableDetail.put(dataTableDetail.FieldAPIName__c, dataTableDetail);
        }   
        List<Map<String,String>> hideConditionsArrayMap;//188102
        if(flexTable.HideColumnsText__c != null){
            hideConditionsArrayMap = (List<Map<String,String>>)JSON.deserialize(flexTable.HideColumnsText__c,List<Map<String,String>>.Class);  //Deserializing objects from an untrusted source is security-sensitive : False+ve as the JSON data being processed is controlled input through the code and not directly provided by users, the JSON structure is predefined and static, with no opportunity for external manipulation and the values from this JSON are accessed using static keys, ensuring that only expected data is retrieved.
        }
        Integer i=0;
        List<String> flexFieldNames = flexTable.FieldNames__c.split(',');
        // 179175
         SObject record;
         if(recordId != Null && (( enableHideColumnLogic && hideColumnJSON.size() > 0) || (hideGroupingColumn.size() > 0)) ){

            
            Map<String, Schema.SObjectField> objectFields = Schema.getGlobalDescribe().get(sobjectName).getDescribe().fields.getMap();
            String sobjectFieldNames = 'Id,';
            
            for(String s : expFieldsSet) {
                sobjectFieldNames += ' ' + String.escapeSingleQuotes(s) + ',';
            }
            sobjectFieldNames = sobjectFieldNames.removeEnd(',');
            record = Database.query('Select '+sobjectFieldNames + ' From ' + String.escapeSingleQuotes(sobjectName) + ' Where Id = :myId', AccessLevel.USER_MODE); //SOQL Injection - False +ve - Dynamic part of query is escapeSingleQuotes
         }
        
        Set<string> exportFieldNamesSet = new Set<string>();
        List<String> exportFieldNames = new List<String>();
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
            if(((enableHideColumnLogic && hideColumnJSON != null) || hideGroupingColumn != null) && record != null){
                exportFieldNamesSet =removeHideColumn(exportFieldNames,record,hideColumnJSON , hideGroupingColumn);
               List<String> lStrings = new List<String>(exportFieldNamesSet);
               exportFieldNames = lStrings;
            }
           
        }
         
        for(string s: exportFieldNames) {
            s = s.trim();
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
                apifieldMap.put(fielName,s);
                fieldApiNameLabel.add(fld.fieldDesc.getLabel()+'');
            }           
            String dataType = String.ValueOf(fld.fieldDesc.getType()) ;
            if(String.ValueOf(fld.fieldDesc.getType()) == 'REFERENCE') {
                if(s.containsIgnoreCase('CreatedById') || s.containsIgnoreCase('RecordTypeId') || s.containsIgnoreCase('LastModifiedById') || s.containsIgnoreCase('OwnerId') || s.containsIgnoreCase('ParentId') || s.containsIgnoreCase('ContactId') || s.containsIgnoreCase('AccountId') || s.containsIgnoreCase('ProfileId')) {
                    s = s.toLowerCase().replace('id', '.Name');
                } else {
                    if(displayFieldsMap.get(originalFielName) != null){
                         s = s.substringBefore('__c');
                         s = s + '__r.'+displayFieldsMap.get(originalFielName);
                    }else{
                        s = s.substringBefore('__c');
                        s = s + '__r.Name';
                    }
                }  
            }       
            if(s != 'Id') {
                fieldLabels.add(String.ValueOf(fld.fieldDesc.getLabel()));
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
        String whereClause;
        String limitClause;
        List<String> enableInPdf = new List<String>();
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
                                    Integer index = updatedFieldNamesLst.indexOf(fieldName);
                                    if(index != -1){
                                        updatedFieldNamesLst.add(index,'toLabel('+fieldName+')');
                                        updatedFieldNamesLst.remove(index);
                                        
                            }
                        }
                               
                            }

                    }

                    }
                }
            }
            DescribeSObjectResult d = r.getDescribe();
            Schema.DisplayType type;
            string namespace = AppUtils.getNameSpacePrefix();
            if(d.fields.getMap().get(namespace +fieldName) !=  null){
                type =  d.fields.getMap().get(namespace +fieldName).getDescribe().getType();
            }
            if(type != null && (type == Schema.DisplayType.PICKLIST || type == Schema.DisplayType.MultiPicklist) && fieldName.containsIgnoreCase('__c')){
              // fieldNames = fieldNames.replace(fieldName,'toLabel('+fieldName+')');
                Integer index = updatedFieldNamesLst.indexOf(fieldName);
                if(index != -1 && index < updatedFieldNamesLst.size()){
                    updatedFieldNamesLst.add(index,'toLabel('+fieldName+')');
                    updatedFieldNamesLst.remove(index+1);
                }
            }
        }
        fieldNames = AppUtils.fieldsList(updatedFieldNamesLst);
        string query = 'SELECT ' + String.escapeSingleQuotes(fieldNames) + ' FROM ' + String.escapeSingleQuotes(objectName);         
        if(whereClause == null && flexTable.FilterCriteria__c != null && flexTable.FilterCriteria__c != ''){
            Map<String,Object> mergeFieldsKeyValueMap = new Map<String,Object>(); 
            flexTableParam = SFDCEncoder.sanitizeJSON(ApexPages.currentPage().getParameters().get('flexTableParam'));//ApexXSSFromURLParam - False +Ve - We are using custom method for encoding 
            listParam = SFDCEncoder.sanitizeJSON(ApexPages.currentPage().getParameters().get('listParm'));//ApexXSSFromURLParam - False +Ve - We are using custom method for encoding 
            if(!String.isEmpty(listParam) && listParam!='""'){
                mergeFieldsKeyValueMap = (Map<string,object>)JSON.deserializeUntyped(listParam);
            } 
            if(flexTableParam!=null && flexTableParam!=''){
                if(mergeFieldsKeyValueMap == null) {
                    mergeFieldsKeyValueMap = new Map<string,object>();
                }                                            
                flexTableParam = EncodingUtil.urlDecode(flexTableParam,'UTF-8'); 
                mergeFieldsKeyValueMap.putAll((Map<string,object>)JSON.deserializeUntyped(flexTableParam));            
            }
            //temp fix
            if(FlexLayoutPrintGenerator.isFormSelected) {
                mergeFieldsKeyValueMap.put('parentId', recordId);
                mergeFieldsKeyValueMap.put('recordId', (String)FlexLayoutPrintGenerator.selectedLayoutHolder.formRecordMap.get(FlexLayoutPrintGenerator.selectedLayotId).get('Id'));
            }
            mergeFieldsKeyValueMap.put('parentRecordIdOfFlexTable',recordId);
            if(String.escapeSingleQuotes(objectName) == 'ContentNote'){ //B28u71g36- replace merge field logic was not added, added for contet note filter criteria to replace
                FlexGridEnhancedHelper cls = new FlexGridEnhancedHelper();
                if(flexTable.FilterCriteria__c != Null){
                    whereClause = cls.replaceFileMergeFields(flexTable.FilterCriteria__c, recordId);
                    limitClause = KeyValueStoreHelper.getTextValue('LimitFlexTableRowsOnDynamicLayout',true);
                    if(!String.isEmpty(whereClause) && !String.isEmpty(limitClause) ){
                        whereClause = AppUtils.parseWhereClause(whereClause)+Integer.valueOf(limitClause);
                    }
                }
            }else{
                if( mergeFieldsKeyValueMap.size() > 0) {
                    whereClause = new FlexTableCtrl().getFilterClauseString(flexTable.FilterCriteria__c, mergeFieldsKeyValueMap, false);
                    limitClause = KeyValueStoreHelper.getTextValue('LimitFlexTableRowsOnDynamicLayout',true);
                    if(!String.isEmpty(whereClause) && !String.isEmpty(limitClause) ){
                        whereClause = AppUtils.parseWhereClause(whereClause)+ Integer.valueOf(limitClause);
                    }   
                }
    
                if(listViewFilterClause != Null && mergeFieldsKeyValueMap.size() > 0) { 
                    whereClause = new FlexTableCtrl().getFilterClauseString(listViewFilterClause, mergeFieldsKeyValueMap, false);
                    limitClause = KeyValueStoreHelper.getTextValue('LimitFlexTableRowsOnDynamicLayout',true);
                    if(!String.isEmpty(whereClause) && !String.isEmpty(limitClause) ){
                        whereClause = AppUtils.parseWhereClause(whereClause)+Integer.valueOf(limitClause);
                    } 
                }else if(listViewFilterClause != Null) {
                    whereClause = AppUtils.parseWhereClause(listViewFilterClause);
                }
                if(String.isEmpty(whereClause)) {
                    whereClause = AppUtils.parseWhereClause(flexTable.FilterCriteria__c);
                }
            }                   
        }
        if(!String.isEmpty(whereClause)){
            query += ' WHERE ';
            query += whereClause;
        }
        if(flexTable.OrderBy__c!= null && flexTable.OrderBy__c!= ''){
            query += ' order By ';
            query += String.escapeSingleQuotes(flexTable.OrderBy__c);
            if(flexTable.Sort_Direction__c != null && flexTable.Sort_Direction__c != '' && !flexTable.OrderBy__c.contains(',')) {
                query += ' ' + String.escapeSingleQuotes(flexTable.Sort_Direction__c);
            }
        }         
        if(flexTable.Flex_Table_Filter_List_View_Configs__r.size() > 1) {
            for(FlexTableFilterListViewConfig__c flexAction : flexTable.Flex_Table_Filter_List_View_Configs__r) {
                if(flexAction.IsActive__c == true && flexAction.ShowinPDF__c == true) {
                    enableInPdf.add(flexAction.Label__c);
                }
            }
        }
        if(enableInPdf.size() > 0) {
            flexTableWrapperList = new List<FlexTableWrapper>();
            for(FlexTableFilterListViewConfig__c flexAction : flexTable.Flex_Table_Filter_List_View_Configs__r) {
                if(flexAction.IsActive__c == true && flexAction.ShowinPDF__c == true) {
                    String whereClauseView;
                    String limitClauseView;
                    string viewListQuery = 'SELECT ' + String.escapeSingleQuotes(fieldNames) + ' FROM ';
                    String objectName = String.escapeSingleQuotes(flexTable.SObject__c);
                    String objToQuery = (objectName != null ? objectName : (flexTable.SobjectConfig__r.Name != null? flexTable.SobjectConfig__r.Name: objectName) ) ;
                    viewListQuery += String.escapeSingleQuotes(objToQuery);
                    if(whereClauseView == null && flexAction.FilterClause__c != null && flexAction.FilterClause__c != ''){
                        Map<String,Object> mergeFieldsKeyValueMap = new Map<String,Object>(); 
                        flexTableParam = SFDCEncoder.sanitizeJSON(ApexPages.currentPage().getParameters().get('flexTableParam'));//ApexXSSFromURLParam - False +Ve - We are using custom method for encoding 
                        listParam = SFDCEncoder.sanitizeJSON(ApexPages.currentPage().getParameters().get('listParm'));//ApexXSSFromURLParam - False +Ve - We are using custom method for encoding 
                        if(listParam!=null && listParam!=''){
                            listParam = EncodingUtil.urlDecode(listParam,'UTF-8'); 
                            if(mergeFieldsKeyValueMap == null) {
                                mergeFieldsKeyValueMap = new Map<string,object>();
                            }  
                            mergeFieldsKeyValueMap = (Map<string,object>)JSON.deserializeUntyped(listParam);
                        } 
                        if(flexTableParam!=null && flexTableParam!=''){
                            flexTableParam = EncodingUtil.urlDecode(flexTableParam,'UTF-8'); 
                            if(mergeFieldsKeyValueMap == null) {
                                mergeFieldsKeyValueMap = new Map<string,object>();
                            }                                            
                            mergeFieldsKeyValueMap.putAll((Map<string,object>)JSON.deserializeUntyped(flexTableParam));            
                        }
                        if(FlexLayoutPrintGenerator.isFormSelected) {
                            mergeFieldsKeyValueMap.put('parentId', recordId);
                            mergeFieldsKeyValueMap.put('recordId', (String)FlexLayoutPrintGenerator.selectedLayoutHolder.formRecordMap.get(FlexLayoutPrintGenerator.selectedLayotId).get('Id'));
                        }
                        mergeFieldsKeyValueMap.put('parentRecordIdOfFlexTable',recordId);
                        if( mergeFieldsKeyValueMap.size() > 0){
                            whereClauseView = new FlexTableCtrl().getFilterClauseString(flexAction.FilterClause__c, mergeFieldsKeyValueMap, false);
                            limitClauseView = KeyValueStoreHelper.getTextValue('LimitFlexTableRowsOnDynamicLayout',true);
                            if(!String.isEmpty(whereClauseView) && !String.isEmpty(limitClauseView) ){
                                whereClauseView = AppUtils.parseWhereClause(whereClauseView)+ Integer.valueOf(limitClauseView);
                            }   
                        }
                        if(String.isEmpty(whereClauseView)) {
                            whereClauseView = AppUtils.parseWhereClause(flexAction.FilterClause__c);
                        }
                    } 
                    if(!String.isEmpty(whereClauseView)){
                        viewListQuery += ' WHERE ';
                        viewListQuery +=  whereClauseView;
                    }
                    if(flexTable.OrderBy__c!= null && flexTable.OrderBy__c!= ''){
                        viewListQuery += ' order By ';
                        viewListQuery += String.escapeSingleQuotes(flexTable.OrderBy__c);
                        if(flexTable.Sort_Direction__c != null && flexTable.Sort_Direction__c != '') {
                            viewListQuery += ' ' + String.escapeSingleQuotes(flexTable.Sort_Direction__c);
                        }
                    }
                    Schema.SObjectType checkObjectType =  SchemaManager.getSObjectTypeFromName(String.escapeSingleQuotes(objectName));
                    if(checkObjectType.getDescribe().isAccessible() == true){
                        ObjectList = Database.query(viewListQuery , AccessLevel.USER_MODE); //SOQL Injection - False +ve - escapeSingleQuotes Applied on whereClause values using  AppUtils.parseWhereClause method to prevent SOQL injection and Dynamic Part of query string is escapeSingleQuotes.
                    }
                    flexDataWrapperList = new List<FlexDataWrapper>();
                    FlexTableWrapper viewWrapper;
                    if(ObjectList.size() > 0) {   
                        for(Sobject objectRec : objectList){
                            if(hideConditionsArrayMap != null){
                                String recorId = String.valueOf(objectRec.Id);
                                maskMap = maskValueCheck(objectRec,recorId,hideConditionsArrayMap,flexFieldNames);
                            }
                            Map<String, Schema.DisplayType> fieldDatTypeMap = this.getFieldDataType(objectName,exportFieldNames);
                            FlexDataWrapper flexWrapper = new FlexDataWrapper(fieldDatTypeMap,objectRec,sfields,fieldApiNameToDataType,objectName,mode,tableName);
                            for(String key : flexWrapper.record.keySet()) {
                                Object value ;
                                Object newValue;

                                if( maskMap != null && apifieldMap.get(key) != null && renderFieldValue(objectRec,apifieldMap.get(key),maskMap) == maskValue){
                                flexWrapper.record.put(key,maskValue);
                                }
                                value = flexWrapper.record.get(key);
                                newValue = '\"' + value + '\"';
                                string datatype = fieldApiNameToDataType.get(key);
                                if((dataType == 'DATE') || (dataType == 'DATETIME')){
                                    newValue = '='+newValue;
                                }
                                if(mode != null && mode.equalsIgnoreCase('text/csv')){
                                    flexWrapper.record.put(key,newValue);
                                }else{
                                    flexWrapper.record.put(key,String.valueOf(value));
                                }
                            }
                            flexDataWrapperList.add(flexWrapper);
                            viewWrapper = new FlexTableWrapper(flexAction.Label__c,flexDataWrapperList);
                        }
                    }else {
                        viewWrapper = new FlexTableWrapper(flexTableHeader,flexDataWrapperList);
                    }
                     viewWrapper.fieldApiNameToDataType = fieldApiNameToDataType;
                    flexTableWrapperList.add(viewWrapper);
                }   
            } 
        } else {   
            Schema.SObjectType checkObjectType = SchemaManager.getSObjectTypeFromName(String.escapeSingleQuotes(objectName));
            List<sObject> newflitrObjlist = new List<sObject>();
            if(checkObjectType.getDescribe().isAccessible() == true){
                ObjectList = Database.query(query , AccessLevel.USER_MODE); //SOQL Injection - False +ve - escapeSingleQuotes Applied on whereClause values using  AppUtils.parseWhereClause method to prevent SOQL injection and Dynamic Part of query string is escapeSingleQuotes.      
            }
           

            if(tableName =='History'){
                FlexTableCtrl fltCtrl = new FlexTableCtrl();
                newflitrObjlist = fltCtrl.getHistroyExportRecordsList(ObjectList,objectName);
            }else{
                newflitrObjlist = ObjectList;
            }

            flexTableWrapperList = new List<FlexTableWrapper>();
            flexDataWrapperList = new List<FlexDataWrapper>();
            FlexTableWrapper viewWrapper;
            
            if(newflitrObjlist.size() > 0) {   
            for(Sobject objectRec : newflitrObjlist){
                
                if(hideConditionsArrayMap != null){
                    String recorId = String.valueOf(objectRec.Id);
                    maskMap = maskValueCheck(objectRec,recorId,hideConditionsArrayMap,flexFieldNames);
                }
                Map<String, Schema.DisplayType> fieldDatTypeMap = this.getFieldDataType(objectName,exportFieldNames);
                FlexDataWrapper flexWrapper = new FlexDataWrapper(fieldDatTypeMap,objectRec,sfields,fieldApiNameToDataType,objectName,mode,tableName);
                for(String key : flexWrapper.record.keySet()) {
                    Object value ;
                    Object newValue;
                    if( maskMap != null && apifieldMap.get(key) != null && renderFieldValue(objectRec,apifieldMap.get(key),maskMap) == maskValue){
                        flexWrapper.record.put(key,maskValue);
                    }
                    value = flexWrapper.record.get(key);
                    if(value == 'TextName' && objName.equalsIgnoreCase('Account')){
                        value = 'name';
                    }
                    newValue = '\"' + value + '\"';
                    string datatype = fieldApiNameToDataType.get(key);
                    if((datatype == 'STRING') || (datatype == 'TEXTAREA')){
                        String valStr = (String)flexWrapper.record.get(key);
                        valStr = getAnchorCsvFormattedString(valStr);
                        valStr = handleCommaEncodingInCsv(valStr); 
                        newValue = (Object) valStr;
                    }
                    if((dataType == 'DATE') || (dataType == 'DATETIME')){
                        newValue = '='+newValue;
                    }
                    if((dataType == 'PERCENT')){
                        newValue = '='+newValue;
                    }
                    if(mode != null && mode.equalsIgnoreCase('text/csv')){
                        flexWrapper.record.put(key,newValue);
                    }else{
                        flexWrapper.record.put(key,String.valueOf(value));
                    }
                    
                    if(tableName == 'History') {
                        if(key=='ParentId' || key=='Parent.Name') {
                            if(useHistoryNameField == false) {
                                flexWrapper.record.put(key, uniqueField);
                            }
                        }
                        if(key=='Field') {
                            if(value != null) {
                                if(String.valueOf(value) == 'RecordType'){
                                    flexWrapper.record.put(key, 'RecordType');
                                }else if(String.valueOf(value) == 'Owner'){
                                    flexWrapper.record.put(key, 'Owner');
                                }else{
                                SchemaManager.Field fld = SchemaManager.getFieldSchemaResult(objName,String.valueOf(value).trim());
                                flexWrapper.record.put(key, fld.fieldDesc.getLabel()+'');
                            }
                        }
                        }
                        if(key =='NewValue'){
                            flexWrapper.record.put(key,flexWrapper.NewValue !=''?flexWrapper.NewValue:flexWrapper.record.get(key));
                        }

                        if(key == 'OldValue'){
                            flexWrapper.record.put(key,flexWrapper.OldValue !=''?flexWrapper.OldValue:flexWrapper.record.get(key));
                        }
                    }
                }
                flexDataWrapperList.add(flexWrapper);
                viewWrapper = new FlexTableWrapper(flexTableHeader,flexDataWrapperList);
            }
            }else {                
                viewWrapper = new FlexTableWrapper(flexTableHeader,flexDataWrapperList);                
            }
            for(String key: mainMap.keyset()){
                string key2 = apifieldMap.get(key);
                if(checkOverallEnableMap.containsKey(key2) && checkOverallEnableMap.get(key2)){
                Double totalValues = 0;
                list<string> values = mainMap.get(key);
                for(String v1 :values){
                    v1 = v1.replaceAll(',' ,'');
                    if(v1.contains('(')){
                        v1 = v1.replaceAll('\\(' ,'');
                        v1 = v1.replaceAll('\\)' ,'');
                        v1 = v1.replaceAll('%' ,'');
                        v1='-'+v1;
                    }else if(v1.contains('%')){
                        v1 = v1.replaceAll('%' ,'');
                    }
                    

                    totalValues += Decimal.valueOf(v1);
                }
                totalNumberMap.put(key,totalValues);
            }
        }
                //CSV support total
            Map<String, String> totalMap2 = new  Map<String, String>();
            if(hideTotalCheck && totalNumberMap != null && totalNumberMap.size()>0){
            for(Integer indx : index){
                string dataType = fieldApiNameToDataType.get(indexAPI.get(indx));
                if(indx == 0 && totalNumberMap != null){
                    totalMap2.put(indexAPI.get(indx),lableOfTotal);
                }else if(totalNumberMap.containsKey(indexAPI.get(indx))){
                    if(datatype == 'CURRENCY'){
                        string valueForPrint = fdw.getFormattedNumberCSV(totalNumberMap.get(indexAPI.get(indx)), objectName, indexAPI.get(indx));
                        valueForPrint = AppUtils.getLocaleCurrencySymbol()+valueForPrint; 
                        totalMap2.put(indexAPI.get(indx),valueForPrint);
                    }else if(datatype == 'PERCENT'){
                        
                        String valueForPrint = fdw.getFormattedNumberCSV(totalNumberMap.get(indexAPI.get(indx)), objectName, indexAPI.get(indx));
                       if(valueForPrint.contains('-')){
                        valueForPrint = '('+valueForPrint.remove('-')+'%)';
                    }else  if(!valueForPrint.contains('%')){
                        valueForPrint = valueForPrint+'%';
                    }
                        totalMap2.put(indexAPI.get(indx),valueForPrint);
                    }else{
                        string valueForPrint = fdw.getFormattedNumberCSV(totalNumberMap.get(indexAPI.get(indx)), objectName, indexAPI.get(indx));

                        totalMap2.put(indexAPI.get(indx),valueForPrint);
                    }
                    
                }else{
                    totalMap2.put(indexAPI.get(indx),'');
                }
            } 
                   
            viewWrapper.totalMap1=totalMap2;
            if(totalMap2.size() <  1){
                this.hideTotal = false;
            }else{
                this.hideTotal = true;
            }
        }  
            viewWrapper.fieldApiNameToDataType = fieldApiNameToDataType;
            flexTableWrapperList.add(viewWrapper);
        }
    }
    
    public Component.Apex.OutputPanel createFlextblExportForPrint(String tblName, String modeRender){
        tableName = tblName;
        mode = modeRender;
        return getDataTable();
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

    Set<string> removeHideColumn(List<String >tableFieldAPIList,sObject record,Map<String,String> hideColumnMap ,Map<String ,Boolean> hideGroupingColumns){
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
            if(hideGroupingColumns.get(apiName)!=null && record!=null){
                if(hideGroupingColumns.get(apiName) == true){
                    tableFieldAPISet.remove(apiName);
                }
            }
        }
        return tableFieldAPISet;
    }

     public Component.Apex.OutputPanel getDataTable(){
        body = new Component.Apex.OutputPanel();
        fetchData();
        DataTableConfig__c flexTable = flexTableMap.get(tableName);
        if(flexTable.PDFRenderType__c == 'Block'){
            return renderFlexBlock(flexTableWrapperList);
        }else{
        return renderFlexTable(flexTableWrapperList);
    }
    }

    private Component.Apex.OutputPanel renderFlexBlock(List<FlexTableWrapper> flexTableWrapList){
        Component.Apex.OutputPanel panel = new Component.Apex.OutputPanel(); 
        if(flexTableWrapList.size() > 0){
            for(FlexTableWrapper ftWrapper : flexTableWrapList){
                html = '<div class="flexTableHeader flexTableHeaderBg">';
                html += ftWrapper.header != null ? ftWrapper.header : '';
                html += '</div>';   
                html += '<div style="margin-bottom:10px;">';  
                for(FlexDataWrapper flxDataWrap : ftWrapper.flexDataWrapperList){
                    html += '<div class="1" style="border:1px solid #ccc; padding: 15px">';
                    for(Integer indx: index){
                        html += '<div style="margin-bottom:5px;"><b style="margin-right:10px;">';
                        html +=  indexLabel.get(indx);
                        html += ':</b> ';
                        html += '<span>';
                        html += flxDataWrap.record.get(indexAPI.get(indx));
                        html += '</span></div>';  
                    } 
                    html += '</div>';                 
                } 
                html += '</div>'; 
                addHTMLToBody();       
            }
        }else{
            html += '<div colspan="'+ indexSize +'" style="text-align:center"> No Records found.</div>'; 
        } 
         return body;       
    }

    private Component.Apex.OutputPanel renderFlexTable(List<FlexTableWrapper> flexTableWrapList){
        Component.Apex.OutputPanel panel = new Component.Apex.OutputPanel(); 
        if(flexTableWrapList.size() > 0){
            Boolean alignToRight = false;
            String dataType;
            String strCSSStyle = 'text-align: right; padding-right: 10px;';
            for(FlexTableWrapper ftWrapper : flexTableWrapList){
                  html = '<div class="flexTableHeader">';
                  html += ftWrapper.header != null ? ftWrapper.header : '';
                  html += '</div>';

                  html += '<div><table width="100%" border="1" cellspacing="0" cellpadding="0" class="orgtable pdf-wrap-table" style="width:100%;border-collapse: collapse; overflow: auto;">';
                  html += '<tr>';
                      for(Integer indx: index){
                            html += '<th align="center" wrap="wrap" class="tableCell orgtable flexTableLabelstyle pdf-wrap-th" width="'+indexwidth.get(indx)+'"';
                            
                            alignToRight = ftWrapper.fieldApiNameToDataType != null && ftWrapper.fieldApiNameToDataType.containsKey(indexAPI.get(indx)) && ftWrapper.fieldApiNameToDataType.get(indexAPI.get(indx)) != null && setFieldTypesToTextAlignRight != null && setFieldTypesToTextAlignRight.contains(ftWrapper.fieldApiNameToDataType.get(indexAPI.get(indx)));
                            if(alignToRight){
                                html += ' style="'+ strCSSStyle + '"';
                            }
                            html += '>';

                            html +=  indexLabel.get(indx);
                            html += '</th>';
                      }
                 html += '</tr>';

                 String strValue;
                 for(FlexDataWrapper flxDataWrap : ftWrapper.flexDataWrapperList){
                    html += '<tr>';
                    for(Integer indx : index){
                        html += '<td class="tableCell orgtable flexTablevaluestyle pdf-wrap-td">';
                        html += '<div style="vertical-align:top;margin-left: 2px; overflow-wrap: break-word;word-break: break-all;';
                        dataType = ftWrapper.fieldApiNameToDataType != null && ftWrapper.fieldApiNameToDataType.containsKey(indexAPI.get(indx)) ? ftWrapper.fieldApiNameToDataType.get(indexAPI.get(indx)) : null;
                        alignToRight = String.isNotBlank(dataType) && setFieldTypesToTextAlignRight != null && setFieldTypesToTextAlignRight.contains(dataType);
                        if(alignToRight){
                            html += strCSSStyle;
                        } 

                        html += '">';
                        strValue = flxDataWrap.record.get(indexAPI.get(indx)) != null ? String.valueOf(flxDataWrap.record.get(indexAPI.get(indx))) : '';
                         if(dataType == 'TEXTAREA'){
                            String pattern = '(?i)<[^>]*>';
                            strValue = strValue.replaceAll(pattern, '');
                         } 
                        if(alignToRight && String.isNotBlank(strValue)){
                            if(dataType != 'CURRENCY' && dataType != 'DOUBLE' && dataType != 'INTEGER') {
                                strValue = getFormattedNumber(flxDataWrap.record.get(indexAPI.get(indx)), objectName, indexAPI.get(indx));
                            } 
                            if(dataType == 'PERCENT'){
                                Integer fieldScale = 0;
                                try{
                                    fieldScale = SchemaManager.getSObjectField(objectName,  indexAPI.get(indx)).getDescribe().getScale();
                                }catch(Exception exc){
                                    fieldScale = SchemaManager.getSObjectField(objectName, AppUtils.getNameSpacePrefix() +  indexAPI.get(indx)).getDescribe().getScale();
                                }
                                String val = String.valueOf(flxDataWrap.record.get(indexAPI.get(indx)));
                                strValue = val;
                            }
                            if(strValue.contains('-')){
                                strValue = '('+ strValue.remove('-') +')';
                            } 
                        }
                                                       
                        html += strValue;
                        html += '</div>';
                        html += '</td>';
                    }
                    html += '</tr>';   
                 }
                FlexDataWrapper fdw = new FlexDataWrapper();  
                if(hideTotalCheck && totalNumberMap != null && totalNumberMap.size()>0){
                 html += '<tr>';
                 for(Integer indx : index){
                    html += '<td class="tableCell orgtable flexTablevaluestyle pdf-wrap-td ">';
                        html += '<div style="vertical-align:top;margin-left: 2px; overflow-wrap: break-word;word-break: break-all;';
                        dataType = ftWrapper.fieldApiNameToDataType != null && ftWrapper.fieldApiNameToDataType.containsKey(indexAPI.get(indx)) ? ftWrapper.fieldApiNameToDataType.get(indexAPI.get(indx)) : null;
                        alignToRight = String.isNotBlank(dataType) && setFieldTypesToTextAlignRight != null && setFieldTypesToTextAlignRight.contains(dataType);
                        if(alignToRight){
                            html += strCSSStyle;
                        } 
                        html += '">';
                    if(indx == 0 && totalNumberMap != null){
                        html+='<b>'+lableOfTotal+'</b>';
                    }else{
                        for(String key: totalNumberMap.keyset()){
                            if(indexAPI.get(indx) == key){
                                string valueForPrint ;
                                try {
                                    valueForPrint = fdw.getFormattedNumberCSV(totalNumberMap.get(key), objectName, key);
                                }catch (Exception e) {
                                    string Key2 = apifieldMap.get(Key);
                                    valueForPrint = fdw.getFormattedNumberCSV(totalNumberMap.get(key), objectName, Key2);
                                }
                                if(dataType == 'CURRENCY'){
                                    html+='<b>'+AppUtils.getLocaleCurrencySymbol()+valueForPrint+'</b>';
                                }else if(dataType == 'PERCENT'){
                                   
                                    if(valueForPrint.contains('-')){
                                        valueForPrint = '('+ valueForPrint.remove('-') +'%)';
                                    } else{
                                        valueForPrint = valueForPrint+'%';
                                    }
                                    html+='<b>'+valueForPrint+'</b>';
                                }else if(valueForPrint.contains('-')) {
                                    html+='<b>'+'('+ valueForPrint.remove('-') +')'+'</b>'; 
                                 }else{
                                    html+='<b>'+valueForPrint+'</b>';  
                                }
                                
                            }
                            
                        }
                        
                    }
                    html += '</div>';
                    html += '</td>';

                 }
                 html += '</tr>';
                }

                 html += '</table>';
                 html += '</div>';
                 addHTMLToBody();
            }
        }else{
            html += '<tr> <td colspan="'+ indexSize +'" style="text-align:center"> No Records found. </td> </tr>'; 
            addHTMLToBody();
        }

        return body;
    }

    private String getFormattedNumber(Object numberValue, String strObjectName, String strFieldName){
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

    private void addHTMLToBody() {
        if (String.isNotEmpty(html)) {
            body.childComponents.add(new Component.Apex.OutputText(Value=html, escape=false));
            html = '';
        }       
    }
    
    private String handleCommaEncodingInCsv(String fieldValue){
        String doubleQuotes = '"';
        if(String.isNotEmpty(fieldValue) && fieldValue.contains(',')){
            fieldValue= fieldValue.replace('"','""');
            fieldValue = doubleQuotes + fieldValue +doubleQuotes;
        }
        return fieldValue;
    }

     public string getAnchorCsvFormattedString(String fieldString){
            if(fieldString.startsWith('<a')){
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
                         valueF = valueF.removeEnd('; ');
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
    
    public with sharing class FlexTableWrapper {
        public String header{get;set;}
        public List<FlexDataWrapper> flexDataWrapperList {get;set;}
        public Map<String, String> fieldApiNameToDataType {get;set;}
        public Map<String, String> totalMap1 {get;set;}

        public FlexTableWrapper(String header, List<FlexDataWrapper> wrapperList) {
            this.header = header;
            this.flexDataWrapperList = wrapperList;
        }
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
    public static Map<String,List<String>> mainMap = new Map<String,List<String>>(); 
    public with sharing class FlexDataWrapper{        
        public Map<String,Object> record {get;set;}  
        public String oldValue {get;set;}
        public String newValue {get;set;}
        public String dataType {get;set;}
        public Map<String, Schema.DisplayType> fieldDatTypeMap{get; set;}
        public String getFormattedNumber(Object numberValue, String objectName, String fieldName){
            return new FlexTableExportCtrl().getFormattedNumber(numberValue, objectName, fieldName);
        }
        public FlexDataWrapper(){
        }
        public FlexDataWrapper(Map<String, Schema.DisplayType> fieldDatTypeMap,Sobject record, String [] sFields,Map<String,String> fieldApiNameToDataType, String objectName, String mode, String tableName){
            this.record = new Map<String,Object>();
            this.oldValue = '';
            this.newValue = '';
            this.dataType = '';
            this.fieldDatTypeMap = fieldDatTypeMap;
            String objNameVal ='';
            String fieldType = '';
            Integer scaleVal;
            if(tableName == 'History'){
                if(objectName != null && objectName.contains('__History')){
                    objNameVal = objectName.replace('__History','__c');
                }else{
                    objNameVal = objectName.replace('History','');
                }
                Schema.SObjectType parentObjectType = SchemaManager.getSObjectTypeFromName(objNameVal);
                Schema.DescribeSObjectResult parentObjectResult = parentObjectType.getDescribe();
                Map<String,Schema.SObjectField> parentObjectFieldsMap = parentObjectResult.fields.getMap();
                String fieldAPIName = record.get('Field')+'';
                if(fieldAPIName.equalsIgnoreCase('TextName') && objNameVal.equalsIgnoreCase('Account')) { 
                    fieldAPIName = 'name';
                }
                if(fieldAPIName != 'RecordType'  && fieldAPIName != 'Owner'){//Bug 145679: NED - Add field history on payments//Bug 150629: Bug 114866: Organization - Enable History tab-Field Tracking (Shield)
                Schema.DescribeFieldResult fieldDescribe = parentObjectFieldsMap.get(fieldAPIName.toLowerCase()+'').getDescribe();
                fieldType = fieldDescribe.getType()+'';
                scaleVal = fieldDescribe.getScale();
            }
            }
            Object fieldValue;
            for(String field : sFields){
                String contentOfNote = null; //B28u07g81
                String contentOfNoteforXLS = null; //B28u69g66 - for XLS added this code
                fieldValue = null;  // Changes for unwanted value getting put in Lookup if blank during Export.
                string datatype = fieldApiNameToDataType.get(field);
                Boolean isFileTitle = false;
                if(field.equalsIgnoreCase('Content') && objectName == 'ContentNote'){ //B28u07g81
                    ContentNote contNoteRecord =  (ContentNote)record; //type cast sobject into Content note as Sobject blob was not able to convert to string
                    contentOfNote = contNoteRecord.Content.toString();           
                    contentOfNoteforXLS = contentOfNote.replaceAll('<[^>]*>',''); //B28u69g66 - for XLS added this code
                    contentOfNoteforXLS = contentOfNoteforXLS.replaceAll('\u200b','');
                    contentOfNoteforXLS = contentOfNoteforXLS.replaceAll('&#39;','\'');
                    contentOfNoteforXLS = contentOfNoteforXLS.replaceAll('&amp;','&');
                    contentOfNoteforXLS = contentOfNoteforXLS.replaceAll('&quot;','\"');
                }

                if(field.equalsIgnoreCase('Title') && (objectName == 'ContentVersion' || objectName == 'ContentDocument')){
                    //String fullFileURL = URL.getSalesforceBaseUrl().toExternalForm() +'/' + record.Id;
                    //String result = '<a href="' + fullFileURL + '?isdtp=vw"  target="_blank" styleClass="btn" class="tableRowLinks" title="' +  record.get('Title')+ '">' +  record.get('Title') + '</a>';
                    String result = (String)record.get('Title');
                    this.record.put(field,result);
                    isFileTitle = true;
                }
                if((dataType == 'STRING' || dataType == 'TEXTAREA') && !field.contains('.') ){
                    String fieldString  = String.valueOf(record.get(field));
                    if(!isFileTitle && String.isNotEmpty(fieldString)){                        
                        if(fieldString.startsWith('<img')){
                          String formulaTxt = getAltValue(fieldString);  
                          this.record.put(field,formulaTxt); 
                        }else if(fieldString.startsWith('<a')){
                           String formulaTxt = getFormattedString(fieldString);
                           this.record.put(field,formulaTxt); 
                        }else{
                        String val = getFormattedString(fieldString);
                        this.record.put(field,val.replaceAll('\n','<br />'));
                        }
                    } else if(String.isEmpty(fieldString)){
                        this.record.put(field,'');
                    } 
                }else if((dataType == 'DATETIME') && !field.contains('.')){
                    String val = String.valueOf(record.get(field));
                    if(!String.isEmpty(val)){
                        DateTime fieldVal = Datetime.valueOfgmt(val);                   
                        //String dateTimeValue = fieldVal.format('MM/dd/yyyy hh:mm a', String.valueOf(UserInfo.getTimeZone()));
                        String dateTimeValue = fieldVal.format(AppUtils.getUserDateTimeFormat(), String.valueOf(UserInfo.getTimeZone()));
                        this.record.put(field,dateTimeValue);
                    }else{
                        this.record.put(field,'');
                    }                   
                                        
                }else if(dataType == 'DATE' && !field.contains('.')){
                    String val = String.valueOf(record.get(field));
                    if(!String.isEmpty(val)){
                        DateTime fieldVal = DateTime.valueOf(val);                  
                        String dateTimeValue = fieldVal.format(AppUtils.getUserDateFormat(), String.valueOf(UserInfo.getTimeZone()));
                        this.record.put(field,dateTimeValue);
                    }else{
                        this.record.put(field,'');
                    }
                }else if(fieldDatTypeMap.get(field) != null && fieldDatTypeMap.get(field) == Schema.DisplayType.PICKLIST && !field.contains('.') ){
                        String objName = objectName;
                        String label;
                    if(tableName == 'History') {
                        String fieldName = String.valueOf(record.get('Field'));
                        if(objName != null && objName.contains('__History')){
                            objName = objName.replace('__History','__c');
                        }else{
                            objName = objName.replace('History','');
                        }
                        if(fieldName.equalsIgnoreCase('TextName') && objName.equalsIgnoreCase('Account')){
                            fieldName = 'name';
                        }
                        Schema.DescribeFieldResult dsr;
                        if(fieldName != 'RecordType'  && fieldName != 'Owner'){//Bug 145679: NED - Add field history on payments//Bug 150629: Bug 114866: Organization - Enable History tab-Field Tracking (Shield)
                             dsr = SchemaManager.fetchDescribeFieldResult(objName,fieldName);
                        }
                        if(dsr!= null && dsr.getType() == Schema.DisplayType.PICKLIST){
                            for(Schema.PicklistEntry ple : dsr.getPicklistValues()){
                                label = ple.getLabel();
                                if(record.get('NewValue') == ple.getValue()){
                                    //record.put('NewValue',label);
                                    NewValue = label;
                                }else{
                                    this.record.put(field,record.get(field));
                                }
                                if(record.get('OldValue') == ple.getValue()){
                                    //record.put('OldValue',label);
                                    OldValue = label;
                                }else{
                                    this.record.put(field,record.get(field));
                                }
                            }
                        }else{
                            this.record.put(field,record.get(field));
                        }
                    }else{
                        this.record.put(field,record.get(field));
                    }
                    //this.dataType = 'PICKLIST';
                }else if(dataType == 'TIME' && !field.contains('.')){
                    Time val = (Time) record.get(field);
                    if(val !=null){
                        Datetime fieldVal = Datetime.newInstance(System.today(), val);
                        String timeVal = fieldVal.format(AppUtils.getUserDateTimeFormat(), String.valueOf(UserInfo.getTimeZone()));
                        if(timeVal !=null){
                            List<String> dtStrvalLst = timeVal.split(' ');
                            String ampmVal = dtStrvalLst.size() > 2 ? dtStrvalLst[2] : '';
                            String timeStr = dtStrvalLst[1]+' '+ampmVal;
                            this.record.put(field,timeStr);
                        }
                    }else{
                        this.record.put(field,'');
                    }
                }else if(dataType == 'REFERENCE' && !field.contains('.')){
                    field = field.replace('__c','__r');
                    String val = String.valueOf(record.get(field+'.Name'));
                    if(!String.isEmpty(val)){
                        this.record.put(field,val);
                    }else{
                        this.record.put(field,'');
                    }    
                }else if(dataType == 'CURRENCY' && !field.contains('.') ) {
                    String val1;
                    String fieldVal=String.valueOf(record.get(field));
                    if(fieldVal != null){
                            Decimal currDecVal=Decimal.valueOf(fieldVal);
                            val1 = getFormattedNumberCSV(Double.valueOf(record.get(field)), objectName, field);
                            //Bug 103742: Internal - Flex Table - PDF is not showing total at PDF and CSV
                            if(mainMap.get(field)!= null)
                            {
                                List<string> volatileList= mainMap.get(field);
                                volatileList.add(val1);
                                mainMap.put(field,volatileList);
                            }
                            else{
                                List<string> vlaueList= new List<string>();
                                vlaueList.add(val1);
                                mainMap.put(field,vlaueList);
                            }
                    }
                   // String val1 = getFormattedNumber(record.get(field), objectName, field);//String.valueOf(record.get(field));
                    if(String.isNotBlank(val1)){
                        this.record.put(field, AppUtils.getLocaleCurrencySymbol() + val1);
                    }else{
                        this.record.put(field,'');
                    }
                
                } else if(dataType == 'PERCENT' &&  !field.contains('.')){
                    String fieldVal=String.valueOf(record.get(field));
                    String val1 ;
                    if(fieldVal != null){
                            Decimal currDecVal=Decimal.valueOf(fieldVal);
                            val1 = getFormattedNumberCSV(Double.valueOf(fieldVal), objectName, field);
                            //Bug 103742: Internal - Flex Table - PDF is not showing total at PDF and CSV
                            if(val1.contains('-')){
                                val1 = '('+val1.remove('-')+'%)';
                            }else{
                                val1 = val1+'%';
                            }
                if(mainMap.get(field)!= null)
                            {
                                List<string> volatileList= mainMap.get(field);
                                volatileList.add(val1);
                                mainMap.put(field,volatileList);
                            }
                            else{
                                List<string> vlaueList= new List<string>();
                                vlaueList.add(val1);
                                mainMap.put(field,vlaueList);
                            }
                    }
                    if(String.isNotBlank(val1) ){
                        if(val1.contains('-')){
                            val1 = '('+val1.remove('-')+'%)';
                        }if(!val1.contains('%')){
                            val1 = val1+'%';
                        }
                        this.record.put(field, val1);
                    }else{
                        this.record.put(field,'');
                    }

                }else{
                    if(!String.isEmpty(field) && field.containsIgnoreCase('.')){
                        String[] fieldName = field.split('\\.');
                        Sobject intRecord = record.getSobject(fieldName[0]);
                        Integer i = 1;
                        for(i = 1; i < fieldName.size()-1 ; i++){
                            if(intRecord  != null){
                                intRecord = intRecord.getSobject(fieldName[i]);
                            }
                        }
                        if(intRecord != null){
                             fieldValue = intRecord.get(fieldName[i]);
                             if((dataType == 'STRING' || dataType == 'TEXTAREA') && !field.contains('.') ){
                                String fieldString  = String.valueOf(fieldValue);
                                if(!String.isEmpty(fieldString)){
                                    String val = getFormattedString(fieldString);
                                    this.record.put(field,val);
                                      
                                } 
                                
                             }else if((dataType == 'DATETIME') && !field.contains('.')){
                                String val = String.valueOf(record.get(field));
                                if(!String.isEmpty(val)){
                                    DateTime fieldVal = Datetime.valueOfgmt(val);                   
                                    String dateTimeValue = fieldVal.format('MM/dd/yyyy hh:mm a', String.valueOf(UserInfo.getTimeZone()));
                                    this.record.put(field,dateTimeValue);
                                }else{
                                    this.record.put(field,'');
                                }                   
                                                    
                            }else if(dataType == 'DATE' && !field.contains('.')){
                                String val = String.valueOf(record.get(field));
                                if(!String.isEmpty(val)){
                                    DateTime fieldVal = DateTime.valueOf(val);                  
                                    String dateTimeValue = fieldVal.format('MM/dd/yyyy', String.valueOf(UserInfo.getTimeZone()));
                                    this.record.put(field,dateTimeValue);                   
                                }else{
                                    this.record.put(field,'');
                                }
                            }
                        }
                        if(fieldValue != null){
                            if((dataType == 'DATETIME') && field.contains('.') ){
                                String val = String.valueOf(fieldValue);
                                if(!String.isEmpty(val)){
                                    DateTime fieldVal = Datetime.valueOfgmt(val);
                                    String dateTimeValue = fieldVal.format('MM/dd/yyyy hh:mm a', String.valueOf(UserInfo.getTimeZone()));
                                    this.record.put(field,dateTimeValue);
                                }else{
                                    this.record.put(field,'');
                                }
                            }else if(dataType == 'CURRENCY' && field.contains('.')) {
                                String val = String.valueOf(fieldValue);
                                if(String.isNotEmpty(val)){
                                    Decimal decimalVal =  Decimal.valueOf(val);
                                    String finalVal = decimalVal < 0 ? '('+AppUtils.getLocaleCurrencySymbol() : AppUtils.getLocaleCurrencySymbol();
                                    finalVal += Math.abs(decimalVal).format();
                                    finalVal += decimalVal < 0 ? ')' : '';
                                    this.record.put(field, finalVal);
                                    if(dataType=='CURRENCY'){
                                        if(mainMap.get(field)!= null){
                                        List<string> volatileList= mainMap.get(field);
                                        volatileList.add(String.valueOf(fieldValue));
                                        mainMap.put(field,volatileList);
                                        }else{
                                        List<string> vlaueList= new List<string>();
                                        vlaueList.add(String.valueOf(fieldValue));
                                        mainMap.put(field,vlaueList);
                                        }
                                      }
                                }else {
                                    this.record.put(field,'');
                                }
                            } else if(dataType == 'DATE'  && field.contains('.') ){
                                String val = String.valueOf(fieldValue);
                                if(!String.isEmpty(val)){
                                    DateTime fieldVal = DateTime.valueOf(val);                  
                                    String dateTimeValue = fieldVal.format('MM/dd/yyyy', String.valueOf(UserInfo.getTimeZone()));
                                    this.record.put(field,dateTimeValue);                   
                                }else{
                                    this.record.put(field,'');
                                }
                            }else{
                                this.record.put(field,fieldValue);
                                 if(dataType=='DOUBLE'){
                                    if(mainMap.get(field)!= null){
                                    List<string> volatileList= mainMap.get(field);
                                    volatileList.add(String.valueOf(fieldValue));
                                    mainMap.put(field,volatileList);
                                    }else{
                                    List<string> vlaueList= new List<string>();
                                    vlaueList.add(String.valueOf(fieldValue));
                                    mainMap.put(field,vlaueList);
                                    }
                                  } 
                            } 
                            
                        }else{
                            this.record.put(field,'');
                        }
                    }else{
                        fieldValue  = record.get(field);
                        if(fieldValue != null){
                             if(fieldType == 'CURRENCY'){
                                String fieldVal=String.valueOf(fieldValue);
                                Decimal currDecVal=Decimal.valueOf(fieldVal);
                                String formatCurrVal=AppUtils.getFormattedNumber(Double.valueOf(currDecVal),scaleVal,true,fieldType);
                                this.record.put(field,formatCurrVal);
                            }
                            if(fieldType == 'DOUBLE' || fieldType == 'INTEGER' || fieldType == 'PERCENT'){
                                String fieldVal=String.valueOf(fieldValue);
                                String formatedNumberVal = AppUtils.getFormattedNumber(Double.valueOf(fieldVal),scaleVal,false,fieldType);
                                this.record.put(field,formatedNumberVal);
                            }
                            if(String.valueOf(fieldValue).contains('00:00:00')){
                                String updatedVal =Datetime.valueOf(String.valueOf(fieldValue)).format(AppUtils.getUserDateFormat());
                                updatedVal =  updatedVal.replace('00:00:00','');
                                this.record.put(field,updatedVal);
                            }else{
                                try{
                                    String updatedVal;
                                    if(dataType == 'BASE64'){
                                        if(mode =='application/vnd.ms-excel'){
                                            updatedVal = String.isNotBlank(contentOfNoteforXLS) ? contentOfNoteforXLS : ''; //B28u69g66 - for XLS added this code
                                        }else{
                                            updatedVal = String.isNotBlank(contentOfNote) ? contentOfNote : ''; //B28u07g81
                                        }
                                    }else{
                                        updatedVal =Datetime.valueOf(String.valueOf(fieldValue)).format(AppUtils.getUserDateTimeFormat());
                                    }
                                    this.record.put(field,updatedVal);
                                }catch(System.TypeException err){
                                   if(fieldType != 'CURRENCY' && fieldType != 'DOUBLE' && fieldType != 'INTEGER' && fieldType != 'PERCENT')
                            this.record.put(field,fieldValue);
                            //
                                if(dataType == 'DOUBLE'){
                                    if(mainMap.get(field)!= null){
                                        String fieldVal=String.valueOf(fieldValue);
                                        List<string> volatileList= mainMap.get(field);
                                        volatileList.add(fieldVal);
                                        mainMap.put(field,volatileList);
                                    }else{
                                        String fieldVal=String.valueOf(fieldValue);
                                        List<string> vlaueList= new List<string>();
                                        vlaueList.add(fieldVal);
                                        mainMap.put(field,vlaueList);
                                       
                                    }
                                    String formatedNum = getFormattedNumberCSV(Double.valueOf(fieldValue),objectName,field);
                                    this.record.put(field,formatedNum);
                                    
                                   }
                                }
                                
                            }

                        }else if(fieldValue != null && dataType == 'DOUBLE' && mode =='application/vnd.ms-excel'){
                            String formatedNum = getFormattedNumberCSV(Double.valueOf(fieldValue),objectName,field);
                            this.record.put(field,formatedNum);
                        }else{
                            this.record.put(field,'');
                        }
                    }                    
                }                
            }
        }
        
        private String getFormattedNumberCSV(Double numberValue, String strObjectName, String strFieldName){
            Decimal decValue = Decimal.valueOf(numberValue);
            Integer fieldScale = 2;
            try{
                fieldScale = SchemaManager.getSObjectField(strObjectName, strFieldName).getDescribe().getScale();
            } catch(Exception exc){
                fieldScale = SchemaManager.getSObjectField(strObjectName, AppUtils.getNameSpacePrefix() + strFieldName).getDescribe().getScale();
            }

            if(fieldScale > 1){
                decValue = decValue.setScale(2,RoundingMode.CEILING);
            }
            String formattedNumber = decValue.format();

            if(fieldScale > 1 && formattedNumber.indexOf('.') != -1 && formattedNumber.length() - formattedNumber.indexOf('.') < 3){
                return formattedNumber + 0;
            }else if(formattedNumber.indexOf('.') == -1){
                return formattedNumber += fieldScale > 1 ? +'.00':'';
            }
            return formattedNumber; 
        }
        
        private String getAltValue(String fieldStr){
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

        private String getAnchorTitleValue(String fieldStr){
            String altVal = '';
             if(!String.isEmpty(fieldStr)){
                String regex = 'title="([^"]*)"';
                Pattern regexForExtractingAlt = Pattern.compile(regex);
                Matcher regexMatcherForExtractingAlt = regexForExtractingAlt.matcher(fieldStr);
            
                while(regexMatcherForExtractingAlt.find()){//SOQL/SOSL Injection False +ve
                   String val = regexMatcherForExtractingAlt.group(0);
                   val = val.remove('title=').remove('"');
                   altVal += val;
                }    
             }

             return altVal;
        }

        
        private string getFormattedString(String fieldString){
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
    }

    private Map<String,String> maskValueCheck( Sobject intRecord , String recorId ,List<Map<String,String>> hideCellMapList, List<String> fieldAPIList){
        Integer index = 0;        
        for(String fieldApi : fieldAPIList){

        if(hideCellMapList != null && hideCellMapList.size() > 0){
            String fieldRes ='';
            if(intRecord != null && fieldApi != null) 
            {
               Schema.DisplayType  fielddataType;
                try {
                   
                   String tempFieldApi = fieldApi;
                   tempFieldApi = tempFieldApi.containsIgnoreCase('__r.')?tempFieldApi.split('__r.').get(0)+'__c':tempFieldApi;
                   if(tempFieldApi.containsIgnoreCase('.Name')){
                        tempFieldApi = tempFieldApi.replace('.Name', 'Id');
                   }
                   fielddataType = intRecord.getSobjectType().getDescribe().fields.getMap().get(tempFieldApi.toLowerCase()).getDescribe().getType();
                } catch(Exception ex) {
                    throw new CustomExceptions.InputDataException('Field not found ' + fieldApi + ' for sobject' + intRecord);
                }
               
               if(!fieldApi.containsIgnoreCase('__r.')){
               fieldApi = fielddataType != null && fielddataType == Schema.DisplayType.reference ? fieldApi.containsIgnoreCase('__c')?fieldApi.replace('__c','__c') : fieldApi : fieldApi;
               }
               Object fieldVal = AppUtils.getFieldValue(intRecord, fieldApi);
               fieldRes = fieldVal != null ? String.valueOf(fieldVal) : '';
            }
            for(Map <String,String > fieldInfo: hideCellMapList){
                if(fieldRes.equalsIgnoreCase(String.valueOf(fieldInfo.get('value')))){
                    String tempFieldInfo = fieldInfo.get('column');
                    maskMap.put(tempFieldInfo + recorId,'true');
                    maskMap.put(fieldApi + fieldRes, 'true');
                }
            } 
        }
        }
        
        return maskMap; 
    }
    private String renderFieldValue(Sobject record, String field,  Map<String,String> maskMap) {
        Sobject intRecord = record;
        String recorId = String.valueOf(intRecord.Id);
        String objName = record.getSObjectType().getDescribe().getName();
        Integer decimalScaleValPer=0;
        Integer currcenyDecSacle=0;
        Integer doubleScaleValue=0;
        Schema.DescribeFieldResult fldRes = SchemaManager.getFieldSchemaResult(objName, field).fieldDesc;
        String copyRefField;
        String pkLabel;
            
        String maskValueField = field;
        if(field.containsIgnoreCase('.')){    
                List<String> colSplit = field.split('\\.',-1);          
                Integer i = 0;                  
                do{
                    String fieldAPiName = colSplit[i++];           
                    if(intRecord != null && fieldAPiName!= 'Id'){
                        intRecord = intRecord.getSobject(fieldAPiName);
                        
                    }
                }while(i < colSplit.size() - 1);  
                field = colSplit[i];
        }

        if(intRecord != null && field != null) {    
            Schema.DisplayType  fielddataType;
            Schema.DisplayType  fielddataType1;
            try {
                fielddataType = intRecord.getSobjectType().getDescribe().fields.getMap().get(field.toLowerCase()).getDescribe().getType();
                fielddataType1 = intRecord.getSobjectType().getDescribe().fields.getMap().get(field.toLowerCase()).getDescribe().getType();
                if(fielddataType1 == Schema.DisplayType.reference && maskValueField.containsIgnoreCase('__c')){
                    maskValueField = maskValueField.replace('__c', '__r.Name');
                }
                if(fielddataType == Schema.DisplayType.reference )
                        copyRefField = field;
            } catch(Exception ex) {
                throw new CustomExceptions.InputDataException('Field not found ' + field + ' for sobject' + intRecord);
            }
            if(maskMap.containsKey(maskValueField+recorId)){
                String resultVal;
                resultVal = maskValue;
                return resultVal;
            }  
            switch on fielddataType {
                when Reference {
                    String result='';
                    if(String.valueOf(intRecord.get(copyRefField)) != null) {
                       
                        String objVal = ((Id)intRecord.get(copyRefField)).getSObjectType().getDescribe().getName();
                            field = field.replace('__c','__r.Name');
                            if(field.containsIgnoreCase('.')){          
                                List<String> colSplit = field.split('\\.',-1);          
                                Integer i = 0;                
                                do{
                                String fieldAPiName = colSplit[i++];           
                                    if(intRecord != null){
                                    intRecord = intRecord.getSobject(fieldAPiName);
                                    }
                                }while(i < colSplit.size() - 1);  
                                field = colSplit[i];
                                result = ((String)intRecord.get(field));
                            }else{
                            result =String.ValueOf(intRecord.get(copyRefField));
                            }
                    }
                    return result;
                }  
                when STRING, TEXTAREA {
                    if(!field.contains('.')){
                String fieldVal = String.valueOf(intRecord.get(field)); 
                if(String.isNotEmpty(fieldVal)){
                    fieldVal = fdw.getFormattedString(fieldVal);
                }
                fieldVal = fieldVal !=null ? fieldVal : '';
                return fieldVal;               
            }
                }
                when DATETIME {
                    String dtVal ='';
                    DateTime d = (DateTime) intRecord.get(field);
                    if (d != null) { 
                        Integer offset = UserInfo.getTimezone().getOffset(d);
                        offset = offset - UserInfo.getTimezone().getOffset(d) - 3600000;
                        offset = offset + 3600000;
                        Datetime local = d.addSeconds(offset/1000);
                        dtVal += local.format(AppUtils.getUserDateTimeFormat());
                    }
                    return dtVal;
                }
                when PERCENT {
                    decimalScaleValPer = fldRes.getScale();
                    decimalScaleValPer =  decimalScaleValPer > 2 ? 2 : decimalScaleValPer;           
                }
                when CURRENCY {
                    currcenyDecSacle = fldRes.getScale();
                    currcenyDecSacle = currcenyDecSacle > 2 ? 2 : currcenyDecSacle;
                }
                when DOUBLE {
                    doubleScaleValue = fldRes.getScale();
                }
                when PICKLIST {
                    String pkVal = String.valueOf(intRecord.get(field));
                    if(fldRes.getType() == Schema.DisplayType.PICKLIST){
                        for(Schema.PicklistEntry ple : fldRes.getPicklistValues()){
                            if(pkVal == ple.getValue() &&  ple.getValue() != null){
                                pkLabel = ple.getLabel();
                            }
                        }
                    }
                    return pkLabel != null ? pkLabel :'';
                }
            }   
        }
        return '';
    }

    
     @TestVisible 
     public with sharing class exportWrapper{
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
         

        public exportWrapper(list<sObject> sObjectList, Map<String, String> fieldLableMap,Map<String, String> fieldDataTypeMap,Map<String, Integer> scaleMap,String label){
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