/*
This class has methods to test FlexTableCtrl.
**********************************************************
Audit History
**********************************************************
2018-10-31  Sonali Bajirao Jadhav     Created
**********************************************************  
*/
@isTest
private with sharing class TestFlexTableCtrl{
    
    static DataTableConfig__c dataTableConfig; 
    static DataTableConfig__c parentDataTableConfig;
    static DataTableConfig__c childDataTableConfig;
    static DataTableAction__c dataTableAction;
    static FlexGridConfig__c fgc ;
    static Map<String, List<String>> recordsMap ;
    static Map < String, Object > paramMap;
    static PageBlockConfig__c pbc ;
    
    ///static SearchConfig__c searchConfig;
    static PhaseConfig__c phase;
    ///public static String sObjName;
    public static Map<String,Object> keyValueMap1;
    public static Map<String,Object> paraMap;
    public static Map<String,Object> result;
    public static FlexTableCtrl fc;
    public static  Map<String,String> keyValueMapp ;
    public static  SampleObject11__c ann;
    public static SObjectConfig__c SObjectConfig;
    public static  SObjectPhaseConfig__c SObjectPhase;
    ///public static string pbid;
    public static string keyValueMap;
    static Account accobj2;
    static DataTableDetailConfig__c DataTableDetailConfig;
    
    
    //TODO:Add assert statements
    
    public static void setupData(){        
        ann=TestHelper.getSampleObject1(true);
        
        phase = TestHelper.getPhase(true);
        dataTableConfig = TestHelper.getFlexDataTableConfigForReport(false);
        dataTableConfig.Description__c='testDescription';
        dataTableConfig.isActive__C=false;
        dataTableConfig.SObject__c=AppUtils.getNamespacePrefix()+'SampleObject11__c';
        dataTableConfig.ReadOnlyFields__c='id';
        insert dataTableConfig;
        system.assert(dataTableConfig!=null);
       
        SobjectConfig__c SObjectConfig = new SobjectConfig__c(name=AppUtils.getNamespacePrefix()+'SampleObject11__c', HistoryObjects__c=AppUtils.getNamespacePrefix()+'SampleObject11__c');
        insert SObjectConfig;
        system.assert(SObjectConfig!=null);

        SObjectPhase=TestHelper.getSObjectPhaseConfig(phase.Id,sobjectConfig.Id,  false);
        SObjectPhase.GlobalSearchFlexTableConfig__c=dataTableConfig.id;
        insert SObjectPhase;
        
        PageLayoutConfig__c pc = TestHelper.getPageLayoutConfig(false);
        pc.Description__c='TestDescription';
        insert pc;
        
        TabConfig__c tc = TestHelper.getTabConfig(pc.Id, true);
        
        DataTableDetailConfig = new DataTableDetailConfig__c();
        DataTableDetailConfig.FlexTableConfig__c=dataTableConfig.Id;
        DataTableDetailConfig.DisplayFields__c='Status__c';
        DataTableDetailConfig.FieldWidth__c=23.0;
        DataTableDetailConfig.FieldLabelOverride__c='test';
        insert DataTableDetailConfig;
        
        pbc = TestHelper.getPageBlockConfig(tc.Id, false);
        pbc.isActive__c = true;
        pbc.FlexTableName__c=dataTableConfig.id;
        insert pbc;
        
        PageReference PageRef = Page.NoteAdd;
        Test.setCurrentPage(PageRef);
        Apexpages.currentPage().getParameters().put('flexTableName','test');
        ApexPages.currentPage().getParameters().put('url', '/apex/NoteAdd?Host=FundingOpportunity');
        
        FlexTableCtrl.refreshTables('Test View Layout');
        ApexPages.Message warnMsg = new ApexPages.Message(ApexPages.Severity.Warning,'warn:warn,warn','warn:warn,warn FIELD_CUSTOM_VALIDATION_EXCEPTION.');
        ApexPages.Message warnMsg1 = new ApexPages.Message(ApexPages.Severity.Warning,'warn1:warn1,warn','warn1:warn1,warn FIELD_CUSTOM_VALIDATION_EXCEPTION.');
        ApexPages.addMessage(warnMsg);
        ApexPages.addMessage(warnMsg1);
        
        keyValueMapp = new Map<String,String>();  
        keyValueMapp.put('name','test'); 
        keyValueMapp.put('istest','true');  
        
        SobjectActionConfig__c SobjectActionConfig=new SobjectActionConfig__c();
        SobjectActionConfig.Name = AppUtils.getNamespacePrefix() + 'SampleObject11__c';
        SobjectActionConfig.SObjectConfig__c = SObjectConfig.Id;
        SobjectActionConfig.HideDecisionField__c='Status__c';
        insert SobjectActionConfig;
        
        dataTableAction = TestHelper.getDataTableAction(dataTableConfig.Id,false);
        dataTableAction.Location__c='top';
        dataTableAction.HideDecisionField__c='Status__c';
        //dataTableAction.HideExpressionJSON__c ='{"LogicalOperator":"AND","Conditions":[{"LOperand":{"Type":"Field","Value":"Status__c"},"Operator":"=","ROperand":{"Type":"Freetext","Value":"Created","Values":[]}}],"Groups":[],"ExpressionObject":"Program__c"}'; 

        dataTableAction.SobjectActionConfig__c=SobjectActionConfig.id;
        dataTableAction.AnonymousExecuteScript__c = 'test';
        insert dataTableAction;
        Map<String,String> mapRecordIds = new Map<String,String>();
        mapRecordIds.put('buttonId',dataTableAction.Id);
        FlexTableCtrl.executeAnonymous(mapRecordIds);
        UserPreferences__c userPref = TestHelper.getUserPreference(false,'ReportsFolderName__c','State_as_Grantor');
        userPref.SetupOwnerId = UserInfo.getProfileId();
        userPref.id = null;
        insert userPref; 
        
        CustomAppConfig__c cac = TestHelper.getCustomAppConfig(true);
        
        keyValueMap1 = new Map<String,Object>();  
        keyValueMap1.put('parentRecordIdOfFlexTable',ann.id); 
        string dataTableConfigid= dataTableConfig.id;
        keyValueMap1.put('flexTableId','TestDataTable'); 
        
        paraMap = new Map<String,Object>(); 
        paraMap.put('FieldApiName', 'Name');
        paraMap.put('ObjectName', AppUtils.getNamespacePrefix()+'SampleObject11__c');
        paraMap.put('SearchCriteria', 'ABC');
        paraMap.put('ExistingFilterClause', 'Name=\'ABC\'');
        paraMap.put('newFilterClause', 'Name=\'ABC\'');
        paraMap.put('Counter',null);
        paraMap.put('lastSearchedTerm', 'Name=\'dd\'');
        
        parentDataTableConfig = new DataTableConfig__c();
        parentDataTableConfig.SObject__c='Account';
        parentDataTableConfig.Name = 'TestParentDataTable';
        parentDataTableConfig.FieldNames__c = 'OwnerId, Owner.FirstName, CreatedById,LastModifiedById,ParentId, Type ';  
        parentDataTableConfig.FilterCriteria__c = 'ParentId = null';
        parentDataTableConfig.Description__c='TestDescription';  
        //parentDataTableConfig.ParentTargetLookupField__c='ParentId';
        parentDataTableConfig.ReadOnlyFields__c='id';
        insert parentDataTableConfig;
        
        childDataTableConfig = new DataTableConfig__c();
        childDataTableConfig.SObject__c='Account';  
        childDataTableConfig.Name = 'TestChildDataTable';
        childDataTableConfig.FieldNames__c = 'Id, Name ,Owner.FirstName';  
        childDataTableConfig.FilterCriteria__c = 'ParentId = \'parentId\'';
        childDataTableConfig.Description__c='TestDescription';  
        childDataTableConfig.ReadOnlyFields__c='id';
        childDataTableConfig.RequiredFields__c = AppUtils.getNamespacePrefix() +'SampleObject11__c';           
        insert childDataTableConfig;
        
        fgc = new FlexGridConfig__c();
        fgc.Name = 'EditableGrid';      
        fgc.ParentFlexTable__c = parentDataTableConfig.Id;
        fgc.Child1FlexTable__c = childDataTableConfig.Id; 
        fgc.Child1RelationshipName__c='SampleObject11__c';
        insert fgc; 
        
        Map<String,Object> keyValueMap1 = new Map<String,Object>();         
        List<String> nameList = new List<String> {'test1','test2'}; 
        keyValueMap1.put('nameList',nameList); 
        
        paramMap = new Map < String, Object >();
        paramMap.put('queryColumns','Name');
        paramMap.put('hideDecisionFields','Id');
        paramMap.put('objectName', AppUtils.getNamespacePrefix()+'SampleObject11__c');
        paramMap.put('pageNumber',1);
        paramMap.put('pageSize',2);
        paramMap.put('sortFieldName','Name');
        paramMap.put('sortDirection','');
        //paramMap.put('searchTerm','Name=\'ABC\'');
        paramMap.put('newFilterClause','');
        paramMap.put('isSOSL',false);
        paramMap.put('stickySearchTerm','PG-601-0001');
        paramMap.put('flexTableId',dataTableConfig.id);
        paramMap.put('isSelectionChagned',true);
        paramMap.put('isHistory',false);
        paramMap.put('isFilterCriteriaChanged',true);
        paramMap.put('updatedFlexHeader','{"key1":"value1"}');
        paramMap.put('flexKeyValueMap','{"key1":"value1"}'); 
        paramMap.put('mergeFields','');
        paramMap.put('SearchTerm','ALL');
        paramMap.put('searchAllField',false);
        
        Account accobj1 = new Account();
        accobj1.Name ='Test34';
        insert accobj1;
        
        accobj2 = new Account();
        accobj2.Name ='Test678';
        insert accobj2;
        system.assert(accobj2.id!=NULL);
        
        contact con = TestHelper.getContact(false);
        con.AccountId= accobj2.id;
        insert con;
        
        recordsMap = new Map<String, List<String>>();
        List<String> AccountList = new List<String>();
        AccountList.add(accobj1.id);
        AccountList.add(accobj2.id);
        recordsMap.put('Account',AccountList);
        
        FlexTableFilterListViewConfig__c filterListView = new FlexTableFilterListViewConfig__c();
        filterListView.FlexTableConfig__c = dataTableConfig.id;
        filterListView.Label__c = '{"key1":"value1"}';
        filterListView.FilterClause__c = 'Status__c != NULL';
        filterListView.IsActive__c = true;
        filterListView.IsDefault__c=true;
        filterListView.IsMasterView__c=true;
        insert filterListView;
        
        fc = new FlexTableCtrl();
        Integer val=fc.timeOffset;
        fc.parentRecordId = ann.id;
        fc.dataTableConfigName='sampleDataTable';
        fc.searchTerm='test';
        fc.objectName='SampleObject11__c';
        fc.phase=phase.name;
        fc.sObjectNameForFieldHistory='test';////not used anywhere
        fc.isPreviewMode=false;
        fc.isFieldHistory=true;
        fc.flexTablePropInfo  ='test'; 
        fc.flexTableHeaderTitle = 'test'; 
        fc.flexHeaderDescription ='test'; 
        fc.FlexTableFieldAPIs ='test'; 
        fc.govGrantPleaseWaitIconURL='test';
		fc.currentPageURL ='www.sample.com';
        FlexTableCtrl.HistoryClass historycls= new FlexTableCtrl.HistoryClass();
        historycls.Field='Status__c'; 
        historycls.OldValue='test1'; 
        historycls.NewValue='test2'; 
        historycls.CreatedBy=accobj2;
        historycls.Parent=keyValueMapp;
        historycls.CreatedDate =DateTime.now();
        
    }
    
    @isTest
    public static void fetchInitialDataTestForReport(){
        User u = TestHelper.getAdminUser(true);
        setupData();
        System.runAs(u) {
            Test.startTest();  
            result = FlexTableCtrl.fetchInitialDataWithFilter('TestDataTable',JSON.serialize(keyValueMap1),null,false,null,paraMap);
            keyValueMap='id!=null';
            Map<String,Object> result3 = FlexTableCtrl.fetchInitialDataWithFilterEnhanced('TestDataTable','',false,JSON.serialize(keyValueMap1),null,false,null,paraMap);
            Map<String,Object> result4 = FlexTableCtrl.fetchListInformation('TestDataTable');
           
            string  flextableId = (string)keyValueMap1.get('flexTableId');
            
            FlexTableCtrl.markFlexTableAsActive(keyValueMap1);
            
            keyValueMap1.put('parentRecordIdOfFlexTable',ann.id); 
            Map<String,Object> result = FlexTableCtrl.fetchGridType('sampleDataTable',JSON.serialize(keyValueMap1),null,false);        
            
            keyValueMap1.put('istest', '15DIGITID({!istest})');
            String objectName=AppUtils.getNamespacePrefix()+'SampleObject11__c';
            Map<String,Object> result_1 = FlexTableCtrl.fetchInitialSearchData('test',objectName,phase.Name,JSON.serialize(keyValueMap1),null,false);
            Map<String,Object> result_2 = FlexTableCtrl.fetchStickySearchSuggestionsData(JSON.serialize(paraMap));
            
            String rows1 = '{"'+AppUtils.getNamespacePrefix()+'SampleObject11__c":[{"Id":"'+ann.id+'","Name":"test"}]}';
            TestHelper.createDisableRecordLocking();           
           // Map<String,Object> result_3 = FlexTableCtrl.updateRows(rows1,rows1);
            
            FlexTableCtrl.fetchLookupData('Name','DataTableConfig__c','Name');
            FlexTableCtrl.fetchLookupData('Name','DataTableConfig__c','Name', '');
            
            FlexTableCtrl.fetchAutoSuggestData('Name',objectName,'Test','');
            FlexTableCtrl.fetchAutoSuggestData('Name',objectName,'','','');
            FlexTableCtrl.fetchAutoSuggestData('Name',DataTableDetailConfig.id,objectName,'','Id!=null','{"requiredField": true,"fieldName": "Description__c","fieldLabel": "gsdaj"}');
            
            Map<String,Object> result_5 = fc.fetchN2GDataExport(fgc.Name,JSON.serialize(keyValueMapp),JSON.serialize(keyValueMap1),false);  
            Map<String,Object> result_4 = FlexTableCtrl.fetchN2GData(fgc.Name,JSON.serialize(keyValueMapp),JSON.serialize(keyValueMap1),false);        
           Test.stopTest();
        }
    }
    
    @isTest
    public static void fetchInitialDataTest(){
        User u = TestHelper.getAdminUser(true);
        setupData();
        System.runAs(u) {
            Test.startTest(); 
            childDataTableConfig.FilterCriteria__c = ''; 
            update childDataTableConfig;
            fgc.Child1RelationshipName__c='Contacts';
            update fgc;
            Map<String,Object> result5 = FlexTableCtrl.fetchEditableGridData(fgc.Name,JSON.serialize(keyValueMapp),JSON.serialize(keyValueMap1),true);   
            
            FlexTableCtrl.getPageRecordsForFlexGrid('Name','','',AppUtils.getNamespacePrefix()+'SampleObject11__c','Name=\'test\'','Name','DESC',1,2,false);
            FlexTableCtrl.getPageRecordsForN2G('Name','','',AppUtils.getNamespacePrefix()+'SampleObject11__c','Name=\'test\'','Name','DESC',1,2,false,'','');
            FlexTableCtrl.getPageRecordsForN2GNew('Name','','',AppUtils.getNamespacePrefix()+'SampleObject11__c','Name=\'test\'','Name','DESC',1,2,false,'','','');
            FlexTableCtrl.getPageRecordsForN2GNew2('Name','','',AppUtils.getNamespacePrefix()+'SampleObject11__c','Name=\'test\'','Name','DESC',1,2,false,'Account','contact','','AccountId');
            
            String keyValMap = '{"isTest":"true","name":"test"}';
            DataTableConfig__c dataTableConfig1 = TestHelper.getFlexDataTableHistoryConfig(false);
            dataTableConfig1.name='test';
            insert dataTableConfig1;
            
            SampleObject11__c sampleObj = TestHelper.getSampleObject1(false);
            sampleObj.Status__c = 'test';
            insert sampleObj;
            sampleObj.Status__c = 'test1';
            update sampleObj;
            sampleObj.Status__c = 'test2';
            update sampleObj;
            
            Map<String,Object> result_6 = FlexTableCtrl.fetchInitialHistoryData(dataTableConfig1.Name, AppUtils.getNamespacePrefix()+'SampleObject11__c',AppUtils.getNamespacePrefix()+'SampleObject11__c',true,accobj2.id,JSON.serialize(keyValueMap1),keyValMap,false);
            
            dataTableAction.Location__c='row';
            update dataTableAction;
            Map<String,Object> result_7 = FlexTableCtrl.fetchPreviewData(dataTableConfig.Name,true);
            FlexTableCtrl.getPageRecords('name','','Account',null,null,'','','Trial','',true);
            
            Map<String,Object> result_8 = FlexTableCtrl.getPageRecordsWithMergeFields('name','',AppUtils.getNamespacePrefix()+'SampleObject11__c',1,2,'Name','DESC','Name','Name=\'{!test}\' and OwnerId=\'{!User.Id}\'',true,JSON.serialize(keyValueMapp));
            paramMap.put('user',u.id);
            Map<String,Object> result_9 = FlexTableCtrl.updateFlexTableWithStickySearch(paramMap);
            
            Map<String, Object> result_10 = fc.handleSOSLStandardListControllers('Name','','Account',5,30,'Name','','Trial','');
            keyValueMapp.put('buttonId',dataTableAction.id);
            System.assertNotEquals(null,result_10);
            //FlexTableCtrl.executeAnonymous(keyValueMapp);
            Test.stopTest();
        }
    }
    
    @isTest
    public static void fetchDataTest(){
        User u = TestHelper.getAdminUser(true);
        setupData();
        System.runAs(u) {
            Test.startTest(); 
            String objectNameWithPrefix = AppUtils.getNamespacePrefix()+'SampleObject11__c';
            Map<String,Object> result_11 = FlexTableCtrl.deleteRecord(objectNameWithPrefix ,ann.id);
            Map<String,Object> deletedRecords = FlexTableCtrl.deleteRecords(recordsMap);
            Map<String,Object> result_12 = FlexTableCtrl.executeClass('ApplyStandardPackage',keyValueMapp,keyValueMapp,dataTableAction,dataTableConfig.Name,'https://na11.salesforce.com/01pG00000048sdI/e?retURL=%2Fsetup%2Fbuild%2FviewApexClass.apexp%3Fid%3D01pG00000048sdI%26id%3D01pG00000048sdI');            
            paramMap.put('PageSize',2);
            paramMap.put('PageNumber',2);
            Map<String,Object> result_13= FlexTableCtrl.paintLookupFlexTable('Id, Name, Owner.FirstName ,CreatedById,LastModifiedById,ParentId, Type' , 'Account', 'Id != NULL' , paramMap);
            fc.keyValueMap='{"requiredField": true,"fieldName": "Description__c","fieldLabel": "gsdaj"}';
            fc.pbId=pbc.id;
            String resultstr= fc.getKeyValMapStr();
            List<Id> recordIdSet = new List<Id>();
            
            
            Account accobj3 = TestHelper.getAccount(true);
            recordIdSet.add(accobj3.id);
                
            FlexTableCtrl.getAccountHierarchy(accobj3.id);
            FlexTableCtrl.getAccountHierarchy(accobj3.id, null);
            FlexTableCtrl.inlineEditRecordIds(accobj3.id);
            FlexTableCtrl.setInlineEditRecordIds(recordIdSet,'Account');
            FlexTableCtrl.getLocaleCurrSymbol();
            System.assertNotEquals(null,accobj3);
            Test.stopTest();
        }
    }
}