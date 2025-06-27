/**
*************************************************
Audit History
*************************************************
2018-06-01     Ajinkya Raut         Created
*************************************************
**/
public with sharing class FlexGridEnhancedHelper{
    private sObject parentRecord;
    private set<string> setParentObjectFields = new set<string>();
    private Boolean isSearchTable = false;
    public String searchText;
    public FlexGridEnhancedHelper(){

    }
    private Savepoint sp ;

    public Map<String, Object> getFlexGridInfo(String paramsJson){
        Map<string, Object> flexGridInfoMap = new Map<string, Object>();

         FlexGridEnhancedUtility.InitParams params = new FlexGridEnhancedUtility.InitParams(paramsJson);
        if(params.flexGridName == null || params.flexGridType != 'FlexGrid'){
            return null;
        }

        if(FlexGridConfig__c.sObjectType.getDescribe().isAccessible() == true) {
            List<FlexGridConfig__c> flexGridConfigList = (List<FlexGridConfig__c> )new QueryBuilder()
                                        .addFields(FlexGridFactory.getFlexGridInfoFields())
                                        .setsObject('FlexGridConfig__c')
                                        .addFilter('Name = \'' + String.escapeSingleQuotes(params.flexGridName) + '\'')
                                        .createQuery()
                                        .execute();

            if(flexGridConfigList.size() > 1){
                flexGridInfoMap.put('Message','More than 1 Flex Grid Config records found.');
                flexGridInfoMap.put('Success',false);
            }else if(flexGridConfigList.size() == 1){
                FlexGridEnhancedHelper flexGridEnhancedHelper = new FlexGridEnhancedHelper();
                Set<String> userInfoSet = new Set<String>();
                setParentObjectFields = new set<string>();

                flexGridEnhancedHelper.processFlexGrid(flexGridInfoMap,flexGridConfigList[0],params,userInfoSet);
                flexGridEnhancedHelper.getUserinfo(flexGridInfoMap,userInfoSet);
                Integer MessageTimeOut = FlexGridEnhancedCtrl.getmessageTimeOut();
                Boolean MessageTimeOutEnabled = FlexGridEnhancedCtrl.getmessageTimeOutEnabled();
               flexGridInfoMap.put('MessageTimeOut',MessageTimeOut);
                flexGridInfoMap.put('MessageTimeOutEnabled',MessageTimeOutEnabled);
                flexGridInfoMap.put('GridType','FlexGrid');
		
				flexGridInfoMap.put('NameSpacePrefix', AppUtils.getNamespacePrefix());
                String CommunityBaseUrl = AppUtils.getCommunityBaseUrl();
                
                if(CommunityBaseUrl != null){
                    flexGridInfoMap.put('isCommunitySiteUser', true);
                    flexGridInfoMap.put('CommunityBaseUrl', CommunityBaseUrl);

                }
            }else{
                flexGridInfoMap.put('Message','No Flex Grid Config records found.');
                flexGridInfoMap.put('Success',false);
            }

        }else{
            flexGridInfoMap.put('Message','Flex Grid Config - No Access');
            flexGridInfoMap.put('Success',false);
        }

        return flexGridInfoMap;
    }


    public Map<String, Object> getFlexTableInfo(String paramsJson){

        Map<string, Object> flexTableInfoMap = new Map<string, Object>();
        FlexGridEnhancedUtility.InitParams params = new FlexGridEnhancedUtility.InitParams(paramsJson);
        if(params.flexGridName == null || params.flexGridType != 'FlexTable'){
            return null;
        }
        flexTableInfoMap.put('NameSpacePrefix', AppUtils.getNamespacePrefix());
        Integer MessageTimeOut = FlexGridEnhancedCtrl.getmessageTimeOut();
        Boolean MessageTimeOutEnabled = FlexGridEnhancedCtrl.getmessageTimeOutEnabled();
       flexTableInfoMap.put('MessageTimeOut',MessageTimeOut);
        flexTableInfoMap.put('MessageTimeOutEnabled',MessageTimeOutEnabled);
        if(DataTableConfig__c.sObjectType.getDescribe().isAccessible() == true) {
            List<DataTableConfig__c> flexTableConfigList = new List<DataTableConfig__c>();
            flexTableConfigList = (List<DataTableConfig__c> )new QueryBuilder()
                                        .addFields(FlexGridFactory.getFlexTableFields())
                                        .setsObject('DataTableConfig__c')
                                        .addFilter('Name = \'' + String.escapeSingleQuotes(params.flexGridName) + '\'')
                                        .createQuery()
                                        .execute();

            if(flexTableConfigList.size() > 1){
                flexTableInfoMap.put('Message','More than 1 Flex Grid Config records found.');
                flexTableInfoMap.put('Success',false);
            }else if(flexTableConfigList.size() == 1){
                getFlexTableConfig(flexTableConfigList[0].Id);
                FlexGridEnhancedHelper flexGridEnhancedHelperObj = new FlexGridEnhancedHelper();
                Set<String> userInfoSet = new Set<String>();
                
                if(flexTableConfigList[0] != null){
                    getFlexTableConfigData(flexTableInfoMap, flexTableConfigList[0],'ParentFlexTable',params,userInfoSet);
                    flexGridEnhancedHelperObj.getUserinfo(flexTableInfoMap,userInfoSet);
                    flexTableInfoMap.put('GridType','FlexTable');
                    String CommunityBaseUrl = AppUtils.getCommunityBaseUrl();
                
                    if(CommunityBaseUrl != null){
                        flexTableInfoMap.put('isCommunitySiteUser', true);
                        flexTableInfoMap.put('CommunityBaseUrl', CommunityBaseUrl);
    
                    }
                }
                if(params.parentRecordId != null){
                    parentRecord = FlexGridEnhancedHelper.getParentRecord(params.parentRecordId, setParentObjectFields, flexTableInfoMap);
                    try{
                        if(parentRecord != null && (String)parentRecord.get('RecordTypeId') != null){
                            String ParentRecordTypeId = (String)parentRecord.get('RecordTypeId');
                            List<RecordType> rtList =[select DeveloperName from RecordType where Id =: ParentRecordTypeId WITH USER_MODE];//CRUD/FLS False +ve As per business scenario we can't check for portal/external users
                            String ParentRecordTypeName = rtList[0].DeveloperName;
                            flexTableInfoMap.put('ParentRecordTypeName',ParentRecordTypeName);
                        }
                    }
                    catch(Exception ex){
                       
                    }
                    if(parentRecord != null){                
                        flexTableInfoMap.put('ParentRecord',parentRecord);
                    }
                }

            }else{
                flexTableInfoMap.put('Message','No Flex Grid Config records found.');
                flexTableInfoMap.put('Success',false);
            }

        }else{
            flexTableInfoMap.put('Message','Flex Table Config - No Access');
            flexTableInfoMap.put('Success',false);
        }

        return flexTableInfoMap;
    }

    public void getUserinfo( Map<string, Object> flexGridInfoMap,Set<String> userInfoSet){
        Map<string, Object> currentUserInfo  = new Map<string, Object>();
        currentUserInfo.put('UserType', AppUtils.getUserType());
        currentUserInfo.put('UserProfile', AppUtils.getProfileInfo());
        currentUserInfo.put('UserAppName', UserPreferenceHelper.getStringValue('ActiveAppName__c'));
        
        set<string> UserFields = Schema.SObjectType.User.fields.getMap().Keyset(); 
        set<string> newUserFields = new set<string>{'Name','Title','CompanyName','firstname','lastname','Username','Department','Email'};    
        If(UserFields.contains('rolecode__c'))
            UserFields.remove('rolecode__c');
        for(string s : UserFields){
            If(s.contains('__c'))
                newUserFields.add(s);
        }
        userInfoSet.addall(newUserFields);
        String userFieldsStr = String.join(new List<String>(userInfoSet),',' );
        String userQuery = 'SELECT '+ string.escapesinglequotes(userFieldsStr) + ' FROM User where Id = \''+string.escapeSingleQuotes(UserInfo.getUserId())+'\'';
        User currentUser = Database.query(userQuery, AccessLevel.USER_MODE); //SOQL Injection - False +ve - Dynamic parts of the query string is ecsapeSingleQuotes to prevent SOQL Injection
        currentUserInfo.put('UserInfo',currentUser);
        set<string> QueueList = new set<string>();
        set<string> newGroupField = new set<string>{'Name'};    
        set<string> newGroupmenberField = new set<string>{'GroupId'}; 
        String GroupfieldStr = String.join(new List<String>(newGroupField),',' );
        String GroupmemberfieldStr = String.join(new List<String>(newGroupmenberField),',' );   
        String QueueQuery = 'SELECT '+ string.escapesinglequotes(GroupfieldStr) + ' FROM Group where Id IN (SELECT '+ string.escapesinglequotes(GroupmemberfieldStr) +' FROM GroupMember WHERE UserOrGroupId = \''+string.escapeSingleQuotes(UserInfo.getUserId())+'\') ';
        List<Group> QueueRecordList = Database.query(QueueQuery, AccessLevel.USER_MODE); //SOQL Injection - False +ve - Dynamic parts of the query string is ecsapeSingleQuotes to prevent SOQL Injection
        if(QueueRecordList.size() > 0){
        
           for(Group grp : QueueRecordList){
            QueueList.add(grp.Name);
           }
        }

        if(QueueList.size() > 0){
            currentUserInfo.put('Queue',QueueList);
        }
        
        flexGridInfoMap.put('govGrantPleaseWaitIconURL',AppUtils.getIcons('govGrantPleaseWaitIcon'));
        flexGridInfoMap.put('CurrentUserInfo', currentUserInfo);
    }

    public void processFlexGrid( Map<string, Object> flexGridInfoMap,FlexGridConfig__c flexGridConfig,FlexGridEnhancedUtility.InitParams initParams,Set<String> userInfoSet){
       getFlexGridConfigData(flexGridInfoMap,flexGridConfig);

       if(flexGridConfig.ParentFlexTable__c != null){
            getFlexTableConfigData(flexGridInfoMap, flexGridConfig.ParentFlexTable__r,'ParentFlexTable',initParams,userInfoSet);
        }
        if(flexGridConfig.Child1FlexTable__c != null){
            getFlexTableConfigData(flexGridInfoMap, getFlexTableConfig(flexGridConfig.Child1FlexTable__c),'Child1',initParams,userInfoSet);
        }
        if(flexGridConfig.Child2FlexTable__c != null){
            getFlexTableConfigData(flexGridInfoMap, getFlexTableConfig(flexGridConfig.Child2FlexTable__c),'Child2',initParams,userInfoSet);
        }
        if(flexGridConfig.GrandChild1FlexTable__c != null){
            getFlexTableConfigData(flexGridInfoMap, getFlexTableConfig(flexGridConfig.GrandChild1FlexTable__c),'GrandChild1',initParams,userInfoSet);
        }
        if(flexGridConfig.GrandChild2FlexTable__c != null){
            getFlexTableConfigData(flexGridInfoMap, getFlexTableConfig(flexGridConfig.GrandChild2FlexTable__c),'GrandChild2',initParams,userInfoSet);
        }
        if(initParams.parentRecordId != null){
            parentRecord = flexGridEnhancedHelper.getParentRecord(initParams.parentRecordId, setParentObjectFields, flexGridInfoMap);
            try{
                if(parentRecord != null && (String)parentRecord.get('RecordTypeId') != null){
                    String ParentRecordTypeId = (String)parentRecord.get('RecordTypeId');
                    List<RecordType> rtList;
                    if(RecordType.sObjectType.getDescribe().isAccessible()) {
                        rtList = [select DeveloperName from RecordType where Id =: ParentRecordTypeId WITH USER_MODE];//CRUD/FLS False +ve As per business scenario we can't check for portal/external users
                    }
                    String ParentRecordTypeName = rtList[0].DeveloperName;
                    flexGridInfoMap.put('ParentRecordTypeName',ParentRecordTypeName);
                }
            }
            catch(Exception ex){
               
            }
            if(parentRecord != null){                
                flexGridInfoMap.put('ParentRecord',parentRecord);
            }
        }
    }

    private void getFlexGridConfigData(Map<string, Object> flexGridInfoMap,FlexGridConfig__c flexGridConfig){
        flexGridInfoMap.put('NameSpacePrefix', AppUtils.getNamespacePrefix());
        FlexGridEnhancedUtility.FlexGridConfigMetaData flexGridWrapper =new FlexGridEnhancedUtility.FlexGridConfigMetaData(flexGridConfig);
        flexGridInfoMap.put('FlexGridMetaData',flexGridWrapper);
        flexGridInfoMap.put('IsSpreadSheet',flexGridWrapper.IsSpreadSheet);
    }

    private DataTableConfig__c getFlexTableConfig(Id flexTableId){
        List<DataTableConfig__c> flexTableConfigList = new List<DataTableConfig__c>();
        if(DataTableConfig__c.sObjectType.getDescribe().isAccessible() == true) {
            flexTableConfigList = (List<DataTableConfig__c> )new QueryBuilder()
                                        .addFields(FlexGridFactory.getFlexTableFields())
                                        .setsObject('DataTableConfig__c')
                                        .addFilter('Id = \'' + String.escapeSingleQuotes(flexTableId) + '\'')
                                        .createQuery()
                                        .execute();
        }
        return  flexTableConfigList [0];
    }

    private void getFlexTableConfigData(Map<string, Object> flexGridInfoMap,
                                        DataTableConfig__c flexTableConfig,
                                        String flexTableLevel,
                                        FlexGridEnhancedUtility.InitParams initParams,Set<String> userInfoSet){

        FlexGridEnhancedUtility.FlexTableConfigData flexTableConfigData = new FlexGridEnhancedUtility.FlexTableConfigData();

        List<String> additionalRowMergeFields = new List<String>();

        flexTableConfigData.FlexTableActionMap = getFlexTableActionConfig(flexTableConfig.Id,initParams,additionalRowMergeFields,flexTableConfig,userInfoSet);

        flexTableConfigData.DataTableDetailConfigMap = getDataTableDetailConfig(flexTableConfig.Id,initParams);
        if(initParams.parentRecordId != null){
            setParentObjectFields.addAll(flexGridEnhancedHelper.getParentObjectFields(initParams.parentRecordId,flexTableConfigData.FlexTableActionMap,flexTableConfigData.DataTableDetailConfigMap,flexGridInfoMap));
        }
 

        

        flexTableConfigData.FlexTableFilterListViewList = getFlexTableFilterListView(flexTableConfig.Id,initParams);
		flexTableConfigData.flexTableUserListView =getFlexTableUserListView(flexTableConfig.Id,UserInfo.getUserId());
       flexTableConfigData.FlexTableConfigMap = getTableMetaData(flexTableConfigData,flexTableConfig,initParams,flexGridInfoMap.get('IsSpreadSheet') != null ? Boolean.valueOf(flexGridInfoMap.get('IsSpreadSheet')) : false,additionalRowMergeFields);
        flexGridInfoMap.put(flexTableLevel,flexTableConfigData);
    }

    private Map< String, FlexGridEnhancedUtility.DataTableDetailInfo>  getDataTableDetailConfig(String flexTableId, FlexGridEnhancedUtility.InitParams initParams){
        Map< String, FlexGridEnhancedUtility.DataTableDetailInfo> dataTableDetailConfigMap = new  Map< String, FlexGridEnhancedUtility.DataTableDetailInfo>();
        if(DataTableDetailConfig__c.sObjectType.getDescribe().isAccessible() == true) {
            QueryBuilder queryBuilder = new QueryBuilder();
            List<DataTableDetailConfig__c> dataTableDetailConfigObjList = (List<DataTableDetailConfig__c> )queryBuilder.addFields(FlexGridfactory.getDataTableDetailFields())
                                         .setsObject('DataTableDetailConfig__c')
                                         .addFilter('FlexTableConfig__c = \'' + String.escapeSingleQuotes(flexTableId) + '\'')
                                         .createQuery()
                                         .execute();
            if(dataTableDetailConfigObjList.size() > 0){
                for(DataTableDetailConfig__c obj:dataTableDetailConfigObjList){
                    FlexGridEnhancedUtility.DataTableDetailInfo dataTableDetailInfo = new FlexGridEnhancedUtility.DataTableDetailInfo(obj);
                    if(dataTableDetailInfo.WhereClause != null){
                      dataTableDetailInfo.WhereClause = replaceAllMergeFields(dataTableDetailInfo.WhereClause,initParams);
                    }
                    if(dataTableDetailInfo.DefaultValue != null){
                        dataTableDetailInfo.DefaultValue = replaceAllMergeFields(dataTableDetailInfo.DefaultValue,initParams);
                    }
                DataTableDetailConfigMap.put(obj.fieldApiName__c, dataTableDetailInfo);
                }
            }

        }
        return dataTableDetailConfigMap;
    }

    private List<FlexGridEnhancedUtility.FlexTableListFilterListView> getFlexTableFilterListView(String flexTableId, FlexGridEnhancedUtility.InitParams initParams){
        Id loggedInUserId = userInfo.getUserId();
        String UserListView;
        List<FlexGridEnhancedUtility.FlexTableListFilterListView> flexTableFilterListViewList = new List<FlexGridEnhancedUtility.FlexTableListFilterListView>();
         List<FlexTableFilterListViewConfig__c> flexTableFilterListViewLists = new List<FlexTableFilterListViewConfig__c>();
        if(FlexTableFilterListViewConfig__c.sObjectType.getDescribe().isAccessible() == true) {
            QueryBuilder queryBuilder = new QueryBuilder();
            flexTableFilterListViewLists = queryBuilder.addFields(FlexGridfactory.getFlexTableFilterListView())
                                         .setsObject('FlexTableFilterListViewConfig__c')
                                         .addFilter('FlexTableConfig__c = \'' + String.escapeSingleQuotes(flexTableId) + '\'')
                                         .setSortField('Sequence__c')
                                         .createQuery()
                                         .execute();
            }
            List<FlexTableListViewUserConfig__c> flexUserConfigList = new List<FlexTableListViewUserConfig__c>();
            if(Schema.sObjectType.FlexTableListViewUserConfig__c.isAccessible()){
                flexUserConfigList = [SELECT Id,Name,User__c,FlexTableListViewConfig__r.Label__c FROM FlexTableListViewUserConfig__c WHERE User__c = :loggedInUserId and FlexTableConfig__r.id =:flexTableId];
            }
            if(flexUserConfigList.size() == 1){
                UserListView = (String)flexUserConfigList[0]?.FlexTableListViewConfig__r.Label__c;
            }
            for(FlexTableFilterListViewConfig__c flexTableFilterListView :flexTableFilterListViewLists){

                FlexGridEnhancedUtility.FlexTableListFilterListView flexListView = new FlexGridEnhancedUtility.FlexTableListFilterListView(flexTableFilterListView);
                if (flexListView.FilterClause != null){
                    flexListView.FilterClause = replaceAllMergeFields(flexListView.FilterClause,initParams);
                }
                if(!string.isBlank(UserListView)){
                    flexListView.IsUserListView = flexListView?.Label.equalsIgnoreCase(UserListView) ? true : false;
                }
                flexTableFilterListViewList.add(flexListview);
            }
        return  flexTableFilterListViewList;
    }


    private Map<String,List<FlexGridEnhancedUtility.FlexTableActionConfig>> getFlexTableActionConfig(String flexTableId, FlexGridEnhancedUtility.InitParams initParams,
                                                                            List<String> additionalRowMergeFields, DataTableConfig__c flexTableConfig,Set<String> userInfoSet) {
        Map<String,List<FlexGridEnhancedUtility.FlexTableActionConfig>> flexTableActionConfigMap = new Map<String,List<FlexGridEnhancedUtility.FlexTableActionConfig>>();
        Set<String> userFieldsSet = new Set<String>();
        Map<String,String> IconCssMap = new Map<String,String>();
        Boolean isExpCloud  = AppUtils.isExperienceCloud();
       if(flexTableId == null){
            return null;
        }
       QueryBuilder queryBuilder = new QueryBuilder();
        List<DataTableAction__c> lstFlexTableActionConfig = (List<DataTableAction__c> )queryBuilder.addFields(FlexGridFactory.getFlexTableActionConfigFields())
                                                                 .setsObject('DataTableAction__c')
                                                                 .addFilter('DataTableConfig__c = \'' + String.escapeSingleQuotes(flexTableId) + '\'')
                                                                 .createQuery()
                                                                 .execute();

        if(lstFlexTableActionConfig.size() > 0){
        
                IconCssMap = AppUtils.getActionIcon();
        }
        for(DataTableAction__c flexTableActionRecord : lstFlexTableActionConfig){
            FlexGridEnhancedUtility.FlexTableActionConfig actionWrapper = new FlexGridEnhancedUtility.FlexTableActionConfig(flexTableActionRecord);
            if(actionWrapper.HideExpressionJSON != null){
                userFieldsSet = getUserExpFields(actionWrapper.HideExpressionJSON);
                if(actionWrapper.Location == 'Row' && actionWrapper.EnableParentHideLogic != true){
                    additionalRowMergeFields.addAll(getHideExpressionFields(actionWrapper.HideExpressionJSON,flexTableConfig.SobjectConfig__r.Name)) ;
                    if(actionWrapper.HideExpressionFields != null){
                        List<String> HideExpressionFieldsList = actionWrapper.HideExpressionFields.split(',');
                        additionalRowMergeFields.addAll(HideExpressionFieldsList);
                    }

              }
            }
            if(flexTableActionConfigMap.get(flexTableActionRecord.Location__c) == null){
                flexTableActionConfigMap.put(flexTableActionRecord.Location__c,new List<FlexGridEnhancedUtility.FlexTableActionConfig>());
            }
            if(actionWrapper.Location == 'Row'){
                List<String> objAPINamelist = new List<String>();
                objAPINamelist.add(flexTableConfig.SobjectConfig__r.Name);
                additionalRowMergeFields.addAll(AppUtils.getMergeFieldSupport(actionWrapper.ActionURLLong,objAPINamelist));
            }
            if(actionWrapper.ActionURLLong != null){
                actionWrapper.ActionURLLong = replaceAllMergeFields(actionWrapper.ActionURLLong,initParams);
            }
            if(actionWrapper.ActionURLLongLWC != null){
                actionWrapper.ActionURLLongLWC = replaceAllMergeFields(actionWrapper.ActionURLLongLWC,initParams);
            }
            
            if(actionWrapper.IconCSS != null && (UserInfo.getUiTheme() =='Theme4d' || UserInfo.getUiTheme() =='Theme4u' || isExpCloud)){
                
                actionWrapper.IconCSS=actionWrapper.IconCSS.replaceAll('<[/a-zAZ0-9]*','');
                actionWrapper.IconCSS=actionWrapper.IconCSS.replaceAll('>','');
                actionWrapper.IconCSS=actionWrapper.IconCSS.replaceAll('"','');
                List<String> iconList = actionWrapper.IconCSS.split('=');
                if(iconList.size()> 1){
                    actionWrapper.IconCSS = IconCssMap.get(iconList[1].trim());
                }
            }
                actionWrapper.HideAction = getFlexTableActionDecision(flexTableActionRecord);
            flexTableActionConfigMap.get(flexTableActionRecord.Location__c).add(actionWrapper);
            if(userFieldsSet.size() > 0){
                userInfoSet.addAll(userFieldsSet);
            }
        }
        return flexTableActionConfigMap;
    }


    private String replaceAllMergeFields(String filterString, FlexGridEnhancedUtility.InitParams initParams){
        filterString = replaceUserAccountMergeFields(filterString);
        filterString = replaceUserMergeFields(filterString);
        filterString = appNameMergeFieldHandler(filterString);
        if (initParams.parentRecordId != null){
            filterString = AppUtils.replaceRecordMergeFields(filterString,initParams.parentRecordId);
        }
        return filterString;
    }


    private String appNameMergeFieldHandler(String mergeString){
        
  
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
                if(appName != null) {
                    mergeString = mergeString.replace(appNameToken, String.valueOf(appName));
                } else {
                    mergeString = mergeString.replace(appNameToken, '');
                }
            }             
        }
        return mergeString;
    }
    public String replaceFileMergeFields(String filterString, Id parentRecordId){

        if(parentRecordId != null && filterString.containsIgnoreCase('{!ContentDocLinkId}')){
            List<String> ContentDocumentIDList = new List<String>();
            if(ContentDocumentLink.sObjectType.getDescribe().isAccessible()) {
                for(ContentDocumentLink cDLink : [SELECT Id,ContentDocumentId FROM ContentDocumentLink 
                WHERE LinkedEntityId =:parentRecordId WITH USER_MODE]){//CRUD/FLS False +ve As per business scenario we can't check for portal/external users
                    ContentDocumentIDList.add(String.escapeSingleQuotes(cDLink.ContentDocumentId));
                }
            }
            String ContentDocLinkIds = 'ContentDocumentId in'+ '(\'' + String.join(ContentDocumentIDList, '\',\'') +'\')';
            filterString = filterString.replace('{!ContentDocLinkId}', ContentDocLinkIds);
        }
        else if(parentRecordId != null && filterString.containsIgnoreCase('{!ContentNoteId}')){
            List<String> ContentDocumentIDList = new List<String>();
            if(ContentDocumentLink.sObjectType.getDescribe().isAccessible()) {
                for(ContentDocumentLink cDLink : [SELECT Id,ContentDocumentId FROM ContentDocumentLink WHERE LinkedEntityId =:parentRecordId  WITH USER_MODE]){//CRUD/FLS False +ve As per business scenario we can't check for portal/external users
                    ContentDocumentIDList.add(String.escapeSingleQuotes(cDLink.ContentDocumentId));
                }
            }
            String ContentDocLinkIds = 'Id in'+ '(\'' + String.join(ContentDocumentIDList, '\',\'') +'\')';
            filterString = filterString.replace('{!ContentNoteId}', ContentDocLinkIds);
        }
        else if(filterString.containsIgnoreCase('{!ContentDocLinkId}')){
            filterString = filterString.replace('{!ContentDocLinkId}', 'Id != null');
        }else if(filterString.containsIgnoreCase('parentId')){
            String[] SplitFiterString = filterString.split('=');
            if(SplitFiterString.size() > 1){ 
                List<String> ContentDocumentIDList = new List<String>();
                String query = 'SELECT Id,ContentDocumentId FROM ContentDocumentLink WHERE LinkedEntityId = '+ AppUtils.parseWhereClause(SplitFiterString[1]);
                 List<ContentDocumentLink> cDLink = Database.query(query, AccessLevel.USER_MODE); //NOPMD SOQL Injection - False +ve - Dynamic parts of the query string is ecsapeSingleQuotes using AppUtils.parseWhereClause method to prevent SOQL Injection
                for(ContentDocumentLink cDLinkVar: cDLink){
                    ContentDocumentIDList.add(String.escapeSingleQuotes(cDLinkVar.ContentDocumentId));
                }
                String ContentDocLinkIds = 'ContentDocumentId in'+ '(\'' + String.join(ContentDocumentIDList, '\',\'') +'\')';
                filterString =  ContentDocLinkIds;                
            }              
        }  
        return filterString;
    }


    private String replaceUserMergeFields(String filterString){

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
            User userObj = Database.query('SELECT '+ string.escapeSingleQuotes(String.join(userFieldsToQueryMap.values(), ',')) + ' FROM User WHERE Id = \''+ string.escapeSingleQuotes(UserInfo.getUserId())+'\'', AccessLevel.USER_MODE);//SOQL Injection - False +ve - Dynamic part of query is escapeSingleQuotes 
            for(String replaceStr : userFieldsToQueryMap.keySet()) {
                Object value = AppUtils.getFieldValue(userObj, userFieldsToQueryMap.get(replaceStr));
                if(value != null) {
                    filterString = filterString.replace(replaceStr, String.escapeSingleQuotes(String.valueOf(value)));
                } else {
                    filterString = filterString.replace(replaceStr, '');
                }
            }
        }
        return filterString;
    }


    private String replaceUserAccountMergeFields(String filterString){

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
            User user = Database.query('SELECT OrganizationId__c FROM User WHERE Id = \''+ string.escapeSingleQuotes(UserInfo.getUserId())+'\'', AccessLevel.USER_MODE);//SOQL Injection - False +ve - Dynamic part of query is escapeSingleQuotes 
            if(user.OrganizationId__c != null) {
                List<Account> acccounts = Database.query('SELECT '+ string.escapeSingleQuotes(String.join(acctFieldsToQueryMap.values(), ',')) + ' FROM Account WHERE Id = \''+ string.escapeSingleQuotes(user.OrganizationId__c)+'\'', AccessLevel.USER_MODE); //SOQL Injection - False +ve - Dynamic part of query is escapeSingleQuotes 
                if(acccounts.size() > 0) {
                    for(String replaceStr : acctFieldsToQueryMap.keySet()) {
                        Object value = AppUtils.getFieldValue(acccounts[0], acctFieldsToQueryMap.get(replaceStr));
                        if(value != null) {
                            filterString = filterString.replace(replaceStr, String.escapeSingleQuotes(String.valueOf(value)));
                        } else {
                            filterString = filterString.replace(replaceStr, '');
                        }
                    }
                }
            }
        }
        return filterString;
    }

    public static List<String> getHideExpressionFields(String expressionJson,String sobjectName){
        list<String> expfieldsList = new list<String>();
        String mergeFields= '';
        mergeFields = ExpressionJSONEvaluator.getfieldNamesFromJSON(expressionJson);
        String alternateSobjectName = sobjectName;
        try {
            Map<String,Object> jsonParsed = (Map<String,Object>)Json.deserializeUntyped(SFDCEncoder.sanitizeJSON(expressionJson)); // false+ for Deserializing objects from an untrusted source is security-sensitive as sanitizing it by using SFDCEncoder.sanitizeJSON
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

    private  Set<String> getUserExpFields(String expJson){
        ExpressionJsonEvaluator.ExpGroup expGrp =(ExpressionJsonEvaluator.ExpGroup)JSON.deserialize(expJson,ExpressionJsonEvaluator.ExpGroup.class);
        Set<String> expFieldsSet = new Set<String>();
        processExpGroup(expGrp,expFieldsSet);
        return expFieldsSet;
    }

    private void processExpGroup(ExpressionJsonEvaluator.ExpGroup expGroup,Set<String> fieldsSet){
        if(expGroup.Conditions != null){
            for(ExpressionJsonEvaluator.Condition condition:expGroup.Conditions){
                if(condition.LOperand.Type == 'User'){
                    fieldsSet.add(condition.LOperand.Value.toLowerCase());
                }
                if(condition.ROperand.Type == 'User'){
                    fieldsSet.add(condition.ROperand.Value.toLowerCase());
                }
            }
        }
        if(expGroup.Groups != null){
                for(ExpressionJsonEvaluator.ExpGroup childExpGroup:expGroup.Groups){
                    processExpGroup(childExpGroup,fieldsSet);
                }
        }
    }


    //setParentObjectFields
    public Static Set<String> getParentObjectFields(String strParentRecordId,
                                            Map<String,List<FlexGridEnhancedUtility.FlexTableActionConfig>> flexTableActionMap,
                                            Map<String , FlexGridEnhancedUtility.DataTableDetailInfo> dataTableDetailConfigMap,
                                            Map<string, Object> flexGridInfoMap){

        if(strParentRecordId == null){
            return null;
        }
        Id parentRecordId = Id.valueOf(strParentRecordId);
        String sObjectName = (String)parentRecordId.getsobjecttype().getDescribe().getName();
        Set<String> expFieldsSet = new Set<String>();

        if(flexTableActionMap!= null && flexTableActionMap.get('Top') != null){
            for(FlexGridEnhancedUtility.FlexTableActionConfig  flexTableActionRecord : flexTableActionMap.get('Top')){
                Boolean isExpressionBlank = true;
                if(flexTableActionRecord.Location == 'Top'){
                    if(String.isEmpty(flexTableActionRecord.HideExpressionJSON)){
                        isExpressionBlank = true;
                    }else{
                       List<String> expFields = new List<String>();
                       expFields = getHideExpressionFields(flexTableActionRecord.HideExpressionJSON,sobjectName);
                        if(expFields.size() > 0){
                            expFieldsSet.addAll(expFields);
                        }
                    }
                }
                if(isExpressionBlank == true){
                    continue;
                }
            }
        }

        if(flexTableActionMap!= null && flexTableActionMap.get('Row') != null){
            for(FlexGridEnhancedUtility.FlexTableActionConfig  flexTableActionRecord : flexTableActionMap.get('Row')){
                if(flexTableActionRecord.EnableParentHideLogic == true){
                    Boolean isExpressionBlank = true;
                    if(flexTableActionRecord.Location == 'Row'){
                        if(String.isEmpty(flexTableActionRecord.HideExpressionJSON)){
                            isExpressionBlank = true;
                        }else{
                            List<String> expFields = new List<String>();
                            expFields = getHideExpressionFields(flexTableActionRecord.HideExpressionJSON,sobjectName);
                            if(expFields.size() > 0){
                                expFieldsSet.addAll(expFields);
                            }
                        }    
                    }
                    if(isExpressionBlank == true){
                        continue;
                    }
                }
            }
        }


        if(dataTableDetailConfigMap != null){
            for(String  detailInfoName : dataTableDetailConfigMap.keySet()){
                 FlexGridEnhancedUtility.DataTableDetailInfo detailInfoWrapper = dataTableDetailConfigMap.get(detailInfoName);
                 Boolean isExpressionBlank = true;
                 if(String.isEmpty(detailInfoWrapper.HideColumnJSON) && String.isEmpty(detailInfoWrapper.ReadOnlyColumnJSON)){
                     isExpressionBlank = true;
                 }else{
                    List<String> hideFields = new List<String>();
                    List<String> readOnlyFields = new List<String>();
                    if(String.isNotEmpty(detailInfoWrapper.HideColumnJSON)){
                         hideFields = getHideExpressionFields(detailInfoWrapper.HideColumnJSON,sobjectName);
                    }
                    if(String.isNotEmpty(detailInfoWrapper.ReadOnlyColumnJSON)){
                         readOnlyFields = getHideExpressionFields(detailInfoWrapper.ReadOnlyColumnJSON,sobjectName);
                    }
                     if(hideFields.size() > 0){
                         expFieldsSet.addAll(hideFields);
                     }
                     if(readOnlyFields.size() > 0){
                         expFieldsSet.addAll(readOnlyFields);
                     }
                 }
                 if(isExpressionBlank == true){
                     continue;
                 }
             }
         }

        return expFieldsSet;
    }

    public Static sobject getParentRecord(String strParentRecordId, set<string> setParentObjectFields, Map<string, Object> flexGridInfoMap){
        if(strParentRecordId == null){
            return null;
        }
        Id parentRecordId = Id.valueOf(strParentRecordId);
        String sObjectName = (String)parentRecordId.getsobjecttype().getDescribe().getName();
        if(setParentObjectFields.size() == 0){
            setParentObjectFields.add('Id');
        }
        if(setParentObjectFields.size() > 0){
            QueryBuilder queryBuilder =  new QueryBuilder();
            List<String> expFieldsList = new List<String>(setParentObjectFields);
            List<sobject> lstparentRecord  = (List<Sobject>)queryBuilder
                                                            .addFields(expFieldsList)
                                                            .setsObject(sObjectName)
                                                            .addFilter('Id =\'' + parentRecordId+'\'')
                                                            .setLimit(1)
                                                            .createQuery()
                                                            .execute();
            return lstparentRecord[0];
        }else{
            return null;
        }
    }

    public List<sobject> getPageRecords(String paramsJson){
        Map<String, Object> returnMap = new Map<String, Object>();
        List<sobject> lstFlexRecords;
        FlexGridEnhancedUtility.RecordParams params = new FlexGridEnhancedUtility.RecordParams(paramsJson);
        QueryBuilder queryBuilder =  new QueryBuilder();
        if(params.filterCriteria != null && (params.sObjectName == 'ContentVersion' || params.sObjectName == 'ContentNote')){
            params.filterCriteria = replaceFileMergeFields(params.filterCriteria, params.parentRecordId); 
        }  
        if(params.enhancedSearchText != null && params.enhancedSearchText !=''){
            isSearchTable = true;
            searchText = params.enhancedSearchText;
        }   
        if(isSearchTable == true){
            String query = 'FIND \''+String.escapeSingleQuotes(searchText)+'*\' IN ALL FIELDS RETURNING '+ String.escapeSingleQuotes(params.sObjectName);
            List<List<sobject>> tempLstFlexRecords = Search.Query(query,AccessLevel.USER_MODE);  //SOQL/SOSL Injection - False +ve - Dynamic part of query string is escapeSingleQuotes          
            lstFlexRecords = tempLstFlexRecords[0];
        }else{
            String nullOrder = params.sortDirection == 'ASC' ? 'FIRST' : 'LAST';
            lstFlexRecords  = (List<Sobject>)queryBuilder
                                                        .addFields(params.queryFieldsList)
                                                        .setsObject(params.sObjectName)
                                                        .addFilter(params.filterCriteria)
                                                        .setSortField(params.sortableColumn)
                                                        .setOrder(params.sortDirection)
                                                        .setLimit(params.limitValue)
                                                        .setOffset(params.pageSize)
                                                        .setNullOrder(nullOrder)
                                                        .setGroupBy(params.GroupByCluase)
                                                        .createQuery()
                                                        .execute();
        }        
        return lstFlexRecords;

    }

    public Map<String, Object> getPageRecordsMap(String paramsJson){
        Map<String, Object> returnMap = new Map<String, Object>();
        Map<Id,SObject> mapFlexRecords;
        FlexGridEnhancedUtility.RecordParams params = new FlexGridEnhancedUtility.RecordParams(paramsJson);
        if((params.sObjectName == 'ContentVersion' || params.sObjectName == 'ContentNote' ) && params.filterCriteria != null){
          params.filterCriteria = replaceFileMergeFields(params.filterCriteria, params.parentRecordId);
        }
        if(params.pageSize == 0){
            params.pageSize = null;
        }
        if(params.enhancedSearchText != null && params.enhancedSearchText !=''){
            isSearchTable = true;
            searchText = params.enhancedSearchText;
        }  
        Id userId = userInfo.getUserId();
        if(params.flexTableId != null && params.updatdFlexHeader != null )    
            FlexTableStickySearchCtrl.updateFlexTableListViewConfig(params.flexTableId,userId,params.updatdFlexHeader);
        
        String tableQueryWithReplaceMergeFileds;
        tableQueryWithReplaceMergeFileds = new QueryBuilder()
                                                .addFields(params.queryFieldsList)
                                                .setsObject(params.sObjectName)
                                                .addFilter(params.filterCriteria)
                                                .setSortField(params.sortableColumn)
                                                .setOrder(params.sortDirection)                                               
                                                .setGroupBy(params.GroupByCluase)
                                                .createQuery().strQuery;

        if(isSearchTable == true){           
            String query = 'FIND \''+String.escapeSingleQuotes(searchText)+'*\' IN ALL FIELDS RETURNING '+ String.escapeSingleQuotes(params.sObjectName)+'('+ AppUtils.concatenate(params.queryFieldsList, ', ') + ')' ;
            List<List<sobject>> lstFlexRecords = Search.Query(query,AccessLevel.USER_MODE);//SOQL/SOSL Injection - False +ve - Dynamic part of query string is escapeSingleQuotes 
            mapFlexRecords = new Map<Id,SObject>(lstFlexRecords[0]);
        }else{
            if(params.sObjectName == 'ContentNote'){
                mapFlexRecords  = (Map<Id,SObject>)new QueryBuilder()
                                                            .addContentFields(params.queryFieldsList)
                                                            .setsObject(params.sObjectName)
                                                            .addFilter(params.filterCriteria)
                                                            .setSortField(params.sortableColumn)
                                                            .setOrder(params.sortDirection)
                                                            .setLimit(params.limitValue)
                                                            .setOffset(params.pageSize)
                                                            .setGroupBy(params.GroupByCluase)
                                                            .createQuery()
                                                            .execute('Map');
                }else{
                
            mapFlexRecords  = (Map<Id,SObject>)new QueryBuilder()
                                                        .addFields(params.queryFieldsList)
                                                        .setsObject(params.sObjectName)
                                                        .addFilter(params.filterCriteria)
                                                        .setSortField(params.sortableColumn)
                                                        .setOrder(params.sortDirection)
                                                        .setLimit(params.limitValue)
                                                        .setOffset(params.pageSize)
                                                        .setGroupBy(params.GroupByCluase)
                                                        .createQuery()
                                                        .execute('Map');

        }        

        }        
        List<NotesCtrl.EnhancedtNoteWrapper> notesLst = new List<NotesCtrl.EnhancedtNoteWrapper>();
        if(params.sObjectName == 'ContentNote'){
            List<ContentNote> contenetNoteRecords = mapFlexRecords.values();
            for(ContentNote rec : contenetNoteRecords){       
               String strNotes = rec.Content.toString();
               notesLst.add(new NotesCtrl.EnhancedtNoteWrapper(rec,strNotes));
            }
            returnMap.put('RecordsList',notesLst);
            returnMap.put('ApprovalLockedRecordsMap', Approval.isLocked(new List<Id>(mapFlexRecords.keySet())));
            returnMap.put('query', tableQueryWithReplaceMergeFileds);
        }else{
	        returnMap.put('RecordsList', mapFlexRecords.values());
	        returnMap.put('ApprovalLockedRecordsMap', Approval.isLocked(new List<Id>(mapFlexRecords.keySet())));
	        returnMap.put('query', tableQueryWithReplaceMergeFileds);
        }
        return returnMap;
    }


    private Boolean getFlexTableActionDecision(DataTableAction__c flexTableActionRecord) {
        boolean hideAction = AppUtils.showHideComponent(null, AppUtils.isInternalUser(), AppUtils.isApplicant(), flexTableActionRecord.HideForProfile__c,'', null, flexTableActionRecord.HideForUser__c, AppUtils.getProfileInfo(), flexTableActionRecord.HideForRole__c, AppUtils.getRoleInfo(), flexTableActionRecord.HideOperator__c) ;
        return hideAction;
    }


    private Map<String, Object> getTableMetaData(FlexGridEnhancedUtility.FlexTableConfigData flexTableConfigData,
                                                 DataTableConfig__c flexTableConfig,
                                                 FlexGridEnhancedUtility.InitParams initParams,
                                                 Boolean isSpreadSheet,List<String> additionalRowMergeFields){
        Map<String, Object> flexTableConfigMap = new Map<String, Object>();
        Schema.SObjectType dataTableObjectType;
        dataTableObjectType = SchemaManager.getSObjectTypeFromName(flexTableConfig.SobjectConfig__r.Name);
        Map<String,Object> fieldInfoMap = new Map<String,Object>();
       if(dataTableObjectType <> null){
            Map<String, Object> fieldMetaDataMap = new Map<String, Object>();
            fieldMetaDataMap = getFieldMetadata(flexTableConfig, dataTableObjectType, flexTableConfigData.dataTableDetailConfigMap,additionalRowMergeFields);
            flexTableConfigMap.put('FieldMetaData', fieldMetaDataMap.get('FieldMetaData'));
            flexTableConfigMap.put('ColumnNamesList', fieldMetaDataMap.get('ColumnNamesList'));
            flexTableConfigMap.put('QueryFieldsList', fieldMetaDataMap.get('QueryFieldsList'));
            FlexGridEnhancedUtility.FlexTableConfig flexDataConfig = new  FlexGridEnhancedUtility.FlexTableConfig(flexTableConfig,isSpreadSheet);
            if(flexDataConfig.FilterCriteria != null && flexDataConfig.FilterCriteria != ''){
                flexDataConfig.FilterCriteria  = replaceAllMergeFields(flexDataConfig.FilterCriteria,initParams);
            }                       
            if(flexDataConfig.HelpConfig != null){
                flexDataConfig.HelpDocId = getHelpDocId(flexDataConfig.HelpConfig);
            }

            flexTableConfigMap.put('FlexTableConfig',flexDataConfig);
        }
        return flexTableConfigMap;
    }


    private String getHelpDocId(Id helpConfigId){
        List<HelpConfig__c> helpList = new List<HelpConfig__c>();
        String  docId = null;
        if(Schema.sObjectType.HelpConfig__c.isAccessible()){
        helpList = [Select id, DocumentName__c, RecordType.DeveloperName
                    From HelpConfig__c Where id = :helpConfigId WITH USER_MODE Limit 1];
        }
        if(helpList != null && helpList.size() > 0){
            if(helpList[0].RecordType.DeveloperName == 'InternalDocument'){
                if(helpList[0].DocumentName__c != null){
                    List<Document> doc;
                    if(Document.sObjectType.getDescribe().isAccessible()) {
                        doc = [Select id From Document Where
                        DeveloperName = : helpList[0].DocumentName__c WITH USER_MODE];//CRUD/FLS False +ve As per business scenario we can't check for portal/external users
                    }
                    
                    if(doc != null && doc.size() > 0){
                        docId = doc[0].id;
                    }
                }
                return docId;
            }
        }
        return docId;
    }


    private Map<String,Object> getFieldMetadata(DataTableConfig__c flexTableConfig,Schema.SObjectType dataTableObjectType, Map< String, FlexGridEnhancedUtility.DataTableDetailInfo> dataTableDetailConfigMap,List<String> additionalRowMergeFields) {
        Schema.DescribeSObjectResult dataTableObjectResult = dataTableObjectType.getDescribe();
        Map<String,Schema.SObjectField> dataObjectFieldsMap = dataTableObjectResult.fields.getMap();
        Map<String, Object> retVal = new Map<String, Object>();
        Map<String, Object> fieldMetaData = new Map<String, Object>();
        Set<String> displayFieldsSet = new Set<String>(flexTableConfig.FieldNames__c.split(',',-1));
        Set<String> queryFieldsSet = new Set<String>();
        Set<String> tempQueryFieldsSet = new Set<String>();
        Set<String> additionalRefFieldSet = new Set<String>();
        List<String> stdObject = new List<String>();
        stdObject.add('ContentDocument');
        stdObject.add('ContentDocumentLink');
        stdObject.add('CollaborationGroupMember');
        stdObject.add('CollaborationGroupMemberRequest');
        queryFieldsSet.add('Id');
        if(additionalRowMergeFields.size() > 0){
            queryFieldsSet.addAll(additionalRowMergeFields);
        }
        queryFieldsSet.addAll(displayFieldsSet);
        String strSObjectName = dataTableObjectResult.getName();
        sObject sObjectRecord = Schema.getGlobalDescribe().get(strSObjectName).newSObject(null, true);

        addQueryFields(queryFieldsSet, dataTableDetailConfigMap,flexTableConfig,stdObject,strSObjectName);  

        for(String fieldName:queryFieldsSet){
            fieldName = fieldName.trim();
            if(fieldName.containsIgnoreCase(' Desc')){
                fieldName = fieldName.removeEndIgnoreCase(' Desc').trim();
            }
            if(fieldName.containsIgnoreCase(' Asc')){
                fieldName = fieldName.removeEndIgnoreCase(' Asc').trim();
            }

            //if(fieldName.contains('.'))
            {
                fieldName = getStandardFieldName(fieldName);    
            }
            
            String actualRelationshipField = removeRelationship(fieldName);
            if(dataObjectFieldsMap.get(actualRelationshipField) == null){
                throw new CustomExceptions.InputDataException(fieldName + ' field is not defined on ' + flexTableConfig.SobjectConfig__r.Name);
            }
            Schema.DescribeFieldResult fieldDescribe = dataObjectFieldsMap.get(actualRelationshipField.toLowerCase()).getDescribe();
            FlexGridEnhancedUtility.FieldDescribe fieldDescribeWrapper = new FlexGridEnhancedUtility.FieldDescribe(fieldDescribe);
            if(fieldDescribeWrapper.Type == 'REFERENCE'){               
                if(!stdObject.contains(flexTableConfig.SobjectConfig__r.Name)){
                   addAdditionalField(fieldName,additionalRefFieldSet);
                }

            }
            FlexGridEnhancedUtility.DataTableDetailInfo dataTableDetailWrapper = dataTableDetailConfigMap.get(fieldName) != null ? dataTableDetailConfigMap.get(fieldName) : null;
            processFieldData(fieldName, fieldDescribe, fieldDescribeWrapper, dataTableDetailWrapper, dataObjectFieldsMap, dataTableObjectType, fieldMetaData);

           
            if(fieldName.containsNone('.')){
                String fieldValue = String.valueOf(sObjectRecord.get(fieldName)); 
                if(String.isNotBlank(fieldValue)){
                    FlexGridEnhancedUtility.FieldDescribe fieldDescribeWrapperRecord = (FlexGridEnhancedUtility.FieldDescribe)(fieldMetaData.get(fieldName));
                    if(fieldDescribeWrapperRecord != null && (fieldDescribeWrapperRecord.DefaultValue != null || fieldDescribeWrapperRecord.DefaultValueFormula != null)){
                        fieldDescribeWrapperRecord.DefaultValue =  fieldValue;
                        if('Percent'.equalsIgnoreCase(fieldDescribeWrapperRecord.Type)){
                            Double percentValue = double.valueOf(fieldValue);
                            fieldDescribeWrapperRecord.DefaultValue =  String.valueOf(percentValue/100);
                        }
                    }
                }
            }


            if(fieldDescribeWrapper.Type == 'REFERENCE'){
                fieldName = validateStandardRefFields(fieldName);
            }
            tempQueryFieldsSet.add(fieldName);
        }


        queryFieldsSet.clear();
        queryFieldsSet.addAll(tempQueryFieldsSet);
        queryFieldsSet.addAll(additionalRefFieldSet);
        retVal.put('FieldMetaData',fieldMetaData);
        retVal.put('ColumnNamesList',displayFieldsSet);
        retVal.put('QueryFieldsList',queryFieldsSet);
        return retVal;
    }

     private void processFieldData(String fieldName, Schema.DescribeFieldResult fieldDescribe,
                                  FlexGridEnhancedUtility.FieldDescribe fieldDescribeWrapper,
                                  FlexGridEnhancedUtility.DataTableDetailInfo dataTableDetailWrapper,
                                  Map<String,Schema.SObjectField> dataObjectFieldsMap,
                                  Schema.SObjectType dataTableObjectType, Map<String, Object> fieldMetaDataMap){

        if(fieldDescribe.getType() == Schema.DisplayType.Reference) {
            fieldDescribeWrapper.ReferenceFieldInfo = getRefFieldMetadata(dataTableObjectType, fieldName, dataTableDetailWrapper);
        } else if(fieldDescribe.getType() == Schema.DisplayType.Picklist || fieldDescribe.getType() == Schema.DisplayType.MultiPicklist || fieldDescribe.getType() == Schema.DisplayType.Combobox){
            fieldDescribeWrapper.PickListFieldInfo = getPickListInfo(fieldDescribe, fieldDescribeWrapper);
        }
        if(fieldDescribeWrapper.Type == 'REFERENCE'){
           fieldName = validateStandardRefFields(fieldName);
        }

        fieldMetaDataMap.put(fieldName,fieldDescribeWrapper);
    }

    private Map<String,Object> processReferenceField(Schema.SObjectType sObjectType, String fieldName){
        Map <String, Object> referenceFieldInfoMap = new Map<String, Object>();
        List<String> splitFieldsList = fieldName.split('\\.',-1);
        Integer length = splitFieldsList.size();
        String referenceField = fieldName;
        if(length > 1){
            for(String splittedField : splitFieldsList){
                splittedField = splittedField .replace('__r','__c');
                referenceField = splittedField;
                if(!splittedField.equalsIgnoreCase('Name') && splittedField.containsNone('__c') && !splittedField.endsWithIgnoreCase('Id')){
                  splittedField = getStandardFieldName(splittedField);

                }
                if(!(splittedField.equals(splitFieldsList[length-1]))){
                    Schema.DescribeSObjectResult dataTableObjectResult = sObjectType.getDescribe();
                    Map<String,Schema.SObjectField> dataObjectFieldsMap = dataTableObjectResult.fields.getMap();
                    Schema.SObjectField sobjfield= dataObjectFieldsMap.get(splittedField);
                    Schema.DescribeFieldResult fieldDescribe = sObjField.getDescribe();
                    List<Schema.SObjectType> sobjTypeList = fieldDescribe.getReferenceTo();
                    sObjectType  = sobjTypeList [0];
                }
            }
        }
        referenceFieldInfoMap.put('ReferencedObject', sObjectType);
        referenceFieldInfoMap.put('ReferencedField', referenceField);
        return referenceFieldInfoMap;
    }

    private void addQueryFields(Set<String> queryFieldsSet, Map< String, FlexGridEnhancedUtility.DataTableDetailInfo> dataTableDetailConfigMap, DataTableConfig__c flexTableConfig ,List<String> stdObject,String sobjectName){
        if(!stdObject.contains(flexTableConfig.SobjectConfig__r.Name)){
            queryFieldsSet.add('LastModifiedDate');
        }
        if(String.isNotEmpty(flexTableConfig.OrderBy__c)){
            queryFieldsSet.addAll(new set<string>(flexTableConfig.OrderBy__c.split(',')));
        }
        for(String  fieldAPIName:dataTableDetailConfigMap.keySet()){
            if(fieldAPIName != null){
                FlexGridEnhancedUtility.DataTableDetailInfo dataTableDetail  =  dataTableDetailConfigMap.get(fieldAPIName);
                if(!queryFieldsSet.contains(fieldAPIName)){
                    queryFieldsSet.add(fieldAPIName);
                }
                String field = dataTableDetail.DisplayField;
                if(String.isNotEmpty(field)){
                    String refField = fieldAPIName.replace('__c','__r');
                    field = refField+'.'+field;
                    if(!queryFieldsSet.contains(field)){
                        queryFieldsSet.add(field);
                    }
                }
                List<String> hideFields = new List<String>();
                if(String.isNotEmpty(dataTableDetail.HideCellJSON)){
                     hideFields = getHideExpressionFields(dataTableDetail.HideCellJSON,sobjectName);
                     if(hideFields.size() > 0){
                        queryFieldsSet.addAll(hideFields);
                        
                    }
                }
            }
        }
    }

    private Map<String, Object>  getPickListInfo(Schema.DescribeFieldResult flexGriFieldDescribe, FlexGridEnhancedUtility.FieldDescribe fieldDescribeWrapper){
        Map<String, Object> pickListInfoMap = new Map<String, Object>();
        List<String> pickListOptions = new List<String>();
        List<Map<String,String>> pickListKeyValueMapList = new List<Map<String,String>>();
        Map<String,String> fieldPickListValueLabelMap = new Map<String,String>();
        Map<String,String> pickListKeyValueMap = new Map<String,String>();
        if (!flexGriFieldDescribe.isDefaultedOnCreate()) {                 
            if(flexGriFieldDescribe.isNillable()){
                pickListOptions.add('--None--');
                pickListKeyValueMap = new Map<String,String>();
                pickListKeyValueMap.put('Label','--None--');
                pickListKeyValueMap.put('Value','');
                pickListKeyValueMapList.add(pickListKeyValueMap);
                fieldPickListValueLabelMap.put('None','');
            } 
        }
                    for(Schema.PicklistEntry pe:flexGriFieldDescribe.getPicklistValues()){            
                            pickListOptions.add(pe.getLabel()+'');
                            pickListKeyValueMap = new Map<String,String>();
                            pickListKeyValueMap.put('Label',pe.getLabel()+'');
                            pickListKeyValueMap.put('Value',pe.getValue()+'');
                            pickListKeyValueMapList.add(pickListKeyValueMap);
                            fieldPickListValueLabelMap.put(pe.getValue()+'',pe.getLabel()+'');
                    }
        
        pickListInfoMap.put('PicklistValues',pickListOptions);
        pickListInfoMap.put('PickListKeyValueMapList',pickListKeyValueMapList);
        pickListInfoMap.put('FieldPicklistValueLabelMap',fieldPickListValueLabelMap);
        return pickListInfoMap;
    }



    private String removeRelationship(String relationshipField){
        relationshipField = relationshipField.replace('__r','__c');
        List<String> relationshipFieldList = relationshipField.split('\\.');
        relationshipField = relationshipFieldList[0];
        return relationshipField;
    }



    private String getStandardFieldLabel(String fieldLabel){
        fieldLabel = (fieldLabel.equalsIgnoreCase('CreatedById')) ? Label.CreatedBy :
                                (fieldLabel.equalsIgnoreCase('LastModifiedById')) ? Label.LastModifiedBy :
                                (fieldLabel.equalsIgnoreCase('ContactId')) ? Label.Contact :
                                (fieldLabel.equalsIgnoreCase('OwnerId')) ? Label.AssignedTo :
                                (fieldLabel.equalsIgnoreCase('RecordTypeId')) ? Label.RecordType :
                                (fieldLabel.equalsIgnoreCase('ActivityDate')) ? Label.DueDate :
                                fieldLabel;
        return fieldLabel;
    }

    private String getStandardFieldName(String fieldName){
        List<String> splitFields = fieldName.split('\\.',-1);
        List<String> resultList = new List<String>();
            for(String splittedFieldName : splitFields){
                splittedFieldName = splittedFieldName.equalsIgnoreCase('Account') ? 'AccountId' :
                splittedFieldName.equalsIgnoreCase('Owner') ? 'OwnerId' :
                splittedFieldName.equalsIgnoreCase('CreatedBy') ? 'CreatedById' :
                splittedFieldName.equalsIgnoreCase('What') ? 'WhatId' :
                splittedFieldName.equalsIgnoreCase('LastModifiedBy') ? 'LastModifiedById' :
                splittedFieldName.equalsIgnoreCase('Parent') ? 'ParentId' :
                splittedFieldName.equalsIgnoreCase('Actor') ? 'ActorId' :
                splittedFieldName.equalsIgnoreCase('Group') ? 'GroupId' :
                splittedFieldName.equalsIgnoreCase('ProcessInstance') ? 'ProcessInstanceId' :
                splittedFieldName.equalsIgnoreCase('SetupOwner') ? 'SetupOwnerId' :
                splittedFieldName.equalsIgnoreCase('Contact') ? 'ContactId' :
                splittedFieldName.equalsIgnoreCase('RecordType') ? 'RecordTypeId' :
                splittedFieldName.equalsIgnoreCase('ContentDocument') ? 'ContentDocumentId' :
                splittedFieldName.equalsIgnoreCase('LinkedEntity') ? 'LinkedEntityId' :
                splittedFieldName.equalsIgnoreCase('ContentVersion') ? 'ContentVersionId' :
                splittedFieldName.equalsIgnoreCase('CollaborationGroup') ? 'CollaborationGroupId' :
                splittedFieldName.equalsIgnoreCase('Member') ? 'MemberId' :
                splittedFieldName.equalsIgnoreCase('Requester') ? 'RequesterId' :
                splittedFieldName;
                resultList.add(splittedFieldName);
            }
        fieldName = String.join(resultList,'.');
        return fieldName;
    }
    private void addAdditionalField(String fieldName,Set<String> additionalRefFieldSet){
        String field = fieldName.toLowerCase();
        switch on field{
            when 'lastmodifiedbyid','lastmodifiedbyid.id'{
                additionalRefFieldSet.add('LastModifiedBy.Name');
            }
            when 'createdbyid','createdbyid.id'{
                additionalRefFieldSet.add('CreatedBy.Name');
            }
            when 'recordtypeid','recordtypeid.id'{
                additionalRefFieldSet.add('RecordType.Name');
            }
            when 'accountid','accountid.id'{
                additionalRefFieldSet.add('Account.Name');
            }
            when 'ownerid','ownerid.id'{
                additionalRefFieldSet.add('Owner.Name');
            }
            when 'parentid','parentid.id'{
                additionalRefFieldSet.add('Parent.Name');
            } 
            when else{
                if(field.containsNone('.')){
                    additionalRefFieldSet.add(fieldName.replace('__c','__r')+'.Name');   
                }else{
                    if(field.contains('.')){
                        String[] splittedFields = field.split('\\.');
                         if(splittedFields.size() > 1 && (field.endsWithIgnoreCase('.Id') || field.endsWithIgnoreCase('Id.Id'))){
                            if(field.endsWithIgnoreCase('Id.Id')){
                                fieldName = field.replace('id.id', '.Name');
                            } else if(field.endsWithIgnoreCase('.Id')){
                                fieldName = field.replace('.id', '.Name');
                            }
                            additionalRefFieldSet.add(fieldName);
                        } 
                    }
                }
            }
        }   
    }
    private String validateStandardRefFields(String fieldName){
        if(fieldName.contains('RecordTypeId.')){
            fieldName = fieldName.replace('RecordTypeId','RecordType');
        }
        if(fieldName.contains('ContentDocumentId.')){
            fieldName = fieldName.replace('ContentDocumentId','ContentDocument');
        }
        if(fieldName.contains('LinkedEntityId.')){
            fieldName = fieldName.replace('LinkedEntityId','LinkedEntity');
        }
        if(fieldName.contains('LastModifiedById.')){
            fieldName = fieldName.replace('LastModifiedById','LastModifiedBy');
        }
        if(fieldName.contains('CreatedById.')){
            fieldName = fieldName.replace('CreatedById','CreatedBy');
        }
        if(fieldName.contains('LinkedEntityId.')){
            fieldName = fieldName.replace('LinkedEntityId','LinkedEntity');
        }
        if(fieldName.contains('CollaborationGroupId.')){
            fieldName = fieldName.replace('CollaborationGroupId','CollaborationGroup');
        }
        if(fieldName.contains('MemberId.')){
            fieldName = fieldName.replace('MemberId','Member');
        }
        if(fieldName.contains('RequesterId.')){
            fieldName = fieldName.replace('RequesterId','Requester');
        }
        if(fieldName.contains('OwnerId.')){
            fieldName = fieldName.replace('OwnerId','Owner');
        }if(fieldName.contains('ParentId.')){
            fieldName = fieldName.replace('ParentId','Parent');
        }
        if(fieldName.contains('ProfileId.')){
            fieldName = fieldName.replace('ProfileId','Profile');
        }
        if(fieldName.contains('AccountId.')){
            fieldName = fieldName.replace('AccountId','Account');
        }
        return fieldName;
    }
    public FlexGridEnhancedUtility.FieldDescribe getRefFieldMetadata(Schema.SObjectType sobjectType,String fieldName, FlexGridEnhancedUtility.DataTableDetailInfo dataTableDetail) {
        Map<String, Object> referenceFieldInfoMap = processReferenceField( sobjectType, fieldName);
        FlexGridEnhancedUtility.FieldDescribe fieldDescribeWrapper = new FlexGridEnhancedUtility.FieldDescribe ();
        Schema.SObjectType referencedObject = (Schema.SObjectType)referenceFieldInfoMap.get('ReferencedObject');
        String referencedFieldName = String.valueOf(referenceFieldInfoMap.get('ReferencedField'));
        Schema.DescribeSObjectResult sObjDescribe = referencedObject.getDescribe();
        Map<String, Schema.SObjectField> fieldsMap = sObjDescribe.fields.getMap();
        Schema.SObjectField sObjField = fieldsMap.get(referencedFieldName);
        if(sObjField == null){
            throw new CustomExceptions.InputDataException(referencedFieldName + ' field is not defined on ' + referencedObject);
        }
        Schema.DescribeFieldResult fieldDescribe = sObjField.getDescribe();
        Map<String, Object> retVal = new Map<String, Object>();
        String csfieldName = referencedObject+'.'+referencedFieldName;
        String fieldLabel = null;
        String fieldLabelOverride =null;
        fieldLabel = getStandardFieldLabel(fieldDescribe.getLabel());
        if(dataTableDetail != null && dataTableDetail.FieldLabelOverride != null) {
            fieldLabel = dataTableDetail.FieldLabelOverride;
        }
        fieldDescribeWrapper.Label = fieldLabel;
        fieldDescribeWrapper.Name = referencedFieldName;
        fieldDescribeWrapper.Type = String.valueOf(fieldDescribe.Type);
        fieldDescribeWrapper.IsFilterable = fieldDescribe.isFilterable();
        fieldDescribeWrapper.IsUpdateable = Boolean.valueOf(fieldDescribe.isUpdateable());
        fieldDescribeWrapper.IsAutoNumber = fieldDescribe.isAutoNumber();
        fieldDescribeWrapper.IsFormulaField = fieldDescribe.isCalculated();        
        fieldDescribeWrapper.scale= fieldDescribe.getScale();
        fieldDescribeWrapper.FieldPath = fieldName;
        List<Schema.SObjectType> referenceToObjects = fieldDescribe.getReferenceTo();
        List<String> objectNames = new List<String>();
        for (Schema.SObjectType objectType : referenceToObjects) {
            objectNames.add(objectType.getDescribe().getName());
        }
        String objectName = objectNames.isEmpty() ? '' : objectNames[0];
         fieldDescribeWrapper.lookupDetails =getFlexTableLookupDetails(objectName);
        if(fieldDescribe.getType()+'' == 'PICKLIST'){
            fieldDescribeWrapper.PickListFieldInfo = getPickListInfo(fieldDescribe, fieldDescribeWrapper);
        }

        return fieldDescribeWrapper;
    }




    public Map<String,Object> executeClass(  String executeClassParamsJSON) {

        Map<String,Object> paramMap = (Map<string, Object>)JSON.deserializeUntyped(executeClassParamsJSON);
        String className = String.valueOf(paramMap.get('actionClass'));
        Map<String,Object> selectedRecordIdMap = (Map<String,Object>)paramMap.get('recordSelectionMap');
        String stringParameters = String.valueOf(paramMap.get('stringParameters'));
        Map<String,Object> keyValueMap = new Map<String,Object>();
        Map<String,String> keyValueMapForDataTable = new Map<String,String>();
        if(stringParameters != null){
           keyValueMap =(Map<String,Object>)JSON.deserializeUntyped(stringParameters);
           for(String key : keyValueMap.keySet()){
            keyValueMapForDataTable.put(key, String.valueOf(keyValueMap.get(key)));
           }
        }
        String listParameters = String.valueOf(paramMap.get('listParameters'));
        Map<String,Object> mergeFieldslistParameters = new Map<String,Object>();
        if(listParameters != null){
            mergeFieldslistParameters = (Map<string,object>)JSON.deserializeUntyped(listParameters);
        } 

        FlexGridEnhancedUtility.FlexTableActionConfig flexTableActionConfig = new FlexGridEnhancedUtility.FlexTableActionConfig();
        Map<String, Object> actionConfigMap = (Map<String, Object>)paramMap.get('action');
        String dataTableConfigName = String.valueOf(paramMap.get('tableName'));
        String URL = String.valueOf(paramMap.get('url'));
        String query = String.valueOf(paramMap.get('query'));
        String selectedRecordId = String.valueOf(paramMap.get('selectedRecordId'));
        Savepoint sp ;
        Map<String, Object> result = new Map<String, Object>();
        Map<String, Object> newUrlParamMap = new  Map<String, Object> ();
        Map<String, String> newurlParams = new Map<String, String>();
        if(keyValueMap != null){
            newUrlParamMap.putAll(keyValueMap) ;
        }
        if(keyValueMapForDataTable != null){
            newurlParams.putAll(keyValueMapForDataTable);
        }
        if(mergeFieldslistParameters != null){
            newUrlParamMap.putAll(mergeFieldslistParameters);
        }
        List<String> selectedRecordIdList = new List<String>();
        String[] classNameParts;
        Type actionClassType;

        if(actionConfigMap.get('SkipRollbackLogic') == false){
            sp = Database.setSavepoint();
        }

        try {
            if(className.contains('.')){
                classNameParts = className.split('\\.');
                actionClassType = Type.forName(classNameParts[0], classNameParts[1]);
            }else{
                actionClassType = Type.forName('', className);
            }
        } catch(Exception ex) {
            throw new CustomExceptions.InputDataException('Class not found with Name ' + className + '. Please check class name.');
        }
        
        for(String id:selectedRecordIdMap.keySet()){
            if(selectedRecordIdMap.get(id) == true){
                selectedRecordIdList.add(id);
            }
        }

        if(selectedRecordId != null){
            selectedRecordIdList.add(selectedRecordId);
        }
        
		FlexTableActionHandler  flexTableAction = (FlexTableActionHandler)actionClassType.newInstance();
        flexTableAction.selectedRecordIds = selectedRecordIdList;
        flexTableAction.actionConfigMap = actionConfigMap;
        flexTableAction.dataTableConfigName = dataTableConfigName ;
        flexTableAction.selectedRecordId = selectedRecordId;
        flexTableAction.query = query;
        if(UserInfo.getUiTheme() =='Theme4d' || UserInfo.getUiTheme() =='Theme4u' || AppUtils.isExperienceCloud()){   
            flexTableAction.lightningObject.isLightning = true;
            if(URL != null){
                newUrlParamMap.putAll( (Map<String,Object>)JSON.deserializeUntyped(URL));
                if(newUrlParamMap != null){
                    for(String key : newUrlParamMap.keySet()){
                        newurlParams.put(key, String.valueOf(newUrlParamMap.get(key)));
                    }
                }
            }
            flexTableAction.urlParamsMap = newUrlParamMap;
            flexTableAction.urlParams = newurlParams;
        }else{
            List<String> URLParamsList = URL.split('\\?',-1);
            if(URLParamsList.size() >= 2){
                String URLparams = URLParamsList[1];
                if(URLparams != null && URLparams.length() > 0){
                    URLParamsList = URLparams.split('&',-1);
                    for(String paramsMap:URLParamsList){
                        List<String> paramKeyvalue = paramsMap.split('=',-1);
                        if(paramKeyvalue.size() > 1) {
                            if(String.isNotBlank(paramKeyvalue[1]) && paramKeyvalue[1].contains('#/!') == true){
                                paramKeyvalue[1] = paramKeyvalue[1].remove('#/!');
                            }
                            newUrlParamMap.put(paramKeyvalue[0],paramKeyvalue[1]);
                            newurlParams.put(paramKeyvalue[0],paramKeyvalue[1]);
                        }
                    }
                }
            }

            flexTableAction.lightningObject.isLightning = false;
            flexTableAction.urlParamsMap = newUrlParamMap;
            flexTableAction.urlParams = newurlParams;
        }
        try
        {
            Map<String,Object> resultMap = new Map<String,Object>();
            resultMap = flexTableAction.clickHandler();

            result.put('PageURL',resultMap.get('PageReference'));
            
            result.put('Success',resultMap.get('Success'));
            result.put('Error',resultMap.get('Error'));
            result.put('Warning',resultMap.get('Warning'));
            if(resultMap.get('Type') != null){
                result.put('type',resultMap.get('Type'));
            }
             if(resultMap.get('Message') != null){
                String messg = AppUtils.handleSystemExceptionMsg(String.valueOf(resultMap.get('Message')));
                result.put('Message',messg);
            }
            if(resultMap.get('MessageConfig') != null){
                String errorCode = String.valueOf(resultMap.get('MessageConfig'));
                List<ErrorMessageConfig__c> errorMessages = new List<ErrorMessageConfig__c>();
                if(Schema.sObjectType.ErrorMessageConfig__c.isAccessible()){
                    errorMessages = [select id,Message_Type__c,Message__c,ErrorCode__c
                                                            from ErrorMessageConfig__c
                                                            Where ErrorCode__c =: errorCode WITH USER_MODE];
                }
                if(errorMessages.size() == 0) {
                    CustomExceptions.logException('Not error message config found for ' + errorCode, false);
                }
                String errMsg = Apputils.handleSystemExceptionMsg(errorMessages.get(0).Message__c);
                result.put('Message',errMsg);
                result.put('type',errorMessages.get(0).Message_Type__c);
            }
            if(resultMap.get('RefreshParentPage') != null) {
                result.put('RefreshParentPage',resultMap.get('RefreshParentPage'));
            }
        }
        catch(Exception e)
        {
            if(sp!=null){
                Database.rollback(sp);
            }
            String errMsg = Apputils.handleSystemExceptionMsg(e.getMessage());
            result.put('Error',errMsg);
        }
        return result;
    }


    public Map<String,Object> deleteRecords(String deleteRecordsParamJSON){//Map<String, List<String>> objectNameToIdsMap
        Map<String, Object> objectNameToIdsMap =  (Map<String, Object>)JSON.deserializeUntyped(deleteRecordsParamJSON);
        Map<String, Object> retVal = new Map<String, Object>();
        Integer recordCount = 0;
        try{
            for(String objectName : objectNameToIdsMap.keySet() ){
                Object o = objectNameToIdsMap.get(objectName);
                List<Object> recordIds = (List<Object>) objectNameToIdsMap.get(objectName);
                String commaSepratedRecordIds = '';
                for(Object recordId : recordIds){
                    recordCount++;
                    String recordIdStr = String.valueOf( recordId );
                    if(recordIdStr.length() == 15 || recordIdStr.length() == 18){
                        commaSepratedRecordIds += ' \''+String.escapeSingleQuotes(recordIdStr) +'\',';
                    }
                }
                commaSepratedRecordIds = commaSepratedRecordIds.subString(0, commaSepratedRecordIds.length()-1);
                if( commaSepratedRecordIds != null && commaSepratedRecordIds !='' ){
                    String query = 'SELECT Id FROM ' + String.escapeSingleQuotes(objectName) + ' WHERE Id in('+  String.escapeSingleQuotes(string.valueOf(commaSepratedRecordIds)) +')';//SOQL Injection - False +ve - commaSepratedRecordIds are also applied escapeSingleQuotes in above iteration, to prevent SOQL Injection
                    List<Sobject> sobjList = new List<Sobject>();
                    if(AppUtils.isObjectAccessible(objectName)) {
                        sobjList = Database.query(query, AccessLevel.USER_MODE);//NOPMD SOQL Injection - False +ve - Dynamic part of query is escapeSingleQuotes 
                    }
                    Schema.sObjectType objType = sobjList[0].getSObjectType();
                       new SystemContextMethodsHelper().deleteSobjectListSysContext(sobjList);
                        if(recordCount == 1){
                             retVal.put('Message','Record deleted successfully.');
                        }else{
                             retVal.put('Message','Records deleted successfully.');
                        }
                        retVal.put('Success',true);
                }
            }
        }catch(Exception e) {
                
            String errMsg = Apputils.handleSystemExceptionMsg(e.getMessage());
            retVal.put('Message',errMsg);
            retVal.put('Success',false);
            return retVal;
        }
        return retVal;
    }

    public Map<String,Object>  dataInsertion( Map<String,Object> result,
                                            String objectName,
                                            String tableId,
                                            Map<String,Object> queryFieldsMap,
                                            Map<String,String> newIdsMap,
                                            Map<String,Object> resultReturnMap,
                                            Map<String,Object> parentLookupFieldMap,
                                            Map<String, Object> updatedRowsMap){
        List<String> updatedIdList = new List<String>();
        List<Sobject> sobjListToInsert = new  List<Sobject>();
        List<Sobject> sobjListToUpdate = new  List<Sobject>();
        Map<String,Sobject> newRecordsMap = new Map<String,Sobject>();
        Map<String,Sobject> updatedRecordsMap = new Map<String,Sobject>();
       
        try{
            createMap(newRecordsMap, updatedRecordsMap, updatedRowsMap, objectName, tableId, sobjListToInsert, sobjListToUpdate, newIdsMap, parentLookupFieldMap);
            if(AppUtils.isObjectUpdateable(objectName)){//CRUD/FLS False +ve as we are performing action on Sobject CRUD we have verified with the help of other class
            	Database.SaveResult[] srList1 = Database.update(updatedRecordsMap.values(),true, AccessLevel.USER_MODE);
	            for (Database.SaveResult sr : srList1) {
	                if (sr.isSuccess()) {
	                     updatedIdList.add(sr.getId());
	                }else{
	                    String mssg = '';
	                    for(Database.Error err : sr.getErrors()) {
	                        result.put('Success',false);
	                        mssg = err.getMessage();
	                        mssg = AppUtils.handleSystemExceptionMsg(mssg);
	                        result.put ('Message',mssg);
	                    }
	                }
	            }
            }
            if(AppUtils.isObjectCreateable(objectName)){  //CRUD/FLS False +ve as we are performing action on Sobject CRUD we have verified with the help of other class
	            Database.SaveResult[] srList2 = Database.insert(newRecordsMap.values(), true, AccessLevel.USER_MODE);
	            for (Database.SaveResult sr : srList2) {
	                if (sr.isSuccess()) {
	                     updatedIdList.add(sr.getId());
	                }else{
	                    String mssg = '';
	                    for(Database.Error err : sr.getErrors()) {
	                        result.put('Success',false);
	                        mssg = err.getMessage();
	                        mssg = AppUtils.handleSystemExceptionMsg(mssg);
	                        result.put ('Message',mssg);
	                    }
	                }
	            }
	
	            if(result.get('Success') == false){
	                if(sp != null){
	                    Database.rollback( sp );
	                }
	                return result;
	            }
            }
            
            List<sObject> sobj1List = new List<sObject>();
            List<Object> queryFieldsList = (List<Object>)queryFieldsMap.get(tableId);
            Set<String> queryFieldsSet = new Set<String>();
            for(Object field:queryFieldsList){
                queryFieldsSet.add(String.valueOf(field));
            }
            QueryBuilder queryBuilder = new QueryBuilder();
            sobj1List = queryBuilder.addFields(String.join(new List<String>(queryFieldsSet),','))
                                         .setsObject(objectName)
                                         .addFilter('Id IN (\'' + String.join(updatedIdList,'\',\'') + '\')')
                                         .createQuery()
                                         .execute();
            for(Sobject sobj : sobj1List){
                for(String tmpId: newRecordsMap.keySet()){
                    if(newRecordsMap.get(tmpId).Id == sobj.Id){
                        newRecordsMap.put(tmpId,sobj);
                        newIdsMap.put(tmpId,String.valueOf(sobj.get('Id')));
                    }
                }
            }


            for(Sobject sobj : sobj1List){
                if(updatedRecordsMap.get(sobj.Id) != null){
                    updatedRecordsMap.put(sobj.Id,sobj);
                }
            }
            Map<String,Map<String,sobject>> resultUpdatedMap = new Map<String,Map<String,sobject>>();
            resultUpdatedMap.put('updatedRecordsMap',updatedRecordsMap);
            resultUpdatedMap.put('newRecordsMap',newRecordsMap);
            resultReturnMap.put(tableId,resultUpdatedMap);
            result.put('result',resultReturnMap);
            result.put('Success',true);
        }catch(Exception e) {
            result.put('Success',false);
            String message = '';
            if(AppUtils.isLightningTheme() || AppUtils.getCommunityBaseUrl() != null){
               message = e.getMessage();
               message = AppUtils.handleSystemExceptionMsg(message);
           }else{
            if(Apexpages.getMessages() != null && Apexpages.getMessages().size() > 0) {
                for(Apexpages.Message msg : Apexpages.getMessages()) {
                    if(msg.getSeverity() == ApexPages.Severity.ERROR || msg.getSeverity() == ApexPages.Severity.FATAL){
                        message += msg.getSummary() + '<br/>';
                        message = message.replace('[','');
                        message = message.replace(']','');
                    }
                }
            } else {
                message = e.getMessage();
                if(message.contains('Cannot deserialize instance of date from VALUE_STRING value Invalid Date or request may be missing a required field')){
                    message = message.replace('Cannot deserialize instance of date from VALUE_STRING value Invalid Date or request may be missing a required field', 'Invalid Date Field Entered.');
                }
                message = AppUtils.handleSystemExceptionMsg(message);
            }
        }
            result.put('Message',message);
            if(sp != null){
                Database.rollback( sp );
            }
        }
        return result;
    }

    public void createMap(Map<String,Sobject> newRecordsMap,
                            Map<String,Sobject> updatedRecordsMap,
                            Map<String, Object> updatedRowsMap,
                            String objectName,
                            String tableId,
                            List<Sobject> sobjListToInsert,
                            List<Sobject> sobjListToUpdate,
                            Map<String,String> newIdsMap,
                            Map<String,Object> parentLookupFieldMap){
        List<Object> updatedRowList = (List<Object>)updatedRowsMap.get(tableId);

            for(Integer i = 0; i < updatedRowList.size() ; i++){
                String recordJson = JSON.serialize(updatedRowList[i]);
                Sobject record = (Sobject)JSON.deserializeStrict(SFDCEncoder.sanitizeJSON(recordJson),Type.forName(objectName)); // false+ for Deserializing objects from an untrusted source is security-sensitive as sanitizing it by using SFDCEncoder.sanitizeJSON
                String recordId = String.valueOf(record.get('Id'));
                if(recordId.length() != 15 && recordId.length() != 18){
                    sobjListToInsert.add(record);
                }else{
                    sobjListToUpdate.add(record);
                }
            }


            for(Sobject sobj: sobjListToInsert){
                Sobject tmpsobj = sobj;
                String tmpId = tmpsobj.Id;
                String parentTmpId = '';
                if(parentLookupFieldMap.get(tableId) != null){
                    parentTmpId = String.valueOf(tmpsobj.get(String.valueOf(parentLookupFieldMap.get(tableId))));
                }
                if(newIdsMap.get(parentTmpId) != null){
                    tmpsobj.put('Id',null);
                    tmpsobj.put(String.valueOf(parentLookupFieldMap.get(tableId)),newIdsMap.get(parentTmpId));
                }else{
                    tmpsobj.put('Id',null);
                }
                newRecordsMap.put(tmpId,tmpsobj);
            }

            for(Sobject sobj: sobjListToUpdate){
                updatedRecordsMap.put(sobj.Id,sobj);
            }
    }

    public  Map<String,Object> saveRecords(String saveRecordsMapJSON){
        Map<String, Object> saveRecordsParamMap=  (Map<String, Object>)JSON.deserializeUntyped(saveRecordsMapJSON);
        Map<String, Object> updatedRowsMap = (Map<String, Object>)saveRecordsParamMap.get('saveRecordsMap');
        Map<String, Object> tableObjectsMap = (Map<String, Object>)saveRecordsParamMap.get('tableObjectsMap');
        Map<String, Object> levelVsTableIdMap = (Map<String, Object>)saveRecordsParamMap.get('levelVsTableIdMap');
        Map<String, Object> parentLookupFieldMap = (Map<String,Object>)saveRecordsParamMap.get('parentLookupFieldMap');
        Map<String, Object> queryfieldsMap = (Map<String,Object>)saveRecordsParamMap.get('queryfieldsMap');
        Map<String,Object> result = new Map<String,Object>();
        Map<String,String> newIdsMap = new Map<String,String>();
        Map<String,object> resultReturnMap = new Map<String,Object>();


        sp = Database.setSavepoint();
        for(String tableLevel: tableObjectsMap.keySet()){
            String sobjectName = String.valueOf(tableObjectsMap.get(tablelevel));
            String tableId = String.valueOf(levelVsTableIdMap.get(tableLevel));
            if(updatedRowsMap.get(tableId)!= null){
                dataInsertion(result, sobjectName, tableId, queryfieldsMap, newIdsMap, resultReturnMap, parentLookupFieldMap, updatedRowsMap);
            }
        }
        return result;
    }


    // Enhanced
    public Map<String,Object> fetchLookUpData(String fetchLookupParamJSON){
        Map<String,Object> paramMap = (Map<string, Object>)JSON.deserializeUntyped(fetchLookupParamJSON);
        String fieldName = (String) paramMap.get('refField');
        String displayField = (String) paramMap.get('displayField');
        String sobjName = (String) paramMap.get('sobjectName');
        String searchTerm = (String) paramMap.get('searchTerm');
        String filterClause = (String) paramMap.get('filterClause');
        if(String.isNotEmpty(displayField)){
            fieldName = displayField;
        }
        Map<String, Object> result = new Map<String, Object>();
        String nameSpace = AppUtils.getNamespacePrefix();
        String queryString;
        if(searchTerm != null && searchTerm != ''){
            filterClause = filterClause == null | filterClause == '' ? '' : ' AND ' + AppUtils.parseWhereClause(filterClause);
            queryString = 'SELECT ID, ' + string.escapeSingleQuotes(fieldName) + ' FROM ' + string.escapeSingleQuotes(sobjName) + ' WHERE ' + string.escapeSingleQuotes(fieldName) + ' LIKE \'%' + string.escapeSingleQuotes(searchTerm) + '%\'' + filterClause +  ' ORDER BY ' + string.escapeSingleQuotes(fieldName) + ' ASC LIMIT 1000';
        }else{
            filterClause = filterClause == null || filterClause == '' ? '': ' WHERE ' + AppUtils.parseWhereClause(filterClause);
            queryString = 'SELECT ID, ' + string.escapeSingleQuotes(fieldName) + ' FROM ' + string.escapeSingleQuotes(sobjName) + filterClause +  ' ORDER BY ' + string.escapeSingleQuotes(fieldName) + ' ASC LIMIT 1000';
        }
        List<FlexGridEnhancedUtility.LookupData> sobjList = new List<FlexGridEnhancedUtility.LookupData>();
        Set<String> uniqueValuesSet = new Set<String>();
        if(AppUtils.isObjectAccessible(sobjName)) {
            for( Sobject sObj : Database.query(queryString, AccessLevel.USER_MODE)){ //NOPMD SOQL Injection - False +ve - Dynamic parts of the query String is escapeSingleQuotes and filterClause value are also escapeSingleQuotes in AppUtils.parseWhereClause method to prevent SOQL Injection 
                List<String> fieldNameSplit = fieldName.split('\\.',-1);
                Integer i = 0;
                String idVal = (String)sObj.get('Id');
                do{
                    if(i == fieldNameSplit.size() - 1){
                        String value = (String)sObj.get(fieldNameSplit[i]);
                        if(uniqueValuesSet.contains(value) == false){
                            sobjList.add(new FlexGridEnhancedUtility.LookupData(idVal,value));
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
    public Map<String,Object> getOverAllTotal(String overAllTotalJSON){     
        Map<String, Object> overAllTOtalValueMap = new Map<String, Object>();   
        Map<String,Object> paramMap = (Map<string, Object>)JSON.deserializeUntyped(overAllTotalJSON);
        Map<String,Object> result = new Map<String,Object>();
        List<String> columnList = new List<String>();
        List<Object> lstExpressions  = new List<Object>();
        String sObjectName = (String)paramMap.get('sObjectName');
        for(Object column : (List<Object>)paramMap.get('columnList')){
            String col = (String)column;
            columnList.add(col);
        }

        Object filterClauseObject = paramMap.get('filterClause');
        Map<String,Object> filterCriteriaMap = (Map<String,Object>)filterClauseObject;

        Map<String,Object> hideExpressionRecordMap = (Map<String,Object>)paramMap.get('hideExpressionRecordList');
        for(String columnName : columnList){
            String filterCriteria = (String)filterCriteriaMap.get(columnName);
            list<String> hideExpressionRecordList = new list<String>();

            if(hideExpressionRecordMap != null){
                lstExpressions = (List<Object>)hideExpressionRecordMap.get(columnName);
                if(lstExpressions!= null && !lstExpressions.isEmpty()){
                    filterCriteria = String.isNotBlank(filterCriteria) ? filterCriteria + ' AND Id NOT IN (' : ' Id NOT IN (';

                    for(Object hideRecordIdList : lstExpressions){
                      filterCriteria = filterCriteria + '\'' + (String)hideRecordIdList + '\' ,';
                    }

                    filterCriteria = lstExpressions.isEmpty() ? filterCriteria : filterCriteria.removeEnd(',') + ' )';
                }
            }

            QueryBuilder queryBuilder = new QueryBuilder();
            List<sobject> lstFlexRecords  = (List<Sobject>)queryBuilder
                                                .addFields(' Sum(' + columnName + ') ')
                                                .setsObject(string.escapeSingleQuotes(sObjectName))
                                                .addFilter(string.valueOf(filterCriteria))
                                                .createQuery()
                                                .execute();

            overAllTOtalValueMap.put(columnName, lstFlexRecords[0].get('expr0') != null ? lstFlexRecords[0].get('expr0') : 0);
        }
        result.put('overAllTOtalValues',overAllTOtalValueMap);

        return result;
    }
	
	private List<FlexGridEnhancedUtility.FlexTableUserListView> getFlexTableUserListView(String flexTableId, String UserId){
        List<FlexGridEnhancedUtility.FlexTableUserListView> flexTableUserListViewList = new List<FlexGridEnhancedUtility.FlexTableUserListView>();
        List<FlexTableListViewUserConfig__c> flexTableUserListViewRecords = new List<FlexTableListViewUserConfig__c>();
        if(FlexTableListViewUserConfig__c.sObjectType.getDescribe().isAccessible() == true) {
            QueryBuilder queryBuilder = new QueryBuilder();
            flexTableUserListViewRecords = queryBuilder.addFields(FlexGridfactory.getFlexTableUserListView())
                                         .setsObject('FlexTableListViewUserConfig__c')
                                         .addFilter('FlexTableConfig__c = \'' + String.escapeSingleQuotes(flexTableId) + '\''+'AND User__c = \''+String.escapeSingleQuotes(UserId)+'\'')
                                         .createQuery()
                                         .execute();
            }
            for(FlexTableListViewUserConfig__c flexTableUserListView :flexTableUserListViewRecords){



               FlexGridEnhancedUtility.FlexTableUserListView flexUserListView = new FlexGridEnhancedUtility.FlexTableUserListView(flexTableUserListView);
              



               flexTableUserListViewList.add(flexUserListView);
            }
        return  flexTableUserListViewList;
    }

    private List<FlexGridEnhancedUtility.FlexTableLookupDetail> getFlexTableLookupDetails(String SobjectApiName){
        List<FlexGridEnhancedUtility.FlexTableLookupDetail> flexTableLookupDetail = new List<FlexGridEnhancedUtility.FlexTableLookupDetail>();
        if(SobjectApiName != '' ){
        List<SobjectConfig__c> flexTableLookupData = new List<SobjectConfig__c>();
        String apiname='SampleObject1__c';
        if(SobjectConfig__c.sObjectType.getDescribe().isAccessible() == true) {
            QueryBuilder queryBuilder = new QueryBuilder();
            flexTableLookupData          = queryBuilder.addFields(FlexGridfactory.getFlexTableLookupDetails())
                                         .setsObject('SobjectConfig__c')
                                         .addFilter('Name = \'' + String.escapeSingleQuotes(SobjectApiName)+ '\'')
                                         .createQuery()
                                         .execute();
            }
            for(SobjectConfig__c flexTableLookuo :flexTableLookupData){



               FlexGridEnhancedUtility.FlexTableLookupDetail flexTableLookuprecord = new FlexGridEnhancedUtility.FlexTableLookupDetail(flexTableLookuo);
              



               flexTableLookupDetail.add(flexTableLookuprecord);
            }
        }
        return  flexTableLookupDetail;
    } 
    public Map<String,Object> searchWithAllRecord(String paramsJson){
        Map<String, Object> returnMap = new Map<String, Object>();
        Map<Id,SObject> lstFlexRecords;
        // 1. Initialize the initparams class
        FlexGridEnhancedUtility.RecordParams params = new FlexGridEnhancedUtility.RecordParams(paramsJson);
        QueryBuilder queryBuilder =  new QueryBuilder();
        if(params.filterCriteria != null && (params.sObjectName == 'ContentVersion' || params.sObjectName == 'ContentNote')){
            params.filterCriteria = replaceFileMergeFields(params.filterCriteria, params.parentRecordId); 
        }  
         // 2. Check search text present
        if(params.enhancedSearchText != null && params.enhancedSearchText !=''){
            isSearchTable = true;
            searchText = params.enhancedSearchText;
        }   
        if(isSearchTable == true){
            String query = 'FIND \''+String.escapeSingleQuotes(searchText)+'*\' IN ALL FIELDS RETURNING '+ String.escapeSingleQuotes(params.sObjectName);
            List<List<sobject>> lstFlexRecords1 = Search.Query(query,AccessLevel.USER_MODE);//SOQL/SOSL Injection - False +ve - Dynamic part of query string is escapeSingleQuotes 
            lstFlexRecords = new Map<Id,SObject>(lstFlexRecords1[0]);
        }else{
            String nullOrder = params.sortDirection == 'ASC' ? 'FIRST' : 'LAST';
            lstFlexRecords  = (Map<Id,SObject>)new QueryBuilder()
                                                .addFields(params.queryFieldsList)
                                                .setsObject(params.sObjectName)
                                                .addFilter(params.filterCriteria)
                                                .setSortField(params.sortableColumn)
                                                .setOrder(params.sortDirection)
                                                .setLimit(params.limitValue)
                                                .setOffset(params.pageSize)
                                                .setGroupBy(params.GroupByCluase)
                                                .createQuery()
                                                .execute('Map');
        }  
        returnMap.put('RecordsList', lstFlexRecords.values());
        returnMap.put('ApprovalLockedRecordsMap', Approval.isLocked(new List<Id>(lstFlexRecords.keySet())));      
        return returnMap;

    }

}