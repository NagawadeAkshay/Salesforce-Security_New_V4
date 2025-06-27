/**
    **********************************************************
    Audit History
    **********************************************************  
    2014-01-01     Prem Pal         Created class 
    **********************************************************  
*/
global with sharing class FlexTableCtrl{
    /*The datatable config object name query to display the list view*/ 
    global transient string dataTableConfigName {get; set;}
    private static String globalQueryString{get; set;}
    public string attachmentNamespace {get; set;}
    public Integer  flexTableCtrlTimeOffset {
        get{            
            TimeZone tz = UserInfo.getTimeZone();           
            return tz.getOffset(System.now());
        }set;
    }
    //Test for Git by shubhangi
    /* Maximum record limit that we'll use in the limit clause */
    private static final integer MAX_LIMIT = 10000;
    
    private static final Boolean DebugFlag = true;
    
    /* Standard set controller to be used for the records */
    private transient ApexPages.StandardSetController setCon;
    private static String recordType {get; set;}
    public static String originalObjectName {get; set;} 
    global transient String searchTerm {get;set;}
    global transient String objectName{get;set;}
    global transient String sObjectNameForFieldHistory{get;set;}
    public transient String recordId {get; set;}
    global transient String phase{get;set;}  
    public transient Boolean isPreviewMode{get;set;} 
    public transient Boolean isFieldHistory{get;set;}
    private Boolean isPBIdAdded = false;
    global String keyValueMap{
        get;set;
     }
     
     public String getKeyValMapStr() {
         if(String.isNotEmpty(keyValueMap) && String.isNotEmpty(pbId)) {
                Map<String,Object> tableParamMap = new Map<String, Object>();
                tableParamMap = (Map<String,Object>) JSON.deserializeUntyped(keyValueMap);
                tableParamMap.put('pageBlockId', pbId);
                return JSON.serialize(tableParamMap);
        }
        return keyValueMap;
     }
    
    public String getNamespace() {
        return AppUtils.getNameSpacePrefix();
    }

    public transient String pbId{
        get;set; 
     }  
    global transient String listKeyValueMap{get;set;}  
    public transient Boolean admnSetup{get;set;}
    global transient String flexTablePropInfo{get;set;}
    global transient String flexTableHeaderTitle{get;set;}
    global transient String flexHeaderDescription{get;set;}
    public transient String historyObjName{get; set;}
    public transient boolean isHistory{get; set;}
    global transient String flexTableFieldAPIs{get;set;}
    
    public String isN2GSearch{get;set;}
    public String filterClauseN2GSearch{get;set;}
    public String govGrants {
        get;
        set;
    }
    public String govGrantsExternal {
        get;
        set;
    }
    public String tooltipster {
        get;
        set;
    }
    public String externalLibNew {
        get;
        set;
    }
    public static Map<String,Schema.SObjectType> globalDescribe;
    public String parentRecordId{get;
        set{
           
            parentRecordId = value;
            }}
    
    public String currentPageURLButtons {get;set;}
    public String localDateFormat {
        get{
            return AppUtils.getUserDateFormat();
        }set;
    }
    
    public String currentPageURL {
        get{
            String url = ApexPages.currentPage().getUrl();
            String pageName = url.replace('/apex/','');
            pageName = pageName.substringBefore('?');
            String hostString = ApexPages.currentPage().getHeaders().get('Host');
            String domain = '';
            if(!Test.isRunningTest()) {
                domain = hostString.substringBefore('.');
            }
            String namespace = AppUtils.getNamespacePrefix().toLowerCase().remove('__');
            if(!pageName.contains(namespace)){
                if(domain.contains(namespace)){
                    url = url.replace(pageName,String.escapeSingleQuotes(namespace+'__'+pageName));
                }else{
                    url = url.replace(pageName,String.escapeSingleQuotes('c__'+pageName));
                }        
            }
            return url;
        }set;
    }
    public Integer  timeOffset {
        get{            
            TimeZone tz = UserInfo.getTimeZone();           
            return tz.getOffset(System.now());
        }set;
    }
    public String userDateFormat{
        get{
            return AppUtils.getUserDateFormat();
        }set;
    }
    public transient   String namespace {get; set;}
    public transient   String headerDescription {get; set;}
    private FlexGridUtility flexGridUtility;
    public String govGrantPleaseWaitIconURL{get;set;}
    public String currSymbol{
        get{
            return AppUtils.getLocaleCurrencySymbol();
            }set;
    }
    public String timezone{
        get{                     
            return UserInfo.getTimeZone().getID(); 
           
        }set;
    }
    public String locale{
        get{                     
            return UserInfo.getLocale();
           
        }set;
    }
    
    global FlexTableCtrl() {
        this.namespace = AppUtils.getNamespacePrefix();
        attachmentNamespace = this.namespace;
        if(attachmentNamespace!=null && attachmentNamespace!=''){
            attachmentNamespace = attachmentNamespace+'Attachment__c';
        }else{
            attachmentNamespace = 'Attachment__c';
        }
        flexGridUtility = new FlexGridUtility();
        admnSetup = GlobalConfigHelper.getEnableAdminSetup();
        if(admnSetup == null){
            admnSetup = false;
        }
        currentPageURLButtons = URL.getCurrentRequestUrl().toExternalForm();
        //User Story 71061: Internal - Remove document object dependency and move to static resource
        govGrantPleaseWaitIconURL = AppUtils.getIcons('govGrantPleaseWaitIcon');

        // List<String> resourceName= new List<String>{'ExternalLibNew','Tooltipster','GovGrants','GovGrantsExternal'};
        // AppUtils.getResourceURL(resourceName);
        externalLibNew = AppUtils.getIcons('ExternalLibNew');
        tooltipster = AppUtils.getIcons('Tooltipster');
        govGrantsExternal = AppUtils.getIcons('GovGrantsExternal');
        govGrants = AppUtils.getIcons('GovGrants');
    }
    

    @RemoteAction
    global static DateTime inlineEditRecordIds(Id recordId){
        DateTime lastmodifieddateonloadofpage = null;
       if(recordId != null){
            String sObjName = recordId.getSObjectType().getDescribe().getName();
            String strQuery = ' SELECT Id, LastModifiedDate FROM ' + String.escapeSingleQuotes(sObjName) + ' WHERE ID = : recordId';
            List<SObject> listData;
            if(AppUtils.isObjectAccessible(sObjName)){   //CRUD/FLS False +ve with the help of AppUtils we have performed check
                listData = Database.query(String.escapeSingleQuotes(strQuery),AccessLevel.USER_MODE); //SOQL Injection - False +ve - Dynamic part of query is escapeSingleQuotes/static bind
            }
            lastmodifieddateonloadofpage = (DateTime)listData[0].get('LastModifiedDate');
       }
       return lastmodifieddateonloadofpage;
    }

    @RemoteAction
    global static Map<String,Object> setInlineEditRecordIds(List<Id> recordIdSet, String sObjName){
        Map<String,Object> lastModifiedDtforIdsMap = new Map<String,Object>();
        //List<Id> inlineRecIdsList = (List<Id>) JSON.deserialize(recordIdSet, List<Id>.class);
        String strQuery = 'SELECT Id, LastModifiedDate FROM ' + String.escapeSingleQuotes(sObjName) + ' WHERE Id IN :recordIdSet';
        List<SObject> listData;
        if(AppUtils.isObjectAccessible(sObjName)){   //CRUD/FLS False +ve with the help of AppUtils we have performed check
            listData = Database.query(String.escapeSingleQuotes(strQuery),AccessLevel.USER_MODE); //SOQL Injection - False +ve - Dynamic part of query is escapeSingleQuotes/static bind
        }if(listData.size() > 0){
            for(SObject sobjVal: listData){
                lastModifiedDtforIdsMap.put(String.valueOf(sobjVal.get('Id')),sobjVal.get('LastModifiedDate'));
            }
        }
        return lastModifiedDtforIdsMap;
    }


    
    @RemoteAction
    global static void markFlexTableAsActive(map<string,object>args){
        if(Schema.sObjectType.DataTableConfig__c.isAccessible())  {      
            string  flextableId = (string)args.get('flexTableId');
            List<DataTableConfig__c> flexTableList = [SELECT Id,Name,IsActive__c
                                                        FROM DataTableConfig__c 
                                                        WHERE Name = : flextableId 
                                                        AND IsActive__c = false
                                                        WITH USER_MODE];
            if(flexTableList.size() > 0){
                if(Schema.sObjectType.DataTableConfig__c.fields.IsActive__c.isUpdateable()){
                    flexTableList[0].IsActive__c = true;
                }
                if(Schema.sObjectType.DataTableConfig__c.isUpdateable()){
                    update as user flexTableList;
                }
            }
        }
    }

    @RemoteAction
    global static String getLocaleCurrSymbol(){
        String localCurrSymbol = AppUtils.getLocaleCurrencySymbol();
        return localCurrSymbol;
    }
    
    /*
    Method  :   fetchGridType()
    Purpose :   This method is called at initial load of flex grid to get the type of grid that will be displayed.
    */
    @RemoteAction 
    global static Map<String,Object> fetchGridType(String dataTableConfigName,String keyValueMap,String listKeyValueMap,Boolean sforce1) {
        FlexGridUtility flexGridUtility = new FlexGridUtility();
        return flexGridUtility.getGridType(dataTableConfigName, keyValueMap, listKeyValueMap, sforce1);
    }
    /*
    Method  :   fetchInitialSearchData()
    Purpose :   This method is called at initial load of flex skinny table which is displayed on search from side bar.
    */    
    
    global static Map<String,Object> fetchInitialSearchData(String searchTerm,String objectName,String phaseName,String keyValueMap,String listKeyValueMap,Boolean sforce1) {
        return fetchInitialSearchDataWithSorting(searchTerm, objectName, phaseName, keyValueMap, listKeyValueMap, sforce1, null, null);
    }
      
    @RemoteAction
    global static Map<String,Object> fetchInitialSearchDataWithSorting(String searchTerm,String objectName,String phaseName,String keyValueMap,String listKeyValueMap,Boolean sforce1, String orderBy, String sortDirection) {
        Map<String, Object> result = new Map<String, Object>();
        String dataTableConfigName ;
        
        List<PhaseConfig__c> phaseConfig = new List<PhaseConfig__c>();
        if(Schema.sObjectType.PhaseConfig__c.isAccessible()){
            phaseConfig = [SELECT id from PhaseConfig__c WHERE Name =:phaseName WITH USER_MODE];
        }
        if(phaseConfig !=null && phaseConfig.size()>0){
            //Tomy - 14/08/2018 - ticket 31547
            List<SObjectPhaseConfig__c> sobjPhaseConfig = new List<SObjectPhaseConfig__c>();
            if(Schema.sObjectType.PhaseConfig__c.isAccessible()){
                sobjPhaseConfig = [SELECT GlobalSearchFlexTableConfig__c ,RecordType__c ,SObjectConfig__r.Name
                                                           FROM SObjectPhaseConfig__c 
                                                           WHERE PhaseConfig__c =: phaseConfig[0].Id 
                                                           AND SObjectConfig__r.Name =: objectName
                                                           WITH USER_MODE
                                                           LIMIT 1];            
            }
            recordType = sobjPhaseConfig[0].RecordType__c==null ? '' : sobjPhaseConfig[0].RecordType__c;
           
            if(sobjPhaseConfig!=null && sobjPhaseConfig.size()>0){
                List<DataTableConfig__c> dataTableConfig  = new List<DataTableConfig__c>();
                if(Schema.sObjectType.DataTableConfig__c.isAccessible()){
                    dataTableConfig = [SELECT Name from DataTableConfig__c WHERE Id = :sobjPhaseConfig[0].GlobalSearchFlexTableConfig__c WITH USER_MODE] ;
                }
                if(dataTableConfig  !=null && dataTableConfig.size()>0){
                    dataTableConfigName = dataTableConfig[0].Name;
                    FlexTableCtrl flexTableController = new FlexTableCtrl();                                       
                    result = flexTableController.createInitData(dataTableConfigName,searchTerm,true,keyValueMap,listKeyValueMap,sforce1,null);
                    Map<String,Object> dataTableInfoMap = (Map<String,Object>)result.get('DataTableInfoMap');
                    if(String.isEmpty(orderBy)) {
                        orderBy = (String)dataTableInfoMap.get('OrderBy');
                    }
                    if(String.isEmpty(sortDirection)) {
                        sortDirection = (String)dataTableInfoMap.get('SortDirection');
                    }
                    
                    
                    result.put('DataTableInfo',flexTableController.getRecords((String)dataTableInfoMap.get('ColumnString'),null,(String)dataTableInfoMap.get('HideDecisionFields'),(String)dataTableInfoMap.get('SObjectName'),(Integer)dataTableInfoMap.get('PageNumber'),
                                                            (Integer)dataTableInfoMap.get('PageSize'),orderBy,sortDirection,(String)dataTableInfoMap.get('SearchTerm'),
                                                            (String)dataTableInfoMap.get('FilterClause'),(Boolean)dataTableInfoMap.get('IsSOSL')));        
                    result.put('query',globalQueryString);
                }
            } 
        }
        // Added by to fix the sidebar search result issue
        Map<String,Object> dataTableInfoMap1 = (Map<String,Object>)result.get('DataTableInfo');
        Map<String,Object> actionInfoMap1 = (Map<String,Object>)result.get('ActionInfo');
        List<sObject> recordList = (List<sObject>)dataTableInfoMap1.get('RecordsList');
        Map<String ,Object> keyValueMapMode = new  Map<String ,Object>();
        if(String.isNotEmpty(keyValueMap)){
            keyValueMapMode =(Map<String ,Object>)JSON.deserializeUntyped(keyValueMap);    
        }
        if(actionInfoMap1 != null){
            result.put('HideExpMap',evaluateHideExpression(recordList,actionInfoMap1,(String)keyValueMapMode.get('mode')));   
        }
        result.put('tableCurrencySymbol',AppUtils.getLocaleCurrencySymbol());
        return result;
    }

    /*
    This method is used to evaluate Decision for Row level Actions  
    of Flextable depending on Hide Expression JSON.
    */
    private static Map<String,Map<String,String>> evaluateHideExpression(List<sObject> recordsList,Map<String,Object> actionInfoMap,String mode){
        Map<String,Map<String,String>> HideExpressionMap = new Map<String,Map<String,String>>();
        for(sObject record:recordsList){
            for(String action:actionInfoMap.keySet()){
                Object actionDet = actionInfoMap.get(action);
                Map<String,Object> actionDetail = (Map<String,Object>) actionDet;
                if(String.valueOf(actionDetail.get('Location')) == 'Row'){
                    if(HideExpressionMap.get(record.id) == null){
                    HideExpressionMap.put(record.id,new Map<String,String>());
                    }
                    HideExpressionMap.get(record.id).put((String)actionDetail.get('ActionName'),'null');
                    if(String.isNotEmpty((String)actionDetail.get('HideExpJSON'))){
                        ExpressionJsonEvaluator.recordMap = new Map<String,sObject>();
                        Boolean jsonResult = ExpressionJsonEvaluator.evaluateExpression((String)actionDetail.get('HideExpJSON'), record, mode); 
                        HideExpressionMap.get(record.id).put((String)actionDetail.get('ActionName'),String.valueOf(jsonResult));
                    }
                }
                
            }   
        }
        return HideExpressionMap;
    }
    /*
    Method  :   fetchInitialData()
    Purpose :   This method is called at initial load of flex table.
    */
    @RemoteAction 
    global static Map<String,Object> fetchInitialData(String dataTableConfigName,String keyValueMap,String listKeyValueMap,Boolean sforce1) {
        return fetchInitialDataWithFilter(dataTableConfigName,keyValueMap, listKeyValueMap, sforce1, null, null);
    }
    
    /*
    Method  :   fetchStickySearchSuggestionsData()
    Purpose :   This method is called when user types input values in sticky search text box 
    */
    @RemoteAction
    global static Map<String,Object> fetchStickySearchSuggestionsData(String paramMap){
            Map<String,Object> result = new Map<String,Object>();    
            return result;
    } 
    
        
    
    @RemoteAction
    global static Map<String,Object> fetchInitialDataWithFilter(String dataTableConfigName,String keyValueMap,String listKeyValueMap, Boolean sforce1, String filterClause, Map<String, Object> paramMap) {
        Map<String, Object> result = new Map<String, Object>();
        Map<string,string> stickySearchConfig = new Map<string,string>();
        //try{
            FlexTableCtrl flexTableController = new FlexTableCtrl();
            string searchTerm = '';
            if(paramMap.get('SearchTerm') != null){
                searchTerm = (String)paramMap.get('SearchTerm');
            }
            if(paramMap.get('filterString') != null){
                searchTerm = '';
                filterClause = (String)paramMap.get('filterString');
            }
            boolean isSOSLCheck = false;
            if(paramMap.get('isSOSLCheck') != null){
                isSOSLCheck  = (boolean)paramMap.get('isSOSLCheck');
            }
            if(isSOSLCheck && String.isNotEmpty(searchTerm)){
                result = flexTableController.createInitData(dataTableConfigName,searchTerm,true,keyValueMap,listKeyValueMap,sforce1,null);
            }else{
                result = flexTableController.createInitData(dataTableConfigName,searchTerm,false,keyValueMap,listKeyValueMap,sforce1,null);
            }    
            
            flexTableController.filterClauseN2GSearch = (String)paramMap.get('FilterClause');
            flexTableController.isN2GSearch = (String)paramMap.get('isN2GGridSearch');         
            Map<String,Object> dataTableInfoMap = (Map<String,Object>)result.get('DataTableInfoMap');
            stickySearchConfig.put('stickyLastSearchTerm',String.valueOf(dataTableInfoMap.get('StickySearchLastSearchTerm')));
            stickySearchConfig.put('stickySearchFieldApiName',String.valueOf(dataTableInfoMap.get('StickySearchFieldApiName')));
            TimeZone tz = UserInfo.getTimeZone();
            result.put('UserLocale', tz.getOffset(DateTime.newInstance(2012,10,23,12,0,0)) );
            result.put('IntialFilterClause', (String)dataTableInfoMap.get('FilterClause') );
            result.put('tableDateFormat',AppUtils.getUserDateFormat());
            result.put('tableDateTimeFormat',AppUtils.getUserDateTimeFormat());
            result.put('tableTimeFormat',AppUtils.getUserTimeZoneFormat());
            result.put('tableCurrencySymbol',AppUtils.getLocaleCurrencySymbol());
            String str =(String)dataTableInfoMap.get('HideDecisionFields');
            result.put('DataTableInfo',flexTableController.getRecords( (String)dataTableInfoMap.get('ColumnString'),null,(String)dataTableInfoMap.get('HideDecisionFields'),(String)dataTableInfoMap.get('SObjectName'),
                                                                    paramMap.get('PageNumber') != null ? Integer.valueOf( paramMap.get('PageNumber') ) : (Integer)dataTableInfoMap.get('PageNumber'),
                                                                    paramMap.get('PageSize') != null ? Integer.valueOf( paramMap.get('PageSize') ) : (Integer)dataTableInfoMap.get('PageSize'),
                                                                    paramMap.get('OrderBy') != null ? (String)paramMap.get('OrderBy') : (String)dataTableInfoMap.get('OrderBy'),
                                                                    paramMap.get('SortDirection') != null ? (String)paramMap.get('SortDirection') : (String)dataTableInfoMap.get('SortDirection'),
                                                                    (String)dataTableInfoMap.get('SearchTerm'),
                                                                    (( filterClause == null || filterClause == '' ) ? (String)dataTableInfoMap.get('FilterClause') : paramMap.get('isN2GGridSearch') == 'true' ? (String)dataTableInfoMap.get('FilterClause') : ( ( ((String)dataTableInfoMap.get('FilterClause')) != null && ((String)dataTableInfoMap.get('FilterClause')) != '' ) ? filterClause + ' and ' + ((String)dataTableInfoMap.get('FilterClause')) : filterClause) ),
                                                                    (Boolean)dataTableInfoMap.get('IsSOSL'), stickySearchConfig) );
            result.put('query',globalQueryString);
        Map<String,Object> dataTableInfoMap1 = (Map<String,Object>)result.get('DataTableInfo');
        Map<String,Object> actionInfoMap1 = (Map<String,Object>)result.get('ActionInfo');
        List<sObject> recordList = (List<sObject>)dataTableInfoMap1.get('RecordsList');
        Map<String ,Object> keyValueMapMode = new  Map<String ,Object>();
        if(String.isNotEmpty(keyValueMap)){
            keyValueMapMode =(Map<String ,Object>)JSON.deserializeUntyped(keyValueMap);    
        }
        if(actionInfoMap1 != null){
            result.put('HideExpMap',evaluateHideExpression(recordList,actionInfoMap1,(String)keyValueMapMode.get('mode')));   
        }
        
        return result;    
    }

    private static List<Object> createFilterListViewMapEnhanced(List<FlexTableFilterListViewConfig__c> flexTableFilterListViewConfigList,String flexListViewUserLastClause,String flexListViewDefaultClause){
        List<Object> resultList = new List<Object>();
       
        for(FlexTableFilterListViewConfig__c record : flexTableFilterListViewConfigList){
            if(record.IsActive__c){
                if(String.isNotEmpty(record.FilterClause__c)){
                    Map<String,Object> result = new Map<String,Object>();
                    result.put('label',record.Label__c);
                    result.put('clause',record.FilterClause__c);
                    result.put('isActive',record.IsActive__c);
                    result.put('isDefault',record.IsDefault__c);
                    result.put('isIsMasterView',record.IsMasterView__c);
                    if(record.FilterClause__c.equalsIgnoreCase(flexListViewUserLastClause)){
                        result.put('isSelected',true);
                    }else if(record.FilterClause__c.equalsIgnoreCase(flexListViewDefaultClause)){
                        result.put('isSelected',true);
                    }else if(String.isEmpty(flexListViewUserLastClause) && String.isEmpty(flexListViewDefaultClause) && record.IsMasterView__c){
                        result.put('isSelected',true);
                    }else{
                        result.put('isSelected',false);
                    }                
                    resultList.add(result);
                }           
            }                
        }
        return resultList;
    }
    
    @RemoteAction
    global static Map<String,Object> fetchListInformation(String dataTableConfigName) {
        Map<String, Object> result = new Map<String, Object>();

            String flexListViewDefaultClause = '';
            String flexListViewUserLastClause = '';   
            String flexListViewMasterClause = '';         
            Boolean showFilterViewList = false;
            List<object> labelToFilterClause;
            Boolean searchallFields = false;
            Id loggedInUserId = userInfo.getUserId();
            List<FlexTableFilterListViewConfig__c> flexTableFilterListViewConfigList = new List<FlexTableFilterListViewConfig__c>();
            if(Schema.sObjectType.FlexTableFilterListViewConfig__c.isAccessible()){
            flexTableFilterListViewConfigList = [SELECT Id,Name,Label__c,Sequence__c,FilterClause__c,IsActive__c,IsDefault__c,IsMasterView__c 
                                                FROM FlexTableFilterListViewConfig__c
                                                WHERE FlexTableConfig__r.Name = :dataTableConfigName
                                                WITH USER_MODE
                                                ORDER BY Sequence__c];
            }
            List<FlexTableListViewUserConfig__c> flexTableListViewUserConfigList = new List<FlexTableListViewUserConfig__c>();
            if(Schema.sObjectType.FlexTableListViewUserConfig__c.isAccessible()){
            flexTableListViewUserConfigList = [SELECT Id,Name,User__c,FlexTableListViewConfig__r.Label__c,FlexTableListViewConfig__r.FilterClause__c                                                                                            
                                                FROM FlexTableListViewUserConfig__c
                                                WHERE User__c = :loggedInUserId AND FlexTableConfig__r.Name = :dataTableConfigName
                                                WITH USER_MODE
                                                ORDER BY LastModifiedDate
                                                LIMIT 1];
            }
        if(flexTableListViewUserConfigList.size() > 0){
            flexListViewUserLastClause = flexTableListViewUserConfigList[0].FlexTableListViewConfig__r.FilterClause__c;
        }else{
            for(FlexTableFilterListViewConfig__c record : flexTableFilterListViewConfigList){
                if(record.IsActive__c){
                    if(record.IsDefault__c){
                        flexListViewDefaultClause = record.FilterClause__c;
                    }
                    if(record.IsMasterView__c){
                        flexListViewMasterClause = record.FilterClause__c;
                    }
                }                    
            }
        }
        if(flexTableFilterListViewConfigList.size() > 0){                
            labelToFilterClause = createFilterListViewMapEnhanced(flexTableFilterListViewConfigList,flexListViewUserLastClause,flexListViewDefaultClause);  
            if(labelToFilterClause.size()>0){
                result.put('isListViewAvailable',true); 
                result.put('ListViewResult',labelToFilterClause); 
            }else{
                result.put('isListViewAvailable',false);  
            }
            showFilterViewList = true;          
        }else{
            result.put('isListViewAvailable',false);
            showFilterViewList = false;
        }
        
        if(KeyValueStoreHelper.getBooleanValue('FlextableEnableSearchAllFields',true) != null){
            searchallFields = KeyValueStoreHelper.getBooleanValue('FlextableEnableSearchAllFields',true);
    
        }else{
            searchallFields = false;   
        }
        result.put('searchallFields',searchallFields); 

       // result.put('ListViewResult',labelToFilterClause);                                             
        return result;
    }
    
    @RemoteAction
    global static Map<String,Object> fetchInitialDataWithFilterEnhanced(String dataTableConfigName,String searchTerm,String keyValueMap,String listKeyValueMap, Boolean sforce1, String filterClause, Map<String, Object> paramMap) {
        Map<String, Object> result = new Map<String, Object>();
        return result;    
    }

    @RemoteAction
    global static Map<String,Object> fetchInitialDataWithFilterEnhanced(String dataTableConfigName,String searchTerm,Boolean isSOSL,String keyValueMap,String listKeyValueMap, Boolean sforce1, String filterClause, Map<String, Object> paramMap) {
        Map<String, Object> result = new Map<String, Object>();
        return result;    
    }
    
    @RemoteAction
    global static Map<String,Object> updateRows(String updatedRows,String parentTableMetadata){
       return  updateRowsIds(updatedRows, parentTableMetadata, null);
    }

    
    /*
        Obselete Method
    */
    global static Map<String,Object> updateRows(String updatedRows, String parentTableMetadata, String inlineEditIds){
       return  null;
    }

    /*
    Method  :   updateRows()
    Purpose :   This method is called to updated the edited rows.
    */
    @RemoteAction
    global static Map<String,Object> updateRowsIds(String updatedRows,String parentTableMetadata, String inlineEditIds) {
         
        Map<String,Object> dataInfoTableMap = (Map<String,Object>) JSON.deserializeUntyped(parentTableMetadata);
        Map<String,Object> dataInfoTableMapInfoMap = (Map<String,Object>)dataInfoTableMap.get('DataTableInfoMap');

        Set<Id> recrdIdList = new Set<Id>();
        String objName = '';
        if(dataInfoTableMapInfoMap.get('SObjectName') != null)
          objName = (String)dataInfoTableMapInfoMap.get('SObjectName');
        Map<Id,Datetime> getLastModifiedDtforIds = new Map<Id,Datetime>();
        Map<Id,DateTime> lstModfyDateTimeonsave = new Map<Id,Datetime>();
        if(String.isNotBlank(inlineEditIds)){
        Map<String,Object> newInlineEditMap = (Map<String,Object>) JSON.deserializeUntyped(inlineEditIds);
        for(String idVal : newInlineEditMap.keySet()){
            String  objVal = String.valueOf(newInlineEditMap.get(idVal));
            Long lngVal = Long.valueOf(objVal);
            Datetime dtVal = DateTime.newInstance(lngVal);
            getLastModifiedDtforIds.put(idVal,dtVal); 
        }
        }
        Map<String, Object> result = new Map<String, Object>(); 
        List<Sobject> sobjListToInsert = new  List<Sobject>();    
        List<Sobject> sobjListToUpdate = new  List<Sobject>();  
        Map<String, Object> updatedRowsMap = (Map<String, Object>)JSON.deserializeUntyped(updatedRows); 
        for(String objectAPIName : updatedRowsMap.keySet()){
            List<Object> updatedRowList = (List<Object>)updatedRowsMap.get(objectAPIName);
             //objName = objectAPIName;
             //for formation of recordIdList before save
            for(Integer i = 0; i < updatedRowList.size() ; i++){
                String str = JSON.serialize(updatedRowList[i]);  
                Sobject sobj = (Sobject)JSON.deserializeStrict(SFDCEncoder.sanitizeJSON(str),Type.forName(objectAPIName));  // false+ for Deserializing objects from an untrusted source is security-sensitive as sanitizing it by using SFDCEncoder.sanitizeJSON
                ID rcrdId = (Id)sobj.get('Id');
                
                if(rcrdId !=null){
                    recrdIdList.add(rcrdId); 
                }
            }
           

            // Forming of dynamic query for LastModified Date...
            if(objectAPIName !=null && recrdIdList.size() > 0){
                List<SObject> listData = new List<SObject>();
                if(AppUtils.isObjectAccessible(objectAPIName)){
                    String strQuery = ' SELECT Id, LastModifiedDate FROM ' + String.escapeSingleQuotes(objectAPIName) + ' WHERE ID IN :recrdIdList'; 
                    listData = Database.query(String.escapeSingleQuotes(strQuery),AccessLevel.USER_MODE); //SOQL Injection - False +ve - Dynamic part of query is escapeSingleQuotes/static bind
                    
                    if(listData.size() > 0){
                        for(SObject sobj:listData){
                            DateTime dtLval = (DateTime)sobj.get('LastModifiedDate');
                            lstModfyDateTimeonsave.put(Id.valueOf(String.valueOf(sobj.get('Id'))), dtLval);
                        }
                    }
                }                
            }
            
            for(Integer i = 0; i < updatedRowList.size() ; i++){                             
                String str = JSON.serialize(updatedRowList[i]);  
                Sobject sobj = (Sobject)JSON.deserializeStrict(SFDCEncoder.sanitizeJSON(str),Type.forName(objectAPIName)); // false+ for Deserializing objects from an untrusted source is security-sensitive as sanitizing it by using SFDCEncoder.sanitizeJSON 
                if(sobj.get('Id') !=null){
                    Id rcrdId = (Id)sobj.get('Id');
                     /* Locking of Record on bases of LastModified Date....*/
                    Boolean disableRecordLocking = KeyValueStoreHelper.getBooleanValue('DisableRecordLocking', true) == null? true : KeyValueStoreHelper.getBooleanValue('DisableRecordLocking', true);
                    if(!disableRecordLocking){
                        DateTime lastmodifieddateonload = (DateTime)getLastModifiedDtforIds.get(rcrdId);
                        DateTime lstModfyDateonsave = (DateTime)lstModfyDateTimeonsave.get(rcrdId);
                        if(lastmodifieddateonload != lstModfyDateonsave){
                            result.put('Success',false);
                            //ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'You can not modify this record'));
                            result.put('ErrorMessage','You can not modify this record');
                            return result;
                        }else{
                            getLastModifiedDtforIds.put(rcrdId,lastmodifieddateonload);
                        }  
                    }                
                }
                

                if(sobj.get('Id') != null){               
                    sobjListToUpdate.add(sobj);
                }else{
                    sobjListToInsert.add(sobj);
                }     
            }       
        }
        try{
            if(AppUtils.isObjectUpdateable(objName)){
                update as user sobjListToUpdate;//CRUD - False +ve - As this is Sobject with the help of other method we have checked CRUD
            }
            if(AppUtils.isObjectCreateable(objName)){
                insert as user sobjListToInsert;//CRUD - False +ve - As this is Sobject with the help of other method we have checked CRUD
            }
            
            Map<String, Object> parentTableMetadataMap = (Map<String, Object>)JSON.deserializeUntyped(parentTableMetadata); 
            String childRelationshipQueries = (String)parentTableMetadataMap.get('ChildRelationshipQueries');
            Map<String,Object> parentDataTableInfoMap = (Map<String,Object>)parentTableMetadataMap.get('DataTableInfoMap');
            FlexTableCtrl flexTableController = new FlexTableCtrl(); 
            result.put('DataTableInfo',flexTableController.getRecords((String)parentDataTableInfoMap.get('ColumnString'),childRelationshipQueries,(String)parentDataTableInfoMap.get('HideDecisionFields'),
                            (String)parentDataTableInfoMap.get('SObjectName'),(Integer)parentDataTableInfoMap.get('PageNumber'),(Integer)parentDataTableInfoMap.get('PageSize'),
                            (String)parentDataTableInfoMap.get('OrderBy'),(String)parentDataTableInfoMap.get('SortDirection'),(String)parentDataTableInfoMap.get('SearchTerm'),
                            (String)parentDataTableInfoMap.get('FilterClause'),(Boolean)parentDataTableInfoMap.get('IsSOSL'))); 
            result.put('SobjList',updatedRows);
            result.put('Success',true);
            
        } catch(Exception e) {
            result.put('Success',false);
            String message = '';
            if(Apexpages.getMessages() != null && Apexpages.getMessages().size() > 0) {
                for(Apexpages.Message msg : Apexpages.getMessages()) {
                    if(msg.getSeverity() == ApexPages.Severity.ERROR || msg.getSeverity() == ApexPages.Severity.FATAL){
                        message += msg.getSummary() + '<br/>';
                        message = message.replace('[','');
                        message = message.replace(']','');
                    }
                }
            } else {
                message = Apputils.handleSystemExceptionMsg(e);
            }
            result.put('ErrorMessage',message);
        }
        return result;
    }
   
   // temp method
    global static Map<String,Object> fetchLookupData(String fieldName,String sobjName,String searchTerm) {
        return null;
    }
    global static Map<String,Object> fetchLookupData(String fieldName,String sobjName,String searchTerm, String filterClause) {
        return null;
    }
    global static Map<String,Object> fetchAutoSuggestData(String fieldName,String sobjName,String searchTerm,String filterClause) {
        return null;
    }
    global static Map<String,Object> fetchAutoSuggestData(String fieldName, String sobjName, String searchTerm, String filterClause, String keyValueMapString) {
        return null;

    }
    @RemoteAction
    global static Map<String,Object> fetchAutoSuggestData(String fieldName, String flexDetailId, String sobjName, String searchTerm, String filterClause, String keyValueMapString) {
        List<DataTableDetailConfig__c> dataTableDetailConfigObjList = new List<DataTableDetailConfig__c>();
        if(Schema.sObjectType.DataTableDetailConfig__c.isAccessible()){
            dataTableDetailConfigObjList = [SELECT DisplayFields__c FROM DataTableDetailConfig__c WHERE id=:flexDetailId WITH USER_MODE];
        }
        String displayField;
        for(DataTableDetailConfig__c dataTable: dataTableDetailConfigObjList){
            displayField = dataTable.DisplayFields__c;
        }
        if(String.isNotEmpty(displayField)){
            fieldName = displayField;    
        }
        
        if(String.isNotEmpty(keyValueMapString) && String.isNotEmpty(filterClause )) {
            Map<String,Object>margeFieldKeyValueMap =  (Map<string,object>)JSON.deserializeUntyped(keyValueMapString);     
            filterClause = new FlexTableCtrl().getFilterClauseString(filterClause, margeFieldKeyValueMap);
        }
        
        Map<String, Object> result = new Map<String, Object>();
        String nameSpace = AppUtils.getNamespacePrefix();
        String queryString;
        if(searchTerm != null && searchTerm != ''){
            searchTerm = '%' + String.escapeSingleQuotes(searchTerm) + '%';
            filterClause = filterClause == null | filterClause == '' ? '' : ' AND ' + AppUtils.parseWhereClause(filterClause);
            queryString = 'SELECT ID, ' + String.escapeSingleQuotes(fieldName) + ' FROM ' + String.escapeSingleQuotes(sobjName) + ' WHERE ' + String.escapeSingleQuotes(fieldName) + ' LIKE :searchTerm ' + filterClause +  ' ORDER BY ' + String.escapeSingleQuotes(fieldName) + ' ASC LIMIT 1000';
        }else{
            filterClause = filterClause == null || filterClause == '' ? '': ' WHERE ' + AppUtils.parseWhereClause(filterClause);
            queryString = 'SELECT ID, ' + String.escapeSingleQuotes(fieldName) + ' FROM ' + String.escapeSingleQuotes(sobjName) + filterClause +  ' ORDER BY ' + String.escapeSingleQuotes(fieldName) + ' ASC LIMIT 1000';
        }
        List<LookupData> sobjList = new List<LookupData>();
        Set<String> uniqueValuesSet = new Set<String>();
        if(AppUtils.isObjectAccessible(sobjName)) {
            for( Sobject sObj : Database.query(queryString,AccessLevel.USER_MODE)){//SOQL Injection - False +ve - Using AppUtils.parseWhereClause method to applying escapeSingleQuotes to each value of filterClause clause
                List<String> fieldNameSplit = fieldName.split('\\.',-1);
                Integer i = 0;
                String idVal = (String)sObj.get('Id');
                do{
                    if(i == fieldNameSplit.size() - 1){
                        String value = (String)sObj.get(fieldNameSplit[i]);
                        if(uniqueValuesSet.contains(value) == false){
                            sobjList.add(new LookupData(idVal,value));
                            uniqueValuesSet.add(value);
                        }
                    }else{
                        String objectName = fieldNameSplit[i].replace(nameSpace,'');
                        sObj = sObj.getSObject(objectName); 
                        idVal = (String)sObj.get('Id');
                    }
                    i++;
                }while(i < fieldNameSplit.size());
            }
        }
        result.put('SobjList',sobjList);
        return result;
    }
    private Map<String,Object> getTableInfo(String tableName,String keyValueMap,String listKeyValueMap,Boolean sforce1,String flexGridId,String gridRecordType){    
        Map<String, Object> result = new Map<String, Object>();
        result = createInitData(tableName,null,false,keyValueMap,listKeyValueMap,sforce1,gridRecordType);           
        Map<String,Object> dataTableInfoMap = (Map<String,Object>)result.get('DataTableInfoMap');          
        result.put('DataTableInfo',getRecords(
                                (String)dataTableInfoMap.get('ColumnString'), 
                                null, 
                                (String)dataTableInfoMap.get('HideDecisionFields'),
                                (String)dataTableInfoMap.get('SObjectName'), 
                                (Integer)dataTableInfoMap.get('PageNumber'), 
                                (Integer)dataTableInfoMap.get('PageSize'),//PageSizeForFlexGrid
                                (String)dataTableInfoMap.get('OrderBy'), 
                                (String)dataTableInfoMap.get('SortDirection'), 
                                (String)dataTableInfoMap.get('SearchTerm'),
                                (String)dataTableInfoMap.get('FilterClause'), 
                                (Boolean)dataTableInfoMap.get('IsSOSL')));
        result.put('GridId',flexGridId);                                
       
        return result;
    }     
    
     /*
    Method  :   fetchEditableGridData()
    Purpose :   This method is called at initial load of inline editable grid.
    */
    @RemoteAction
    global static Map<String,Object> fetchN2GData(String editableGridName,String keyValueMap,String listKeyValueMap,Boolean sforce1) {
        Map<String, Object> result = new Map<String, Object>();
        List<FlexGridConfig__c> flexGridConfigList = new List<FlexGridConfig__c>();
        if(Schema.sObjectType.FlexGridConfig__c.isAccessible()){
        flexGridConfigList = [SELECT Id,Name,ParentFlexTable__c,ParentFlexTable__r.Name,ParentFlexTable__r.HeaderDescription__c,
                                Child1FlexTable__c,Child1FlexTable__r.Name,Child1RelationshipName__c,
                                GrandChild1FlexTable__c,GrandChild1FlexTable__r.Name,
                                RecordTypeId,RecordType.Name,HeaderInstruction__c,EnablePagination__c                                                                    
                                FROM FlexGridConfig__c
                                WHERE Name=:editableGridName
                                WITH USER_MODE];
        }
        if(flexGridConfigList.size() > 0){
            FlexGridConfig__c flexGridConfig = flexGridConfigList[0];
            FlexTableCtrl flexTableController = new FlexTableCtrl();
            Map<String, Object> parentResult = flexTableController.getTableInfo(flexGridConfig.ParentFlexTable__r.Name,keyValueMap,listKeyValueMap,sforce1,flexGridConfig.Id,flexGridConfigList[0].RecordType.Name);                        
            result.put('ParentTableMetadata',parentResult);
            Map<String, Object> childResult = flexTableController.createInitData(flexGridConfig.Child1FlexTable__r.Name,null,false,keyValueMap,listKeyValueMap,sforce1,flexGridConfigList[0].RecordType.Name);            
            result.put('ChildTableMetadata',childResult);
            Map<String, Object> grandChildResult = flexTableController.createInitData(flexGridConfig.GrandChild1FlexTable__r.Name,null,false,keyValueMap,listKeyValueMap,sforce1,flexGridConfigList[0].RecordType.Name);            
            result.put('GrandChildTableMetadata',grandChildResult);
            result.put('RecordType',flexGridConfigList[0].RecordType.Name);
            result.put('helpText',flexGridConfigList[0].ParentFlexTable__r.HeaderDescription__c);
            result.put('headerInstructionForGrid',flexGridConfigList[0].HeaderInstruction__c);
            result.put('N2GGridCurrSymbol',AppUtils.getLocaleCurrencySymbol());
            result.put('gridLocaleDateFormat',AppUtils.getUserDateFormat());
            result.put('gridLocaleDateTimeFormat',AppUtils.getUserDateTimeFormat());
            result.put('gridLocaleTimeFormat',AppUtils.getUserTimeZoneFormat());
            TimeZone tz = UserInfo.getTimeZone();           
            Integer n2gTimeOffset = tz.getOffset(System.now());
            result.put('timeOffset',n2gTimeOffset);
            //For +ve and -ve sign
            Map<String,Integer> recordCountofGrid = new Map<String,Integer>();
            if(flexGridConfig.Child1FlexTable__c != null) {
                recordCountofGrid.putAll(flexTableController.childRecordsCount(parentResult,childResult));
            }
            //put grid id in parent metadata for cog icon
            Map<String, Object> parentMetadata = (Map<String, Object>) parentResult.get('ParentTableMetadata');
            if(parentMetadata != null) {
                parentMetadata.put('GridId', flexGridConfig.Id);
            }
            result.put('recordCountofGrid',recordCountofGrid);
            
        }else{
            result.put('ErrorMessages','No grid config record defined ');  
        }
        return result;
   }
   
   public Map<String,Object> fetchN2GDataExport(String editableGridName,String keyValueMap,String listKeyValueMap,Boolean sforce1) {
        Map<String, Object> result1 = new Map<String, Object>();
        FlexTableCtrl flexTableController = new FlexTableCtrl();
        String editableGridName1 = editableGridName;
        String keyValueMap1 = keyValueMap;
        String listKeyValueMap1 = listKeyValueMap;
        Boolean sforce11 = sforce1;        
        result1 = fetchN2GData (editableGridName1,keyValueMap1,listKeyValueMap1,sforce11);         
        return result1;
    }
       
    public Map<String,Integer> childRecordsCount(Map<String, Object> parentResult,Map<String, Object> childResult){
        Map<String,Object> parentdataTableInfoMap = (Map<String,Object>)parentResult.get('DataTableInfo');
        String parentObjectName = (String)parentdataTableInfoMap.get('ObjectName');
        
        
        Map<String,Object> childdataTableInfoMap = (Map<String,Object>)childResult.get('DataTableInfoMap');
        String childObjectName = (String)childdataTableInfoMap.get('SObjectName');
        String filterClause = (String)childdataTableInfoMap.get('FilterClause');
        
        Map<String,Object> configInfoMap = (Map<String,Object>)childResult.get('ConfigInfo');
        String parentTargetLookupField = (String)childdataTableInfoMap.get('ParentTargetLookupField');
        
        List<Object> recordListGrid = (List<Object>)parentdataTableInfoMap.get('RecordsList');
        List<String> recordIdList = new List<String>();
        for(object value : recordListGrid) {
            recordIdList.add(String.valueOf(((sObject)value).get('Id')));
        }
        Map<String,Integer> recordCountofGrid = fetchN2GRecordCount(parentObjectName,childObjectName,recordIdList,filterClause,parentTargetLookupField); 
        return  recordCountofGrid;     
    }
    /*
    Method   : fetchN2GRecordCount()    
    Purpose  : To get record related to N2G
    */
    public Map<String,Integer> fetchN2GRecordCount(String parentObjectName, String childObjectName,List<String> recordIdList,String filterClause,String parentLookupField) {
        String relationshipFieldAPIName;
        String refFieldAPIName;
        List<String> recordList1 = new List<String>();
        Map<String,Integer> recordCounts = new Map<String,Integer>();
        if(parentLookupField != null && parentLookupField != 'null'){
            relationshipFieldAPIName = parentLookupField;
            refFieldAPIName = relationshipFieldAPIName.substringAfterLast('.');
            refFieldAPIName = refFieldAPIName == '' ? relationshipFieldAPIName : refFieldAPIName; 
        }else{
            SObjectType sObjType = Schema.getGlobalDescribe().get(childObjectName);
            Map<String, Schema.SObjectField> mfields = sObjType.getDescribe().fields.getMap();  
                     
            for(Schema.SObjectField sObjField : mfields.values()){
                Schema.DescribeFieldResult fldDesc = sObjField.getDescribe();
                if( fldDesc.getType().name() == 'REFERENCE') {              
                   if( (fldDesc.getReferenceTo()[0]).getDescribe().getName() == parentObjectName){                    
                       relationshipFieldAPIName = fldDesc.getName();
                   }
                }             
            }
            refFieldAPIName = relationshipFieldAPIName;
        }
        for(String a : recordIdList) {            
            recordCounts.put(a,0);  
        }
        String query = 'SELECT Count(Id), '+ String.escapeSingleQuotes(relationshipFieldAPIName) + ' FROM ' + String.escapeSingleQuotes(childObjectName) + ' WHERE ' + String.escapeSingleQuotes(relationshipFieldAPIName) + ' IN :recordIdList';
        if(String.isNotBlank(filterClause)){
            filterClause = filterClause.replaceAll('\'parentId\'', ':recordIdList');
            query += ' AND ' + AppUtils.parseWhereClause(filterClause);
        }
        query += ' GROUP BY ' + String.escapeSingleQuotes(relationshipFieldAPIName);
        Map<String,Integer> queryresult = new Map<String, Integer>();
        if(AppUtils.isObjectAccessible(childObjectName)) {
            AggregateResult[] aggresult = Database.Query(query,AccessLevel.USER_MODE);//SOQL Injection - False +ve - Using AppUtils.parseWhereClause method to applying escapeSingleQuotes to each value of filterClause clause
            for(AggregateResult ar : aggresult){
                recordCounts.put((String)ar.get(refFieldAPIName), (Integer)ar.get('expr0'));
            }       
        }
        return recordCounts;
    }
    /* This method is invoked when clicked on refresh of flex grid*/
    @RemoteAction
    global static Map<String,Object> getPageRecordsForFlexGrid(String queryColumns,String childRelationShipQueries,String hideDecisionFields,String objectName,String filterClause,String sortBy,String sortDir,Integer pageNumber,Integer pageSize,Boolean isSOSL){
        Map<String, Object> result = new Map<String, Object>();
        FlexTableCtrl flexTableController = new FlexTableCtrl();     
        result = flexTableController.getRecords(queryColumns,childRelationShipQueries,hideDecisionFields,objectName,pageNumber,pageSize,sortBy,sortDir,'',filterClause,isSOSL);  
        
        
        return result;
    }
    /* This method is invoked when clicked on refresh of flex grid*/
    @RemoteAction
    global static Map<String,Object> getPageRecordsForN2G(String queryColumns,String childRelationShipQueries,String hideDecisionFields,String objectName,String filterClause,String sortBy,
                                                            String sortDir,Integer pageNumber,Integer pageSize,Boolean isSOSL,String parentObjectName,String childObjectName){
        /*  // Dk : Spring Cleanup 7-5-16
        Map<String, Object> result = new Map<String, Object>();        
        return result;*/
        return null;
    }
    /* This method is invoked when clicked on refresh of flex grid*/
    @RemoteAction
    global static Map<String,Object> getPageRecordsForN2GNew(String queryColumns,String childRelationShipQueries,String hideDecisionFields,String objectName,String filterClause,String sortBy,
                                                            String sortDir,Integer pageNumber,Integer pageSize,Boolean isSOSL,String parentObjectName,String childObjectName,String configFilterClause){
        /*// Dk : Spring Cleanup 7-5-16
        Map<String, Object> result = new Map<String, Object>();        
        return result;*/
        return null;
    }
    /* This method is invoked when clicked on refresh of flex grid*/
    @RemoteAction
    global static Map<String,Object> getPageRecordsForN2GNew2(String queryColumns,String childRelationShipQueries,String hideDecisionFields,String objectName,String filterClause,String sortBy,
                                                            String sortDir,Integer pageNumber,Integer pageSize,Boolean isSOSL,String parentObjectName,String childObjectName,String configFilterClause,String parentLookupField){
        Map<String, Object> result = new Map<String, Object>();
        FlexTableCtrl flexTableController = new FlexTableCtrl();     
        result = flexTableController.getRecords(queryColumns,childRelationShipQueries,hideDecisionFields,objectName,pageNumber,pageSize,sortBy,sortDir,'',filterClause,isSOSL);  
        
        //For +ve and -ve sign
        if(parentObjectName != null && childObjectName != null){
            List<String> recordIdList = new List<String>();
            for(object value : (List<Object>)result.get('RecordsList')) {
                recordIdList.add(String.valueOf(((sObject)value).get('Id')));
            }
            
            Map<String,Integer> recordCountofGrid = flexTableController.fetchN2GRecordCount(parentObjectName,childObjectName,recordIdList,configFilterClause,parentLookupField);
            result.put('recordCountofGrid',recordCountofGrid);
            result.put('N2GGridLocaleCurrSymbol',AppUtils.getLocaleCurrencySymbol());
        }
        return result;
    }
    /*
    Method  :   fetchEditableGridData()
    Purpose :   This method is called at initial load of inline editable grid.
    */
    @RemoteAction
    global static Map<String,Object> fetchEditableGridData(String editableGridName,String keyValueMap,String listKeyValueMap,Boolean sforce1) {
        Map<String, Object> result = new Map<String, Object>();
        
        List<FlexGridConfig__c> editableGridConfigList = new List<FlexGridConfig__c>();
        if(Schema.sObjectType.FlexGridConfig__c.isAccessible()){
            editableGridConfigList = [SELECT Id,Name,ParentFlexTable__c,ParentFlexTable__r.Name,HeaderInstruction__c,EnablePagination__c,
                                    Child1FlexTable__c,Child1RelationshipName__c,Child1FlexTable__r.Name,Child1RelationshipLabel__c,
                                    Child2FlexTable__c,Child2RelationshipName__c,Child2FlexTable__r.Name,Child2RelationshipLabel__c,
                                    Child1DefaultSize__c, Child2DefaultSize__c,ParentFlexTable__r.HeaderDescription__c,
                                    ShowHideMassFunctionality__c,ParentRelationshipField__c,RecordTypeId,RecordType.Name
                                    FROM FlexGridConfig__c
                                    WHERE Name=:editableGridName
                                    WITH USER_MODE];
        }
        if(editableGridConfigList.size() > 0){
            FlexGridConfig__c editableGridConfig = editableGridConfigList[0];
            result.put('HeaderInstructionForGrid',editableGridConfig.HeaderInstruction__c != null ? editableGridConfig.HeaderInstruction__c : '');            
            result.put('MassFunctionality',editableGridConfig.ShowHideMassFunctionality__c);
            result.put('EnablePagination', editableGridConfig.EnablePagination__c + '');
            result.put('RecordType', editableGridConfig.RecordType.Name + '');
            result.put('GridId', editableGridConfig.Id);
            result.put('helpText',editableGridConfig.ParentFlexTable__r.HeaderDescription__c);
            result.put('gridCurrencySymbol',AppUtils.getLocaleCurrencySymbol());
            result.put('gridLocaleDateFormat',AppUtils.getUserDateFormat());
            result.put('gridLocaleDateTimeFormat',AppUtils.getUserDateTimeFormat());
            result.put('gridLocaleTimeFormat',AppUtils.getUserTimeZoneFormat());
            
            FlexTableCtrl flexTableController = new FlexTableCtrl();  
            String childRelationshipQueries = '';
            Map<String, Object> parentResult = new Map<String, Object>(); 
            parentResult = flexTableController.createInitData(editableGridConfig.ParentFlexTable__r.Name,null,false,keyValueMap,listKeyValueMap,sforce1,null);           
            Map<String, Object> childRelationshipMap = new Map<String, Object>(); 
            childRelationshipMap = flexTableController.getChildRelationshipMap(parentResult,editableGridConfig);
            
            List<String> childMetadataKeysArray = new List<String>();
            
            if(editableGridConfig.Child1FlexTable__c != null){
                Map<String, Object> child1result = flexTableController.createChildRecordsMetadata(childRelationshipMap,editableGridConfig.Child1RelationshipName__c,editableGridConfig.Child1RelationshipLabel__c,editableGridConfig.Child1FlexTable__r.Name, keyValueMap, listKeyValueMap, sforce1);
                ((Map<String, Object>)child1result.get('ChildTableMetadata')).put('ListSize', editableGridConfig.Child1DefaultSize__c + '');
                
                result.put('Child1TableMetadata',child1result.get('ChildTableMetadata'));
                
                childMetadataKeysArray.add('Child1TableMetadata');
                result.put('ChildMetadataKeysArray',childMetadataKeysArray);
                
                childRelationshipQueries += ' , ( ' + child1result.get('ChildRelationshipQuery') + ' ) ';
            }
            if(editableGridConfig.Child2FlexTable__c != null){
                Map<String, Object> child2result = flexTableController.createChildRecordsMetadata(childRelationshipMap,editableGridConfig.Child2RelationshipName__c,editableGridConfig.Child2RelationshipLabel__c,editableGridConfig.Child2FlexTable__r.Name, keyValueMap, listKeyValueMap, sforce1);
                ((Map<String, Object>)child2result.get('ChildTableMetadata')).put('ListSize', editableGridConfig.Child2DefaultSize__c + '');
                
                result.put('Child2TableMetadata',child2result.get('ChildTableMetadata'));
                
                childMetadataKeysArray.add('Child2TableMetadata');
                result.put('ChildMetadataKeysArray',childMetadataKeysArray);
                
                childRelationshipQueries += ' , ( ' + child2result.get('ChildRelationshipQuery') + ' ) ';
            }
            parentResult.put('ChildRelationshipQueries',childRelationshipQueries);
            parentResult.put('GridId', editableGridConfig.Id);
            if(editableGridConfig.ParentRelationshipField__c != null){
                parentResult.put('ParentRelationshipField',editableGridConfig.ParentRelationshipField__c);    
            }
            result.put('ParentTableMetadata',parentResult);
            Map<String,Object> parentDataTableInfoMap = (Map<String,Object>)parentResult.get('DataTableInfoMap');
            if(editableGridConfig.RecordType.Name == 'Budget Grid'){
                result.put('DataTableInfo',flexTableController.getRecords((String)parentDataTableInfoMap.get('ColumnString'), childRelationshipQueries, (String)parentDataTableInfoMap.get('HideDecisionFields'),
                            (String)parentDataTableInfoMap.get('SObjectName'), (Integer)parentDataTableInfoMap.get('PageNumber'), (Integer)parentDataTableInfoMap.get('PageSize'),
                            (String)parentDataTableInfoMap.get('OrderBy'), (String)parentDataTableInfoMap.get('SortDirection'), (String)parentDataTableInfoMap.get('SearchTerm'),
                            (String)parentDataTableInfoMap.get('FilterClause'), (Boolean)parentDataTableInfoMap.get('IsSOSL')));    
            }else{
                 result.put('DataTableInfo',flexTableController.getRecords((String)parentDataTableInfoMap.get('ColumnString'), childRelationshipQueries, (String)parentDataTableInfoMap.get('HideDecisionFields'),
                            (String)parentDataTableInfoMap.get('SObjectName'), (Integer)parentDataTableInfoMap.get('PageNumber'), (Integer)parentDataTableInfoMap.get('PageSize'),
                            (String)parentDataTableInfoMap.get('OrderBy'), (String)parentDataTableInfoMap.get('SortDirection'), (String)parentDataTableInfoMap.get('SearchTerm'),
                            (String)parentDataTableInfoMap.get('FilterClause'), (Boolean)parentDataTableInfoMap.get('IsSOSL')));
            }    
        }else{
            result.put('ErrorMessages','No grid record defined ');  
        }
        
        return result;    
    }
    private Map<String,Object> getChildRelationshipMap(Map<String, Object> parentResult,FlexGridConfig__c editableGridConfig){    
        Map<String, Object> result = new Map<String, Object>();
        Schema.DescribeSObjectResult dataTableObjectResult =  (Schema.DescribeSObjectResult)parentResult.get('DataTableObjectResult');
        List<Schema.ChildRelationship> childRelationshipList = dataTableObjectResult.getChildRelationships();
        for(Schema.ChildRelationship childRelationship : childRelationshipList){
            String relationshipname = childRelationship.getRelationshipName();  
            if(editableGridConfig.Child1RelationshipName__c != null && relationshipname == editableGridConfig.Child1RelationshipName__c){
                result.put(editableGridConfig.Child1RelationshipName__c,childRelationship.getField().getDescribe().getName());
            }else if(editableGridConfig.Child2RelationshipName__c != null && relationshipname == editableGridConfig.Child2RelationshipName__c){
                result.put(editableGridConfig.Child2RelationshipName__c,childRelationship.getField().getDescribe().getName());
            }  
        }
        return result;
    }
    private Map<String,Object> createChildRecordsMetadata(Map<String, Object> childRelationshipMap,String childRelationshipName,String childRelationshipLabel, String flextableName,String keyValueMap,String listKeyValueMap,Boolean sforce1){
        Map<String, Object> result = new Map<String, Object>();
        Map<String, Object> childResult = new Map<String, Object>();
        childResult = createInitData(flextableName,null,false,keyValueMap,listKeyValueMap,sforce1,null);
        childResult.put('ChildRelationshipName',childRelationshipName);
        childresult.put('ChildRelationshipLabel',childRelationshipLabel);
        childresult.put('ChildRelationshipField',childRelationshipMap.get(childRelationshipName));
        result.put('ChildTableMetadata',childResult);
        
        Map<String,Object> childDataTableInfoMap = (Map<String,Object>)childResult.get('DataTableInfoMap');
        String childRelationshipQuery = createSOQLQuery((String)childDataTableInfoMap.get('ColumnString'), null, 
                                                        (String)childDataTableInfoMap.get('HideDecisionFields'),childRelationshipName, 
                                                        (String)childDataTableInfoMap.get('OrderBy'), (String)childDataTableInfoMap.get('SortDirection'), 
                                                        (String)childDataTableInfoMap.get('SearchTerm'), (String)childDataTableInfoMap.get('FilterClause'));
        result.put('ChildRelationshipQuery',childRelationshipQuery);
        return result;
    } 
    /*
    Method  :   FetchInitialHistoryData()
    Purpose :   This method is called at initial load of History Field flex table. 
    */
    @RemoteAction
    global static Map<String,Object> fetchInitialHistoryData(String dataTableConfigName,String objName,String childObject,Boolean isHistoryField,String recId,String keyValueMap,String listKeyValueMap,Boolean sforce1) {
        Map<String, Object> result = new Map<String, Object>();
        Map<String, Object> defaultValue = new Map<String, Object>();
        Map<String,Object> resultMap = new Map<String,Object>();
        Map<String,String > childRelationshipMap = new Map<String,String >();
        Map<String,String > relatedFieldAPI = new Map<String,String >();
        originalObjectName = objName;
        if(childObject != '' && !String.isEmpty(childObject)){
            objName = childObject;
        }
        String suffix = '__c';
        if(objName != null && objName.endsWithIgnoreCase(suffix)){
            objName = objName.replace(suffix, '__History');
        }else{  
            objName = objName+'History';
        }
        FlexTableCtrl flexTableController = new FlexTableCtrl();     
        flexTableController.historyObjName = objName;
        flexTableController.isHistory = true; 
        flexTableController.recordId = recId;  
        result = flexTableController.createInitData(dataTableConfigName,null,false,keyValueMap,listKeyValueMap,sforce1,null);
        Map<String,Object> dataTableInfoMap = (Map<String,Object>)result.get('DataTableInfoMap');
        resultMap = fetchChildRelationships(originalObjectName);

        List<Id> ids = new List<Id>();
        if(resultMap.size() > 0){
            childRelationShipMap = (Map<String,String>)resultMap.get('ChildObjects');
            relatedFieldAPI = (Map<String,String>)resultMap.get('RelatedFieldName');
            List<ChildRelationShipWrapper > childList = (List<ChildRelationShipWrapper>)resultMap.get('ChildObjectWrapper');
            childList.sort();
            if((childObject !='' || !String.isEmpty(childObject))&& !childObject.equalsIgnoreCase(originalObjectName)){
               defaultValue.put(childObject,childRelationShipMap.get(childObject));
               String relatedFields = relatedFieldAPI.get(childObject);
               relatedFields = relatedFields.replaceAll(',','=:recId  OR ');
               relatedFields += '=:recId';
               String queryChildren ;
               if(!relatedFieldAPI.get(childObject).contains(',')){
                   queryChildren = 'select id from '+ String.escapeSingleQuotes(childObject) + ' where ' +String.escapeSingleQuotes(relatedFieldAPI.get(childObject))+ '=:recId';
               }else{
                   queryChildren = 'select id from '+ String.escapeSingleQuotes(childObject) + ' where ' + AppUtils.parseWhereClause(relatedFields);
               }
                List<Sobject> objects;
                if(AppUtils.isObjectAccessible(objName)){  
                    objects = database.query(String.escapeSingleQuotes(queryChildren),AccessLevel.USER_MODE);//SOQL Injection - False +ve - Dynamic part of query string is escapeSingleQuotes
                }
               for(Sobject obj : objects){
                   ids.add((Id)obj.get('id'));
               }
            }else{
               defaultValue.put(originalObjectName,childRelationShipMap.get(originalObjectName));
            }   

            //Tomy --USER STORY 33072 change for showing child history along with parent history in first call -- end
            result.put('DefaultMap',defaultValue);
            result.put('ChildRelationShipList',childList);
            result.put('ChildRelationShips',childRelationshipMap);
            result.put('NoChildPresent',false);
        }else{
            result.put('NoChildPresent',true);
        }
        //Tomy --USER STORY 33072 change for showing even child history in first call -- end
        result.put('HistorytableDateFormat',AppUtils.getUserDateFormat());
        result.put('HistorytableDateTimeFormat',AppUtils.getUserDateTimeFormat());
        result.put('DataTableInfo', flexTableController.fetchHistoryRecords(DataTableInfoMap,originalObjectName,childObject,relatedFieldAPI,recId,ids));

        return result;
    }
    
    private Map<String,object> fetchHistoryRecords(Map<String,Object> dTableInfoMap,String originalObjectName,String childObject,Map<String,String> relatedFieldName,String recId,List<Id> recordIds){
        Map<String, Object> result = new Map<String, Object>();
        string objectName = childObject;
        String columnNames = (String)dTableInfoMap.get('ColumnString') ;//+ ',Parent.Name';
        //String columnNameList = columnNames + ', Parent'; 
        
        if(String.isEmpty(childObject) || childObject == ''|| childObject.equalsIgnoreCase(originalObjectName)){
            result = getRecords(columnNames ,null,(String)dTableInfoMap.get('HideDecisionFields'),(String)dTableInfoMap.get('SObjectName'),(Integer)dTableInfoMap.get('PageNumber'),
                                                            (Integer)dTableInfoMap.get('PageSize'),(String)dTableInfoMap.get('OrderBy'),(String)dTableInfoMap.get('SortDirection'),(String)dTableInfoMap.get('SearchTerm'),
                                                            (String)dTableInfoMap.get('FilterClause'),(Boolean)dTableInfoMap.get('IsSOSL'));
        }else{
                if(childObject != null && childObject.endsWithIgnoreCase('__c')){
                    childObject = childObject.removeEnd('__c');
                    childObject += '__History';
                }else{  
                   childObject +='History';
                }
                String idList;  
                if(recordIds.size () > 0){
                    idList = '(';
                    for(Id rcrdId : recordIds){
                        idList+='\'' + string.escapeSingleQuotes(rcrdId) + '\',';
                    }
                    
                    idList = idList.removeEnd(',');
                    idList += ')';
                }else{
                    idList = '(\'\')';
                }
                    String filterClause ='';
                    if(!childObject.endsWithIgnoreCase('__History')){
                         filterClause = string.escapeSingleQuotes(objectName)+'Id in ' + idList + 'AND Field NOT IN (\'created\',\'feedEvent\',\'ownerAccepted\',\'ownerAssignment\',\'locked\',\'unlocked\')' ;
                    }else{
                         filterClause = 'ParentId in ' + idList + 'AND Field NOT IN (\'created\',\'feedEvent\',\'ownerAccepted\',\'ownerAssignment\',\'locked\',\'unlocked\')' ;
                    }
                    //String filterClause = 'ParentId in ' + idList + 'AND Field NOT IN (\'created\',\'feedEvent\',\'ownerAccepted\',\'ownerAssignment\',\'locked\',\'unlocked\')' ;
                    String query = createSOQLQuery(columnNames ,null,(String)dTableInfoMap.get('HideDecisionFields'), childObject,(String)dTableInfoMap.get('OrderBy'), (String)dTableInfoMap.get('SortDirection'),(String)dTableInfoMap.get('SearchTerm'),filterClause);
                    result = handleStandardListControllers(query,(String)dTableInfoMap.get('ColumnString'),(String)dTableInfoMap.get('HideDecisionFields'),
                                                        (Integer)dTableInfoMap.get('PageNumber'),(Integer)dTableInfoMap.get('PageSize'),filterClause,(String)dTableInfoMap.get('OrderBy')
                                                        ,(String)dTableInfoMap.get('SortDirection'),childObject);

        }
       return result;
    }
    
    public static Map<String,Object> fetchChildRelationships(String objectName){
        List<SobjectConfig__c> sobjects = new List<SobjectConfig__c>();
        if(Schema.sObjectType.SobjectConfig__c.isAccessible()){
            sobjects = [SELECT HistoryObjects__c FROM SobjectConfig__c WHERE name =: objectName WITH USER_MODE];
        }
        Map<String,String> mapChildObjects = new Map<String,String>();
        Map<String,String> mapOfRelatedFieldName = new Map<String,String>();
        Map<String,Object> resultMap = new Map<String,Object>();
        Map<String, Object> objectNameLableMap ;
        if(sobjects.size () > 0 && !String.isEmpty(sobjects[0].HistoryObjects__c)){
            string[]  childObjectNames = new List<String>();//User Story 161383: NFWF - Grantee Opportunity - Field History dropdown finding wrong child records - Part 2
            if(sobjects[0].HistoryObjects__c.indexOf('StateAsGrantor') != -1 || sobjects[0].HistoryObjects__c.indexOf('StateAsGrantee') != -1){
                UserPreferences__c pref = UserPreferences__c.getInstance();
                if(pref == null || pref.ActiveAppName__c == null) {
                    CustomExceptions.logException(String.format(System.Label.UserPrefrenceLabel, new List<String>{Userinfo.getUserId()}), false);
                }
                String customAppName = pref.ActiveAppName__c;
                Map<String, Object> objectMap = (Map<String, Object>) JSON.deserializeUntyped(sobjects[0].HistoryObjects__c);
                for (String rowKey: objectMap.keySet()) {
                    if(rowKey.equalsIgnoreCase(customAppName)){
                        objectNameLableMap=  (Map<String, Object>) objectMap.get(rowKey);
                        for (String objName: objectNameLableMap.keySet()) {
                            childObjectNames.add(objName);
                        }
                    }
                }
                if(childObjectNames == null){
                    return resultMap;
                }
            }else{
                childObjectNames = sobjects[0].HistoryObjects__c.split(',');
            }
            Map<String,Integer> mapChildObjectsIndex = new Map<String,Integer>();  
            Set<String> setChildObjects = new Set<String>();
            List<String> listChildObjects= new List<String>();
            Integer i =1;
            for(String childObj : childObjectNames ){
                    mapChildObjectsIndex.put(childObj.trim(),i++);
                    setChildObjects.add(childObj.trim());
                    listChildObjects.add(childObj.trim());
            }
            
            Map<String, Schema.SObjectType> gd = Schema.getGlobalDescribe(); 
            Schema.sobjectType sobj = gd.get(objectName);
            Schema.DescribeSObjectResult descObjResult  = sobj.getDescribe();
            List<Schema.ChildRelationship> childRelationship = descObjResult.getChildRelationships(); 
            mapChildObjects.put(objectName,descObjResult.getLabel());
            i = 0;
            List<ChildRelationShipWrapper  > childWrappers = new List<ChildRelationShipWrapper  >();
            ChildRelationShipWrapper  childWrap = new ChildRelationShipWrapper  ();
            childWrap.childObjectApiName = objectName;
            if(objectNameLableMap != null && objectNameLableMap.get(objectName)!= null){
                childWrap.childObjectLabel = (String)objectNameLableMap.get(objectName);
            }else{
            childWrap.childObjectLabel = descObjResult.getLabel();
            }
            childWrap.index = i++;
            childWrappers.add(childWrap);
            for(Schema.ChildRelationship cR : childRelationship){
                Schema.DescribeSObjectResult child = cR.getChildSobject().getDescribe();
                if(setChildObjects.contains(child.getName())){
                    String label;
                    if(objectNameLableMap != null && objectNameLableMap.get(child.getName())!= null){
                        label = (String)objectNameLableMap.get(child.getName());
                    }else{
                        label = child.getLabel();
                    }
                    String objectAPI = child.getName();
                    mapChildObjects.put(objectAPI,label);
                    String relatedFieldNames = mapOfRelatedFieldName.get(objectAPI);
                    if(String.isNotEmpty(relatedFieldNames)){
                            relatedFieldNames += ','+cr.getField().getDescribe().getName();
                    }else{
                            relatedFieldNames = cr.getField().getDescribe().getName();
                            childWrap = new ChildRelationShipWrapper  ();
                            childWrap.childObjectApiName = objectAPI;
                            childWrap.childObjectLabel = label;
                            childWrap.index = mapChildObjectsIndex.get(objectAPI);
                            childWrappers.add(childWrap);
                    }
                    mapOfRelatedFieldName.put(objectAPI,relatedFieldNames);
                    
                }
                
            }
            resultMap.put('ChildObjects',mapChildObjects);
            resultMap.put('ChildObjectWrapper',childWrappers);
            resultMap.put('RelatedFieldName',mapOfRelatedFieldName);
        }
        return resultMap;
    }   
    
    
    /* 
    Method  :   fetchPreviewData()
    Purpose :   This method is called at initial load of flex table for preview purpose. 
    */ 
    @RemoteAction
    global static Map<String,Object> fetchPreviewData(String dataTableConfigName,Boolean sforce1) {
        Map<String, Object> result = new Map<String, Object>();
        FlexTableCtrl flexTableController = new FlexTableCtrl();
        
            
        result = flexTableController.createPreviewData(dataTableConfigName,null,false,sforce1);
        return result;    
    }

    @RemoteAction
    global static List<String> refreshTables(String pageLayoutName) {
            List<String> flexTableNames;
        //pLayoutName = 'ReviewPanelView';
        if(pageLayoutName != null) {
            flexTableNames = new List<String>();
            List<PageBlockConfig__c> pageBlocks = new List<PageBlockConfig__c>();
            if(Schema.sObjectType.PageBlockConfig__c.isAccessible()){
                pageBlocks = [SELECT id,FlexTableName__c,FlexTableName__r.Name,TabLayoutConfig__r.PageLayoutConfig__r.Name,HideDecisionField__c 
                                FROM PageBlockConfig__c
                                WHERE isActive__c = true 
                                AND TabLayoutConfig__r.PageLayoutConfig__r.Name =: pageLayoutName
                                WITH USER_MODE];
            }
            for(PageBlockConfig__c pageBlock : pageBlocks) {
                if(pageBlock.FlexTableName__c != null) {
                    flexTableNames.add(pageBlock.FlexTableName__r.Name);
                }
            }
        }
            return flexTableNames;
    }
     /*
    }
    Method  :   createPreviewData()
    Purpose :   Creates preview data along with the config info for flex table.
    */
    public  Map<String,Object> createPreviewData(String dataTableConfigName,String searchTerm,Boolean isSOSL,Boolean sforce1){
        Map<String, Object> result = new Map<String, Object>();      
        List<DataTableConfig__c> dataTableConfigObjList = new List<DataTableConfig__c>();
        if(Schema.sObjectType.DataTableConfig__c.isAccessible()){
        dataTableConfigObjList = [SELECT Id,Name,ActionDisplayType__c,HelpConfig__c,FieldNames__c,SObject__c,DefaultPageSize__c,
                                            FilterCriteria__c,OrderBy__c,Sort_Direction__c,Header__c,DisableMenu__c,SubHeaderText__c,
                                            EnableRecordSelection__c,EnableExport__c,EnableExportXls__c,EnableHelp__c,ReadOnlyFields__c,
                                            EnableIndexBar__c,EnablePagination__c,EnablePageSize__c,SubTotalEvaluatorJSON__c,MassEditableGridConfigJSON__c,
                                            EnableTotalRecordsCount__c,EnableFilter__c,EnableSearchAllField__c,EnableQuickSearch__c,QuickSearchBehaviour__c,EnableAutoIndex__c,
                                            HeaderDescription__c,HideRecordSelectionDecisionField__c,ParentTargetLookupField__c,
                                            RecordSelectionColumnPosition__c,RecordSelectionColumnHeader__c,RequiredFields__c,EnableDataImportExport__c,IsActive__c
                                            FROM DataTableConfig__c
                                            WHERE Name=:dataTableConfigName
                                            WITH USER_MODE
                                            LIMIT 1];
        }
       Boolean isactive = dataTableConfigObjList[0].IsActive__c;
        if(dataTableConfigObjList.size() > 0 &&  isactive){
            List<DataTableConfig__c> dataTableConfigLst = new List<DataTableConfig__c>();
            DataTableConfig__c dataTableConfigObj = dataTableConfigObjList[0];
            
            if(dataTableConfigObj.SObject__c <> null){
                this.headerDescription = dataTableConfigObj.HeaderDescription__c;
                Schema.SObjectType dataTableObjectType;      
                try {                   
                    dataTableObjectType = SchemaManager.getSObjectTypeFromName(dataTableConfigObj.SObject__c);                               
                } catch(Exception e) {                    
                    result.put('ErrorMessages','Error: '+ Apputils.handleSystemExceptionMsg(e));           
                }   
                
                if(dataTableObjectType <> null){
                    Schema.DescribeSObjectResult dataTableObjectResult = dataTableObjectType.getDescribe();
                   
                    Map<String,Schema.SObjectField> dataObjectFieldsMap = dataTableObjectResult.fields.getMap();
                   
                    if(sObjectType.AccordionContent__c != null){
                        String nameSpacePrefix = AppUtils.getNamespacePrefix();
                        result.put('NamespacePrefix',nameSpacePrefix ); 
                    }
                    Map<String,Object> fieldInfoMap = getFieldMetadata(dataTableConfigObj.Id,dataTableObjectType,dataTableConfigObj.SObject__c,dataTableConfigObj.FieldNames__c,dataObjectFieldsMap);
                    result.put('FlexTableHeader',dataTableConfigObj.Header__c);
                    result.put('FieldMetadata',fieldInfoMap.get('FieldsMap'));
                    result.put('FieldsList',fieldInfoMap.get('FieldsList')); 
                    result.put('FieldsColumnMap',fieldInfoMap.get('FieldsColumnMap'));
                    result.put('ColumnFieldMap',fieldInfoMap.get('ColumnFieldMap'));
                    result.put('ColumnsNameList',fieldInfoMap.get('ColumnsNameList'));
                    result.put('KeyValueMap','');                                   
                    List<DataTableAction__c> dataTableActionsList = new List<DataTableAction__c>();
                    if(Schema.sObjectType.DataTableAction__c.isAccessible()){
                    dataTableActionsList = [SELECT Id,RecordType.Name, Name, DeveloperActionName__c, ActionClass__c,StandardAction__c,ModalHeight__c,ActionURLLong__c,
                                                                         ModalWidth__c,ActionBehavior__c,ActionURL__c,DataTableConfig__c,HideInSearch__c,
                                                                         Location__c,Sequence__c,IconCSS__c, HeaderActionDisplayType__c,ConfirmationMessage__c,
                                                                         HideDecisionField__c,HideForUser__c,HideForProfile__c,ShowConfirmationBox__c,ModalTitle__c,RefreshBehavior__c,
                                                                         SobjectActionConfig__r.HideDecisionField__c,SobjectActionConfig__r.HideForProfile1__c,
                                                                         SobjectActionConfig__r.HideForUser__c,ButtonHelpText__c,HideOperator__c,HideForRole__c,SobjectActionConfig__r.HideOperator__c,
                                                                         SobjectActionConfig__r.HideForRole__c,HideExpressionJSON__C,HideExpressionFields__c,
                                                                         SobjectActionConfig__r.HideExpressionJSON__c,SobjectActionConfig__r.HideExpressionFields__c,SobjectActionConfig__r.HideForContext__c,RecordType.DeveloperName 
                                                                         FROM DataTableAction__c
                                                                         WHERE DataTableConfig__c=:dataTableConfigObjList[0].id 
                                                                         WITH USER_MODE
                                                                         ORDER BY Sequence__c];
                    }
                    Map<String,Object> dataTableActionsMap = new Map<String,Object>();                    
                    // in case of print we dont want buttons.         
                    if(!FlexLayoutPrintGenerator.isPrint && dataTableActionsList.size() > 0) {
                        dataTableActionsMap = getActionInfo(dataTableActionsList,null);
                        result.put('ActionInfo',dataTableActionsMap.get('ActionInfoMap'));
                    }
                        
                    Integer pageSize;
                    if(sforce1 == true){
                        pageSize = KeyValueStoreHelper.getIntegerValue('FlexTableDefaultPageSizeSF1',true);
                    }else{
                        pageSize = Integer.valueOf(dataTableConfigObj.DefaultPageSize__c) == null ? KeyValueStoreHelper.getIntegerValue('FlexTableDefaultPageSize',true) : Integer.valueOf(dataTableConfigObj.DefaultPageSize__c);
                    }
                    if(pageSize == null){
                        pageSize = 5;    
                    }
                    String hideDecisionFields = (String)dataTableActionsMap.get('HideDecisionFields');   
                    if(!String.isEmpty(dataTableConfigObj.HideRecordSelectionDecisionField__c)){
                            hideDecisionFields = ','+dataTableConfigObj.HideRecordSelectionDecisionField__c;
                    }
                    result.put('DataTableInfo','');
                    result.put('ObjectMetaData',getObjectMetadata(dataTableObjectResult,dataTableConfigObj.FieldNames__c));                    
                    dataTableConfigLst.add(dataTableConfigObj);
                    result.put('ConfigInfo',getConfigInfo(dataTableConfigLst));
                }                        
                
            }else{
               
                result.put('ErrorMessages','No sobject defined in flex table config record found. Please contact your administrator.');  
            }
        }else{
            
            result.put('ErrorMessages','No data table config object found. Please contact your administrator.');
        }
        return result;  
    }   

    /*
    Method  :   createInitData()
    Purpose :   Creates initial data along with the config info for flex table.
    */
    public  Map<String,Object> createInitData(String dataTableConfigName, String searchTerm, Boolean isSOSL, String keyValueMap, String listKeyValueMap, Boolean sforce1, String gridRecordType){
        return createInitData(dataTableConfigName, searchTerm, isSOSL, keyValueMap, listKeyValueMap, sforce1, true, gridRecordType);
    }
    private  Map<String,Object> createInitData(String dataTableConfigName, String searchTerm, Boolean isSOSL, String keyValueMap, String listKeyValueMap, Boolean sforce1, Boolean replaceReferenceWithName, String gridRecordType){
        /*
            This method accepts following parameters:
            1. The name of flex table congif object.
            2. Search term, if any. This is basically for flex skinny table that is rendered on search from left side navigation.
            3. Whether we need to fire a SOSL or a SOQL query.
            4. The key value map for merge fields.
            5. A boolean value the indicates if the page is loaded through salesforce1 mobile app.
        */
        Map<String,Object> tableParamMap1 = new Map<String, Object>();
        tableParamMap1 = String.isNotEmpty(keyValueMap) ? (Map<String,Object>) JSON.deserializeUntyped(keyValueMap):null;
        if(tableParamMap1 !=null){
            recordId = tableParamMap1.get('recordId') != null ? (String)tableParamMap1.get('recordId'):'';
        }else{
            recordId = '';
        }
        
        
        Map<String, Object> result = new Map<String, Object>(); 
        Set<String> colunmStringSet = new Set<String>();    
        List<DataTableConfig__c> dataTableConfigObjList = new List<DataTableConfig__c>();
        if(Schema.sObjectType.DataTableConfig__c.isAccessible()){
        dataTableConfigObjList = [SELECT Id,Name,ActionDisplayType__c,HelpConfig__c,FieldNames__c,Additionalcolumns__c,SObject__c,DefaultPageSize__c,
                                                                FilterCriteria__c,OrderBy__c,Sort_Direction__c,Header__c,EnableSearchAllField__c,
                                                                EnableRecordSelection__c,EnableExport__c,EnableExportXls__c,EnableHelp__c,DisableMenu__c,SubHeaderText__c,
                                                                EnableIndexBar__c,EnablePagination__c,EnablePageSize__c,SubTotalEvaluatorJSON__c,EnableAutoIndex__c,
                                                                EnableTotalRecordsCount__c,EnableFilter__c,EnableQuickSearch__c,QuickSearchBehaviour__c,ParentTargetLookupField__c,
                                                                HeaderDescription__c,HideRecordSelectionDecisionField__c,ShowHideDisabledAction__c,MassEditableGridConfigJSON__c,
                                                                RecordSelectionColumnHeader__c,RecordSelectionColumnPosition__c,ReadOnlyFields__c,RequiredFields__c,
                                                                StickySearchPlaceHolderText__c,StickySearchFieldApiName__c,EnableTotalColumn__c,RecordTypeId,RecordType.Name,RecordType.DeveloperName,
                                                                RowGroupingFieldsJSON__c,BudgetGridEditCondition__c,EnableTotalRow__c,TotalRowLabel__c,HideColumnsText__c,ReadOnlyFieldsJSON__c,ColumnGroupingFieldJSON__c,SummarizableField__c,
                                                                parentChildRelationshipField__c,parentGrantChildRelationshipField__c,EnableDataImportExport__c
                                                                FROM DataTableConfig__c
                                                                WHERE Name=:dataTableConfigName
                                                                WITH USER_MODE
                                                                LIMIT 1]; 
        }
        if(dataTableConfigObjList.size() > 0){
            List<DataTableConfig__c> dataTableConfigLst = new List<DataTableConfig__c>();
            DataTableConfig__c dataTableConfigObj = dataTableConfigObjList[0];
            if(dataTableConfigObj.RecordType.Name == 'Budget Grid' ) {
                dataTableConfigObj = flexGridUtility.getFieldNamesForBudgetGrid(dataTableConfigObj);
            }
            //  dataTableConfigObj = tmpFlextableUtility.getFieldNamesForBudgetGrid(dataTableConfigObj);
            String stickySearchTerm= '';
            String stickySearchJSON= '';
            String configFilterClause = '';
            String flexListViewDefaultClause = '';
            String flexListViewUserLastClause = '';   
            String flexListViewMasterClause = '';         
            String stickySearchPlaceHolderText = dataTableConfigObj.StickySearchPlaceHolderText__c;
            Boolean showFilterViewList = false;
            List<object> labelToFilterClause;
            Id loggedInUserId = userInfo.getUserId();
            List<FlexTableStickySearchConfig__c> flexStickySearchConfigList = new List<FlexTableStickySearchConfig__c>();
            if(Schema.sObjectType.FlexTableStickySearchConfig__c.isAccessible()){
                flexStickySearchConfigList = [SELECT Id,Name,StickySearchCriteria__c,StickySearchJSON__c 
                                                FROM FlexTableStickySearchConfig__c 
                                                WHERE FlexTableConfig__c = :dataTableConfigObj.Id 
                                                AND User__c = :loggedInUserId
                                                WITH USER_MODE];
            }
            List<FlexTableFilterListViewConfig__c> flexTableFilterListViewConfigList = new List<FlexTableFilterListViewConfig__c>();
            if(Schema.sObjectType.FlexTableFilterListViewConfig__c.isAccessible()){
                flexTableFilterListViewConfigList = [SELECT Id,Name,Label__c,Sequence__c,FilterClause__c,IsActive__c,IsDefault__c,IsMasterView__c 
                                                                                            FROM FlexTableFilterListViewConfig__c
                                                                                            WHERE FlexTableConfig__c = :dataTableConfigObj.Id
                                                                                            WITH USER_MODE
                                                                                            ORDER BY Sequence__c];
            }
            List<FlexTableListViewUserConfig__c> flexTableListViewUserConfigList = new List<FlexTableListViewUserConfig__c>();
            if(Schema.sObjectType.FlexTableListViewUserConfig__c.isAccessible()){
                flexTableListViewUserConfigList = [SELECT Id,Name,User__c,FlexTableListViewConfig__r.Label__c,FlexTableListViewConfig__r.FilterClause__c                                                                                            
                                                                                            FROM FlexTableListViewUserConfig__c
                                                                                            WHERE User__c = :loggedInUserId AND FlexTableConfig__c = :dataTableConfigObj.Id
                                                                                            WITH USER_MODE
                                                                                            ORDER BY LastModifiedDate
                                                                                            LIMIT 1];
            }
            if(flexTableListViewUserConfigList.size() > 0){
                flexListViewUserLastClause = flexTableListViewUserConfigList[0].FlexTableListViewConfig__r.FilterClause__c;
            }else{
                for(FlexTableFilterListViewConfig__c record : flexTableFilterListViewConfigList){
                    if(record.IsActive__c){
                        if(record.IsDefault__c){
                        flexListViewDefaultClause = record.FilterClause__c;
                        }
                        if(record.IsMasterView__c){
                            flexListViewMasterClause = record.FilterClause__c;
                        }
                    }                    
                }
            }
            if(flexTableFilterListViewConfigList.size() > 0){                
                labelToFilterClause = createFilterListViewMap(flexTableFilterListViewConfigList,dataTableConfigObj,flexListViewUserLastClause,flexListViewDefaultClause);  
                showFilterViewList = true;          
            }else{
                showFilterViewList = false;
            }                                                                                                                                                                   
            if(flexStickySearchConfigList.size() > 0 && flexStickySearchConfigList[0].StickySearchCriteria__c != null){
                stickySearchTerm = flexStickySearchConfigList[0].StickySearchCriteria__c;
                stickySearchJSON = flexStickySearchConfigList[0].StickySearchJSON__c;
            }
            this.headerDescription = dataTableConfigObj.HeaderDescription__c;
            
            if(dataTableConfigObj.SObject__c <> null){
                String SObjectName;
                Schema.SObjectType dataTableObjectType;      
                    SObjectName = dataTableConfigObj.SObject__c;
                    if(isHistory != null && isHistory == true){
                        SObjectName = historyObjName;
                        String suffix = '__c', parentField = 'ParentId';
                        if(!sobjectName.containsIgnoreCase('__History')){
                            dataTableConfigObj.FilterCriteria__c = dataTableConfigObj.FilterCriteria__c.replace('ParentId',originalObjectName+'Id');
                            dataTableConfigObj.FieldNames__c = dataTableConfigObj.FieldNames__c.replace('ParentId,','');
                        } 
                    } 
                    if(sobjectName.containsIgnoreCase('__History')){
                        String  originalObjectName = SObjectName.replace('__History','__c');
                    }
                    dataTableObjectType = SchemaManager.getSObjectTypeFromName(SObjectName);                     
                
                if(dataTableObjectType <> null){
                    Schema.DescribeSObjectResult dataTableObjectResult = dataTableObjectType.getDescribe();
                    Map<String,Schema.SObjectField> dataObjectFieldsMap = dataTableObjectResult.fields.getMap();
                    
                    if(sObjectType.AccordionContent__c != null){
                        String nameSpacePrefix = AppUtils.getNamespacePrefix();
                        result.put('NamespacePrefix',nameSpacePrefix ); 
                    }
                    Map<String,Object> fieldInfoMap = getFieldMetadata(dataTableConfigObj.Id, dataTableObjectType, dataTableConfigObj.SObject__c, dataTableConfigObj.FieldNames__c,
                                                                        dataObjectFieldsMap, replaceReferenceWithName);
                    result.put('FlexTableHeader',dataTableConfigObj.Header__c);
                    if(String.isEmpty(dataTableConfigObj.StickySearchPlaceHolderText__c)){                      
                        Map<String,Object> fieldsMetadata = (Map<String,Object>)fieldInfoMap.get('FieldsMap');
                        String stickySearchApiName = dataTableConfigObj.StickySearchFieldApiName__c;
                        if(String.isNotEmpty(stickySearchApiName)){                         
                            stickySearchApiName = stickySearchApiName.trim();                           
                            Map<String,Object> fieldData = (Map<String,Object>)fieldsMetadata.get(stickySearchApiName);                         
                            stickySearchPlaceHolderText = String.valueOf(fieldData.get('Label'));                           
                        }                       
                        
                    }
                    result.put('FieldMetadata',fieldInfoMap.get('FieldsMap'));
                    result.put('FieldsList',fieldInfoMap.get('FieldsList'));
                    result.put('FieldsColumnMap',fieldInfoMap.get('FieldsColumnMap'));
                    result.put('ColumnFieldMap',fieldInfoMap.get('ColumnFieldMap'));
                    result.put('ColumnsNameList',fieldInfoMap.get('ColumnsNameList'));
                    //additional column list to set default values which are not populated in display field names.
                    //It contains comma seprated field API Names and values will be populated from key value Map.
                    if(dataTableConfigObj.AdditionalColumns__c != null){
                        List<String> additionalcolumnslist = dataTableConfigObj.AdditionalColumns__c.split(',');
                        result.put('AdditionalColumnsList',additionalcolumnslist); 
                    }
                                        
                    if(dataTableConfigObj.RecordType.Name == 'Data Table' ) {               
                        String HideField = flexGridUtility.getHidefield(dataTableConfigObj);
                        fieldInfoMap.put('ColumnString',fieldInfoMap.get('ColumnString') +','+ HideField);
                        result.put('ColumnString',fieldInfoMap.get('ColumnString'));
                    }
                    
                    Map<String,Object> mergeFieldsKeyValueMap = new Map<String,Object>(); 
                    if(keyValueMap!=null && keyValueMap!=''){                                            
                        mergeFieldsKeyValueMap = (Map<string,object>)JSON.deserializeUntyped(keyValueMap);                        
                                                                       
                    }
                    result.put('KeyValueMap',mergeFieldsKeyValueMap); 
                    if(listKeyValueMap !=null && listKeyValueMap !=''){                             
                        Map<String,Object> keyValueMapForObj = new Map<String,Object>();
                        keyValueMapForObj = (Map<string,object>)JSON.deserializeUntyped(listKeyValueMap);
                        mergeFieldsKeyValueMap.putAll(keyValueMapForObj);
                           
                    }
                    
                    String filterCriteria = dataTableConfigObj.FilterCriteria__c;
                    String filterClause;// = dataTableConfigObj.FilterCriteria__c; 
                    filterCriteria = (String.isNotEmpty(flexListViewUserLastClause)) ? flexListViewUserLastClause :
                                    (String.isNotEmpty(flexListViewDefaultClause)) ? flexListViewDefaultClause : (String.isNotEmpty(flexListViewMasterClause)) ?
                                    flexListViewMasterClause : dataTableConfigObj.FilterCriteria__c;
                  
                    
                    if(isN2GSearch == 'true' && filterClauseN2GSearch != null){
                        filterCriteria = filterClauseN2GSearch;
                    }


                    if(filterCriteria != null && filterCriteria!= '' && mergeFieldsKeyValueMap != null ){
                        if(isHistory != null && isHistory == true){ 
                            String target = '{!parentid}';
                            String dest = String.escapeSingleQuotes(recordId); 
                            if(filterCriteria.contains(target)){
                                if(!sobjectName.containsIgnoreCase('__History')){
                                    filterCriteria = filterCriteria.replace('ParentId',originalObjectName+'Id');                                   
                                } 
                                filterClause = filterCriteria.replace(target,dest);  
                                filterClause =  filterClause + ' and DataType != \'EntityId\' and Field != \'created\'';////Bug 145679: NED - Add field history on payments//Bug 150629: Bug 114866: Organization - Enable History tab-Field Tracking (Shield)
                            }
                        }else{    
                            String target = '{!parentid}';
                            String dest = String.escapeSingleQuotes(recordId);
                            filterClause =  getFilterClauseString(filterCriteria, mergeFieldsKeyValueMap);  
                            if(filterCriteria.contains(target)){
                                filterClause = filterCriteria.replace(target,dest);  
                            }    
                            
                            configFilterClause = filterClause;                                                              
                        }                                                          
                    }   
                    List<DataTableAction__c> dataTableActionsList = new List<DataTableAction__c>();
                    if(Schema.sObjectType.DataTableAction__c.isAccessible()){
                        dataTableActionsList = [SELECT Id,RecordType.Name, Name, DeveloperActionName__c, ActionClass__c,StandardAction__c,ModalHeight__c,
                                                                         ModalWidth__c,ActionBehavior__c,ActionURL__c,ActionURLLong__c,DataTableConfig__c,HideInSearch__c,
                                                                         Location__c,Sequence__c,IconCSS__c, HeaderActionDisplayType__c,ConfirmationMessage__c,
                                                                         HideDecisionField__c, HideForUser__c,HideForProfile__c,ShowConfirmationBox__c,ModalTitle__c,RefreshBehavior__c,
                                                                         SobjectActionConfig__r.HideDecisionField__c,SobjectActionConfig__r.HideForProfile1__c,
                                                                         SobjectActionConfig__r.HideForUser__c,ButtonHelpText__c,HideOperator__c,HideForRole__c,SobjectActionConfig__r.HideOperator__c,
                                                                         SobjectActionConfig__r.HideForRole__c,HideExpressionJSON__C,HideExpressionFields__c,
                                                                         SobjectActionConfig__r.HideExpressionJSON__c,SobjectActionConfig__r.HideExpressionFields__c,SobjectActionConfig__r.HideForContext__c,RecordType.DeveloperName  
                                                                         FROM DataTableAction__c
                                                                         WHERE DataTableConfig__c=:dataTableConfigObjList[0].id
                                                                         WITH USER_MODE];
                    }
                    // Get MergeFields from ActionURLs
                    if(dataTableActionsList.size() > 0){
                       List<String> mergeFielList =getActionUrlMergerFields(dataTableActionsList);
                       if(mergeFielList.size() > 0){
                          colunmStringSet.addAll(mergeFielList);
                       }
                    }
                    
                    Map<String,Object> dataTableActionsMap = new Map<String,Object>();                    
                        // in case of print we dont want buttons.         
                        if(!FlexLayoutPrintGenerator.isPrint && dataTableActionsList.size() > 0) {
                            dataTableActionsMap = getActionInfo(dataTableActionsList,mergeFieldsKeyValueMap);
                            result.put('ActionInfo',dataTableActionsMap.get('ActionInfoMap'));
                            result.put('RowlevelActionExist',dataTableActionsMap.get('isRowlevelActionExist'));
                        }
                           
                        
                    Integer pageSize;
                    //Integer pageSizeForFlexGrid = KeyValueStoreHelper.getIntegerValue('FlexGridDefaultPageSize',true);
                    if(sforce1 == true){
                        pageSize = KeyValueStoreHelper.getIntegerValue('FlexTableDefaultPageSizeSF1',true);
                    }else{
                        if(dataTableConfigObj.RecordType.Name == 'Budget Grid'){
                            pageSize = KeyValueStoreHelper.getIntegerValue('BudgetGridDefaultPageSize',true);//BudgetGridDefaultPageSize;//Prem - remove this hardcoded value
                        }
                        if(dataTableConfigObj.DefaultPageSize__c != null){
                            pageSize = Integer.valueOf(dataTableConfigObj.DefaultPageSize__c) != null ? Integer.valueOf(dataTableConfigObj.DefaultPageSize__c) : KeyValueStoreHelper.getIntegerValue('FlexTableDefaultPageSize',true);
                            
                        }else if(gridRecordType == 'Nested Navigation Grid') {
                            pageSize = KeyValueStoreHelper.getIntegerValue('N2GTableDefaultPageSize',true);
                        }
                    }
                    if(pageSize == null){
                        pageSize = 20;    
                    }
                    
                    String hideDecisionFields = (String)dataTableActionsMap.get('HideDecisionFields');
                    if(!String.isEmpty(dataTableConfigObj.HideRecordSelectionDecisionField__c)){
                            hideDecisionFields = ','+dataTableConfigObj.HideRecordSelectionDecisionField__c;
                    }
                    
                    String SobjNameforquery;
                    Map<String,Object> datatableInfoMap = new Map<String,Object>();
                    if(isHistory != null && isHistory == true){
                        datatableInfoMap.put('SObjectName',historyObjName);
                        SobjNameforquery = historyObjName;
                    } else {
                        datatableInfoMap.put('SObjectName',dataTableConfigObj.SObject__c);
                        SobjNameforquery = dataTableConfigObj.SObject__c;                       
                    }
                    
                    // insert map values in set of String
                    String quCol = (String)fieldInfoMap.get('ColumnString');
                    List<String> quryColList = new List<String>();
                   
                    if( quCol !=null){
                        quryColList = quCol.split(',');
                         
                        if(quryColList.size() > 0){
                            colunmStringSet.addAll(quryColList);
                        }
                    }
                    
                    Set<String> colunmStringSetWithLowerCase = new Set<String>();
                    
                    //This loop to avoid duplication of fields(id and Id will not be considered as Different)
                    for (String quryCol : colunmStringSet) {
                        colunmStringSetWithLowerCase.add(quryCol.toLowerCase());
                    }

                    String colString = '';
                    for(String s : colunmStringSetWithLowerCase) {
                       colString += (colString==''?'':',')+s;
                    }
                     
                    // Pass set of String  
                    String queryCol = colString;
                    //String queryCol =(String)fieldInfoMap.get('ColumnString');
                    /* Code Commented For Double Query in Within Init Data*/

                   // String query = createSOQLQuery(queryCol,null,hideDecisionFields, SobjNameforquery, dataTableConfigObj.OrderBy__c, dataTableConfigObj.Sort_Direction__c, searchTerm, filterClause); 

                    
                    //Code for Form Config
                    datatableInfoMap.put('ColumnString',queryCol);
                    //datatableInfoMap.put('ColumnString',(String)fieldInfoMap.get('ColumnString'));
                    datatableInfoMap.put('HideDecisionFields',hideDecisionFields);
                    datatableInfoMap.put('PageNumber',1);
                    datatableInfoMap.put('PageSize',pageSize);
                    datatableInfoMap.put('OrderBy',dataTableConfigObj.OrderBy__c);
                    datatableInfoMap.put('SortDirection',dataTableConfigObj.Sort_Direction__c);
                    datatableInfoMap.put('RowLevelActionForDisabled',dataTableConfigObj.ShowHideDisabledAction__c);
                    datatableInfoMap.put('SearchTerm',searchTerm);
                   /* if(isN2GSearch == 'true' && filterClauseN2GSearch != null && filterClauseN2GSearch != '') {
                        datatableInfoMap.put('FilterClause',filterClauseN2GSearch); 
                    }else {
                        datatableInfoMap.put('FilterClause',filterClause);
                    }*/
                    datatableInfoMap.put('FilterClause',filterClause);
                    datatableInfoMap.put('IsSOSL',isSOSL);   
                    dataTableInfoMap.put('StickySearchFieldApiName',dataTableConfigObj.StickySearchFieldApiName__c);                 
                    dataTableInfoMap.put('StickySearchPlaceHolderText',stickySearchPlaceHolderText);
                    dataTableInfoMap.put('StickySearchLastSearchTerm',stickySearchTerm); 
                    dataTableInfoMap.put('StickySearchJSON',stickySearchJSON); 
                    dataTableInfoMap.put('ConfigFilterClause',configFilterClause);
                    dataTableInfoMap.put('LabelToFilterClause',labelToFilterClause);
                    dataTableInfoMap.put('ShowFilterViewList',showFilterViewList);
                    dataTableInfoMap.put('EnableTotalRecordsCount',dataTableConfigObj.EnableTotalRecordsCount__c);
                    dataTableInfoMap.put('EnableTotalColumn',dataTableConfigObj.EnableTotalColumn__c);
                    dataTableInfoMap.put('EnableTotalRow',dataTableConfigObj.EnableTotalRow__c);
                    dataTableInfoMap.put('TotalRowLabel',dataTableConfigObj.TotalRowLabel__c);
                    dataTableInfoMap.put('RowJSON',dataTableConfigObj.RowGroupingFieldsJSON__c);
                    dataTableInfoMap.put('RecordType',dataTableConfigObj.RecordType.DeveloperName);
                    dataTableInfoMap.put('RecordTypeName',dataTableConfigObj.RecordType.Name);

                    dataTableInfoMap.put('ColumnJSON',dataTableConfigObj.ColumnGroupingFieldJSON__c);
                    dataTableInfoMap.put('HideColumnsJSON',dataTableConfigObj.HideColumnsText__c);
                    dataTableInfoMap.put('ReadColumnJSON',dataTableConfigObj.ReadOnlyFieldsJSON__c);
                    dataTableInfoMap.put('BudgetGridEditJSON',dataTableConfigObj.BudgetGridEditCondition__c);
                    dataTableInfoMap.put('SummarizableField',dataTableConfigObj.SummarizableField__c);
                    dataTableInfoMap.put('PageSizeForFlexGrid',pageSize);
                    //dataTableInfoMap.put('Query',query);
                    dataTableInfoMap.put('ParentChildRelationField',dataTableConfigObj.parentChildRelationshipField__c);
                    dataTableInfoMap.put('ParentGrantChildRelationField',dataTableConfigObj.parentGrantChildRelationshipField__c);
                    
                    //dataTableInfoMap.put('ChildRelationShips', childRelationshipMap);
                    result.put('DataTableInfoMap',datatableInfoMap);
                    
                    result.put('ObjectMetaData',getObjectMetadata(dataTableObjectResult,dataTableConfigObj.FieldNames__c));                    
                    dataTableConfigLst.add(dataTableConfigObj);
                    result.put('ConfigInfo',getConfigInfo(dataTableConfigLst));
                    result.put('DataTableObjectResult',dataTableObjectResult);
                    
                    Timezone tz = UserInfo.getTimezone();
                    DateTime now = DateTime.now();
                    Integer offset = tz.getOffset(System.now());
                    result.put('Offset',offset);
                }                        
            }else{  
                result.put('ErrorMessages','No sobject defined in flex table config record found. Please contact your administrator.');  
            }
        }else{
            result.put('ErrorMessages','No data table config object found. Please contact your administrator.');
        }
       
        Boolean renderBtnForPDF = KeyValueStoreHelper.getBooleanValue('DownloadPDFStyle_FlexTable',true);
        result.put('renderBtnForPDF',renderBtnForPDF);
        
        Boolean renderBtnForCSV = KeyValueStoreHelper.getBooleanValue('DownloadCSVStyle_FlexTable',true);
        result.put('renderBtnForCSV',renderBtnForCSV);
        return result;    
    }

    private List<String> getActionUrlMergerFields(List<DataTableAction__c> actionList){
        List<String> mergeFieldKey = new List<String>();
         for(DataTableAction__c dataaction:actionList){
            if(dataaction.Location__c == 'Row'){
                String fields =String.isNotEmpty(dataaction.SobjectActionConfig__c) ? dataaction.SobjectActionConfig__r.HideExpressionFields__c : dataaction.HideExpressionFields__c;       
                if(String.isNotEmpty(fields)){
                    mergeFieldKey.addAll((fields).split(','));  
                }
            }
            
            if(dataaction.ActionURLLong__c !=null){
                 mergeFieldKey.addAll(AppUtils.getMergeFieldsWithoutObject(dataaction.ActionURLLong__c));
            }
            else if(dataaction.ActionURL__c !=null){
                mergeFieldKey.addAll(AppUtils.getMergeFieldsWithoutObject(dataaction.ActionURL__c));
            }
         }
         return mergeFieldKey;
    }
    
    
    private List<Object> createFilterListViewMap(List<FlexTableFilterListViewConfig__c> flexTableFilterListViewConfigList,DataTableConfig__c dataTableConfigObj,String flexListViewUserLastClause,String flexListViewDefaultClause){
        List<Object> resultList = new List<Object>();
       
        for(FlexTableFilterListViewConfig__c record : flexTableFilterListViewConfigList){
            if(record.IsActive__c){
                if(String.isNotEmpty(record.FilterClause__c)){
                    Map<String,Object> result = new Map<String,Object>();
                    result.put('label',record.Label__c);
                    result.put('clause',record.FilterClause__c);
                    result.put('isActive',record.IsActive__c);
                    result.put('isDefault',record.IsDefault__c);
                    result.put('isIsMasterView',record.IsMasterView__c);
                    if(record.FilterClause__c.equalsIgnoreCase(flexListViewUserLastClause)){
                        result.put('isSelected',true);
                    }else if(record.FilterClause__c.equalsIgnoreCase(flexListViewDefaultClause)){
                        result.put('isSelected',true);
                    }else if(String.isEmpty(flexListViewUserLastClause) && String.isEmpty(flexListViewDefaultClause) && record.IsMasterView__c){
                        result.put('isSelected',true);
                    }else{
                        result.put('isSelected',false);
                    }                
                    resultList.add(result);
                    }           
                }                
        }
        return resultList;
    }
    
    /*
    Method  :   getPageRecords ()
    Purpose :   This method is invoked on different page call actions apart from initial load like sorting, pagination, etc.
    */
    @RemoteAction
    global static Map<String,Object> getPageRecords(String queryColumns,String hideDecisionFields,String objectName, Integer pageNumber, Integer pageSize,String sortBy, String sortDir
                                                    ,String searchTerm,String filterClause,Boolean isSOSL){
        Map<String, Object> result = new Map<String, Object>();
        FlexTableCtrl flexTableController = new FlexTableCtrl();
        Map<String,Object> mergeFieldsKeyValueMap = new Map<String,Object>();
        filterClause = flexTableController.getFilterClauseString(filterClause, mergeFieldsKeyValueMap);                        
        result = flexTableController.getRecords(queryColumns,null,hideDecisionFields,objectName,pageNumber,pageSize,sortBy,sortDir,searchTerm,filterClause,isSOSL);  
        return result;  
    }
    
    
    global static Map<String,Object> getPageRecordsWithMergeFields(String queryColumns,String hideDecisionFields,String objectName, Integer pageNumber, Integer pageSize,String sortBy, 
                                            String sortDir,String searchTerm, String filterClause,Boolean isSOSL, String mergeFields){
        Map<String, Object> result = new Map<String, Object>();
        
        FlexTableCtrl flexTableController = new FlexTableCtrl();
        Map<String,Object> mergeFieldsKeyValueMap = new Map<String,Object>(); 
        if(mergeFields!=null && mergeFields!=''){                                            
            mergeFieldsKeyValueMap = (Map<string,object>)JSON.deserializeUntyped(mergeFields);                        
        }
        filterClause = flexTableController.getFilterClauseString(filterClause, mergeFieldsKeyValueMap);                        
        result = flexTableController.getRecords(queryColumns,null,hideDecisionFields,objectName,pageNumber,pageSize,sortBy,sortDir,searchTerm,filterClause,isSOSL);  
        return result;  
    }
    
    /*
        Method:getPageRecordsWithMergeFields()
        Purpose: This Method used in Skinny Flex Table Compoment to provide record while search from it along support for 
        for merge fields of KeyValueMap and ListParam. 
    */
    @RemoteAction
    global static Map<String,Object> getPageRecordsWithMergeFields(String queryColumns,String hideDecisionFields,String objectName, Integer pageNumber, Integer pageSize,String sortBy, 
                                            String sortDir,String searchTerm, String filterClause,Boolean isSOSL, String mergeFields, String listParams){
        Map<String, Object> result = new Map<String, Object>();
        
        FlexTableCtrl flexTableController = new FlexTableCtrl();
        Map<String,Object> mergeFieldsKeyValueMap = new Map<String,Object>(); 
        if(mergeFields!=null && mergeFields!=''){                                            
            mergeFieldsKeyValueMap = (Map<string,object>)JSON.deserializeUntyped(mergeFields);                        
        }
        if(String.isNotEmpty(listParams)){
            mergeFieldsKeyValueMap.putAll((Map<string,object>)JSON.deserializeUntyped(listParams));
        }
        filterClause = flexTableController.getFilterClauseString(filterClause, mergeFieldsKeyValueMap);                        
        result = flexTableController.getRecords(queryColumns,null,hideDecisionFields,objectName,pageNumber,pageSize,sortBy,sortDir,searchTerm,filterClause,isSOSL);  
        return result;  
    }
    
    /*
    Method  :   updateFlexTableWithStickySearch ()
    Purpose :   This method is invoked on different page call actions apart from initial load like sorting, pagination, etc.
    */
    @RemoteAction
    global static Map<String,Object> updateFlexTableWithStickySearch(Map<String,Object> paramMap){                                         
        Map<String,String> stickySerchConfig = new Map<String,String>();         
        FlexTableCtrl ctrl = new FlexTableCtrl();           
        List<String> queryColList = new List<String>();
           
        Boolean isSearchAllFields = Boolean.valueOf(paramMap.get('searchAllField')); 
        String objectName = String.valueOf(paramMap.get('objectName')); 
        
        String queryColumns = String.valueOf(paramMap.get('queryColumns'));
        String hideDecisionFields = String.valueOf(paramMap.get('hideDecisionFields'));
        
        Integer pageNumber = Integer.valueOf(paramMap.get('pageNumber'));
        Integer pageSize = Integer.valueOf(paramMap.get('pageSize'));
        String sortBy = String.valueOf(paramMap.get('sortFieldName'));
        String sortDir = String.valueOf(paramMap.get('sortDirection'));
        String searchTerm = String.valueOf(paramMap.get('searchTerm'));
        if(String.isNotBlank(searchTerm)){
            searchTerm = String.escapeSingleQuotes(searchTerm);
        }        
        String filterClause = String.valueOf(paramMap.get('newFilterClause'));
        Boolean isSOSL = Boolean.valueOf(paramMap.get('isSOSL'));           
        String stickySearchTerm = String.valueOf(paramMap.get('stickySearchTerm'));
        if(String.isNotBlank(stickySearchTerm)){
            stickySearchTerm = String.escapeSingleQuotes(stickySearchTerm);
        }        
        String stickySearchCriteria = String.valueOf(paramMap.get('stickySearchCriteria'));
        String stickySearchJSON = String.valueOf(paramMap.get('stickySearchJSON'));
        Id flexTableId = (Id)String.valueOf(paramMap.get('flexTableId'));
        Boolean isSelectionChagned = Boolean.valueOf(paramMap.get('isSelectionChagned')); 
        Boolean isHistory = Boolean.valueOf(paramMap.get('isHistory'));
        Map<String,Object> actionInfoMap = new Map<String,Object>();
        if(paramMap.get('actionInfo') != null){
            actionInfoMap = (Map<String,Object>)JSON.deserializeUntyped(String.valueOf(paramMap.get('actionInfo')));
        } 
        if(isHistory){
            // in case of pagination we already have Object_History. No need to append history again.
            if(objectName.endsWith('__c')){
                objectName = objectName.removeEnd('__c');
                objectName += '__History';
            }
            
        }
        Boolean isFilterCriteriaChanged = Boolean.valueOf(paramMap.get('isFilterCriteriaChanged')); 
        String updatdFlexHeader = String.valueOf(paramMap.get('updatedFlexHeader'));
        String keyValueMapString = String.valueOf(paramMap.get('flexKeyValueMap'));
        Map<String,Object>margeFieldKeyValueMap =  (Map<string,object>)JSON.deserializeUntyped(keyValueMapString);     
        Id userId = userInfo.getUserId();
        if(isFilterCriteriaChanged){
            FlexTableStickySearchCtrl.updateFlexTableListViewConfig(flexTableId,userId,updatdFlexHeader);
        }           
        //if(String.isNotEmpty(stickySearchCriteria)){
        //    filterClause += stickySearchCriteria;// Prem 26 Jan 2017 removed -> filterClause += ' AND '+stickySearchCriteria;
        //}
        filterClause = ctrl.getFilterClauseString(filterClause, margeFieldKeyValueMap);
        Map<String, Object> result = new Map<String, Object>();
        FlexTableCtrl flexTableController = new FlexTableCtrl();
        if(isSearchAllFields){
            result = flexTableController.getRecords(queryColumns,null,hideDecisionFields,objectName,pageNumber,pageSize,sortBy,sortDir,searchTerm,filterClause,isSOSL,null,isSearchAllFields);  
        }else{
        result = flexTableController.getRecords(queryColumns,null,hideDecisionFields,objectName,pageNumber,pageSize,sortBy,sortDir,searchTerm,filterClause,isSOSL);
        }
        //String recordJSON = JSON.serialize(result.get('RecordsList'));
        List<sObject> recordList = new List<sObject>();
        if(result !=null && !isHistory){
            recordList = (List<sObject>)result.get('RecordsList');
        }
        if(!objectName.containsIgnoreCase('History')){
            //List<SObject> recordList = (List<SObject>)JSON.deserialize(recordJSON,List<SObject>.class);
            result.put('HideExpMap',evaluateHideExpression(recordList,actionInfoMap,String.valueOf(paramMap.get('mode'))));
        }
        
        return result;  
    }

    
    /*
    Method  :   replaceUserMergeFields ()
    Purpose :   This method is to handle merge fields for User object.
                e.g. If we have a merge field like  {!user.Id} then it will be replaced by user id of current logged in user.
    */
    private String replaceUserMergeFields(String filterString){
        
        /* Special handling for user fields */ 
        if(filterString.containsIgnoreCase('{!User')){        
            Pattern regexForExtractingUserFields = Pattern.compile('\\{!((U|u)(S|s)(E|e)(R|r)\\.[a-zA-Z0-9\\.\\_]+)\\}'); 
            Matcher regexMatcherForExtractingUserTokens = regexForExtractingUserFields.matcher(filterString);        
                
            Map<String, String> userFieldsToQueryMap = new Map<String, String>();
            while (regexMatcherForExtractingUserTokens.find()){//SOQL/SOSL Injection False +ve         
                String userToken = regexMatcherForExtractingUserTokens.group();
                
                if(userToken != null && userToken.length() > 7) {
                    String userTokenAfterRemove = userToken.substring(2,userToken.length()-1); 
                    List<String> userSplitField = userTokenAfterRemove.split('\\.', 2);
                    userFieldsToQueryMap.put(userToken, userSplitField[1]);
                }             
            }
            if(userFieldsToQueryMap.size() > 0) {
                String userId = UserInfo.getUserId();
                String soqlQuery = 'SELECT '+String.escapeSingleQuotes(String.join(userFieldsToQueryMap.values(), ',')) + ' FROM USER  WHERE Id =:userId';// //CRUD False +ve As per business scenario it is failing for portal/external users
                User userObj = Database.query(String.escapeSingleQuotes(soqlQuery), AccessLevel.USER_MODE);//SOQL Injection - False +ve - Dynamic part of query string is escapeSingleQuotes
                for(String replaceStr : userFieldsToQueryMap.keySet()) {
                    Object value = AppUtils.getFieldValue(userObj, userFieldsToQueryMap.get(replaceStr));
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
    
    /*
    Method  :   replaceUserAccountMergeFields ()
    Purpose :   This method is to handle merge fields for Account associated with User record.
                e.g. If we have a merge field like  {!Account.Id} then it will be replaced by user id of current logged in user.
    */
    private String replaceUserAccountMergeFields(String filterString){
        if(filterString.contains('{!Account')){
            Pattern regexForExtractingUserFields = Pattern.compile('\\{!(Account\\.[a-zA-Z0-9\\.\\_]+)\\}'); 
            Matcher regexMatcherForExtractingUserTokens = regexForExtractingUserFields.matcher(filterString);        
                
            Map<String, String> acctFieldsToQueryMap = new Map<String, String>();
            while (regexMatcherForExtractingUserTokens.find()){//SOQL/SOSL Injection False +ve        
                String userToken = regexMatcherForExtractingUserTokens.group();
                
                if(userToken != null && userToken.length() > 7) {
                    String userTokenAfterRemove = userToken.substring(2,userToken.length()-1); 
                    List<String> userSplitField = userTokenAfterRemove.split('\\.', 2);
                    acctFieldsToQueryMap.put(userToken, userSplitField[1]);
                }             
            }
            if(acctFieldsToQueryMap.size() > 0) {
                User user = [SELECT OrganizationId__c FROM User WHERE Id =:UserInfo.getUserId() WITH USER_MODE LIMIT 1];//CRUD/FLS False +ve As per business scenario we can't check for portal/external users
                if(user.OrganizationId__c != null) {
                    String accQuery = 'SELECT '+ String.escapeSingleQuotes(String.join(acctFieldsToQueryMap.values(), ',')) + ' FROM Account WHERE Id =: user.OrganizationId__c';
                    List<Account> acccounts;
                    if(Schema.sObjectType.Account.isAccessible()){  
                        acccounts = Database.query(String.escapeSingleQuotes(accQuery),AccessLevel.USER_MODE);//SOQL Injection - False +ve - Dynamic part of query string is escapeSingleQuotes
                    }
                    if(acccounts.size() > 0) {
                        for(String replaceStr : acctFieldsToQueryMap.keySet()) {
                            Object value = AppUtils.getFieldValue(acccounts[0], acctFieldsToQueryMap.get(replaceStr));
                            if(value != null) {
                                filterString = filterString.replace(replaceStr, String.escapeSingleQuotes(string.valueof(value)));
                            } else {
                                filterString = filterString.replace(replaceStr, '');
                            }
                        }
                    }
                }
            }
        }
        return filterString;
    }
    
    
    /*
    Method  :   replaceRecordMergeFields ()
    Purpose :   This method is to handle merge fields for SObject associated with URL Id.
                e.g. If we have a merge field like  {!Program__c.Id} then it will be replaced by user id of current logged in user.
    */
    private String replaceRecordMergeFields(String filterString, Map<String,Object> mergeFieldsKeyValueMap) {
        if(mergeFieldsKeyValueMap.get('RecordId') == null) {
            return filterString;
        }
        Id recordId = Id.valueOf( String.valueOf(mergeFieldsKeyValueMap.get('RecordId')) );
        filterString = AppUtils.replaceRecordMergeFields(filterString,recordId);
        return filterString;
    }
    
    /*
    Method  :   appNameMergeFieldHandler ()
    Purpose :   This method is to handle merge field for App Name.
                e.g. If we have a merge field like  {!appName} then it will be replaced by existing users Active App Name
    */
    private Map<String,Object> appNameMergeFieldHandler(String mergeString,Map<String,Object> mergeFieldsKeyValueMap){
        
        /* Special handling for app name */        
        Pattern regexForExtractingAppName = Pattern.compile('\\{!((A|a)(P|p)(P|p)(N|n)(A|a)(M|m)(E|e))\\}'); 
        Matcher regexMatcherForExtractingAppNameTokens = regexForExtractingAppName.matcher(mergeString);        
        UserPreferences__c pref = UserPreferences__c.getInstance();
        String appName;
        if(pref != null){
            appName = pref.ActiveAppName__c;
        }else{
            pref = UserPreferences__c.getInstance();
            appName = pref.ActiveAppName__c;
        } 
        while (regexMatcherForExtractingAppNameTokens.find()){//SOQL/SOSL Injection False +ve         
            String appNameToken = regexMatcherForExtractingAppNameTokens.group();
            
            if(appNameToken != null){
                appNameToken = appNameToken.substring(2,appNameToken.length()-1);
                mergeFieldsKeyValueMap.put(appNameToken,appName);//SOQL/SOSL Injection False +ve
            }             
        }
        return mergeFieldsKeyValueMap;
    }
    
    /*
    Method  :   getFilterClauseString ()
    Purpose :   Identifies the merge fields in filter string and replaces them with the corresponding value.
    */
    global String getFilterClauseString(String filterClause, Map<String,Object> mergeFieldsKeyValueMap){
        return getFilterClauseString(filterClause, mergeFieldsKeyValueMap, true);
    }
    public String getFilterClauseString(String filterClause, Map<String,Object> mergeFieldsKeyValueMap, Boolean processRecordMerge){
        filterClause = filterClause.replace('\r\n','  ');                          
        // in case of export logic is bulkified
        if(processRecordMerge == true && filterClause.contains('{!')) {
            //replace User Account Merge fields                       
            filterClause  = replaceRecordMergeFields(filterClause, mergeFieldsKeyValueMap);
            //replace User Account Merge fields                       
            filterClause  = replaceUserAccountMergeFields(filterClause);
            //replace User Merge fields                       
            filterClause  = replaceUserMergeFields(filterClause);
            // replace current app merge fields
        }
        mergeFieldsKeyValueMap  = appNameMergeFieldHandler(filterClause,mergeFieldsKeyValueMap);
        List<String> filterList = new List<String>();
        
        // Added by chinmay to add OR support in case of filter criteria.        
        Pattern regexForExtractingCriterias = Pattern.compile('([\\s]+((a|A)(n|N)(d|D)[\\s]+)|(o|O)(r|R)[\\s]+)');  
        filterList = regexForExtractingCriterias.split(filterClause);                                                          
          
        if(filterList  != null && filterList.size() > 0){
            for(String filter : filterList) {
                filter = filter.trim();                                
                List<String> filterTokensList = new List<String>();
                Pattern regexForExtractingTokens = Pattern.compile('(=|!=|<|>|<=|>=)'); 
                Matcher regexMatcherForExtractingTokens = regexForExtractingTokens.matcher(filter);
                while (regexMatcherForExtractingTokens.find()){//SOQL/SOSL Injection False +ve         
                    String operatorToken = regexMatcherForExtractingTokens.group();
                    filter = regexMatcherForExtractingTokens.replaceAll(' '+operatorToken +' '); 
                }
                filterTokensList = filter.split('(\\s+)'); 

                if(filterTokensList != null && filterTokensList.size() > 0){
                    String operator = '';
                    String mergeFieldVal = ''; 
                    if(filterTokensList.size() == 3){
                        operator =  filterTokensList[1];
                        mergeFieldVal =  filterTokensList[2]; 
                    }else if(filterTokensList.size() == 4){
                        operator =  filterTokensList[1] + ' ' + filterTokensList[2]; 
                        mergeFieldVal =  filterTokensList[3]; 
                    }
                    String mergeFieldKey = '';
                    Pattern regex = Pattern.compile('\\{!([^}]*)\\}'); 
                    Matcher regexMatcher = regex.matcher(mergeFieldVal); 
                    while (regexMatcher.find()){//SOQL/SOSL Injection False +ve         
                        String dirtyVariable = regexMatcher.group();
                        mergeFieldKey  = dirtyVariable.substring(2,dirtyVariable.length()-1); 
                    }    
                    if(operator == '=' || operator == '!=' || operator == '<' || operator == '<=' || operator =='>' ||  operator == '>=' || operator.equalsIgnoreCase('like')){                                                                               
                         if(mergeFieldsKeyValueMap.get(mergeFieldKey) != null){
                             String value = (String)mergeFieldsKeyValueMap.get(mergeFieldKey);
                             filterClause = filterClause.replace('{!'+mergeFieldKey+'}',String.escapeSingleQuotes(value));
                         } 
                    }else if(operator.equalsIgnoreCase('in') || operator.equalsIgnoreCase('not in')){                         
                        if(mergeFieldsKeyValueMap.get(mergeFieldKey) != null){
                             List<Object> listValue = (List<Object>)mergeFieldsKeyValueMap.get(mergeFieldKey); 
                             String filterKeyValue = '(';
                             if(listValue != null && !listValue.isEmpty()){
                                 for(Object o:listValue){
                                     filterKeyValue += '\'' + String.escapeSingleQuotes((String)o) + '\',';    
                                 }
                                 filterKeyValue  = filterKeyValue.subString(0,filterKeyValue.length()-1) ;
                             }else{
                                 filterKeyValue += '\'\'';
                             }
                             filterKeyValue += ')';
                             filterClause = filterClause.replace(mergeFieldVal.replace(')',''),filterKeyValue );
                         } 
                    }else if(operator.equalsIgnoreCase('includes') ||operator.equalsIgnoreCase('excludes')){
                        if(mergeFieldsKeyValueMap.get(mergeFieldKey) != null){
                            String value = (String)mergeFieldsKeyValueMap.get(mergeFieldKey);
                            if(value == null){
                                value = '(\'\')';
                            }else{
                                //value = value.replace(';','\',\'');     //This was old code. changed it with below for Security reasons.
                                //value = '(\''+ value +'\')';
                                List<String> valuesList = value.split(';');
                                value = '(';
                                for(String val: valuesList){
                                    value += '\''+String.escapeSingleQuotes(val)+'\',';
                                }
                                value = value.removeEnd(',');
                                value += ')';
                            }
                            filterClause = filterClause.replace(mergeFieldVal,value );
                        }
                    }
                } 
            }
            //Pankaj : Above approach is not correct. It is breaking for complex filter clause with merge fields ex -
            //(Type='Email' AND WhatId='{!parentRecordIdOfFlexTable}') OR (Type='Email' AND WhoId='{!parentRecordIdOfFlexTable}')
            // Added quick fix
            for(String token : mergeFieldsKeyValueMap.keySet()) {
                if(mergeFieldsKeyValueMap.get(token) != null) {
                    filterClause = filterClause.replace('{!' + token + '}', String.escapeSingleQuotes(String.valueOf(mergeFieldsKeyValueMap.get(token))));
                }
            }
        }
        return  filterClause;
    }  
     
    /*
    Method  :   getRecords ()
    Purpose :   This method constructs the query and fetches records from the database. Overload used by both Flex Table and Flex Grids.
    */
    private Map<String,Object> getRecords(String queryColumns, String childRelationshipQueries, String hideDecisionFields, String objectName, Integer pageNumber, Integer pageSize, String sortBy, String sortDir, String searchTerm, String filterClause, Boolean isSOSL) {
        return getRecords(queryColumns, childRelationshipQueries, hideDecisionFields, objectName, pageNumber, pageSize, sortBy, sortDir, searchTerm, filterClause, isSOSL, null);
    }

    
    private Map<String,Object> getRecords(String queryColumns, String childRelationshipQueries, String hideDecisionFields, String objectName, Integer pageNumber, Integer pageSize, String sortBy, String sortDir, String searchTerm, String filterClause, Boolean isSOSL, Map<String, String> stickySearchConfig) {
        return getRecords(queryColumns, childRelationshipQueries, hideDecisionFields, objectName, pageNumber, pageSize, sortBy, sortDir, searchTerm, filterClause, isSOSL, stickySearchConfig, false);  
    } 

    private Map<String,Object> getRecords(String queryColumns, String childRelationshipQueries, String hideDecisionFields, String objectName, Integer pageNumber, Integer pageSize, String sortBy, String sortDir, String searchTerm, String filterClause, Boolean isSOSL, Map<String, String> stickySearchConfig, Boolean searchAllField){
        /* Create a map object to be returned */
        Map<String, Object> retVal = new Map<String, Object>(); 
        retVal.put('ErrorMessages','');
        // Reading Standard Object for Flex Table in custom setting...
        String flexStdObjs = KeyValueStoreHelper.getTextValue('FlexTableStandardObjects',true);
        // Global Search Value...
        if(searchAllField && String.isNotEmpty(searchTerm)){
             if(flexStdObjs != null && flexStdObjs.containsIgnoreCase(objectName)){
                retVal = handleSOSLStandardListControllers(queryColumns,hideDecisionFields,objectName, pageNumber, pageSize,sortBy, sortDir,searchTerm,filterClause);                
             }else{
                 retVal = handleSOSLFlexTables(queryColumns,hideDecisionFields,objectName, pageNumber, pageSize,sortBy, sortDir,searchTerm,filterClause);
             }
         }else{
        if(isSosl && objectName != 'Profile' && objectName != 'Group' && objectName != 'UserRole') {
            if(objectName == 'Profile') {
               // retVal = handleSOSLStandardListControllers(queryColumns,hideDecisionFields,objectName, pageNumber, pageSize,sortBy, sortDir,searchTerm,filterClause);   
            }else { 
                        retVal = handleSOSLFlexTables(queryColumns,hideDecisionFields,objectName, pageNumber, pageSize,sortBy, sortDir,searchTerm,filterClause);            
            }
        }else {
            if(stickySearchConfig != null) {
                String stickyLastSearchTerm = stickySearchConfig.get('stickyLastSearchTerm');
                if(String.isNotBlank(stickyLastSearchTerm)){
                    stickyLastSearchTerm = String.escapeSingleQuotes(stickyLastSearchTerm);
                }                
                String stickySearchFieldApiName = stickySearchConfig.get('stickySearchFieldApiName');
                if(String.isNotEmpty(stickyLastSearchTerm)) {
                    if(String.isNotEmpty(filterclause)) {
                        //filterclause += ' AND '+ stickySearchFieldApiName+' IN ('+stickyLastSearchTerm+')';
                        filterclause +=  ' AND '+ stickyLastSearchTerm;
                    }else{
                        //filterclause = ' WHERE '+ stickySearchFieldApiName+' IN ('+stickyLastSearchTerm+')';
                        filterclause = stickyLastSearchTerm;
                    }
                }
            }
            retVal = handleSOQLFlexTables(queryColumns, childRelationshipQueries, hideDecisionFields, objectName, pageNumber, pageSize, sortBy, sortDir, searchTerm, filterClause);
        }
         }
        
        
        return retVal;
    } 
    /*
    Method  :   createSOQLQuery ()
    Purpose :   This method handles the creation of query.    
    */ 
    public String createSOQLQuery(String queryColumns,String childRelationshipQueries,String hideDecisionFields, String objectName,String sortBy, String sortDir,String searchTerm,String filterClause){
        
        if(objectName.equals('CaseComment')){
            queryColumns = queryColumns.replace('Parent.Name','ParentId');
        }
        childRelationshipQueries = childRelationshipQueries == null ? '' : string.escapeSingleQuotes(childRelationshipQueries);
        Set<String> queryColumnsSet = new Set<String>();
        Set<String> trimmedQueryColumnsSet = new Set<String>();
        queryColumnsSet.addAll(queryColumns.deleteWhitespace().split(','));
        if(hideDecisionFields != null && hideDecisionFields != ''){
            queryColumnsSet.addAll(hideDecisionFields.deleteWhitespace().split(','));
        }
        Schema.SObjectType ObjDetails = Schema.getGlobalDescribe().get(objectName);
        if(ObjDetails != null){
            DescribeSObjectResult d = ObjDetails.getDescribe();
            Schema.DisplayType type;
            for(String columns :queryColumnsSet){
                if(d.fields.getMap().get(columns) !=  null){
                    type =  d.fields.getMap().get(columns).getDescribe().getType();
                }
                if(columns !=''&& type != Schema.DisplayType.MULTIPICKLIST){
                    trimmedQueryColumnsSet.add(string.escapeSingleQuotes(columns.trim()));
                } else if(columns !=''){
                    trimmedQueryColumnsSet.add('toLabel('+string.escapeSingleQuotes(columns.trim())+')');
                }
                type = null;
            }
        }else{
            for(String columns :queryColumnsSet){
                if(columns !=''){
                    trimmedQueryColumnsSet.add(string.escapeSingleQuotes(columns.trim()));
                }
            }  
        }        
        String query ='';
        if(queryColumnsSet.size () > 0){
             query = 'SELECT ' + AppUtils.concatenate(trimmedQueryColumnsSet, ', ') + childRelationshipQueries +   ' FROM ' + String.escapeSingleQuotes(objectName) ; 
        }
        String whereClause = '';
        if(filterClause != null && filterClause != '' && filterClause != 'undefined'){
             whereClause += ' WHERE ';
             if(searchTerm != null && searchTerm != '' && searchTerm != 'ALL'){ 
                whereClause +=  '( '+ AppUtils.parseWhereClause(filterClause) +' )';
             }else{
             whereClause +=  AppUtils.parseWhereClause(filterClause); 
        }
            
        }
        if(searchTerm != null && searchTerm != '' && searchTerm != 'ALL'){ 
            whereClause += (whereClause.contains('WHERE')) ? ' AND ' : ' WHERE ';
            whereClause += ' Name LIKE \'%' + String.escapeSingleQuotes(searchTerm) + '%\' ';
        } 
         
        // Changes made for: Fetch applicable Report folders as per the current App.
        if(objectName == 'Report'){
            List<Id> folderIdList = new List<Id>();
            folderIdList = getReportFolderId();
            if(folderIdList != null && folderIdList.size() > 0){
                whereClause += (whereClause.contains('WHERE')) ? ' AND ' :  ' WHERE ';
               for(ID fid : folderIdList){
                    whereClause += ' OwnerId = \''+string.escapeSingleQuotes(fid) +'\''+ ' OR ';  // OwnerId = FolderId --> to fetch reports in that folder
                }
                String suffix = ' OR ';
                if(whereClause.endsWith(suffix)){
                    whereClause = whereClause.substring(0, whereClause.length()- suffix.length());
                }
            }
        }
        query += AppUtils.parseWhereClause(whereClause);//SOQL Injection - False +ve Dynamic parts of query is escapeSingleQuotes and whereClause is sanitized using custom method of AppUtils
        String sortString = '';
        if(sortBy!=null && sortBy!='') {
             sortString = ' ORDER BY ' + string.valueof(sortBy) + ' ';
             if(sortDir!=null && sortDir!=''){
                 sortString += ' ' + string.valueof(sortDir) + ' ';
                 if(sortDir.equalsIgnoreCase('DESC')) {
                    sortString += ' NULLS LAST '; 
                 }
             }else{
                 sortString += ' ASC ';
             }                 
        }
        query += sortString;
        globalQueryString = query;
        return query;   
    }
    
    /*
    Method  :   handleSOQLFlexTables ()
    Purpose :   This method handles the creation of flex tables that use SOQL. Overloaded to fit Flex Grids
    */
    public Map<String, Object> handleSOQLFlexTables(String queryColumns, String childRelationshipQueries, String hideDecisionFields, String objectName, Integer pageNumber, Integer pageSize, String sortBy, String sortDir, String searchTerm, String filterClause) {
        Map<String, Object> retVal = new Map<String, Object>();
        List<sobject> records = new List<sobject>();
        String query = createSOQLQuery(queryColumns,childRelationshipQueries,hideDecisionFields, objectName,sortBy, sortDir,searchTerm,filterClause);
        String flexStdObjs = KeyValueStoreHelper.getTextValue('FlexTableStandardObjects',true);
        if(AppUtils.isHistoryTable(objectName)){
            retVal = handleStandardListControllers(query,queryColumns,hideDecisionFields,pageNumber,pageSize,filterClause,sortBy, sortDir,objectName);  
        }else if(objectName.containsIgnoreCase('__share')){
            retVal = handleStandardListControllers(query,queryColumns,hideDecisionFields,pageNumber,pageSize,filterClause,sortBy, sortDir,objectName);
        }else if(flexStdObjs != null && flexStdObjs.contains(objectName)){
            retVal = handleStandardListControllers(query,queryColumns,hideDecisionFields,pageNumber,pageSize,filterClause,sortBy, sortDir,objectName);
        }else{
            if(objectName.equalsignoreCase('CaseComment')  || objectName.equalsignoreCase('UserRole')  || objectName.equalsignoreCase('Note')  || objectName.equalsignoreCase('Group') || objectName.equalsignoreCase('QueueSobject') || objectName.equalsignoreCase('GroupMember') || objectName.equalsignoreCase('EmailTemplate') || objectName.equalsignoreCase('UserLicense')) {
                retVal = handleStandardListControllers(query,queryColumns,hideDecisionFields,pageNumber,pageSize,filterClause,sortBy, sortDir,objectName);
            }else {
                retVal = handleStandardSetControllers(query, queryColumns, hideDecisionFields, pageNumber, pageSize, filterClause, sortBy, sortDir, objectName);
            }
        }
        retval.put('isSOSL',false);
        return retVal;   
    }

    public static Boolean isValidSalesforceId( String sfdcId){
        try{
            if( Pattern.compile( '[a-zA-Z0-9]{15}|[a-zA-Z0-9]{18}' ).matcher( sfdcId ).matches() ){
                return true;
            }
        }catch(Exception e){
            return null;
        }
        return false;
    }
    
    /*
    Method  :   handleStandardListControllers ()
    Purpose :   This method handles fetching of records which are not supported by Standard set controllers e.g Task.    
    */
    public Map<String, Object> handleStandardListControllers(String query,String queryColumns,String hideDecisionFields,Integer pageNumber,Integer pageSize,String filterClause,String sortBy, String sortDir,String objectName){
        Map<String, Object> retVal = new Map<String, Object>();
        List<sobject> records = new List<sobject>();
        if(AppUtils.isObjectAccessible(objectName)){
            records = Database.query(query,AccessLevel.USER_MODE);//SOQL Injection - False +ve - Dynamic part of query string is escapeSingleQuotes
        }

        Integer j = 0;
        while (j < records.size()){
           sObject obj = records.get(j);
           Map<String, Object> fieldsToValue = Obj.getPopulatedFieldsAsMap();
           if(fieldsToValue.containsKey('Field') && obj.get('Field') == 'Owner' && isValidSalesforceId(String.valueOf(obj.get('NewValue')))){ 
                records.remove(j);
                }else{
                j++;
            }
        
        }

        Integer resultSize = 0; 
        // need to call this methiod twice to get the result size as we are skipping the duplicate entry occuring for reference field
        List<HistoryClass> history = new List<HistoryClass>();
        if(objectName.indexOf('History') != -1){//This means that the sobject is an history object
            history = handleHistoryRecords(records,objectName);
            //Replace Id values with its names.
            history = replaceIdValues(history);
            resultSize = history.size();
        }else{
            resultSize = records.size();
        }     
        Integer max_pages = (Integer)Math.ceil((double)resultSize/pageSize);
        if(max_pages == 0){
            pageNumber = 0;
        }
        Integer offset = (pageNumber-1)*pageSize;
        if(offset >= 0 && offset <= 2000) { 
            query += ' LIMIT ' + Integer.valueOf(pageSize);
            query += ' OFFSET ' + Integer.valueOf(offset);
        }
        if(AppUtils.isObjectAccessible(objectName)) {
            records = Database.query(query,AccessLevel.USER_MODE);//SOQL Injection - False +ve - Dynamic part of query string is escapeSingleQuotes
        }
        
        if(objectName.indexOf('History') != -1){//This means that the sobject is an history object
            //List<HistoryClass> history = handleHistoryRecords(records,objectName);
            history = getHistoryPageRecords(history, pageNumber, pageSize,offset);
            retVal.put('RecordsList',history);
            retVal.put('ResultSize',resultSize);    
        }else{
            retVal.put('RecordsList',records);  
            retVal.put('ResultSize', resultSize); // ResultSetSize - as in setcontroller
        } 
        
        retVal.put('QueryColumns',queryColumns );
        retVal.put('HideDecisionFields',hideDecisionFields );
        if(filterClause == null){
            filterClause = '';    
        }                
        retVal.put('FilterClause',filterClause);  
        retVal.put('SortColumn',sortBy); 
        retVal.put('SortDir',sortDir);  
        retVal.put('ObjectName',objectName);           
        
        Boolean hasNext = pageNumber == max_pages ? false:true;
        boolean hasPrev = pageNumber == 1?false:true;
        retVal.put('HasPrevious',hasPrev);   
        retVal.put('HasNext',hasNext); 
        retVal.put('TotalPages',max_pages); 
        retVal.put('PageSize', pageSize); // PageSize - Page information must be returned to keep list in sync
        retVal.put('PageNumber', pageNumber); // PageNumber that is to be returned
        
        return retVal;
    }

    /*
        Name    : Mayuresh G
        Bug Id  : 26279 : Ohio - Need to map salesforce ID to business ID
        Comment :  Replace Id values with its names from Old value and New Value of History.
    */
    //Replace Id values with its names.
    public List<HistoryClass> replaceIdValues(List<HistoryClass> history){
        Map<String,List<Id>> mapValIds = new Map<String,List<Id>>();
        //
        for(HistoryClass objHistory : history){
            if(objHistory.NewValue != null && (objHistory.NewValue.length() == 15 || objHistory.NewValue.length() == 18)){
                List<Id> lstRecordIds = new List<Id>();
                try {
                    Id idNew = (Id)objHistory.NewValue;
                } catch(Exception ex) {
                    continue;
                }
                if(mapValIds.containsKey(objHistory.NewValue.substring(0,3))){
                    lstRecordIds = mapValIds.get(objHistory.NewValue.substring(0,3));
                }
                lstRecordIds.add((Id)objHistory.NewValue);
                mapValIds.put(objHistory.NewValue.substring(0,3), lstRecordIds);
            }
            if(objHistory.oldValue != null && (objHistory.OldValue.length() == 15 || objHistory.oldValue.length() == 18)){
                List<Id> lstRecordIds = new List<Id>();
                try {
                    Id idOld = (Id)objHistory.oldValue;
                } catch(Exception ex) {
                    continue;
                }
                if(mapValIds.containsKey(objHistory.oldValue.substring(0,3))){
                    lstRecordIds = mapValIds.get(objHistory.oldValue.substring(0,3));
                }
                lstRecordIds.add((Id)objHistory.OldValue);
                mapValIds.put(objHistory.oldValue.substring(0,3), lstRecordIds);
            }
        }
        map<Id,String> mapIdToName = new map<Id,String>();
        for (String key : mapValIds.keySet()) {
            // The "key" variable is also available inside the loop
            List<Id> lstIds = mapValIds.get(key);
            if(lstIds != null && lstIds.size()>0 && objectName != null && AppUtils.isObjectAccessible(objectName)){
                SchemaManager.SObjectWrapper parentSObject = SchemaManager.getSObject(lstIds[0]);
                String queryStr = 'select Id,Name from '+String.escapeSingleQuotes(parentSObject.objectName)+' WHERE Id IN: lstIds';
                List<SObject> lstSObj;
                if(AppUtils.isObjectAccessible(parentSObject.objectName)){   //CRUD/FLS False +ve with the help of AppUtils we have performed check
                    lstSObj = Database.query(String.escapeSingleQuotes(queryStr),AccessLevel.USER_MODE);//SOQL Injection - False +ve - Dynamic part of query string is escapeSingleQuotes
                }
                if(lstSObj != null){
                    for(Sobject obj : lstSObj){
                        mapIdToName.put((Id)obj.get('Id'),(String)obj.get('Name'));
                    }
                }
            }
        }
        if(mapIdToName != null && mapIdToName.size()> 0){
            for(HistoryClass objHistory : history){
                if(objHistory.NewValue != null && (objHistory.NewValue.length() == 15 || objHistory.NewValue.length() == 18 )&& mapIdToName.containsKey(objHistory.NewValue)){
                    objHistory.NewValue = mapIdToName.get(objHistory.NewValue) == null ? objHistory.NewValue : mapIdToName.get(objHistory.NewValue);
                }
                if(objHistory.OldValue != null && (objHistory.OldValue.length() == 15 || objHistory.OldValue.length() == 18) && mapIdToName.containsKey(objHistory.OldValue)){
                    objHistory.OldValue = mapIdToName.get(objHistory.OldValue) == null ? objHistory.OldValue : mapIdToName.get(objHistory.OldValue);
                }
            }
        }
        return history;
    }

    //get page records for field history
    private List<HistoryClass> getHistoryPageRecords(List<HistoryClass> history,Integer pageNumber,Integer pageSize, Integer offset){
        List<HistoryClass> historyRecord = new List<HistoryClass>();
        if(history != null && history.size()==0){
            return historyRecord;
       }
        Integer pageStartRec = pageNumber == 1 ? 0 : offset;
        if(pageStartRec >= history.size()){
            pageStartRec = 0;
        }
        Integer count = 1;
        for(Integer i = pageStartRec; i < history.size(); i++){
            if(count > pageSize){
                break;
            }
            historyRecord.add(history.get(i));    
            count++;
        }
        return historyRecord;
    }

    /*
    Method  :   handleHistoryRecords ()
    Purpose :
    */
    public List<HistoryClass> handleHistoryRecords(List<sobject> records, String objectName){
        List<HistoryClass> updatedRecords = new List<HistoryClass>();
        String picklistObjName = objectName;
        String parentObjectName;      
        if(objectName.indexOf('__History') != -1){
             parentObjectName = objectName.replace('__History','__c');  
        }else{
             parentObjectName = objectName.replace('History','');   
        }
        List<Id> parentIds = new List<Id>();
        List<SobjectConfig__c> sobj = new List<SobjectConfig__c>();
        if(Schema.sObjectType.SobjectConfig__c.isAccessible()){
            sobj = [SELECT UserFriendlyNameField__c from SobjectConfig__c WHERE name =: parentObjectName  WITH USER_MODE];
        }
        Map<id,sobject> sobjectMap = new Map<id,sobject>();
        if(objectName.indexOf('__History') != -1){
        for(sobject historyRecord: records){
            parentIds.add((Id)historyRecord.get('parentId'));
        }
        }
        String uniqueField = 'name';
        String query = 'SELECT id,name from ' + String.escapeSingleQuotes(parentObjectName)+  ' WHERE id in: parentIds';
        if(sobj.size() > 0 && !String.isEmpty(sobj[0].UserFriendlyNameField__c) ){    
            query = 'SELECT id,' + String.escapeSingleQuotes(sobj[0].UserFriendlyNameField__c) +   ' from ' + String.escapeSingleQuotes(parentObjectName)+  ' WHERE id in: parentIds';
            uniqueField = sobj[0].UserFriendlyNameField__c;
        } 
        if(AppUtils.isObjectAccessible(parentObjectName)){   //CRUD/FLS False +ve with the help of AppUtils we have performed check
            sobjectMap = new Map<id,sobject>(Database.query(String.escapeSingleQuotes(query),AccessLevel.USER_MODE));//SOQL Injection - False +ve - Dynamic part of query string is escapeSingleQuotes
        }//try {  
            Boolean skipEntry = false;                  
            Schema.SObjectType parentObjectType = SchemaManager.getSObjectTypeFromName(parentObjectName);
            if(parentObjectType <> null){
                Schema.DescribeSObjectResult parentObjectResult = parentObjectType.getDescribe(); 
                if(parentObjectResult <> null){
                    Map<String,Schema.SObjectField> parentObjectFieldsMap = parentObjectResult.fields.getMap();
                    for(sobject historyRecord: records){
                        String fieldAPIName = historyRecord.get('Field')+'';
                        if(parentObjectName.equalsignorecase('Case') && fieldAPIName.equalsignorecase('Owner')) { // Added by Davinder(8/5/15) for showing Case History 
                          fieldAPIName = 'ownerId';
                        }
                        if(fieldAPIName.equalsignorecase('TextName') && parentObjectName.equalsignorecase('Account')) { 
                          fieldAPIName = 'name';
                        }
                        String fieldLabel;
                        string relationshipName;
                        // Need to check field type for Currency
                        String fieldType;
                        Integer scaleVal;

                        if(fieldAPIName == 'RecordType' || fieldAPIName == 'Owner' || fieldAPIName=='Account'){//Bug 145679: NED - Add field history on payments//Bug 150629: Bug 114866: Organization - Enable History tab-Field Tracking (Shield)
                            fieldLabel = fieldAPIName;

                        } else{
                        Schema.DescribeFieldResult fieldDescribe = parentObjectFieldsMap.get(fieldAPIName.toLowerCase()+'').getDescribe();
                            fieldLabel = fieldDescribe.getLabel()+'';
                            relationshipName = fieldDescribe.getRelationshipName();
                        // Need to check field type for Currency
                            fieldType = fieldDescribe.getType()+'';
                            scaleVal = fieldDescribe.getScale();
                        }                      
                       
                        skipEntry = false;

                        HistoryClass historyRec = new HistoryClass();
                        historyRec.Idval = historyRecord.Id;
                        //Sobject sobj = sobjectMap.get((Id)historyRecord.get('parentId')); 
                        if(sobjectMap.size () > 0){
                            historyRec.Parent.put('Name',sobjectMap.get(Id.valueOf((String)historyRecord.get('ParentId'))).get(uniqueField)+'');//historyRecord.getSobject('Parent');   //historyRecord.getSobject('Parent').get('Name') + '';                        
                        }
                        historyRec.Field = fieldLabel;
                        if(historyRecord.get('OldValue') == null){
                            historyRec.OldValue = '';
                        }else{
                            if(!String.isEmpty(relationshipName)){    //this block skips the id part for refernce field so put comment here 
                                try{
                                    String oldValue = Id.valueOf((String)historyRecord.get('OldValue'));
                                    skipEntry = false;

                                }catch(Exception e){
                                    if( historyRecord.get('OldValue') == true ||  historyRecord.get('OldValue') == false){
                                        historyRec.OldValue = historyRecord.get('OldValue')+'';
                                    }else{
                                    historyRec.OldValue = SFDCEncoder.SFDC_HTMLENCODE((String)historyRecord.get('OldValue')+'');
                                }
                                }
                            }else{
                                   // This Code is Being Added for Formatting currency fields in Field History for Old Value.
                                    if(fieldType == 'CURRENCY' && historyRecord.get('OldValue') != null){
                                        historyRec.OldValue = '$' +  historyRecord.get('OldValue')+'';
                                        String oldVal= historyRecord.get('OldValue')+'';
                                        Decimal oldValDec = Decimal.valueOf(oldVal);
                                        String formatedOldVal = AppUtils.getFormattedNumber(Double.valueOf(oldValDec),scaleVal,true,fieldType);
                                        historyRec.OldValue = formatedOldVal;
                                    } else if(fieldType == 'DATE' && historyRecord.get('OldValue') != null){
                                        String formateddtOldVal =  Datetime.valueOf(historyRecord.get('OldValue')+'').format(AppUtils.getUserDateFormat());
                                        historyRec.OldValue = formateddtOldVal;
                                    } else if(fieldType == 'DATETIME' && historyRecord.get('OldValue') != null){
                                        DateTime formateddtimeOldVal = Datetime.valueOf(historyRecord.get('OldValue'));
                                        historyRec.OldValue = formateddtimeOldVal.format(AppUtils.getUserDateTimeFormat(), String.valueOf(UserInfo.getTimeZone()));
                                        // Comment: User Story 100297: Internal - Enhancement - Format currency field history on PDF
                                    } else if((fieldType == 'DOUBLE' || fieldType == 'INTEGER' || fieldType == 'PERCENT') && historyRecord.get('OldValue') != null){
                                       String formatedNumberVal = AppUtils.getFormattedNumber(Double.valueOf(historyRecord.get('OldValue')),scaleVal,false,fieldType);
                                        historyRec.OldValue = formatedNumberVal;
                                    } else if(fieldType == 'PICKLIST' && historyRecord.get('OldValue') != null){
                                        picklistObjName = picklistObjName.replace('__History','__c');
                                        if(picklistObjName.endsWithIgnoreCase('History')){
                                            picklistObjName = picklistObjName.replace('History','');
                                        }
                                        Schema.DescribeFieldResult dsr = SchemaManager.fetchDescribeFieldResult(picklistObjName,fieldAPIName);
                                        for(Schema.PicklistEntry ple : dsr.getPicklistValues()){
                                            String label = ple.getLabel();
                                            if(ple.getValue() == historyRecord.get('OldValue')+''){
                                                historyRec.OldValue = label;
                                                break;
                                            }
                                        }
                                    } else {
                                        if( historyRecord.get('OldValue') == true ||  historyRecord.get('OldValue') == false){
                                            historyRec.OldValue = historyRecord.get('OldValue')+'';
                                        }else{
                                        String xssOldValue = SFDCEncoder.SFDC_HTMLENCODE((String)historyRecord.get('OldValue'));
                                        historyRec.OldValue = xssOldValue+'';
                                    }
                                }
                            }
                            }
                        if(historyRecord.get('NewValue') == null){
                            historyRec.NewValue = '';
                        }else{
                            if(!String.isEmpty(relationshipName)){    //this block skips the id part for refernce field so put comment here
                                try{
                                    String NewValue = Id.valueOf((String)historyRecord.get('NewValue'));
                                    skipEntry = false;
                                }catch(Exception e){
                                    if(historyRecord.get('NewValue') == true || historyRecord.get('NewValue') == false){
                                        historyRec.NewValue = historyRecord.get('NewValue')+'';
                                    }else{
                                    historyRec.NewValue = SFDCEncoder.SFDC_HTMLENCODE((String)historyRecord.get('NewValue')+'');
                                }
                                }
                            }else{
                                  // This Code is Being Added for Formatting currency fields in Field History for New Value.
                                if(fieldType == 'CURRENCY' && historyRecord.get('NewValue') != null){
                                    string newVal= historyRecord.get('NewValue')+'';
                                    Decimal newValDec = Decimal.valueOf(newVal);
                                    String formatedNewVal = AppUtils.getFormattedNumber(Double.valueOf(newValDec),scaleVal,true,fieldType);
                                    historyRec.NewValue = formatedNewVal;
                                } else if(fieldType == 'DATE' && historyRecord.get('NewValue') != null){
                                    String formateddtNewVal =  Datetime.valueOf(historyRecord.get('NewValue')+'').format(AppUtils.getUserDateFormat());
                                    historyRec.NewValue = formateddtNewVal;
                                } else if(fieldType == 'DATETIME' && historyRecord.get('NewValue') != null){
                                     DateTime formateddtimeNewVal = Datetime.valueOf(historyRecord.get('NewValue'));
                                    historyRec.NewValue = formateddtimeNewVal.format(AppUtils.getUserDateTimeFormat(), String.valueOf(UserInfo.getTimeZone()));
                                    // Comment: User Story 100297: Internal - Enhancement - Format currency field history on PDF
                                }   else if((fieldType == 'DOUBLE' || fieldType == 'INTEGER' || fieldType == 'PERCENT') && historyRecord.get('NewValue') != null){
                                    String formatedNumberVal = AppUtils.getFormattedNumber(Double.valueOf(historyRecord.get('NewValue')),scaleVal,false,fieldType);
                                    historyRec.NewValue = formatedNumberVal;
                                } else if(fieldType == 'PICKLIST' && historyRecord.get('NewValue') != null){
                                       picklistObjName = (String.isNotBlank(picklistObjName) && picklistObjName.contains('__History'))?picklistObjName.replace('__History','__c'):picklistObjName;
                                       picklistObjName = picklistObjName.replace('__History','__c');
                                       if(picklistObjName.endsWithIgnoreCase('History')){
                                            picklistObjName = picklistObjName.replace('History','');
                                        }
                                       Schema.DescribeFieldResult dsr = SchemaManager.fetchDescribeFieldResult(picklistObjName,fieldAPIName);
                                    for(Schema.PicklistEntry ple : dsr.getPicklistValues()){
                                        String label = ple.getLabel();
                                        if(ple.getValue() == historyRecord.get('NewValue')+''){
                                            historyRec.NewValue = label;
                                            break;
                                        }
                                    }
                                } else {
                                    if(historyRecord.get('NewValue') == true || historyRecord.get('NewValue') == false){                                       
                                        historyRec.NewValue = historyRecord.get('NewValue')+'';
                                    }else{
                                    String xssNewValue = SFDCEncoder.SFDC_HTMLENCODE((String)historyRecord.get('NewValue'));
                                    historyRec.NewValue = xssNewValue+'';
                                }
                                    
                                }
                            }
                        }
                        //Added by : Shantanu
                        //Purpose : Date is appended with 00:00:00 so to remove the time value.
                        if(fieldType == 'DATE' ){
                            if(historyRec.NewValue != null){
                                String newValue = historyRec.NewValue+'';
                                newValue = newValue.replace('00:00:00','');
                                historyRec.NewValue = newValue;
                            }if(historyRec.OldValue != null){
                                String oldValue = historyRec.OldValue+'';
                                oldValue = oldValue.replace('00:00:00','');
                                historyRec.OldValue = oldValue;
                            }
                        }
                        historyRec.CreatedBy = historyRecord.getSobject('CreatedBy');
                        
                        historyRec.CreatedDate = (DateTime)historyRecord.get('CreatedDate');
                         // Check if ownerId is 15/18 digits, do not add such records.
                         //if(fieldAPIName.equalsignorecase('OwnerId')  && (historyRec.OldValue.startsWith('00G') || historyRec.OldValue.startsWith('005' ))){
                           //do not do anything
                         //} else 
                        if(!skipEntry && (String.isNotEmpty(historyRec.NewValue) || String.isNotEmpty(historyRec.OldValue))){
                            updatedRecords.add(historyRec);
                        }
                    }
                }
            }                                       
        return updatedRecords;
    }
    
    /*
        Method  :    getHistroyExportRecordsList()
        Purpose :    This mehtod to handle history records during exporting   
    */
    
    public List<sObject> getHistroyExportRecordsList(List<sObject> histroryRecordList,String objName){
        List<sObject> finalFilterHistoryList = new List<sObject>();
        Map<Id,sObject> recordsMap = new Map<Id,sObject>();

        if(histroryRecordList.size() > 0){
            for(sObject sobjRec : histroryRecordList){
                recordsMap.put(sobjRec.Id, sobjRec);
            }
        }

        List<HistoryClass> handleHistorylist = handleHistoryRecords(histroryRecordList, objName);

        if(handleHistorylist.size() > 0){
            for(HistoryClass histVal:handleHistorylist){
                sObject histSobjRec = recordsMap.get(histVal.Idval);
                finalFilterHistoryList.add(histSobjRec);
            }
        }
        return finalFilterHistoryList;
    }
    /*
    Method  :   handleStandardSetControllers ()
    Purpose :   This method handles fetching of records which are  supported by Standard set controllers e.g Any custom object.    
    */
    public Map<String, Object> handleStandardSetControllers(String query, String queryColumns, String hideDecisionFields, Integer pageNumber, Integer pageSize, String filterClause, String sortBy, String sortDir, String objectName) {
    
        Map<String, Object> retVal = new Map<String, Object>();
        List<sobject> records = new List<sobject>();
        if(!query.contains(' limit ')) {
            query = query + ' limit 10000 ';
        }
        if(AppUtils.isObjectAccessible(objectName)){   //CRUD/FLS False +ve with the help of AppUtils we have performed check
            setCon = new ApexPages.StandardSetController(Database.query(query,AccessLevel.USER_MODE));  //SOQL Injection - False +ve - Dynamic part of query string is escapeSingleQuotes
        }
        /* Max 2k can be fetched per batch - this can be set to 1 to test with few records! */ 
        setCon.setPageSize(pageSize); 
        /*Default is page 1  */
        
        setCon.setPageNumber(pageNumber); 
        Integer resultSize = setCon.getResultSize();
        Integer max_pages = (Integer)Math.ceil((Double)resultSize/pageSize);
        records = setCon.getRecords();
        if(max_pages == 0) {
            pageNumber = 0;
        } 
        /* Populate the map with objects that must be returned back */
        /* Some of these values are returned to stay in sync */        
        retVal.put('QueryColumns',queryColumns );
        retVal.put('HideDecisionFields',hideDecisionFields );
        if(filterClause == null || filterClause == 'undefined'){
            filterClause = '';    
        }
        Timezone tz = UserInfo.getTimezone();
        DateTime now = DateTime.now();
        Integer offset = tz.getOffset(System.now());
        retVal.put('Offset',offset);
        retVal.put('FilterClause',filterClause);  
        retVal.put('SortColumn',sortBy); 
        retVal.put('SortDir',sortDir);  
        retVal.put('ObjectName',objectName);
        retVal.put('TotalPages',max_pages);
        retVal.put('RecordsList',records);        
        retVal.put('PageSize', pageSize); // PageSize - Page information must be returned to keep list in sync
        retVal.put('PageNumber', pageNumber); // PageNumber that is to be returned
        retVal.put('ResultSize', resultSize); // ResultSetSize - as in setcontroller
        retVal.put('HasNext', setCon.getHasNext());
        retVal.put('HasPrevious', setCon.getHasPrevious()); 
        return retVal;
    } 
    
    /*
    Method  :   getReportFolderId ()
    Purpose :   This method get the folder id for selected app in custom setting.    
    */ 
    public List<Id> getReportFolderId(){  
        //Id folderId;
        List<ID> folderIdList = new List<ID>();
        String appName = UserPreferenceHelper.getStringValue('ActiveAppName__c'); 
        UserPreferences__c userPref = UserPreferences__c.getInstance();
        String repFolderString = String.valueOf(userPref.ReportsFolderName__c); 
        List<String> lstReportFolder = repFolderString.split(';');
        String folderType = 'Report';
        String fQuery = 'SELECT Id From Folder WHERE Type =:folderType AND DeveloperName IN :lstReportFolder';
        try{
            List<Folder> reportFolder = new List<Folder>();
                reportFolder = Database.query(String.escapeSingleQuotes(fQuery),AccessLevel.USER_MODE);//SOQL Injection - False +ve - Dynamic part of query string is escapeSingleQuotes //CRUD/FLS False +ve As per business scenario we can't check for portal/external users
            if(reportFolder != null && reportFolder.size() > 0){
                for(Folder f : reportFolder){
                    folderIdList.add(f.id);
                }
            }           
        }catch(Exception e) {                 
        }   
        return folderIdList;        
    }
    
    /*
    Method  :   handleSOSLFlexTables ()
    Purpose :   This method handles the creation of flex tables that use SOSL.
    */
    public Map<String, Object> handleSOSLFlexTables(String queryColumns,String hideDecisionFields, String objectName, Integer pageNumber, Integer pageSize,String sortBy, String sortDir,String searchTerm,String filterClause){
        Map<String, Object> retVal = new Map<String, Object>();
        Set<String> queryColumnsSet = new Set<String>();
        //Added all fields in querycolumns that is displayed fields in set.
        queryColumnsSet.addAll(queryColumns.deleteWhitespace().split(','));
        //If object is custom or account and  if Name field is not added in lookupfield displayed names then by default name is also passed in query.
        if(objectName.endsWith('__c') || objectName =='Account') {
            queryColumnsSet.add('name'); 
        }
        Set<String> trimmedQueryColumnsSet = new Set<String>();
        for(String columns :queryColumnsSet){
            if(columns !=''){
                trimmedQueryColumnsSet.add(columns.trim().toLowerCase());
            }
        }
        List<sobject> records = new List<sobject>();
        String searchquery;
        if(searchTerm == 'ALL' || searchTerm == '*.*' || searchTerm == '*'){
            searchTerm = '* OR *';
        }
        Pattern stringPattern = Pattern.compile('[A-Za-z0-9]{1}[\\*]{1}');
        if(searchTerm.length () == 2 && stringPattern.matcher(searchTerm).matches()){
                String searchString = searchTerm.splitByCharacterType()[0];
                searchTerm = searchString + ' OR ' + searchString; 
        }
        if(String.isBlank(sortDir)) {
            sortDir = ' ASC ';
        }
        if(searchTerm != null && searchTerm.length()>0){
            searchTerm = String.escapeSingleQuotes(searchTerm);
        }
        //String recordType='Test';
        if(!String.isEmpty(recordType) && recordType != ''){
            String[] recordTypes = recordType.split(',');
            String formatedRecordType='';
            for(String rcrdType:recordTypes){
                formatedRecordType +='\''+rcrdType+'\',';
            }
            recordType = formatedRecordType.removeEnd(',');
            if(!String.isEmpty(filterClause) && filterClause != null) {
                filterClause += ' AND RecordType.Name IN ('+String.escapeSingleQuotes(recordType)+')';
            }
            else {
                filterClause = ' RecordType.Name IN ('+String.escapeSingleQuotes(recordType)+')';
            }
        }

        String filterClause1 = filterClause;
        List<DND__mdt> lstConfigs = [SELECT Id, sObjectName__c, FilterCriteria__c, DNDCriteria__c FROM DND__mdt WHERE sObjectName__c =:objectName WITH USER_MODE LIMIT 1 ];
        String userFieldValue;
        if(lstConfigs.size() > 0 && lstConfigs[0].DNDCriteria__c != null && lstConfigs[0].FilterCriteria__c != null){
            Map<String,String> filterCriteriaMap = (Map<String,String>)JSON.deserialize(SFDCEncoder.sanitizeJSON(lstConfigs[0].FilterCriteria__c), Map<String,String>.class); // false+ve for Deserializing objects from an untrusted source is security-sensitive as sanitizing it by using SFDCEncoder.sanitizeJSON
            String userField = filterCriteriaMap.get('userField');
            String objectField = filterCriteriaMap.get('objectField');
            String operator = filterCriteriaMap.get('operator');
            String currentUser = userinfo.getuserid();
            userFieldValue = String.valueOf(Database.query('SELECT id,Name, '+String.escapeSingleQuotes(userField)+' FROM USER WHERE id=:currentUser',AccessLevel.USER_MODE)[0].get(userField));//SOQL Injection - False +ve - Dynamic part of query string is escapeSingleQuotes //CRUD/FLS False +ve As per business scenario we can't check for portal/external users
            if(userFieldValue != null && userFieldValue != ''){
               List<String> possibleUserValuesLst = userFieldValue.split(';');// need to add check for userFieldValue
                operator = operator.toUpperCase().trim();
    
                Map<String, String> operatorMap1 = new Map<String, String>();
                operatorMap1.put('CONTAINS',' = ');
                operatorMap1.put('NOTCONTAINS',' != ');
                operatorMap1.put('==',' = ');
                operatorMap1.put('!=',' != ');
    
                Map<String, String> operatorMap2 = new Map<String, String>();
                operatorMap2.put('CONTAINS',' != ');
                operatorMap2.put('NOTCONTAINS',' = ');
                operatorMap2.put('==',' != ');
                operatorMap2.put('!=',' = ');
    
                String dndCriteria = lstConfigs[0].DNDCriteria__c;
                while(dndCriteria.contains('{!searchVal}')){
                    dndCriteria = dndCriteria.replace('{!searchVal}', searchTerm);
                }
    
                String whereClause1 = '';
                String whereClause2 = '';
                if(possibleUserValuesLst.size() > 0){
                    if(operator == '==' || operator == 'CONTAINS'){
                        whereClause1 += ' (';
                        whereClause2 += ' ';
                        for(String str: possibleUserValuesLst){
                            whereClause1 += objectField + operatorMap1.get(operator) + ' \'' +str+'\' OR ' ;
        
                            //whereClause2 += ' (';AND '+dndCriteria +' )
                            whereClause2 += objectField + operatorMap2.get(operator) + ' \'' +str+'\'   AND ' ;
                            //whereClause2 = objectField + operatorMap2.get(operator) +userFieldValue ;
                        }
                        whereClause1 = whereClause1.removeEnd('OR ');
                        whereClause2 = whereClause2.removeEnd('AND ');
                        whereClause1 += ') ';
                        whereClause2 += ' AND '+objectField + ' != null AND '+dndCriteria;
                    }else{
                        whereClause2 += ' (';
                        for(String str: possibleUserValuesLst){
                            whereClause1 += objectField + operatorMap1.get(operator) + ' \'' +str+'\' AND ' ;
                            whereClause2 += objectField + operatorMap2.get(operator) + ' \'' +str+'\'   OR ' ;
                        }
                        whereClause1 = whereClause1.removeEnd('AND ');
                        whereClause2 = whereClause2.removeEnd('OR ');
                        whereClause2 += ') ';
                        whereClause2 += ' AND '+objectField + ' != null AND '+dndCriteria;
                    }
                 }
                 //else{
                //     userFieldValue = ' \'' + possibleUserValuesLst[0] + '\' ';
                //     whereClause1 = objectField + operatorMap1.get(operator) +userFieldValue ;
                //     whereClause2 = objectField + operatorMap2.get(operator) +userFieldValue + '  AND '+objectField + ' != null AND '+dndCriteria;
                // }
    
    
                if(!String.isEmpty(filterClause) && filterClause != 'undefined' && !String.isEmpty(whereClause1) && !String.isEmpty(whereClause2)){
                    filterClause += ' AND ' + whereClause1;
                    filterClause1 += ' AND ' + whereClause2;
                }else{
                    filterClause = whereClause1;
                    filterClause1 = whereClause2;
                }
            }
        }

        searchquery = 'FIND \''+String.escapeSingleQuotes(searchTerm)+'*\' IN ALL FIELDS RETURNING '+ String.escapeSingleQuotes(objectName) +'('+ AppUtils.concatenate(trimmedQueryColumnsSet, ', ') ;
        String searchquery1 = 'FIND \''+String.escapeSingleQuotes(searchTerm)+'*\' IN ALL FIELDS RETURNING '+ String.escapeSingleQuotes(objectName) +'('+ AppUtils.concatenate(trimmedQueryColumnsSet, ', ') ;
        
        if(!String.isEmpty(filterClause) && filterClause != 'undefined'){
            searchquery += ' WHERE '+ AppUtils.parseWhereClause(filterClause); //SOQL Injection - False +ve - Using AppUtils.parseWhereClause method to applying escapeSingleQuotes to each value of filterClause clause
            searchquery1 += ' WHERE '+AppUtils.parseWhereClause(filterClause1); //SOQL Injection - False +ve - Using AppUtils.parseWhereClause method to applying escapeSingleQuotes to each value of filterClause clause
        }
        if(String.isNotBlank(sortBy)) {
            searchquery += ' ORDER BY ' + sortBy + ' '+ String.escapeSingleQuotes(sortDir) ;
            searchquery1 += ' ORDER BY ' + sortBy + ' '+ String.escapeSingleQuotes(sortDir) ;
        }
        searchquery += ')';
        searchquery1 += ')';

    

        List<List<sobject>> searchList = search.query(searchquery,AccessLevel.USER_MODE);//SOQL/SOSL Injection - False +ve - Dynamic part of query string is escapeSingleQuotes,Using AppUtils.parseWhereClause method to applying escapeSingleQuotes to each value of filterClause
        Sobject [] objectList = ((List<Sobject>)searchList[0]);

        if(lstConfigs.size() > 0 && lstConfigs[0].DNDCriteria__c != null && userFieldValue != null && searchquery != searchquery1){
            List<List<sobject>> searchList1 = search.query(searchquery1,AccessLevel.USER_MODE);//SOQL/SOSL Injection - False +ve - Dynamic part of query string is escapeSingleQuotes,Using AppUtils.parseWhereClause method to applying escapeSingleQuotes to each value of filterClause
            Sobject [] objectList1 = ((List<Sobject>)searchList1[0]);            
            objectList.addAll(objectList1);
        }

        try{
            setCon = new ApexPages.StandardSetController(objectList);
            // Check for Nullablity...
            if(pageSize !=null && pageNumber !=null){
            setCon.setPageSize(pageSize); 
            
            setCon.setPageNumber(pageNumber); 
            }
            
            Integer resultSize = setCon.getResultSize();
            Integer max_pages;
            if(pageSize != 0){
                max_pages = (Integer)Math.ceil((Double)resultSize/pageSize);
            }
            
            records = setCon.getRecords();              
    
            if(max_pages == 0){
                pageNumber = 0;
            } 
            /* Populate the map with objects that must be returned back */
            /* Some of these values are returned to stay in sync */        
            retVal.put('QueryColumns',queryColumns );
            retVal.put('HideDecisionFields',hideDecisionFields );
            if(filterClause == null){
                filterClause = '';    
            }                                 
            retVal.put('TotalPages',max_pages);
            retVal.put('ResultSize', resultSize);
            retVal.put('HasNext', setCon.getHasNext());
            retVal.put('HasPrevious', setCon.getHasPrevious());                                 
            retVal.put('FilterClause',filterClause);  
            retVal.put('SortColumn',sortBy); 
            retVal.put('SortDir',sortDir);  
            retVal.put('ObjectName',objectName);
            retVal.put('PageSize',pageSize);
            retVal.put('PageNumber', pageNumber);           
            retVal.put('RecordsList',records);     
            retVal.put('isSOSL', true);
        }catch(Exception e) {    
            retVal.put('ErrorMessages','Error: '+ Apputils.handleSystemExceptionMsg(e)+','+e.getLineNumber());                     
        }
        return retVal;  
    }
    public Map<String, Object> handleSOSLStandardListControllers(String queryColumns,String hideDecisionFields, String objectName, Integer pageNumber, Integer pageSize,String sortBy, String sortDir,String searchTerm,String filterClause) {
        Map<String, Object> retVal = new Map<String, Object>();
        List<sobject> records = new List<sobject>();
        Set<String> queryColumnsSet = new Set<String>();
        queryColumnsSet.addAll(queryColumns.deleteWhitespace().split(','));
        Set<String> trimmedQueryColumnsSet = new Set<String>();
        for(String columns :queryColumnsSet){
            if(columns !=''){
                trimmedQueryColumnsSet.add(String.escapeSingleQuotes(columns.trim().toLowerCase()));
            }
        }
        String searchquery;
        if (String.isNotBlank(sortBy)) {
            if(!String.isEmpty(filterClause) && filterClause != 'undefined'){
                 searchquery = 'FIND \''+String.escapeSingleQuotes(searchTerm)+'*\' IN ALL FIELDS RETURNING '+ String.escapeSingleQuotes(objectName) +'('+ AppUtils.concatenate(trimmedQueryColumnsSet, ', ') 
                                   +' WHERE '+ AppUtils.parseWhereClause(filterClause)  +' ORDER BY ' + string.valueOf(sortBy) + ' '+ string.valueOf(sortDir) ;
            }else{
                 searchquery = 'FIND \''+String.escapeSingleQuotes(searchTerm)+'*\' IN ALL FIELDS RETURNING '+ String.escapeSingleQuotes(objectName) +'('+ AppUtils.concatenate(trimmedQueryColumnsSet, ', ')
                                    +' ORDER BY ' + string.valueOf(sortBy) + ' '+ string.valueOf(sortDir);
            }
        } else {
            if(!String.isEmpty(filterClause) && filterClause != 'undefined'){
                searchquery = 'FIND \''+String.escapeSingleQuotes(searchTerm)+'*\' IN ALL FIELDS RETURNING '+ String.escapeSingleQuotes(objectName) +'('+ AppUtils.concatenate(trimmedQueryColumnsSet, ', ') 
                                   +' WHERE '+ AppUtils.parseWhereClause(filterClause); 
            }else{
                searchquery = 'FIND \''+String.escapeSingleQuotes(searchTerm)+'*\' IN ALL FIELDS RETURNING '+ String.escapeSingleQuotes(objectName) +'('+ AppUtils.concatenate(trimmedQueryColumnsSet, ', ');
            }
        }
        
        Integer resultSize = 0;

        String countQuery = searchquery + ')';
        List<List<sobject>> searchList = search.query(countQuery,AccessLevel.USER_MODE);//SOQL/SOSL Injection - False +ve - Dynamic part of query string is escapeSingleQuotes,Using AppUtils.parseWhereClause method to applying escapeSingleQuotes to each value of filterClause
        records = ((List<Sobject>)searchList[0]); 

        resultSize = records.size();
        
        Integer offset = (pageNumber-1)*pageSize;
        if(offset >= 0 && offset <= 2000) { 
            searchquery += ' LIMIT ' + Integer.valueOf(pageSize);
            searchquery += ' OFFSET ' + Integer.valueOf(offset) + ')';
        } else {
            searchquery += ')';
        }
        
         searchList = search.query(searchquery,AccessLevel.USER_MODE);//SOQL/SOSL Injection - False +ve - Dynamic part of query string is escapeSingleQuotes,Using AppUtils.parseWhereClause method to applying escapeSingleQuotes to each value of filterClause
        records = ((List<Sobject>)searchList[0]); 

       
        Integer max_pages = (Integer)Math.ceil((double)resultSize/pageSize);
        if(max_pages == 0){
            pageNumber = 0;
        }
        if(objectName.indexOf('History') != -1){//This means that the sobject is a history object
            List<HistoryClass> history = handleHistoryRecords(records,objectName);
            //Replace Id values with its names.
            history = replaceIdValues(history);
            retVal.put('RecordsList',history);
            retVal.put('ResultSize',resultSize);            
        }else{
            retVal.put('RecordsList',records);
            retVal.put('ResultSize', resultSize); // ResultSetSize - as in setcontroller            
        } 
        
        retVal.put('QueryColumns',queryColumns );
        retVal.put('HideDecisionFields',hideDecisionFields );
        if(filterClause == null){
            filterClause = '';    
        }
        retVal.put('FilterClause',filterClause);  
        retVal.put('SortColumn',sortBy); 
        retVal.put('SortDir',sortDir);  
        retVal.put('ObjectName',objectName);           
        
        Boolean hasNext = pageNumber == max_pages ? false:true;
        boolean hasPrev = pageNumber == 1?false:true;
        retVal.put('HasPrevious',hasPrev);   
        retVal.put('HasNext',hasNext); 
        retVal.put('TotalPages',max_pages); 
        retVal.put('PageSize', pageSize); 
        retVal.put('PageNumber', pageNumber); 
        
        return retVal;
    }
    /*
    Method  :   getObjectMetadata()
    Purpose :   Get the object meta data for which table is constructed.
    */
    private Map<String,Object> getObjectMetadata(Schema.DescribeSObjectResult dataTableObjectResult, String columnNames){
        /* Create a map object to be returned */
        Map<String, Object> retVal= new Map<String, Object>();
        retVal.put('APIName', dataTableObjectResult.getName()+'');
        retVal.put('LabelPlural', dataTableObjectResult.getLabelPlural()+'');
        retVal.put('IsDeletable', (AppUtils.isSkipPermissionCheck() || dataTableObjectResult.isDeletable())+'');// User Story 127005: Internal - Spring'21 release - View All, Modify All, Edit, and Delete Object Permissions Removed for Guest Users - Part 2
        retVal.put('IsCreateable', dataTableObjectResult.isCreateable()+'');
        retVal.put('IsUpdateable', dataTableObjectResult.isUpdateable()+'');
        
        Map<String,Schema.SObjectField> fieldsMap = dataTableObjectResult.fields.getMap();
        Map<String, Object> fieldMetaDataMap = new Map<String, Object>();         
        
        for(String fieldName : fieldsMap.keySet()){ 
            if(!columnNames.containsIgnoreCase(fieldName)){
                Schema.SObjectField field = fieldsMap.get(fieldName);
                Schema.DescribeFieldResult fieldDescribe = field.getDescribe();
                if(!fieldDescribe.isNillable() && fieldDescribe.getCalculatedFormula() == null && !fieldDescribe.isDefaultedOnCreate() ){
                    Map<String, Object> fieldMetaData = new Map<String,Object>();  
                    fieldMetaData.put('Name',fieldDescribe.getName()+'');
                    fieldMetaData.put('Label',fieldDescribe.getLabel()+'');
                    fieldMetaData.put('IsUpdateable',fieldDescribe.isUpdateable()+'');
                    fieldMetaData.put('IsFilterable',fieldDescribe.isFilterable());        
                    fieldMetaData.put('Type',fieldDescribe.getType()+'');
                    fieldMetaData.put('DefaultValue',fieldDescribe.getDefaultValue()+'');
                    fieldMetaData.put('IsNillable',fieldDescribe.isNillable());
                    fieldMetaData.put('IsCreateable',fieldDescribe.isCreateable());
                    fieldMetaData.put('CalculatedFormula',fieldDescribe.getCalculatedFormula());
                    fieldMetaDataMap.put(fieldDescribe.getName() + '',fieldMetaData);    
                }
            } 
            
        }
        retVal.put('RequiredFields', fieldMetaDataMap);
        return retVal;
    }
    
    /*
    Method  :   getConfigInfo()
    Purpose :   This method creates configuration info specified in the Flex Table config record.
    */
    private Map<String,Object> getConfigInfo(List<DataTableConfig__c> dataTableConfigObjLst){
        /* Create a map object to be returned */ 
        Map<String, Object> finalResultMap = new Map<String, Object>();
        if(dataTableConfigObjLst != null && dataTableConfigObjLst.size() > 0){
            for(DataTableConfig__c dataTableConfigObj: dataTableConfigObjLst){
        Map<String, Object> retVal= new Map<String, Object>();
        retVal.put('Name', dataTableConfigObj.Name +'');
        retVal.put('Header', dataTableConfigObj.Header__c+'');
        retVal.put('HeaderDescription', (!String.isEmpty(dataTableConfigObj.HeaderDescription__c) ? dataTableConfigObj.HeaderDescription__c : ''));
        retVal.put('ActionDisplayType', dataTableConfigObj.ActionDisplayType__c+'');
        retVal.put('Help', dataTableConfigObj.HelpConfig__c+'');
        retVal.put('IsHelpDownloadable', false+'');
        if(dataTableConfigObj.HelpConfig__c != null && isHelpDownloadable(dataTableConfigObj.HelpConfig__c)){
            retVal.put('IsHelpDownloadable', true+'');
            retVal.put('HelpDocId', docId+'');
        }
        
        Map<String,Object> readOnlyFieldsMap = new Map<String,Object>();
        if(dataTableConfigObj.ReadOnlyFields__c != null){
            String readOnlyFields = dataTableConfigObj.ReadOnlyFields__c;
            readOnlyFields = readOnlyFields.trim();
            List<String> readOnlyFieldsList = readOnlyFields.split(',');
            
            for(String readOnlyField: readOnlyFieldsList){
                readOnlyFieldsMap.put(readOnlyField,true);    
            }        
        }
        retVal.put('ReadOnlyFieldsMap', readOnlyFieldsMap);
        
        Map<String,Object> requiredFieldsMap = new Map<String,Object>();
        if(dataTableConfigObj.RequiredFields__c != null){
            String requiredFields = dataTableConfigObj.RequiredFields__c;
            requiredFields = requiredFields.trim();
            List<String> requiredFieldsList = requiredFields.split(',');
            
            for(String requiredField: requiredFieldsList){
                requiredFieldsMap.put(requiredField,true);    
            }        
        }
        retVal.put('EnableDataImportExport', dataTableConfigObj.EnableDataImportExport__c+'');
        boolean searchallFields;
        if(KeyValueStoreHelper.getBooleanValue('FlextableEnableSearchAllFields',true) != null){
            searchallFields = KeyValueStoreHelper.getBooleanValue('FlextableEnableSearchAllFields',true);
    
        }else{
            searchallFields = false;   
        }
        retVal.put('RequiredFieldsMap', requiredFieldsMap); 
        retVal.put('SubTotalEvaluatorJSON', dataTableConfigObj.SubTotalEvaluatorJSON__c + '');
        retVal.put('MassEditableGridConfigJSON', dataTableConfigObj.MassEditableGridConfigJSON__c + '');
        retVal.put('EnableQuickSearch', dataTableConfigObj.EnableQuickSearch__c+'');
        retVal.put('SearchAllFields', searchallFields +'');
        retVal.put('QuickSearchBehaviour', dataTableConfigObj.QuickSearchBehaviour__c+'');        
        retVal.put('EnableExport', dataTableConfigObj.EnableExport__c+'');
        retVal.put('EnableExportXLS', dataTableConfigObj.EnableExportXls__c+'');
        retVal.put('EnableAutoIndex', dataTableConfigObj.EnableAutoIndex__c+'');
        retVal.put('EnableRecordSelection',dataTableConfigObj.EnableRecordSelection__c+'');
        retVal.put('EnableHelp', dataTableConfigObj.EnableHelp__c+'');
        retVal.put('ParentTargetLookupField', dataTableConfigObj.ParentTargetLookupField__c+'');
        retVal.put('EnableIndexBar', dataTableConfigObj.EnableIndexBar__c+'');
        retVal.put('EnableFilter', dataTableConfigObj.EnableFilter__c+'');  
        retVal.put('DisableMenu', dataTableConfigObj.DisableMenu__c+''); 
        retVal.put('subHeaderDescription', dataTableConfigObj.SubHeaderText__c); 
        retVal.put('EnablePageSize', dataTableConfigObj.EnablePageSize__c+'');
        retVal.put('EnablePagination', dataTableConfigObj.EnablePagination__c+'');
        retVal.put('EnableTotalRecordsCount', dataTableConfigObj.EnableTotalRecordsCount__c+'');
        retVal.put('HideDecisionForRecordSelection', dataTableConfigObj.HideRecordSelectionDecisionField__c+'');
        retVal.put('FlexTableRecordName',dataTableConfigObj.Name+'');
        retVal.put('FlexTableRecordId', dataTableConfigObj.Id+'');
        retVal.put('RecordSelectionHeader', dataTableConfigObj.RecordSelectionColumnHeader__c+'');
        retVal.put('RecordSelectionPosition', dataTableConfigObj.RecordSelectionColumnPosition__c+'');
        retVal.put('PageSizes', KeyValueStoreHelper.getTextValue('FlexTablePageSizeOptions',true)+'');
        retVal.put('DefaultPageSize', (dataTableConfigObj.DefaultPageSize__c == null ? KeyValueStoreHelper.getIntegerValue('FlexTableDefaultPageSize',true) : dataTableConfigObj.DefaultPageSize__c) +'');
        retVal.put('MaxRecordsCount', KeyValueStoreHelper.getIntegerValue('FlexTableMaxRecordsCount',true)+'');
        
        Boolean modifyFlexTableMetadata = false;
        modifyFlexTableMetadata = GlobalConfigHelper.getEnableAdminSetup() ;
        if(modifyFlexTableMetadata == null){
            modifyFlexTableMetadata = false;
        }
        retVal.put('ModifyFlexTableMetadata',modifyFlexTableMetadata+'');
                finalResultMap.putAll(retVal);
        }
        }
        return finalResultMap;
    }
    
    private Id docId{get;set;}
    private Boolean isHelpDownloadable(Id helpConfigId){
        List<HelpConfig__c> helpList = new List<HelpConfig__c>();
        if(Schema.sObjectType.HelpConfig__c.isAccessible()){
            helpList = [SELECT id, DocumentName__c, RecordType.DeveloperName FROM HelpConfig__c WHERE id = :helpConfigId WITH USER_MODE Limit 1];
        }
        if(helpList != null && helpList.size() > 0){
            if(helpList[0].RecordType.DeveloperName == 'InternalDocument'){
                if(helpList[0].DocumentName__c != null){
                    List<Document> doc = [SELECT id From Document WHERE DeveloperName = : helpList[0].DocumentName__c WITH USER_MODE];//CRUD/FLS False +ve As per business scenario we can't check for portal/external users
                    if(doc != null && doc.size() > 0){
                        docId = doc[0].id;
                    }
                }
                return true;
            }
        }
        return false;
    }
    
    /*
    Method  :   getActionInfo()
    Purpose :    This method creates configuration info specified in the Flex Table Action config records.
    */
    public Map<String,Object> getActionInfo(List<DataTableAction__c> dataTableActionsList,Map<String,Object> mergeFieldsKeyValueMap){
        String hideButton = 'false';
        Boolean isRowlevelActionExist = false;
        Map<String, Object> retVal= new Map<String, Object>();
        Map<String, Object> actionInfoMap = new Map<String,Object>();
        Map<String, Object> actionInfo = new Map<String,Object>(); 
        Map<String,String> hideExpResultForTopButtonsMap = new Map<String,String>();
        Set<String> hideDecisionFieldsSet = new Set<String>();
        Boolean isInternalUser = AppUtils.isInternalUser();
        Boolean isApplicant = AppUtils.isApplicant();
        String userProfile = AppUtils.getProfileInfo();
        String userRole = AppUtils.getRoleInfo();
        Map<String,Boolean> hideDecisionFieldValueMap = new Map<String,Boolean>();
        hideDecisionFieldValueMap = fetchHideDecisionValueMap( dataTableActionsList, mergeFieldsKeyValueMap, hideExpResultForTopButtonsMap);
        Boolean isViewLayout = true;
        if(mergeFieldsKeyValueMap != null && mergeFieldsKeyValueMap.get('mode') == 'Edit' ){
            isViewLayout = false;
        }
        for(DataTableAction__c da: dataTableActionsList){
             if(hideExpResultForTopButtonsMap.get(String.valueOf(da.Id)) == 'null' || hideExpResultForTopButtonsMap.get(String.valueOf(da.Id)) == null){   
                if(da.Location__c != null && da.Location__c.equalsIgnoreCase('top')){
                    if(!String.isEmpty(da.SobjectActionConfig__c)){
                        if(!String.isEmpty(da.SobjectActionConfig__r.HideDecisionField__c)){                                 
                            hideButton = evaluateHideDecisionField( da.SobjectActionConfig__r.HideDecisionField__c, hideDecisionFieldValueMap, mergeFieldsKeyValueMap);                                            
                        }   
                    }
                    else{
                        if(!String.isEmpty(da.HideDecisionField__c)){                    
                            hideButton = evaluateHideDecisionField( da.HideDecisionField__c, hideDecisionFieldValueMap, mergeFieldsKeyValueMap);   
                        }
                    }
                }
            }

            String actionURL;
            if(da.ActionURLLong__c !=null){
                actionURL = da.ActionURLLong__c;
            }else{
                 actionURL = da.ActionURL__c;
            }
             
            if(actionURL != null && actionURL != ''){                                                                
                if(mergeFieldsKeyValueMap != null){
                    for(String key:mergeFieldsKeyValueMap.keySet()){                        
                        String mergeKeyVal = '{!'+key+'}';
                        String mergeKeyValForReport = '15DIGITID({!'+key+'})';                                              
                        if(actionURL.contains(mergeKeyValForReport)){                            
                            String value = (String)mergeFieldsKeyValueMap.get(key);                                
                            actionURL = actionURL.replace(mergeKeyValForReport,String.escapeSingleQuotes(value.subString(0,15)+''));                                        
                        } 
                        else if(actionURL.contains(mergeKeyVal)){                            
                            String value = (String)mergeFieldsKeyValueMap.get(key);                                
                            actionURL = actionURL.replace(mergeKeyVal,String.escapeSingleQuotes(value+''));                                        
                        }                        
                    }
                }                
            }
            if(da.ConfirmationMessage__c == null){
                da.ConfirmationMessage__c =' ';
            }
            actionInfo = new Map<String,Object>(); 
            actionInfo.put('HideExpJSON',String.isEmpty(da.SobjectActionConfig__c)?da.HideExpressionJSON__c:da.SobjectActionConfig__r.HideExpressionJSON__c);
            actionInfo.put('HideExpFields',String.isEmpty(da.SobjectActionConfig__c)?da.HideExpressionFields__c+'':da.SobjectActionConfig__r.HideExpressionFields__c+'');
            actionInfo.put('HideExpResultForTopButton',hideExpResultForTopButtonsMap.get(String.valueOf(da.Id)));
            actionInfo.put('ActionName',da.Name);
            actionInfo.put('ActionURL',actionURL +''); 
            actionInfo.put('Location',da.Location__c+'');
            actionInfo.put('ShowConfirmationBox',da.ShowConfirmationBox__c);
            actionInfo.put('ConfirmationMessage',da.ConfirmationMessage__c+'');
            actionInfo.put('Sequence',da.Sequence__c+'');
            actionInfo.put('Icon',da.IconCSS__c+'');            
            actionInfo.put('StandardAction',da.StandardAction__c+'');
            actionInfo.put('ActionClass',da.ActionClass__c+'');
            actionInfo.put('ActionBehavior',da.ActionBehavior__c+'');
            actionInfo.put('RefreshBehaviour',da.RefreshBehavior__c+'');
            actionInfo.put('Height',da.ModalHeight__c +'');
            actionInfo.put('Width',da.ModalWidth__c+'');
            actionInfo.put('HeaderActionDisplayType',da.HeaderActionDisplayType__c+'');
            actionInfo.put('ButtonHelpText',da.ButtonHelpText__c+'');
            actionInfo.put('HideDecisionField',String.isEmpty(da.SobjectActionConfig__c)? da.HideDecisionField__c+'':da.SobjectActionConfig__r.HideDecisionField__c+'');
            actionInfo.put('HideForUserType',String.isEmpty(da.SobjectActionConfig__c)?da.HideForUser__c+'':da.SobjectActionConfig__r.HideForUser__c+'');
            actionInfo.put('HideForProfile',String.isEmpty(da.SobjectActionConfig__c)?da.HideForProfile__c+'':da.SobjectActionConfig__r.HideForProfile1__c+'');
            actionInfo.put('ModalTitle',da.ModalTitle__c+'');
            actionInfo.put('DataTableActionObj',da);
            actionInfo.put('DataTableActionId',da.Id);
            actionInfo.put('HideDecisionForTopButtons',hideButton);
            actionInfo.put('RecordType',da.RecordType.Name);
            actionInfo.put('hideInSearch',da.HideInSearch__c);
            actionInfo.put('hideOperator',da.HideOperator__c);
            hideButton = 'false'; 
            actionInfoMap.put(da.Id,actionInfo);
            
            boolean hideAction;
            if(hideExpResultForTopButtonsMap.get(String.valueOf(da.Id)) == 'null' || hideExpResultForTopButtonsMap.get(String.valueOf(da.Id)) == null){
                if(da.SobjectActionConfig__c != null){
                    hideAction = AppUtils.showHideComponent( isViewLayout, isInternalUser, isApplicant, da.SobjectActionConfig__r.HideForProfile1__c, '', da.SobjectActionConfig__r.HideForContext__c, da.SobjectActionConfig__r.HideForUser__c, userProfile,da.SobjectActionConfig__r.HideForRole__c,userRole,da.SobjectActionConfig__r.HideOperator__c);
                }
                else{
                    hideAction = AppUtils.showHideComponent(null, isInternalUser, isApplicant, da.HideForProfile__c, '', null, da.HideForUser__c, userProfile,da.HideForRole__c,userRole,da.HideOperator__c);
                }
            }
            else{
                if(actionInfo.get('HideExpResultForTopButton')!= null && actionInfo.get('HideExpResultForTopButton')!= ''){
                    hideAction = Boolean.valueOf(actionInfo.get('HideExpResultForTopButton'));
                }
            }
            actionInfo.put('hideAction',hideAction+'');
            if(da.Location__c != null && da.Location__c.equalsIgnoreCase('row')){
                isRowlevelActionExist = true;
                if(da.SobjectActionConfig__c != null ){
                    if(da.SobjectActionConfig__r.HideDecisionField__c != null ){
                         hideDecisionFieldsSet.add(da.SobjectActionConfig__r.HideDecisionField__c+'');
                    }                
                }  
                else{
                    if(da.HideDecisionField__c != null ){
                        hideDecisionFieldsSet.add(da.HideDecisionField__c+''); 
                    }
                }
            }
           
            
        }
        retVal.put('ActionInfoMap',actionInfoMap);
        retVal.put('isRowlevelActionExist',isRowlevelActionExist+'');
        String hideDecisionFields = '';
        for(String hideField:hideDecisionFieldsSet){
            hideDecisionFields += ' , ' + hideField;
        }
        retVal.put('HideDecisionFields',hideDecisionFields);
        return retVal;
    }


    private Map<String,Boolean> fetchHideDecisionValueMap( List<DataTableAction__c> dataTableActionsList, Map<String,Object> mergeFieldsKeyValueMap, Map<String,String> hideExpResultForTopButtonsMap){
        Set<String> hideDecisionFieldsList = new Set<String>();
        Set<String> hideExpressionFieldsSet = new Set<String>();
        String query = 'SELECT Id,Name,';
        String fields = '';
        Map<String,Boolean> result = new Map<String,Boolean>();
        

        if(dataTableActionsList.size() > 0){
            for(DataTableAction__c action : dataTableActionsList){
                if(action.Location__c != null){
                    if(action.Location__c.equalsIgnoreCase('top')){
                        if(action.SobjectActionConfig__c != null){
                            if(!String.isEmpty(action.SobjectActionConfig__r.HideExpressionJSON__c)){
                                if(!String.isEmpty(action.SobjectActionConfig__r.HideExpressionFields__c)){
                                    hideExpressionFieldsSet.addAll((action.SobjectActionConfig__r.HideExpressionFields__c).toLowerCase().split(','));
                                }
                            }
                            else{
                                if(!String.isEmpty(action.SobjectActionConfig__r.HideDecisionField__c)){
                                    hideDecisionFieldsList.add((action.SobjectActionConfig__r.HideDecisionField__c).toLowerCase());    
                                }
                            }
                        }else{
                            if(!String.isEmpty(action.HideExpressionJSON__c)){
                                if(!String.isEmpty(action.HideExpressionFields__c)){
                                    hideExpressionFieldsSet.addAll((action.HideExpressionFields__c).toLowerCase().split(','));
                                }
                            }else{
                                if(!String.isEmpty(action.HideDecisionField__c)){
                                    hideDecisionFieldsList.add((action.HideDecisionField__c).toLowerCase());    
                                }
                            }
                        } 
                    }
                }
            }
             
            String parentRecordIdOfFlexTable = mergeFieldsKeyValueMap != null ? String.valueOf(mergeFieldsKeyValueMap.get('parentRecordIdOfFlexTable')) : '';
            String contextOfFlextable = mergeFieldsKeyValueMap != null ? String.valueOf(mergeFieldsKeyValueMap.get('mode')) : '';
            //if(!String.isEmpty(parentRecordIdOfFlexTable)){
                    if(((hideDecisionFieldsList.size() > 0) || (hideExpressionFieldsSet.size() > 0)) && String.isNotEmpty(parentRecordIdOfFlexTable)){
                    String objectName = Id.valueOf(parentRecordIdOfFlexTable).getSObjectType().getDescribe().getName();                    

                    if(hideDecisionFieldsList.size() > 0){
                        for(String field : hideDecisionFieldsList){
                            fields += String.escapeSingleQuotes(field) + ',';
                        }                        
                        }
                        if(hideExpressionFieldsSet.size() > 0){
                            for(String field : hideExpressionFieldsSet){
                                fields += String.escapeSingleQuotes(field) + ',';
                            }    
                        }                       
                        fields = fields.removeEnd(',');

                        query += fields; 

                        query += ' FROM '+String.escapeSingleQuotes(objectName)+' WHERE Id =: parentRecordIdOfFlexTable';

                        if(AppUtils.isObjectAccessible(objectName)) {
                            List<Sobject> parentObj = Database.query(String.escapeSingleQuotes(query),AccessLevel.USER_MODE);//SOQL Injection - False +ve - Dynamic part of query string is escapeSingleQuotes
                            if(parentObj.size() > 0){
                                evaluateHideExpForTopButtons( dataTableActionsList, parentObj[0], hideExpResultForTopButtonsMap, contextOfFlextable);
                                for(String field : hideDecisionFieldsList){
                                    result.put(field.trim(),Boolean.valueOf(parentObj[0].get(field.trim())));
                                }
                            }                
                        }
                    }else{
                        evaluateHideExpForTopButtons( dataTableActionsList, null, hideExpResultForTopButtonsMap, contextOfFlextable); 
                    }
                //}
            }            
        return result;
    }

    private void evaluateHideExpForTopButtons( List<DataTableAction__c> dataTableActionsList, SObject record, Map<String,String> hideExpResultForTopButtonsMap, String contextOfFlextable){
        if(dataTableActionsList.size() > 0){
            List<sObject> recordSobjectList = new List<sObject>();
            if(record != null){
                recordSobjectList.add(record);
            }
            for(DataTableAction__c action : dataTableActionsList){
                hideExpResultForTopButtonsMap.put(action.Id,null);
                if(action.Location__c != null){
                    if(action.Location__c.equalsIgnoreCase('top')){
                        ExpressionJsonEvaluator.recordMap = new Map<String,sObject>();
                        if(action.SobjectActionConfig__c != null){
                            if(String.isNotEmpty(action.SobjectActionConfig__r.HideExpressionJSON__c)){
                                hideExpResultForTopButtonsMap.put(String.valueOf(action.Id),String.valueOf(ExpressionJsonEvaluator.evaluateExpression( action.SobjectActionConfig__r.HideExpressionJSON__c, recordSobjectList, contextOfFlextable)));
                            }
                        }
                        else if(String.isNotEmpty(action.HideExpressionJSON__c)){
                            hideExpResultForTopButtonsMap.put(String.valueOf(action.Id),String.valueOf(ExpressionJsonEvaluator.evaluateExpression( action.HideExpressionJSON__c, recordSobjectList, contextOfFlextable)));
                        }
                    }
                }
            }
        }
    }


    private String evaluateHideDecisionField (String hideDescisionFieldApiName,Map<String,Boolean> hideDecisionFieldValueMap,Map<String,Object> mergeFieldsKeyValueMap){
        if( mergeFieldsKeyValueMap != null ){
            String parentRecordIdOfFlexTable = String.valueOf(mergeFieldsKeyValueMap.get('parentRecordIdOfFlexTable'));
            List<Sobject> parentObjectList = new List<Sobject>();
            if(!String.isEmpty(parentRecordIdOfFlexTable)){
                String result = String.valueOf(hideDecisionFieldValueMap.get(hideDescisionFieldApiName.trim().toLowerCase()));
                return result;
            }else{
                //Shantanu: Dont know the use case of below code.Henc,Keeping in try/catch block. 
                try{
                 String query = 'SELECT Id,Name FROM User WHERE Id =:userInfo.getUserId() AND ';
    
                if(!String.isEmpty(hideDescisionFieldApiName)){
                    query += AppUtils.parseWhereClause(hideDescisionFieldApiName);
                    List<User>  userList = new List<User>();
                    userList = (List<User>) Database.query(query,AccessLevel.USER_MODE);//SOQL Injection - False +ve - Dynamic part of query string is escapeSingleQuotes //CRUD/FLS False +ve As per business scenario we can't check for portal/external users
                    if(userList.size() > 0){
                        return 'true';
                    }else{
                        return 'false';
                    }
                }
                return 'false';
                }catch(Exception e) {
                    throw new CustomExceptions.InputDataException('Invalid Hide DecisionField');                
                }
            }
        }
        return 'false';
    }

    public Map<String,Object> getFieldMetadata(String flexTableId, Schema.SObjectType dataTableObjectType, String objectName, String fieldNames, Map<String,Schema.SObjectField> dataObjectFieldsMap){
        return getFieldMetadata(flexTableId, dataTableObjectType, objectName, fieldNames, dataObjectFieldsMap, true);
    }
    
    private Map<String,Object> getFieldMetadata(String flexTableId, Schema.SObjectType dataTableObjectType, String objectName, String fieldNames, Map<String,Schema.SObjectField> dataObjectFieldsMap, Boolean replaceReferenceWithName) {
        List<DataTableDetailConfig__c> dataTableDetailConfigObjList = new List<DataTableDetailConfig__c>();
        if(Schema.sObjectType.DataTableDetailConfig__c.isAccessible()){
            dataTableDetailConfigObjList = [SELECT EnableTotal__c,EnableRowGrouping__c,SubTotalLabel__c,EscapeHtml__c, FieldAPIName__c, FieldLabelOverride__c,
                                                FieldWidth__c,WhereClause__c,RenderType__c,HelpText__c,DisplayFields__c,ShowLinkAsText__c
                                                FROM DataTableDetailConfig__c
                                                WHERE FlexTableConfig__c=:flexTableId
                                                WITH USER_MODE];
        }
        Map<String, Object> retVal = new Map<String, Object>();
        Map<object,object> dataTableConfigMap = new Map<object,object>();
        
        Map<String, Object> fieldMetaDataMap = new Map<String, Object>(); 
        Map<String, Object> fieldMetaDataForId = new Map<String,Object>(); 
        Schema.DescribeFieldResult fieldDescribeForId = dataObjectFieldsMap.get('id').getDescribe();                       
        fieldMetaDataForId.put('Label',fieldDescribeForId.getLabel()+'');
        //fieldMetaDataForId.put('fieldLength',fieldDescribeForId.getLength());  
        fieldMetaDataForId.put('IsUpdateable',fieldDescribeForId.isUpdateable()+'');        
        fieldMetaDataForId.put('Type',fieldDescribeForId.getType()+'');
        fieldMetaDataForId.put('DefaultValue',fieldDescribeForId.getDefaultValue()+'');
        fieldMetaDataForId.put('IsNillable',fieldDescribeForId.isNillable());
        fieldMetaDataForId.put('IsCreateable',fieldDescribeForId.isCreateable());
        //fieldMetaDataForId.put('DecimalPlaces',fieldDescribeForId.getScale());
        Double scale = fieldDescribeForId.getScale();
        fieldMetaDataForId.put('DecimalPlaces', (scale > 2 ? 2 : scale));
        fieldMetaDataMap.put('Id',fieldMetaDataForId); 
        
        String columnnames = '';
        List<String> columnsNamesList = new List<String>();
        //Set<String> columnsNamesSet = new Set<String>();
        columnsNamesList.add('Id');
        
        List<String> columnsFieldWidthList = new List<String>();
        columnsFieldWidthList.add('0');
        
        fieldNames = fieldNames.replace('\r\n','  ');   
        fieldNames = fieldNames.replace(' ','');
        List<String> fieldNamesList = fieldNames.split(',',-1);
        
        Map<String,String> flexDetailConfigMap = new Map<String,String>();
        Map<String,String> fieldsColumnMap = new Map<String,String>();
        Map<String,String> columnFieldMap = new Map<String,String>();
        Map<String,Boolean> flexDetailEscapeMap = new Map<String,Boolean>();
        Map<String,String> flexDetailWidthMap = new Map<String,String>();
        Map<String,String> displayFieldMap = new Map<String,String>();
        Map<String,String> gridDisplayFieldMap = new Map<String,String>();
        /*Prasanna*/
        for(DataTableDetailConfig__c obj:dataTableDetailConfigObjList){
            Map<String,Object> detailInfoMap = new Map<String,Object>();
            detailInfoMap.put('RenderType', obj.RenderType__c);
            detailInfoMap.put('WhereClause', obj.WhereClause__c);
            detailInfoMap.put('EnableTotal', obj.EnableTotal__c); //Add Field EnableTotal__c
            detailInfoMap.put('EnableRowGrouping', obj.EnableRowGrouping__c);
            detailInfoMap.put('HelpText', obj.HelpText__c);
            detailInfoMap.put('fieldApiName', (obj.FieldAPIName__c!= null ? obj.FieldAPIName__c.replace('.','') : null));
            detailInfoMap.put('SubTotalLabel', obj.SubTotalLabel__c);
            detailInfoMap.put('ShowLinkAsText', obj.ShowLinkAsText__c);
            dataTableConfigMap.put(obj.fieldApiName__c, detailInfoMap);
            displayFieldMap.put(obj.fieldApiName__c, obj.id);
            
            
            gridDisplayFieldMap.put(obj.fieldApiName__c,obj.DisplayFields__c);
            if (obj.FieldLabelOverride__c != null && obj.FieldLabelOverride__c != '') {
              flexDetailConfigMap.put(obj.FieldAPIName__c,obj.FieldLabelOverride__c);
            }
            if (obj.FieldWidth__c != null) {
              flexDetailWidthMap.put(obj.FieldAPIName__c,obj.FieldWidth__c+'');
            }
            flexDetailEscapeMap.put(obj.FieldAPIName__c,obj.EscapeHtml__c);
        }
        /*Prasanna*/
        fieldMetaDataMap.put('dataTableDetailInfo',dataTableConfigMap);
        
        for(String fieldName:fieldNamesList) {
            //Create a copy of field name
            fieldName = fieldName.trim();
            String field = fieldName; 
            
            String fieldColumnName = fieldName;           
            if(field.toLowerCase() != 'id') {                
                Map<String, Object> fieldMetaData = new Map<String,Object>();
                //Check if the field consists of relationship
                if(field.contains('.')) {    
                    List<String> splitField = field.split('\\.',-1);
                    field = splitField[0];
                    field = field.contains('__r') ? field.replace('__r','__c') :
                            field.equalsIgnoreCase('Owner') ? 'OwnerId' :
                            field.equalsIgnoreCase('CreatedBy') ? 'CreatedById' :
                            field.equalsIgnoreCase('What') ? 'WhatId' :
                            field.equalsIgnoreCase('LastModifiedBy') ? 'LastModifiedById' :
                            field.equalsIgnoreCase('Parent') ? 'ParentId' :
                            field.equalsIgnoreCase('Actor') ? 'ActorId' :
                            field.equalsIgnoreCase('ProcessInstance') ? 'ProcessInstanceId' :
                            field.equalsIgnoreCase('SetupOwner') ? 'SetupOwnerId' :
                            field.equalsIgnoreCase('Contact') ? 'ContactId' :
                            field.equalsIgnoreCase('RecordType') ? 'RecordTypeId' :
                            field;
                }
                if(dataObjectFieldsMap.get(field.toLowerCase()+'') == null) {
                    throw new CustomExceptions.InputDataException('Field ' + fieldName + ' not found for sobject ' + dataTableObjectType + ' : table:' + flexTableId);
                }
                Schema.DescribeFieldResult fieldDescribe = dataObjectFieldsMap.get(field.toLowerCase()+'').getDescribe();      
                if(fieldDescribe.getType() == Schema.DisplayType.Reference) {
                    if(fieldName.endsWithIgnoreCase('id') && !fieldName.equalsIgnoreCase('whatid')) {
                        fieldName = fieldName.removeEndIgnoreCase('id');
                        fieldName = fieldName + '.Name';                         
                    }
                    //Split the field string using ".", because this is a reference field so it definitely has a "." in  it, if not refer else part
                    List<String> splitRefField = fieldName.split('\\.',-1);
                    
                    if(splitRefField.size() == 1 ){                        
                        fieldName = fieldName.replace('__c','__r');
                        fieldName += '.Name';
                    }
                    splitRefField = fieldName.split('\\.',-1);
                    if(splitRefField.size() > 1){
                        Map<String, Schema.SObjectField> referenceFieldsMap = new Map<String, Schema.SObjectField>();
                        referenceFieldsMap = dataObjectFieldsMap;            
                        Schema.SObjectType referenceObject = dataTableObjectType ;
                        String referenceField = field;
                        for(String splittedField:splitRefField){
                            referenceField = splittedField;
                            if(splittedField.contains('__r') || splittedField.equalsIgnoreCase('CreatedBy')|| splittedField.equalsIgnoreCase('Parent') || splittedField.equalsIgnoreCase('Group')){//||splittedField.equalsIgnoreCase('UserOrGroup')
                                splittedField= splittedField.replace('__r','__c'); 
                                splittedField = (splittedField.equalsIgnoreCase('CreatedBy')) ? 'CreatedById' :
                                                (splittedField.equalsIgnoreCase('Parent')) ? 'ParentId' :
                                                (splittedField.equalsIgnoreCase('Group')) ? 'GroupId' :
                                                splittedField;
                                Schema.DescribeFieldResult reffieldDescribe = referenceFieldsMap.get(splittedField.toLowerCase()+'').getDescribe();     
                                referenceObject = reffieldDescribe.getReferenceTo().get(0);
                                Schema.DescribeSObjectResult sObjDescribe = referenceObject.getDescribe();
                                referenceFieldsMap = sObjDescribe.fields.getMap();   
                            }else if(splittedField.contains('__r') || splittedField.equalsIgnoreCase('Owner') ){
                               splittedField= splittedField.replace('__r','__c'); 
                                if(splittedField.equalsIgnoreCase('Owner')){
                                    splittedField = 'OwnerId';  
                                }
                                Schema.DescribeFieldResult reffieldDescribe = referenceFieldsMap.get(splittedField.toLowerCase()+'').getDescribe();     
                                referenceObject = reffieldDescribe.getReferenceTo().get(0);
                                Schema.DescribeSObjectResult sObjDescribe = referenceObject.getDescribe();
                                referenceFieldsMap = sObjDescribe.fields.getMap();   
                            }else{
                            }
                        } 
                                                
                        //if((String.ValueOf(referenceObject).equals('CaseComment') && referenceField.equals('Name'))) {} else
                        if((String.ValueOf(referenceObject).equals('CaseComment') && referenceField.equals('Name')) || (String.ValueOf(referenceObject).contains('Event') && referenceField.equals('Name'))) {
                        }else{
                            if(splitRefField.size() == 2 && splitRefField[1] == 'Name'){
                                fieldMetaData.put('IsLookup',true);
                            }
                            fieldMetaData.put('ReferenceFieldInfo',getRefFieldMetadata(referenceObject,referenceField, fieldColumnName, flexDetailConfigMap,displayFieldMap.get(fieldColumnName)));
                        }
                    }else{                        
                    }
                }
                if(fieldDescribe.getType()+'' == 'PICKLIST' || fieldDescribe.getType()+'' == 'MULTIPICKLIST'){
                    List<String> pickListOptions = new List<String>();

                    List<Map<String,String>> pickListKeyValueMapList = new List<Map<String,String>>(); 
                    Map<String,String> fieldPickListValueLabelMap = new Map<String,String>();
                        Map<String,String> pickListKeyValueMap = new Map<String,String>();
                        pickListKeyValueMap.put('Label','--None--'); 
                        pickListKeyValueMap.put('Value',null); 
                       
                        pickListKeyValueMapList.add(pickListKeyValueMap);   
                    for(Schema.PicklistEntry pe:fieldDescribe.getPicklistValues()){
                        pickListOptions.add(pe.getLabel()+'');                               
                         //pickListOptions.add('None'+'--None--'); 
                        pickListKeyValueMap = new Map<String,String>();
                        pickListKeyValueMap.put('Label',pe.getLabel()+''); 
                        pickListKeyValueMap.put('Value',pe.getValue()+'');
                        //pickListKeyValueMap.put('Label','None');
                       // pickListKeyValueMap.put('Value','--None--');

                        
                        pickListKeyValueMapList.add(pickListKeyValueMap);
                        fieldPickListValueLabelMap.put(pe.getValue()+'',pe.getLabel()+'');
                        //fieldPickListValueLabelMap.put(fieldName,pickListValueLabelMap);
                    }
                    fieldMetaData.put('PicklistValues',pickListOptions);
                    fieldMetaData.put('PicklistKeyValuesMap',pickListKeyValueMapList);
                    fieldMetaData.put('FieldPicklistValueLabelMap',fieldPickListValueLabelMap);
                }

                columnnames += fieldName +  + ' ,';
                //if field label is override then add field in query 
                if(gridDisplayFieldMap.get(fieldColumnName)!=null){ 
                    String fieldColumnNames;
                    fieldColumnNames = fieldColumnName; 
                    fieldColumnNames = fieldColumnNames .replace('__c','__r');
                    fieldColumnNames = fieldColumnNames +'.'+ gridDisplayFieldMap.get(fieldColumnName) ;
                    
                    columnnames += fieldColumnNames +  + ' ,';
                }
                
                
                       
                   
                columnsNamesList.add(fieldName);
                fieldMetaData.put('FieldPath',fieldName);
                fieldMetaData.put('FieldDisplay',gridDisplayFieldMap.get(fieldColumnName));
                
                /*Prasanna*/
                String fieldLabel = null;   
                String fieldLabelOverride =null;
                
                fieldLabel = flexDetailConfigMap.get(fieldColumnName);
                if(fieldLabel == null){
                    fieldLabel = fieldDescribe.getLabel()+''; 
                }
                 fieldLabel = (fieldColumnName.equalsIgnoreCase('CreatedById')) ? Label.CreatedBy :
                                (fieldColumnName.equalsIgnoreCase('LastModifiedById')) ? Label.LastModifiedBy :
                                (fieldColumnName.equalsIgnoreCase('ContactId')) ? Label.Contact :
                                (fieldColumnName.equalsIgnoreCase('OwnerId')) ? Label.AssignedTo :
                                (fieldColumnName.equalsIgnoreCase('RecordTypeId')) ? Label.RecordType :
                                (fieldColumnName.equalsIgnoreCase('ActivityDate')) ? Label.DueDate :
                                fieldLabel;                
                if(flexDetailConfigMap.get(fieldColumnName) != Null) {
                    fieldLabel = flexDetailConfigMap.get(fieldColumnName);
                }                
                if(isHistory == true){
                    fieldLabel = (fieldColumnName.equalsIgnoreCase('CreatedById')) ? Label.ChangedBy : (fieldColumnName.equalsIgnoreCase('CreatedDate')) ? Label.ChangedOn : fieldLabel;
                 
                }
                fieldMetaData.put('Label',fieldLabel);
                fieldMetaData.put('IsUpdateable',fieldDescribe.isUpdateable()+'');
                if(fieldDescribe.getReferenceTo().size() > 0){
                    fieldMetaData.put('ReferenceTo',fieldDescribe.getReferenceTo()[0].getDescribe().getName()+'' );
                }
                fieldMetaData.put('Type',fieldDescribe.getType()+'');
                fieldMetaData.put('Reference',field);
                fieldMetaData.put('ActualField',fieldColumnName);
                fieldMetaData.put('DefaultValue',fieldDescribe.getDefaultValue()+'');
                fieldMetaData.put('IsNillable',fieldDescribe.isNillable());
                fieldMetaData.put('IsCreateable',fieldDescribeForId.isCreateable());
                fieldMetaData.put('ColumnWidth',flexDetailWidthMap.get(fieldColumnName));
                fieldMetaData.put('isFormulaeField',fieldDescribe.isCalculated());
                fieldMetaData.put('fieldLength',fieldDescribe.getLength());
                fieldMetaData.put('PrecisionLength',fieldDescribe.getPrecision());
                fieldMetaData.put('ScaleLength',fieldDescribe.getScale());
                fieldMetaData.put('isAutoNumber',fieldDescribe.isAutoNumber());
                fieldMetaData.put('IsFilterable',fieldDescribe.isFilterable() && (!skipFields.contains(fieldName)));
                fieldMetaData.put('Escape', (flexDetailEscapeMap.containsKey(fieldName)) ? flexDetailEscapeMap.get(fieldName) : true);
                fieldMetaData.put('DecimalPlaces',fieldDescribe.getScale());

                if(fieldDescribe.getType() == Schema.DisplayType.Reference && fieldMetaData.get('ReferenceFieldInfo') != null){
                    Map<String,Object> refObj = (Map<String,Object>)fieldMetaData.get('ReferenceFieldInfo');
                    fieldMetaData.put('DecimalPlaces', refObj.get('DecimalPlaces'));
                }
                fieldsColumnMap.put(fieldName,fieldColumnName);
                columnFieldMap.put(fieldColumnName,fieldName);
                fieldMetaDataMap.put(fieldName,fieldMetaData);                
            }                   
        
        }

       if(columnnames != ''){
        columnnames = columnnames.substring(0, columnnames.length() - 1);          
       }               
        retVal.put('ColumnString',columnnames);
        retVal.put('ColumnsNameList',columnsNamesList);
        retVal.put('FieldsMap',fieldMetaDataMap);
        retVal.put('FieldsList',fieldNamesList);        
        retVal.put('FieldsColumnMap',fieldsColumnMap);
        retVal.put('ColumnFieldMap',columnFieldMap);
        return retVal;     
    } 
    public static Set<String> skipFields = new Set<String>{'ActivityDate'};

 
    public Map<String,Object> getRefFieldMetadata(Schema.SObjectType objectName,String fieldName, String origFieldName, Map<String, String> flexDetailConfigMap, String flexDetailId) {
        
        Schema.DescribeSObjectResult sObjDescribe = objectName.getDescribe();
        Map<String, Schema.SObjectField> fieldsMap = sObjDescribe.fields.getMap();
        
        Schema.SObjectField sObjField = fieldsMap.get(fieldName);
        if(sObjField == null){
            throw new CustomExceptions.InputDataException(fieldName + ' field is not defined on ' + objectName);


        }                
         
        Schema.DescribeFieldResult fieldDescribe = sObjField.getDescribe();
        
        Map<String, Object> retVal = new Map<String, Object>();
        String csfieldName = objectName+'.'+fieldName;        
        
        String fieldLabel = null;   
        String fieldLabelOverride =null;
                
        fieldLabel = (origFieldName.contains('CreatedById')) ? Label.CreatedBy :
                            (origFieldName.contains('LastModifiedById')) ? Label.LastModifiedBy :
                            (origFieldName.contains('ContactId')) ? Label.Contact :
                            (origFieldName.contains('OwnerId')) ? Label.AssignedTo :
                            (origFieldName.contains('RecordTypeId')) ? Label.RecordType :
                            (origFieldName.contains('ActivityDate')) ? Label.DueDate :
                            fieldLabel;
        if(flexDetailConfigMap.get(origFieldName) != null) {                    
            fieldLabel = flexDetailConfigMap.get(origFieldName);
        }       
        if(fieldLabel == null){
            fieldLabel = fieldDescribe.getLabel()+''; 
        }
        retVal.put('Label',fieldLabel);
        retVal.put('FieldPath',fieldName);
        retVal.put('FlexDetailId', flexDetailId);
        retVal.put('Name',fieldDescribe.getName()+'');
        retVal.put('Type',fieldDescribe.getType()+'');
        retVal.put('IsFilterable',fieldDescribe.isFilterable()+'');
        retVal.put('IsUpdateable',fieldDescribe.isUpdateable()+'');
        retVal.put('isAutoNumber',fieldDescribe.isAutoNumber());
        retVal.put('isFormulaeField',fieldDescribe.isCalculated());
        retVal.put('DecimalPlaces',fieldDescribe.getScale());
        if(fieldDescribe.getType()+'' == 'PICKLIST'){
            List<Map<String,String>> pickListKeyValueMapList = new List<Map<String,String>>();
            Map<String,String> fieldPickListValueLabelMap = new Map<String,String>();
            Map<String,String> pickListKeyValueMap = new Map<String,String>();
            List<String> pickListOptions = new List<String>();
            for(Schema.PicklistEntry pe:fieldDescribe.getPicklistValues()){
                    pickListOptions.add(pe.getLabel()+'');                               
                pickListKeyValueMap = new Map<String,String>();
                pickListKeyValueMap.put('Label',pe.getLabel()+'');
                pickListKeyValueMap.put('Value',pe.getValue()+'');
                pickListKeyValueMapList.add(pickListKeyValueMap);
                fieldPickListValueLabelMap.put(pe.getValue()+'',pe.getLabel()+'');

            }
            retVal.put('PicklistValues',pickListOptions);
            retVal.put('PicklistKeyValuesMap',pickListKeyValueMapList);
            retVal.put('FieldPicklistValueLabelMap',fieldPickListValueLabelMap);
        }
        return retVal;
    }
    

    @RemoteAction
    global static Map<String,Object> deleteRecord(String objectName,String recordId) {
        Map<String, Object> retVal = new Map<String, Object>();
        recordId = String.escapeSingleQuotes(recordId);
        String query = 'SELECT Id FROM ' + String.escapeSingleQuotes(objectName) + ' WHERE Id=:recordId';
        List<Sobject> sobjList;
        if(AppUtils.isObjectAccessible(objectName)){   //CRUD/FLS False +ve with the help of AppUtils we have performed check
            sobjList = Database.query(String.escapeSingleQuotes(query),AccessLevel.USER_MODE);//SOQL Injection - False +ve - Dynamic part of query string is escapeSingleQuotes
        }
        try{
            Schema.sObjectType objType = sobjList[0].getSObjectType();
            if(objType.getDescribe().isDeletable()){
                delete as user sobjList;//CRUD - False +ve - As this is Sobject with the help of other method we have checked CRUD
                retVal.put('Message','Record deleted successfully.');
                retVal.put('Success',true);
            } else if(AppUtils.isSkipPermissionCheck()){ // User Story 127005: Internal - Spring'21 release - View All, Modify All, Edit, and Delete Object Permissions Removed for Guest Users - Part 2
                new SystemContextMethodsHelper().deleteSobjectWithoutPermission(sobjList);
                retVal.put('Message','Record deleted successfully.');
                retVal.put('Success',true);
            }else{
                retVal.put('Message',Label.insufficientPrivilagesErrorForUser);
                retVal.put('Success',false);
                return retVal;
            }
        }catch(Exception e) {
            Schema.sObjectType objType = sobjList[0].getSObjectType();
            String errorMessage = AppUtils.handleSystemExceptionMsg(e);
            retVal.put('Message','Error: '+ errorMessage);             
            retVal.put('Success',false);
            return retVal;         
        }
        return retVal;    
    } 
        

    @RemoteAction
    global static Map<String,Object> deleteRecords(Map<String, List<String>> objectNameToIdsMap) {
        Map<String, Object> retVal = new Map<String, Object>();
        
        return retVal;    
    } 


    @RemoteAction
    global static Map<String,Object> executeClass(String className,Map<String,String> idsMap,Map<String,String> keyValueMap,DataTableAction__c actionConfig, String dataTableConfigName,String url) {
        Savepoint sp ;
        Map<String, Object> result = new Map<String, Object>();      
        
        Map<String, String> newUrlParamMap = new Map<String, String>();
        Map<String, Object> urlParamasMapForBulkPdf = new Map<String, Object>();
        for(String key : keyValueMap.keySet()) {
            newUrlParamMap.put(key,keyValueMap.get(key));
        }

        if(newUrlParamMap.get('bulkPdfkeyValueMap') != null && newUrlParamMap.get('bulkPdfkeyValueMap') != ''){
            urlParamasMapForBulkPdf = (Map<string,object>)JSON.deserializeUntyped(keyValueMap.get('bulkPdfkeyValueMap')); 
        }
        if(newUrlParamMap.get('bulkPdfListValueMap') != null && newUrlParamMap.get('bulkPdfListValueMap') != ''){
            Map<String, Object> urlParamasMapForBulkPdfObj = new Map<String, Object>();
            urlParamasMapForBulkPdfObj = (Map<string,object>)JSON.deserializeUntyped(keyValueMap.get('bulkPdfListValueMap')); 
            urlParamasMapForBulkPdf.putAll(urlParamasMapForBulkPdfObj);
        }

        String query = newUrlParamMap != null && newUrlParamMap.get('queryGlobal')!= null ? newUrlParamMap.get('queryGlobal') : '';
        newUrlParamMap.remove('queryGlobal');
        String[] spliStr;
        Type t;
        DataTableAction__c dataTableAction;
        if(Schema.sObjectType.DataTableAction__c.isAccessible()){
            dataTableAction = [SELECT SkipRollbackLogic__c FROM DataTableAction__c WHERE id =:actionConfig.id WITH USER_MODE];
        }
         if(dataTableAction.SkipRollbackLogic__c == false){
            sp = Database.setSavepoint();
         }
        try {
            if(className.contains('.')){
                spliStr = className.split('\\.');
                t = Type.forName(spliStr[0], spliStr[1]);
            }else{
                t = Type.forName('', className);
            }
        } catch(Exception ex) {
            throw new CustomExceptions.InputDataException('Class not found with Name ' + className + '. Please check class name.');
        }
        List<String> idsList = new List<String>();
        FlexTableActionHandler  flexTableAction = (FlexTableActionHandler)t.newInstance();
        for(String id:idsMap.keySet()){
            if(idsMap.get(id) == 'true'){
                idsList.add(id);    
            }
        }
        flexTableAction.selectedRecordIds = idsList; 
        flexTableAction.actionConfig = actionConfig;
        flexTableAction.dataTableConfigName = dataTableConfigName ;
        flexTableAction.query = query;
        
        // Map<String, String> urlParamsMap = new Map<String, String>();
        List<String> URLSplitList = url.split('\\?',-1);
        if(URLSplitList.size() >= 2){
            String URLparams = URLSplitList[1];
            if(URLparams != null && URLparams.length() > 0){
                List<String> URLParamsList = URLparams.split('&',-1);
              
                for(String paramMap:URLParamsList){
                    List<String> paramKeyvalue = paramMap.split('=',-1); 
                    if(paramKeyvalue.size() > 1) {
                        newUrlParamMap.put(paramKeyvalue[0],paramKeyvalue[1]);// commented temp AJA                
                    }
                }
            }
        }        
        flexTableAction.urlParams = newUrlParamMap;   
        flexTableAction.urlParamsMap = urlParamasMapForBulkPdf;  
        
        try
        {
            Map<String,Object> resultMap = new Map<String,Object>();
            resultMap = flexTableAction.clickHandler();
            result.put('PageURL',resultMap.get('PageReference'));
            result.put('Message',resultMap.get('Message'));
            result.put('Success',resultMap.get('Success'));
            result.put('Error',resultMap.get('Error'));
            result.put('Warning',resultMap.get('Warning'));
            result.put('query', globalQueryString);
            if(resultMap.get('Type') != null){
                result.put('type',resultMap.get('Type'));
            }
            if(resultMap.get('MessageConfig') != null){
                String errorCode = String.valueOf(resultMap.get('MessageConfig'));
                List<ErrorMessageConfig__c> errorMessages = new List<ErrorMessageConfig__c>();
                if(Schema.sObjectType.ErrorMessageConfig__c.isAccessible()){
                    errorMessages = [SELECT id,Message_Type__c,Message__c,ErrorCode__c FROM ErrorMessageConfig__c WHERE ErrorCode__c =: errorCode WITH USER_MODE];
                }
                if(errorMessages.size() == 0) {
                    CustomExceptions.logException('Not error message config found for ' + errorCode, false);
                }
                result.put('Message',errorMessages.get(0).Message__c);
                result.put('type',errorMessages.get(0).Message_Type__c);
                
            }
            if(resultMap.get('RefreshParentPage') != null) {
                result.put('RefreshParentPage',resultMap.get('RefreshParentPage'));
            }
        }
        catch(Exception ex)
        {
            if(sp!=null){
                Database.rollback(sp);
            }

            List<String> recordIdSet = new List<String>();
            if(flexTableAction.selectedRecordIds.size() == 0){
                String recMsg = 'No records are selected.';
                recordIdSet.add(recMsg);                    
            }else{
                recordIdSet.addAll(flexTableAction.selectedRecordIds);
            }

            if(ex instanceOf NullPointerException){
                CustomExceptions.logSystemException(ex,null,recordIdSet);
            }else if(ex instanceOf ListException){
                CustomExceptions.logSystemException(ex,null,recordIdSet);
            }else if(ex instanceOf DmlException){
                CustomExceptions.logSystemException(ex,null,recordIdSet);
            }else if(ex instanceOf QueryException){
                CustomExceptions.logSystemException(ex,null,recordIdSet);
            }else if(ex instanceOf SObjectException){
                CustomExceptions.logSystemException(ex,null,recordIdSet);
            }else if(ex instanceOf JSONException){
                CustomExceptions.logSystemException(ex,null,recordIdSet);
            }else if(ex instanceOf NoDataFoundException){
                CustomExceptions.logSystemException(ex,null,recordIdSet);
            }else if(ex instanceOf SerializationException){
                CustomExceptions.logSystemException(ex,null,recordIdSet);                
            }else if(ex instanceOf TypeException){
                CustomExceptions.logSystemException(ex,null,recordIdSet);    
            }else if(ex instanceOf CalloutException){
                CustomExceptions.logSystemException(ex,null,recordIdSet);    
            }else{
                throw new CustomExceptions.InputDataException(ex.getMessage());
            }

            //String errMsg = Apputils.handleSystemExceptionMsg(ex.getMessage());  
            String errMsg = Apputils.handleSystemExceptionMsg(ex);  
            result.put('Error',errMsg);
        }
        return result;    
    }  
    
    @RemoteAction
    global static Map<String,Object>fetchMiniLayout(Id referenceId){
        return MiniLayoutController.getLayout(referenceId);
    }
    
    public with sharing class HistoryClass{
        public String Field {get;set;}
        public String OldValue {get;set;}
        public String NewValue {get;set;}
        public DateTime CreatedDate {get;set;}
        public Sobject CreatedBy {get;set;}
        public Map<String,String> Parent{get;set;}
        public Id Idval{get;set;}
        public HistoryClass(){
            Parent = new Map<String,String>();
        }
    } 
    public with sharing class LookupData{
        public String id;
        public String text;
        
        public LookupData(Object id, Object text){
            this.id = String.valueOf(id);
            this.text = String.valueOf(text);
        }
    }
    
    
    
    global static Map<String,Object> getAccountHierarchy(String accId){
        return AccountHierarchyCtrl.getAccountHierarchy(accId,null);
    }

    @RemoteAction
    global static Map<String,Object> getAccountHierarchy(String accId,String treeFilter){
        return AccountHierarchyCtrl.getAccountHierarchy(accId,treeFilter);
    }
    
    @RemoteAction
    global static Map<String,Object> paintLookupFlexTable(String fieldAPINames,String sobjectName,String filterClause,Map<String, Object> paramMap) {
        Map<String, Object> result = new Map<String, Object>();
        FlexTableCtrl flexTableController = new FlexTableCtrl();        
        TimeZone tz = UserInfo.getTimeZone();
        result = flexTableController.createInitDataForSkinnyTable(fieldAPINames,sobjectName, filterClause, String.valueOf(paramMap.get('mergeFields')),String.valueOf(paramMap.get('listmergeFields')));
        result.put('UserLocale', tz.getOffset(DateTime.newInstance(2012,10,23,12,0,0)) );
        result.put('DataTableInfo',flexTableController.getRecords( (String)result.get('ColumnString'), null, null, sobjectName, Integer.valueOf( paramMap.get('PageNumber')) ,
                                                                    Integer.valueOf( paramMap.get('PageSize')),
                                                                    String.valueOf(paramMap.get('SortBy')),
                                                                    String.valueOf(paramMap.get('SortDirection')) + ' NULLS LAST',String.valueOf(paramMap.get('searchTerm')),
                                                                    result.get('FilterClause') != null ? String.valueOf(result.get('FilterClause')) : '', false));
        return result;    
    }
    
    /*
        This method accepts following parameters:
        1. The name of flex table congif object.
        2. Search term, if any. This is basically for flex skinny table that is rendered on search from left side navigation.
        3. Whether we need to fire a SOSL or a SOQL query.
        4. The key value map for merge fields.
        5. A boolean value the indicates if the page is loaded through salesforce1 mobile app.
    */
     public  Map<String,Object> createInitDataForSkinnyTable(String fieldAPIList,String sobjectName,String filterClause, String filterParams,String listParams){
        Map<String, Object> result = new Map<String, Object>();         
        if(!String.isEmpty(fieldAPIList)){
            if(!String.isEmpty(sobjectName)){
                Schema.SObjectType dataTableObjectType;      
                dataTableObjectType = SchemaManager.getSObjectTypeFromName(SObjectName);                     
                if(dataTableObjectType <> null){
                    Schema.DescribeSObjectResult dataTableObjectResult = dataTableObjectType.getDescribe();
                    Map<String,Schema.SObjectField> dataObjectFieldsMap = dataTableObjectResult.fields.getMap();
                    if(sObjectType.AccordionContent__c != null){
                        String nameSpacePrefix = AppUtils.getNamespacePrefix();
                        result.put('NamespacePrefix',nameSpacePrefix ); 
                    }
                    Map<String,Object> fieldInfoMap = getFieldMetadataForSkinnyTable(dataTableObjectType,sobjectName,fieldAPIList,dataObjectFieldsMap);
                    result.put('FieldMetadata',fieldInfoMap.get('FieldsMap'));
                    result.put('FieldsList',fieldInfoMap.get('FieldsList'));
                    result.put('FieldsColumnMap',fieldInfoMap.get('FieldsColumnMap'));
                    result.put('ColumnFieldMap',fieldInfoMap.get('ColumnFieldMap'));
                    result.put('ColumnsNameList',fieldInfoMap.get('ColumnsNameList'));
                    
                   
                    Map<String,Object> mergeFieldsKeyValueMap = new Map<String,Object>(); 
                    if(filterParams!=null && filterParams!=''){                                            
                        mergeFieldsKeyValueMap = (Map<string,object>)JSON.deserializeUntyped(filterParams);                        
                                                                       
                    }

                    if(listParams!=null && listParams!=''){
                        mergeFieldsKeyValueMap.putAll((Map<string,object>)JSON.deserializeUntyped(listParams));
                    }
                    filterClause = getFilterClauseString(filterClause, mergeFieldsKeyValueMap);
                    result.put('KeyValueMap',mergeFieldsKeyValueMap); 
                    result.put('MaxRecordsCount', KeyValueStoreHelper.getIntegerValue('FlexTableMaxRecordsCount',true)+'');
                    if(listKeyValueMap !=null && listKeyValueMap !=''){                             
                         
                        Map<String,Object> keyValueMapForObj = new Map<String,Object>();
                        keyValueMapForObj = (Map<string,object>)JSON.deserializeUntyped(listKeyValueMap);
                        mergeFieldsKeyValueMap.putAll(keyValueMapForObj);
                           
                    }
                    Integer pageSize = KeyValueStoreHelper.getIntegerValue('FlexTableDefaultPageSize',true);   
                    if(pageSize == null){
                        pageSize = 10;    
                    }
                    
                    Map<String,Object> datatableInfoMap = new Map<String,Object>();
                    datatableInfoMap.put('SObjectName',sobjectName);                      
                    datatableInfoMap.put('ColumnString',(String)fieldInfoMap.get('ColumnString'));
                    datatableInfoMap.put('PageNumber',1);
                    datatableInfoMap.put('PageSize',pageSize);
                    datatableInfoMap.put('FilterClause',filterClause);    
                    datatableInfoMap.put('PageSizes', KeyValueStoreHelper.getTextValue('FlexTablePageSizeOptions',true)+'');  
                            
                    result.put('DataTableInfoMap',datatableInfoMap);
                    
                    result.put('ObjectMetaData',getObjectMetadata(dataTableObjectResult,fieldAPIList));                    
                    result.put('DataTableObjectResult',dataTableObjectResult);
                    result.put('FilterClause',filterClause);
                    result.put('ColumnString',(String)fieldInfoMap.get('ColumnString'));
                    Timezone tz = UserInfo.getTimezone();
                    DateTime now = DateTime.now();
                    //Long offset = DateTime.newInstance(now.date(), now.time()).getTime()
                    Integer offset = tz.getOffset(System.now());
                    result.put('Offset',offset);
                }                        
            }else{  
                result.put('ErrorMessages','No sobject defined in flex table config record found. Please contact your administrator.');  
            }
        }else{
            result.put('ErrorMessages','No data table config object found. Please contact your administrator.');
        }
       
        Boolean renderBtnForPDF = KeyValueStoreHelper.getBooleanValue('DownloadPDFStyle_FlexTable',true);
        result.put('renderBtnForPDF',renderBtnForPDF);
        
        Boolean renderBtnForCSV = KeyValueStoreHelper.getBooleanValue('DownloadCSVStyle_FlexTable',true);
        result.put('renderBtnForCSV',renderBtnForCSV);
        return result;    
    }
    
     /*
    
    Get Field Meta Data for Lookup   
    */
    
    
    
     private Map<String,Object> getFieldMetadataForSkinnyTable(Schema.SObjectType dataTableObjectType,String objectName,String fieldNames,Map<String,Schema.SObjectField> dataObjectFieldsMap){
        /* Create a map object to be returned */
        Map<String, Object> retVal = new Map<String, Object>();
        Map<String, Object> fieldMetaDataMap = new Map<String, Object>(); 
        Map<String, Object> fieldMetaDataForId = new Map<String,Object>(); 
        Schema.DescribeFieldResult fieldDescribeForId = dataObjectFieldsMap.get('id').getDescribe();                       
        fieldMetaDataForId.put('Label',fieldDescribeForId.getLabel()+'');
        fieldMetaDataForId.put('IsUpdateable',fieldDescribeForId.isUpdateable()+'');        
        fieldMetaDataForId.put('Type',fieldDescribeForId.getType()+'');
        fieldMetaDataForId.put('DefaultValue',fieldDescribeForId.getDefaultValue()+'');
        fieldMetaDataForId.put('IsNillable',fieldDescribeForId.isNillable());
        fieldMetaDataForId.put('IsCreateable',fieldDescribeForId.isCreateable());
        fieldMetaDataMap.put('Id',fieldMetaDataForId); 
        
        String columnnames = 'Id ,';
        List<String> columnsNamesList = new List<String>();
        columnsNamesList.add('Id');
        
        List<String> columnsFieldWidthList = new List<String>();
        columnsFieldWidthList.add('0');
        
        fieldNames = fieldNames.replace('\r\n','  ');   
        
        // check if fieldNames is valid JSON if yes then it will contains API name and its associated label else it will have field using CSV format
        List<String> fieldNamesList = new List<String>();
        Map<String,String> flexDetailConfigMap = new Map<String,String>();
        try {
            flexDetailConfigMap =  (Map<String, String>)JSON.deserialize(fieldNames,  Map<String, String>.class);
            fieldNamesList.addAll(flexDetailConfigMap.keySet());
        } catch(Exception ex) {
            fieldNames = fieldNames.replace(' ','');
            fieldNamesList = fieldNames.split(',',-1);
        }
        
        Map<String,Boolean> flexDetailEscapeMap = new Map<String,Boolean>();
        Map<String,String> flexDetailWidthMap = new Map<String,String>();
        for(String fieldName : fieldNamesList) {
            //Create a copy of field name
            fieldName = fieldName.trim();
            String field = fieldName; 
            
            String fieldColumnName = fieldName;           
            if(field.toLowerCase() != 'id'){                
                Map<String, Object> fieldMetaData = new Map<String,Object>();
                //Check if the field consists of relationship
                if(field.contains('.')){    
                    List<String> splitField = field.split('\\.',-1);
                      
                    field = splitField[0];
                    field = (field.contains('__r')) ? field.replace('__r','__c') :
                            (field.equalsIgnoreCase('Owner')) ? 'OwnerId' :
                            (field.equalsIgnoreCase('CreatedBy')) ? 'CreatedById' :
                            (field.equalsIgnoreCase('What')) ? 'WhatId' :
                            (field.equalsIgnoreCase('LastModifiedBy')) ? 'LastModifiedById' :
                            (field.equalsIgnoreCase('Parent')) ? 'ParentId' :
                            (field.equalsIgnoreCase('Actor')) ? 'ActorId' :
                            (field.equalsIgnoreCase('ProcessInstance')) ? 'ProcessInstanceId' :
                            (field.equalsIgnoreCase('SetupOwner')) ? 'SetupOwnerId' :
                            (field.equalsIgnoreCase('Contact')) ? 'ContactId' :
                            (field.equalsIgnoreCase('RecordType')) ? 'RecordTypeId' :
                             (field.equalsIgnoreCase('UserRole')) ? 'UserRoleId' :
                             field;
                }
                
                Schema.DescribeFieldResult fieldDescribe = dataObjectFieldsMap.get(field.toLowerCase()+'').getDescribe();      
                if(fieldDescribe.getType() == Schema.DisplayType.Reference) {

                    if(fieldName.endsWithIgnoreCase('id') && !fieldName.equalsIgnoreCase('whatid')) {
                        fieldName = fieldName.removeEndIgnoreCase('id');
                        fieldName = fieldName + '.Name';                         
                    }
                    
                    //Split the field string using ".", because this is a reference field so it definitely has a "." in  it, if not refer else part
                    List<String> splitRefField = fieldName.split('\\.',-1);
                    if(splitRefField.size() == 1 ){                        
                        fieldName = fieldName.replace('__c','__r');
                        fieldName += '.Name';
                    }
                    
                    splitRefField = fieldName.split('\\.',-1);
                    if(splitRefField.size() > 1){
                        Map<String, Schema.SObjectField> referenceFieldsMap = new Map<String, Schema.SObjectField>();
                        referenceFieldsMap = dataObjectFieldsMap;            
                        Schema.SObjectType referenceObject = dataTableObjectType ;
                        
                        String referenceField = field;
                        for(String splittedField:splitRefField){
                            
                            referenceField = splittedField;
                            if(splittedField.contains('__r') || splittedField.equalsIgnoreCase('CreatedBy')){//||splittedField.equalsIgnoreCase('UserOrGroup')
                                splittedField= splittedField.replace('__r','__c'); 
                                if(splittedField.equalsIgnoreCase('CreatedBy')){
                                    splittedField = 'CreatedById';  
                                }
                                
                                Schema.DescribeFieldResult reffieldDescribe = referenceFieldsMap.get(splittedField.toLowerCase()+'').getDescribe();     
                                
                                referenceObject = reffieldDescribe.getReferenceTo().get(0);
                                
                                Schema.DescribeSObjectResult sObjDescribe = referenceObject.getDescribe();
                                
                                referenceFieldsMap = sObjDescribe.fields.getMap();   
                                
                            }else if(splittedField.contains('__r') || splittedField.equalsIgnoreCase('Owner')|| splittedField.equalsIgnoreCase('Parent') || splittedField.equalsIgnoreCase('UserRole')){
                               splittedField= (splittedField.equalsIgnoreCase('Owner')) ? 'OwnerId' :
                                                (splittedField.equalsIgnoreCase('Parent')) ? 'ParentId' :
                                                (splittedField.equalsIgnoreCase('UserRole')) ? 'UserRoleId' :
                                                splittedField.replace('__r','__c'); 
                                Schema.DescribeFieldResult reffieldDescribe = referenceFieldsMap.get(splittedField.toLowerCase()+'').getDescribe();     
                                
                                referenceObject = reffieldDescribe.getReferenceTo().get(0);
                                
                                Schema.DescribeSObjectResult sObjDescribe = referenceObject.getDescribe();
                                
                                referenceFieldsMap = sObjDescribe.fields.getMap();   
                              
                            }else{
                            }
                        } 
                        if(String.ValueOf(referenceObject).equals('CaseComment') && referenceField.equals('Name')){
                        }else{
                            fieldMetaData.put('ReferenceFieldInfo',getRefFieldMetadata(referenceObject,referenceField, fieldColumnName, flexDetailConfigMap,null));
                        }
                    }
                }
                if(fieldDescribe.getType()+'' == 'PICKLIST'){
                    List<String> pickListOptions = new List<String>();
                    for(Schema.PicklistEntry pe:fieldDescribe.getPicklistValues()){
                        pickListOptions.add(pe.getLabel()+'');                               
                    }
                    fieldMetaData.put('PicklistValues',pickListOptions);
                }
                columnnames += fieldName +  + ' ,';
                columnsNamesList.add(fieldName);
                fieldMetaData.put('FieldPath',fieldName);
                String fieldLabel = null;   
                String fieldLabelOverride =null;
                
                fieldLabel = flexDetailConfigMap.get(fieldColumnName);
                if(String.isEmpty(fieldLabel)){
                    fieldLabel = fieldDescribe.getLabel()+''; 
                }
                /*Prasanna*/
                fieldMetaData.put('Label',fieldLabel);
                fieldMetaData.put('IsUpdateable',fieldDescribe.isUpdateable()+'');
                if(fieldDescribe.getReferenceTo().size() > 0){
                    fieldMetaData.put('ReferenceTo',fieldDescribe.getReferenceTo()[0].getDescribe().getName()+'' );
                }
                fieldMetaData.put('Type',fieldDescribe.getType()+'');
                fieldMetaData.put('Reference',field);
                fieldMetaData.put('ActualField',fieldColumnName);
                fieldMetaData.put('DefaultValue',fieldDescribe.getDefaultValue()+'');
                fieldMetaData.put('IsNillable',fieldDescribe.isNillable());
                fieldMetaData.put('IsCreateable',fieldDescribeForId.isCreateable());
                fieldMetaData.put('IsCreateable',fieldDescribeForId.isCreateable());
                fieldMetaData.put('ColumnWidth',flexDetailWidthMap.get(fieldColumnName));
                
                fieldMetaData.put('Escape', (flexDetailEscapeMap.containsKey(fieldName)) ? flexDetailEscapeMap.get(fieldName) : true);
                fieldMetaDataMap.put(fieldName,fieldMetaData);                
            }                   
        }

        columnnames = columnnames.substring(0, columnnames.length() - 1);          
        
        //Prajakta:We need to add name field in query when in display field name is not configured.Removed 'name' to avoid dupliacte error.
        Set<String> columnNamesSet = new Set<String>();
        List<String> columnNamesList = new List<String>();
        columnNamesSet.addAll(columnnames.deleteWhitespace().split(','));
        columnNamesSet.add('Name');
        columnNamesSet.remove('name');
        columnNamesList.addAll(columnNamesSet);
        columnnames = String.join(columnNamesList, ',');        
        
        retVal.put('ColumnString',columnnames);
        retVal.put('ColumnsNameList',columnsNamesList);
        retVal.put('FieldsMap',fieldMetaDataMap);
        retVal.put('FieldsList',fieldNamesList);        
        
        return retVal;     
    } 
    public with sharing class ChildRelationShipWrapper implements comparable{
        public string childObjectAPIName {get;set;}
        public string childObjectLabel {get;set;}
        public integer index;
        
        public Integer compareTo(Object compareTo) {
            ChildRelationShipWrapper  compareToObj = (ChildRelationShipWrapper )compareTo;
            if (index== compareToObj .index){
                return 0;
            }
            if (index > compareToObj .index){
                return 1;
            }
            return -1;        
        }

    }  
    
    /*
    Method  :   executeAnonymous(Id buttonId, Id recordId, Id parentId)
    Purpose :   This method will run script which is define in flex table action.
    */
    @RemoteAction
    global static String executeAnonymous(Map<String,String> mapRecordIds) {
        Id buttonId = (mapRecordIds.get('buttonId') != null ? Id.ValueOf(mapRecordIds.get('buttonId')) : null);
        Id recordId = (mapRecordIds.get('recordId') != null ? Id.ValueOf(mapRecordIds.get('recordId')) : null);
        Id parentId = (mapRecordIds.get('parentId') != null ? Id.ValueOf(mapRecordIds.get('parentId')) : null);
        
        List<DataTableAction__c> lstDataTableActions = new List<DataTableAction__c>();
        if(Schema.sObjectType.DataTableAction__c.isAccessible()){
            lstDataTableActions = [SELECT Id, Name,AnonymousExecuteScript__c FROM DataTableAction__c WHERE Id =:buttonId WITH USER_MODE];
        }
        String anonymousExecuteScript = lstDataTableActions[0].AnonymousExecuteScript__c;
        
        String anonymousExecuteScriptResult = null;
        
        FlexTableCtrl flexTableController = new FlexTableCtrl(); 
        anonymousExecuteScriptResult = flexTableController.replaceUserMergeFields(anonymousExecuteScript);
        anonymousExecuteScriptResult = flexTableController.replaceUserAccountMergeFields(anonymousExecuteScriptResult);
        if(recordId != null){
            anonymousExecuteScriptResult = AppUtils.replaceRecordMergeFields(anonymousExecuteScriptResult,recordId);
            if(parentId != null){
                anonymousExecuteScriptResult = AppUtils.replaceRecordMergeFields(anonymousExecuteScriptResult,parentId);
            }
        }
        else if(parentId != null){
            anonymousExecuteScriptResult = AppUtils.replaceRecordMergeFields(anonymousExecuteScript,parentId);
        }
        
        return AppUtils.executeAnonymousScript(anonymousExecuteScriptResult);             
    }

 @RemoteAction
        global static Map<String, Object> initPhases(){        
            return populatePhasesList();
        }
        static Map<String,Object> initData;
        private static Map<String, Object> populatePhasesList(){
            initData = new Map<String,Object>();
            List<String> phaseList = new List<string>();
            List<Map<String,Object>> phaseMap = new List<Map<String,Object>>();
            String phaseJSON = '[';
            String appName = UserPreferenceHelper.getStringValue('ActiveAppName__c');
            if(!String.isEmpty(appName)){
                List<PhaseConfig__c> lstConfig = new List<PhaseConfig__c>();
                if(Schema.sObjectType.PhaseConfig__c.isAccessible()){
                    lstConfig = [Select Id, Name, Sequence__c, TabName__c From PhaseConfig__c 
                        Where CustomAppName__c = :appName And PhaseType__c = 'Phase' And Active__c = true AND (NOT Name LIKE 'Collab%') WITH USER_MODE Order by Sequence__c];
                }
                if(lstConfig != null){
                    for(PhaseConfig__c pConfig : lstConfig ){
                        Map<String, Object> phaseMapInner = new Map<String,Object>();
                        phaseList.add(pConfig.TabName__c);
                        phaseMapInner.put('name', pConfig.Name);
                        phaseMapInner.put('label', pConfig.TabName__c);
                        phaseMap.add(phaseMapInner);
                    }
                }
            }
            initData.put('phasesString', phaseMap);
            return initData;
        }



}