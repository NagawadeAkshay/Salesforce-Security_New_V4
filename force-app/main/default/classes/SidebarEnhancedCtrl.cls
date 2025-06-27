/*
    Controller for SidebarEnhanced component.
    
    ****************************************************************************************
    Audit History
    ****************************************************************************************
    10-07-2018      Tomy Pallissery        Created
	24-08-2018      Tomy Pallissery        Added support for collapsed state persist
    10-08-2018      Yogeshkumar Gaikwad    Added support of Name Display Field for Recently View
    ****************************************************************************************
*/
global with sharing class SidebarEnhancedCtrl {
    //No changes needed
    public String govGrants {
        get{
            govGrants= AppUtils.getIcons('GovGrants');
            return govGrants;
        }
        set;
    }
    @AuraEnabled(cacheable=true)
    public static Boolean isCommunitySiteUser(){
        if(Network.getNetworkId()!=null){
            return true;
        }else{
            return false;
        }
    }
    @AuraEnabled(cacheable=true)
    public static object getTabName(String PhaseName) {
        return null;
    }
    
    public static String getTabNameFromRecordPage(String SobjectName,string recID) {
        set<string> AppNameSet = new set<string>();  //      <MetaData> Can be Added here;
        SobjectName = SobjectName.length() != -1 &&  !String.isblank(SobjectName) ? SobjectName :  Id.valueOf(recID).getSObjectType().getDescribe().getName();    
        if(!AppUtils.isExperienceCloud()){    
            UserAppInfo userAppInfo;
            AppDefinition appDefinition;
            if(Schema.sObjectType.userAppInfo.isAccessible() && Schema.sObjectType.appDefinition.isAccessible()){
                userAppInfo = [SELECT Id, AppDefinitionId FROM UserAppInfo WHERE UserId = :UserInfo.getUserId() WITH USER_MODE LIMIT 1];
                appDefinition = [SELECT DurableId, Label,Utilitybar, DeveloperName, MasterLabel  FROM AppDefinition Where DurableId = :userAppInfo.AppDefinitionId WITH  USER_MODE LIMIT 1 ];
                if(appDefinition.DeveloperName.length() != -1 &&  !String.isblank(appDefinition.DeveloperName)){
                    AppNameSet.add(appDefinition.DeveloperName);
                }
            }
        }else{
            UserPreferences__c userPref = UserPreferences__c.getInstance();
             String activeApp = userPref != null ? CustomAppConfig__c.getValues(userPref.ActiveAppName__c).name : '';
            AppNameSet.add(activeApp);
        }
        
        List<SObjectPhaseConfig__c> SobjphaseConfig  = new list<SObjectPhaseConfig__c>();
        if(!String.isEmpty(SobjectName)){
            if(Schema.sObjectType.SObjectPhaseConfig__c.isAccessible()){
                SobjphaseConfig = [SELECT Id, PhaseConfig__r.Name,PhaseConfig__r.TabName__c, PhaseConfig__r.CustomAppName__c,SObjectConfig__r.Name FROM SObjectPhaseConfig__c
                            WHERE SObjectConfig__r.Name =:SobjectName AND HighlightPhase__c = true and   PhaseConfig__r.CustomAppName__c IN: AppNameSet WITH USER_MODE];
            }
        }
        if(SobjphaseConfig.size() == 0) {
            return '';
        }
        if(SobjphaseConfig.size() > 1) {
            CustomExceptions.logException('Please configure only single record for App: ' + appDefinition.Label + ' SObject : ' + SobjectName + ' with Highlight Phase checked.' , false);
        }               
        return SobjphaseConfig[0].PhaseConfig__r.Name;
     }
     
     public static String getUserProfileName() {
        String userProfileId = UserInfo.getProfileId();
        Profile userProfile = [SELECT Id, Name FROM Profile WHERE Id = :userProfileId LIMIT 1]; //NOPMD CRUD/FLS False +ve As per business scenario we can't check for portal/external users
        return userProfile.Name;
    }


    @RemoteAction @AuraEnabled(cacheable=true)
    global static Map<String, Object> fetchComponents(Map<String, Object> parameterMap) {
        UserPreferences__c userPref = UserPreferences__c.getInstance();
        String sidebarCollapseCache = userPref != null ? userPref.SidebarCollapsedCache__c : '';
        String activeApp;
        String loggedInUserprofile;
       if(AppUtils.isLightningTheme()){    
            if(Schema.sObjectType.userAppInfo.isAccessible() && Schema.sObjectType.appDefinition.isAccessible()){
                list<UserAppInfo> userAppInfo = [SELECT Id, AppDefinitionId FROM UserAppInfo WHERE UserId = :UserInfo.getUserId() WITH USER_MODE LIMIT 1];
                if (!userAppInfo.isEmpty()){
                    list<AppDefinition> appDefinition = [SELECT DurableId, Label,Utilitybar, DeveloperName, MasterLabel  FROM AppDefinition Where DurableId = :userAppInfo[0].AppDefinitionId WITH  USER_MODE LIMIT 1 ];
                    activeApp = appDefinition[0].DeveloperName.length() != -1 &&  !String.isblank(appDefinition[0].DeveloperName) ? appDefinition[0].DeveloperName : '';
                }
            }
            
            loggedInUserprofile = getUserProfileName();
        }else{
            activeApp = userPref != null ? CustomAppConfig__c.getValues(userPref.ActiveAppName__c).name : '';
            loggedInUserprofile = userPref != null ? userPref.ProfileName__c : '';
        }

        String currentPhase = getActivePhase(parameterMap, activeApp);
        Map<String, Object> configurationMap = new Map<String, Object>();

        List<PhaseConfig__c> phaseConfigList;
        if(Schema.sObjectType.PhaseConfig__c.isAccessible()) {
            phaseConfigList = [SELECT SidebarComponentSequence__c, Name,
                                                            EnableMenu__c, EnableBIAnalytics__c, EnableCollab__c, 
                                                            EnableSidebarTaskMenu__c, EnableRecentlyViewed__c, EnableSearch__c,
                                                            EnableExternalLinks__c, Enable_Technical_Support__c,TabName__c,
                                                            AccordionHeader__c, SidebarBIAnalyticsMenuLabel__c, SidebarCollabMenuLabel__c, 
                                                            SidebarTaskMenuLabel__c, SidebarRecentlyViewedLabel__c, SidebarSearchLabel__c, 
                                                            SidebarExternalLinksLabel__c, SidebarTechnicalSupportLabel__c, SearchResultPage__c
                                                    FROM PhaseConfig__c 
                                                    WHERE Name =:currentPhase WITH USER_MODE];
        }
        if(phaseConfigList.size() == 0) {
            return configurationMap; 
        }

        configurationMap = getActiveComponents(phaseConfigList[0]);
        configurationMap.put('loggedInUserProfile', loggedInUserprofile);
		configurationMap.put('tabName', phaseConfigList[0].TabName__c);
        configurationMap.put('currentPhase', currentPhase);
        configurationMap.put('searchResultPage', phaseConfigList[0].SearchResultPage__c);

        configurationMap.put('collapsedArray', new Set<String>());
        if(String.isNotEmpty(sidebarCollapseCache)) {
            ((Set<String>)configurationMap.get('collapsedArray')).addAll(sidebarCollapseCache.split(','));
        }

        Set<String> activeTypes = (Set<String>)configurationMap.get('types');

        configurationMap.putAll(getAccordionHierarchy(currentPhase, loggedInUserprofile, activeTypes));
        KeyValueHolder__mdt objMetadataHolder = KeyValueHolderHelper.getKeyValueHolder('EnableLWC');    
        boolean isEnableLWC = false;
        if(objMetadataHolder != null && objMetadataHolder.BooleanValue__c){
            if(objMetadataHolder.TextValue__c.contains('sideBar')){
                isEnableLWC = true;
            } 
        }
       if(AppUtils.isLightningTheme() || AppUtils.isExperienceCloud()){ 
            isEnableLWC = true;
        }
        configurationMap.put('isEnableLWC', isEnableLWC);
        return configurationMap;
    }

    @RemoteAction @AuraEnabled(cacheable=true)
    global static List<ExternalLinkConfig__c> fetchExternalLinks(Map<String, Object> parameterMap) {
        String currentPhase = String.valueOf(parameterMap.get('currentPhase'));

        List<ExternalLinkConfig__c> externalLinks;
        if(Schema.sObjectType.ExternalLinkConfig__c.isAccessible()) {
            externalLinks = [SELECT Id, Name , PhaseConfig__c, Active__c,Sequence__c,Lightning_Target_URL__c,OpenNewWindow__c, URL__c 
                                                    FROM ExternalLinkConfig__c 
                                                    WHERE Active__c = true AND PhaseConfig__r.Name = :currentPhase
                                                    WITH USER_MODE ORDER BY Sequence__c ASC];
        }   
        return externalLinks;
    }

    @RemoteAction @AuraEnabled(cacheable=true)
    global static List<TechnicalLinkConfig__c> fetchTechSupportLinks(Map<String, Object> parameterMap) {
        String currentPhase = String.valueOf(parameterMap.get('currentPhase'));
        String loggedInUserprofile = String.valueOf(parameterMap.get('loggedInUserProfile'));

        List<TechnicalLinkConfig__c> technicalSupportLinks;
        if(Schema.sObjectType.TechnicalLinkConfig__c.isAccessible()) {
            technicalSupportLinks = [SELECT Id, Name, PhaseConfig__c, Active__c, OpenNewWindow__c,Sequence__c, URL__c,Lightning_Target_URL__c
                                                              FROM TechnicalLinkConfig__c 
                                                              WHERE Active__c = true 
                                                              AND PhaseConfig__r.Name = :currentPhase 
                                                              AND HideForProfiles__c EXCLUDES (:loggedInUserprofile)
                                                              WITH USER_MODE];
        }
        return technicalSupportLinks;
    }

    

    // This method is deprecated and has been replace by fetchRecentlyViewedWrapper method
    @RemoteAction @AuraEnabled(cacheable=true)
    global static List<RecentlyViewed> fetchRecentlyViewed(Map<String, Object> parameterMap) {
        return null;
    }

    // This method is introduced to render recently viewed records section with support of Name Dipslay Field of sobject config level 
    @RemoteAction @AuraEnabled(cacheable=true)
    global static List<RecentlyViewedWrapper> fetchRecentlyViewedWrapper(Map<String, Object> parameterMap) {
        return null;        
    }

    @RemoteAction @AuraEnabled(cacheable=true)
    global static Map<String, Object> fetchGlobalSearchConfig(Map<String, Object> parameterMap) {
        return null;
    }

    @RemoteAction @AuraEnabled(cacheable=true)
    global static List<SObject> fetchSearchTypeAheadRecords(Map<String, Object> parameterMap) {
        return null;
    }

    @RemoteAction
    global static Map<String, Object> fetchMiniLayout(Id referenceId) {
        return MiniLayoutController.getLayout(referenceId);
    }

    @RemoteAction @AuraEnabled
    global static void updateCollapsedState(String id, String type, Boolean isCollapsed) {
        String sidebarCollapseCache = UserPreferenceHelper.getStringValue('SidebarCollapsedCache__c');
        Set<String> headerSet = new Set<String>();
        List<String> headerList = new List<String>();
        Set<String> componentSet = new Set<String>();
        List<String> componentList = new List<String>();

        if(String.isNotEmpty(sidebarCollapseCache)) {
            List<String> lstSplit = sidebarCollapseCache.split(',');

            for(String idInLoop : lstSplit) {
                if(idInLoop.length() > 1) {
                    headerSet.add(idInLoop);
                } else {
                    componentSet.add(idInLoop);
                }
            }

            if(type == 'header') {
                if(isCollapsed) {
                    headerSet.add(id);
                    headerList.addAll(headerSet);
                    if(headerList.size() > 12) {
                        headerList.remove(0);
                    }
                } else {
                    headerSet.remove(id);
                    headerList.addAll(headerSet);
                }
            } else {
                headerList.addAll(headerSet);
            }

            if(type == 'component') {
                if(isCollapsed) {
                    componentSet.add(id);
                    componentList.addAll(componentSet);
                    if(componentList.size() > 10) {
                        componentList.remove(0);
                    }
                } else {
                    componentSet.remove(id);
                    componentList.addAll(componentSet);
                }
            } else {
                componentList.addAll(componentSet);
            }

            String cacheString = String.join(componentList, ',') + ',' + String.join(headerList, ',');
            UserPreferenceHelper.setStringValue('SidebarCollapsedCache__c', cacheString);

        } else if(isCollapsed) {
            UserPreferenceHelper.setStringValue('SidebarCollapsedCache__c', id);
        }
    }
    
    private static Map<String, Object> getAccordionHierarchy(String phaseName, String loggedInUserProfile, Set<String> activeTypes) {
        Map<String, Object> configurationMap = new Map<String, Object>();
        list<String> headerIdList = getAccordionHeader(phaseName, activeTypes);
        List<AccordionContent__c> contentList;
        if(Schema.sObjectType.AccordionContent__c.isAccessible()) {
            contentList = [SELECT Id, Name, RecordType.Name, RecordType.DeveloperName, 
                    DataTableConfig__r.Name,FlexGridConfig__r.Name, FlexTableParameters__c, AccordionSubHeader__c,
                    DataTableConfig__r.Header__c, Active__c, Sequence__c, Availableforprofiles__c,
                    Link__c, OpenInNewWindow__c, FlexTableHeader__c, TaskSummaryAPI__c, SobjectNames__c,
                    AccordionSubHeader__r.Id, AccordionSubHeader__r.Name, AccordionSubHeader__r.Hide__c, 
                    AccordionSubHeader__r.AccordionHeader__c, AccordionSubHeader__r.Active__c, AccordionSubHeader__r.Sequence__c,
                    AccordionSubHeader__r.AccordionHeader__r.Id, AccordionSubHeader__r.AccordionHeader__r.Name, 
                    AccordionSubHeader__r.AccordionHeader__r.Active__c, AccordionSubHeader__r.AccordionHeader__r.Sequence__c, 
                    AccordionSubHeader__r.AccordionHeader__r.IconCSS__c, AccordionSubHeader__r.AccordionHeader__r.Type__c,
                    AccordionSubHeader__r.AccordionHeader__r.PhaseConfig__r.Name,Target_Lightning_URL__c
            FROM AccordionContent__c 
            WHERE Active__c = true AND AccordionSubHeader__r.Active__c = true
            AND AccordionSubHeader__r.AccordionHeader__c IN :headerIdList
            AND Availableforprofiles__c INCLUDES (:loggedInUserProfile) WITH USER_MODE];
        }
        Set<Id> visitedHeadersSet = new Set<Id>();
        Set<Id> visitedSubHeadersSet = new Set<Id>();
        List<AccHeaderWrapper> headersList = new List<AccHeaderWrapper>();
        Map<String, Object> linkParamMap = new Map<String, Object>();
        Map<Id, List<AccSubHeaderWrapper>> headerSubHeaderMap = new Map<Id, List<AccSubHeaderWrapper>>();
        Map<Id, List<AccContentWrapper>> subHeaderContentMap = new Map<Id, List<AccContentWrapper>>();

        if(contentList.size() > 0) {
            linkParamMap = getLinkParameters();
        }

        for(AccordionContent__c content : contentList) {
            if(subHeaderContentMap.get(content.AccordionSubHeader__c) == null) {
                subHeaderContentMap.put(content.AccordionSubHeader__c, new List<AccContentWrapper>());
            }
            subHeaderContentMap.get(content.AccordionSubHeader__c).add(new AccContentWrapper(content, linkParamMap));


            if(visitedSubHeadersSet.contains(content.AccordionSubHeader__c) == false) {
                visitedSubHeadersSet.add(content.AccordionSubHeader__c);

                if(headerSubHeaderMap.get(content.AccordionSubHeader__r.AccordionHeader__c) == null) {
                    headerSubHeaderMap.put(content.AccordionSubHeader__r.AccordionHeader__c, new List<AccSubHeaderWrapper>());
                }
                headerSubHeaderMap.get(content.AccordionSubHeader__r.AccordionHeader__c).add(new AccSubHeaderWrapper(content.AccordionSubHeader__r));
            }

            if(visitedHeadersSet.contains(content.AccordionSubHeader__r.AccordionHeader__c) == false) {
                visitedHeadersSet.add(content.AccordionSubHeader__r.AccordionHeader__c);
                headersList.add(new AccHeaderWrapper(content.AccordionSubHeader__r.AccordionHeader__r));
            }
        }
        configurationMap.put('headers', headersList);
        configurationMap.put('subheaders', headerSubHeaderMap);
        configurationMap.put('contents', subHeaderContentMap);
        return configurationMap;
    }

    /*Prajakta:Below code is used to support expression Json in Accordion Header.
    If hideResult returns true then it will render the header and by deafult if HideExpressionJSON__c is empty then also it will render header.*/
    
    private static List<String> getAccordionHeader(String phaseName,Set<String> activeTypes) {
        List<AccordionHeader__c> headerList;
        if(Schema.sObjectType.AccordionHeader__c.isAccessible()) {
            headerList = [Select HideExpressionJSON__c from AccordionHeader__c 
                                                Where Active__c = true AND PhaseConfig__r.Name = :phaseName 
                                                AND Type__c IN :activeTypes WITH USER_MODE];
        }
        List<Sobject> sobjectList = new List<Sobject>();
        //headerIdList contains id of accordion header.
        list<String> headerIdList = new list<String>();
        for(AccordionHeader__c header : headerList){
             if(String.isNotEmpty(header.HideExpressionJSON__c)){
                Boolean renderCondtion = ExpressionJsonEvaluator.evaluateExpression(header.HideExpressionJSON__c, sobjectList, 'View');
                if(renderCondtion != null && renderCondtion == true){
                 headerIdList.add(header.id);   
                }
             }else{
                headerIdList.add(header.id); 
             }


        }
        return headerIdList;

    }

    
    private static String getActivePhase(Map<String, Object> parameterMap, String activeApp) {
        String currentPhase = String.valueOf(parameterMap.get('urlTabName'));
        if(String.isEmpty(currentPhase)) {
            if(AppUtils.isLightningTheme() || AppUtils.isExperienceCloud()){ 
               if(String.valueOf(parameterMap.get('objName')).length() != -1 &&  !String.isblank(String.valueOf(parameterMap.get('objName')))){
                    currentPhase = getTabNameFromRecordPage(String.valueOf(parameterMap.get('objName')),'');
                }else if(String.valueOf(parameterMap.get('recordId')).length() != -1 &&  !String.isblank(String.valueOf(parameterMap.get('recordId')))){
                    currentPhase = getTabNameFromRecordPage('',String.valueOf(parameterMap.get('recordId')));
                }
            }else{
                currentPhase = AppUtils.getActiveTabNameFromId(String.valueOf(parameterMap.get('recordId')), activeApp);
            }
        }
        if(String.isEmpty(currentPhase)) {
            currentPhase = String.valueOf(parameterMap.get('cookieTabName'));
        }
        return currentPhase;
    }

    private static Map<String,Object> getLinkParameters() {
        Map<String,Object> parameters = new Map<String,Object>();  
        FrameworkConfig__c fc = FrameworkConfig__c.getValues('UserDepartmentFieldApiName');
        if(fc != null && fc.TextValue__c != null) {
            String query = 'SELECT Id, ' + String.escapeSingleQuotes(fc.TextValue__c) + ' FROM User WHERE Id = ' + String.escapeSingleQuotes(UserInfo.getUserId()); //CRUD/FLS False +ve As per business scenario we can't check for portal/external users
            User user = Database.Query(query,AccessLevel.USER_MODE);//SOQL Injection - False +ve - Dynamic parts of the query string is ecsapeSingleQuotes and id is fetch from Standard Method UserInfo.getUserId()
            if(user.get(fc.TextValue__c) != null) {
                parameters.put('orgId', user.get(fc.TextValue__c));
            } else {
                UserPreferences__c userPrefs = UserPreferences__c.getInstance();
                if(userPrefs != null && userPrefs.OrganizationAccountId__c != null) {
                    parameters.put('orgId', userPrefs.OrganizationAccountId__c);
                }
            }           
        }
        return parameters;
    }

    
    private static Map<String, Object> getActiveComponents(PhaseConfig__c phase) {
        List<ComponentWrapper> activeComponents = new List<ComponentWrapper>();
        Set<string> types  = new Set<string>();

        List<String> componentSequenceList = String.isEmpty(phase.SidebarComponentSequence__c) ? new List<String>() : phase.SidebarComponentSequence__c.split(',');

        for(Integer index = 0; index < componentSequenceList.size(); index++) {
            if(componentSequenceList[index].equalsIgnoreCase('ActivityMenu') && phase.EnableMenu__c) { 
                activeComponents.add(new ComponentWrapper('1', 'activity', phase.AccordionHeader__c, true, index));
                types.add('Activity');
            }
            else if(componentSequenceList[index].equalsIgnoreCase('BI&AnalyticsMenu') && phase.EnableBIAnalytics__c) {
                activeComponents.add(new ComponentWrapper('2', 'analytics', phase.SidebarBIAnalyticsMenuLabel__c, true, index));
                types.add('BI&Analytics');
            }
            else if(componentSequenceList[index].equalsIgnoreCase('CollabMenu') && phase.EnableCollab__c) {
                activeComponents.add(new ComponentWrapper('3', 'collab', phase.SidebarCollabMenuLabel__c, true, index));
            }
            else if(componentSequenceList[index].equalsIgnoreCase('TaskMenu') && phase.EnableSidebarTaskMenu__c) {
                activeComponents.add(new ComponentWrapper('4', 'task', phase.SidebarTaskMenuLabel__c, true, index));
                types.add('Task');
            }
            else if(componentSequenceList[index].equalsIgnoreCase('RecentlyViewed') && phase.EnableRecentlyViewed__c) {
                activeComponents.add(new ComponentWrapper('5', 'recentlyviewed', phase.SidebarRecentlyViewedLabel__c, true, index));
            }
            else if(componentSequenceList[index].equalsIgnoreCase('Search') && phase.EnableSearch__c) {
                activeComponents.add(new ComponentWrapper('6', 'search', phase.SidebarSearchLabel__c, true, index));
            }
            else if(componentSequenceList[index].equalsIgnoreCase('Links') && phase.EnableExternalLinks__c) {
                activeComponents.add(new ComponentWrapper('7', 'externallinks', phase.SidebarExternalLinksLabel__c, true, index));
            }
            else if(componentSequenceList[index].equalsIgnoreCase('TechnicalSupport') && phase.Enable_Technical_Support__c) {
                activeComponents.add(new ComponentWrapper('8', 'technicalsupport', phase.SidebarTechnicalSupportLabel__c, true, index));
            }
        }

        Map<String, Object> returnMap = new Map<String, Object>();
        returnMap.put('components', activeComponents);
        returnMap.put('types', types);
        return returnMap;
    }

    public with sharing class ComponentWrapper {
        @AuraEnabled public String id;
        @AuraEnabled public string name;
        @AuraEnabled public String label;
        @AuraEnabled public boolean isExpanded;
        @AuraEnabled public Integer sequence;

        public ComponentWrapper(String id, string name, string label, boolean isExpanded, Integer sequence) {
            this.id = id;
            this.name = name;
            this.label = label;
            this.isExpanded = isExpanded;
            this.sequence = sequence;
        }
    }

     public with sharing class AccHeaderWrapper {
        @AuraEnabled public string id;
        @AuraEnabled public string name;
        @AuraEnabled public decimal sequence;
        @AuraEnabled public string iconCSS;
        @AuraEnabled public string headerType;
        @AuraEnabled public string groupName;
        @AuraEnabled public boolean isExpanded;
        @AuraEnabled public List<AccSubHeaderWrapper> subHeaders;

        public AccHeaderWrapper(AccordionHeader__c header) {
            this.id = header.Id;
            this.name = header.Name;
            this.sequence = header.Sequence__c;
            this.iconCSS = header.IconCSS__c;
            this.headerType = header.Type__c;
            this.isExpanded = true;
            this.subHeaders = new List<AccSubHeaderWrapper>();
            setGroupName(header.Type__c);
        }

        private void setGroupName(string headerType) {
            if(headerType.equalsIgnoreCase('Activity')) {
                this.groupName = 'activity';
            } else if(headerType.equalsIgnoreCase('BI&Analytics')) {
                this.groupName = 'analytics';
            } else if(headerType.equalsIgnoreCase('Task')) {
                this.groupName = 'task';
            }
        }
    }

    public with sharing class AccSubHeaderWrapper {
        @AuraEnabled public string id;
        @AuraEnabled public string name;
        @AuraEnabled public boolean isHidden;
        @AuraEnabled public String parentId;
        @AuraEnabled public decimal sequence;
        @AuraEnabled public List<AccContentWrapper> contents;

        public AccSubHeaderWrapper(AccordionSubHeader__c subHeader) {
            this.id = subHeader.Id;
            this.name = subHeader.Name;
            this.isHidden = subHeader.Hide__c;
            this.parentId = subHeader.AccordionHeader__c;
            this.sequence = subHeader.Sequence__c;
            this.contents = new List<AccContentWrapper>();
        }
    }

    public with sharing class AccContentWrapper {
        @AuraEnabled public string id;
        @AuraEnabled public string name;
        @AuraEnabled public decimal sequence;
        @AuraEnabled public string url;
        @AuraEnabled public boolean isNewWindow;
        @AuraEnabled public string tableName;
        @AuraEnabled public string RecordType;
        @AuraEnabled public string FlexTableParameters;
        @AuraEnabled public string lightningUrl;

        public AccContentWrapper(AccordionContent__c content, Map<String, Object> linkParamMap) {
            this.id = content.Id;
            this.name = content.Name;
            this.sequence = content.Sequence__c;
            this.isNewWindow = content.OpenInNewWindow__c;
            this.tableName = content.DataTableConfig__r.Name == null ? content.FlexGridConfig__r.Name : content.DataTableConfig__r.Name;
            this.RecordType = content.RecordType.Name;
            this.FlexTableParameters =content.FlexTableParameters__c;
            this.lightningUrl =content.Target_Lightning_URL__c;
             if(!AppUtils.isLightningTheme() || !AppUtils.isExperienceCloud()){ 
                setContentURL(content, linkParamMap);
            }
        }

        private void setContentURL(AccordionContent__c content, Map<String, Object> linkParamMap) {
            //change to record type developer name if possible
            String link;
            if(content.RecordType.Name == 'Flex Table' || content.RecordType.Name == 'Task Based Flex Table') {
                link  = '/apex/FlexTableView?flexTableName=' + content.DataTableConfig__r.Name;
                link += '&pageTitle=' + content.DataTableConfig__r.Header__c;
                link += '&flexTableHeader=' + content.FlexTableHeader__c;
                link += '&RecordType=' + content.RecordType.Name;
                if(String.isNotEmpty(content.FlexTableParameters__c)) {
                    link += '&' + content.FlexTableParameters__c.replace(',','&');
                }
            } else if(content.RecordType.Name == 'Flex Table Enhanced') {
                link  = '/apex/FlexTableView?flexTableName=' + content.DataTableConfig__r.Name;
                link += '&pageTitle=' + content.DataTableConfig__r.Header__c;
                link += '&flexTableHeader=' + content.FlexTableHeader__c;
                link += '&RecordType=' + content.RecordType.Name;
                if(String.isNotEmpty(content.FlexTableParameters__c)) {
                    link += '&' + content.FlexTableParameters__c.replace(',','&');
                }
            }else if(content.RecordType.Name == 'Flex Grid Enhanced') {
                link  = '/apex/FlexTableView?flexTableName=' + content.FlexGridConfig__r.Name;
                link += '&pageTitle=' + content.DataTableConfig__r.Header__c;
                link += '&flexTableHeader=' + content.FlexTableHeader__c;
                link += '&RecordType=' + content.RecordType.Name;
                if(String.isNotEmpty(content.FlexTableParameters__c)) {
                    link += '&' + content.FlexTableParameters__c.replace(',','&');
                }
            }if(content.Link__c != '' && content.Link__c != null) {
                link = content.Link__c;
                for(String param : linkParamMap.keyset()) {
                    link = link.replace('{!'+ param +'}', (String)linkParamMap.get(param));
                }
            }
            this.url = link;
        }
    }
    
     @TestVisible 
     public with sharing class SideBarWrapper{
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
         

        public SideBarWrapper(list<sObject> sObjectList, Map<String, String> fieldLableMap,Map<String, String> fieldDataTypeMap,Map<String, Integer> scaleMap,String label){
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